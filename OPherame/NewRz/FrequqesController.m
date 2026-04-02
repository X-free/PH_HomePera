//
//  FrequqesController.m
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import "FrequqesController.h"
#import "AuthenticationCell.h"
#import "AuthenticationModel.h"
#import "EKYCPopupView.h"
#import "sfAutController.h"
#import "rlAutController.h"
#import "susAutController.h"
#import "GorenBackController.h"
#import "GworkBackController.h"
#import "GtxlplBackController.h"
#import "GpaymBackController.h"
#import "LocationUtilfo.h"
#import "DeviceInfoCollector.h"
#import "Base64Tool.h"
@interface FrequqesController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,OPhNavigationBackButtonDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *species;

@property (nonatomic, strong) NSString *flipped;
@end

@implementation FrequqesController

- (void)navigationBackButtonDidClick {
    // 执行返回前的操作...返回按钮被点击，可以在这里保存数据等操作
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 在视图控制器中实现
- (void)setupRefreshControl {
    // 创建刷新控件
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor]; // 设置指示器颜色
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.bounds = CGRectMake(
                                            self.refreshControl.bounds.origin.x,
        0, // 修改 Y 值
                                            self.refreshControl.bounds.size.width,
                                            self.refreshControl.bounds.size.height
    );
    
    // 添加到 scrollView (或 tableView/collectionView)
    if (@available(iOS 10.0, *)) {
        self.collectionView.refreshControl = self.refreshControl;
    } else {
        [self.collectionView addSubview:self.refreshControl];
    }
}

