//
//  EKMGPopupView.m
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import "EKMGPopupView.h"
#import "DatePickerView.h"
#import "AddressView.h"
@interface EKYCPopupView ()<AddressViewDelegate>


@end

@implementation EKMGPopupView{
    UIView *_backgroundView;
    UIView *_contentView;
    EKYCPopupConfirmBlock _confirmBlock;
    UIScrollView *_scrollView;
    
    UIButton *_checkboxButton;
}

/// 选择日期
/// @param date 日期
+ (void)  showWithDate:(NSString*)date
           confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    EKMGPopupView *popup = [[EKMGPopupView alloc] init];
    popup->_confirmBlock = confirmAction;
    [popup showWithDate:date confirmAction:confirmAction];
    
    [popup show];
    
}

- (void)showWithDate:(NSString*)date
       confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    
    // 背景遮罩
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIView colorFromRGB:0x8E8F8F];
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
    titleLabel.text = @"Date Selection";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [_contentView addSubview:titleLabel];
    
  
    // 在需要显示日期选择器的地方

    
    // 创建并显示日期选择器
    CGRect pickerFrame = CGRectMake(48.5, titleLabel.bottom+47.5, _contentView.width-97, 198);
    DatePickerView *datePicker = [[DatePickerView alloc] initWithFrame:pickerFrame
                                                          dateString:date
                                                          completion:^(NSString *selectedDate) {
        NSLog(@"选择的日期: %@", selectedDate);
        // 更新UI显示选择的日期
//        self.dateLabel.text = selectedDate;
        self->_confirmBlock(selectedDate);
    }];

    // 自定义标题和虚线颜色（可选）
    datePicker.title = @"选择日期";
    datePicker.dashLineColor = [UIColor blueColor];

    [datePicker showInView:_contentView];
    
    
    // 确认按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(61, _contentView.height-54, _contentView.width-122, 50);
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [confirmButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_contentView addSubview:confirmButton];
}


//单选选取器和地址选取器
+(void)showWithTitle:(NSString*)title isComper:(BOOL)comper addreess:(NSString*)address
         mainOptions:(NSArray<NSDictionary *> *)mainOptions
       confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    EKMGPopupView *popup = [[EKMGPopupView alloc] init];
    popup->_confirmBlock = confirmAction;
    [popup showWithTitle:title isComper:comper addreess:address mainOptions:mainOptions confirmAction:confirmAction];
    
    [popup show];
}

-(void)showWithTitle:(NSString*)title isComper:(BOOL)comper addreess:(NSString*)address
         mainOptions:(NSArray<NSDictionary *> *)mainOptions
       confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    // 背景遮罩
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIView colorFromRGB:0x8E8F8F];
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
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [_contentView addSubview:titleLabel];
    
    if(comper == YES){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(53, titleLabel.bottom+47, _contentView.width-106, 200)];
        _scrollView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_scrollView];
        
      
        // 创建选项按钮
        CGFloat yPosition = 0;
        CGFloat rowHeight = 43;
        CGFloat horizontalPadding = 16;
        
        for (NSInteger i = 0; i < mainOptions.count; i++) {
           

            // 创建容器视图
            UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, _scrollView.bounds.size.width, rowHeight)];
            rowView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            rowView.layer.cornerRadius = 8;
            [_scrollView addSubview:rowView];
            
            // 标题标签（靠左）
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalPadding, 0  , 200, rowHeight)];
            titleLabel.text = mainOptions[i][@"appreciating"];
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [rowView addSubview:titleLabel];
            
            // 未选中图标（靠右）
            UIImageView *ungou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goub"]];
            UIImage *uncheckedImage = [UIImage imageNamed:@"unchecked_icon"];
            UIImageView *uncheckedImageView = [[UIImageView alloc] initWithImage:uncheckedImage];
            ungou.frame = CGRectMake(5, 7.5, 10.23, 7.42);
            [uncheckedImageView addSubview:ungou];
            uncheckedImageView.frame = CGRectMake(rowView.width - horizontalPadding - 20,
                                             (rowHeight - 20)/2,
                                                  20, 20);
            [rowView addSubview:uncheckedImageView];
            
            // 添加点击手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rowTapped:)];
            [rowView addGestureRecognizer:tapGesture];
            rowView.tag = i;
            
            yPosition += rowHeight + 9; // 1像素的分隔线
        }
        
        // 设置ScrollView内容大小
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, yPosition);
    }else{
        
        // 1. 初始化地址选择器
        CGRect pickerFrame = CGRectMake(48.5, titleLabel.bottom+47.5, _contentView.width-97, 198);
        NSArray*adds;
        if(address &&![address isEqualToString:@""]){
            adds = [address componentsSeparatedByString:@"-"];
        }
        AddressView *ressView = [[AddressView alloc]initWithFrame:pickerFrame
                                                    defaultRegion:address?adds[0]:nil
                                                            defaultProvince:address?adds[1]:nil
                                                          defaultCity:address?adds[2]:nil regions:mainOptions];
        
        ressView.delegate = self;
        [ressView setSelectedRegion:address?adds[0]:nil
                                       province:address?adds[1]:nil
                                           city:address?adds[2]:nil];
        [_contentView addSubview:ressView];
        
        
        
    }
    
    
    // 确认按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(61, _contentView.height-54, _contentView.width-122, 50);
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"bukath"] forState:(UIControlStateNormal)];
    [confirmButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_contentView addSubview:confirmButton];
    
}


