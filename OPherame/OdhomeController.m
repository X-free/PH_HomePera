
//
//  OdhomeController.m
//  OPherame
//
//  Created by todesk on 2025/6/16.
//

#import "OdhomeController.h"

@interface OdhomeController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *homeView;
@property (nonatomic, strong) UIView *detailView;

@end

@implementation OdhomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置固定值
    self.cupersuchousB = 86000;
    self.cupersuchousC = 0.06;
    
    [self setupUI];
}

- (void)setupUI {
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // 创建公共视图
    [self setupHomeView];
    /*
    // 创建首页视图
    [self setupHomeView];
    
    // 创建详情视图
    [self setupDetailView];
    
    // 默认显示首页
    self.homeView.hidden = NO;
    self.detailView.hidden = YES;*/
}

#pragma mark - Home View (Left UI in the image)

- (void)setupHomeView {
    
    UIImage *image = [UIImage imageNamed:@"nlko"];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageHeight = screenWidth * (image.size.height / image.size.width);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1040)];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:backgroundImageView];
    
    // 设置滚动区域
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1040);
//    backgroundImageView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    /*
    self.homeView = [[UIView alloc] initWithFrame:CGRectMake(0, -70, self.view.frame.size.width, 1200)];
    [self.scrollView addSubview:self.homeView];
    
    
    UIImage *image = [UIImage imageNamed:@"nlko"];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//
//    // 计算等比例高度（不留空白）
//    CGFloat imageHeight = screenWidth * (image.size.height / image.size.width);
    // 蓝色背景
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.homeView.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"nlko"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.homeView addSubview:backgroundImageView];
    
    
    
    // 状态栏内容（时间，信号等）已在系统UI中显示
    
    // "Home Peru" 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 30)];
    titleLabel.text = @"Home Peru";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.homeView addSubview:titleLabel];
    
    // 右上角个人头像
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 45, 46, 46)];
    avatarImageView.image = [UIImage imageNamed:@"tcx"];
    avatarImageView.layer.cornerRadius = 20;
    avatarImageView.clipsToBounds = YES;
    [self.homeView addSubview:avatarImageView];
    
    // 贷款卡片
    [self setupLoanCardForHomeView];
    
    // 客服卡片
    [self setupCustomerServiceCard];
    
    // 身份认证卡片
    [self setupIdentityCard];
    
    // FAQ卡片
    [self setupFAQCard];
    
    // 底部贷款要求描述
    [self setupLoanRequirements];
    
    // 设置滚动区域
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);*/
}

