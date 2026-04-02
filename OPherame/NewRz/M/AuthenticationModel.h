//
//  AuthenticationModel.h
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, CertificationType) {
    cupersuchousF = 0,
    cupersuchousG,
    cupersuchousH,
    cupersuchousI,
    cupersuchousL
};
@interface AuthenticationModel : NSObject
@property (nonatomic, strong) NSString *assumed;          // 图片URL
@property (nonatomic, assign) NSInteger crunchy;           // 标记1
@property (nonatomic, strong) NSString *downright;         // "Verify Identity"
@property (nonatomic, assign) NSInteger during;            // 标记0
@property (nonatomic, strong) NSString *experienced;       // "For identity verification only"
@property (nonatomic, strong) NSString *guessing;          // "Please complete the certifications in order"
@property (nonatomic, assign) NSInteger imitation;        // 标记0
@property (nonatomic, assign) NSInteger munched;           // 标记1
@property (nonatomic, assign) CertificationType pensive;   // 认证类型枚举
@property (nonatomic, strong) NSString *pry;               // "Certification"
@property (nonatomic, strong) NSString *shiny;             // 空字符串
@property (nonatomic, assign) NSInteger texture;          // 标记0
@property (nonatomic, strong) NSString *icon;

+ (NSArray<AuthenticationModel *> *)defaultModels;

+ (NSString *)stringFromUserStatus:(CertificationType)status;
@end

NS_ASSUME_NONNULL_END
