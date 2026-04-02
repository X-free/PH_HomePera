//
//  HoPerController.m
//  OPherame
//
//  Created by todesk on 2025/6/23.
//

#import "HoPerController.h"
#import "LoanResponseModel.h"
#import "OnlpoController.h"
#import "FrequqesController.h"
#import "mkWterController.h"

#import "LocationUtilfo.h"

#import "VerticalMarqueeView.h"
#import "LoanAdScrollView.h"


#import "MBProgressHUD.h"
#import "DeviceInfoCollector.h"
#import "Base64Tool.h"
typedef NS_ENUM(NSInteger, UserStatus) {
    cupersuchousB,//大卡位
    cupersuchousC//小卡位
};

@interface HoPerController ()
@property (nonatomic,strong)LoanResponseModel*ResponseModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, assign) UILabel *titleLabel;

@property (nonatomic, assign) UserStatus currentStatus;
@property (nonatomic, strong) UIView *largeCardView;
@property (nonatomic, strong) UIView *smallCardView;


/**cupersuchousB大卡片**/
@property (nonatomic, assign) UILabel *BamountLabel;
@property (nonatomic, assign) UILabel *BloanAmountTitleLabel;
@property (nonatomic, assign) UILabel *BdaysAmountTitleLabel;
@property (nonatomic, assign) UILabel *BnameLabel;
@property (nonatomic, assign) UIButton *BapplyButton;

/**cupersuchousC小卡片**/
@property (nonatomic, assign) UILabel *CamountLabel;
@property (nonatomic, assign) UILabel *CloanAmountTitleLabel;
@property (nonatomic, assign) UILabel *CdaysAmountTitleLabel;
@property (nonatomic, assign) UILabel *CnameLabel;
@property (nonatomic, assign) UIButton *CapplyButton;
@property (nonatomic, assign) UIImageView *overdue;

@property (nonatomic, assign) UIImageView *faqView;
@property (nonatomic, assign) UIImageView *identityView;
@property (nonatomic, assign) UIImageView *requirementsDesc;

@property (nonatomic, strong) LoanAdScrollView *LoanscrollView;
@property (nonatomic, strong) VerticalMarqueeView *marquee;
@end

@implementation HoPerController

-(UIScrollView*)scrollView{
    if(!_scrollView){
        // 创建滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
// 在视图控制器中实现
- (void)setupRefreshControl {
    // 创建刷新控件
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor]; // 设置指示器颜色
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.bounds = CGRectMake(
                                            self.refreshControl.bounds.origin.x,
        -25, // 修改 Y 值
                                            self.refreshControl.bounds.size.width,
                                            self.refreshControl.bounds.size.height
    );
    
    // 添加到 scrollView (或 tableView/collectionView)
    if (@available(iOS 10.0, *)) {
        self.scrollView.refreshControl = self.refreshControl;
    } else {
        [self.scrollView addSubview:self.refreshControl];
    }
}

- (void)triggerRefreshProgrammatically {
    // 立即开始刷新动画
    [self.refreshControl beginRefreshing];
    
    // 手动设置 contentOffset 使刷新控件可见
    [self.scrollView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height-25) animated:YES];
    
    // 触发刷新方法
    [self handleRefresh:self.refreshControl];
}

