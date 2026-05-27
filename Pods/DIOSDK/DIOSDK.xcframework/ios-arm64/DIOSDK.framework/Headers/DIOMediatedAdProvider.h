//
//  MediatedAdProvider.h
//  DIOSDK
//
//  Created by Roman Do on 27.05.2025.
//  Copyright © 2025 Display.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DIOMediatedAdEventType) {
    DIOMediatedAdEventTypeError,
    DIOMediatedAdEventTypeAdLoaded,
    DIOMediatedAdEventTypeAdClicked,
    DIOMediatedAdEventTypeAdImpression,
    DIOMediatedAdEventTypeInterstitialDismissed,
    DIOMediatedAdEventTypeInterstitialCompleted
};

typedef void (^DIOMediatedAdEventHandler)(DIOMediatedAdEventType eventType, id value);

@interface DIOMediatedAdProvider : NSObject

+ (nullable instancetype)factoryWithDisplayManager:(NSString *)displayManager;

- (void)createAdViewWithPayload:(id)payload
                       eventHandler:(DIOMediatedAdEventHandler)handler;

- (void)createInterstitialWithPayload:(id)payload
                         eventHandler:(DIOMediatedAdEventHandler)handler;

- (void)createNativeAdWithPayload:(id)payload
                     eventHandler:(DIOMediatedAdEventHandler)handler;

- (void)cleanup;

@end

NS_ASSUME_NONNULL_END
