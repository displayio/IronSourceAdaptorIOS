//
//  ViewController.m
//  IronSource_iOS
//
//  Created by Ro Do on 21.03.2024.
//

#import "ViewController.h"
#import "FeedViewController.h"
#import "InterstitialAdDelegate.h"
#import "BannerAdDelegate.h"
#import <DIOSDK/DIOSDK.h>

// LevelPlay ad unit IDs (from the IronSource dashboard). With IronSource 8+/9+ each ad
// format is loaded by its own ad unit ID instead of the legacy global appKey-only load.
NSString *const kAdUnitBanner       = @"1eyeni5hr976t06u";
NSString *const kAdUnitInfeed       = @"fg0sfdrx050iih6q";
NSString *const kAdUnitInterstitial = @"3y98oeuomvtgj1bw";
NSString *const kAdUnitIS           = @"xu0a4x9dm9fa4ey2";
NSString *const kAdUnitNative       = @"01xo5xvftyxtovvi";
NSString *const kAdUnitRewarded     = @"qfg6631ek1iqdnxg";

@class InlineAdDelegate;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ironsourceVerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dioVerLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadInterstitial;
@property (weak, nonatomic) IBOutlet UIButton *loadBannerMrect;
@property (weak, nonatomic) IBOutlet UIButton *gotoFeedIS;
@property (weak, nonatomic) IBOutlet UIButton *showInterstitial;
@property (weak, nonatomic) IBOutlet UIButton *showBannerMrect;
@property (weak, nonatomic) IBOutlet UIButton *gotoFeedIF;

@property (strong, nonatomic) LPMBannerAdView *bannerView;
@property (strong, nonatomic) LPMInterstitialAd *interstitialAd;
@property (strong, nonatomic) InterstitialAdDelegate *interstitialDelegate;
@property (strong, nonatomic) BannerAdDelegate *bannerDelegate;
@property (strong, nonatomic) LPMRewardedAd *rewardedAd;
@property (strong, nonatomic) UIButton *loadRewarded;
@property (strong, nonatomic) UIButton *showRewarded;
@property (strong, nonatomic) UIButton *showInfeed;
@property (strong, nonatomic) UISwitch *useFeedSwitch;
@property (strong, nonatomic) UIView *adSlot;
@property (strong, nonatomic) LPMBannerAdView *infeedView;
@property (strong, nonatomic) InlineAdDelegate *inlineDelegate;
@end

@interface ViewController () <LPMRewardedAdDelegate>
@end

@interface InlineAdDelegate : NSObject <LPMBannerAdViewDelegate>
@property (nonatomic, copy) void (^onLoad)(void);
@property (nonatomic, copy) void (^onFail)(void);
@end

@implementation InlineAdDelegate
- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"inline didLoad adInfo = %@", adInfo);
    if (self.onLoad) self.onLoad();
}
- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSLog(@"inline didFailToLoad adUnitId = %@ | error = %@", adUnitId, error.localizedDescription);
    if (self.onFail) self.onFail();
}
- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"inline didDisplay adInfo = %@", adInfo);
}
- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"inline didClick adInfo = %@", adInfo);
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ironsourceVerLabel.text = [NSString stringWithFormat:@"IronSource sdk version %@", [LevelPlay sdkVersion]];
    _dioVerLabel.text = [NSString stringWithFormat:@"DisplayIO sdk version %@", [[DIOController sharedInstance] getSDKVersion]];
    self.loadInterstitial.enabled = NO;
    self.loadBannerMrect.enabled = NO;
    self.gotoFeedIS.enabled = NO;
    self.showInterstitial.enabled = NO;
    self.showBannerMrect.enabled = NO;
    self.gotoFeedIF.enabled = NO;
    [self addShowInfeedButton];
    [self addRewardedButtons];
    [self addUseFeedSwitch];
    [self addAdSlot];

    [self initSDKs];
}

