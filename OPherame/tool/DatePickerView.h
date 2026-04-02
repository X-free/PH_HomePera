//
//  DatePickerView.h
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef void(^DatePickerCompletion)(NSString *selectedDate);

@interface DatePickerView : UIView

@property (nonatomic, strong) NSString *title; // 顶部标题
@property (nonatomic, strong) UIColor *dashLineColor; // 虚线颜色

/**
 初始化日期选择器
 
 @param frame 选择器frame
 @param dateString 初始日期字符串，格式为"dd/MM/yyyy"或"dd-MM-yyyy"
 @param completion 选择完成回调
 */
- (instancetype)initWithFrame:(CGRect)frame
                   dateString:(NSString *)dateString
                   completion:(DatePickerCompletion)completion;

// 显示选择器
- (void)showInView:(UIView *)view;

// 隐藏选择器
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