- (void)setupLoanCardForHomeView {
    // 白色主卡片
    UIView *loanCardView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 396.5)];
   
    [self.homeView addSubview:loanCardView];
    
    UIImageView *redView = [[UIImageView alloc] initWithFrame:loanCardView.bounds];
    redView.image = [UIImage imageNamed:@"nblopd"];
    [loanCardView addSubview:redView];
    /*
    // 红色区域
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, loanCardView.frame.size.width, 130)];
    redView.backgroundColor = [UIColor colorWithRed:240/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
    redView.layer.cornerRadius = 20;
    redView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner; // 只有上方圆角
    [loanCardView addSubview:redView];
    
    // "Loan amount up to" 标签
    UILabel *loanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 20)];
    loanTitleLabel.text = @"Loan amount up to";
    loanTitleLabel.textColor = [UIColor whiteColor];
    loanTitleLabel.font = [UIFont systemFontOfSize:18];
    loanTitleLabel.textAlignment = NSTextAlignmentCenter;
    [redView addSubview:loanTitleLabel];
    
    // 贷款金额
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, redView.frame.size.width - 40, 50)];
    amountLabel.text = [NSString stringWithFormat:@"₱ %.0f", self.cupersuchousB];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.font = [UIFont boldSystemFontOfSize:40];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [redView addSubview:amountLabel];
    
    // 利率标签
    UIView *rateView = [[UIView alloc] initWithFrame:CGRectMake(20, 95, 90, 25)];
    rateView.backgroundColor = [UIColor colorWithRed:150/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    rateView.layer.cornerRadius = 12.5;
    [redView addSubview:rateView];
    
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    rateLabel.text = [NSString stringWithFormat:@"%.2f%%/day", self.cupersuchousC];
    rateLabel.textColor = [UIColor whiteColor];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.font = [UIFont systemFontOfSize:14];
    [rateView addSubview:rateLabel];
    
    // 天数标签
    UIView *daysView = [[UIView alloc] initWithFrame:CGRectMake(redView.frame.size.width - 100, 95, 80, 25)];
    daysView.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:180/255.0 alpha:0.8];
    daysView.layer.cornerRadius = 12.5;
    [redView addSubview:daysView];
    
    UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    daysLabel.text = @"150 days";
    daysLabel.textColor = [UIColor whiteColor];
    daysLabel.textAlignment = NSTextAlignmentCenter;
    daysLabel.font = [UIFont systemFontOfSize:14];
    [daysView addSubview:daysLabel];
    
    // Go按钮（黄金圆形）
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.frame = CGRectMake((loanCardView.frame.size.width - 80)/2, 100, 80, 80);
    goButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1.0];
    goButton.layer.cornerRadius = 40;
    goButton.layer.borderWidth = 5;
    goButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:180/255.0 alpha:1.0].CGColor;
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    goButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [goButton addTarget:self action:@selector(showDetailView) forControlEvents:UIControlEventTouchUpInside];
    [loanCardView addSubview:goButton];
    
    // 手指点击图标
    UIImageView *fingerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(goButton.frame.origin.x + 60, goButton.frame.origin.y + 60, 40, 40)];
    fingerImageView.image = [UIImage imageNamed:@"nblopd"]; // 手指图标
    [loanCardView addSubview:fingerImageView];
    
    // "Choose Us" 标签
    UILabel *chooseUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, loanCardView.frame.size.width, 30)];
    chooseUsLabel.text = @"Choose Us";
    chooseUsLabel.textAlignment = NSTextAlignmentCenter;
    chooseUsLabel.textColor = [UIColor brownColor];
    chooseUsLabel.font = [UIFont boldSystemFontOfSize:18];
    [loanCardView addSubview:chooseUsLabel];
    
    // 装饰性线条
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(50, 205, 40, 1)];
    leftLine.backgroundColor = [UIColor lightGrayColor];
    [loanCardView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(loanCardView.frame.size.width - 90, 205, 40, 1)];
    rightLine.backgroundColor = [UIColor lightGrayColor];
    [loanCardView addSubview:rightLine];
    
    // 菱形装饰
    UILabel *leftDiamond = [[UILabel alloc] initWithFrame:CGRectMake(30, 195, 20, 20)];
    leftDiamond.text = @"◇";
    leftDiamond.textColor = [UIColor brownColor];
    leftDiamond.textAlignment = NSTextAlignmentCenter;
    [loanCardView addSubview:leftDiamond];
    
    UILabel *rightDiamond = [[UILabel alloc] initWithFrame:CGRectMake(loanCardView.frame.size.width - 50, 195, 20, 20)];
    rightDiamond.text = @"◇";
    rightDiamond.textColor = [UIColor brownColor];
    rightDiamond.textAlignment = NSTextAlignmentCenter;
    [loanCardView addSubview:rightDiamond];
    
    // 底部三个特性框
    CGFloat featureWidth = (loanCardView.frame.size.width - 40) / 3;
    NSArray *titles = @[@"7x24", @"0", @"99.6%"];
    NSArray *subtitles = @[@"hours loan", @"mortgage", @"Approval Rate"];
    NSArray *images = @[@"biibi", @"gogre", @"grebb"]; // 使用home1文件夹中的图标
    
    for (int i = 0; i < 3; i++) {
        UIView *featureView = [[UIView alloc] initWithFrame:CGRectMake(20 + i * featureWidth, 220, featureWidth - 10, 50)];
        featureView.backgroundColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        featureView.layer.cornerRadius = 10;
        [loanCardView addSubview:featureView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, featureWidth - 10, 20)];
        titleLabel.text = titles[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = i == 0 ? [UIColor redColor] : (i == 1 ? [UIColor orangeColor] : [UIColor redColor]);
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [featureView addSubview:titleLabel];
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, featureWidth - 10, 20)];
        subtitleLabel.text = subtitles[i];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.textColor = [UIColor darkGrayColor];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        [featureView addSubview:subtitleLabel];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((featureWidth - 30)/2, featureView.frame.size.height + 5, 30, 30)];
        iconView.image = [UIImage imageNamed:images[i]];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [loanCardView addSubview:iconView];
    }*/
}

- (void)setupCustomerServiceCard {
    UIImageView *serviceCardView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 475, self.view.frame.size.width - 40, 124)];
    serviceCardView.image = [UIImage imageNamed:@"kefubh"]; // 客服图标
    
    [self.homeView addSubview:serviceCardView];
    
   
}

- (void)setupIdentityCard {
    UIImageView *identityView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 540+75, self.view.frame.size.width - 40, 90)]; // 增加高度以显示完整内容
    identityView.image = [UIImage imageNamed:@"grebb"];
    
    [self.homeView addSubview:identityView];
    
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
    [identityView addSubview:goButton];
}

