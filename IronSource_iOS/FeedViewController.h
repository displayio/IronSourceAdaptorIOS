//
//  FeedViewController.h
//  IronSource_iOS
//
//  Created by Ro Do on 22.03.2024.
//

#import <UIKit/UIKit.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UITableViewController
@property (nonatomic, strong) NSString *adUnitType;
@property (nonatomic, strong, nullable) LPMBannerAdView *preloadedAdView;

@end

NS_ASSUME_NONNULL_END
