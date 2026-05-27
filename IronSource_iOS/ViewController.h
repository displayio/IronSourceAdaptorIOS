//
//  ViewController.h
//  IronSource_iOS
//
//  Created by Ro Do on 21.03.2024.
//

#import <UIKit/UIKit.h>
#import <IronSource/IronSource.h>

// LevelPlay ad unit IDs (from the IronSource dashboard). Centralized here so every
// screen pulls the same values. Defined in ViewController.m.
extern NSString *const kAdUnitInfeed;        // Infeed (MediumRectangle 300x250)
extern NSString *const kAdUnitInterstitial;  // Interstitial
extern NSString *const kAdUnitIS;            // Interscroller
extern NSString *const kAdUnitNative;        // reserved for future use
extern NSString *const kAdUnitRewarded;      // reserved for future use

@protocol ViewControllerAdDelegate <NSObject>
- (void)interstitialLoaded;
- (void)bannerLoaded:(LPMBannerAdView *)bannerView;
- (void)interstitialFailToLoad;
- (void)bannerFailToLoad;
@end

@interface ViewController : UIViewController <ViewControllerAdDelegate>


@end

