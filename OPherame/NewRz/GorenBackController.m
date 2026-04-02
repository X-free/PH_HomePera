//
//  GorenBackController.m
//  OPherame
//
//  Created by todesk on 2025/6/27.
//

#import "GorenBackController.h"
#import "EKMGPopupView.h"
#import "GworkBackController.h"
#import "GtxlplBackController.h"
#import "GpaymBackController.h"
@interface GorenBackController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,OPhNavigationBackButtonDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *inputValues; // 存储用户输入的值
@property (nonatomic, strong) NSMutableDictionary *imitations;

@property (nonatomic, assign) CGFloat originalContainerHeight; // 原始容器高度
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSString *startTime;
@end

@implementation GorenBackController

- (void)navigationBackButtonDidClick {
    // 执行返回前的操作...返回按钮被点击，可以在这里保存数据等操作
    [self.view endEditing:YES];
    
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
    
    self.startTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(8, [UIView navigationBarHeight]+[UIView statusBarHeight]+20, self.view.width-16, 300)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 16;
    [self.view addSubview:self.containerView];
  
    [[NetworkManager sharedManager] POST:@"/radiating/enough"
                              parameters:@{@"harukos":self.harukos}
                                 headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            self.dataArray = responseObject[@"thump"][@"haru"];
            [self.tableView reloadData];
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
    
    
    self.originalContainerHeight = 300; // 默认高度
    
    self.inputValues = [NSMutableDictionary dictionary];
    self.imitations = [NSMutableDictionary dictionary];
    // 创建表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 31, self.containerView.width-44, self.containerView.height-62) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.layer.cornerRadius = 16;
    [self.containerView addSubview:self.tableView];
    
    // 自动调整高度
    self.tableView.rowHeight = 80;

    
    // 监听表格内容变化
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    CGRect applyFrame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 302)/2.0, self.view.bounds.size.height - 80, 302, 54);

    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = applyFrame;
    [applyButton setTitle:@"Next" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [applyButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
    
}

-(void)confirmButtonTapped{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.inputValues.count != 0) {
        [parameters addEntriesFromDictionary:self.inputValues];
        if (self.imitations.count != 0) {
            
            // 找出需要替换的键值对
            NSSet *validKeysToReplace = [self.imitations keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                // 检查: 1. dict1包含此key 2. 新值有效
                return parameters[key] && obj && ![obj isKindOfClass:[NSNull class]] &&
                      (![obj isKindOfClass:[NSString class]] || [(NSString *)obj length] > 0);
            }];

            if ([validKeysToReplace count] > 0) {
                [validKeysToReplace enumerateObjectsUsingBlock:^(id key, BOOL *stop) {
                    parameters[key] = self.imitations[key];
                }];
                NSLog(@"替换后的 dict1: %@", parameters);
            } else {
                NSLog(@"没有有效的相同 key 可替换");
            }
            
            
        }
        
    }
    
    [parameters addEntriesFromDictionary:@{@"harukos":self.harukos,@"tosayama":[RandomStringGenerator randomlyCallMethod]}];
    
    [[NetworkManager sharedManager] POST:@"/radiating/least"
                              parameters:parameters
                                 headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
            NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
            mutbdic[@"moneys"] = self.startTime;
            mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
            [self locaRadiatingPermis:mutbdic];
            
            [self cradiatingButtonTomomi];
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
}

