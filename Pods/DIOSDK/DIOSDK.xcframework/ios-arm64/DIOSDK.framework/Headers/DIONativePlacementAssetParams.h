//
//  DIONativePlacementAssetParams.h
//  DIOSDK
//
//  Copyright © 2026 Display.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIONativePlacementAssetParams : NSObject

@property (nonatomic, strong, nullable, readonly) NSNumber *required;
@property (nonatomic, strong, nullable, readonly) NSNumber *len;
@property (nonatomic, strong, nullable, readonly) NSNumber *wmin;
@property (nonatomic, strong, nullable, readonly) NSNumber *hmin;

+ (instancetype)params;

- (instancetype)withRequired:(BOOL)required;
- (instancetype)withLen:(NSInteger)len;
- (instancetype)withWmin:(NSInteger)wmin;
- (instancetype)withHmin:(NSInteger)hmin;

@end

NS_ASSUME_NONNULL_END
