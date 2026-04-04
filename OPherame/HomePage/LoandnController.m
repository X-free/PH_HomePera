//
//  LoandnController.m
//  OPherame
//
//  Created by todesk on 2025/6/29.
//

#import "LoandnController.h"
#import "HoPerController.h"
@interface LoandnController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIButton *tepmBtn;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray<UIButton *> *buttons; // 存储所有按钮

@property (nonatomic, strong) NSString *thuds;//状态 4全部 7进行中 6待还款 5已结清

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (strong, nonatomic) UIView *emptyView;
@property (nonatomic, strong) UIImageView *emptyIconView;
@property (nonatomic, strong) UILabel *emptyTitleLabel;
@property (nonatomic, strong) UILabel *emptySubtitleLabel;
@property (nonatomic, strong) UIButton *emptyActionButton;
@end

@implementation LoandnController


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
        self.tableView.refreshControl = self.refreshControl;
    } else {
        [self.tableView addSubview:self.refreshControl];
    }
}

- (void)triggerRefreshProgrammatically {
    // 立即开始刷新动画
    [self.refreshControl beginRefreshing];
    
    // 手动设置 contentOffset 使刷新控件可见
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    
    // 触发刷新方法
    [self handleRefresh:self.refreshControl];
}

// 处理刷新事件
- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    

    [[NetworkManager sharedManager] POST:@"/radiating/himself"
                              parameters:@{@"thuds":self.thuds}
                                 headers:nil
                               progress:nil
                                success:^(id responseObject) {
        // 结束刷新动画
        [refreshControl endRefreshing];
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            self.dataArray = responseObject[@"thump"][@"jiju"];
            [self.tableView reloadData];
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        // 结束刷新动画
        [refreshControl endRefreshing];
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
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
    
    self.title = @"Orders";
    UIImage *image = [UIImage imageNamed:@"kllkp"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(8, [UIView navigationBarHeight]+[UIView statusBarHeight]+20 + 70, self.view.width-16, self.view.height-[UIView navigationBarHeight]-[UIView statusBarHeight]-20-88-75)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 16;
    [self.view addSubview:self.containerView];
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(self.containerView.left, self.containerView.top - 70, self.containerView.width, 55)];
    barView.layer.cornerRadius = 16;
    barView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:barView];
    
    CGFloat buttonWidth = (self.containerView.width - 31) / 4; // 计算按钮宽度（左右间距 10，按钮间距 10）
    CGFloat buttonHeight = 55.0;
    CGFloat startX = 3; // 起始 X 坐标
        
    NSArray *buttonTitles = @[@"All", @"In progress", @"Repayment", @"Completed"];
    NSMutableArray *buttons = [NSMutableArray array];
    UIColor *normalTitleColor = [UIView colorFromRGB:0x929292];
    
    for (int i = 0; i < buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(startX + i * (buttonWidth + 10), 0, buttonWidth, buttonHeight);
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        // 选中态：绿色渐变背景 + 白色描边（匹配设计稿的选中 pill）
        [button setBackgroundImage:[UIImage imageNamed:@"itembg"] forState:(UIControlStateSelected)];
        [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13]; // 未选中：常规
        button.backgroundColor = [UIColor clearColor];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 0;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.tag = i+1; // 设置 tag 用于区分按钮
        button.selected = i == 0?YES:NO;
        if (button.selected) {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:13]; // 选中：加粗
            button.layer.borderWidth = 2; // 选中态描边
            self.tepmBtn = button;
        }
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [barView insertSubview:button atIndex:0];
        [buttons addObject:button];
    }
    self.buttons = buttons.copy; // 存储所有按钮
    
    self.thuds = @"4";
    
    // 创建表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(19, 20, self.containerView.width-38, self.containerView.height-40) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.containerView addSubview:self.tableView];
    
    // 创建空数据视图
    [self setupEmptyView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DDmoCell"];
    
    
}


