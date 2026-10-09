//
//  ISDIOCustomInterstitial.m
//  IronSource_iOS
//
//  Created by Ro Do on 22.03.2024.
//

#import "ISDIOCustomInterstitial.h"
#import <DIOSDK/DIOSDK.h>


@interface ISDIOCustomInterstitial ()

@property (nonatomic, strong, nullable) DIOAd *interstitialAd;

@end

@implementation ISDIOCustomInterstitial

- (void)loadAdWithAdData:(nonnull ISAdData *)adData delegate:(nonnull id<ISInterstitialAdDelegate>)delegate {
    NSString *placementId = [adData getString:@"dio_placement_id"];
    if (placementId == nil || [placementId length] == 0) {
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorMissingParams
                                  errorMessage:@"Placement Id missed"];
        return;
    }
    DIOPlacement *placement = [[DIOController sharedInstance] placementWithId:placementId];
    if (placement == nil || ![placement isKindOfClass:[DIOInterstitialPlacement class]]) {
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorInternal
                                  errorMessage:@"No placement or placement is not an Interstitial type"];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        DIOAdRequest *adRequest = [placement newAdRequest];

        [adRequest requestAdWithAdReceivedHandler:^(DIOAd *ad) {
            self.interstitialAd = ad;
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
                        delegate:(nonnull id<ISInterstitialAdDelegate>)delegate {
    dispatch_async(dispatch_get_main_queue(), ^{
        DIOAd *ad = self.interstitialAd;
        if (ad == nil || ad.impressed) {
            [delegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal errorMessage:@"Failed to show Ad"];
            return;
        }
        BOOL isVideo = [ad isKindOfClass:DIOInterstitialVast.class];
        __block BOOL ended = NO;
        [ad showAdFromViewController:viewController eventHandler:^(DIOAdEvent event) {
            switch (event) {
                case DIOAdEventOnShown:{
                    [delegate adDidOpen];
                    [delegate adDidBecomeVisible];
                    if (isVideo) {
                        [delegate adDidStart];
                    }
                    break;
                }
                case DIOAdEventOnFailedToShow:{
                    if (!ad.impressed) {
                        [delegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal errorMessage:@"Failed to show ad"];
                    }
                    self.interstitialAd = nil;
                    break;
                }
                case DIOAdEventOnClicked:{
                    [delegate adDidClick];
                    break;
                }
                case DIOAdEventOnAdCompleted:{
                    if (isVideo && !ended) {
                        ended = YES;
                        [delegate adDidEnd];
                    }
                    break;
                }
                case DIOAdEventOnClosed:{
                    [delegate adDidClose];
                    self.interstitialAd = nil;
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
    return self.interstitialAd != nil && !self.interstitialAd.impressed;
}

@end
