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



@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray<UIButton *> *buttons; // 存储所有按钮

@property (nonatomic, strong) NSString *thuds;//状态 4全部 7进行中 6待还款 5已结清

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (strong, nonatomic) UIView *emptyView;
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
    
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(8, [UIView navigationBarHeight]+[UIView statusBarHeight]+20, self.view.width-16, self.view.height-[UIView navigationBarHeight]-[UIView statusBarHeight]-20-88)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 16;
    [self.view addSubview:self.containerView];
    
    UIImageView *receiveing = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wekolmj"]];
    receiveing.frame = CGRectMake(1, -11, self.containerView.width-96, 41);
    [self.containerView addSubview:receiveing];
    
    UIImageView *madib = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenbuks"]];
    madib.frame = CGRectMake(receiveing.right-11, -41, self.containerView.width-receiveing.right+6, 90);
    [self.containerView addSubview:madib];
    
    
    CGFloat buttonWidth = (self.containerView.width - 50) / 4; // 计算按钮宽度（左右间距 10，按钮间距 10）
    CGFloat buttonHeight = 110.5;
    CGFloat startX = 9; // 起始 X 坐标
        
    NSArray *buttonTitles = @[@"All", @"In progress", @"Repayment", @"Completed"];
    NSMutableArray *buttons = [NSMutableArray array];
    for (int i = 0; i < buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(startX + i * (buttonWidth + 10), 0, buttonWidth, buttonHeight);
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"xnomttout"] forState:(UIControlStateNormal)];
        [button setBackgroundImage:[UIImage imageNamed:@"xseltout"] forState:(UIControlStateSelected)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        button.tag = i+1; // 设置 tag 用于区分按钮
        button.selected = i == 0?YES:NO;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(67.5, 0, 0, 0)];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView insertSubview:button atIndex:0];
        [buttons addObject:button];
    }
    self.buttons = buttons.copy; // 存储所有按钮
    
    self.thuds = @"4";
    
    
    
    
    // 创建表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(19, buttonHeight+20, self.containerView.width-38, self.containerView.height-130.5) style:UITableViewStyleGrouped];
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
    // 遍历所有按钮，取消选中状态
        for (UIButton *button in self.buttons) {
            button.selected = NO;
            // 恢复默认背景色
            [button setBackgroundImage:[UIImage imageNamed:@"xnomttout"] forState:(UIControlStateNormal)];
            
        }
        
    // 选中当前按钮
    sender.selected = YES;
     // 选中背景色
    [sender setBackgroundImage:[UIImage imageNamed:@"xseltout"] forState:(UIControlStateSelected)];
    
    
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
    
    NSArray*ary = @[@[dic[@"aware"],dic[@"expectations"]],@[dic[@"playfully"],dic[@"broached"]]];
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
    
    
    NSArray*ary = @[@[dic[@"aware"],dic[@"expectations"]],@[dic[@"playfully"],dic[@"broached"]]];
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
    
    
    NSArray*ary = @[@[dic[@"aware"],dic[@"expectations"]],@[dic[@"playfully"],dic[@"broached"]]];
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

    // 检查网络状态
    [NetworkManager startMonitoringNetworkStatusWithCallback:^(BOOL hasNetwork, NSString *networkType) {
        NSArray *ary;
        if (hasNetwork) {
            ary = @[@"apoli",@"No orders yet",@"There are currently no order \nrecords available",@"Apply"];
        }else{
            ary = @[@"apowkk",@"No network available",@"Sorry, the page cannot be found",@"Refresh It"];
        }
        
        // 创建容器视图
        self.emptyView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        self.emptyView.backgroundColor = [UIColor clearColor];
        self.emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 创建内容容器（方便居中布局）
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.emptyView addSubview:contentView];
        
        // 添加图标
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ary[0]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:imageView];
        
        // 添加主标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = ary[1];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:titleLabel];
        
        // 添加副标题（两行）
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.text = ary[2];
        subtitleLabel.textColor = [UIColor grayColor];
        subtitleLabel.font = [UIFont systemFontOfSize:14];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.numberOfLines = 2;
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:subtitleLabel];
        
        // 添加刷新按钮
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [refreshButton setTitle:ary[3] forState:UIControlStateNormal];
        [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refreshButton setBackgroundImage:[UIImage imageNamed:@"zonbuta"] forState:(UIControlStateNormal)];
        refreshButton.layer.cornerRadius = 6;
        refreshButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
        [refreshButton addTarget:self action:@selector(refreshButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:refreshButton];
        
        // 设置约束
        [NSLayoutConstraint activateConstraints:@[
            // 内容容器居中
            [contentView.centerXAnchor constraintEqualToAnchor:self.emptyView.centerXAnchor],
            [contentView.centerYAnchor constraintEqualToAnchor:self.emptyView.centerYAnchor constant:-50], // 稍微上移
            
            // 图标
            [imageView.topAnchor constraintEqualToAnchor:contentView.topAnchor],
            [imageView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
            [imageView.widthAnchor constraintEqualToConstant:100],
            [imageView.heightAnchor constraintEqualToConstant:100],
            
            // 主标题
            [titleLabel.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:20],
            [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
            [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
            
            // 副标题
            [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
            [subtitleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
            [subtitleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
            
            // 按钮
            [refreshButton.topAnchor constraintEqualToAnchor:subtitleLabel.bottomAnchor constant:25],
            [refreshButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
            [refreshButton.widthAnchor constraintEqualToConstant:217],
            [refreshButton.heightAnchor constraintEqualToConstant:44],
            [refreshButton.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor] // 确保contentView高度正确
        ]];
        
        // 初始隐藏
        self.emptyView.hidden = YES;
        [self.tableView addSubview:self.emptyView];
    }];
    
    
   
}

#pragma mark - 按钮点击事件
- (void)refreshButtonTapped:(UIButton*)sender {
    if([sender.currentTitle isEqualToString:@"Go AppLy"]){

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