-(void)cradiatingButtonTomomi{
    
    
    //[self popToSpecificViewController:[FrequqesController class]];
    
    [[NetworkManager sharedManager] POST:@"/radiating/tomomi"
                              parameters:@{@"harukos": self.harukos,@"bygone":[RandomStringGenerator randomlyCallMethod], @"riveted": [RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
            NSDictionary *species = responseObject[@"thump"][@"species"];
            if ([species[@"pensive"] isEqualToString:@"cupersuchousH"]){

                GworkBackController *controller = [[GworkBackController alloc]init];
                controller.harukos = self.harukos;
                controller.navTitle = [species valueForKey:@"downright"];
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([species[@"pensive"] isEqualToString:@"cupersuchousI"]){
                GtxlplBackController *controller = [[GtxlplBackController alloc]init];
                controller.harukos = self.harukos;
                controller.navTitle = [species valueForKey:@"downright"];
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([species[@"pensive"] isEqualToString:@"cupersuchousL"]){
                GpaymBackController *controller = [[GpaymBackController alloc]init];
                controller.harukos = self.harukos;
                controller.navTitle = [species valueForKey:@"downright"];

                [self.navigationController pushViewController:controller animated:YES];
            }else if(species == nil){
                [self cradiatingflipped];
            }
            
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 计算表格所需高度
        CGFloat tableHeight = self.tableView.contentSize.height;
        
        // 计算容器最终高度（取最大值：原始高度或表格所需高度）
        CGFloat finalHeight = MAX(self.originalContainerHeight, tableHeight);
        if(finalHeight>500){
            finalHeight = 500;
        }
        
        // 更新容器和表格的frame
        CGRect containerFrame = self.containerView.frame;
        containerFrame.size.height = finalHeight+62;
        self.containerView.frame = containerFrame;
        
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = finalHeight;
        self.tableView.frame = tableFrame;
    }
}

- (void)dealloc {
    // 移除观察者
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EditableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 标题标签
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 24.5)];
        titleLabel.tag = 100;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        
        // 输入框/占位文本
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+5, UIScreen.mainScreen.bounds.size.width - 60, 40)];
        textField.tag = 101;
        textField.font = [UIFont systemFontOfSize:13];
        textField.delegate = self;
        textField.backgroundColor = [UIView colorFromRGB:0xF8F8F8];
        textField.layer.cornerRadius = 4;
        [cell.contentView addSubview:textField];
        
        // 设置左边间距
        UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
        textField.leftView = leftPadding;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    NSDictionary *item = self.dataArray[indexPath.row];

    // 配置标题
    UILabel *titleLabel = [cell.contentView viewWithTag:100];
    titleLabel.text = item[@"downright"];
    
    // 配置输入框/占位文本
    UITextField *textField = [cell.contentView viewWithTag:101];
    textField.placeholder = item[@"experienced"];
    if(item[@"haruko"]){
        textField.text = item[@"haruko"];
    }
    
    //输入框类型 键盘类型，输入框需要用到（0 为全键盘，1 为数字键盘）
    if ([item[@"bells"] isEqualToNumber:@1]){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        textField.keyboardType = UIKeyboardTypeDefault;
    }
    
    // 恢复已输入的值
    NSString *key = item[@"heavy"];//[NSString stringWithFormat:@"%ld", (long)indexPath.row];
    if (self.inputValues[key]) {
        //修改值
        textField.text = self.inputValues[key];
    } else {
        if(item[@"haruko"]){
            //获取值
            textField.text = item[@"haruko"];
            self.inputValues[key] = item[@"haruko"];
            if (![item[@"staff"] isEqualToString:@"cupersuchousN"]) {
                self.imitations[key] = item[@"imitation"];
            }
        }else{
            textField.text = @"";
        }
        
    }
    
    // 重置rightView防止重用问题
        textField.rightView = nil;
    // 根据是否可编辑设置样式
    if ([item[@"staff"] isEqualToString:@"cupersuchousN"]) {
        textField.userInteractionEnabled = YES;
        textField.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        
        
        textField.userInteractionEnabled = NO;
        textField.textColor = [UIColor blackColor];
        // 自定义 accessory view 调整箭头位置
        UIImage *arrowImage = [UIImage systemImageNamed:@"chevron.right"]; // iOS 13+
        UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowButton setImage:arrowImage forState:UIControlStateNormal];
        arrowButton.frame = CGRectMake(0, 0, 15, 15); // 调整大小
        arrowButton.userInteractionEnabled = NO;
        arrowButton.tintColor = [UIColor lightGrayColor];
        UIView *rightContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
        // 调整图标垂直居中
        CGFloat verticalOffset = (textField.frame.size.height - 15) / 2;
        arrowButton.frame = CGRectMake((30-15)/2, verticalOffset, 15, 15);
        [rightContainer addSubview:arrowButton];
        textField.rightView = rightContainer;
        textField.rightViewMode = UITextFieldViewModeAlways;
       
    }
    
    return cell;
}

// 或者使用UITableViewDelegate的方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES]; // 当用户开始滚动时收起键盘
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 21;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES]; // 收起键盘
    NSDictionary *item = self.dataArray[indexPath.row];
    NSString *key = item[@"heavy"];//[NSString stringWithFormat:@"%ld", (long)indexPath.row];
    if ([item[@"staff"] isEqualToString:@"cupersuchousM"]){
        //单选
        [EKMGPopupView showWithTitle:item[@"downright"] isComper:YES addreess:nil mainOptions:item[@"ring"] confirmAction:^(NSObject * _Nullable obj) {
            NSNumber *num = (NSNumber*)obj;
            NSDictionary *ring = [item[@"ring"] objectAtIndex:[num intValue]];
            [self.inputValues setValue:ring[@"appreciating"] forKey:key];
            [self.imitations setValue:ring[@"imitation"] forKey:key];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }else if ([item[@"staff"] isEqualToString:@"cupersuchousO"]){
        
        //地址选择
        [[NetworkManager sharedManager] GET:@"http://8.220.140.188:8083/blewapi/radiating/thumped" completion:^(NSDictionary *response, NSError *error) {
            if (error) {
                NSLog(@"请求失败: %@", error.localizedDescription);
                return;
            }
            // 处理返回的数据
            if([response[@"heavy"] isEqualToString:@"0"]){
                NSString *addreess = self.inputValues[key];
                [EKMGPopupView showWithTitle:item[@"downright"] isComper:NO addreess:addreess?:nil  mainOptions:response[@"thump"][@"jiju"] confirmAction:^(NSObject * _Nullable obj) {
                    
                    [self.inputValues setValue:[(NSArray*)obj componentsJoinedByString:@"-"] forKey:key];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                
            }
            
        }];
        
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 保存用户输入的值
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *item = self.dataArray[indexPath.row];
    NSString *key = item[@"heavy"];//[NSString stringWithFormat:@"%ld", (long)indexPath.row];
    self.inputValues[key] = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
    
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        
        NSDictionary *medis = @{
            @"centimetre": self.harukos,   // 产品ID
            @"bill": @"5",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
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



-(void)cradiatingflipped{
    
    //开始时间
    NSString *StartTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
    mutbdic[@"moneys"] = StartTime;
    mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
    mutbdic[@"bill"] = @"9";
    
    [[NetworkManager sharedManager] POST:@"/radiating/car"
                              parameters:@{@"concentration": self.flipped?:@"",@"koimari":[RandomStringGenerator randomlyCallMethod], @"lacquer": [RandomStringGenerator randomlyCallMethod],@"intervals":[RandomStringGenerator randomlyCallMethod],@"equal":[RandomStringGenerator randomlyCallMethod]}
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
                webVC.harukos = self.harukos;
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
@end
