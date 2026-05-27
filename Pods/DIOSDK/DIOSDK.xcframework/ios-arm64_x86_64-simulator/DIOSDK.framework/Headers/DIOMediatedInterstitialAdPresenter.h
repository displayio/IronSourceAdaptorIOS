//
//  DIOMediatedInterstitialAdPresenter.h
//  DIOSDK
//
//  Created by Roman Do on 28.05.2025.
//  Copyright © 2025 Display.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DIOMediatedInterstitialAdPresenter <NSObject>

- (void)showInterstitialAdFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
