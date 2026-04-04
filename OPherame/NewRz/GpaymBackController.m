//
//  GpaymBackController.m
//  OPherame
//
//  Created by todesk on 2025/6/28.
//

#import "GpaymBackController.h"
#import "EKMGPopupView.h"
@interface GpaymBackController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,OPhNavigationBackButtonDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *reqArray;
@property (nonatomic, strong) NSArray *dataArray;



@property (nonatomic, strong) NSMutableDictionary *inputEwalletValues; // 存储用户输入的值
@property (nonatomic, strong) NSMutableDictionary *inputBankValues;

//@property (nonatomic, strong) NSMutableDictionary *imEwalletitations;
//@property (nonatomic, strong) NSMutableDictionary *imBankitations;

@property (nonatomic, assign) CGFloat originalContainerHeight; // 原始容器高度
@property (nonatomic, strong) UIView *containerView;


@property (strong, nonatomic) UIButton *EwalletBut;
@property (strong, nonatomic) UIButton *BankBut;
@property (assign, nonatomic) NSInteger buttonTag;

@property (nonatomic, strong) NSString *Ewalletimitation;
@property (nonatomic, strong) NSString *Bankimitation;



@property (nonatomic, strong) NSString *startTime;
@end

@implementation GpaymBackController

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
    
    UIButton *EwalletBut = [UIButton buttonWithType:UIButtonTypeSystem];
    EwalletBut.frame = CGRectMake(15, [UIView navigationBarHeight]+[UIView statusBarHeight]+20, 140, 50);
    
    [EwalletBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    EwalletBut.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [EwalletBut setBackgroundImage:[UIImage imageNamed:@"mddrsel"] forState:(UIControlStateNormal)];
    EwalletBut.tag = 1;
    [EwalletBut addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.EwalletBut = EwalletBut;
    [self.view addSubview:EwalletBut];
    
    UIButton *BankBut = [UIButton buttonWithType:UIButtonTypeSystem];
    BankBut.frame = CGRectMake(EwalletBut.right+23, [UIView navigationBarHeight]+[UIView statusBarHeight]+20, 140, 50);
    [BankBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    BankBut.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [BankBut setBackgroundImage:[UIImage imageNamed:@"mddrorn"] forState:(UIControlStateNormal)];
    BankBut.tag = 2;
    [BankBut addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.BankBut = BankBut;
    [self.view addSubview:BankBut];
    
    // 初始化状态
    self.buttonTag = 0;
    [self updateButtonColors];
    
    self.startTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(8, BankBut.bottom+22, self.view.width-16, 300)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 16;
    [self.view addSubview:self.containerView];
  
    [[NetworkManager sharedManager] POST:@"/radiating/researching"
                              parameters:@{@"tosa":@"0",@"impressive":[RandomStringGenerator randomlyCallMethod]}
                                 headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            self.reqArray = responseObject[@"thump"][@"haru"];
            self.dataArray = self.reqArray[self.buttonTag][@"haru"];
            [EwalletBut setTitle:responseObject[@"thump"][@"haru"][0][@"downright"] forState:UIControlStateNormal];
            [BankBut setTitle:responseObject[@"thump"][@"haru"][1][@"downright"] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
    
    
    self.originalContainerHeight = 300; // 默认高度
    
    self.inputEwalletValues = [NSMutableDictionary dictionary];
    self.inputBankValues  = [NSMutableDictionary dictionary];
    
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
    self.tableView.rowHeight = 62.5;

    
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


- (void)buttonTapped:(UIButton *)sender {
    // 根据点击的按钮更新状态
    self.buttonTag = sender.tag-1;
    [self updateButtonColors];
    self.dataArray = self.reqArray[self.buttonTag][@"haru"];
    [self.tableView reloadData];
}

- (void)updateButtonColors {
    // 定义选中和未选中的颜色
//    UIColor *selectedColor = [UIColor blueColor];
//    UIColor *normalColor = [UIColor lightGrayColor];
    
    UIImage *selectedImage = [UIImage imageNamed:@"mddrsel"];
    UIImage *normalImage = [UIImage imageNamed:@"mddrorn"];
    
    // 更新按钮1颜色
//    self.EwalletBut.backgroundColor = self.buttonTag == 0 ? selectedColor : normalColor;
    [self.EwalletBut setBackgroundImage:self.buttonTag == 0 ? selectedImage : normalImage forState:(UIControlStateNormal)];
    [self.EwalletBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 更新按钮2颜色
//    self.BankBut.backgroundColor = self.buttonTag  == 1 ? selectedColor : normalColor;
    [self.BankBut setBackgroundImage:self.buttonTag == 1 ? selectedImage : normalImage forState:(UIControlStateNormal)];
    [self.BankBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)confirmButtonTapped{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.inputEwalletValues.count != 0 && self.buttonTag == 0) {
        [parameters addEntriesFromDictionary:self.inputEwalletValues];
        parameters[@"paused"] = self.Ewalletimitation;
        
    }else if (self.inputBankValues.count != 0 && self.buttonTag == 1){
        [parameters addEntriesFromDictionary:self.inputBankValues];
        parameters[@"paused"] = self.Bankimitation;
    }
    
    
     
    
    [parameters addEntriesFromDictionary:@{@"harukos":self.harukos,@"vegetable":[NSString stringWithFormat:@"%ld",self.buttonTag+1],@"trace":[RandomStringGenerator randomlyCallMethod]}];
    
    [[NetworkManager sharedManager] POST:@"/radiating/mealsthe"
                              parameters:parameters
                                 headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.startTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
               
                [self cradiatingButtonTomomi];
            });
            
            
            
            NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
            mutbdic[@"moneys"] = self.startTime;
            mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
            mutbdic[@"bill"] = @"8";
            
            [self locaRadiatingPermis:mutbdic Completion:nil];
            
            
//            [self locaRadiatingPermis:mutbdic Completion:^(NSString *bill) {
//                if([bill isEqualToString:@"8"]){
////                    self.startTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
////                    [self cradiatingButtonTomomi];
//                }
//            }];
            
          
            
            
            
            
            
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
}

-(void)cradiatingButtonTomomi{
    
    
    [[NetworkManager sharedManager] POST:@"/radiating/tomomi"
                              parameters:@{@"harukos": self.harukos,@"bygone":[RandomStringGenerator randomlyCallMethod], @"riveted": [RandomStringGenerator randomlyCallMethod]}
                                headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            
            
            
            
            self.flipped = responseObject[@"thump"][@"scary"][@"flipped"];
            NSDictionary *species = responseObject[@"thump"][@"species"];
            if(species == nil){
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

-(void)cradiatingflipped{
    
    //开始时间
    NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
    mutbdic[@"moneys"] = self.startTime;
    
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
                mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
                
                WKWebViewController *webVC = [[WKWebViewController alloc] initWithURLString:shiny];
                webVC.themeColor = [UIView colorFromRGB:0x3D6AFF];
                webVC.harukos = self.harukos;
                
                [self.navigationController pushViewController:webVC animated:YES];

                [self locaRadiatingPermis:mutbdic Completion:^(NSString *bill) {
                }];
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
        if(finalHeight>460){
            finalHeight = 460;
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
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+5, CGRectGetWidth(tableView.frame), 33)];
        textField.tag = 101;
        textField.font = [UIFont systemFontOfSize:13];
        textField.delegate = self;
        textField.backgroundColor = [UIView colorFromRGB:0xF8F8F8];
        textField.layer.cornerRadius = 4;
        [cell.contentView addSubview:textField];
        
        // 设置左边间距
        UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 33)];
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
    
    //输入框类型 键盘类型，输入框需要用到（0 为全键盘，1 为数字键盘）
    if ([item[@"bells"] isEqualToNumber:@1]){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        textField.keyboardType = UIKeyboardTypeDefault;
    }
    
    // 恢复已输入的值
    NSString *key = item[@"heavy"];//[NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    NSMutableDictionary *concDic = self.buttonTag == 0?self.inputEwalletValues:self.inputBankValues;
    if (concDic[key]) {
        textField.text = concDic[key];
    } else {
        if(item[@"haruko"]){
            textField.text = item[@"haruko"];
            if (![item[@"staff"] isEqualToString:@"cupersuchousN"]) {
                
                if(self.buttonTag == 0){
                    self.Ewalletimitation = item[@"imitation"];
                }else{
                    self.Bankimitation = item[@"imitation"];
                }
            }
            
            if(self.buttonTag == 0){
                self.inputEwalletValues[key] = item[@"haruko"];
            }else{
                self.inputBankValues[key] = item[@"haruko"];
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
        UIView *rightContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 33)];
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
            
            if(self.buttonTag == 0){
                [self.inputEwalletValues setValue:ring[@"appreciating"] forKey:key];
                self.Ewalletimitation = ring[@"imitation"];
            }else{

                [self.inputBankValues setValue:ring[@"appreciating"] forKey:key];
                self.Bankimitation = ring[@"imitation"];
            }
            
            
            
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
                
                NSString *addreess;
                if(self.buttonTag == 0){
                    addreess = self.inputEwalletValues[key];
                }else{

                    addreess = self.inputBankValues[key];
                }
                
                [EKMGPopupView showWithTitle:item[@"downright"] isComper:NO addreess:addreess?:nil  mainOptions:response[@"thump"][@"jiju"] confirmAction:^(NSObject * _Nullable obj) {
                    
                    if(self.buttonTag == 0){
                        [self.inputEwalletValues setValue:[(NSArray*)obj componentsJoinedByString:@"-"] forKey:key];
                    }else{
    
                        [self.inputBankValues setValue:[(NSArray*)obj componentsJoinedByString:@"-"] forKey:key];
                    }
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
    
    if(self.buttonTag == 0){
        self.inputEwalletValues[key] = textField.text;
    }else{
        self.inputBankValues[key] = textField.text;
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



-(void)locaRadiatingPermis:(NSMutableDictionary*)permis Completion:(void (^)(NSString *bill))completion{
    
//    @"bill": @"8",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
        
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        
        NSDictionary *medis = @{
            @"centimetre": self.harukos,   // 产品ID
            
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
                if (completion) {
                        completion(permis[@"bill"]);
                    }
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
        
    });
}

@end
