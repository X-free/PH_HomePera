//
//  LoanAdScrollView.h
//  OPherame
//
//  Created by todesk on 2025/6/28.
//

#import <UIKit/UIKit.h>
#import "LoanResponseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoanAdScrollView : UIScrollView

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                       cards:(NSArray<BingoParItem *> *)cards;

// 卡片背景色 (默认#FFD8CD)
@property (nonatomic, strong) UIColor *cardBackgroundColor;

// 按钮点击回调
@property (nonatomic, copy) void (^didTapButton)(NSInteger index);

- (void)setupCardsWithData:(NSArray *)cards;
@end

NS_ASSUME_NONNULL_END
