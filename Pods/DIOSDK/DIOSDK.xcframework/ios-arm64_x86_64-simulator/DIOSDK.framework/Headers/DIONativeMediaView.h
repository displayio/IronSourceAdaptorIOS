//
//  DIONativeMediaView.h
//  DIOSDK
//
//  Copyright © 2026 Display.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIONativeMediaView : UIView

@property (nonatomic, assign) BOOL blurBackgroundEnabled;

- (void)setIconBitmap:(UIImage *)bitmap;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
