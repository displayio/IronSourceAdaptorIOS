#import "ISDIOCustomRewardedVideo.h"
#import <DIOSDK/DIOSDK.h>

@interface ISDIOCustomRewardedVideo ()

@property (nonatomic, strong, nullable) DIOAd *rewardedAd;
@property (nonatomic) BOOL rewardGranted;

@end

@implementation ISDIOCustomRewardedVideo

- (void)loadAdWithAdData:(nonnull ISAdData *)adData delegate:(nonnull id<ISRewardedVideoAdDelegate>)delegate {
    NSString *placementId = [adData getString:@"dio_placement_id"];
    if (placementId == nil || [placementId length] == 0) {
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorMissingParams
                                  errorMessage:@"Placement Id missed"];
        return;
    }
    DIOPlacement *placement = [[DIOController sharedInstance] placementWithId:placementId];
    if (placement == nil
        || !([placement isKindOfClass:[DIOInterstitialPlacement class]] || [placement isKindOfClass:[DIORewardedVideoPlacement class]])) {
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorInternal
                                  errorMessage:@"No placement or placement is not an Interstitial type"];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        DIOAdRequest *adRequest = [placement newAdRequest];

        [adRequest requestAdWithAdReceivedHandler:^(DIOAd *ad) {
            if (![ad isKindOfClass:DIOInterstitialVast.class] && ![ad isKindOfClass:DIOInterstitialAudio.class]) {
                [ad finish];
                [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeNoFill
                                             errorCode:ISAdapterErrorInternal
                                          errorMessage:@"Received a non-rewardable creative"];
                return;
            }
            self.rewardedAd = ad;
            self.rewardGranted = NO;
            [delegate adDidLoad];
        } noAdHandler:^(NSError *error){
            [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeNoFill
                                         errorCode:ISAdapterErrorInternal
                                      errorMessage:@"No fill"];
        }];
    });
}

- (void)showAdWithViewController:(nonnull UIViewController *)viewController
                          adData:(nonnull ISAdData *)adData
                        delegate:(nonnull id<ISRewardedVideoAdDelegate>)delegate {
    dispatch_async(dispatch_get_main_queue(), ^{
        DIOAd *ad = self.rewardedAd;
        if (ad == nil || ad.impressed) {
            [delegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal errorMessage:@"Failed to show Ad"];
            return;
        }
        [ad showAdFromViewController:viewController eventHandler:^(DIOAdEvent event) {
            switch (event) {
                case DIOAdEventOnShown:{
                    [delegate adDidOpen];
                    [delegate adDidBecomeVisible];
                    [delegate adDidStart];
                    break;
                }
                case DIOAdEventOnFailedToShow:{
                    if (!ad.impressed) {
                        [delegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal errorMessage:@"Failed to show ad"];
                    }
                    self.rewardedAd = nil;
                    break;
                }
                case DIOAdEventOnClicked:{
                    [delegate adDidClick];
                    break;
                }
                case DIOAdEventOnAdCompleted:{
                    [delegate adDidEnd];
                    if (!self.rewardGranted) {
                        self.rewardGranted = YES;
                        [delegate adRewarded];
                    }
                    break;
                }
                case DIOAdEventOnClosed:{
                    [delegate adDidClose];
                    self.rewardedAd = nil;
                    break;
                }
                case DIOAdEventOnAdStarted:
                case DIOAdEventOnSwipedOut:
                case DIOAdEventOnSnapped:
                case DIOAdEventOnMuted:
                case DIOAdEventOnUnmuted:
                    break;
            }
        }];
    });
}

- (BOOL)isAdAvailableWithAdData:(nonnull ISAdData *)adData {
    return self.rewardedAd != nil && !self.rewardedAd.impressed;
}

@end
