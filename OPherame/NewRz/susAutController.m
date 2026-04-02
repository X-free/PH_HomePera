//
//  susAutController.m
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import "susAutController.h"
#import "FrequqesController.h"
#import "GorenBackController.h"

#import "GworkBackController.h"
#import "GtxlplBackController.h"
#import "GpaymBackController.h"
@interface susAutController ()<OPhNavigationBackButtonDelegate>

@end

@implementation susAutController

- (void)navigationBackButtonDidClick {
    // 执行返回前的操作...返回按钮被点击，可以在这里保存数据等操作
    
    [EKMGPopupView showWithTitle:@"Really skip verification?" content:@"After verifcation, you can enjoy\n account security protection,\n fundsare more secure, and loans\n areeasier to obtain" CancelStr:@"Cancel" sureStr:@"Confirm" confirmAction:^(NSObject * _Nullable obj) {
        
        [EKMGPopupView dismiss];
        [self popToSpecificViewController:[FrequqesController class]];
    }];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"";
    UIImage *image = [UIImage imageNamed:@"plobac"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(8, [UIView navigationBarHeight]+[UIView statusBarHeight]+45, self.view.width-16, 280)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 16;
    [self.view addSubview:topView];
    [self uploadviewsTopView:topView];
    
    UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(8,topView.bottom+12, self.view.width-16, 205)];
    botView.backgroundColor = [UIColor whiteColor];
    botView.layer.cornerRadius = 16;
    botView.clipsToBounds = YES;
    [self.view addSubview:botView];
    [self uploadviewsBotView:botView];
    
    CGRect applyFrame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 302)/2.0, self.view.bounds.size.height - 60, 302, 54);

    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = applyFrame;
    [applyButton setTitle:@"OK" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [applyButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
}

-(void)uploadviewsTopView:(UIView*)topView{
    
    UIImageView *receiveing = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emkio"]];
    receiveing.frame = CGRectMake(1, -11, topView.width-120, 109);
//    receiveing.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:receiveing];
    
    UIImageView *madib = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beib"]];
    madib.frame = CGRectMake(receiveing.right-75, -75, 196, 189);
//    madib.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:madib];
    
    UIImageView *sfzIG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sfbabv"]];
    sfzIG.frame = CGRectMake(37, receiveing.bottom+40.5, topView.width-74, 81);
    [topView addSubview:sfzIG];
    
    UIImageView *gouzb = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gouzib"]];
    gouzb.frame = CGRectMake(56.5, 26, 29.5, 29.5);
    [sfzIG addSubview:gouzb];
    
    gouzb = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gouzib"]];
    gouzb.frame = CGRectMake(12, 15, 29.5, 29.5);
    UIImageView *txkkl = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"txkk"]];
    txkkl.frame = CGRectMake(225, 11, 52.8, 60);
    [txkkl addSubview:gouzb];
    [sfzIG addSubview:txkkl];
    
    UILabel *top_tit = [[UILabel alloc] initWithFrame:CGRectMake(0, sfzIG.bottom+11, topView.width, 20)];
    top_tit.text = @"ID card\t\tFace Recognition";
    top_tit.textColor = [UIColor blackColor];
    top_tit.font = [UIFont boldSystemFontOfSize:14];
    top_tit.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:top_tit];
}

-(void)uploadviewsBotView:(UIView*)botView{
    
    // 创建并添加个人信息视图
       [self createPersonInfoViewWithRealName:self.realname
                                    idNumber:self.unique
                                    birthday:self.birthday
                                   superView:botView];
}