// 处理刷新事件
- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    
    [[NetworkManager sharedManager] GET:@"/radiating/tastes"
                                  parameters:@{@"relatively": [RandomStringGenerator randomlyCallMethod],@"load": [RandomStringGenerator randomlyCallMethod]}
                                     headers:nil
                                   progress:nil
                                    success:^(id responseObject) {
        // 结束刷新动画
        [refreshControl endRefreshing];
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            self.ResponseModel = [LoanResponseModel yy_modelWithJSON:responseObject[@"thump"]];
            

            if([self.ResponseModel.truly.imitation isEqualToString:@"cupersuchousB"]){
                //大卡位
                self.currentStatus = cupersuchousB;
                self.backgroundImageView.image = [UIImage imageNamed:@"nlko"];
            }else if ([self.ResponseModel.truly.imitation isEqualToString:@"cupersuchousC"]){
                //小卡位
                self.currentStatus = cupersuchousC;
                self.backgroundImageView.image = [UIImage imageNamed:@"mlkp"];
            }
            
            //强制小卡位（调试）
//            self.currentStatus = cupersuchousC;
//            self.backgroundImageView.image = [UIImage imageNamed:@"mlkp"];
            
           
            [self updateViewsWithStatus:self.currentStatus animated:NO];
            
            [self updataNetudata];
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
            
        } failure:^(NSError *error) {
            [SHToast showWithText:error.localizedDescription];
            // 结束刷新动画
            [refreshControl endRefreshing];
        }];

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.scrollView];
    [self setupRefreshControl];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 确保视图已经显示后再触发刷新
    [self triggerRefreshProgrammatically];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建公共视图
    [self setupHomeView];
    
    // 初始化视图
    self.largeCardView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.view safeAreaBottom]+77.5, self.view.width, self.view.height)];
    self.largeCardView.hidden = YES;
    [self.scrollView addSubview:self.largeCardView];
    //大卡位
    [self setupDetailViewLargeCardView:self.largeCardView];
    
    self.smallCardView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.view safeAreaBottom]+77.5, self.view.width, self.view.height)];
    self.smallCardView.hidden = YES;
    [self.scrollView addSubview:self.smallCardView];
    //小卡位
    [self setupDetailViewSmallCardView:self.smallCardView];
}

- (void)setupHomeView {
    
    UIImage *image = [UIImage imageNamed:@"nlko"];
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = image;
    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    _backgroundImageView.clipsToBounds = YES;
    _backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.scrollView addSubview:_backgroundImageView];
    
    // "Home Peru" 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, [self.view safeAreaBottom]+30, 150, 30)];
    titleLabel.text = @"Credit Peso";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.scrollView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    // 右上角个人头像
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, [self.view safeAreaBottom]+16, 46, 46)];
    avatarImageView.image = [UIImage imageNamed:@"tcx"];
    avatarImageView.layer.cornerRadius = 20;
    avatarImageView.clipsToBounds = YES;
    avatarImageView.tag = 1002;
    avatarImageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:avatarImageView];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedWithAnimation:)];
    [avatarImageView addGestureRecognizer:tapGesture];
}


- (void)updateViewsWithStatus:(UserStatus)status animated:(BOOL)animated {
    void (^updateBlock)(void) = ^{
        self.largeCardView.hidden = (status != cupersuchousB);
        self.smallCardView.hidden = (status != cupersuchousC);
    };
    
    if (animated) {
        [UIView transitionWithView:self.view
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:updateBlock
                        completion:nil];
    } else {
        updateBlock();
    }
}

