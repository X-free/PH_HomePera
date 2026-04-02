//
//  AddressView.m
//  OPherame
//
//  Created by todesk on 2025/6/27.
//
#if 0
#import "AddressView.h"
@interface AddressView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray<NSDictionary *> *regions;
@property (strong, nonatomic) NSArray<NSDictionary *> *currentProvinces;
@property (strong, nonatomic) NSArray<NSDictionary *> *currentCities;

@property (assign, nonatomic) NSInteger selectedRegionIndex;
@property (assign, nonatomic) NSInteger selectedProvinceIndex;
@property (assign, nonatomic) NSInteger selectedCityIndex;

@end
@implementation AddressView

- (instancetype)initWithFrame:(CGRect)frame
                 defaultRegion:(NSString *)region
                defaultProvince:(NSString *)province
                  defaultCity:(NSString *)city regions:(NSArray<NSDictionary *> *)regions {
    self = [super initWithFrame:frame];
    if (self) {
        self.regions = regions;
        [self loadAddressData];
        [self setupUI];
        [self setDefaultAddressWithRegion:region province:province city:city];
    }
    return self;
}

- (void)setupUI {
    self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
}

- (void)loadAddressData {
    // 这里应该是从您提供的JSON数据加载
    // 由于JSON数据很大，实际项目中应该从文件或网络加载
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"philippines_address" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    self.regions = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    // 初始化当前省份和城市数组
    if (self.regions.count > 0) {
        NSDictionary *firstRegion = self.regions[0];
        self.currentProvinces = firstRegion[@"jiju"];
        if (self.currentProvinces.count > 0) {
            self.currentCities = self.currentProvinces[0][@"jiju"];
        }
    }
}

