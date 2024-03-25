//
//  ViewController.h
//  IronSource_iOS
//
//  Created by Ro Do on 21.03.2024.
//

#import <UIKit/UIKit.h>
#import <IronSource/IronSource.h>

@protocol ViewControllerAdDelegate <NSObject>
- (void)interstitialLoaded;
- (void)bannerLoaded:(ISBannerView *)bannerView;
- (void)interstitialFailToLoad;
- (void)bannerFailToLoad;
@end

@interface ViewController : UIViewController <ViewControllerAdDelegate>


@end