- (void)setupFAQCard {
    UIImageView *faqView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 646+75, self.view.frame.size.width - 40, 90)]; // 调整Y坐标
    faqView.image = [UIImage imageNamed:@"redgbb"];
    [self.homeView addSubview:faqView];
    
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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1; // 行间距 10pt

    // 创建 NSAttributedString
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
    };

    faqDesc.attributedText = [[NSAttributedString alloc] initWithString:@"These questions will help you get to know us better" attributes:attributes];
    
    // Go按钮
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.frame = CGRectMake(faqView.frame.size.width - 99.5, 27.5, 79.5, 35);
    [goButton setBackgroundImage:[UIImage imageNamed:@"gored"] forState:(UIControlStateNormal)];
    goButton.layer.cornerRadius = 35/2;
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    [faqView addSubview:goButton];
}

- (void)setupLoanRequirements {
    // "Loan requirements Description" 分隔线
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(60, 670, self.view.frame.size.width - 120, 1)]; // 调整Y坐标
    separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [self.homeView addSubview:separatorView];
    
    UILabel *requirementsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 660, self.view.frame.size.width, 20)]; // 调整Y坐标
    requirementsTitle.text = @"Loan requirements Description";
    requirementsTitle.textColor = [UIColor whiteColor];
    requirementsTitle.textAlignment = NSTextAlignmentCenter;
    requirementsTitle.font = [UIFont systemFontOfSize:14];
    [self.homeView addSubview:requirementsTitle];
    
    // 贷款要求详细说明
    UILabel *requirementsDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, 680, self.view.frame.size.width - 40, 100)];
    requirementsDesc.text = @"You must be an adult and over 18 years old... Having a personal phone number, need to tie to 10 contacts minimum, bank card, government... Having a personal payment account... Loans with good repayment...";
    requirementsDesc.textColor = [UIColor whiteColor];
    requirementsDesc.font = [UIFont systemFontOfSize:13];
    requirementsDesc.numberOfLines = 0;
    [self.homeView addSubview:requirementsDesc];
}

#pragma mark - Detail View (Right UI in the image)

- (void)setupDetailView {
    self.detailView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.detailView.hidden = YES;
    [self.scrollView addSubview:self.detailView];
    
    // 蓝色背景
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImageView.image = [UIImage imageNamed:@"nlko"];//使用与首页相同的背景图片
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.detailView addSubview:backgroundImageView];
    
    // "Home Peru" 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 30)];
    titleLabel.text = @"Home Peru";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.detailView addSubview:titleLabel];
    
    // 右上角个人头像
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 45, 40, 40)];
    avatarImageView.image = [UIImage imageNamed:@"tcx"]; // 使用与首页相同的头像
    avatarImageView.layer.cornerRadius = 20;
    avatarImageView.clipsToBounds = YES;
    [self.detailView addSubview:avatarImageView];
    
    // 贷款卡片
    [self setupLoanCardForDetailView];
    
    // 订单提示条
    [self setupOrderTip];
    
    // 推荐产品标题栏
    [self setupRecommendedTitle];
    
    // 推荐产品列表
    [self setupRecommendedProducts];
    
    // 设置滚动区域
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1140);
}

- (void)setupLoanCardForDetailView {
    // 白色卡片
    UIView *loanCardView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 140)];
    loanCardView.backgroundColor = [UIColor whiteColor];
    loanCardView.layer.cornerRadius = 15;
    loanCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    loanCardView.layer.shadowOffset = CGSizeMake(0, 2);
    loanCardView.layer.shadowOpacity = 0.1;
    [self.detailView addSubview:loanCardView];
    
    // 红色背景区域
    UIView *redBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, loanCardView.frame.size.width, 100)];
    redBgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
    redBgView.layer.cornerRadius = 15;
    redBgView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [loanCardView addSubview:redBgView];
    
    // "Loan amount up to" 标签
    UILabel *loanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 20)];
    loanTitleLabel.text = @"Loan amount up to";
    loanTitleLabel.textColor = [UIColor whiteColor];
    loanTitleLabel.font = [UIFont systemFontOfSize:14];
    [redBgView addSubview:loanTitleLabel];
    
    // 贷款金额
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 180, 40)];
    amountLabel.text = [NSString stringWithFormat:@"₱ %.0f", self.cupersuchousB];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.font = [UIFont boldSystemFontOfSize:32];
    [redBgView addSubview:amountLabel];
    
    // 150天标签（粉红色背景）
    UIView *daysView = [[UIView alloc] initWithFrame:CGRectMake(redBgView.frame.size.width - 80, 15, 60, 25)];
    daysView.backgroundColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0];
    daysView.layer.cornerRadius = 12.5;
    [redBgView addSubview:daysView];
    
    UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    daysLabel.text = @"150 days";
    daysLabel.textColor = [UIColor whiteColor];
    daysLabel.textAlignment = NSTextAlignmentCenter;
    daysLabel.font = [UIFont systemFontOfSize:12];
    [daysView addSubview:daysLabel];
    
    // 利率标签
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(redBgView.frame.size.width - 80, 50, 60, 20)];
    rateLabel.text = [NSString stringWithFormat:@"%.2f%%/day", self.cupersuchousC];
    rateLabel.textColor = [UIColor whiteColor];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.font = [UIFont systemFontOfSize:14];
    [redBgView addSubview:rateLabel];
    
    // "Go to Loan"按钮
    UIButton *goToLoanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goToLoanButton.frame = CGRectMake((loanCardView.frame.size.width - 120) / 2, 110, 120, 30);
    goToLoanButton.backgroundColor = [UIColor orangeColor];
    goToLoanButton.layer.cornerRadius = 15;
    [goToLoanButton setTitle:@"Go to Loan" forState:UIControlStateNormal];
    [goToLoanButton addTarget:self action:@selector(showHomeView) forControlEvents:UIControlEventTouchUpInside];
    [loanCardView addSubview:goToLoanButton];
}

