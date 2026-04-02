//
//  rlAutController.m
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import "rlAutController.h"
#import "susAutController.h"
#import "sfAutController.h"
@interface rlAutController ()<OPhNavigationBackButtonDelegate>

@end

@implementation rlAutController

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
    
    self.title = self.navTitle;
    self.customTitleColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"plobac"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(8, [UIView navigationBarHeight]+[UIView statusBarHeight]+34, self.view.width-16, 280)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 16;
    [self.view addSubview:topView];
    [self uploadviewsTopView:topView];
    
    UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(8,topView.bottom+18, self.view.width-16, 167)];
    botView.backgroundColor = [UIColor whiteColor];
    botView.layer.cornerRadius = 16;
    botView.clipsToBounds = YES;
    [self.view addSubview:botView];
    [self uploadviewsBotView:botView];
    
    
    [[NetworkManager sharedManager] GET:@"/radiating/forest"
                                  parameters:@{@"harukos": self.harukos,@"figured": [RandomStringGenerator randomlyCallMethod]}
                                     headers:nil
                                   progress:nil
                                success:^(id responseObject) {
        if ([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@1]&&[responseObject[@"thump"][@"combine"] isEqualToNumber:@0]){
            self.imitation = [responseObject[@"thump"][@"imitation"] doubleValue];
        }
        
    }failure:^(NSError *error) {
        [SHToast showWithText:error.localizedDescription];
        
    }];
}

-(void)uploadviewsTopView:(UIView*)topView{
    UIImageView *receiveing = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"idcardface"]];
    receiveing.frame = CGRectMake(1, -11, topView.width-96, 41);
    [topView addSubview:receiveing];
    
    UIImageView *madib = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"madib"]];
    madib.frame = CGRectMake(receiveing.right-11, -41, topView.width-receiveing.right+6, 90);
    [topView addSubview:madib];
    
    UIImageView *sfzIG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sminIg"]];
    sfzIG.frame = CGRectMake(37, 58.5, topView.width-74, 161.5);
    sfzIG.userInteractionEnabled = YES;
    [topView addSubview:sfzIG];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmButtonTapped)];
    [sfzIG addGestureRecognizer:tapGesture];
    
    
    UILabel *bot_tit = [[UILabel alloc] initWithFrame:CGRectMake(0, sfzIG.bottom+19, topView.width, 20)];
    bot_tit.text = @"Click to perform face recognition";
    bot_tit.textColor = [UIColor blackColor];
    bot_tit.font = [UIFont boldSystemFontOfSize:14];
    bot_tit.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:bot_tit];
    
    
    CGRect applyFrame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 302)/2.0, self.view.bounds.size.height - 60, 302, 54);

    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = applyFrame;
    [applyButton setTitle:@"Continue certification" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [applyButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
}

-(void)uploadviewsBotView:(UIView*)botView{
    
    UILabel *top_tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 22.5, botView.width, 18.5)];
    top_tit.text = @"- Requirements for photographing lD cards -";
    top_tit.textColor = [UIColor blackColor];
    top_tit.font = [UIFont boldSystemFontOfSize:14];
    top_tit.textAlignment = NSTextAlignmentCenter;
    [botView addSubview:top_tit];
    
    UILabel *cot_tit = [[UILabel alloc] initWithFrame:CGRectMake(0, top_tit.bottom+8, botView.width, 30)];
    cot_tit.text = @"When shooting,Make sure the lD card frame is\n intact,clearand even in brghtness.";
    cot_tit.textColor = [UIColor lightGrayColor];
    cot_tit.font = [UIFont systemFontOfSize:11];
    cot_tit.textAlignment = NSTextAlignmentCenter;
    cot_tit.numberOfLines = 2;
    [botView addSubview:cot_tit];
    
    NSArray *arr = @[@"smina",@"sminb",@"sminc"];
    for (int i = 0; i < 3; i++) {
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:arr[i]]];
        icon.frame = CGRectMake((botView.width-64.5*3-30)/2+80*i, cot_tit.bottom+17, 64.5, 38.7);
        [botView addSubview:icon];
        
        UIImageView *xx = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cakdelx"]];
        xx.frame = CGRectMake(25.5, 33, 13, 13);
        
        [icon addSubview:xx];
    }
}


