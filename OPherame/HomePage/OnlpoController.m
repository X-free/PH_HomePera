//
//  OnlpoController.m
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import "OnlpoController.h"
@implementation FAQItem

- (instancetype)initWithQuestion:(NSString *)question answer:(NSString *)answer {
    self = [super init];
    if (self) {
        _question = question;
        _answer = answer;
        _isExpanded = YES; // 默认全部展开
    }
    return self;
}

@end

@interface OnlpoController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<FAQItem *> *faqItems;

@end

@implementation OnlpoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Online service";
    self.customTitleColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"kllkp"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
    
    
    
    UIImageView *receiveing = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kbanm"]];
    receiveing.frame = CGRectMake(8, [UIView navigationBarHeight]+[UIView statusBarHeight]+34, self.view.width-16, 411);
    receiveing.userInteractionEnabled = YES;
    [self.view addSubview:receiveing];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, receiveing.top+5, (self.view.width-62*2), 20)];
    titleLabel.text = @"Frequently asked questionsd";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.view addSubview:titleLabel];
    
    
    
    // 初始化数据
    [self setupData];
    
    // 设置表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, 63, receiveing.width-32, receiveing.height-63-28) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 60;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [receiveing addSubview:self.tableView];
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FAQCell"];
    
    

        
       
    
}

- (void)setupData {
    self.faqItems = @[
            [[FAQItem alloc] initWithQuestion:@"1. What is Credit Peso ?"
                                     answer:@"Credit Peso is a personal loan app designed with flexible loan options to meet various financial needs."],
            [[FAQItem alloc] initWithQuestion:@"2. How much can I borrow?"
                                     answer:@"You can borrow between P30,000 and P86,000 depending on your eligibility and financial needs."],
            [[FAQItem alloc] initWithQuestion:@"3. How long does it take to get approved?"
                                     answer:@"Approval is typically fast, often within minutes of submitting your application."],
            [[FAQItem alloc] initWithQuestion:@"4. When will I receive my funds?"
                                     answer:@"Once approved, the loan will be transferred directly to your bank account, usually within hours."]
        ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.faqItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FAQCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FAQItem *item = self.faqItems[indexPath.row];
    
    // 清除旧内容
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 创建问题标签 - 始终显示
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.text = item.question;
    questionLabel.font = [UIFont boldSystemFontOfSize:16];
    questionLabel.numberOfLines = 0;
    questionLabel.textColor = [UIView colorFromRGB:0xFF718E];
    [cell.contentView addSubview:questionLabel];
    
    // 添加箭头图标
    NSString *arrowImageName = item.isExpanded ? @"arrow_up" : @"arrow_down";
    UIImageView *arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrowImageName]];
    arrowIcon.tintColor = [UIColor grayColor];
    [cell.contentView addSubview:arrowIcon];
    
    // 只在展开时显示答案
    if (item.isExpanded) {
        UILabel *answerLabel = [[UILabel alloc] init];
        answerLabel.text = item.answer;
        answerLabel.font = [UIFont systemFontOfSize:14];
        answerLabel.textColor = [UIColor grayColor];
        answerLabel.numberOfLines = 0;
        [cell.contentView addSubview:answerLabel];
        
        // 设置约束（展开状态）
        questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        answerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        arrowIcon.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
            // 问题标签约束
            [questionLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:15],
            [questionLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
            [questionLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-30],
            
            // 答案标签约束
            [answerLabel.topAnchor constraintEqualToAnchor:questionLabel.bottomAnchor constant:8],
            [answerLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
            [answerLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
            [answerLabel.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-15],
            
            // 箭头图标约束
            [arrowIcon.centerYAnchor constraintEqualToAnchor:questionLabel.centerYAnchor],
            [arrowIcon.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
            [arrowIcon.widthAnchor constraintEqualToConstant:15],
            [arrowIcon.heightAnchor constraintEqualToConstant:15]
        ]];
    } else {
        // 设置约束（收起状态）
        questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        arrowIcon.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
            // 问题标签约束
            [questionLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:15],
            [questionLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
            [questionLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-30],
            [questionLabel.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-15],
            
            // 箭头图标约束
            [arrowIcon.centerYAnchor constraintEqualToAnchor:questionLabel.centerYAnchor],
            [arrowIcon.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
            [arrowIcon.widthAnchor constraintEqualToConstant:15],
            [arrowIcon.heightAnchor constraintEqualToConstant:15]
        ]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FAQItem *item = self.faqItems[indexPath.row];
    item.isExpanded = !item.isExpanded;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FAQItem *item = self.faqItems[indexPath.row];
    
    if (!item.isExpanded) {
        // 收起状态固定高度
        return 60;
    }
    
    // 展开状态自动计算高度
    return UITableViewAutomaticDimension;
}

@end
