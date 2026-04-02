//
//  AuthenticationCell.m
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import "AuthenticationCell.h"

@interface AuthenticationCell ()
@property (nonatomic, strong) UIView *statusCircleView;
@property (nonatomic, strong) UILabel *statusCheckLabel;
@property (nonatomic, strong) UIImageView *statusIconImageView;
@end

@implementation AuthenticationCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIView colorFromRGB:0xEAF6FF];
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    
    // 行内状态圆（右侧）
    _statusCircleView = [[UIView alloc] initWithFrame:CGRectZero];
    _statusCircleView.layer.cornerRadius = 10;
    _statusCircleView.layer.masksToBounds = YES;
    [self.contentView addSubview:_statusCircleView];
    
    _statusCheckLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _statusCheckLabel.text = @"✓";
    _statusCheckLabel.textAlignment = NSTextAlignmentCenter;
    _statusCheckLabel.textColor = [UIColor whiteColor];
    _statusCheckLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.statusCircleView addSubview:_statusCheckLabel];

    // 右侧状态：直接用 done/todo 切图（包含圆与符号）
    _statusIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _statusIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.statusCircleView addSubview:_statusIconImageView];
    
    // 图标
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImageView];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 1;
    [self.contentView addSubview:_titleLabel];
    
    // 描述：该页面行列表不需要展示
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont systemFontOfSize:12];
    _descriptionLabel.textColor = [UIColor grayColor];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_descriptionLabel];
    _descriptionLabel.hidden = YES;
    
    // 按钮：该页面行列表不需要展示
    _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _actionButton.userInteractionEnabled = NO;
    _actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:_actionButton];
    _actionButton.hidden = YES;
    
    // 布局
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat paddingX = 14;
    CGFloat iconBoxSize = 40;
    CGFloat rightPadding = 18;
    CGFloat circleSize = 20;
    
    _iconImageView.frame = CGRectMake(paddingX, (h - iconBoxSize) / 2.0, iconBoxSize, iconBoxSize);
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 12,
                                     0,
                                     w - CGRectGetMaxX(_iconImageView.frame) - 12 - rightPadding - circleSize,
                                     h);
    
    _statusCircleView.frame = CGRectMake(w - rightPadding - circleSize,
                                         (h - circleSize) / 2.0,
                                         circleSize,
                                         circleSize);
    _statusCircleView.layer.cornerRadius = circleSize / 2.0;
    
    _statusCheckLabel.frame = _statusCircleView.bounds;
    _statusIconImageView.frame = _statusCircleView.bounds;
}

- (void)configureWithTitle:(NSString *)title
              description:(NSString *)description
                  btnText:(NSString *)btnText
                     icon:(UIImage *)icon assumed:(NSString*)assumed{
    _titleLabel.text = title;
    
    BOOL completed = [btnText isEqualToString:@"1"] || [btnText isEqualToString:@"true"];
    if (completed) {
        // done 切图：橙色圆+勾
        self.statusCircleView.backgroundColor = [UIColor clearColor];
        self.statusIconImageView.image = [UIImage imageNamed:@"done"];
        self.statusCheckLabel.hidden = YES;
    } else {
        // todo 切图：绿色圆+箭头
        self.statusCircleView.backgroundColor = [UIColor clearColor];
        self.statusIconImageView.image = [UIImage imageNamed:@"todo"];
        self.statusCheckLabel.hidden = YES;
    }
    
    // 加载左侧认证项 logo
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:assumed]];
    
}
@end
