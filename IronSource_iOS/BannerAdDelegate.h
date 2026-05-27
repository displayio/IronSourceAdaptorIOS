

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerAdDelegate : NSObject<LPMBannerAdViewDelegate>

@property (weak, nonatomic) id<ViewControllerAdDelegate> delegate;
@property (weak, nonatomic) LPMBannerAdView *bannerView;

- (instancetype)initWithDelegate:(id<ViewControllerAdDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
