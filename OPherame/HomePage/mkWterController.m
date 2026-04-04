//
//  mkWterController.m
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import "mkWterController.h"
#import "BeiMInfoUtil.h"
#import "LoandnController.h"
#import "EKMGPopupView.h"
#import "stpUpController.h"
@interface mkWterController ()

@end

@implementation mkWterController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.customTitleColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Profile";
    self.customTitleColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"grbacdd"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
    
    UIImageView *grzxtp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grzxtp"]];
    grzxtp.frame = CGRectMake(8, [UIView navigationBarHeight]+[UIView statusBarHeight]+34, self.view.width-16, grzxtp.image.size.height);
    grzxtp.userInteractionEnabled = YES;
    [self.view addSubview:grzxtp];
    
    UIButton *tioncButton = [UIButton buttonWithType:UIButtonTypeSystem];
    tioncButton.frame = CGRectMake(16, grzxtp.top+58, self.view.bounds.size.width - 32, 64.5);
    [tioncButton setTitle:[NSString stringWithFormat:@"  %@",[self maskPhoneNumberFromThird:[[NSUserDefaults standardUserDefaults] objectForKey:@"ZHpro"]]] forState:UIControlStateNormal];
    [tioncButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tioncButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [tioncButton setImage:[[UIImage imageNamed:@"tionc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [tioncButton setBackgroundColor:[UIView colorFromRGB:0x0691FF]];
    [self.view addSubview:tioncButton];
    
    
    /*
    UILabel *assoon = [[UILabel alloc] initWithFrame:CGRectMake(0, grzxtp.bottom-15-17, grzxtp.width, 17)];
    assoon.text = [NSString stringWithFormat:@"version-%@",[BeiMInfoUtil getAppVersion]];
    assoon.textColor = [UIView colorFromRGB:0x005DA5];
    assoon.font = [UIFont systemFontOfSize:13];
    assoon.textAlignment = NSTextAlignmentCenter;
    assoon.userInteractionEnabled = YES;
    [self.view addSubview:assoon];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assoonTost)];
    [assoon addGestureRecognizer:tapGesture];*/
    
    
    
    for (int i = 0; i<4; i++) {
        UIView *bigBV = [[UIView alloc]initWithFrame:CGRectMake(31, grzxtp.top+148+(38.5+15)*i, grzxtp.width-31-25, 38.5)];
        bigBV.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bigBV];
        bigBV.tag = 1200+i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigBVTappedWithAnimation:)];
        [bigBV addGestureRecognizer:tapGesture];
    }
    
}

-(void)assoonTost{
    [SHToast showWithText:[NSString stringWithFormat:@"version-%@",[BeiMInfoUtil getAppVersion]]];
}

- (NSString *)maskPhoneNumberFromThird:(NSString *)phoneNumber {
    if (phoneNumber.length < 3) {
        return phoneNumber; // 位数不足，直接返回
    }
    
    NSString *firstTwoChars = [phoneNumber substringToIndex:2];
    NSString *maskedPart = @"****";
    NSString *lastPart = @"";
    
    if (phoneNumber.length > 6) {
        lastPart = [phoneNumber substringFromIndex:6];
    }
    
    return [NSString stringWithFormat:@"%@%@%@", firstTwoChars, maskedPart, lastPart];
}


-(void)bigBVTappedWithAnimation:(UITapGestureRecognizer*)tap{
    if(tap.view.tag == 1200){
        LoandnController *controller = [[LoandnController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (tap.view.tag == 1201){
        WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:@"http://8.220.140.188:8083/sauceBellp"];
        webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (tap.view.tag == 1202){
        
        WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:@"http://8.220.140.188:8083/empanadaAp"];
        webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (tap.view.tag == 1203){
        
        stpUpController *controller = [[stpUpController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        /*
        [EKMGPopupView showWithTitle:@"Exit app?" content:@"lt would be a pity to quit\n now.Exclusive rights such as\n priority loanare waiting for you.\n Come andexperience it!" CancelStr:@"Confirm Exit" sureStr:@"Continue to use" confirmAction:^(NSObject * _Nullable obj) {
         
            [[NetworkManager sharedManager] GET:@"/radiating/onthe"
                                          parameters:@{@"minami": [RandomStringGenerator randomlyCallMethod],@"suigei": [RandomStringGenerator randomlyCallMethod]}
                                             headers:nil
                                           progress:nil
                                            success:^(id responseObject) {
               
                if([responseObject[@"heavy"] isEqualToString:@"0"]){
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
                    window.rootViewController = navOdController;
                    [window makeKeyAndVisible];
                }else{
                    [SHToast showWithText:responseObject[@"daughters"]];
                }
                    
                } failure:^(NSError *error) {
                    [SHToast showWithText:error.localizedDescription];
                }];
            
        }];*/
    }else if (tap.view.tag == 1204){
        /*
        [EKMGPopupView  showAccountCancellationfirmAction:^(NSObject * _Nullable obj) {
            [[NetworkManager sharedManager] GET:@"/radiating/ingredients"
                                          parameters:@{@"reminds": [RandomStringGenerator randomlyCallMethod]}
                                             headers:nil
                                           progress:nil
                                            success:^(id responseObject) {
               
                if([responseObject[@"heavy"] isEqualToString:@"0"]){
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
                    window.rootViewController = navOdController;
                    [window makeKeyAndVisible];
                }else{
                    [SHToast showWithText:responseObject[@"daughters"]];
                }
                    
                } failure:^(NSError *error) {
                    [SHToast showWithText:error.localizedDescription];
                }];
        }];
        */
        
    }
}


@end
