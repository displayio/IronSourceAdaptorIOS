//
//  DIOFullscreenAudioCoverLayout.h
//  DIOSDK
//
//  Created by Roman Do on 26.01.2026.
//  Copyright © 2026 Display.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DIOSoundControlListenerBlock)(BOOL isEnabled);

@interface DIOFullscreenAudioCoverLayout : UIView

@property (nonatomic, copy, nullable) DIOSoundControlListenerBlock onSoundControlClicked;
@property (nonatomic, copy, nullable) void(^onMediaContainerClicked)(void);

- (instancetype)initWithLabelText:(nullable NSString *)labelText labelHidden:(BOOL)labelHidden;

- (void)addMediaView:(UIView *)view;
- (void)addPlaceholderMediaView:(UIView *)view;
- (void)addProgressView:(UIView *)progressView;
- (void)setupSoundControlWithMuted:(BOOL)muted;
- (void)setAudioAccentColor:(UIColor *)accentColor buttonTextColor:(UIColor *)buttonTextColor;

@end

NS_ASSUME_NONNULL_END