-(void)updataNetudata{
    TrulyParItem *parItem = self.ResponseModel.truly.par[0];
    self.titleLabel.text = parItem.marinate;
    
    
    if(self.currentStatus == cupersuchousB){
        self.BloanAmountTitleLabel.text = parItem.mewed;
        self.BdaysAmountTitleLabel.text = parItem.lowly;
        
        self.BamountLabel.text = [NSString stringWithFormat:@"₱ %@",parItem.exaggerating];
        self.BnameLabel.text = parItem.future;
        [self.BapplyButton setTitle:@"GO" forState:(UIControlStateNormal)];
    }else{
        
        self.CamountLabel.text = [NSString stringWithFormat:@"₱ %@",parItem.exaggerating];
        self.CnameLabel.text = parItem.future;
        [self.CapplyButton setTitle:parItem.rolls forState:(UIControlStateNormal)];
        
        self.CloanAmountTitleLabel.text = parItem.lowly;
        self.CdaysAmountTitleLabel.text = parItem.mewed;
        
        [self.LoanscrollView setupCardsWithData:self.ResponseModel.bingo.par];
        
        if(self.ResponseModel.drew.par&&self.ResponseModel.drew.par.count>0){

            self.marquee.messages = self.ResponseModel.drew.par;
            [self.marquee startScrolling];
            
            self.overdue.hidden = NO;
        }else{
            self.overdue.hidden = YES;
        }
        
    }
    
    
    
    if(self.ResponseModel.answered  == 0){
        //首页差异化模块显示状态，1表示显示，0表示不显示
        _faqView.hidden = YES;
        _identityView.hidden = YES;
        _requirementsDesc.hidden = YES;
        
        
//        _largeCardView.height = 0;?
        self.scrollView.contentSize = CGSizeMake(0, self.view.height);
    }else{
        _faqView.hidden = NO;
        _identityView.hidden = NO;
        _requirementsDesc.hidden = NO;
        _backgroundImageView.height = _requirementsDesc.bottom+150;
        _largeCardView.height = _requirementsDesc.bottom+150;
        self.scrollView.contentSize = CGSizeMake(0, _requirementsDesc.bottom+150);
    }
    
    
    //首页获取到定位权限之后，每次刷新需要再次上报定位信息接口
    if(self.ResponseModel.clearly == 1){

        [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
            if (error) {
                NSLog(@"定位失败: %@", error.localizedDescription);
                
                return;
            }
            
            // 预处理数据（子线程）
            NSString *lat = [NSString stringWithFormat:@"%.17f", coordinate.latitude];
            NSString *lon = [NSString stringWithFormat:@"%.17f", coordinate.longitude];
            NSString *en = [RandomStringGenerator randomlyCallMethod];
            NSString *shosei = [RandomStringGenerator randomlyCallMethod];
            
            NSDictionary *params = @{
                @"dot": province ?: @"",//省
                @"curl": countryCode ?: @"",//国家code
                @"shooing": country ?: @"",//国家
                @"throngs": street ?: @"",//街道
                @"surveying": lat ?: @"",//纬度
                @"stroke": lon ?: @"",//经度
                @"bending": city ?: @"",//市
                @"en": en,
                @"shosei": shosei
            };
    
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self locaResPermis:params];
                
            });
            

        }];
        
        
        
    }else{
        [self loxidFrequqesParItem:self.ResponseModel.truly.par[0]];
    }
    
    
    //每次刷新首页需要再次上报设备信息接口
    NSDictionary *deviceInfo = [[DeviceInfoCollector sharedCollector] collectFullDeviceInfo];
    [[NetworkManager sharedManager]googleMarketPOST:@"/radiating/tableyoure" parameters:@{@"thump":[Base64Tool base64EncodeDictionary:deviceInfo]} headers:nil progress:nil success:^(id  _Nullable responseObject) {
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

//大卡位
-(void)setupDetailViewLargeCardView:(UIView*)largeCardView{
    UIImageView *amount = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, largeCardView.width - 16, 396.5)];
    amount.image = [UIImage imageNamed:@"nblopd"];
    [largeCardView addSubview:amount];
    
    UIImageView *serviceCardView = [[UIImageView alloc] initWithFrame:CGRectMake(8, amount.bottom-23, largeCardView.width - 16, 124)];
    serviceCardView.image = [UIImage imageNamed:@"kefubh"]; // 客服图标
    serviceCardView.contentMode = UIViewContentModeScaleAspectFill;
    serviceCardView.userInteractionEnabled = YES;
    serviceCardView.tag = 1004;
    [largeCardView addSubview:serviceCardView];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedWithAnimation:)];
    [serviceCardView addGestureRecognizer:tapGesture];
    
    // 贷款金额最高可达
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 13.5, serviceCardView.width-80, 25)];
    nameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    [largeCardView addSubview:nameLabel];
    _BnameLabel = nameLabel;
    
    // 贷款金额
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, serviceCardView.width-80, 58)];
    [amountLabel setFont:[UIFont systemFontOfSize:33 weight:UIFontWeightHeavy]];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [largeCardView addSubview:amountLabel];
    _BamountLabel = amountLabel;
    
    // "Apply now"按钮
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame = CGRectMake(143, amountLabel.bottom+10, serviceCardView.width-138*2, 85);
    [applyButton setTitleColor:[UIColor colorWithRed:0.647 green:0.114 blue:0.024 alpha:1.0] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
    applyButton.titleLabel.numberOfLines = 2;
    applyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [largeCardView addSubview:applyButton];
    applyButton.tag = 1003;
    _BapplyButton = applyButton;
    
    UIImageView *dijj = [[UIImageView alloc]initWithFrame:CGRectMake(largeCardView.width-96-109, 153, 96, 75)];
    dijj.image = [UIImage imageNamed:@"recproee"];
    dijj.userInteractionEnabled = YES;
    [largeCardView addSubview:dijj];
    
    // 添加点击手势
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedWithAnimation:)];
    [applyButton addGestureRecognizer:tapGesture];
    
    UILabel *loanAmountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, amountLabel.bottom+13, 77, 18.5)];
    loanAmountTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy];
    loanAmountTitleLabel.textColor = [UIColor colorWithRed:0.647 green:0.114 blue:0.024 alpha:1.0];
    loanAmountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [largeCardView addSubview:loanAmountTitleLabel];
    _BloanAmountTitleLabel = loanAmountTitleLabel;
    
    UILabel *daysAmountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(largeCardView.width-50-77, amountLabel.bottom+13, 77, 18.5)];
    daysAmountTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy];
    daysAmountTitleLabel.textColor = [UIColor colorWithRed:0.647 green:0.114 blue:0.024 alpha:1.0];
    daysAmountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [largeCardView addSubview:daysAmountTitleLabel];
    _BdaysAmountTitleLabel = daysAmountTitleLabel;
    
    
    UIImageView *identityView = [[UIImageView alloc] initWithFrame:CGRectMake(8, serviceCardView.bottom+16, largeCardView.width - 16, 90)]; // 增加高度以显示完整内容
    identityView.image = [UIImage imageNamed:@"grebb"];
    identityView.tag = 1005;
    identityView.userInteractionEnabled = YES;
    [largeCardView addSubview:identityView];
    _identityView = identityView;
    // 添加点击手势
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedWithAnimation:)];
    [identityView addGestureRecognizer:tapGesture];
    
    // 身份认证标题
    UILabel *identityTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 200, 23)];
    identityTitle.text = @"Identity Authentication";
    identityTitle.textColor = [UIColor colorWithRed:30/255.0 green:120/255.0 blue:80/255.0 alpha:1.0];
    identityTitle.font = [UIFont boldSystemFontOfSize:16];
    [identityView addSubview:identityTitle];
    
    // 身份认证描述 - 调整高度和宽度以显示完整内容
    UILabel *identityDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, 40.5, 250, 37)];
    identityDesc.textColor = [UIColor darkGrayColor];
    identityDesc.font = [UIFont systemFontOfSize:13];
    identityDesc.numberOfLines = 0; // 允许多行显示
    [identityView addSubview:identityDesc];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1; // 行间距 10pt

    // 创建 NSAttributedString
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
    };

    identityDesc.attributedText = [[NSAttributedString alloc] initWithString:@"Completing identity verification can help you get a higher credit limit" attributes:attributes];
    
    // Go按钮
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.frame = CGRectMake(identityView.frame.size.width - 99.5, 27.5, 79.5, 35); // 调整按钮位置
    [goButton setBackgroundImage:[UIImage imageNamed:@"gogre"] forState:(UIControlStateNormal)];
    goButton.layer.cornerRadius = 35/2;
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    goButton.userInteractionEnabled = NO;
    [identityView addSubview:goButton];
    
    
    
    UIImageView *faqView = [[UIImageView alloc] initWithFrame:CGRectMake(8, identityView.bottom+16, largeCardView.width - 16, 90)]; // 调整Y坐标
    faqView.image = [UIImage imageNamed:@"redgbb"];
    faqView.userInteractionEnabled = YES;
    faqView.tag = 1006;
    [largeCardView addSubview:faqView];
    _faqView = faqView;
    
    // 添加点击手势
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedWithAnimation:)];
    [faqView addGestureRecognizer:tapGesture];
    
    // FAQ标题
    UILabel *faqTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 230, 23)];
    faqTitle.text = @"Frequently asked questions";
    faqTitle.textColor = [UIColor colorWithRed:180/255.0 green:80/255.0 blue:0/255.0 alpha:1.0];
    faqTitle.font = [UIFont boldSystemFontOfSize:16];
    [faqView addSubview:faqTitle];
    
    // FAQ描述
    UILabel *faqDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, 40.5, 250, 37)];
    faqDesc.textColor = [UIColor darkGrayColor];
    faqDesc.font = [UIFont systemFontOfSize:13];
    faqDesc.numberOfLines = 0; // 允许多行显示
    [faqView addSubview:faqDesc];
    
    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1; // 行间距 10pt

    // 创建 NSAttributedString
    attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
    };

    faqDesc.attributedText = [[NSAttributedString alloc] initWithString:@"These questions will help you get to know us better" attributes:attributes];
    
    // Go按钮
    goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.frame = CGRectMake(faqView.frame.size.width - 99.5, 27.5, 79.5, 35);
    [goButton setBackgroundImage:[UIImage imageNamed:@"gored"] forState:(UIControlStateNormal)];
    goButton.layer.cornerRadius = 35/2;
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    goButton.userInteractionEnabled = NO;
    [faqView addSubview:goButton];
    
    
    UIImageView *requirementsDesc = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lmoyu"]];
    requirementsDesc.frame = CGRectMake(18.5, faqView.bottom+22, largeCardView.width-37, 136.5);
    [largeCardView addSubview:requirementsDesc];
    _requirementsDesc = requirementsDesc;
    
    _backgroundImageView.height = requirementsDesc.bottom+150;
    largeCardView.height = requirementsDesc.bottom+150;
    self.scrollView.contentSize = CGSizeMake(0, requirementsDesc.bottom+150);
}

