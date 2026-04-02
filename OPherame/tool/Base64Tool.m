//
//  Base64Tool.m
//  OPherame
//
//  Created by todesk on 2025/7/4.
//

#import "Base64Tool.h"

@implementation Base64Tool

#pragma mark - 字符串Base64编码/解码
+ (NSString *)base64EncodeString:(NSString *)string {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)base64DecodeString:(NSString *)base64String {
    if (!base64String) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 数组Base64编码/解码
+ (NSString *)base64EncodeArray:(NSArray *)array {
    if (!array) return nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
    if (error) {
        NSLog(@"数组转JSON失败: %@", error);
        return nil;
    }
    return [jsonData base64EncodedStringWithOptions:0];
}

+ (NSArray *)base64DecodeToArray:(NSString *)base64String {
    if (!base64String) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    if (!data) return nil;
    
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"JSON转数组失败: %@", error);
        return nil;
    }
    return array;
}

#pragma mark - 字典Base64编码/解码
+ (NSString *)base64EncodeDictionary:(NSDictionary *)dictionary {
    if (!dictionary) return nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error) {
        NSLog(@"字典转JSON失败: %@", error);
        return nil;
    }
    return [jsonData base64EncodedStringWithOptions:0];
}

+ (NSDictionary *)base64DecodeToDictionary:(NSString *)base64String {
    if (!base64String) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    if (!data) return nil;
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"JSON转字典失败: %@", error);
        return nil;
    }
    return dictionary;
}

#pragma mark - NSData ↔ Base64 NSString

+ (NSString *)base64EncodeData:(NSData *)inputData {
    if (!inputData) return nil;
    
    NSString *base64String = [inputData base64EncodedStringWithOptions:0];
    return base64String;
}

+ (NSData *)base64DecodeData:(NSString *)base64String {
    if (!base64String) return nil;
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return decodedData;
}
@end
