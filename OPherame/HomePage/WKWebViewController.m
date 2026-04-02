//
//  WKWebViewController.m
//  OPherame
//
//  Created by todesk on 2025/7/1.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "HoPerController.h"

#import <MessageUI/MessageUI.h>

#import <StoreKit/StoreKit.h>
@interface WKWebViewController () <WKNavigationDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) NSString *startTime;
@end

@implementation WKWebViewController

- (instancetype)initWithURLString:(NSString *)urlString {
    self = [super init];
    if (self) {
        _urlString = [urlString copy];
        _themeColor = [UIColor systemBlueColor]; // 默认主题色
    }
    return self;
}

- (UIImage *)convertWhiteToBlackByPixel:(UIImage *)originalImage {
    CGImageRef imageRef = originalImage.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    unsigned char *data = CGBitmapContextGetData(context);
    
    if (data != NULL) {
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int byteIndex = (bytesPerRow * y) + x * 4;
                
                // 获取当前像素的RGBA值
                unsigned char red = data[byteIndex];
                unsigned char green = data[byteIndex + 1];
                unsigned char blue = data[byteIndex + 2];
                unsigned char alpha = data[byteIndex + 3];
                
                // 如果是白色或接近白色，则改为黑色
                if (red > 200 && green > 200 && blue > 200) {
                    data[byteIndex] = 0;     // R
                    data[byteIndex + 1] = 0; // G
                    data[byteIndex + 2] = 0; // B
                    // Alpha保持不变
                }
            }
        }
    }
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *resultImage = [UIImage imageWithCGImage:newImageRef];
    
    CGContextRelease(context);
    CGImageRelease(newImageRef);
    
    return resultImage;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.customTitleColor = [UIColor blackColor];
//    self.customBackButtonImage = [UIImage imageNamed:@"norevebn"];//
    [self setupWebView];
    [self setupProgressView];
//    [self setupNavigationItems];
    [self loadRequest];
    
    self.startTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
       
    [button setImage:[[UIImage imageNamed:@"rtunm"]imageWithTintColor:[UIColor blackColor] renderingMode:UIImageRenderingModeAlwaysOriginal]
           forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, MAX(button.bounds.size.width, 44), 44);
    [button addTarget:self action:@selector(goBackAction)
                       forControlEvents:UIControlEventTouchUpInside];
       
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"norevebn"] style:(UIBarButtonItemStyleDone) target:self action:@selector(fdff)];
}

- (void)setupWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 注入 JavaScript 桥接
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    [userController addScriptMessageHandler:self name:@"mustardPe"];
    [userController addScriptMessageHandler:self name:@"queenElep"];
    [userController addScriptMessageHandler:self name:@"cashewXyl"];
    [userController addScriptMessageHandler:self name:@"mangoPizz"];
    
    config.userContentController = userController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, [self navigationBarHeight]+2, self.view.width, self.view.height-[self navigationBarHeight]-2) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
    
    // 监听标题变化
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    // 监听加载进度
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupProgressView {
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.frame = CGRectMake(0, [self navigationBarHeight], self.view.bounds.size.width, 2);
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = self.themeColor;
    [self.view addSubview:self.progressView];
}

//- (void)setupNavigationItems {
//    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"]
//                                                       style:UIBarButtonItemStylePlain
//                                                      target:self
//                                                      action:@selector(goBackAction)];
//    
//    self.closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
//                                                        style:UIBarButtonItemStylePlain
//                                                       target:self
//                                                       action:@selector(closeAction)];
//    
//    self.navigationItem.leftBarButtonItem = self.backButton;
//}

- (void)loadRequest {
    if (!self.urlString) {
        NSLog(@"URL字符串为空");
        return;
    }
    
    // 处理URL字符串（添加http前缀如果不存在）
    NSString *urlString = self.urlString;
    if (![urlString hasPrefix:@"http://"] && ![urlString hasPrefix:@"https://"]) {
        urlString = [NSString stringWithFormat:@"https://%@", urlString];
    }
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    //[NSURL URLWithString:@"http://8.220.140.188:8083/test"];
    if (!url) {
        NSLog(@"URL格式错误: %@", urlString);
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - Actions

- (void)goBackAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {

        if([self.urlString containsString:@"flipped"]){
            [self popToSpecificViewController:[HoPerController class]];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.webView.estimatedProgress >= 1.0) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                self.progressView.progress = 0;
                self.progressView.alpha = 1;
            }];
        }
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self updateNavigationItems];
    
}

- (void)updateNavigationItems {
    if (self.webView.canGoBack) {
        NSMutableArray *items = [NSMutableArray arrayWithObjects:self.backButton, self.closeButton, nil];
        self.navigationItem.leftBarButtonItems = items;
    } else {
        if (self.backButton) {
            self.navigationItem.leftBarButtonItems = @[self.backButton];
        }
        
    }
}



