//
//  ISDIOCustomBanner.m
//  IronSource_iOS
//
//  Created by Ro Do on 22.03.2024.
//

#import "ISDIOCustomBanner.h"
#import <DIOSDK/DIOSDK.h>

@interface ISDIOCustomBanner ()

@property (nonatomic, strong, nullable) DIOAd *inlineAd;
@property (nonatomic) BOOL destroyed;

@end

@implementation ISDIOCustomBanner

- (void)loadAdWithAdData:(nonnull ISAdData *)adData
          viewController:(UIViewController *)viewController
                    size:(ISBannerSize *)size
                delegate:(nonnull id<ISBannerAdDelegate>)delegate{

    NSString *placementId = [adData getString:@"dio_placement_id"];
    if (placementId == nil || [placementId length] == 0) {
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorMissingParams
                                  errorMessage:@"Placement Id missed"];
        return;
    }
    DIOPlacement *placement = [[DIOController sharedInstance] placementWithId:placementId];
    if (placement == nil || [placement isKindOfClass:[DIOInterstitialPlacement class]]
        || [placement isKindOfClass:[DIORewardedVideoPlacement class]]) {
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorInternal
                                  errorMessage:@"No placement or placement is not an Inline type"];
        return;
    }
    BOOL isRectangleSize = size.height >= 250;
    BOOL isBannerPlacement = [placement isKindOfClass:[DIOBannerPlacement class]];
    BOOL isRectanglePlacement = [placement isKindOfClass:[DIOInFeedPlacement class]]
        || [placement isKindOfClass:[DIOMediumRectanglePlacement class]];
    if ((isBannerPlacement && isRectangleSize) || (isRectanglePlacement && !isRectangleSize)) {
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorInternal
                                  errorMessage:[NSString stringWithFormat:@"Placement %@ does not match banner size %@", placementId, size.sizeDescription]];
        return;
    }
    self.destroyed = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        DIOAdRequest *adRequest = [placement newAdRequest];

        [adRequest requestAdWithAdReceivedHandler:^(DIOAd *ad) {
            if (self.destroyed) {
                [ad finish];
                return;
            }
            self.inlineAd = ad;
            [self handleInlineAdEvents:ad andNotifyDelegate:delegate];
            UIView *adView = [ad view];
            NSString *adUnitType = ad.adUnitType;
            if ([adUnitType isEqualToString:BANNER]) {
                adView.frame = CGRectMake(0, 0, 320, 50);
                [adView.widthAnchor constraintEqualToConstant:320].active = YES;
                [adView.heightAnchor constraintEqualToConstant:50].active = YES;
            } else if ([adUnitType isEqualToString:INFEED] || [adUnitType isEqualToString:MEDIUMRECTANGLE]) {
                adView.frame = CGRectMake(0, 0, 300, 250);
                [adView.widthAnchor constraintEqualToConstant:300].active = YES;
                [adView.heightAnchor constraintEqualToConstant:250].active = YES;
            } else if ([adUnitType isEqualToString:INTERSCROLLER]) {
                CGSize size = viewController.view.bounds.size;
                adView.frame = CGRectMake(0, 0, size.width, size.height);
                [adView.widthAnchor constraintEqualToConstant:size.width].active = YES;
                [adView.heightAnchor constraintEqualToConstant:size.height].active = YES;
            }
            [delegate adDidLoadWithView: adView];
        } noAdHandler:^(NSError *error){
            if (self.destroyed) {
                return;
            }
            [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeNoFill errorCode:ISAdapterErrorInternal errorMessage:@"No fill"];
        }];

    });
}

- (void)destroyAdWithAdData:(nonnull ISAdData *)adData {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.destroyed = YES;
        DIOAd *ad = self.inlineAd;
        self.inlineAd = nil;
        if (ad != nil) {
            [ad finish];
        }
    });
}


- (void)handleInlineAdEvents:(DIOAd *)ad andNotifyDelegate:(nonnull id<ISBannerAdDelegate>)delegate{
    if(ad == nil || delegate == nil) {
        return;
    }

    __weak ISDIOCustomBanner *weakSelf = self;
    [ad setEventHandler:^(DIOAdEvent event) {
        ISDIOCustomBanner *strongSelf = weakSelf;
        if (strongSelf == nil || strongSelf.destroyed) {
            return;
        }
        switch (event) {
            case DIOAdEventOnShown:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    ISDIOCustomBanner *openSelf = weakSelf;
                    if (openSelf != nil && !openSelf.destroyed) {
                        [delegate adDidOpen];
                    }
                });
                break;
            }
            case DIOAdEventOnClicked:{
                [delegate adDidClick];
                break;
            }
            case DIOAdEventOnFailedToShow:
            case DIOAdEventOnClosed:
            case DIOAdEventOnAdStarted:
            case DIOAdEventOnAdCompleted:
            case DIOAdEventOnSwipedOut:
            case DIOAdEventOnSnapped:
            case DIOAdEventOnMuted:
            case DIOAdEventOnUnmuted:
                break;
        }
    }];
}
@end
