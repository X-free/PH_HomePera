//
//  PhotoConfirmation.h
//  OPherame
//
//  Created by todesk on 2025/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoConfirmation : UIViewController
@property (nonatomic, strong) UIImage *capturedImage;
@property (nonatomic, copy) void (^onConfirm)(BOOL confirmed);

- (instancetype)initWithImage:(UIImage *)image confirmationHandler:(void(^)(BOOL))handler;
@end

NS_ASSUME_NONNULL_END
