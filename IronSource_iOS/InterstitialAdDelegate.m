

#import "InterstitialAdDelegate.h"

@implementation InterstitialAdDelegate

- (instancetype)initWithDelegate:(id<ViewControllerAdDelegate>)delegate {
    self = [super init];

    if (self) {
        _delegate = delegate;
    }

    return self;
}

/**
 Triggered when an interstitial ad is successfully loaded.
 @param adInfo Ad info of the loaded interstitial ad.
 */
- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
    [self.delegate interstitialLoaded];
}

/**
 Triggered when an interstitial ad fails to load.
 @param adUnitId The ad unit id of the interstitial ad that fails to load.
 @param error The error that occurred during loading.
 */
- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSLog(@"adUnitId = %@ | error = %@", adUnitId, error.localizedDescription);
    [self.delegate interstitialFailToLoad];
}

/**
 Triggered when an interstitial ad is displayed.
 This is the indication for impression.
 @param adInfo Ad info of the displayed interstitial ad.
 */
- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Triggered when an interstitial ad fails to show.
 @param adInfo Ad info of the interstitial ad that failed to display.
 @param error The error that occurred.
 */
- (void)didFailToDisplayAdWithAdInfo:(LPMAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"error = %@ | adInfo = %@", error.localizedDescription, adInfo);
}

/**
 Triggered when an interstitial ad is clicked.
 @param adInfo Ad info of the clicked interstitial ad.
 */
- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Triggered when an interstitial ad is closed.
 @param adInfo Ad info of the closed interstitial ad.
 */
- (void)didCloseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

@end