- (void)addressPickerView:(AddressViewDelegate *_Nonnull)pickerView
          didSelectRegion:(NSString *_Nonnull)region
                 province:(NSString *_Nullable)province
                     city:(NSString *_Nonnull)city{
    
    NSLog(@"Selected Address: %@, %@, %@", region, province, city);
    _confirmBlock(@[region ?: @"", province ?: @"", city ?: @""]);
}


- (void)rowTapped:(UITapGestureRecognizer *)gesture {
    NSInteger selectedIndex = gesture.view.tag;
    NSLog(@"Selected option: %ld", (long)selectedIndex + 1);
    _confirmBlock([NSNumber numberWithInteger:selectedIndex]);
    // 更新选中状态（示例）
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            if(view.subviews.count>1){
                UIImageView *ImageView = view.subviews[1];
                if(view.tag == selectedIndex){
                    ImageView.image = [UIImage imageNamed:@"checked_icon"];
                }else{
                    ImageView.image = [UIImage imageNamed:@"unchecked_icon"];
                }
            }
            
        }
    }
}


//挽留弹窗和退出弹窗
+(void)showWithTitle:(NSString*)title  content:(NSString*)content
              CancelStr:(NSString*)Cancel sureStr:(NSString*)sure
       confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    EKMGPopupView *popup = [[EKMGPopupView alloc] init];
    popup->_confirmBlock = confirmAction;
    [popup showWithTitle:title  content:content
               CancelStr:Cancel sureStr:sure
        confirmAction:confirmAction];
    
    [popup show];
}

