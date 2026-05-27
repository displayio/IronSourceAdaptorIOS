//
//  DIOInFlowAudioPlacement.h
//  DIOSDK
//
//  Created by Ro Do on 09.04.2026.
//  Copyright © 2026 Display.io. All rights reserved.
//

#import <DIOSDK/DIOInRingPlacement.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIOInFlowAudioPlacement : DIOInRingPlacement

- (void)loadInFlowAudioFromORTB:(id)ortbResp
              adReceivedHandler:(void (^)(DIOAd*))adReceivedHandler
                    noAdHandler:(void (^)(NSError*))noAdHandler;

@end

NS_ASSUME_NONNULL_END