- (void)triggerRefreshProgrammatically {
    // 立即开始刷新动画
    [self.refreshControl beginRefreshing];
    
    // 手动设置 contentOffset 使刷新控件可见
    [self.collectionView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    
    // 触发刷新方法
    [self handleRefresh:self.refreshControl];
}

// 处理刷新事件
- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    NSArray *components = [self.harukos componentsSeparatedByString:@"="];

    [[NetworkManager sharedManager] POST:@"/radiating/tomomi"
                              parameters:@{@"harukos": components[1],@"bygone":[RandomStringGenerator randomlyCallMethod], @"riveted": [RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        // 结束刷新动画
        [refreshControl endRefreshing];
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
            self.flipped = responseObject[@"thump"][@"scary"][@"flipped"];
            self.species = responseObject[@"thump"][@"species"];
            self.dataArray = [NSMutableArray array];
            NSArray *iconNames = @[@"wenabn", @"wenbbn", @"wencbn", @"wendbn", @"wenebn"];
            int icon_i = 0;
            for (NSObject *obj in responseObject[@"thump"][@"associate"]) {
                AuthenticationModel *model = [AuthenticationModel yy_modelWithJSON:obj];
                model.icon = iconNames[icon_i];
                icon_i++;
                [self.dataArray addObject:model];
            }
            [self.collectionView reloadData];
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        // 结束刷新动画
        [refreshControl endRefreshing];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupRefreshControl];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 确保视图已经显示后再触发刷新
    [self triggerRefreshProgrammatically];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Authentication";
    self.customTitleColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"plobac"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
//    [self setupData];
    [self setupCollectionView];
    
    
    //获取地址和
    [self requestAddress];
    
}

-(void)requestAddress{
    [[NetworkManager sharedManager] GET:@"http://8.220.140.188:8083/blewapi/radiating/thumped" completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"请求失败: %@", error.localizedDescription);
            return;
        }
        
        //NSLog(@"请求成功: %@", response);
        // 处理返回的数据
    }];
    
    NSDictionary *deviceInfo = [[DeviceInfoCollector sharedCollector] collectFullDeviceInfo];
    [[NetworkManager sharedManager]googleMarketPOST:@"/radiating/tableyoure" parameters:@{@"thump":[Base64Tool base64EncodeDictionary:deviceInfo]} headers:nil progress:nil success:^(id  _Nullable responseObject) {
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((self.view.width-29*2-12)/2, 175.5);
    layout.minimumLineSpacing = 15; // 上下间距
    layout.minimumInteritemSpacing = 12; // 左右间距
    layout.sectionInset = UIEdgeInsetsMake(15, 29, 15, 29); // 整体边距
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [UIView navigationBarHeight]+[UIView statusBarHeight]+34, self.view.width, self.view.height-[UIView navigationBarHeight]-[UIView statusBarHeight]-34-80) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[AuthenticationCell class] forCellWithReuseIdentifier:@"AuthenticationCell"];
    
    [self.view addSubview:_collectionView];
    
    // 添加底部申请贷款按钮
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = CGRectMake(61, self.view.bounds.size.height - 80, self.view.bounds.size.width - 122, 50);
    [applyButton setTitle:@"Apply for a loan" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [applyButton addTarget:self action:@selector(didItemforaLoan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AuthenticationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AuthenticationCell" forIndexPath:indexPath];
    
    AuthenticationModel *item = self.dataArray[indexPath.item];
    
    [cell configureWithTitle:item.downright
                description:item.experienced
                    btnText:[NSString stringWithFormat:@"%ld",item.during]
                        icon:[UIImage imageNamed:item.icon] assumed:item.assumed];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AuthenticationModel *itemMod = self.dataArray[indexPath.item];
    
    
    
    NSArray *components = [self.harukos componentsSeparatedByString:@"="];
    if(indexPath.item == 0){
        [[NetworkManager sharedManager] GET:@"/radiating/forest"
                                      parameters:@{@"harukos": components[1],@"figured": [RandomStringGenerator randomlyCallMethod]}
                                         headers:nil
                                       progress:nil
                                        success:^(id responseObject) {
          
            if([responseObject[@"heavy"] isEqualToString:@"0"]){
                if([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@0]){
                    //跳转选择卡类型页面
                    
                    //开始时间
                    NSString *StartTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
                    
                    // 显示弹窗（带更多选项）
                    [EKYCPopupView showWithTitle:@[@"E-KYC",@"More options"]
                                     mainOptions:responseObject[@"thump"][@"zushi"][0]
                                     moreOptions:responseObject[@"thump"][@"zushi"][1]
                                    confirmTitle:@"Confirm"
                                   confirmAction:^(NSObject * _Nullable obj) {
                        sfAutController *controller = [[sfAutController alloc]init];
                        controller.harukos = components[1];
                        controller.vegetable = (NSString*)obj;
                        controller.imitation = [responseObject[@"thump"][@"imitation"] doubleValue];
                        [self.navigationController pushViewController:controller animated:YES];
                        
                        NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
                        mutbdic[@"moneys"] = StartTime;
                        mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
                        mutbdic[@"bill"] = @"2";
                        [self locaRadiatingPermis:mutbdic];
                    }];

                }else if ([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@1]&&[responseObject[@"thump"][@"combine"] isEqualToNumber:@0]){
                    //跳转选择人脸页面
                    rlAutController *controller = [[rlAutController alloc]init];
                    controller.harukos = components[1];
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
                    controller.harukos = components[1];
                    controller.flipped = self.flipped;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }else{
                [SHToast showWithText:responseObject[@"daughters"]];
            }
                
            } failure:^(NSError *error) {
                [SHToast showWithText:error.localizedDescription];
                
            }];
    }else if(itemMod.during == 1&&indexPath.item == 1){
        GorenBackController *controller = [[GorenBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(itemMod.during == 1&&indexPath.item == 2){
        GworkBackController *controller = [[GworkBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(itemMod.during == 1&&indexPath.item == 3){
        GtxlplBackController *controller = [[GtxlplBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(itemMod.during == 1&&indexPath.item == 4){
        GpaymBackController *controller = [[GpaymBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        //全部认证完成
        [self didItemforaLoan];
    }
}


-(void)didItemforaLoan{
    
    NSArray *components = [self.harukos componentsSeparatedByString:@"="];
    if(self.species == nil){
        [self cradiatingButtonTomomi];
        return;
    }
    if([self.species[@"pensive"] isEqualToString:@"cupersuchousF"]){
        //获取用户身份信息（第一项）
        
        [[NetworkManager sharedManager] GET:@"/radiating/forest"
                                      parameters:@{@"harukos": components[1],@"figured": [RandomStringGenerator randomlyCallMethod]}
                                         headers:nil
                                       progress:nil
                                        success:^(id responseObject) {
          
            if([responseObject[@"heavy"] isEqualToString:@"0"]){
                if([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@0]){
                    //跳转选择卡类型页面
                    
                    //开始时间
                    NSString *StartTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
                    
                    // 显示弹窗（带更多选项）
                    [EKYCPopupView showWithTitle:@[@"E-KYC",@"More options"]
                                     mainOptions:responseObject[@"thump"][@"zushi"][0]
                                     moreOptions:responseObject[@"thump"][@"zushi"][1]
                                    confirmTitle:@"Confirm"
                                   confirmAction:^(NSObject * _Nullable obj) {
                        sfAutController *controller = [[sfAutController alloc]init];
                        controller.harukos = components[1];
                        controller.vegetable = (NSString*)obj;
                        controller.imitation = [responseObject[@"thump"][@"imitation"] doubleValue];
                        [self.navigationController pushViewController:controller animated:YES];
                        
                        NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
                        mutbdic[@"moneys"] = StartTime;
                        mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
                        mutbdic[@"bill"] = @"2";
                        [self locaRadiatingPermis:mutbdic];
                    }];

                }else if ([responseObject[@"thump"][@"wedged"][@"during"] isEqualToNumber:@1]&&[responseObject[@"thump"][@"combine"] isEqualToNumber:@0]){
                    //跳转选择人脸页面
                    rlAutController *controller = [[rlAutController alloc]init];
                    controller.harukos = components[1];
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
                    controller.harukos = components[1];
                    controller.flipped = self.flipped;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }else{
                [SHToast showWithText:responseObject[@"daughters"]];
            }
                
            } failure:^(NSError *error) {
                [SHToast showWithText:error.localizedDescription];
                
            }];
        
        
    }else if ([self.species[@"pensive"] isEqualToString:@"cupersuchousG"]){
        GorenBackController *controller = [[GorenBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([self.species[@"pensive"] isEqualToString:@"cupersuchousH"]){
        GworkBackController *controller = [[GworkBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([self.species[@"pensive"] isEqualToString:@"cupersuchousI"]){
        GtxlplBackController *controller = [[GtxlplBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([self.species[@"pensive"] isEqualToString:@"cupersuchousL"]){
        GpaymBackController *controller = [[GpaymBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
    //位置上报
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
        if (error) {
            NSLog(@"定位失败: %@", error.localizedDescription);
            return;
        }
        
        NSLog(@"国家: %@", country);
        NSLog(@"国家代码: %@", countryCode);
        NSLog(@"省份: %@", province);
        NSLog(@"城市: %@", city);
        NSLog(@"区县: %@", district);
        NSLog(@"街道: %@", street);
        NSLog(@"完整地址: %@", fullAddress);
        NSLog(@"经度: %f", coordinate.longitude);
        NSLog(@"纬度: %f", coordinate.latitude);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self locaResPermis:@{
                @"dot": province?:@"",  //省
                @"curl": countryCode?:@"",//国家code
                @"shooing": country?:@"",//国家
                @"throngs": street?:@"",//街道
                @"surveying": [NSString stringWithFormat:@"%.17f",coordinate.latitude]?:@"",//纬度
                @"stroke": [NSString stringWithFormat:@"%.17f", coordinate.longitude]?:@"",//经度
                @"bending": city?:@"",//市
                @"en": [RandomStringGenerator randomlyCallMethod],
                @"shosei": [RandomStringGenerator randomlyCallMethod]
            }];
        });
        
        
    }];
}

-(void)cradiatingButtonTomomi{
    
    
    //开始时间
    NSArray *components = [self.harukos componentsSeparatedByString:@"="];
    NSString *StartTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
    mutbdic[@"moneys"] = StartTime;
    mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
    mutbdic[@"bill"] = @"9";
    
    
    [[NetworkManager sharedManager] POST:@"/radiating/car"
                              parameters:@{@"concentration": self.flipped,@"koimari":[RandomStringGenerator randomlyCallMethod], @"lacquer": [RandomStringGenerator randomlyCallMethod],@"intervals":[RandomStringGenerator randomlyCallMethod],@"equal":[RandomStringGenerator randomlyCallMethod]}
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
                if (components.count > 1) {
                    webVC.harukos = components[1];
                }
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


-(void)locaResPermis:(NSDictionary*)permis{
    
    [[NetworkManager sharedManager]googleMarketPOST:@"/radiating/somewhere" parameters:permis headers:nil progress:nil success:^(id  _Nullable responseObject) {
        if([responseObject[@"heavy"] isEqualToString:@"0"]){

        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}



-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
//    @"bill": @"2",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
    NSArray *components = [self.harukos componentsSeparatedByString:@"="];
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
       
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        NSString *centimetre = @"";
        if (components.count > 1) {
            centimetre = components[1];
        }
        NSDictionary *medis = @{
            @"centimetre": centimetre ?: @"",   // 产品ID
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
