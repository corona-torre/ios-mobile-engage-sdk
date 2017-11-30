//
// Copyright (c) 2017 Emarsys. All rights reserved.
//

#import "MobileEngage.h"
#import "MEConfig.h"
#import "MobileEngageInternal.h"
#import "MEInbox+Notification.h"
#import "MEIAM.h"

@implementation MobileEngage

static MobileEngageInternal *_mobileEngageInternal;
static MEInbox *_inbox;
static MEIAM *_iam;

+ (void)setupWithMobileEngageInternal:(MobileEngageInternal *)mobileEngageInternal
                               config:(MEConfig *)config
                        launchOptions:(NSDictionary *)launchOptions {
    _mobileEngageInternal = mobileEngageInternal;
    _inbox = [[MEInbox alloc] initWithConfig:config];
    _iam = [MEIAM new];
    [_mobileEngageInternal setupWithConfig:config
                             launchOptions:launchOptions];
}

+ (void)setupWithConfig:(MEConfig *)config
          launchOptions:(NSDictionary *)launchOptions {
    [MobileEngage setupWithMobileEngageInternal:[MobileEngageInternal new]
                                         config:config
                                  launchOptions:launchOptions];
}

+ (void)setPushToken:(NSData *)deviceToken {
    [_mobileEngageInternal setPushToken:deviceToken];
}

+ (NSString *)appLogin {
    [_inbox setAppLoginParameters:[MEAppLoginParameters new]];
    return [_mobileEngageInternal appLogin];
}

+ (NSString *)appLoginWithContactFieldId:(NSNumber *)contactFieldId
                       contactFieldValue:(NSString *)contactFieldValue {
    [_inbox setAppLoginParameters:[[MEAppLoginParameters alloc] initWithContactFieldId:contactFieldId
                                                                     contactFieldValue:contactFieldValue]];
    return [_mobileEngageInternal appLoginWithContactFieldId:contactFieldId
                                           contactFieldValue:contactFieldValue];
}

+ (NSString *)appLogout {
    [_inbox setAppLoginParameters:nil];
    return [_mobileEngageInternal appLogout];
}

+ (NSString *)trackMessageOpenWithUserInfo:(NSDictionary *)userInfo {
    NSNumber *inbox = userInfo[@"inbox"];
    if (inbox && [inbox boolValue]) {
        MENotification *notification = [[MENotification alloc] initWithUserinfo:userInfo];
        [_inbox addNotification:notification];
    }
    return [_mobileEngageInternal trackMessageOpenWithUserInfo:userInfo];
}

+ (NSString *)trackMessageOpenWithInboxMessage:(MENotification *)inboxMessage {
    return [_mobileEngageInternal trackMessageOpenWithInboxMessage:inboxMessage];
}

+ (NSString *)trackCustomEvent:(NSString *)eventName
               eventAttributes:(NSDictionary<NSString *, NSString *> *)eventAttributes {
    return [_mobileEngageInternal trackCustomEvent:eventName
                                   eventAttributes:eventAttributes];
}

+ (void)setStatusDelegate:(id <MobileEngageStatusDelegate>)statusDelegate {
    [_mobileEngageInternal setStatusDelegate:statusDelegate];
}

+ (id <MobileEngageStatusDelegate>)statusDelegate {
    return [_mobileEngageInternal statusDelegate];
}

+ (MEInbox *)inbox {
    return _inbox;
}

+ (MEIAM *)iam {
    return _iam;
}

+ (void)setIam:(MEIAM *)iam {
    _iam = iam;
}

@end