// 按钮点击事件
- (void)buttonClicked:(UIButton *)sender {
    self.tepmBtn.selected = NO;
    self.tepmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.tepmBtn setTitleColor:[UIView colorFromRGB:0x929292] forState:UIControlStateNormal];
    self.tepmBtn.layer.borderWidth = 0;
    
    // 选中当前按钮
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    sender.layer.borderWidth = 2;
    
    self.tepmBtn = sender;

    if(sender.tag == 1){
        self.thuds = @"4";
    }else if (sender.tag == 2){
        self.thuds = @"7";
    }else if (sender.tag == 3){
        self.thuds = @"6";
    }else{
        self.thuds = @"5";
    }
    
    
    [self triggerRefreshProgrammatically];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    BOOL isEmpty = self.dataArray.count == 0;
    self.emptyView.hidden = !isEmpty;
    return self.dataArray.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDmoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 清除旧内容
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDictionary *dic = self.dataArray[indexPath.row][@"deliberate"];
    if([dic[@"fixing"] isEqualToString:@"Delay"]||[dic[@"fixing"] isEqualToString:@"Relayment"]){
        
        [self setContViewDelay_1:cell.contentView redius:dic];
    }else if ([dic[@"fixing"] isEqualToString:@"Apply"]){
        [self setContViewDelay_2:cell.contentView redius:dic];
    }else{
        [self setContViewDelay_3:cell.contentView redius:dic];
    }
   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = self.dataArray[indexPath.row][@"deliberate"];
    
    if([dic[@"fixing"] isEqualToString:@"Delay"]||[dic[@"fixing"] isEqualToString:@"Relayment"]){
        
        return 257.4;
    }else if ([dic[@"fixing"] isEqualToString:@"Apply"]){
        return 232.4;
    }else{
        return 178.4;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12.5;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row][@"deliberate"];
    if(![dic[@"am"] isEqualToString:@""]&&dic[@"am"]!=nil){
//        NSURL *url = [NSURL URLWithString:dic[@"am"]];
//        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//        // 在当前的视图控制器上呈现
//        [self presentViewController:safariVC animated:YES completion:nil];
        
        if([dic[@"am"] containsString:@"http"]||[dic[@"am"] containsString:@"https"]){
            NSString *shiny = [BeiMInfoUtil appendParamsToURL:dic[@"am"] params:[[NetworkManager sharedManager]  addCommonParameters:nil]];
            
            WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:shiny];
                            webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
                            [self.navigationController pushViewController:webVC animated:YES];
        }else{
            NSString *amkos = [dic[@"am"] componentsSeparatedByString:@"?"][1];
            NSArray *components = [amkos componentsSeparatedByString:@"="];
            [self loxidFrequqesController:components[1]];
        }
        
        
        
    }
}

