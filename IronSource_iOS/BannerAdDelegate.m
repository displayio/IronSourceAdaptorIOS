

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
 Called after each banner ad has been successfully loaded, either a manual load or banner refresh
 @param adInfo The info of the ad.
 */
- (void)didLoad:(ISBannerView *)bannerView withAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
    [self.delegate bannerLoaded: bannerView];
}

/**
 Called after a banner has attempted to load an ad but failed.
 This delegate will be sent both for manual load and refreshed banner failures.
 @param error The reason for the error.
 */
- (void)didFailToLoadWithError:(NSError *)error {
    NSLog(@"error = %@", error.localizedDescription);
    [self.delegate bannerFailToLoad];
}

/**
 Called after a banner has been clicked.
 @param adInfo The info of the ad.
 */
- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called when a user was taken out of the application context.
 @param adInfo The info of the ad.
 */
- (void)didLeaveApplicationWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called when a banner presented a full screen content.
 @param adInfo The info of the ad.
 */
- (void)didPresentScreenWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

/**
 Called after a full screen content has been dismissed.
 @param adInfo The info of the ad.
 */
- (void)didDismissScreenWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"adInfo = %@", adInfo);
}

@end