// 5. 显示评分弹窗
- (void)showRatingAlert {
    // 跳转到App Store评分页面
    NSString *appID = @"YOUR_APP_ID";
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"mustardPe"]) {
        // 处理来自网页的按钮点击事件
        NSLog(@"收到按钮点击事件: %@", message.body);
        
        // 在这里执行原生操作，如发送邮件
        if ([message.body isKindOfClass:[NSString class]]) {
            [self sendEmailTo:message.body];
        }
    }else if ([message.name isEqualToString:@"cashewXyl"]){
        //开始时间
        NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
        mutbdic[@"moneys"] = self.startTime;
        mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
        [self locaRadiatingPermis:mutbdic];
    }else if ([message.name isEqualToString:@"queenElep"]){
        [SKStoreReviewController requestReview];
    }else if ([message.name isEqualToString:@"mangoPizz"]){
        NSLog(@"收到按钮点击事件: %@", message.body);
        
        if ([message.body rangeOfString:@"mangoIrisZuc"].location != NSNotFound) {
            //身份验证
            FrequqesController *controller = [[FrequqesController alloc]init];
            
            controller.harukos = [message.body componentsSeparatedByString:@"?"][1];
            [self.navigationController pushViewController:controller animated:YES];
        }else if ([message.body rangeOfString:@"rabbitKaleOn"].location != NSNotFound){
            //首页
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

- (NSDictionary *)dictionaryFromEmailString:(NSString *)inputString {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    // 去除可能的前后空格
    NSString *trimmedString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 分割键值对
    NSArray *components = [trimmedString componentsSeparatedByString:@":"];
    
    if (components.count >= 2) {
        NSString *key = [components[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *value = [components[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // 验证电子邮件格式
        if ([self isValidEmail:value]) {
            [result setObject:value forKey:key];
        }
    }
    
    return [result copy];
}

// 验证电子邮件格式
- (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


// 发送邮件方法
- (void)sendEmailTo:(NSString *)emailAddress {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        
        // 设置收件人
        [mailVC setToRecipients:@[[self dictionaryFromEmailString:emailAddress][@"email"]]];
//        if (mailVC.toRecipients.count == 0) {
//                NSLog(@"收件人设置失败，请检查邮箱格式");
//            }
        // 设置邮件主题（可选）
//        [mailVC setSubject:@"联系支持"];
        
        // 从 Info.plist 中获取应用显示名称（用户在Springboard看到的名字）
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

        // 如果没有设置CFBundleDisplayName，则获取CFBundleName
        if (!appName) {
            appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        }
        
        // 设置邮件正文（可选）
        NSString *messageBody = [NSString stringWithFormat:@"APP:%@\nPhone:%@\n",appName,[[NSUserDefaults standardUserDefaults] objectForKey:@"ZHpro"]];
        [mailVC setMessageBody:messageBody isHTML:NO];
        
        // 弹出邮件发送界面
        [self presentViewController:mailVC animated:YES completion:nil];
    } else {
        // 设备未配置邮件账户
        [self showMailUnavailableAlert];
    }
}

// 邮件发送结果回调
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"邮件已发送");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件已保存");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"邮件已取消");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败: %@", error.localizedDescription);
            break;
    }
}

// 显示无法发送邮件的提示
- (void)showMailUnavailableAlert {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"无法发送邮件"
        message:@"您的设备没有配置邮件账户，请先设置邮件账户"
        preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
        actionWithTitle:@"去设置"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                             options:@{}
                                   completionHandler:nil];
        }]];
    
    [alert addAction:[UIAlertAction
        actionWithTitle:@"取消"
        style:UIAlertActionStyleCancel
        handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Helper

- (CGFloat)navigationBarHeight {
    return self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"mustardPe"];
}


-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
//    @"bill": @"8",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        NSDictionary *medis = @{
            @"centimetre": self.harukos?:@"",   // 产品ID
            @"bill": @"10",
            @"flipped": @"",            // 用户申贷全局订单号，不用管, 传空即可
            @"splitting": [BeiMInfoUtil getOrCreateIDFV], // idfv
            @"tight": [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString]?:@"",             // idfa
            @"stroke": lngcoo?:@"",     // 经度
            @"surveying": lat?:@"",        // 纬度
            @"skills": [RandomStringGenerator randomlyCallMethod]         // 混淆字段
        };
        
        [permis addEntriesFromDictionary:medis];
        [[NetworkManager sharedManager]googleMarketPOST:@"/radiating/winds" parameters:permis headers:nil progress:nil success:^(id  _Nullable responseObject) {
            if([responseObject[@"heavy"] isEqualToString:@"0"]){
                
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    });

}
@end