-(void)showWithTitle:(NSString*)title  content:(NSString*)content
              CancelStr:(NSString*)Cancel sureStr:(NSString*)sure
       confirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    // 背景遮罩
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIView colorFromRGB:0x8E8F8F];
    [self addSubview:_backgroundView];
    
    // 内容视图
    UIImageView *imgbac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kmoju"]];
    imgbac.frame = CGRectMake(16, 212, _backgroundView.width-32, 292);
    imgbac.userInteractionEnabled = YES;
    [_backgroundView addSubview:imgbac];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 15, (imgbac.width-62*2), 42)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [imgbac addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 94, (imgbac.width-60*2), 104)];
    contentLabel.textColor = [UIView colorFromRGB:0x8E8E8E];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.userInteractionEnabled = YES;
    contentLabel.numberOfLines = 0;
    [imgbac addSubview:contentLabel];
    
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSParagraphStyleAttributeName: ({
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 8;
            paragraphStyle.alignment = NSTextAlignmentCenter; // 居中
            paragraphStyle;
        })
    };

    contentLabel.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    
    UIButton *CanceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CanceButton.frame = CGRectMake(48.52, imgbac.height-33-42, (imgbac.width-106)/2, 42);
    [CanceButton setTitle:Cancel forState:UIControlStateNormal];
    [CanceButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [CanceButton setBackgroundImage:[UIImage imageNamed:@"cancered"] forState:(UIControlStateNormal)];
    [CanceButton addTarget:self action:@selector(removeHideVirew:) forControlEvents:UIControlEventTouchUpInside];
    CanceButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [imgbac addSubview:CanceButton];
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(CanceButton.right+8, imgbac.height-33-42, (imgbac.width-106)/2, 42);
    [sureButton setTitle:sure forState:UIControlStateNormal];
    [sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"surered"] forState:(UIControlStateNormal)];
    [sureButton addTarget:self action:@selector(sureButtonThooud:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [imgbac addSubview:sureButton];
    
    
    UIButton *kmodeltBut = [UIButton buttonWithType:UIButtonTypeSystem];
    kmodeltBut.frame = CGRectMake(_backgroundView.width/2-25/2, imgbac.bottom+52.5, 25, 25);
    [kmodeltBut setBackgroundImage:[UIImage imageNamed:@"kmodelt"] forState:(UIControlStateNormal)];
    [kmodeltBut addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:kmodeltBut];
}

-(void)sureButtonThooud:(UIButton*)but{
    if(![but.currentTitle isEqualToString:@"Continue to use"]){
        _confirmBlock(@"1");
    }else{
        [self hide];
    }
    
}

-(void)removeHideVirew:(UIButton*)but{
    
    if([but.currentTitle isEqualToString:@"Confirm Exit"]){
        _confirmBlock(@"1");
    }
    [self hide];
}

//注销弹窗
+(void)showAccountCancellationfirmAction:(EKYCPopupConfirmBlock)confirmAction{
    EKMGPopupView *popup = [[EKMGPopupView alloc] init];
    popup->_confirmBlock = confirmAction;
    [popup showAccountCancellationfirmAction:confirmAction];
    
    [popup show];
}

-(void)showAccountCancellationfirmAction:(EKYCPopupConfirmBlock)confirmAction{
    
    // 背景遮罩
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIView colorFromRGB:0x8E8F8F];
    [self addSubview:_backgroundView];
    
    // 内容视图
    UIImageView *imgbac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"anzhuxiao"]];
    imgbac.frame = CGRectMake(16, 160 * UIScreen.mainScreen.bounds.size.width/375.0, _backgroundView.width-32, 313);
    imgbac.userInteractionEnabled = YES;
    [_backgroundView addSubview:imgbac];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 15, (imgbac.width-62*2), 42)];
    titleLabel.text = @"Account cancellation?";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [imgbac addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 94, (imgbac.width-60*2), 156)];
    contentLabel.textColor = [UIView colorFromRGB:0x8E8E8E];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.userInteractionEnabled = YES;
    contentLabel.numberOfLines = 0;
    [imgbac addSubview:contentLabel];
    
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSParagraphStyleAttributeName: ({
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 8;
            paragraphStyle.alignment = NSTextAlignmentCenter; // 居中
            paragraphStyle;
        })
    };

    contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Your departure is our biggest\n regret.We have been working hard\n toimprove our services and hope\n toprovide you with a more\n convenientand better loan\n experience." attributes:attributes];
    
    
    
    UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkboxButton.frame = CGRectMake(27.5, contentLabel.bottom+12.5, imgbac.width-55, 16.5);
    [checkboxButton setImage:[UIImage imageNamed:@"norevebn"] forState:UIControlStateNormal];
    [checkboxButton setImage:[UIImage imageNamed:@"sorevebn"] forState:UIControlStateSelected];
    [checkboxButton setTitle:@"  l have read and agree to the above" forState:UIControlStateNormal];
    [checkboxButton setTitleColor:[UIView colorFromRGB:0x000000] forState:(UIControlStateNormal)];
    checkboxButton.titleLabel.font = [UIFont systemFontOfSize:12];
    checkboxButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [checkboxButton addTarget:self action:@selector(checkboxButThooud:) forControlEvents:UIControlEventTouchUpInside];
    [imgbac addSubview:checkboxButton];
    _checkboxButton = checkboxButton;
    
    UIButton *ContinueBut = [UIButton buttonWithType:UIButtonTypeCustom];
    ContinueBut.frame = CGRectMake(_backgroundView.width/2-150/2, imgbac.bottom+25, 150, 42);
    [ContinueBut setBackgroundImage:[UIImage imageNamed:@"inuebut"] forState:(UIControlStateNormal)];
    [ContinueBut setTitle:@"Cancel" forState:UIControlStateNormal];
    [ContinueBut addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [ContinueBut setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_backgroundView addSubview:ContinueBut];
    
    UIButton *ConfirmBut = [UIButton buttonWithType:UIButtonTypeSystem];
    ConfirmBut.frame = CGRectMake(_backgroundView.width/2-230/2, ContinueBut.bottom+14, 230, 42);
    [ConfirmBut setTitle:@"Account cancellation" forState:UIControlStateNormal];
    [ConfirmBut setTitleColor:[UIView colorFromRGB:0xC1C1C1] forState:UIControlStateNormal];
    [ConfirmBut addTarget:self action:@selector(ConfirmButThooud) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:ConfirmBut];
    
    UIButton *kmodeltBut = [UIButton buttonWithType:UIButtonTypeSystem];
    kmodeltBut.frame = CGRectMake(_backgroundView.width/2-25/2, ConfirmBut.bottom+20, 25, 25);
    [kmodeltBut setBackgroundImage:[UIImage imageNamed:@"kmodelt"] forState:(UIControlStateNormal)];
    [kmodeltBut addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:kmodeltBut];
}

-(void)checkboxButThooud:(UIButton*)but{
    but.selected = !but.selected;
}

-(void)ConfirmButThooud{
    if(_checkboxButton.selected == NO){
        [SHToast showWithText:@"Please read the above content carefully"];
    }else{
        _confirmBlock(@"1");
    }
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

+ (void)dismiss {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:[EKMGPopupView class]]) {
            [(EKMGPopupView *)subview hide];
            break;
        }
    }
}
@end
