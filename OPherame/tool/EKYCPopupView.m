//
//  EKYCPopupView.m
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import "EKYCPopupView.h"
#import "CameraAlbumManager.h"
#import "UIViewController+TopMost.h"
#import "EKMGPopupView.h"
#import "rlAutController.h"
#import "sfAutController.h"
@interface EKYCPopupView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) UIImageView *camepree;
@property (nonatomic, assign) UIImageView *camekop;


// 声明 textField 属性
@property (nonatomic, strong) UITextField *realNameField;
@property (nonatomic, strong) UITextField *idNumberField;
@property (nonatomic, strong) UITextField *birthdayField;



@end


@implementation EKYCPopupView {
    UIView *_backgroundView;
    UIView *_contentView;
    EKYCPopupConfirmBlock _confirmBlock;
    NSArray<NSString *> *_mainOptions;
    NSArray<NSString *> *_moreOptions;
    NSArray<NSString *> *_dataOptions;
    
    BOOL _allowSwitchCamera;
}

#pragma mark - Public Methods
+ (void)showWithTitle:(NSArray<NSString *> *)titles
          mainOptions:(NSArray<NSString *> *)mainOptions
          moreOptions:(NSArray<NSString *> *)moreOptions
         confirmTitle:(NSString *)confirmTitle
        confirmAction:(EKYCPopupConfirmBlock)confirmAction {
    
    EKYCPopupView *popup = [[EKYCPopupView alloc] init];
    [popup setupUIWithTitle:titles mainOptions:mainOptions moreOptions:moreOptions confirmTitle:confirmTitle];
    popup->_confirmBlock = confirmAction;
    popup->_moreOptions = moreOptions;
    [popup show];
}

+ (void)dismiss {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:[EKYCPopupView class]]) {
            [(EKYCPopupView *)subview hide];
            break;
        }
    }
}

#pragma mark - UI Setup
- (void)setupUIWithTitle:(NSArray<NSString *> *)titles
            mainOptions:(NSArray<NSString *> *)mainOptions
            moreOptions:(NSArray<NSString *> *)moreOptions
           confirmTitle:(NSString *)confirmTitle {
    
    _mainOptions = mainOptions;
    _moreOptions = moreOptions;
    _dataOptions = mainOptions;
    // 背景遮罩
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.5];//[UIView colorFromRGB:0x8E8F8F];
    [self addSubview:_backgroundView];
    
    // 内容视图
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-600, [UIScreen mainScreen].bounds.size.width, 566.5)];
//    _contentView.center = self.center;
    _contentView.backgroundColor = UIColor.clearColor;
    _contentView.layer.cornerRadius = 10;
    [_backgroundView addSubview:_contentView];
    
    UIImageView *imgbac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ebact"]];
    imgbac.frame = CGRectMake(0, 33.5, [UIScreen mainScreen].bounds.size.width, 566.5);
    imgbac.userInteractionEnabled = YES;
    [_contentView addSubview:imgbac];
    
    UIImageView *edelt = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edelt"]];
    edelt.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 8, 25, 25);
    edelt.userInteractionEnabled = YES;
    [_contentView addSubview:edelt];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [edelt addGestureRecognizer:tapGesture];
    
    // 标题1
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 95, (_contentView.width-62*2-13)/2, 42)];
    titleLabel.text = titles[0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [_contentView addSubview:titleLabel];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didGesturetitleLabel:)];
    [titleLabel addGestureRecognizer:tapGesture];
    
    // 标题2
    UILabel *MoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(62+(_contentView.width-62*2-13)/2+13, 95, (_contentView.width-62*2-13)/2, 42)];
    MoreLabel.text = titles[1];
    MoreLabel.textColor = [UIView colorFromRGB:0x9CC6FF];
    MoreLabel.font = [UIFont boldSystemFontOfSize:18];
    MoreLabel.textAlignment = NSTextAlignmentCenter;
    MoreLabel.userInteractionEnabled = YES;
    [_contentView addSubview:MoreLabel];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didGesturetitleLabel:)];
    [MoreLabel addGestureRecognizer:tapGesture];
    
    // 表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(41, MoreLabel.bottom+52, _contentView.width-82, 225) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_contentView addSubview:self.tableView];
    
    // 确认按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(61, _contentView.height-54, _contentView.width-122, 50);
    [confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_contentView addSubview:confirmButton];
    
    
  
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    // 创建底部虚线
            CAShapeLayer *dashedLine = [CAShapeLayer layer];
            dashedLine.strokeColor = [UIColor lightGrayColor].CGColor;
            dashedLine.fillColor = nil;
            dashedLine.lineWidth = 1.0;
            dashedLine.lineDashPattern = @[@4, @2]; // 4pt线，2pt间隔
            dashedLine.name = @"bottomDashedLine"; // 设置名称以便后续查找
            
            [cell.contentView.layer addSublayer:dashedLine];
    
    // 更新虚线位置
       CAShapeLayer *existingDashedLine = nil;
       for (CALayer *layer in cell.contentView.layer.sublayers) {
           if ([layer.name isEqualToString:@"bottomDashedLine"]) {
               existingDashedLine = (CAShapeLayer *)layer;
               break;
           }
       }
       
       if (existingDashedLine) {
           CGFloat lineY = CGRectGetHeight(cell.contentView.bounds) - 1; // 底部位置
           UIBezierPath *path = [UIBezierPath bezierPath];
           [path moveToPoint:CGPointMake(15, lineY)]; // 左边距15pt
           [path addLineToPoint:CGPointMake(CGRectGetWidth(cell.contentView.bounds) - 15, lineY)]; // 右边距15pt
           
           existingDashedLine.path = path.CGPath;
       }
    
    
    // 设置未选中状态的图片
    UIImageView *ungou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goub"]];
    UIImage *uncheckedImage = [UIImage imageNamed:@"unchecked_icon"];
    UIImageView *uncheckedImageView = [[UIImageView alloc] initWithImage:uncheckedImage];
    ungou.frame = CGRectMake(5, 6.5, 10.23, 7.42);
    [uncheckedImageView addSubview:ungou];
    
    // 设置选中状态的图片
    UIImageView *checkgou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goub"]];
    UIImage *checkedImage = [UIImage imageNamed:@"checked_icon"];
    UIImageView *checkedImageView = [[UIImageView alloc] initWithImage:checkedImage];
    checkgou.frame = CGRectMake(5, 6.5, 10.23, 7.42);
    [checkedImageView addSubview:checkgou];
    
    // 根据选中状态设置 accessoryView
    if ([self isCellSelectedAtIndexPath:indexPath]) { // 自定义方法判断是否选中
        cell.accessoryView = checkedImageView;
    } else {
        cell.accessoryView = uncheckedImageView;
    }
    
    
    NSString *item = _dataOptions[indexPath.row];
    
    cell.textLabel.text = item;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// 自定义方法判断cell是否选中
