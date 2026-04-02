//
//  AddressView.h
//  OPherame
//
//  Created by todesk on 2025/6/27.
//

#import <UIKit/UIKit.h>

@class AddressViewDelegate;

@protocol AddressViewDelegate <NSObject>
- (void)addressPickerView:(AddressViewDelegate *_Nonnull)pickerView
          didSelectRegion:(NSString *_Nonnull)region
                 province:(NSString *_Nullable)province
                     city:(NSString *_Nonnull)city;
@end
NS_ASSUME_NONNULL_BEGIN


@interface AddressView : UIView

@property (weak, nonatomic) id<AddressViewDelegate> delegate;

// 初始化方法，可传入默认地址
- (instancetype)initWithFrame:(CGRect)frame
                 defaultRegion:(NSString *)region
                defaultProvince:(NSString *)province
                    defaultCity:(NSString *)city regions:(NSArray<NSDictionary *> *)regions;

// 设置选中地址
- (void)setSelectedRegion:(NSString *)region
                province:(NSString *)province
                    city:(NSString *)city;
@end

NS_ASSUME_NONNULL_END
