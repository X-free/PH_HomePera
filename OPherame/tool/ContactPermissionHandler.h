//
//  ContactPermissionHandler.h
//  OPherame
//
//  Created by todesk on 2025/6/27.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ContactSelectionHandler)(NSString * _Nullable name, NSString * _Nullable phoneNumber);
typedef void (^PermissionDeniedHandler)(void);

@interface ContactPermissionHandler : NSObject

+ (instancetype)sharedInstance;

- (void)requestContactPermissionWithViewController:(UIViewController *)viewController
                            onContactSelected:(ContactSelectionHandler)selectionHandler
                          onPermissionDenied:(PermissionDeniedHandler)deniedHandler;

- (void)uploadAllContactsWithCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
