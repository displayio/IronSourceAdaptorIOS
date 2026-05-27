//
//  DIOInterstitialAudio.h
//  DIOSDK
//
//  Created by Roman Do on 05.01.2026.
//  Copyright © 2026 Display.io. All rights reserved.
//

#import <DIOSDK/DIOMediaAd.h>
#import <DIOSDK/DIOMediaPreloader.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIOInterstitialAudio : DIOMediaAd <DIOMediaPreloaderDelegate>

- (void)renderWithViewController:(UIViewController*)viewController eventHandler:(void (^)(DIOAdEvent event))eventHandler;

@end

NS_ASSUME_NONNULL_END
