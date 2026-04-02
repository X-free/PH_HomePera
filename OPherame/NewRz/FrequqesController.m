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
#import <QuartzCore/QuartzCore.h>
#import "UIView+FrameUtil.h"
@interface FrequqesController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,OPhNavigationBackButtonDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *species;

@property (nonatomic, strong) NSString *flipped;

@property (nonatomic, strong) NSDictionary *scary;
@property (nonatomic, strong) UILabel *productNameLabel;

@property (nonatomic, strong) UILabel *loanTitleLabel;

@property (nonatomic, strong) UILabel *loanAmountValueLabel;

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
            self.scary = responseObject[@"thump"][@"scary"];
            [self updateHeaderWithScary:self.scary];
            self.dataArray = [NSMutableArray array];
            NSArray *iconNames = @[@"wenabn", @"wenbbn", @"wencbn", @"wendbn", @"wenebn"];
            int icon_i = 0;
            for (NSObject *obj in responseObject[@"thump"][@"associate"]) {
                AuthenticationModel *model = [AuthenticationModel yy_modelWithJSON:obj];
                if (icon_i < (int)iconNames.count) {
                    model.icon = iconNames[icon_i];
                }
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

// 用 scary 填充顶部 header（Product Details 卡片）
- (void)updateHeaderWithScary:(NSDictionary *)scary {
    if (!scary) return;
    
    NSString *productName = scary[@"marinate"];
    if (productName.length == 0) {
        productName = @"Credit Peso";
    }
    self.productNameLabel.text = productName;
    
    id amountAny = scary[@"annoying"];
    if (amountAny == nil || amountAny == [NSNull null]) {
        amountAny = @"0";
    }
    NSString *amountRaw = nil;
    if ([amountAny isKindOfClass:[NSString class]]) {
        amountRaw = (NSString *)amountAny;
    } else if ([amountAny respondsToSelector:@selector(stringValue)]) {
        // 兼容 NSNumber 等类型
        amountRaw = [amountAny stringValue];
    } else {
        amountRaw = @"0";
    }
    
    // 提取数字并做千分位格式化：接口可能是 "1.100.000"
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *digitsOnly = [[amountRaw componentsSeparatedByCharactersInSet:nonDigits] componentsJoinedByString:@""];
    if (digitsOnly.length == 0) digitsOnly = @"0";
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    fmt.numberStyle = NSNumberFormatterDecimalStyle;
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *formatted = [fmt stringFromNumber:@(digitsOnly.longLongValue)];
    
    self.loanAmountValueLabel.text = formatted ?: digitsOnly;
    
    NSString *distant = [scary valueForKey:@"distant"];
    
    if (distant.length > 0) {
        self.loanTitleLabel.text = [scary valueForKey:@"distant"];
    } else {
        self.loanTitleLabel.text = @"Loan amount（₱）";
    }
    
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
    self.title = @"Product Details";
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
    // 1) Top product header（detailheader）
    CGFloat navTop = [UIView navigationBarHeight] + [UIView statusBarHeight];
    CGFloat cardX = 16; // 左右间距 16（设计稿）
    CGFloat cardW = self.view.bounds.size.width - cardX * 2;
    CGFloat productCardH = cardW * 319.0 / 692.0; // 692:319
    CGFloat productCardY = navTop;
    
    UIImageView *productBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailheader"]];
    productBg.frame = CGRectMake(cardX, productCardY, cardW, productCardH);
    productBg.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:productBg];
    
    self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(productBg.centerX - 60, 12, 120, 32)];
    self.productNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.productNameLabel.textColor = [UIView colorFromRGB:0x3D3D3D];
    self.productNameLabel.textAlignment = NSTextAlignmentLeft;
    [productBg addSubview:self.productNameLabel];
    
    // 用 logo 切图展示（裁切为左上角图标样式）
    UIImageView *brandLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.productNameLabel.left - 40, 12, 32, 32)];
    brandLogoView.image = [UIImage imageNamed:@"logoh"];
    brandLogoView.contentMode = UIViewContentModeScaleAspectFill;
    brandLogoView.clipsToBounds = YES;
    [productBg addSubview:brandLogoView];
    
    
    UILabel *loanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 78, cardW - 56, 20)];
    loanTitleLabel.font = [UIFont systemFontOfSize:14];
    loanTitleLabel.textColor = [UIView colorFromRGB:0x363636];
    loanTitleLabel.textAlignment = NSTextAlignmentCenter;
    [productBg addSubview:loanTitleLabel];
    self.loanTitleLabel = loanTitleLabel;
    
    
    self.loanAmountValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 105, cardW - 56, 52)];
    self.loanAmountValueLabel.font = [UIFont boldSystemFontOfSize:40];
    self.loanAmountValueLabel.textColor = [UIView colorFromRGB:0x01506B];
    self.loanAmountValueLabel.textAlignment = NSTextAlignmentCenter;
    [productBg addSubview:self.loanAmountValueLabel];
    
    // Bottom Apply
    CGRect applyFrame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 302)/2.0, self.view.bounds.size.height - 60, 302, 54);
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = applyFrame;
    [applyButton setTitle:@"Apply" forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bukathx"] forState:UIControlStateNormal];
    applyButton.layer.borderWidth = 0;
    applyButton.layer.cornerRadius = 26;
    applyButton.backgroundColor = [UIColor clearColor];
    [applyButton addTarget:self action:@selector(didItemforaLoan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
    
    // 2) 全部列表背景（detailcontent）
    CGFloat contentGap = 12;
    CGFloat contentCardY = productCardY + productCardH + contentGap;
    CGFloat desiredContentH = cardW * 1600.0 / 1448.0; // detailcontent 的比例
    CGFloat maxContentH = applyFrame.origin.y - contentCardY - 14;
    if (maxContentH < 120) maxContentH = 120;
    CGFloat contentCardH = MIN(desiredContentH, maxContentH);
    
    UIImageView *contentBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailcontent"]];
    contentBg.frame = CGRectMake(cardX, contentCardY, cardW, contentCardH);
    contentBg.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:contentBg];
    
    // 红色 bar 标题（覆盖在 detailcontent 顶部红条上）
    CGFloat sectionTitleH = 34;
    CGFloat sectionTitleYInContent = 5;
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, sectionTitleYInContent, cardW, sectionTitleH)];
    sectionTitle.text = @"Certification items";
    sectionTitle.font = [UIFont boldSystemFontOfSize:14];
    sectionTitle.textColor = [UIColor whiteColor];
    sectionTitle.textAlignment = NSTextAlignmentCenter;
    [contentBg addSubview:sectionTitle];
    
    // 3) 列表：单列纵向（放在 detailcontent 白色区域）
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat listInsetX = 20;
    CGFloat listW = cardW - 40;
    CGFloat cellH = 56;
    layout.itemSize = CGSizeMake(listW, cellH);
    layout.minimumLineSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(12, 0, 12, 0);
    
    CGFloat listTopInContent = sectionTitleYInContent + sectionTitleH;
    CGFloat listH = contentCardH - listTopInContent - 6;
    if (listH < 100) listH = 100;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(cardX + listInsetX, contentCardY + listTopInContent, listW, listH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[AuthenticationCell class] forCellWithReuseIdentifier:@"AuthenticationCell"];
    [self.view addSubview:_collectionView];
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
                        AuthenticationModel *model = self.dataArray.firstObject;
                        
                        controller.navTitle =  model.downright;
                        
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
                    AuthenticationModel *model = self.dataArray.firstObject;
                    
                    controller.navTitle =  model.downright;
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
        
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (item.pensive == itemMod.pensive) {
                controller.navTitle = item.downright;
            }
            
        }];
        
        [self.navigationController pushViewController:controller animated:YES];
    }else if(itemMod.during == 1&&indexPath.item == 2){
        GworkBackController *controller = [[GworkBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (item.pensive == itemMod.pensive) {
                controller.navTitle = item.downright;
            }
            
        }];
        
        [self.navigationController pushViewController:controller animated:YES];
    }else if(itemMod.during == 1&&indexPath.item == 3){
        GtxlplBackController *controller = [[GtxlplBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (item.pensive == itemMod.pensive) {
                controller.navTitle = item.downright;
            }
            
        }];
        
        [self.navigationController pushViewController:controller animated:YES];
    }else if(itemMod.during == 1&&indexPath.item == 4){
        GpaymBackController *controller = [[GpaymBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (item.pensive == itemMod.pensive) {
                controller.navTitle = item.downright;
            }
            
        }];
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
    NSString *pensive = self.species[@"pensive"];
    if(pensive == nil || [pensive isKindOfClass:[NSNull class]] || pensive.length == 0){
        // 认证项全部完成：直接进入下一步申请
        [self cradiatingButtonTomomi];
        return;
    }
    
    // 兼容新旧 pensive 字段值
    if([pensive isEqualToString:@"cupersuchousF"] || [pensive isEqualToString:@"public"]){
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
                        AuthenticationModel *model = self.dataArray.firstObject;
                        
                        controller.navTitle =  model.downright;
                        
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
                    
                    AuthenticationModel *model = self.dataArray.firstObject;
                    
                    controller.navTitle =  model.downright;
                    
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
        
        
    }else if ([pensive isEqualToString:@"cupersuchousG"] || [pensive isEqualToString:@"personal"]){
        GorenBackController *controller = [[GorenBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([item.pensive isEqualToString:@"cupersuchousG"]) {
                controller.navTitle = item.downright;
            }
            
        }];
        
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([pensive isEqualToString:@"cupersuchousH"] || [pensive isEqualToString:@"job"]){
        GworkBackController *controller = [[GworkBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([item.pensive isEqualToString:@"cupersuchousH"]) {
                controller.navTitle = item.downright;
            }
            
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([pensive isEqualToString:@"cupersuchousI"] || [pensive isEqualToString:@"ext"]){
        GtxlplBackController *controller = [[GtxlplBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([item.pensive isEqualToString:@"cupersuchousI"]) {
                controller.navTitle = item.downright;
            }
            
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([pensive isEqualToString:@"cupersuchousL"] || [pensive isEqualToString:@"bank"]){
        GpaymBackController *controller = [[GpaymBackController alloc]init];
        controller.harukos = components[1];
        controller.flipped = self.flipped;
        [self.dataArray enumerateObjectsUsingBlock:^(AuthenticationModel *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([item.pensive isEqualToString:@"cupersuchousG"]) {
                controller.navTitle = item.downright;
            }
            
        }];
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
