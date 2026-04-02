//
//  AuthenticationCell.h
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthenticationCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIImageView *iconImageView;

- (void)configureWithTitle:(NSString *)title
              description:(NSString *)description
                  btnText:(NSString *)btnText
                     icon:(UIImage *)icon assumed:(NSString*)assumed;
@end

NS_ASSUME_NONNULL_END