- (void)setDefaultAddressWithRegion:(NSString *)region
                          province:(NSString *)province
                              city:(NSString *)city {
    // 设置默认选中的地区
    self.selectedRegionIndex = 0;
    self.selectedProvinceIndex = 0;
    self.selectedCityIndex = 0;
    
    if (region) {
        for (NSInteger i = 0; i < self.regions.count; i++) {
            NSDictionary *regionDict = self.regions[i];
            if ([regionDict[@"appreciating"] isEqualToString:region]) {
                self.selectedRegionIndex = i;
                self.currentProvinces = regionDict[@"jiju"];
                
                if (province && self.currentProvinces.count > 0) {
                    for (NSInteger j = 0; j < self.currentProvinces.count; j++) {
                        NSDictionary *provinceDict = self.currentProvinces[j];
                        if ([provinceDict[@"appreciating"] isEqualToString:province]) {
                            self.selectedProvinceIndex = j;
                            self.currentCities = provinceDict[@"jiju"];
                            
                            if (city && self.currentCities.count > 0) {
                                for (NSInteger k = 0; k < self.currentCities.count; k++) {
                                    NSDictionary *cityDict = self.currentCities[k];
                                    if ([cityDict[@"appreciating"] isEqualToString:city]) {
                                        self.selectedCityIndex = k;
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                    }
                }
                break;
            }
        }
    }
    
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:self.selectedRegionIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.selectedProvinceIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.selectedCityIndex inComponent:2 animated:NO];
}

- (void)setSelectedRegion:(NSString *)region
                province:(NSString *)province
                    city:(NSString *)city {
    // 重置为默认值
    self.selectedRegionIndex = 0;
    self.selectedProvinceIndex = 0;
    self.selectedCityIndex = 0;
    self.currentProvinces = self.regions.count > 0 ? self.regions[0][@"jiju"] : @[];
    self.currentCities = self.currentProvinces.count > 0 ? self.currentProvinces[0][@"jiju"] : @[];
    
    // 如果传入了地区，则查找匹配的地区
    if (region) {
        for (NSInteger i = 0; i < self.regions.count; i++) {
            NSDictionary *regionDict = self.regions[i];
            if ([regionDict[@"appreciating"] isEqualToString:region]) {
                self.selectedRegionIndex = i;
                self.currentProvinces = regionDict[@"jiju"];
                
                // 如果传入了省份，则查找匹配的省份
                if (province && self.currentProvinces.count > 0) {
                    for (NSInteger j = 0; j < self.currentProvinces.count; j++) {
                        NSDictionary *provinceDict = self.currentProvinces[j];
                        if ([provinceDict[@"appreciating"] isEqualToString:province]) {
                            self.selectedProvinceIndex = j;
                            self.currentCities = provinceDict[@"jiju"];
                            
                            // 如果传入了城市，则查找匹配的城市
                            if (city && self.currentCities.count > 0) {
                                for (NSInteger k = 0; k < self.currentCities.count; k++) {
                                    NSDictionary *cityDict = self.currentCities[k];
                                    if ([cityDict[@"appreciating"] isEqualToString:city]) {
                                        self.selectedCityIndex = k;
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                    }
                } else {
                    // 如果没有传入省份，则选择第一个省份
                    self.selectedProvinceIndex = 0;
                    self.currentCities = self.currentProvinces.count > 0 ? self.currentProvinces[0][@"jiju"] : @[];
                }
                break;
            }
        }
    }
    
    // 重新加载选择器数据
    [self.pickerView reloadAllComponents];
    
    // 设置选中的行
    [self.pickerView selectRow:self.selectedRegionIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.selectedProvinceIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.selectedCityIndex inComponent:2 animated:NO];
    
    // 触发回调
    [self notifyDelegate];
}



#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0: return self.regions.count;
        case 1: return self.currentProvinces.count;
        case 2: return self.currentCities.count;
        default: return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.regions[row][@"appreciating"];
        case 1:
            return self.currentProvinces[row][@"appreciating"];
        case 2:
            return self.currentCities[row][@"appreciating"];
        default:
            return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedRegionIndex = row;
        self.currentProvinces = self.regions[row][@"jiju"];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        if (self.currentProvinces.count > 0) {
            self.currentCities = self.currentProvinces[0][@"jiju"];
        } else {
            self.currentCities = @[];
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.selectedProvinceIndex = 0;
        self.selectedCityIndex = 0;
    } else if (component == 1) {
        self.selectedProvinceIndex = row;
        if (self.currentProvinces.count > row) {
            self.currentCities = self.currentProvinces[row][@"jiju"];
        } else {
            self.currentCities = @[];
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.selectedCityIndex = 0;
    } else {
        self.selectedCityIndex = row;
    }
    
    // 回调选中的地址
//    if ([self.delegate respondsToSelector:@selector(addressPickerView:didSelectRegion:province:city:)]) {
//        NSString *region = self.regions[self.selectedRegionIndex][@"appreciating"];
//        NSString *province = self.currentProvinces.count > 0 ? self.currentProvinces[self.selectedProvinceIndex][@"appreciating"] : @"";
//        NSString *city = self.currentCities.count > 0 ? self.currentCities[self.selectedCityIndex][@"appreciating"] : @"";
//        
//        [self.delegate addressPickerView:self didSelectRegion:region province:province city:city];
//    }
    
    [self notifyDelegate];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
    }
    
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}



- (void)notifyDelegate {
    if ([self.delegate respondsToSelector:@selector(addressPickerView:didSelectRegion:province:city:)]) {
        NSString *region = self.regions.count > self.selectedRegionIndex ? self.regions[self.selectedRegionIndex][@"appreciating"] : @"";
        NSString *province = self.currentProvinces.count > self.selectedProvinceIndex ? self.currentProvinces[self.selectedProvinceIndex][@"appreciating"] : @"";
        NSString *city = self.currentCities.count > self.selectedCityIndex ? self.currentCities[self.selectedCityIndex][@"appreciating"] : @"";
        
        [self.delegate addressPickerView:self didSelectRegion:region province:province city:city];
    }
}
@end

#else

#import "AddressView.h"

@interface AddressView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray<NSDictionary *> *regions;
@property (strong, nonatomic) NSArray<NSDictionary *> *currentProvinces;
@property (strong, nonatomic) NSArray<NSDictionary *> *currentCities;

@property (assign, nonatomic) NSInteger selectedRegionIndex;
@property (assign, nonatomic) NSInteger selectedProvinceIndex;
@property (assign, nonatomic) NSInteger selectedCityIndex;

@end

@implementation AddressView

- (instancetype)initWithFrame:(CGRect)frame
                 defaultRegion:(NSString *)region
                defaultProvince:(NSString *)province
                    defaultCity:(NSString *)city regions:(NSArray<NSDictionary *> *)regions{
    self = [super initWithFrame:frame];
    if (self) {
        self.regions = regions;
        [self loadAddressData];
        [self setupUI];
        if (region || province || city) {
            [self setSelectedRegion:region province:province city:city];
        }
    }
    return self;
}

- (void)setupUI {
    self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
}

- (void)loadAddressData {
    // 这里应该是从您提供的JSON数据加载
    // 由于JSON数据很大，实际项目中应该从文件或网络加载
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"philippines_address" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    self.regions = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    // 初始化当前省份和城市数组
    if (self.regions.count > 0) {
        self.currentProvinces = self.regions[0][@"jiju"];
        if (self.currentProvinces.count > 0) {
            self.currentCities = self.currentProvinces[0][@"jiju"];
        }
    }
}

- (void)setSelectedRegion:(NSString *)region
                province:(NSString *)province
                    city:(NSString *)city {
    // 重置为默认值
    self.selectedRegionIndex = 0;
    self.selectedProvinceIndex = 0;
    self.selectedCityIndex = 0;
    self.currentProvinces = self.regions.count > 0 ? self.regions[0][@"jiju"] : @[];
    self.currentCities = self.currentProvinces.count > 0 ? self.currentProvinces[0][@"jiju"] : @[];
    
    // 如果传入了地区，则查找匹配的地区
    if (region) {
        for (NSInteger i = 0; i < self.regions.count; i++) {
            NSDictionary *regionDict = self.regions[i];
            if ([regionDict[@"appreciating"] isEqualToString:region]) {
                self.selectedRegionIndex = i;
                self.currentProvinces = regionDict[@"jiju"];
                
                // 如果传入了省份，则查找匹配的省份
                if (province && self.currentProvinces.count > 0) {
                    for (NSInteger j = 0; j < self.currentProvinces.count; j++) {
                        NSDictionary *provinceDict = self.currentProvinces[j];
                        if ([provinceDict[@"appreciating"] isEqualToString:province]) {
                            self.selectedProvinceIndex = j;
                            self.currentCities = provinceDict[@"jiju"];
                            
                            // 如果传入了城市，则查找匹配的城市
                            if (city && self.currentCities.count > 0) {
                                for (NSInteger k = 0; k < self.currentCities.count; k++) {
                                    NSDictionary *cityDict = self.currentCities[k];
                                    if ([cityDict[@"appreciating"] isEqualToString:city]) {
                                        self.selectedCityIndex = k;
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                    }
                } else {
                    // 如果没有传入省份，则选择第一个省份
                    self.selectedProvinceIndex = 0;
                    self.currentCities = self.currentProvinces.count > 0 ? self.currentProvinces[0][@"jiju"] : @[];
                }
                break;
            }
        }
    }
    
    // 重新加载选择器数据
    [self.pickerView reloadAllComponents];
    
    // 设置选中的行
    [self.pickerView selectRow:self.selectedRegionIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.selectedProvinceIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.selectedCityIndex inComponent:2 animated:NO];
    
    // 触发回调
    [self notifyDelegate];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0: return self.regions.count;
        case 1: return self.currentProvinces.count;
        case 2: return self.currentCities.count;
        default: return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.regions[row][@"appreciating"];
        case 1:
            return self.currentProvinces.count > row ? self.currentProvinces[row][@"appreciating"] : @"";
        case 2:
            return self.currentCities.count > row ? self.currentCities[row][@"appreciating"] : @"";
        default:
            return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedRegionIndex = row;
        self.currentProvinces = self.regions[row][@"jiju"];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        if (self.currentProvinces.count > 0) {
            self.currentCities = self.currentProvinces[0][@"jiju"];
        } else {
            self.currentCities = @[];
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.selectedProvinceIndex = 0;
        self.selectedCityIndex = 0;
    } else if (component == 1) {
        self.selectedProvinceIndex = row;
        if (self.currentProvinces.count > row) {
            self.currentCities = self.currentProvinces[row][@"jiju"];
        } else {
            self.currentCities = @[];
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.selectedCityIndex = 0;
    } else {
        self.selectedCityIndex = row;
    }
    
    [self notifyDelegate];
}

- (void)notifyDelegate {
    if ([self.delegate respondsToSelector:@selector(addressPickerView:didSelectRegion:province:city:)]) {
        NSString *region = self.regions.count > self.selectedRegionIndex ? self.regions[self.selectedRegionIndex][@"appreciating"] : @"";
        NSString *province = self.currentProvinces.count > self.selectedProvinceIndex ? self.currentProvinces[self.selectedProvinceIndex][@"appreciating"] : @"";
        NSString *city = self.currentCities.count > self.selectedCityIndex ? self.currentCities[self.selectedCityIndex][@"appreciating"] : @"";
        
        [self.delegate addressPickerView:self didSelectRegion:region province:province city:city];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
    }
    
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

@end

#endif
