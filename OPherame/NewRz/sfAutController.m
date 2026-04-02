//
//  sfAutController.m
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import "sfAutController.h"

@interface sfAutController ()<OPhNavigationBackButtonDelegate>
@property (nonatomic, strong)UIImageView *sfzIG;
@end

@implementation sfAutController

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
    
}

-(void)uploadviewsTopView:(UIView*)topView{
    UIImageView *receiveing = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"idcardface0"]];
    receiveing.frame = CGRectMake(1, -11, topView.width-96, 41);
    [topView addSubview:receiveing];
    
    UIImageView *madib = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"madib"]];
    madib.frame = CGRectMake(receiveing.right-11, -41, topView.width-receiveing.right+6, 90);
    [topView addSubview:madib];
    
    UIImageView *sfzIG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sfzIG"]];
    sfzIG.frame = CGRectMake(37, 58.5, topView.width-74, 161.5);
    sfzIG.userInteractionEnabled = YES;
    [topView addSubview:sfzIG];
    _sfzIG = sfzIG;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmButtonTapped)];
    [sfzIG addGestureRecognizer:tapGesture];
    
    UIImageView *cameIG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cameIG"]];
    cameIG.frame = CGRectMake(0, 0, 70, 70);
    cameIG.center = sfzIG.center;
    cameIG.userInteractionEnabled = NO;
    [topView addSubview:cameIG];
    
    
    UILabel *bot_tit = [[UILabel alloc] initWithFrame:CGRectMake(0, sfzIG.bottom+19, topView.width, 20)];
    bot_tit.text = @"Click to upload ID card";
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
    
    NSArray *arr = @[@"sfk_a",@"sfk_b",@"sfk_c"];
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
    [[NSUserDefaults standardUserDefaults] setObject:[BeiMInfoUtil getCurrentTimestampInSeconds] forKey:@"StartSFTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [EKYCPopupView showWithUploadmethod:self.imitation allowSwitchCamera:YES confirmAction:^(NSObject * _Nullable obj) {
        
        

        
        NSDictionary *parameters = @{
            @"inaka": [[NSUserDefaults standardUserDefaults] objectForKey:@"inaka"], // 图片来源:1相册 2:拍照上传
            @"harukos": self.harukos, // 产品id
            @"imitation": @"11", //10:人脸自拍, 11身份证正面
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
            
                [EKYCPopupView showWithRealname:responseObject[@"thump"][@"appreciating"] number:responseObject[@"thump"][@"unique"] Birthday:responseObject[@"thump"][@"vinegar"] confirmAction:^(NSObject * _Nullable obj) {
                        
                }];
            }else{
                [SHToast showWithText:responseObject[@"daughters"]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"失败: %@", error.localizedDescription);
            [SHToast showWithText:error.localizedDescription];
            
        }];
        
        
    }];
    
    /*
    [EKYCPopupView showWithRealname:nil number:nil Birthday:nil confirmAction:^(NSObject * _Nullable obj) {
            
    }];*/
}




@end
