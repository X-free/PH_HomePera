//
//  KeychainWrapper.h
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeychainWrapper : NSObject
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (BOOL)removeItemForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
