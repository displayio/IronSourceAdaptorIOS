//
//  DIONativeAdInterface.h
//  DIOSDK
//
//  Copyright © 2026 Display.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DIONativeMediaView;

@protocol DIONativeAdInterface <NSObject>

- (nullable NSString *)headline;
- (nullable NSString *)body;
- (nullable NSString *)callToAction;
- (nullable NSString *)advertiser;
- (nullable NSString *)price;
- (nullable NSString *)privacy;
- (BOOL)hasVideoContent;

- (void)registerViewForInteraction:(UIView *)nativeAdRoot
                         mediaSlot:(DIONativeMediaView *)mediaSlot
                          iconSlot:(nullable DIONativeMediaView *)iconSlot
                     headlineLabel:(nullable UILabel *)headlineLabel
                         ctaButton:(nullable UIButton *)ctaButton;
- (void)unregisterView;
- (void)close;

@end

NS_ASSUME_NONNULL_END