- (BOOL)isCellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    // 实现你的选中逻辑
    if(_indexPath == indexPath){
        return YES;
    }
    return NO;
}

// 处理cell选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 更新选中状态
//    [self toggleSelectionAtIndexPath:indexPath];
    _indexPath = indexPath;
    [tableView reloadData];
    // 刷新cell以更新图片
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


/// 显示弹窗
/// @param imitation 图片选择类型：1，相机+相册；2，相机
///  @param allowSwitchCamera 是否允许切换摄像头
+ (void)showWithUploadmethod:(NSInteger)imitation allowSwitchCamera:(BOOL)allowSwitchCamera confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    EKYCPopupView *popup = [[EKYCPopupView alloc] init];
    [popup showWithUploadmethod:imitation confirmAction:confirmAction];
    // 默认不选中任何图片
    if(imitation == 1){
        popup->_selectedIndex = -1;
    }else{
        popup->_selectedIndex = 501;
    }
    
    popup->_allowSwitchCamera = allowSwitchCamera;
    popup->_confirmBlock = confirmAction;
    [popup show];
    
}

- (void)showWithUploadmethod:(NSInteger)imitation confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    // 背景遮罩
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.5];//[UIView colorFromRGB:0x8E8F8F];
    [self addSubview:_backgroundView];
    
    // 内容视图
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-400, [UIScreen mainScreen].bounds.size.width, 365.64)];
//    _contentView.center = self.center;
    _contentView.backgroundColor = UIColor.clearColor;
    _contentView.layer.cornerRadius = 10;
    [_backgroundView addSubview:_contentView];
    
    UIImageView *imgbac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upmkdcad"]];
    imgbac.frame = CGRectMake(0, 33.5, [UIScreen mainScreen].bounds.size.width, 365.64);
    imgbac.userInteractionEnabled = YES;
    [_contentView addSubview:imgbac];
    
    UIImageView *edelt = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edelt"]];
    edelt.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 8, 25, 25);
    edelt.userInteractionEnabled = YES;
    [_contentView addSubview:edelt];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [edelt addGestureRecognizer:tapGesture];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, imgbac.top+45, (_contentView.width-62*2), 42)];
    titleLabel.text = @"Upload method";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [_contentView addSubview:titleLabel];
    
    if(imitation == 1){
        UIImageView *camepree = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cakomgh"]];
        camepree.frame = CGRectMake(62.25, titleLabel.bottom+45, (_contentView.width-62.25*2-25)/2, 99);
        camepree.contentMode = UIViewContentModeScaleAspectFit;
        camepree.userInteractionEnabled = YES;
        camepree.tag = 500;
        _camepree = camepree;
        [_contentView addSubview:camepree];
        
        
        
        UIImageView *checkgou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goub"]];
        UIImage *checkedImage = [UIImage imageNamed:@"checked_icon"];
        UIImageView *checkedImageView = [[UIImageView alloc] initWithImage:checkedImage];
        checkgou.frame = CGRectMake(5, 6.5, 10.23, 7.42);
        [checkedImageView addSubview:checkgou];
        checkedImageView.frame = CGRectMake(camepree.width-30, 0, 20, 20);
        checkedImageView.hidden = YES;
        [camepree addSubview:checkedImageView];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClkedcameraOrphoto:)];
        [camepree addGestureRecognizer:tapGesture];
        
        
        
        UIImageView *camekop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cameLog"]];
        camekop.frame = CGRectMake(camepree.right+25, titleLabel.bottom+45, (_contentView.width-62.25*2-25)/2, 99);
        camekop.contentMode = UIViewContentModeScaleAspectFit;
        camekop.userInteractionEnabled = YES;
        camekop.tag = 501;
        _camekop = camekop;
        [_contentView addSubview:camekop];
        
        checkgou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goub"]];
        checkedImage = [UIImage imageNamed:@"checked_icon"];
        checkedImageView = [[UIImageView alloc] initWithImage:checkedImage];
        checkgou.frame = CGRectMake(5, 6.5, 10.23, 7.42);
        [checkedImageView addSubview:checkgou];
        checkedImageView.frame = CGRectMake(camekop.width-30, 0, 20, 20);
        checkedImageView.hidden = YES;
        [camekop addSubview:checkedImageView];
        
   
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClkedcameraOrphoto:)];
        [camekop addGestureRecognizer:tapGesture];
    }else{
        UIImageView *camekop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cameLog"]];
        camekop.frame = CGRectMake(0, 0, (_contentView.width-62.25*2-25)/2, 99);
        camekop.center = imgbac.center;
        camekop.contentMode = UIViewContentModeScaleAspectFit;
        camekop.userInteractionEnabled = YES;
        camekop.tag = 501;
        [_contentView addSubview:camekop];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClkedcameraOrphoto:)];
        [camekop addGestureRecognizer:tapGesture];
        
        
        UIImageView *checkgou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goub"]];
        UIImage *checkedImage = [UIImage imageNamed:@"checked_icon"];
        UIImageView *checkedImageView = [[UIImageView alloc] initWithImage:checkedImage];
        checkgou.frame = CGRectMake(5, 6.5, 10.23, 7.42);
        [checkedImageView addSubview:checkgou];
        checkedImageView.frame = CGRectMake(camekop.width-30, 0, 20, 20);
        checkedImageView.hidden = NO;
        [camekop addSubview:checkedImageView];
    }
    
    
    
    
    // 确认按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(61, _contentView.height-54, _contentView.width-122, 50);
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [confirmButton addTarget:self action:@selector(didClkedupTapped) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_contentView addSubview:confirmButton];
    
    
    
}