//小卡位
-(void)setupDetailViewSmallCardView:(UIView*)smallCardView{
    
    UIImageView *amount = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recprocc"]];
    amount.frame = CGRectMake(8, 0, smallCardView.width-16, 202.5);
    [smallCardView addSubview:amount];
    
    // 贷款金额最高可达
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 25, smallCardView.width-68, 25)];
    nameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIView colorFromRGB:0xFD662F];
    [smallCardView addSubview:nameLabel];
    _CnameLabel = nameLabel;
    
    // 贷款金额
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, nameLabel.bottom+2, smallCardView.width-68, 58)];
    [amountLabel setFont:[UIFont systemFontOfSize:33 weight:UIFontWeightHeavy]];
    amountLabel.textColor = [UIView colorFromRGB:0xFD662F];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    [smallCardView addSubview:amountLabel];
    _CamountLabel = amountLabel;
    
    // "Apply now"按钮
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame = CGRectMake(80.5, amountLabel.bottom+25, smallCardView.width-80.5*2, 42);
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [smallCardView addSubview:applyButton];
    applyButton.tag = 1003;
    _CapplyButton = applyButton;
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedWithAnimation:)];
    [applyButton addGestureRecognizer:tapGesture];
    
    
    UIImageView *dijj = [[UIImageView alloc]initWithFrame:CGRectMake(smallCardView.width-81.5-25, amountLabel.bottom+35, 81.5, 64)];
    dijj.image = [UIImage imageNamed:@"recproee"];
    [smallCardView addSubview:dijj];
    
  
    UILabel *loanAmountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(smallCardView.width-15-77, 43, 77, 27.5)];
    loanAmountTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy];
    loanAmountTitleLabel.textColor = [UIColor whiteColor];
    loanAmountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [smallCardView addSubview:loanAmountTitleLabel];
    _CloanAmountTitleLabel = loanAmountTitleLabel;
    
    UILabel *daysAmountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(smallCardView.width-15-77, loanAmountTitleLabel.bottom+7, 77, 27.5)];
    daysAmountTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy];
    daysAmountTitleLabel.textColor = [UIColor whiteColor];
    daysAmountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [smallCardView addSubview:daysAmountTitleLabel];
    _CdaysAmountTitleLabel = daysAmountTitleLabel;
    
    
    
    UIImageView *overdue = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recprodd"]];
    overdue.frame = CGRectMake(8, amount.bottom+31.5, smallCardView.width-16, 65);
    overdue.userInteractionEnabled = YES;
    [smallCardView addSubview:overdue];
    _overdue = overdue;
    
