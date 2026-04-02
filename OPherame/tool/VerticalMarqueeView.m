//
//  VerticalMarqueeView.m
//  OPherame
//
//  Created by todesk on 2025/6/28.
//

#import "VerticalMarqueeView.h"

@interface VerticalMarqueeView ()

@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *nextLabel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic, copy) void (^clickHandler)(NSInteger index, NSString *message);

@end

@implementation VerticalMarqueeView

- (instancetype)initWithFrame:(CGRect)frame messages:(NSArray<DrewParItem *> *)messages {
    self = [super initWithFrame:frame];
    if (self) {
        _messages = [messages copy];
        _scrollInterval = 0.8;
        _animationDuration = 0.5;
        _textFont = [UIFont systemFontOfSize:16];
        _textColor = [UIColor blackColor];
        _currentIndex = 0;
        
        [self setupUI];
        [self addTapGesture];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    
    // 当前显示的label
    _currentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _currentLabel.font = _textFont;
    _currentLabel.textColor = _textColor;
    DrewParItem *item = _messages.firstObject;
    _currentLabel.text = item.daughters;
    _currentLabel.numberOfLines = 2;
    [self addSubview:_currentLabel];
    
    // 下一个label（初始在下方不可见位置）
    _nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    _nextLabel.font = _textFont;
    _nextLabel.textColor = _textColor;
    _nextLabel.numberOfLines = 2;
    [self addSubview:_nextLabel];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
}

- (void)handleTap {
    if (_clickHandler && _messages.count > 0) {
        _clickHandler(_currentIndex, _messages[_currentIndex].shiny);
    }
}

- (void)startScrolling {
    if (_messages.count <= 1) return; // 只有一条数据时不滚动
    
    [self stopScrolling];
    
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval
                                                  target:self
                                                selector:@selector(scrollToNextMessage)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
}

- (void)stopScrolling {
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}

- (void)scrollToNextMessage {
    // 计算下一个index
    NSInteger nextIndex = (_currentIndex + 1) % _messages.count;
    DrewParItem *item = _messages[nextIndex];
    _nextLabel.text = item.daughters;
    
    // 执行动画
    [UIView animateWithDuration:_animationDuration animations:^{
        // 当前label上移
        self.currentLabel.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        // 下一个label上移进入视野
        self.nextLabel.frame = self.bounds;
    } completion:^(BOOL finished) {
        // 重置位置和内容
        self.currentLabel.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        
        // 交换指针
        UILabel *temp = self.currentLabel;
        self.currentLabel = self.nextLabel;
        self.nextLabel = temp;
        
        // 更新index
        self.currentIndex = nextIndex;
    }];
}

#pragma mark - 属性设置
- (void)setMessages:(NSArray<DrewParItem *> *)messages {
    _messages = [messages copy];
    _currentIndex = 0;
    DrewParItem *item = _messages.firstObject;
    _currentLabel.text = item.daughters?:@"";
    
    _nextLabel.text = _messages.count > 1 ? _messages[1].daughters : nil;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _currentLabel.font = textFont;
    _nextLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _currentLabel.textColor = textColor;
    _nextLabel.textColor = textColor;
}

- (void)dealloc {
    [self stopScrolling];
}

@end
