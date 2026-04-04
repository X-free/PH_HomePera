//
//  sfAutController+KYC.m
//  OPherame
//
//  Created by Flyer Free on 2026/4/3.
//

#import "sfAutController+KYC.h"
#import "EKYCPopupView.h"

@implementation sfAutController (KYC)

- (void)kycTypeGuide {
    
    //开始时间
    NSString *StartTime = [BeiMInfoUtil getCurrentTimestampInSeconds];
    
    // 显示弹窗（带更多选项）
    [EKYCPopupView showWithTitle:@[@"E-KYC",@"More options"]
                     mainOptions:self.mainOptions
                     moreOptions:self.moreOptions
                    confirmTitle:@"Confirm"
                   confirmAction:^(NSObject * _Nullable obj) {
        
        self.vegetable = (NSString*)obj;
        
        [self confirmButtonTappedCamera];
        
        NSMutableDictionary *mutbdic = [NSMutableDictionary dictionary];
        mutbdic[@"moneys"] = StartTime;
        mutbdic[@"flatter"] = [BeiMInfoUtil getCurrentTimestampInSeconds];
        mutbdic[@"bill"] = @"2";
        [self locaRadiatingPermis:mutbdic];
    }];
    
}


-(void)locaRadiatingPermis:(NSMutableDictionary*)permis{
    
//    @"bill": @"2",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
    NSArray *components = [self.harukos componentsSeparatedByString:@"="];
    [[LocationUtilfo sharedManager] getFullLocationWithViewController:self completion:^(NSString *country, NSString *countryCode, NSString *province, NSString *city, NSString *district, NSString *street, NSString *fullAddress, CLLocationCoordinate2D coordinate, NSError *error) {
       
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllasd"];
        NSString *lngcoo = [[NSUserDefaults standardUserDefaults] valueForKey:@"lllong"];
        NSString *centimetre = @"";
        if (components.count > 1) {
            centimetre = components[1];
        }
        NSDictionary *medis = @{
            @"centimetre": centimetre ?: @"",   // 产品ID
            @"flipped": @"",            // 用户申贷全局订单号，不用管, 传空即可
            @"splitting": [BeiMInfoUtil getOrCreateIDFV], // idfv
            @"tight": [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString]?:@"",             // idfa
            @"stroke": lngcoo?:@"",     // 经度
            @"surveying": lat?:@"",        // 纬度
            @"skills": [RandomStringGenerator randomlyCallMethod]         // 混淆字段
        };
        
        [permis addEntriesFromDictionary:medis];
        [[NetworkManager sharedManager]googleMarketPOST:@"/radiating/winds" parameters:permis headers:nil progress:nil success:^(id  _Nullable responseObject) {
            if([responseObject[@"heavy"] isEqualToString:@"0"]){
                
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    });
}

@end