//    UILabel *assoon = [[UILabel alloc] initWithFrame:CGRectMake(59.5, 15, overdue.width-59.5*2, 37)];
//    assoon.text = @"Our order is overdue, please pay assoon as possible";
//    assoon.textColor = [UIColor whiteColor];
//    assoon.font = [UIFont systemFontOfSize:13];
//    assoon.numberOfLines = 2;
//    [overdue addSubview:assoon];
    
    // 1. 创建数据源
    NSArray *messages = @[
        @"Our order is overdue, please pay New notification: Your package has shipped",
        @"New notification: Your package has shipped maintenance at 3AM",
        @"Important: System maintenance at 3AM order is overdue",
        @"Our order is overdue, please pay assoon as possible order is overdue"
    ];

    // 2. 创建跑马灯视图
    VerticalMarqueeView *marquee = [[VerticalMarqueeView alloc] initWithFrame:CGRectMake(59.5, 15, overdue.width-59.5*2, 37) messages:nil];

    // 3. 自定义样式（可选）
    marquee.textFont = [UIFont systemFontOfSize:13];
    marquee.textColor = [UIColor whiteColor];
    marquee.scrollInterval = 3; // 每条显示3秒
    marquee.animationDuration = 1.2; // 动画时间1.2秒

    // 4. 设置点击回调
    [marquee setClickHandler:^(NSInteger index, NSString *message) {
        NSLog(@"点击了第%ld条: %@", (long)index, message);
        NSString *shiny = [BeiMInfoUtil appendParamsToURL:message params:[[NetworkManager sharedManager]  addCommonParameters:nil]];
        WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:shiny];
        webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }];

    // 5. 开始滚动
