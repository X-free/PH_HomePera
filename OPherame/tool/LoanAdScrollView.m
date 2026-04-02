//
//  LoanAdScrollView.m
//  OPherame
//
//  Created by todesk on 2025/6/28.
//

#import "LoanAdScrollView.h"

@implementation LoanAdScrollView {
    NSMutableArray<UIView *> *_cardViews;
}

- (instancetype)initWithFrame:(CGRect)frame cards:(NSArray<BingoParItem *> *)cards {
    self = [super initWithFrame:frame];
    if (self) {
        _cardViews = [NSMutableArray array];
        _cardBackgroundColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.80 alpha:1.0]; // #FFD8CD
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
        [self setupCardsWithData:cards];
    }
    return self;
}

- (void)setupCardsWithData:(NSArray *)cards {
    // 移除旧卡片
    for (UIView *view in _cardViews) {
        [view removeFromSuperview];
    }
    [_cardViews removeAllObjects];
    
    CGFloat cardWidth = self.frame.size.width; // 左右边距
    CGFloat cardHeight = 72; // 卡片高度
    CGFloat yPos = 0;
    CGFloat spacing = 14; // 卡片间距
    
    for (int i = 0; i < cards.count; i++) {
        BingoParItem *item = cards[i];
        // 创建卡片容器
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, cardWidth, cardHeight)];
        cardView.backgroundColor = _cardBackgroundColor;
        cardView.layer.cornerRadius = 12;
        cardView.layer.masksToBounds = YES;
        cardView.tag = 50+i;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
        [cardView addGestureRecognizer:tapGesture];
        
        // 添加图片 (示例使用系统图片)
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 15, 42.5, 42.5)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 42.5/2;
        imageView.userInteractionEnabled = YES;
        [cardView addSubview:imageView];
        
        if([item.pick isEqualToString:@""]||item.pick == nil){
            imageView.backgroundColor = [UIView colorFromRGB:0x999999];
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:item.pick]
                         placeholderImage:nil];
        }
        
        
        // 添加标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+8, 12.5, cardWidth-117.5-imageView.right-8, 21.5)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.text = item.marinate;
        [cardView addSubview:titleLabel];
        
        // 添加副标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+8, titleLabel.bottom, cardWidth-117.5-imageView.right-8, 24.5)];
        subtitleLabel.font = [UIFont systemFontOfSize:14];
        subtitleLabel.textColor = [UIColor grayColor];
        
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Loan Amount：₱ %@",item.ideals]];
               
        // 设置"Loan Amount:"的样式
        [attributedText addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:14]
                              range:[attributedText.string rangeOfString:@"Loan Amount:"]];
        
        // 设置"₱ 86,000"的样式
        [attributedText addAttribute:NSFontAttributeName
                              value:[UIFont boldSystemFontOfSize:20]
                              range:[attributedText.string rangeOfString:[NSString stringWithFormat:@"₱ %@",item.ideals]]];
        subtitleLabel.attributedText = attributedText;
        [cardView addSubview:subtitleLabel];
        
        // 添加按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(subtitleLabel.right+8, 21.5, 88, 30);
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setTitle:item.rolls forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        button.backgroundColor = [UIColor blackColor];
        button.layer.cornerRadius = 15;
        button.userInteractionEnabled = NO;
//        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cardView addSubview:button];
        
        [self addSubview:cardView];
        [_cardViews addObject:cardView];
        
        yPos += cardHeight + spacing;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, yPos);
}

- (void)buttonTapped:(UITapGestureRecognizer *)sender {
    if (_didTapButton) {
        _didTapButton(sender.view.tag-50);
    }
}

- (void)setCardBackgroundColor:(UIColor *)cardBackgroundColor {
    _cardBackgroundColor = cardBackgroundColor;
    for (UIView *card in _cardViews) {
        card.backgroundColor = cardBackgroundColor;
    }
}

@end
