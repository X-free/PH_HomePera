//
//  stpUpController.m
//  OPherame
//
//  Created by todesk on 2025/7/28.
//

#import "stpUpController.h"

@interface stpUpController ()

@end

@implementation stpUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Set up";
    self.customTitleColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"grbacdd"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
    [self setupUI];
}

- (void)setupUI {
    // 创建圆角白色容器
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 180)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 10.0;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
    
    NSArray *titles = @[@"Go Out", @"version", @"Account Cancellation"];
    NSArray *details = @[@"", [BeiMInfoUtil getAppVersion], @""];
    
    for (int i = 0; i < titles.count; i++) {
        // 创建按钮容器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i * 60, containerView.frame.size.width, 60);
        button.tag = i;
        [button addTarget:self action:@selector(itemTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:button];
        
        // 左侧标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 60)];
        titleLabel.text = titles[i];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        [button addSubview:titleLabel];
        
        // 右侧内容（版本号或箭头）
        if (i == 1) {
            // 版本号标签
            UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(containerView.frame.size.width - 115, 0, 100, 60)];
            versionLabel.text = details[i];
            versionLabel.textColor = [UIColor grayColor];
            versionLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
            versionLabel.textAlignment = NSTextAlignmentRight;
            [button addSubview:versionLabel];
        } else {
            // 箭头图标
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(containerView.frame.size.width - 25, 22, 15, 15)];
            arrow.image = [UIImage systemImageNamed:@"chevron.right"];
            arrow.tintColor = [UIColor lightGrayColor];
            [button addSubview:arrow];
            
            if (i == 2){
                titleLabel.textColor = [UIColor grayColor];
            }
        }
        
        // 分隔线
        if (i < titles.count - 1) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(15, 60 + i * 60, containerView.frame.size.width - 30, 0.5)];
            separator.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            [containerView addSubview:separator];
        }
    }
}

- (void)itemTapped:(UIButton *)sender {
    NSString *title = [[sender.subviews firstObject] text];
    
    if ([title isEqualToString:@"Go Out"]) {
        [EKMGPopupView showWithTitle:@"Exit app?" content:@"lt would be a pity to quit\n now.Exclusive rights such as\n priority loanare waiting for you.\n Come andexperience it!" CancelStr:@"Leave" sureStr:@"Continue" confirmAction:^(NSObject * _Nullable obj) {
         
            [[NetworkManager sharedManager] GET:@"/radiating/onthe"
                                          parameters:@{@"minami": [RandomStringGenerator randomlyCallMethod],@"suigei": [RandomStringGenerator randomlyCallMethod]}
                                             headers:nil
                                           progress:nil
                                            success:^(id responseObject) {
               
                if([responseObject[@"heavy"] isEqualToString:@"0"]){
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
//                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
//                    window.rootViewController = navOdController;
//                    [window makeKeyAndVisible];
                    
                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
                    navOdController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self.navigationController presentViewController:navOdController animated:YES completion:nil];
                }else{
                    [SHToast showWithText:responseObject[@"daughters"]];
                }
                    
                } failure:^(NSError *error) {
                    [SHToast showWithText:error.localizedDescription];
                }];
            
        }];
    }
    else if ([title isEqualToString:@"version"]) {
        [SHToast showWithText:[NSString stringWithFormat:@"version-%@",[BeiMInfoUtil getAppVersion]]];
    }
    else if ([title isEqualToString:@"Account Cancellation"]) {
        [EKMGPopupView  showAccountCancellationfirmAction:^(NSObject * _Nullable obj) {
            [[NetworkManager sharedManager] GET:@"/radiating/ingredients"
                                          parameters:@{@"reminds": [RandomStringGenerator randomlyCallMethod]}
                                             headers:nil
                                           progress:nil
                                            success:^(id responseObject) {
               
                if([responseObject[@"heavy"] isEqualToString:@"0"]){
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
//                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
//                    window.rootViewController = navOdController;
//                    [window makeKeyAndVisible];
                    
                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
                    navOdController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self.navigationController presentViewController:navOdController animated:YES completion:nil];
                }else{
                    [SHToast showWithText:responseObject[@"daughters"]];
                }
                    
                } failure:^(NSError *error) {
                    [SHToast showWithText:error.localizedDescription];
                }];
        }];
    }
}


@end
