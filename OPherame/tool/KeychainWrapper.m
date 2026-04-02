//
//  KeychainWrapper.m
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import "KeychainWrapper.h"
#import <Security/Security.h>

@implementation KeychainWrapper

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    return [@{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrAccount: key,
        (id)kSecAttrService: [[NSBundle mainBundle] bundleIdentifier] ?: @"",
        (id)kSecAttrAccessible: (id)kSecAttrAccessibleAfterFirstUnlock
    } mutableCopy];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    OSStatus status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    return status == errSecSuccess;
}

+ (NSString *)stringForKey:(NSString *)key {
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == errSecSuccess) {
        ret = [[NSString alloc] initWithData:(__bridge NSData *)keyData encoding:NSUTF8StringEncoding];
    }
    
    if (keyData) CFRelease(keyData);
    return ret;
}

+ (BOOL)removeItemForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    OSStatus status = SecItemDelete((CFDictionaryRef)keychainQuery);
    return status == errSecSuccess || status == errSecItemNotFound;
}

@end
