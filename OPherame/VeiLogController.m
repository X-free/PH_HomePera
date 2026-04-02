//
//  VeiLogController.m
//  OPherame
//
//  Created by todesk on 2025/6/11.
//

#import "VeiLogController.h"
#import "HoPerController.h"

#import "FBSDKCoreKit/FBSDKCoreKit.h"
@interface VeiLogController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *cellPhoneLabel;
@property (nonatomic, strong) UIView *phoneInputContainer;
@property (nonatomic, strong) UILabel *prefixLabel;
@property (nonatomic, strong) UILabel *verificationCodeLabel;
@property (nonatomic, strong) UIView *codeInputContainer;
@property (nonatomic, strong) UILabel *agreementTextLabel;
@property (nonatomic, strong) UIButton *checkboxButton;

@end

@implementation VeiLogController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    

}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self StartInitialization];
    

    [self setupUI];
    
}





- (void)setupUI {
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"banbb"];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundImageView];
    
    
    UIImageView *containerView = [[UIImageView alloc] initWithFrame:CGRectMake(14, [UIView navigationBarHeight]+38.5, self.view.width-28, (self.view.width-28) * 860/708.0)];
    containerView.image = [UIImage imageNamed:@"bukamm"];
    containerView.userInteractionEnabled = YES;
    [self.view addSubview:containerView];
    
    // Cell phone 标签
    UILabel *cellPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 55.5, 150, 23)];
    cellPhoneLabel.text = @"Phone number";
    cellPhoneLabel.font = [UIFont boldSystemFontOfSize:15];
    cellPhoneLabel.textColor = [UIColor darkTextColor];
    [containerView addSubview:cellPhoneLabel];
    
    UIView *phoneInputContainer = [[UIView alloc] initWithFrame:CGRectMake(36, cellPhoneLabel.bottom+14, containerView.width-36*2, 52)];
    [containerView addSubview:phoneInputContainer];
    
    UIImageView *bacImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buka"]];
    bacImg.frame = phoneInputContainer.bounds;
    bacImg.userInteractionEnabled = YES;
    [phoneInputContainer addSubview:bacImg];
    
    UIButton *prefixImg = [[UIButton alloc] initWithFrame:CGRectMake(4, 5.5, 57, 43)];
    [prefixImg setTitle:@"+63" forState:(UIControlStateNormal)];
    [prefixImg setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [prefixImg setBackgroundImage:[UIImage imageNamed:@"bukat"] forState:(UIControlStateNormal)];
    [phoneInputContainer addSubview:prefixImg];
    
    _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(prefixImg.right+14, 13.5, phoneInputContainer.width-prefixImg.right-28, 24.5)];
    // 设置placeholder颜色为白色
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]
        initWithString:@"Phone number"
        attributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16] // 可选：同时设置字体
        }];
        
    _phoneNumberField.attributedPlaceholder = attributedPlaceholder;
    _phoneNumberField.textColor = [UIColor whiteColor];
    _phoneNumberField.backgroundColor = [UIColor clearColor];
    _phoneNumberField.borderStyle = UITextBorderStyleNone;
    _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    _phoneNumberField.tintColor = [UIColor whiteColor];
    [_phoneNumberField becomeFirstResponder];
    _phoneNumberField.delegate = self;
    [phoneInputContainer addSubview:_phoneNumberField];
    
    _phoneNumberField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZHpro"];
    
    // Verification Code 标签
    UILabel *verificationCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, phoneInputContainer.bottom+31.5, 130, 23)];
    verificationCodeLabel.text = @"Verification code";
    verificationCodeLabel.font = [UIFont boldSystemFontOfSize:15];
    verificationCodeLabel.textColor = [UIColor darkTextColor];
    [containerView addSubview:verificationCodeLabel];
    
    
    phoneInputContainer = [[UIView alloc] initWithFrame:CGRectMake(36, verificationCodeLabel.bottom+14, containerView.width-36*2, 52)];
    [containerView addSubview:phoneInputContainer];
    
    bacImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buka"]];
    bacImg.frame = phoneInputContainer.bounds;
    bacImg.userInteractionEnabled = YES;
    [phoneInputContainer addSubview:bacImg];
    
    _verificationCodeField = [[UITextField alloc] initWithFrame:CGRectMake(20, 13.5, phoneInputContainer.width-40, 24.5)];
    
    // 设置placeholder颜色为白色
    attributedPlaceholder = [[NSAttributedString alloc]
        initWithString:@"Verification code"
        attributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont systemFontOfSize:16] // 可选：同时设置字体
        }];
    _verificationCodeField.attributedPlaceholder = attributedPlaceholder;
    _verificationCodeField.textColor = [UIColor whiteColor];
    _verificationCodeField.backgroundColor = [UIColor clearColor];
    _verificationCodeField.borderStyle = UITextBorderStyleNone;
    _verificationCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCodeField.tintColor = [UIColor whiteColor];
    _verificationCodeField.delegate = self;
    [phoneInputContainer addSubview:_verificationCodeField];
    
    // 获取验证码按钮
    _acquireButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _acquireButton.frame = CGRectMake(phoneInputContainer.width-88, (phoneInputContainer.height - 34)/2.0, 82, 34);
    [_acquireButton setTitle:@"Send code" forState:UIControlStateNormal];
    [_acquireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _acquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _acquireButton.layer.cornerRadius = 11;
    _acquireButton.backgroundColor = [UIColor colorWithRed:213/255.0 green:234/255.0 blue:1 alpha:0.2];
    [_acquireButton addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [phoneInputContainer addSubview:_acquireButton];
    
    CGFloat ratio = (UIScreen.mainScreen.bounds.size.width - 30)/345.0;

    // 创建容器视图
    UIView *agreementView = [[UIView alloc] initWithFrame:CGRectMake(20 * ratio, phoneInputContainer.bottom+33.5, self.view.bounds.size.width - 40 * ratio, 30)];
    [containerView addSubview:agreementView];
    [self setupAgreementView:agreementView];
    
    
    // 创建提示标签
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(29, containerView.height-78, containerView.bounds.size.width - 58, 60)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:12];
    
    // 完整提示文本
//    NSString *fullText = @"*Your verification code is valid for 30 minutes. Confirm that the verification code is self operated and cannot be shared with others.";
//    
//    // 创建可变属性字符串
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText];
//    
//    // 设置整体文本颜色为灰色 (#878787)
//    [attributedText addAttribute:NSForegroundColorAttributeName
//                          value:[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0]
//                          range:NSMakeRange(0, fullText.length)];
//    
//    // 查找所有星号(*)的位置
//    NSMutableArray<NSValue *> *asteriskRanges = [NSMutableArray array];
//    NSRange searchRange = NSMakeRange(0, fullText.length);
//    NSRange foundRange;
//    
//    while (searchRange.location < fullText.length) {
//        searchRange.length = fullText.length - searchRange.location;
//        foundRange = [fullText rangeOfString:@"*" options:0 range:searchRange];
//        
//        if (foundRange.location != NSNotFound) {
//            [asteriskRanges addObject:[NSValue valueWithRange:foundRange]];
//            searchRange.location = foundRange.location + foundRange.length;
//        } else {
//            break;
//        }
//    }
//    
//    // 设置星号为橙色 (#FF8370)
//    UIColor *orangeColor = [UIColor colorWithRed:255/255.0 green:131/255.0 blue:112/255.0 alpha:1.0];
//    for (NSValue *rangeValue in asteriskRanges) {
//        [attributedText addAttribute:NSForegroundColorAttributeName
//                              value:orangeColor
//                              range:[rangeValue rangeValue]];
//    }
//    
//    hintLabel.attributedText = attributedText;
//    [containerView addSubview:hintLabel];
//    
    
    
    _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enterButton.frame = CGRectMake(60, containerView.height - 79, self.view.width-60*2, 50);
    [_enterButton setTitle:@"Enter" forState:UIControlStateNormal];
    [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_enterButton setBackgroundImage:[UIImage imageNamed:@"bukathn"] forState:(UIControlStateNormal)];
    _enterButton.layer.cornerRadius = 25;
    [_enterButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:_enterButton];
    
    //点击关闭按钮返回首页
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
       
    [button setImage:[UIImage imageNamed:@"rtunm"]
           forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button sizeToFit];
    button.frame = CGRectMake(0, [UIView statusBarHeight], MAX(button.bounds.size.width, 44), 44);
    [button addTarget:self action:@selector(goBackAction)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)goBackAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