/// 显示弹窗
/// @param realname 姓名
///  @param number 身份证
///  @param birthday 出生日期
+ (void)showWithRealname:(NSString*)realname
                  number:(NSString*)number
                Birthday:(NSString*)birthday
           confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    EKYCPopupView *popup = [[EKYCPopupView alloc] init];
    [popup showWithRealname:realname number:number Birthday:birthday confirmAction:confirmAction];
    popup->_confirmBlock = confirmAction;
    [popup show];
}

- (void)showWithRealname:(NSString*)realname
                  number:(NSString*)number
                Birthday:(NSString*)birthday
           confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    
    // 背景遮罩
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.5];//[UIView colorFromRGB:0x8E8F8F];
    [self addSubview:_backgroundView];
    
    // 内容视图
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-500, [UIScreen mainScreen].bounds.size.width, 466.5)];
//    _contentView.center = self.center;
    _contentView.backgroundColor = UIColor.clearColor;
    _contentView.layer.cornerRadius = 10;
    [_backgroundView addSubview:_contentView];
    
    UIImageView *imgbac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rnball"]];
    imgbac.frame = CGRectMake(0, 33.5, [UIScreen mainScreen].bounds.size.width, 466.5);
    imgbac.userInteractionEnabled = YES;
    [_contentView addSubview:imgbac];
    
    UIImageView *edelt = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edelt"]];
    edelt.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 8, 25, 25);
    edelt.userInteractionEnabled = YES;
    [_contentView addSubview:edelt];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [edelt addGestureRecognizer:tapGesture];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, imgbac.top+45, (_contentView.width-62*2), 42)];
    titleLabel.text = @"Identity Information";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [_contentView addSubview:titleLabel];
    
    // 真实姓名部分
    self.realNameField = [self addInputFieldToView:_contentView
                        withTitle:@"Real name"
                                         Fieldtext:realname?:@"Mr. Li"
                        iconNamed:@"yismk"
                          yOffset:titleLabel.bottom+40];
        
        // 身份证号部分
    self.idNumberField = [self addInputFieldToView:_contentView
                        withTitle:@"ID number"
                                         Fieldtext:number?:@"3216065907940012"
                        iconNamed:@"yismk"
                          yOffset:titleLabel.bottom+40+70];
        
        // 生日部分
    self.birthdayField = [self addInputFieldToView:_contentView
                        withTitle:@"Birthday"
                                         Fieldtext:birthday?:@"23/03/2077"
                        iconNamed:@"jtlp"
                          yOffset:titleLabel.bottom+40+140];
    
    // 确认按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(61, _contentView.height-54, _contentView.width-122, 50);
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [confirmButton addTarget:self action:@selector(didClkedupTapped) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_contentView addSubview:confirmButton];
    self.selectedIndex = 502;
}

