//
//  DIOViewabilityMeasurer.h
//  DIOSDK
//
//  Created by Roman Do on 29.09.2025.
//  Copyright © 2025 Display.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DIOViewabilityChangeDelegate <NSObject>
- (void)viewabilityDidChange:(NSInteger)percentVisible;
@end

@interface DIOViewabilityMeasurer : NSObject

@property (nonatomic, readonly) NSInteger lastViewability;

- (instancetype)initWithInterval:(NSTimeInterval)interval;
- (void)addDelegate:(id<DIOViewabilityChangeDelegate>)delegate;
- (void)removeDelegate:(id<DIOViewabilityChangeDelegate>)delegate;
- (void)trackView:(UIView *)view;
- (void)stopTracking;

+ (BOOL)isVisible:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
