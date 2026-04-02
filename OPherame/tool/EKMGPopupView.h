//
//  EKMGPopupView.h
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import <UIKit/UIKit.h>
typedef void (^EKYCPopupConfirmBlock)(NSObject* _Nullable obj);
NS_ASSUME_NONNULL_BEGIN

@interface EKMGPopupView : UIView

/// 选择日期
/// @param date 日期
+ (void)showWithDate:(NSString*)date
       confirmAction:(EKYCPopupConfirmBlock)confirmAction;


//单选选取器和地址选取器
//comper yes单选器。no地址选取器
+(void)showWithTitle:(NSString*)title isComper:(BOOL)comper addreess:(NSString*)address
         mainOptions:(NSArray<NSDictionary *> *)mainOptions
      confirmAction:(EKYCPopupConfirmBlock)confirmAction;




//挽留弹窗和退出弹窗
+(void)showWithTitle:(NSString*)title  content:(NSString*)content
              CancelStr:(NSString*)Cancel sureStr:(NSString*)sure
      confirmAction:(EKYCPopupConfirmBlock)confirmAction;

//注销弹窗
+(void)showAccountCancellationfirmAction:(EKYCPopupConfirmBlock)confirmAction;

/// 隐藏弹窗
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