- (void)addRewardedButtons {
    UIButtonConfiguration *loadConfig = [UIButtonConfiguration grayButtonConfiguration];
    loadConfig.title = @"Rewarded";
    self.loadRewarded = [UIButton buttonWithConfiguration:loadConfig primaryAction:nil];
    [self.loadRewarded addTarget:self action:@selector(loadRewardedPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIButtonConfiguration *showConfig = [UIButtonConfiguration grayButtonConfiguration];
    showConfig.title = @"Show";
    self.showRewarded = [UIButton buttonWithConfiguration:showConfig primaryAction:nil];
    [self.showRewarded addTarget:self action:@selector(showRewardedPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.loadRewarded.enabled = NO;
    self.showRewarded.enabled = NO;

    self.loadRewarded.translatesAutoresizingMaskIntoConstraints = NO;
    self.showRewarded.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.loadRewarded];
    [self.view addSubview:self.showRewarded];
    [NSLayoutConstraint activateConstraints:@[
        [self.loadRewarded.topAnchor constraintEqualToAnchor:self.gotoFeedIF.bottomAnchor constant:30],
        [self.loadRewarded.leadingAnchor constraintEqualToAnchor:self.gotoFeedIF.leadingAnchor],
        [self.showRewarded.centerYAnchor constraintEqualToAnchor:self.loadRewarded.centerYAnchor],
        [self.showRewarded.leadingAnchor constraintEqualToAnchor:self.showBannerMrect.leadingAnchor]
    ]];
}

- (void)addShowInfeedButton {
    UIButtonConfiguration *showConfig = [UIButtonConfiguration grayButtonConfiguration];
    showConfig.title = @"Show";
    self.showInfeed = [UIButton buttonWithConfiguration:showConfig primaryAction:nil];
    [self.showInfeed addTarget:self action:@selector(showInfeedPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.showInfeed.enabled = NO;
    self.showInfeed.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.showInfeed];
    [NSLayoutConstraint activateConstraints:@[
        [self.showInfeed.centerYAnchor constraintEqualToAnchor:self.gotoFeedIF.centerYAnchor],
        [self.showInfeed.leadingAnchor constraintEqualToAnchor:self.showBannerMrect.leadingAnchor]
    ]];
}

- (void)addUseFeedSwitch {
    UILabel *label = [UILabel new];
    label.text = @"Use Feed";
    self.useFeedSwitch = [UISwitch new];
    self.useFeedSwitch.on = YES;
    self.useFeedSwitch.accessibilityIdentifier = @"useFeedSwitch";
    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[label, self.useFeedSwitch]];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 8;
    row.alignment = UIStackViewAlignmentCenter;
    row.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:row];
    [NSLayoutConstraint activateConstraints:@[
        [row.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [row.bottomAnchor constraintEqualToAnchor:self.loadInterstitial.topAnchor constant:-16]
    ]];
}

- (void)addAdSlot {
    self.adSlot = [UIView new];
    self.adSlot.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adSlot];
    [NSLayoutConstraint activateConstraints:@[
        [self.adSlot.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.adSlot.widthAnchor constraintEqualToConstant:320],
        [self.adSlot.topAnchor constraintEqualToAnchor:self.loadRewarded.bottomAnchor constant:4],
        [self.adSlot.bottomAnchor constraintEqualToAnchor:self.ironsourceVerLabel.topAnchor constant:-2]
    ]];
}

- (void)clearAdSlot {
    for (UIView *v in self.adSlot.subviews) {
        [v removeFromSuperview];
        if (v == self.infeedView) {
            [self.infeedView destroy];
            self.infeedView = nil;
        }
    }
}

- (void)placeInSlot:(UIView *)adView width:(CGFloat)width height:(CGFloat)height {
    [self clearAdSlot];
    [adView removeFromSuperview];
    adView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adSlot addSubview:adView];
    [NSLayoutConstraint activateConstraints:@[
        [adView.centerXAnchor constraintEqualToAnchor:self.adSlot.centerXAnchor],
        [adView.centerYAnchor constraintEqualToAnchor:self.adSlot.centerYAnchor],
        [adView.widthAnchor constraintEqualToConstant:width],
        [adView.heightAnchor constraintEqualToConstant:height]
    ]];
}

- (void)presentFeedWithType:(NSString *)type preloaded:(LPMBannerAdView *)preloaded {
    [self clearAdSlot];
    FeedViewController *vc = [FeedViewController new];
    vc.adUnitType = type;
    vc.preloadedAdView = preloaded;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)loadRewardedPressed:(id)sender {
    self.loadRewarded.enabled = NO;
    self.rewardedAd = [[LPMRewardedAd alloc] initWithAdUnitId:kAdUnitRewarded];
    [self.rewardedAd setDelegate:self];
    [self.rewardedAd loadAd];
}

- (void)showRewardedPressed:(id)sender {
    if (self.rewardedAd != nil && [self.rewardedAd isAdReady]) {
        [self.rewardedAd showAdWithViewController:self placementName:nil];
    } else {
        [self showToast:@"Rewarded is not ready, load another ad"];
    }
    self.showRewarded.enabled = NO;
    self.loadRewarded.enabled = YES;
}

- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"rewarded didLoad adInfo = %@", adInfo);
    self.loadRewarded.enabled = NO;
    self.showRewarded.enabled = YES;
}

- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSLog(@"rewarded didFailToLoad adUnitId = %@ | error = %@", adUnitId, error.localizedDescription);
    self.loadRewarded.enabled = YES;
    self.showRewarded.enabled = NO;
    [self showToast:@"Rewarded fail to load"];
}

- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"rewarded didDisplay adInfo = %@", adInfo);
}

- (void)didFailToDisplayAdWithAdInfo:(LPMAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"rewarded didFailToDisplay error = %@ | adInfo = %@", error.localizedDescription, adInfo);
}

- (void)didRewardAdWithAdInfo:(LPMAdInfo *)adInfo reward:(LPMReward *)reward {
    NSLog(@"rewarded didReward %@ x%ld | adInfo = %@", reward.name, (long)reward.amount, adInfo);
}

- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"rewarded didClick adInfo = %@", adInfo);
}

- (void)didCloseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"rewarded didClose adInfo = %@", adInfo);
}

- (IBAction)loadInterstitialPressed:(id)sender {
    self.loadInterstitial.enabled = NO;
    self.interstitialAd = [[LPMInterstitialAd alloc] initWithAdUnitId:kAdUnitInterstitial];
    [self.interstitialAd setDelegate:self.interstitialDelegate];
    [self.interstitialAd loadAd];
}

- (IBAction)showInterstitialPressed:(id)sender {
    if (self.interstitialAd != nil && [self.interstitialAd isAdReady]) {
        [self.interstitialAd showAdWithViewController:self placementName:nil];
    } else {
        [self showToast:@"Interstitial is not ready, load another ad"];
    }
    self.showInterstitial.enabled = NO;
    self.loadInterstitial.enabled = YES;
}

- (IBAction)loadBannerMrectPressed:(id)sender {
    if (self.bannerView != nil) {
        [self.bannerView destroy];
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    [self clearAdSlot];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        LPMBannerAdViewConfig *config = [[[LPMBannerAdViewConfigBuilder alloc] init]
                                         setWithAdSize:[LPMAdSize bannerSize]].build;
        LPMBannerAdView *banner = [[LPMBannerAdView alloc] initWithAdUnitId:kAdUnitBanner config:config];
        banner.frame = CGRectMake(0, 0, 320, 50);
        self.bannerDelegate.bannerView = banner;
        [banner setDelegate:self.bannerDelegate];
        self.bannerView = banner;
        [banner loadAdWithViewController:self];
    });
}

- (IBAction)showBannerMrectPressed:(id)sender {
    if (self.bannerView == nil) {
        [self showToast:@"Banner is not ready, load another ad"];
        self.loadBannerMrect.enabled = YES;
        self.showBannerMrect.enabled = NO;
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.useFeedSwitch.isOn) {
            LPMBannerAdView *banner = self.bannerView;
            self.bannerView = nil;
            [self presentFeedWithType:@"BN" preloaded:banner];
        } else {
            [self placeInSlot:self.bannerView width:320 height:50];
        }
        self.loadBannerMrect.enabled = YES;
        self.showBannerMrect.enabled = NO;
    });
}