// 创建个人信息展示视图的方法
- (UIView *)createPersonInfoViewWithRealName:(NSString *)realName
                                   idNumber:(NSString *)idNumber
                                   birthday:(NSString *)birthday
                                  superView:(UIView *)superView {
    // 1. 创建容器视图
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(16, 15, superView.width - 32, 174.5)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 8;
    containerView.layer.masksToBounds = YES;
    
    // 2. 数据数组
    NSArray *titles = @[@"Full name", @"ID number", @"Date of birth"];
    NSArray *values = @[realName ?: @"", idNumber ?: @"", birthday ?: @""];
    
    // 3. 计算每个项目的高度
    CGFloat itemHeight = (containerView.frame.size.height - 2) / 3; // 减去两条横线的高度
    
    // 4. 创建并添加标签和横线
    for (int i = 0; i < titles.count; i++) {
        // 计算当前项的Y坐标
        CGFloat yPosition = i * (itemHeight + 1); // 每条横线占1pt
        
        // 创建标题标签
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, yPosition + 12, containerView.frame.size.width - 32, 20)];
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:titleLabel];
        
        // 创建值标签
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, yPosition + 36, containerView.frame.size.width - 32, 24)];
        valueLabel.text = values[i];
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textColor = [UIColor grayColor];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:valueLabel];
        
        // 如果不是最后一项，添加横线
        if (i < titles.count - 1) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(16, yPosition + itemHeight+5, containerView.frame.size.width - 32, 1)];
            separator.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            [containerView addSubview:separator];
        }
    }
    
    // 5. 如果提供了父视图，则添加到父视图
    if (superView) {
        [superView addSubview:containerView];
    }
    
    return containerView;
}

-(void)confirmButtonTapped{
    
    
    //[self popToSpecificViewController:[FrequqesController class]];
    
    [[NetworkManager sharedManager] POST:@"/radiating/tomomi"
                              parameters:@{@"harukos": self.harukos,@"bygone":[RandomStringGenerator randomlyCallMethod], @"riveted": [RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
            NSDictionary *species = responseObject[@"thump"][@"species"];
            if ([species[@"pensive"] isEqualToString:@"cupersuchousG"]){
                GorenBackController *controller = [[GorenBackController alloc]init];
                controller.harukos = self.harukos;
                controller.navTitle = [species valueForKey:@"downright"];
                
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([species[@"pensive"] isEqualToString:@"cupersuchousH"]){
                GworkBackController *controller = [[GworkBackController alloc]init];
                controller.harukos = self.harukos;
                controller.navTitle = [species valueForKey:@"downright"];

                [self.navigationController pushViewController:controller animated:YES];
            }else if ([species[@"pensive"] isEqualToString:@"cupersuchousI"]){
                GtxlplBackController *controller = [[GtxlplBackController alloc]init];
                controller.harukos = self.harukos;
                controller.navTitle = [species valueForKey:@"downright"];

                [self.navigationController pushViewController:controller animated:YES];
            }else if ([species[@"pensive"] isEqualToString:@"cupersuchousL"]){
                GpaymBackController *controller = [[GpaymBackController alloc]init];
                controller.harukos = self.harukos;
                controller.navTitle = [species valueForKey:@"downright"];

                [self.navigationController pushViewController:controller animated:YES];
            }else if(species == nil){
                [self cradiatingflipped];
            }
            
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
    
    
}

- (void)popToSpecificViewController:(Class)targetClass {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:targetClass]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    // 如果没有找到，默认返回上一级
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)cradiatingflipped{
    
    //开始时间
    NSString *StartTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
    mutbdic[@"moneys"] = StartTime;
    mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
    mutbdic[@"bill"] = @"9";
    
    [[NetworkManager sharedManager] POST:@"/radiating/car"
                              parameters:@{@"concentration": self.flipped?:@"",@"koimari":[RandomStringGenerator randomlyCallMethod], @"lacquer": [RandomStringGenerator randomlyCallMethod],@"intervals":[RandomStringGenerator randomlyCallMethod],@"equal":[RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
            NSDictionary *species = responseObject[@"thump"][@"shiny"];
            if(species != nil){
                
                //跳转H5网页
                NSString *shiny = [BeiMInfoUtil appendParamsToURL:responseObject[@"thump"][@"shiny"] params:[[NetworkManager sharedManager]  addCommonParameters:nil]];
//                NSURL *url = [NSURL URLWithString:shiny];
//                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//                // 在当前的视图控制器上呈现
//                [self presentViewController:safariVC animated:YES completion:nil];
                
                WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:shiny];
                                webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
                webVC.harukos = self.harukos;
                                [self.navigationController pushViewController:webVC animated:YES];
                [self locaRadiatingPermis:mutbdic];
            }
            
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
    
}


-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
//    @"bill": @"8",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        
        NSDictionary *medis = @{
            @"centimetre": self.harukos,   // 产品ID
            
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