- (UITextField *)addInputFieldToView:(UIView *)container
                  withTitle:(NSString *)title
                  Fieldtext:(NSString *)Fieldtext
                  iconNamed:(NSString *)iconName
                    yOffset:(CGFloat)yOffset {
    
    // 标题标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(41, yOffset, 100, 20)];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    [container addSubview:label];
    
    // 输入框容器（包含输入框和图标）
    UIView *fieldContainer = [[UIView alloc] initWithFrame:CGRectMake(41, yOffset + 25, container.frame.size.width - 82, 33)];
    fieldContainer.layer.cornerRadius = 5;
    fieldContainer.layer.borderWidth = 1;
    fieldContainer.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
    [container addSubview:fieldContainer];
    
    // 输入框
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, fieldContainer.frame.size.width - 40, 33)];
    textField.text = Fieldtext;
    textField.borderStyle = UITextBorderStyleNone;
    [fieldContainer addSubview:textField];
    
    if([title isEqualToString:@"Birthday"]){
//        textField.enabled = NO;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTextFieldTap:)];
            [textField addGestureRecognizer:tapGesture];
            textField.userInteractionEnabled = YES; // 确保可以接收手势
    
           
    }
    // 右侧图标
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(fieldContainer.frame.size.width - 30, 5, 22, 22)];
    iconView.image = [UIImage imageNamed:iconName];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [fieldContainer addSubview:iconView];
    
    // 添加分割线（可选）
//    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(fieldContainer.frame.size.width - 40, 5, 1, 30)];
//    divider.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
//    [fieldContainer addSubview:divider];
    
    
    // 添加键盘通知
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                         object:nil
                                                          queue:[NSOperationQueue mainQueue]
                                                     usingBlock:^(NSNotification *note) {
            // 获取键盘高度
            CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat keyboardHeight = keyboardFrame.size.height;
            
            // 计算输入框在屏幕上的位置
            CGRect fieldFrameInWindow = [textField convertRect:textField.bounds toView:nil];
            CGFloat fieldBottom = CGRectGetMaxY(fieldFrameInWindow);
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            
            // 如果需要上移
            if (fieldBottom > (screenHeight - keyboardHeight)) {
                CGFloat offset = fieldBottom - (screenHeight - keyboardHeight) + 150; // 加10点额外间距
                [UIView animateWithDuration:0.3 animations:^{
                    self.frame = CGRectMake(0, -offset, self.frame.size.width, self.frame.size.height);
                }];
            }
        }];
        
        // 键盘隐藏时恢复
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                         object:nil
                                                          queue:[NSOperationQueue mainQueue]
                                                     usingBlock:^(NSNotification *note) {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            }];
        }];
    
    return textField; // 返回textField以便外部引用
}

#pragma mark - Actions

-(void)didGesturetitleLabel:(UITapGestureRecognizer*)tap{
  
    _indexPath = nil;
    for (UILabel *lab in _contentView.subviews) {
        if([lab isKindOfClass:[UILabel class]]){
            if(lab == tap.view){
                lab.textColor = [UIColor whiteColor];
                _dataOptions = [lab.text isEqualToString:@"E-KYC"]?_mainOptions:_moreOptions;
                [self.tableView reloadData];
            }else{
                lab.textColor = [UIView colorFromRGB:0x9CC6FF];
            }
        }
    }
    
}


