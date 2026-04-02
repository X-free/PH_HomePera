//
//  AuthenticationCell.m
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import "AuthenticationCell.h"

@implementation AuthenticationCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    
    // 图标
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_iconImageView];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    // 描述
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont systemFontOfSize:12];
    _descriptionLabel.textColor = [UIColor grayColor];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_descriptionLabel];
    
    // 按钮
    _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _actionButton.userInteractionEnabled = NO;
    _actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:_actionButton];
    
    // 布局
    _iconImageView.frame = self.bounds;
    _titleLabel.frame = CGRectMake(11, 11, self.bounds.size.width-64, 40);
    _descriptionLabel.frame = CGRectMake(19, _titleLabel.bottom+28.5, self.bounds.size.width-38, 45);
    _actionButton.frame = CGRectMake(28, _descriptionLabel.bottom+14.5, self.bounds.size.width-56, 26.5);
}

- (void)configureWithTitle:(NSString *)title
              description:(NSString *)description
                  btnText:(NSString *)btnText
                     icon:(UIImage *)icon assumed:(NSString*)assumed{
    _titleLabel.text = title;
    _descriptionLabel.text = description;
    if([btnText isEqualToString:@"1"]){
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitle:@"Finish" forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"bluecor"] forState:(UIControlStateNormal)];
        
    }else{
        [_actionButton setTitleColor:[UIColor colorWithRed:251/255.0f green:61/255.0f blue:74/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_actionButton setTitle:@"Go Certified" forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"yewbb"] forState:(UIControlStateNormal)];
    }
    
   
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:assumed]
                 placeholderImage:icon];
}
@end