//    [marquee startScrolling];

    // 6. 添加到视图
    [overdue addSubview:marquee];
    
    _marquee = marquee;
    
    

    UIButton *recproffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recproffButton.frame = CGRectMake(overdue.width-19-26, 19.5, 26, 26);
    [recproffButton setBackgroundImage:[UIImage imageNamed:@"recproff"] forState:(UIControlStateNormal)];
    [overdue addSubview:recproffButton];
    
    
    UIImageView *productsImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recprobb"]];
    productsImg.frame = CGRectMake(8, overdue.bottom+27.5, smallCardView.width-16, 317);
    productsImg.userInteractionEnabled = YES;
    [smallCardView addSubview:productsImg];
    
    UILabel *productslb = [[UILabel alloc] initWithFrame:CGRectMake(56, 5, productsImg.width-56*2, 20)];
    productslb.text = @"Recommended products";
    productslb.textColor = [UIColor whiteColor];
    productslb.font = [UIFont boldSystemFontOfSize:14];
    productslb.textAlignment = NSTextAlignmentCenter;
    [productsImg addSubview:productslb];
    
    
    
    // 1. 准备卡片数据
    
    
    // 2. 创建滚动视图
    LoanAdScrollView *scrollView = [[LoanAdScrollView alloc] initWithFrame:CGRectMake(8, productslb.bottom+23, productsImg.width-16, 240) cards:self.ResponseModel.bingo.par];

    // 3. 自定义背景色 (可选)
    scrollView.cardBackgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.85 alpha:1.0];

    // 4. 设置按钮点击回调
    scrollView.didTapButton = ^(NSInteger index) {
        NSLog(@"点击了第%ld个卡片的按钮", (long)index + 1);
        
        if(self.ResponseModel.clearly == 1){
            
            if ([[LocationUtilfo sharedManager] hasLocationPermission]) {
                // 有定位权限
                [self loxidFrequqesParItem:self.ResponseModel.bingo.par[index]];
            }
            
            [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
                if (error) {
                    NSLog(@"定位失败: %@", error.localizedDescription);
                    return;
                }
                
//                NSLog(@"国家: %@", country);
//                NSLog(@"国家代码: %@", countryCode);
//                NSLog(@"省份: %@", province);
//                NSLog(@"城市: %@", city);
//                NSLog(@"区县: %@", district);
//                NSLog(@"街道: %@", street);
//                NSLog(@"完整地址: %@", fullAddress);
//                NSLog(@"经度: %f", coordinate.longitude);
//                NSLog(@"纬度: %f", coordinate.latitude);
                
                // 预处理数据（子线程）
                NSString *lat = [NSString stringWithFormat:@"%.17f", coordinate.latitude];
                NSString *lon = [NSString stringWithFormat:@"%.17f", coordinate.longitude];
                NSString *en = [RandomStringGenerator randomlyCallMethod];
                NSString *shosei = [RandomStringGenerator randomlyCallMethod];
                
                NSDictionary *params = @{
                    @"dot": province ?: @"",//省
                    @"curl": countryCode ?: @"",//国家code
                    @"shooing": country ?: @"",//国家
                    @"throngs": street ?: @"",//街道
                    @"surveying": lat ?: @"",//纬度
                    @"stroke": lon ?: @"",//经度
                    @"bending": city ?: @"",//市
                    @"en": en,
                    @"shosei": shosei
                };
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self locaResPermis:params];
                    
                });
                

            }];
            
            
        }else{
            [self loxidFrequqesParItem:self.ResponseModel.bingo.par[index]];
        }
    };

    // 5. 添加到视图
    [productsImg addSubview:scrollView];
    _LoanscrollView = scrollView;
    
    
    
}



