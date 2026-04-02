//
//  PhotoConfirmation.m
//  OPherame
//
//  Created by todesk on 2025/7/10.
//

#import "PhotoConfirmation.h"

@interface PhotoConfirmation ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *retakeButton;
@end

@implementation PhotoConfirmation

- (instancetype)initWithImage:(UIImage *)image confirmationHandler:(void(^)(BOOL))handler {
    self = [super init];
    if (self) {
        _capturedImage = image;
        _onConfirm = [handler copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    // 图片预览
    _imageView = [[UIImageView alloc] initWithImage:self.capturedImage];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100);
    [self.view addSubview:_imageView];
    
    // 底部按钮容器
    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    buttonContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:buttonContainer];
    
    // 重拍按钮
    _retakeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_retakeButton setTitle:@"Beat Down" forState:UIControlStateNormal];
    [_retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _retakeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _retakeButton.frame = CGRectMake(20, 30, 100, 40);
    [_retakeButton addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:_retakeButton];
    
    // 确认按钮
    _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_confirmButton setTitle:@"Using Photos" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _confirmButton.frame = CGRectMake(buttonContainer.bounds.size.width - 140, 30, 120, 40);
    [_confirmButton addTarget:self action:@selector(confirmPhoto) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:_confirmButton];
}

- (void)retakePhoto {
    if (self.onConfirm) {
        self.onConfirm(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmPhoto {
    if (self.onConfirm) {
        self.onConfirm(YES);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