-(void)loxidFrequqesController:(NSString*)harukos{
    
    
    [[NetworkManager sharedManager] POST:@"/radiating/closed"
                              parameters:@{@"harukos": harukos,@"lovingly":[RandomStringGenerator randomlyCallMethod], @"impressions": [RandomStringGenerator randomlyCallMethod]}
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

-(void)setContViewDelay_1:(UIView*)contentView redius:(NSDictionary*)dic{
    UIImageView *AlloView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.frame), 247.5)];
    if([dic[@"fixing"] isEqualToString:@"Delay"]){
        AlloView.image = [UIImage imageNamed:@"Delay_1"];
    }else{
        AlloView.image = [UIImage imageNamed:@"Delay_2"];
    }
    
    [contentView addSubview:AlloView];
    
    UIView *whitV = [[UIView alloc]initWithFrame:CGRectMake(43, 19, 18, 18)];
    whitV.backgroundColor = [UIColor whiteColor];
    whitV.layer.cornerRadius = 9;
    [contentView addSubview:whitV];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(whitV.right+5, whitV.top, 70.5, 16.5)];
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = dic[@"marinate"];
    [contentView addSubview:titleLabel];
    
    UILabel *riLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+52, whitV.top, 100.5, 20.5)];
    riLabel.font = [UIFont boldSystemFontOfSize:14];
    riLabel.textColor = [UIColor whiteColor];
    riLabel.textAlignment = NSTextAlignmentCenter;
    riLabel.text = dic[@"fixing"];
    [contentView addSubview:riLabel];
    
    NSArray *ary = @[
        @[dic[@"aware"] ?: @"", dic[@"expectations"] ?: @""],
        @[dic[@"playfully"] ?: @"", dic[@"broached"] ?: @""]
    ];
    for (int i = 0; i<ary.count; i++) {
        NSArray *marAry = ary[i];
        UILabel *titl = [[UILabel alloc] initWithFrame:CGRectMake(43.5, riLabel.bottom+40+(21+27)*i, 180, 21)];
        titl.font = [UIFont systemFontOfSize:12];
        titl.textColor = [UIColor whiteColor];
        titl.text = marAry[0];
        [contentView addSubview:titl];
        
        UILabel *Pltitl = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width-98.5-15, riLabel.bottom+40+(21+27)*i, 85, 21)];
        Pltitl.font = i == 0?[UIFont boldSystemFontOfSize:17]:[UIFont boldSystemFontOfSize:13];
        Pltitl.textAlignment = NSTextAlignmentCenter;
        Pltitl.textColor = [UIView colorFromRGB:0xFB3D4A];
        Pltitl.text = marAry[1];
        [contentView addSubview:Pltitl];
    }
    
    UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkboxButton.frame = CGRectMake(27.5, riLabel.bottom+125, contentView.width-55, 16);
    [checkboxButton setImage:[UIImage imageNamed:@"zonb"] forState:UIControlStateNormal];
    [checkboxButton setTitle:dic[@"casual"] forState:UIControlStateNormal];
    [checkboxButton setTitleColor:[UIView colorFromRGB:0xFB3D4A] forState:(UIControlStateNormal)];
    checkboxButton.titleLabel.font = [UIFont systemFontOfSize:12];
    checkboxButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:checkboxButton];
    
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = CGRectMake(52, checkboxButton.bottom+13, contentView.width-104, 40.5);
    [applyButton setTitle:dic[@"engagement"] forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"zonbuta"] forState:(UIControlStateNormal)];
    applyButton.userInteractionEnabled = NO;
    [contentView addSubview:applyButton];
    
}

-(void)setContViewDelay_2:(UIView*)contentView redius:(NSDictionary*)dic{
    UIImageView *AlloView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.frame), 222.5)];
    AlloView.image = [UIImage imageNamed:@"Delay_3"];
    [contentView addSubview:AlloView];
    
    UIView *whitV = [[UIView alloc]initWithFrame:CGRectMake(43, 19, 18, 18)];
    whitV.backgroundColor = [UIColor whiteColor];
    whitV.layer.cornerRadius = 9;
    [contentView addSubview:whitV];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(whitV.right+5, whitV.top, 70.5, 16.5)];
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = dic[@"marinate"];
    [contentView addSubview:titleLabel];
    
    UILabel *riLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+52, whitV.top, 100.5, 20.5)];
    riLabel.font = [UIFont boldSystemFontOfSize:14];
    riLabel.textColor = [UIColor whiteColor];
    riLabel.textAlignment = NSTextAlignmentCenter;
    riLabel.text = dic[@"fixing"];
    [contentView addSubview:riLabel];
    
    
    NSArray *ary = @[
        @[dic[@"aware"] ?: @"", dic[@"expectations"] ?: @""],
        @[dic[@"playfully"] ?: @"", dic[@"broached"] ?: @""]
    ];
    for (int i = 0; i<ary.count; i++) {
        NSArray *marAry = ary[i];
        UILabel *titl = [[UILabel alloc] initWithFrame:CGRectMake(43.5, riLabel.bottom+40+(21+27)*i, 180, 21)];
        titl.font = [UIFont systemFontOfSize:12];
        titl.textColor = [UIColor whiteColor];
        titl.text = marAry[0];
        [contentView addSubview:titl];
        
        UILabel *Pltitl = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width-98.5-15, riLabel.bottom+40+(21+27)*i, 85, 21)];
        Pltitl.font = i == 0?[UIFont boldSystemFontOfSize:17]:[UIFont boldSystemFontOfSize:13];
        Pltitl.textAlignment = NSTextAlignmentCenter;
        Pltitl.textColor = [UIView colorFromRGB:0xFB3D4A];
        Pltitl.text = marAry[1];
        [contentView addSubview:Pltitl];
    }
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = CGRectMake(52, riLabel.bottom+135, contentView.width-104, 40.5);
    [applyButton setTitle:dic[@"engagement"] forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"zonbuta"] forState:(UIControlStateNormal)];
    applyButton.userInteractionEnabled = NO;
    [contentView addSubview:applyButton];
    
}