// 带动画效果的点击处理方法
- (void)imageTappedWithAnimation:(UITapGestureRecognizer *)gesture {
    UIImageView *imageView = (UIImageView *)gesture.view;
    
    // 点击动画效果
    [UIView animateWithDuration:0.1 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            //登陆后才允许点击以下功能
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"];
            if (!token) {
                //登录页
                
                OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
                navOdController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.navigationController presentViewController:navOdController animated:YES completion:nil];
                
                return;
            }
            
            
            // 在这里处理点击后的业务逻辑
            if(imageView.tag == 1006){
                //常见问题
                OnlpoController *controller = [[OnlpoController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
            }else if (imageView.tag == 1005){
                
                if(self.ResponseModel.clearly == 1){
                    
                    if ([[LocationUtilfo sharedManager] hasLocationPermission]) {
                        // 有定位权限
                        [self loxidFrequqesParItem:self.ResponseModel.truly.par[0]];
                    }
                
                    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
                        if (error) {
                            NSLog(@"定位失败: %@", error.localizedDescription);
                            return;
                        }
                        

                        
                        // 预处理数据（子线程）
                        NSString *lat = [NSString stringWithFormat:@"%.17f", coordinate.latitude];
                        NSString *lon = [NSString stringWithFormat:@"%.17f", coordinate.longitude];
                        NSString *en = [RandomStringGenerator randomlyCallMethod];
                        NSString *shosei = [RandomStringGenerator randomlyCallMethod];
                        
                        NSDictionary *params = @{
                            @"dot": province ?: @"",//省
                            @"curl": countryCode ?: @"",//国家code
                            @"shooing": country ?: @"",//国家
                            @"throngs": street ?: @"",//街道
                            @"surveying": lat ?: @"",//纬度
                            @"stroke": lon ?: @"",//经度
                            @"bending": city ?: @"",//市
                            @"en": en,
                            @"shosei": shosei
                        };
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self locaResPermis:params];
                            
                        });
                        
                        

                    }];
               
                }else{
                    [self loxidFrequqesParItem:self.ResponseModel.truly.par[0]];
                }
           
            }else if (imageView.tag == 1004){
                //跳转客服
//                NSURL *url = [NSURL URLWithString:self.ResponseModel.pill.healthy];
//                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//                // 在当前的视图控制器上呈现
//                [self presentViewController:safariVC animated:YES completion:nil];
                
                WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:self.ResponseModel.pill.healthy];
                                webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
                                [self.navigationController pushViewController:webVC animated:YES];

                
            }else if (imageView.tag == 1003){
                if(self.ResponseModel.clearly == 1){
                    
                    if ([[LocationUtilfo sharedManager] hasLocationPermission]) {
                        // 有定位权限
                        [self loxidFrequqesParItem:self.ResponseModel.truly.par[0]];
                    }
                
                    
                    
                    
                    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
                        if (error) {
                            NSLog(@"定位失败: %@", error.localizedDescription);
                            
                            return;
                        }
                        
                        // 预处理数据（子线程）
                        NSString *lat = [NSString stringWithFormat:@"%.17f", coordinate.latitude];
                        NSString *lon = [NSString stringWithFormat:@"%.17f", coordinate.longitude];
                        NSString *en = [RandomStringGenerator randomlyCallMethod];
                        NSString *shosei = [RandomStringGenerator randomlyCallMethod];
                        
                        NSDictionary *params = @{
                            @"dot": province ?: @"",//省
                            @"curl": countryCode ?: @"",//国家code
                            @"shooing": country ?: @"",//国家
                            @"throngs": street ?: @"",//街道
                            @"surveying": lat ?: @"",//纬度
                            @"stroke": lon ?: @"",//经度
                            @"bending": city ?: @"",//市
                            @"en": en,
                            @"shosei": shosei
                        };
                
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self locaResPermis:params];
                            
                        });
                        

                    }];
                    
                    
                    
                }else{
                    [self loxidFrequqesParItem:self.ResponseModel.truly.par[0]];
                }
            }else if (imageView.tag == 1002){
                
                if(self.ResponseModel.clearly == 1){
                    if ([[LocationUtilfo sharedManager] hasLocationPermission]) {
                        // 有定位权限
                        mkWterController *controller = [[mkWterController alloc]init];
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
                            
                        }];
                    }
                    
                    
                }else{
                    mkWterController *controller = [[mkWterController alloc]init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
            }
            
        }];
    }];
}