- (void)setupOrderTip {
    UIView *orderTipView = [[UIView alloc] initWithFrame:CGRectMake(20, 260, self.view.frame.size.width - 40, 30)];
    orderTipView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    orderTipView.layer.cornerRadius = 15;
    [self.detailView addSubview:orderTipView];
    
    UILabel *orderTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, orderTipView.frame.size.width - 70, 30)];
    orderTipLabel.text = @"Your order is overdue, please pay as soon as possible";
    orderTipLabel.textColor = [UIColor darkGrayColor];
    orderTipLabel.font = [UIFont systemFontOfSize:12];
    [orderTipView addSubview:orderTipLabel];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(orderTipView.frame.size.width - 40, 5, 20, 20);
    messageButton.backgroundColor = [UIColor whiteColor];
    messageButton.layer.cornerRadius = 10;
    [orderTipView addSubview:messageButton];
}

- (void)setupRecommendedTitle {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 310, self.view.frame.size.width, 40)];
    titleView.backgroundColor = [UIColor colorWithRed:240/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
    [self.detailView addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 40)];
    titleLabel.text = @"Recommended products";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [titleView addSubview:titleLabel];
}

- (void)setupRecommendedProducts {
    UIView *productsView = [[UIView alloc] initWithFrame:CGRectMake(20, 360, self.view.frame.size.width - 40, 280)];
    productsView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    productsView.layer.cornerRadius = 10;
    [self.detailView addSubview:productsView];
    
    // 添加推荐产品
    NSArray *productIcons = @[@"recprobb", @"recprocc", @"recprodd"];
    CGFloat itemHeight = 80;
    CGFloat spacing = 10;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(10, 10 + i * (itemHeight + spacing), productsView.frame.size.width - 20, itemHeight)];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.layer.cornerRadius = 10;
        
        // 产品图标
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
        iconView.image = [UIImage imageNamed:productIcons[i]];
        iconView.layer.cornerRadius = 20;
        iconView.clipsToBounds = YES;
        [itemView addSubview:iconView];
        
        // 产品名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 120, 25)];
        nameLabel.text = @"Home Peru";
        nameLabel.font = [UIFont systemFontOfSize:16];
        [itemView addSubview:nameLabel];
        
        // "Loan Amount"标签
        UILabel *loanAmountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 80, 20)];
        loanAmountTitleLabel.text = @"Loan Amount";
        loanAmountTitleLabel.font = [UIFont systemFontOfSize:12];
        loanAmountTitleLabel.textColor = [UIColor grayColor];
        [itemView addSubview:loanAmountTitleLabel];
        
        // 贷款金额
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 40, 100, 20)];
        amountLabel.text = [NSString stringWithFormat:@"₱ %.0f", self.cupersuchousB];
        amountLabel.font = [UIFont boldSystemFontOfSize:14];
        [itemView addSubview:amountLabel];
        
        // "Apply now"按钮
        UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        applyButton.frame = CGRectMake(itemView.frame.size.width - 90, 20, 80, 40);
        applyButton.backgroundColor = [UIColor orangeColor];
        applyButton.layer.cornerRadius = 20;
        [applyButton setTitle:@"Apply now" forState:UIControlStateNormal];
        applyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [itemView addSubview:applyButton];
        
        [productsView addSubview:itemView];
    }
}

- (void)showDetailView {
    self.homeView.hidden = YES;
    self.detailView.hidden = NO;
}

- (void)showHomeView {
    self.homeView.hidden = NO;
    self.detailView.hidden = YES;
}

@end
