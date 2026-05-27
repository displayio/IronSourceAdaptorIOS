

#import "BannerAdDelegate.h"

@implementation BannerAdDelegate

- (instancetype)initWithDelegate:(id<ViewControllerAdDelegate>)delegate {
    self = [super init];

    if (self) {
        _delegate = delegate;
    }

    return self;
}

/**
 Called after a banner ad has been successfully loaded, either a manual load or banner refresh.
 With LevelPlay the loaded view is the `LPMBannerAdView` the publisher created, so it is passed
 back to the view controller via the weakly-held `bannerView` reference.
 @param adInfo The info of the ad.
 */
- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
    [self.delegate bannerLoaded:self.bannerView];
}

/**
 Called after a banner has attempted to load an ad but failed.
 This delegate will be sent both for manual load and refreshed banner failures.
 @param adUnitId The ad unit id of the banner that failed to load.
 @param error The reason for the error.
 */
- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSLog(@"adUnitId = %@ | error = %@", adUnitId, error.localizedDescription);
    [self.delegate bannerFailToLoad];
}

/**
 Called after a banner has been clicked.
 @param adInfo The info of the ad.
 */
- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called when a banner is displayed.
 @param adInfo The info of the ad.
 */
- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called when a user is taken out of the application context.
 @param adInfo The info of the ad.
 */
- (void)didLeaveAppWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called when a banner presents full screen content.
 @param adInfo The info of the ad.
 */
- (void)didExpandAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called after full screen content has been dismissed.
 @param adInfo The info of the ad.
 */
- (void)didCollapseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

@end
