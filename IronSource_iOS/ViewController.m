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
NSString *const kAdUnitInfeed       = @"wvc82s3hkd6l7ydt";
NSString *const kAdUnitInterstitial = @"28p8pfmeie46nold";
NSString *const kAdUnitIS           = @"dzpfgce0djn5xa4k";
NSString *const kAdUnitNative       = @"x3f8pmsss60tyvhu";
NSString *const kAdUnitRewarded     = @"wkp9a6krbxwthi75";

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

    [self initSDKs];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        LPMBannerAdViewConfig *config = [[[LPMBannerAdViewConfigBuilder alloc] init]
                                         setWithAdSize:[LPMAdSize mediumRectangleSize]].build;
        LPMBannerAdView *banner = [[LPMBannerAdView alloc] initWithAdUnitId:kAdUnitInfeed config:config];
        banner.frame = CGRectMake(0, 0, 300, 250);
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

        if (@available(iOS 11.0, *)) {
            [self.bannerView setCenter:CGPointMake(self.view.center.x,self.view.frame.size.height - (self.bannerView.frame.size.height/2.0) - self.view.safeAreaInsets.bottom)]; // safeAreaInsets is available from iOS 11.0
        } else {
            [self.bannerView setCenter:CGPointMake(self.view.center.x,self.view.frame.size.height - (self.bannerView.frame.size.height/2.0))];
        }
        [self.view addSubview:self.bannerView];
        self.loadBannerMrect.enabled = YES;
        self.showBannerMrect.enabled = NO;
    });
}

- (IBAction)interscrollerPressed:(id)sender {
    [self.bannerView destroy];
    self.bannerView = nil;
    FeedViewController *vc = [FeedViewController new];
    vc.adUnitType = @"IS";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)iInfeedPressed:(id)sender {
    [self.bannerView destroy];
    self.bannerView = nil;
    FeedViewController *vc = [FeedViewController new];
    vc.adUnitType = @"IF";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
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

    LPMInitRequest *initRequest = [[[LPMInitRequestBuilder alloc] initWithAppKey:@"1df03dc05"] build];
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

            [self showToast:@"DIO sdk initialised"];
        } errorHandler:^(NSError * error) {
            [self showToast:@"DIO sdk init failed"];
        }];
    }];
}


@end