// 在视图控制器中实现
- (void)setupAgreementView:(UIView*)agreementView {
    
    CGFloat ratio = (UIScreen.mainScreen.bounds.size.width - 30)/345.0;
    
    // 创建勾选按钮 (默认选中)
    _checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkboxButton.frame = CGRectMake(0, 9 * ratio, 20 * ratio, 20 * ratio);
    [_checkboxButton setImage:[UIImage imageNamed:@"xzf"] forState:UIControlStateSelected];
    [_checkboxButton setImage:[UIImage imageNamed:@"xzm"] forState:UIControlStateNormal];
    _checkboxButton.selected = YES; // 默认选中
    [_checkboxButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [agreementView addSubview:_checkboxButton];
    
    // 创建协议文本
    UILabel *agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * ratio, 0, agreementView.bounds.size.width - 50 * ratio, 44 * ratio)];
    agreementLabel.userInteractionEnabled = YES;
    agreementLabel.font = [UIFont systemFontOfSize:12 * ratio];
    agreementLabel.numberOfLines = 2;
    // 创建富文本
    NSString *fullText = @"I have read and agree to the < Privacy Agreement >";
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 * ratio]}];
    
    // 找到"Privacy Agreement"的范围
    NSRange agreementRange = [fullText rangeOfString:@"< Privacy Agreement >"];
    
    // 添加下划线样式
    [attributedText addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:agreementRange];
    
    // 设置文本颜色
    [attributedText addAttribute:NSForegroundColorAttributeName
                          value:[UIColor darkGrayColor]
                          range:NSMakeRange(0, fullText.length)];
    
    // 设置"Privacy Agreement"为蓝色
    [attributedText addAttribute:NSForegroundColorAttributeName
                          value:[UIColor blackColor]
                          range:agreementRange];
    
    [attributedText addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:11 * ratio]
                          range:agreementRange];
    
    agreementLabel.attributedText = attributedText;
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privacyAgreementTapped)];
    [agreementLabel addGestureRecognizer:tapGesture];
    
    [agreementView addSubview:agreementLabel];
}









