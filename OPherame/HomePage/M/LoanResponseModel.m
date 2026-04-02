//
//  LoanResponseModel.m
//  OPherame
//
//  Created by todesk on 2025/6/16.
//

#import "LoanResponseModel.h"

@implementation AdministeringParItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
@end

@implementation AdministeringModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"par" : [AdministeringParItem class]};
}
@end


@implementation DrewParItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
@end

@implementation DrewModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"par" : [DrewParItem class]};
}
@end


@implementation BingoParItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
@end

@implementation BingoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"par" : [BingoParItem class]};
}
@end

@implementation PillModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
@end

@implementation TrulyParItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
@end

@implementation TrulyModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"par" : [TrulyParItem class]};
}
@end

@implementation LoanResponseModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"BgvDvfhsNf" : @"1BgvDvfhsNf",
        @"JIBdh6q28X" : @"82JIBdh6q28X",
        @"SIeuFJelv3zQ" : @"SIeuFJelv3zQ",
        @"gx9N0Hz" : @"U3gx9N0Hz",
        @"sw1fkOKk" : @"sw1fkOKk",
        @"yj5IfqXRE" : @"yj5IfqXRE"
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"administering" : [AdministeringModel class],
        @"bingo" : [BingoModel class],
        @"pill" : [PillModel class],
        @"truly" : [TrulyModel class]
    };
}
@end
