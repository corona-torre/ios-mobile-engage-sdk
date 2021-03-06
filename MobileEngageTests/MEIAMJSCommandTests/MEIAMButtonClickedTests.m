#import "Kiwi.h"
#import "MEIAMButtonClicked.h"

SPEC_BEGIN(MEIAMButtonClickedTests)

    __block NSString *campaignId;
    __block MEButtonClickRepository *repositoryMock;
    __block id inAppTrackerMock;
    __block MEIAMButtonClicked *meiamButtonClicked;

    beforeEach(^{
        campaignId = @"123";
        repositoryMock = [MEButtonClickRepository mock];
        inAppTrackerMock = [KWMock nullMockForProtocol:@protocol(MEInAppTrackingProtocol)];
        meiamButtonClicked = [[MEIAMButtonClicked alloc] initWithCampaignId:campaignId repository:repositoryMock inAppTracker:inAppTrackerMock];
    });

    describe(@"commandName", ^{

        it(@"should return 'buttonClicked'", ^{
            [[[MEIAMButtonClicked commandName] should] equal:@"buttonClicked"];
        });

    });

    describe(@"handleMessage:resultBlock:", ^{

        it(@"should not accept missing buttonId", ^{
            NSDictionary *dictionary = @{
                    @"id": @"messageId"
            };
            [[repositoryMock shouldNot] receive:@selector(add:)];

            [meiamButtonClicked handleMessage:dictionary
                                  resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {
                                  }];
        });

        it(@"should call track on trackInAppClick:buttonId:", ^{
            NSString *buttonId = @"789";

            NSDictionary *dictionary = @{
                    @"buttonId": buttonId,
                    @"id": @"messageId"
            };
            [[repositoryMock should] receive:@selector(add:)];
            [[inAppTrackerMock should] receive:@selector(trackInAppClick:buttonId:) withArguments:@"123", buttonId];

            [meiamButtonClicked handleMessage:dictionary
                                  resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {

                                  }];
        });

        it(@"should call add on repositoryMock", ^{
            NSString *buttonId = @"789";

            NSDictionary *dictionary = @{
                    @"buttonId": buttonId,
                    @"id": @"messageId"
            };
            KWCaptureSpy *buttonClickSpy = [repositoryMock captureArgument:@selector(add:)
                                                                   atIndex:0];

            NSDate *before = [NSDate date];
            [meiamButtonClicked handleMessage:dictionary
                                  resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {

                                  }];
            NSDate *after = [NSDate date];

            MEButtonClick *buttonClick = buttonClickSpy.argument;

            [[buttonClick.buttonId should] equal:buttonId];
            [[buttonClick.campaignId should] equal:campaignId];
            [[buttonClick.timestamp should] beBetween:before and:after];
        });

        it(@"should receive success in resultBlock", ^{
            XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
            __block NSDictionary<NSString *, NSObject *> *returnedResult;
            [[repositoryMock should] receive:@selector(add:)];

            [meiamButtonClicked handleMessage:@{@"buttonId": @"123", @"id": @"999"}
                                  resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {
                                      returnedResult = result;
                                      [exp fulfill];
                                  }];
            [XCTWaiter waitForExpectations:@[exp] timeout:30];

            [[returnedResult should] equal:@{@"success": @YES, @"id": @"999"}];
        });

        it(@"should receive failure in resultBlock when there is no buttonId", ^{
            XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
            __block NSDictionary<NSString *, NSObject *> *returnedResult;

            [meiamButtonClicked handleMessage:@{@"id": @"999"}
                                  resultBlock:^(NSDictionary<NSString *, NSObject *> *result) {
                                      returnedResult = result;
                                      [exp fulfill];
                                  }];
            [XCTWaiter waitForExpectations:@[exp] timeout:30];

            [[returnedResult should] equal:@{@"success": @NO, @"id": @"999", @"error": @"Missing buttonId!"}];
        });

    });

SPEC_END



