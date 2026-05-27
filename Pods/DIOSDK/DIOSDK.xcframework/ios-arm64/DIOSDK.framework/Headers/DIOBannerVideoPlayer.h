//
//  DIOBannerVideoPlayer.h
//  DIOSDK
//
//  Created by Roman Do on 24.11.2025.
//  Copyright © 2025 Display.io. All rights reserved.
//

#import <DIOSDK/DIOMediaPlayer.h>
#import <DIOSDK/DIOPlayerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIOBannerVideoPlayer : DIOMediaPlayer

- (instancetype)initWithAd:(id)ad;

@end

NS_ASSUME_NONNULL_END
