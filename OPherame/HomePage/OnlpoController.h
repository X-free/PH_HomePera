//
//  OnlpoController.h
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FAQItem : NSObject

@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, assign) BOOL isExpanded; // 展开状态

- (instancetype)initWithQuestion:(NSString *)question answer:(NSString *)answer;

@end


@interface OnlpoController : UIViewController

@end

NS_ASSUME_NONNULL_END
