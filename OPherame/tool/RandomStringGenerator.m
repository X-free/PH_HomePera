//
//  RandomStringGenerator.m
//  OPherame
//
//  Created by todesk on 2025/6/16.
//

#import "RandomStringGenerator.h"

@implementation RandomStringGenerator

+ (NSString *)randomlyCallMethod {
    // 随机选择方法类型 (0-4)
    NSInteger methodType = arc4random_uniform(6);
    
    // 随机生成长度 (1-10)
    NSUInteger length = arc4random_uniform(6) + 4;
    
    NSString *result = nil;
    
    switch (methodType) {
        case 0:
            result = [RandomStringGenerator generateRandomString];
            NSLog(@"调用 generateRandomString");
            break;
            
        case 1:
            result = [RandomStringGenerator generateRandomStringWithLength:length];
            NSLog(@"调用 generateRandomStringWithLength: %lu", (unsigned long)length);
            break;
            
        case 2:
            result = [RandomStringGenerator generateAlphanumericStringWithLength:length];
            NSLog(@"调用 generateAlphanumericStringWithLength: %lu", (unsigned long)length);
            break;
            
        case 3:
            result = [RandomStringGenerator generateNumericStringWithLength:length];
            NSLog(@"调用 generateNumericStringWithLength: %lu", (unsigned long)length);
            break;
            
        case 4:
            result = [RandomStringGenerator generateLettersStringWithLength:length];
            NSLog(@"调用 generateLettersStringWithLength: %lu", (unsigned long)length);
            break;
            
        default:
            result = [RandomStringGenerator generateSpecialCharacterStringWithLength:length];
            NSLog(@"默认调用 generateSpecialCharacterStringWithLength: %lu", (unsigned long)length);
            break;
    }
    
    return result;
}


+ (NSString *)generateRandomString {
    // 随机长度（4到8位）
    NSUInteger length = arc4random_uniform(5) + 4;
    
    return [self generateRandomStringWithLength:length];
}

+ (NSString *)generateRandomStringWithLength:(NSUInteger)length {
    if (length == 0) return @"";
    
    // 所有可用字符集（字母大小写 + 数字 + 特殊字符）
    NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)characters.length);
        unichar character = [characters characterAtIndex:randomIndex];
        [randomString appendFormat:@"%C", character];
    }
    
    return [randomString copy];
}

+ (NSString *)generateAlphanumericStringWithLength:(NSUInteger)length {
    if (length == 0) return @"";
    
    NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)characters.length);
        unichar character = [characters characterAtIndex:randomIndex];
        [randomString appendFormat:@"%C", character];
    }
    
    return [randomString copy];
}

+ (NSString *)generateNumericStringWithLength:(NSUInteger)length {
    if (length == 0) return @"";
    
    NSString *characters = @"0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)characters.length);
        unichar character = [characters characterAtIndex:randomIndex];
        [randomString appendFormat:@"%C", character];
    }
    
    return [randomString copy];
}

+ (NSString *)generateLettersStringWithLength:(NSUInteger)length {
    if (length == 0) return @"";
    
    NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)characters.length);
        unichar character = [characters characterAtIndex:randomIndex];
        [randomString appendFormat:@"%C", character];
    }
    
    return [randomString copy];
}

+ (NSString *)generateSpecialCharacterStringWithLength:(NSUInteger)length {
    if (length == 0) return @"";
    
    NSString *characters = @"!@#$%^&*()_+-=[]{}|;:,.<>?";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)characters.length);
        unichar character = [characters characterAtIndex:randomIndex];
        [randomString appendFormat:@"%C", character];
    }
    
    return [randomString copy];
}

@end