-(void)setContViewDelay_3:(UIView*)contentView redius:(NSDictionary*)dic{
    UIImageView *AlloView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.frame), 168.5)];
    if([dic[@"fixing"] isEqualToString:@"Review"]){
        AlloView.image = [UIImage imageNamed:@"Delay_4"];
    }else{
        AlloView.image = [UIImage imageNamed:@"Delay_5"];
    }
    
    [contentView addSubview:AlloView];
    
    UIView *whitV = [[UIView alloc]initWithFrame:CGRectMake(43, 19, 18, 18)];
    whitV.backgroundColor = [UIColor whiteColor];
    whitV.layer.cornerRadius = 9;
    [contentView addSubview:whitV];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(whitV.right+5, whitV.top, 70.5, 16.5)];
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = dic[@"marinate"];
    [contentView addSubview:titleLabel];
    
    UILabel *riLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+52, whitV.top, 100.5, 20.5)];
    riLabel.font = [UIFont boldSystemFontOfSize:14];
    riLabel.textColor = [UIColor whiteColor];
    riLabel.textAlignment = NSTextAlignmentCenter;
    riLabel.text = dic[@"fixing"];
    [contentView addSubview:riLabel];
    
    
    NSArray *ary = @[
        @[dic[@"aware"] ?: @"", dic[@"expectations"] ?: @""],
        @[dic[@"playfully"] ?: @"", dic[@"broached"] ?: @""]
    ];
    for (int i = 0; i<ary.count; i++) {
        NSArray *marAry = ary[i];
        UILabel *titl = [[UILabel alloc] initWithFrame:CGRectMake(43.5, riLabel.bottom+35+(21+27)*i, 180, 21)];
        titl.font = [UIFont systemFontOfSize:12];
        titl.textColor = [UIColor whiteColor];
        titl.text = marAry[0];
        [contentView addSubview:titl];
        
        UILabel *Pltitl = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width-98.5-15, riLabel.bottom+35+(21+27)*i, 85, 21)];
        Pltitl.font = i == 0?[UIFont boldSystemFontOfSize:17]:[UIFont boldSystemFontOfSize:13];
        Pltitl.textAlignment = NSTextAlignmentCenter;
        Pltitl.textColor = [UIView colorFromRGB:0xFB3D4A];
        Pltitl.text = marAry[1];
        [contentView addSubview:Pltitl];
    }

}

