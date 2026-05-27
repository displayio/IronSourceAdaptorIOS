//
//  DIONativePlacement.h
//  DIOSDK
//
//  Copyright © 2026 Display.io. All rights reserved.
//

#import <DIOSDK/DIOPlacement.h>
#import <DIOSDK/DIONativePlacementAssetParams.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIONativePlacement : DIOPlacement

- (void)setHeadlineParams:(DIONativePlacementAssetParams *)params;
- (void)setMainImageParams:(DIONativePlacementAssetParams *)params;
- (void)setVideoParams:(DIONativePlacementAssetParams *)params;
- (void)setIconParams:(DIONativePlacementAssetParams *)params;
- (void)setBodyParams:(DIONativePlacementAssetParams *)params;
- (void)setCallToActionParams:(DIONativePlacementAssetParams *)params;
- (void)setPriceParams:(DIONativePlacementAssetParams *)params;

- (nullable DIONativePlacementAssetParams *)assetParamsForAssetId:(NSInteger)assetId;

- (void)loadNativeFromORTB:(id)ortbResp
         adReceivedHandler:(void (^)(DIOAd*))adReceivedHandler
               noAdHandler:(void (^)(NSError*))noAdHandler;

@end

NS_ASSUME_NONNULL_END
