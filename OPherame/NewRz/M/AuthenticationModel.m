//
//  AuthenticationModel.m
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"assumed" : @"assumed",
        @"crunchy" : @"crunchy",
        @"downright" : @"downright",
        @"during" : @"during",
        @"experienced" : @"experienced",
        @"guessing" : @"guessing",
        @"imitation" : @"imitation",
        @"munched" : @"munched",
        @"pensive" : @"pensive",
        @"pry" : @"pry",
        @"shiny" : @"shiny",
        @"texture" : @"texture"
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 如果有需要特殊处理的转换可以在这里实现
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    // 如果有需要特殊处理的转换可以在这里实现
    return YES;
}

// 返回写死的模型数组
+ (NSArray<AuthenticationModel *> *)defaultModels {
    NSArray *iconNames = @[@"wenabn", @"wenbbn", @"wencbn", @"wendbn", @"wenebn"];
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSString *iconName in iconNames) {
        AuthenticationModel *model = [[AuthenticationModel alloc] init];
        model.icon = iconName; // 覆盖默认值
        [models addObject:model];
    }
    
    return models.copy;
}

+ (NSString *)stringFromUserStatus:(NSString *)status {
    return status;
}

@end
