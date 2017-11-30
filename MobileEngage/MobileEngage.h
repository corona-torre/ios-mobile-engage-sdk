//
// Copyright (c) 2017 Emarsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEInbox.h"

@class MEConfig;
@protocol MobileEngageStatusDelegate;
@class MEIAM;

NS_ASSUME_NONNULL_BEGIN

@interface MobileEngage : NSObject

@property(class, nonatomic, weak, nullable) id <MobileEngageStatusDelegate> statusDelegate;
@property(class, nonatomic, readonly) MEInbox *inbox;
@property(class, nonatomic, readonly) MEIAM *iam;

+ (void)setupWithConfig:(MEConfig *)config
          launchOptions:(nullable NSDictionary *)launchOptions;

+ (void)setPushToken:(NSData *)deviceToken;

+ (NSString *)appLogin;

+ (NSString *)appLoginWithContactFieldId:(nullable NSNumber *)contactFieldId
                       contactFieldValue:(nullable NSString *)contactFieldValue;

+ (NSString *)trackMessageOpenWithUserInfo:(NSDictionary *)userInfo;

+ (NSString *)trackCustomEvent:(NSString *)eventName
               eventAttributes:(nullable NSDictionary<NSString *, NSString *> *)eventAttributes;

+ (NSString *)appLogout;

@end

NS_ASSUME_NONNULL_END