- (void)setupEmptyView {
    // 空数据视图：先创建，避免网络监听回调未触发时页面始终不显示
    self.emptyView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.emptyView.backgroundColor = [UIColor clearColor];
    self.emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableView addSubview:self.emptyView];

    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.spacing = 10;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emptyView addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.emptyView.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.emptyView.centerYAnchor constant:-50],
        [stackView.leadingAnchor constraintEqualToAnchor:self.emptyView.leadingAnchor constant:20],
        [stackView.trailingAnchor constraintEqualToAnchor:self.emptyView.trailingAnchor constant:-20],
    ]];

    self.emptyIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apoli"]];
    self.emptyIconView.contentMode = UIViewContentModeScaleAspectFit;
    self.emptyIconView.translatesAutoresizingMaskIntoConstraints = NO;

    self.emptyTitleLabel = [[UILabel alloc] init];
    self.emptyTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyTitleLabel.numberOfLines = 1;
    self.emptyTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.emptyTitleLabel.textColor = [UIColor darkGrayColor];

    self.emptySubtitleLabel = [[UILabel alloc] init];
    self.emptySubtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.emptySubtitleLabel.numberOfLines = 2;
    self.emptySubtitleLabel.font = [UIFont systemFontOfSize:14];
    self.emptySubtitleLabel.textColor = [UIColor grayColor];

    self.emptyActionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.emptyActionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emptyActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 默认先给一个，后面会按网络状态切换（有网走绿色样式）
    [self.emptyActionButton setBackgroundImage:[UIImage imageNamed:@"applybg"] forState:UIControlStateNormal];
    self.emptyActionButton.layer.cornerRadius = 22; // 高度 44 的半圆角
    self.emptyActionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.emptyActionButton addTarget:self action:@selector(refreshButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [stackView addArrangedSubview:self.emptyIconView];
    [stackView addArrangedSubview:self.emptyTitleLabel];
    [stackView addArrangedSubview:self.emptySubtitleLabel];
    [stackView addArrangedSubview:self.emptyActionButton];

    // 尺寸约束（stackView 内）
    [NSLayoutConstraint activateConstraints:@[
        // 图2“清单夹”插画比例更像 120x120 的视觉大小
        [self.emptyIconView.widthAnchor constraintEqualToConstant:120],
        [self.emptyIconView.heightAnchor constraintEqualToConstant:120],
        [self.emptyActionButton.widthAnchor constraintEqualToConstant:217],
        [self.emptyActionButton.heightAnchor constraintEqualToConstant:44],
    ]];

    // 根据当前网络状态先初始化一次
    BOOL hasNetworkNow = [[NetworkManager sharedManager] isNetworkAvailable];
    if (hasNetworkNow) {
        self.emptyIconView.image = [UIImage imageNamed:@"emptypicon"];
        self.emptyTitleLabel.hidden = YES; // 只显示两行提示，匹配截图
        self.emptySubtitleLabel.text = @"There are currently no order\nrecords available";
        [self.emptyActionButton setTitle:@"Apply" forState:UIControlStateNormal];
        [self.emptyActionButton setBackgroundImage:[UIImage imageNamed:@"applybg"] forState:UIControlStateNormal];
    } else {
        self.emptyIconView.image = [UIImage imageNamed:@"apowkk"];
        self.emptyTitleLabel.hidden = NO;
        self.emptyTitleLabel.text = @"No network available";
        self.emptySubtitleLabel.text = @"Sorry, the page cannot be found";
        [self.emptyActionButton setTitle:@"Refresh It" forState:UIControlStateNormal];
        [self.emptyActionButton setBackgroundImage:[UIImage imageNamed:@"zonbuta"] forState:UIControlStateNormal];
    }

    // 监听网络变化时更新文案/按钮（空数据时可见）
    [NetworkManager startMonitoringNetworkStatusWithCallback:^(BOOL hasNetwork, NSString *networkType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.emptyView) return;
            if (hasNetwork) {
                self.emptyIconView.image = [UIImage imageNamed:@"emptypicon"];
                self.emptyTitleLabel.hidden = YES;
                self.emptySubtitleLabel.text = @"There are currently no order\nrecords available";
                [self.emptyActionButton setTitle:@"Apply" forState:UIControlStateNormal];
                [self.emptyActionButton setBackgroundImage:[UIImage imageNamed:@"applybg"] forState:UIControlStateNormal];
            } else {
                self.emptyIconView.image = [UIImage imageNamed:@"apowkk"];
                self.emptyTitleLabel.hidden = NO;
                self.emptyTitleLabel.text = @"No network available";
                self.emptySubtitleLabel.text = @"Sorry, the page cannot be found";
                [self.emptyActionButton setTitle:@"Refresh It" forState:UIControlStateNormal];
                [self.emptyActionButton setBackgroundImage:[UIImage imageNamed:@"zonbuta"] forState:UIControlStateNormal];
            }
        });
    }];
}

#pragma mark - 按钮点击事件
- (void)refreshButtonTapped:(UIButton*)sender {
    NSString *title = sender.currentTitle ?: @"";
    if([title isEqualToString:@"Apply"] || [title isEqualToString:@"Go AppLy"]){

        [self popToSpecificViewController:[HoPerController class]];
    }else{
        [self triggerRefreshProgrammatically];
    }
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
@end