- (IBAction)interscrollerPressed:(id)sender {
    [self.bannerView destroy];
    self.bannerView = nil;
    [self presentFeedWithType:@"IS" preloaded:nil];
}

- (IBAction)iInfeedPressed:(id)sender {
    if (self.infeedView != nil) {
        [self.infeedView removeFromSuperview];
        [self.infeedView destroy];
        self.infeedView = nil;
    }
    self.showInfeed.enabled = NO;
    LPMBannerAdViewConfig *config = [[[LPMBannerAdViewConfigBuilder alloc] init]
                                     setWithAdSize:[LPMAdSize mediumRectangleSize]].build;
    LPMBannerAdView *infeed = [[LPMBannerAdView alloc] initWithAdUnitId:kAdUnitInfeed config:config];
    infeed.frame = CGRectMake(0, 0, 300, 250);
    self.inlineDelegate = [InlineAdDelegate new];
    __weak ViewController *weakSelf = self;
    __weak LPMBannerAdView *weakInfeed = infeed;
    self.inlineDelegate.onLoad = ^{
        if (weakInfeed != nil && weakInfeed == weakSelf.infeedView && weakInfeed.superview == nil) {
            weakSelf.showInfeed.enabled = YES;
        }
    };
    self.inlineDelegate.onFail = ^{
        [weakSelf showToast:@"Infeed fail to load"];
    };
    [infeed setDelegate:self.inlineDelegate];
    self.infeedView = infeed;
    [infeed loadAdWithViewController:self];
}

- (void)showInfeedPressed:(id)sender {
    self.showInfeed.enabled = NO;
    LPMBannerAdView *infeed = self.infeedView;
    if (infeed == nil) {
        [self showToast:@"Infeed is not ready, load another ad"];
        return;
    }
    if (self.useFeedSwitch.isOn) {
        self.infeedView = nil;
        [self presentFeedWithType:@"IF" preloaded:infeed];
    } else {
        self.infeedView = nil;
        [self placeInSlot:infeed width:300 height:250];
        self.infeedView = infeed;
    }
}

- (void)interstitialLoaded {
    self.loadInterstitial.enabled = NO;
    self.showInterstitial.enabled = YES;
}

- (void)interstitialFailToLoad {
    self.loadInterstitial.enabled = YES;
    self.showInterstitial.enabled = NO;
    [self showToast:@"Interstitial fail to load"];
}

- (void)bannerLoaded:(LPMBannerAdView *)bannerView {
    self.bannerView = bannerView;
    self.showBannerMrect.enabled = YES;
}

- (void)bannerFailToLoad {
    self.loadBannerMrect.enabled = YES;
    self.showBannerMrect.enabled = NO;
    [self showToast:@"Banner fail to load"];
}


- (void)showToast:(NSString*)message {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [self dismissViewControllerAnimated:YES completion:nil];
    });
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [self presentViewController:alert animated:YES completion:nil];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)initSDKs{
    self.interstitialDelegate = [[InterstitialAdDelegate alloc] initWithDelegate:self];
    self.bannerDelegate = [[BannerAdDelegate alloc] initWithDelegate:self];

    LPMInitRequest *initRequest = [[[LPMInitRequestBuilder alloc] initWithAppKey:@"2899db815"] build];
    [LevelPlay initWithRequest:initRequest completion:^(LPMConfiguration * _Nullable config, NSError * _Nullable error) {
        if (error != nil) {
            [self showToast:@"IronSource sdk init failed"];
            return;
        }
        [self showToast:@"IronSource sdk initialised"];

        [[DIOController sharedInstance] initializeWithAppId:@"7729" completionHandler:^{
            self.loadInterstitial.enabled = YES;
            self.loadBannerMrect.enabled = YES;
            self.gotoFeedIS.enabled = YES;
            self.gotoFeedIF.enabled = YES;
            self.loadRewarded.enabled = YES;

            [self showToast:@"DIO sdk initialised"];
        } errorHandler:^(NSError * error) {
            [self showToast:@"DIO sdk init failed"];
        }];
    }];
}


@end
