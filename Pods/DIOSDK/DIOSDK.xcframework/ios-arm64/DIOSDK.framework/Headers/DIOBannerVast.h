//
//  DIOBannerVast.h
//  DIOSDK
//
//  Created by Roman Do on 24.11.2025.
//  Copyright © 2025 Display.io. All rights reserved.
//

#import <DIOSDK/DIOMediaAd.h>
#import <DIOSDK/DIOBannerVideoPlayer.h>
#import <DIOSDK/DIOMediaPreloader.h>
#import <DIOSDK/DIOBannerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIOBannerVast : DIOMediaAd <DIOMediaPreloaderDelegate, DIOBannerViewDelegate>

@property (nonatomic, strong) DIOBannerView *bannerView;

@end

NS_ASSUME_NONNULL_END