-(void)confirmButtonTapped{
    
    //开始时间
    NSString *StartTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    [EKYCPopupView showWithUploadmethod:self.imitation allowSwitchCamera:NO confirmAction:^(NSObject * _Nullable obj) {
        
        NSDictionary *parameters = @{
            @"inaka": [[NSUserDefaults standardUserDefaults] objectForKey:@"inaka"], // 图片来源:1相册 2:拍照上传
            @"harukos": self.harukos, // 产品id
            @"imitation": @"10", //10:人脸自拍, 11身份证正面
            @"grain": obj, // 压缩500K以内的图片NSData 参考代码：[formData appendPartWithFileData:data name:key fileName:@"xx.jpg" mimeType:@"image/jpeg"];
            @"vegetable": self.vegetable,  //卡类型 UMID/SSS/TIN/PASSPORT/DRIVINGLICENSE/PRC/POSTAL/Voter/PhilHealth
            @"kyotoite": @"", // 默认为空，
            @"drinker": [RandomStringGenerator randomlyCallMethod], // 混淆字段
            @"okinawan": @"1" // 传1即可
        };
        
        
        [[NetworkManager sharedManager] POST:@"/radiating/shoulderot"
                                  parameters:parameters
                                     headers:@{@"Content-Type":@"multipart/form-data"}
                                   progress:nil
                                    success:^(id responseObject) {
            [EKYCPopupView dismiss];
            if([responseObject[@"heavy"] isEqualToString:@"0"]){
                
                //人脸认证点击按钮，直接调用系统前置摄像头拍照，隐藏切换摄像头的按钮，拍照后（随便拍一张照片就可以）（从相机点确定，直接关闭相机，图片压缩逻辑在关闭相机后处理，压缩时需要loading。）调用上传接口【接口上传(face,身份证正面,反面)（第一项）】成功后，调用 产品详情接口 （需要loading）获取下一步认证项，下一步不为空，就跳转到对应的认证项；如果下一步为空就调用【跟进订单号获取跳转地址】（需要loading）接口获取跳转url，跳转到H5页面。
                NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
                mutbdic[@"moneys"] = StartTime;
                mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
                [self locaRadiatingPermis:mutbdic];
                
                [self Reqopradiatingforest];
                
            }else{
                [SHToast showWithText:responseObject[@"daughters"]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"失败: %@", error.localizedDescription);
            [SHToast showWithText:error.localizedDescription];
            
        }];
        
        
    }];
    
    /*
    susAutController *controller = [[susAutController alloc]init];
    controller.realname = self.realname;
    controller.unique = self.unique;
    controller.birthday = self.birthday;
    controller.vegetable = self.vegetable;
    [self.navigationController pushViewController:controller animated:YES];*/
}

-(void)Reqopradiatingforest{
    
    
    [[NetworkManager sharedManager] GET:@"/radiating/forest"
                                  parameters:@{@"harukos": self.harukos,@"figured": [RandomStringGenerator randomlyCallMethod]}
                                     headers:nil
                                   progress:nil
                                    success:^(id responseObject) {
      
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            if([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@0]){
                //跳转选择卡类型页面
                
                // 显示弹窗（带更多选项）
                [EKYCPopupView showWithTitle:@[@"E-KYC",@"More options"]
                                 mainOptions:responseObject[@"thump"][@"zushi"][0]
                                 moreOptions:responseObject[@"thump"][@"zushi"][1]
                                confirmTitle:@"Confirm"
                               confirmAction:^(NSObject * _Nullable obj) {
                    sfAutController *controller = [[sfAutController alloc]init];
                    controller.harukos = self.harukos;
                    controller.vegetable = (NSString*)obj;
                    controller.imitation = [responseObject[@"thump"][@"imitation"] doubleValue];
                    [self.navigationController pushViewController:controller animated:YES];
                }];

            }else if ([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@1]&&[responseObject[@"thump"][@"combine"] isEqualToNumber:@0]){
                //跳转选择人脸页面
                rlAutController *controller = [[rlAutController alloc]init];
                controller.harukos = self.harukos;
                controller.vegetable = responseObject[@"thump"][@"wedged"][@"vegetable"];
                controller.imitation = [responseObject[@"thump"][@"imitation"] doubleValue];
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@1]&&[responseObject[@"thump"][@"combine"] isEqualToNumber:@1]){
                //跳转认证结果页面.
                susAutController *controller = [[susAutController alloc]init];
                controller.realname = responseObject[@"thump"][@"wedged"][@"sushis"][@"appreciating"];
                controller.unique = responseObject[@"thump"][@"wedged"][@"sushis"][@"unique"];
                controller.birthday = responseObject[@"thump"][@"wedged"][@"sushis"][@"vinegar"];
                controller.vegetable = responseObject[@"thump"][@"wedged"][@"vegetable"];
                controller.harukos = self.harukos;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
            
        } failure:^(NSError *error) {
            [SHToast showWithText:error.localizedDescription];
            
        }];
}


-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
    
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        
        NSDictionary *medis = @{
            @"centimetre": self.harukos,   // 产品ID
            @"bill": @"4",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
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
