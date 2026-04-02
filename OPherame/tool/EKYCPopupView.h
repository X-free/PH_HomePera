//
//  EKYCPopupView.h
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import <UIKit/UIKit.h>
typedef void (^EKYCPopupConfirmBlock)(NSObject* _Nullable obj);
NS_ASSUME_NONNULL_BEGIN

@interface EKYCPopupView : UIView
/// 显示弹窗
/// @param titles 标题（如 "E-KYC"）
/// @param mainOptions 主选项数组（如 @[@"PRC ID", @"PRC ID", ...]）
/// @param moreOptions 更多选项数组（如 @[@"Option 1", @"Option 2"]）
/// @param confirmTitle 确认按钮文字（如 "Confirm"）
/// @param confirmAction 确认回调
+ (void)showWithTitle:(NSArray<NSString *> *)titles
          mainOptions:(NSArray<NSString *> *)mainOptions
          moreOptions:(NSArray<NSString *> *)moreOptions
         confirmTitle:(NSString *)confirmTitle
        confirmAction:(EKYCPopupConfirmBlock)confirmAction;


/// 显示弹窗
/// @param imitation 图片选择类型：1，相机+相册；2，相机
///  @param allowSwitchCamera 是否允许切换摄像头
+ (void)showWithUploadmethod:(NSInteger)imitation allowSwitchCamera:(BOOL)allowSwitchCamera confirmAction:(EKYCPopupConfirmBlock)confirmAction;


/// 显示弹窗
/// @param realname 姓名
///  @param number 身份证
///  @param birthday 出生日期
+ (void)showWithRealname:(NSString*)realname
                  number:(NSString*)number
                Birthday:(NSString*)birthday
        confirmAction:(EKYCPopupConfirmBlock)confirmAction;

/// 隐藏弹窗
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
