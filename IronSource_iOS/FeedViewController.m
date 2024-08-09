//
//  FeedViewController.m
//  IronSource_iOS
//
//  Created by Ro Do on 22.03.2024.
//

#import "FeedViewController.h"
#import "BannerAdDelegate.h"
#import <DIOSDK/DIOSDK.h>
#import <IronSource/IronSource.h>

@interface FeedViewController () <LevelPlayBannerDelegate>

@property (nonatomic, strong) ISBannerView *adView;

@end

@implementation FeedViewController
BOOL isClicked;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell1"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell2"];
    
    [self createInlineAd];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)createInlineAd {
    [IronSource setLevelPlayBannerDelegate:self];
    [IronSource loadBannerWithViewController:self size:ISBannerSize_RECTANGLE];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (isClicked) {
        isClicked = NO;
        return;
    }
    [[DIOController sharedInstance] finishAllAds];
    if (self.adView != nil) {
        [IronSource destroyBanner:self.adView];
        self.adView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 139;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 25 && self.adView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.adView];
        self.adView.translatesAutoresizingMaskIntoConstraints = NO;
        if ([self.adUnitType isEqual:@"IF"]) {
            self.adView.frame = CGRectMake(0, 0, 300, 250);
            [cell.contentView.centerXAnchor constraintEqualToAnchor:self.adView.centerXAnchor].active = YES;
            [self.adView.widthAnchor constraintEqualToConstant:300].active = YES;
            [self.adView.heightAnchor constraintEqualToConstant:250].active = YES;
            } else {
                [cell.contentView.leadingAnchor constraintEqualToAnchor:self.adView.leadingAnchor].active = YES;
                [cell.contentView.trailingAnchor constraintEqualToAnchor:self.adView.trailingAnchor].active = YES;
            }
        
        [cell.contentView.topAnchor constraintEqualToAnchor:self.adView.topAnchor].active = YES;
        [cell.contentView.bottomAnchor constraintEqualToAnchor:self.adView.bottomAnchor].active = YES;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Simple Cell";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 25 && [self.adUnitType isEqual:@"IF"]) {
        return 250;
    }
    return UITableViewAutomaticDimension;
}

- (void)close:(id)sender {
    if (self.adView != nil) {
        [IronSource destroyBanner:self.adView];
        self.adView = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LevelPlayBannerDelegate
/**
 Called after each banner ad has been successfully loaded, either a manual load or banner refresh
 @param adInfo The info of the ad.
 */
- (void)didLoad:(ISBannerView *)bannerView withAdInfo:(ISAdInfo *)adInfo{
    self.adView = bannerView;
    NSLog(@"Banner was loaded");
    NSLog(@"adInfo = %@", adInfo);
}
/**
 Called after a banner has attempted to load an ad but failed.
 This delegate will be sent both for manual load and refreshed banner failures.
 @param error The reason for the error
 */
- (void)didFailToLoadWithError:(NSError *)error{
}
/**
 Called after a banner has been clicked.
 @param adInfo The info of the ad.
 */
- (void)didClickWithAdInfo:(ISAdInfo *)adInfo{
    isClicked = YES;
}
/**
 Called when a user was taken out of the application context.
 @param adInfo The info of the ad.
 */
- (void)didLeaveApplicationWithAdInfo:(ISAdInfo *)adInfo{
}
/**
 Called when a banner presented a full screen content.
 @param adInfo The info of the ad.
 */
- (void)didPresentScreenWithAdInfo:(ISAdInfo *)adInfo{
}
/**
 Called after a full screen content has been dismissed.
 @param adInfo The info of the ad.
 */
- (void)didDismissScreenWithAdInfo:(ISAdInfo *)adInfo{
}

@end
