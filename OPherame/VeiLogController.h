//
//  VeiLogController.h
//  OPherame
//
//  Created by todesk on 2025/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VeiLogController : UIViewController
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UITextField *verificationCodeField;
@property (nonatomic, strong) UIButton *acquireButton;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *privacyAgreementButton;
@end

NS_ASSUME_NONNULL_END
