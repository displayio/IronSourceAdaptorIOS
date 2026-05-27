//
//  DIOMediatedAd.h
//  DIOSDK
//
//  Created by Roman Do on 29.05.2025.
//  Copyright © 2025 Display.io. All rights reserved.
//

#import <DIOSDK/DIOAdUnit.h>
#import <DIOSDK/DIOMediatedAdProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIOMediatedAd : DIOAdUnit

@property (nonatomic, strong) DIOMediatedAdProvider* mediatedAdProvider;

@end

NS_ASSUME_NONNULL_END
