//
// Copyright (c) 2018 Emarsys. All rights reserved.
//
#import <CoreSDK/EMSRequestModelBuilder.h>
#import "Kiwi.h"
#import "EMSRequestModel.h"
#import "EMSTimestampProvider.h"
#import "EMSRequestModelRepository.h"
#import "MERequestModelSelectEventsSpecification.h"
#import "EMSSqliteQueueSchemaHandler.h"

#define TEST_DB_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"TestMEDB.db"]

SPEC_BEGIN(RequestModelSpecificationTests)

    __block EMSSQLiteHelper *_dbHelper;
    __block EMSRequestModelRepository *_repository;

    id (^customEventRequestModel)(NSString *eventName, NSDictionary *eventAttributes) = ^id(NSString *eventName, NSDictionary *eventAttributes) {
        return [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
            NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:@{
                    @"type": @"custom",
                    @"name": eventName,
                    @"timestamp": [[EMSTimestampProvider new] currentTimeStamp]}];

            if (eventAttributes) {
                event[@"attributes"] = eventAttributes;
            }

            [builder setUrl:@"https://ems-me-deviceevent.herokuapp.com/v3/devices/12345/events"];
            [builder setMethod:HTTPMethodPOST];
            [builder setPayload:@{@"events": @[event]}];
        }];
    };

    id (^normalRequestModel)(NSString *url) = ^id(NSString *url) {
        return [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
            [builder setUrl:url];
            [builder setMethod:HTTPMethodGET];
        }];
    };


    describe(@"MERequestModelSelectEventsSpecification", ^{

        beforeEach(^{
            [[NSFileManager defaultManager] removeItemAtPath:TEST_DB_PATH error:nil];
            _dbHelper = [[EMSSQLiteHelper alloc] initWithDatabasePath:TEST_DB_PATH schemaDelegate:[EMSSqliteQueueSchemaHandler new]];
            [_dbHelper open];
            _repository = [[EMSRequestModelRepository alloc] initWithDbHelper:_dbHelper];
        });

        afterEach(^{
            [_dbHelper close];
        });

        it(@"should return all custom events", ^{
            EMSRequestModel *item = customEventRequestModel(@"test1", nil);
            EMSRequestModel *item2 = customEventRequestModel(@"test2", nil);
            EMSRequestModel *item3 = customEventRequestModel(@"test3", @{@"key1": @"value1"});
            EMSRequestModel *item4 = customEventRequestModel(@"test4", @{@"key2": @"value2"});
            NSArray *events = @[item, item2, item3, item4];
            [_repository add:item];
            [_repository add:item2];
            [_repository add:item3];
            [_repository add:item4];

            [[[_repository query:[MERequestModelSelectEventsSpecification new]] should] equal:events];
        });

        it(@"should not return none custom event requests", ^{
            EMSRequestModel *item = customEventRequestModel(@"test1", nil);
            EMSRequestModel *item2 = customEventRequestModel(@"test2", nil);
            EMSRequestModel *notCustomEventItem = normalRequestModel(@"https://www.google.com");
            EMSRequestModel *item3 = customEventRequestModel(@"test3", @{@"key1": @"value1"});
            EMSRequestModel *item4 = customEventRequestModel(@"test4", @{@"key2": @"value2"});
            NSArray *events = @[item, item2, item3, item4];
            [_repository add:item];
            [_repository add:item2];
            [_repository add:notCustomEventItem];
            [_repository add:item3];
            [_repository add:item4];

            [[[_repository query:[MERequestModelSelectEventsSpecification new]] should] equal:events];

        });

    });

SPEC_END