-(void)didClkedcameraOrphoto:(UITapGestureRecognizer*)tap{
    
    // 更新选中状态
    self.selectedIndex = tap.view.tag;
    
    NSString *inaka;
    // 设置选中按钮的
    if (tap.view.tag == 500) {
        _camepree.subviews[0].hidden = NO;
        _camekop.subviews[0].hidden = YES;
        inaka = @"1";
        
    } else if (tap.view.tag == 501) {
        _camepree.subviews[0].hidden = YES;
        _camekop.subviews[0].hidden = NO;
        inaka = @"2";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:inaka forKey:@"inaka"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //点击拍照直接打开
    [self didClkedupTapped];
}

-(void)didClkedupTapped{
    
    if(self.selectedIndex == 500){
        // 从相册选择
        [[CameraAlbumManager sharedManager] pickImageFromAlbumWithViewController:[UIViewController topMostViewController]
                                                                     completion:^(UIImage *image, NSError *error) {
            if (image) {
                // 使用选择的图片
//                self.imageView.image = image;
                self->_confirmBlock(image);
            } else if (error) {
                NSLog(@"相册选择错误: %@", error.localizedDescription);
            }
        }];
    }else if (self.selectedIndex == 501){

        // 非全屏拍照示例
        CGFloat width = [UIViewController topMostViewController].view.bounds.size.width - 40;
        CGFloat height = width * 1.5; // 保持4:3比例
           
        CGRect cameraFrame = CGRectMake(20, 100, width, height);

        [[CameraAlbumManager sharedManager] takePhotoWithViewController:[UIViewController topMostViewController]
                                                     allowSwitchCamera:_allowSwitchCamera
                                                                frame:cameraFrame
                                                           completion:^(UIImage *image, NSError *error) {
            if (image) {
                // 使用拍摄的照片
//                self.imageView.image = image;
                self->_confirmBlock(image);
                
            } else if (error) {
                NSLog(@"拍照错误: %@", error.localizedDescription);
            }
        }];
    }else if (self.selectedIndex == 502){
        
        
        sfAutController *sfVc = (sfAutController*)[UIViewController topMostViewController];
        [[NetworkManager sharedManager] POST:@"/radiating/andtaking"
                                  parameters:@{@"vinegar": self.birthdayField.text,@"unique":self.idNumberField.text, @"appreciating":self.realNameField.text,@"vegetable":sfVc.vegetable,@"imitation":@"11",@"san": [RandomStringGenerator randomlyCallMethod]}
                                    headers:nil
                                   progress:nil
                                    success:^(id responseObject) {
            if([responseObject[@"heavy"] isEqualToString:@"0"]){
                
                [self hide];
                
                rlAutController *controller = [[rlAutController alloc]init];
                
                controller.harukos = sfVc.harukos;
                controller.vegetable = sfVc.vegetable;
                controller.imitation = sfVc.imitation;
                
                controller.realname = self.realNameField.text;
                controller.unique = self.idNumberField.text;
                controller.birthday = self.birthdayField.text;
                [[UIViewController topMostViewController].navigationController pushViewController:controller animated:YES];
                
                //埋点
                NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
                mutbdic[@"moneys"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"StartSFTime"];
                mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
                [self locaRadiatingPermis:mutbdic];
                
            }else{
                [SHToast showWithText:responseObject[@"daughters"]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"失败: %@", error.localizedDescription);
            [SHToast showWithText:error.localizedDescription];
        }];
        
        
    }
}


// 点击事件处理
- (void)handleTextFieldTap:(UITapGestureRecognizer *)gesture {
    UITextField *textField = (UITextField *)gesture.view;
    
    [EKMGPopupView showWithDate:textField.text confirmAction:^(NSObject * _Nullable obj) {
        textField.text = (NSString*)obj;
    }];
    
    [self endEditing:YES];
}


- (void)confirmButtonTapped {
    if (_confirmBlock) {
        if(_indexPath == nil){
            return;
        }
        _confirmBlock(_dataOptions[_indexPath.row]);
    }
    [self hide];
}

- (void)show {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    _contentView.alpha = 0;
    _contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 1;
        _contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
    sfAutController *sfVc = (sfAutController*)[UIViewController topMostViewController];
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        
        NSDictionary *medis = @{
            @"centimetre": sfVc.harukos,   // 产品ID
            @"bill": @"3",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
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
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StartSFTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
        
    });
    
}
@end
