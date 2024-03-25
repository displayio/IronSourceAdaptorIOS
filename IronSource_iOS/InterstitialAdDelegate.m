

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
 Called after an interstitial has been loaded
 @param adInfo The info of the ad.
 */
- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
    [self.delegate interstitialLoaded];
}

/**
 Called after an interstitial has attempted to load but failed.
 @param error The reason for the error
 */
- (void)didFailToLoadWithError:(NSError *)error {
    NSLog(@"error = %@", error.localizedDescription);
    [self.delegate interstitialFailToLoad];
}

/**
 Called after an interstitial has been opened.
 This is the indication for impression.
 @param adInfo The info of the ad.
 */
- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called after an interstitial has been displayed on the screen.
 This callback is not supported by all networks, and we recommend using it
 only if it's supported by all networks you included in your build.
 @param adInfo The info of the ad.
 */
- (void)didShowWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called after an interstitial has attempted to show but failed.
 @param error The reason for the error.
 @param adInfo The info of the ad.
 */
- (void)didFailToShowWithError:(NSError *)error
                     andAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"error = %@ | adInfo = %@", error.localizedDescription, adInfo);
}

/**
 Called after an interstitial has been clicked.
 @param adInfo The info of the ad.
 */
- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called after an interstitial has been dismissed.
 @param adInfo The info of the ad.
 */
- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

@end