-(void)loxidFrequqesParItem:(TrulyParItem*)parItem{
    //TrulyParItem *parItem = self.ResponseModel.truly.par[0];
    
    [[NetworkManager sharedManager] POST:@"/radiating/closed"
                              parameters:@{@"harukos": [NSString stringWithFormat:@"%ld",parItem.sub],@"lovingly":[RandomStringGenerator randomlyCallMethod], @"impressions": [RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            if([responseObject[@"thump"][@"shiny"] hasPrefix:@"http"]||[responseObject[@"thump"][@"shiny"] hasPrefix:@"https"]){
                //跳web网页
                
                NSString *shiny = [BeiMInfoUtil appendParamsToURL:responseObject[@"thump"][@"shiny"] params:[[NetworkManager sharedManager]  addCommonParameters:nil]];
//                NSURL *url = [NSURL URLWithString:shiny];
//                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//                // 在当前的视图控制器上呈现
//                [self presentViewController:safariVC animated:YES completion:nil];
                
                WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:shiny];
                webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
                webVC.harukos = [NSString stringWithFormat:@"%ld",parItem.sub];
                [self.navigationController pushViewController:webVC animated:YES];
            }else{

                if ([responseObject[@"thump"][@"shiny"] rangeOfString:@"mangoIrisZuc"].location != NSNotFound) {
                    //身份验证
                    FrequqesController *controller = [[FrequqesController alloc]init];
                    
                    controller.harukos = [responseObject[@"thump"][@"shiny"] componentsSeparatedByString:@"?"][1];
                    [self.navigationController pushViewController:controller animated:YES];
                }else if ([responseObject[@"thump"][@"shiny"] rangeOfString:@"camelViolinZ"].location != NSNotFound){
                    //登录页
//                    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
//                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
//                    window.rootViewController = navOdController;
//                    [window makeKeyAndVisible];
                    
                    OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
                    navOdController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self.navigationController presentViewController:navOdController animated:YES completion:nil];
                    
                }else if ([responseObject[@"thump"][@"shiny"] rangeOfString:@"rabbitKaleOn"].location != NSNotFound){
                    //首页
                    
                }

                    
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
@end