#pragma mark - Actions

// 勾选按钮点击事件
- (void)checkButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
}

// 隐私协议点击事件
- (void)privacyAgreementTapped {
    // 跳转到隐私协议页面
    NSLog(@"Privacy Agreement tapped");
    
    WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:@"http://8.220.140.188:8083/empanadaAp"];
    webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
    [self.navigationController pushViewController:webVC animated:YES];
    // 可以在这里添加跳转逻辑
    // [self.navigationController pushViewController:[PrivacyAgreementViewController new] animated:YES];
}

- (void)sendVerificationCode {
    NSString *phoneNumber = self.phoneNumberField.text;
    if (phoneNumber.length == 0) {
        [SHToast showWithText:@"Please Input Your Phone"];
        return;
    }
    
    
    
    [[NetworkManager sharedManager] POST:@"/radiating/arent"
                             parameters:@{@"complaining": self.phoneNumberField.text, @"drinker": [RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        [SHToast showWithText:responseObject[@"daughters"]];
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            // 发送验证码成功
            [self startCountdown];
            [self StartInitialization];
            [self.verificationCodeField becomeFirstResponder];
            //开始时间
            [[NSUserDefaults standardUserDefaults] setObject:[BeiMInfoUtil getCurrentTimestampInSeconds] forKey:@"StartTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
    }];
    
   
    
    
}

- (void)loginAction {
    NSString *phoneNumber = self.phoneNumberField.text;
    NSString *verificationCode = self.verificationCodeField.text;
    
    if (phoneNumber.length == 0) {
        [SHToast showWithText:@"Please Input Your Phone"];
        return;
    }
    
    if (verificationCode.length == 0) {
        [SHToast showWithText:@"Please enter verification code"];
        return;
    }
    
    if (!_checkboxButton.selected) {
        [SHToast showWithText:@"Please agree to the Privacy Agreement"];
        return;
    }
    

    [[NetworkManager sharedManager] POST:@"/radiating/nobukos"
                              parameters:@{@"pro": phoneNumber,@"wednesdays":verificationCode, @"drinker": [RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"thump"][@"slice"] forKey:@"UserToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"thump"][@"pro"] forKey:@"ZHpro"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //结束时间
            [[NSUserDefaults standardUserDefaults] setObject:[BeiMInfoUtil getCurrentTimestampInSeconds] forKey:@"StopTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[HoPerController alloc] init]];
            window.rootViewController = navOdController;
            [window makeKeyAndVisible];
            
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
    }];
    
}



#pragma mark - Helper Methods

- (void)startCountdown {
    __block NSInteger timeLeft = 60; // 60秒倒计时
    
    // 禁用按钮
    self.acquireButton.enabled = NO;
    self.acquireButton.alpha = 0.6;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeLeft <= 1) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.acquireButton setTitle:@"Acquire" forState:UIControlStateNormal];
                self.acquireButton.enabled = YES;
                self.acquireButton.alpha = 1.0;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.acquireButton setTitle:[NSString stringWithFormat:@"%lds", (long)timeLeft] forState:UIControlStateNormal];
            });
            timeLeft--;
        }
    });
    dispatch_resume(timer);
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)StartInitialization{
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ZHpro"]){
        // Delay the IDFA permission request by 1 second
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [BeiMInfoUtil requestIDFAWithCompletion:^(NSString * _Nullable idfa, BOOL isTrackingAuthorized) {
    //            if (isTrackingAuthorized && idfa) {
    //                NSLog(@"成功获取IDFA: %@", idfa);
    //                // 在这里使用IDFA
    //            } else {
    //                NSLog(@"未获得IDFA权限");
    //                // 处理无权限情况
    //            }
                [[NetworkManager sharedManager]googleMarketPOST:@"/radiating/bringing" parameters:@{@"nearby":[RandomStringGenerator randomlyCallMethod],@"tourists":[BeiMInfoUtil getOrCreateIDFV],@"hordes":idfa?:@""} headers:nil progress:nil success:^(id  _Nullable responseObject) {
                    if([responseObject[@"heavy"] isEqualToString:@"0"]){
                        NSDictionary *heaving = responseObject[@"thump"][@"heaving"];
                        FBSDKSettings.sharedSettings.appID = heaving[@"autumn"];
                        FBSDKSettings.sharedSettings.clientToken = heaving[@"pincher"];
                        FBSDKSettings.sharedSettings.displayName = heaving[@"height"];
                        FBSDKSettings.sharedSettings.appURLSchemeSuffix = heaving[@"foliage"];
                        [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];

                        
                    }
                    
                } failure:^(NSError * _Nonnull error) {
                    
                }];
                
            }];
        });
    }
    
}





@end
