

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InterstitialAdDelegate : NSObject<LevelPlayInterstitialDelegate>

@property (weak, nonatomic) id<ViewControllerAdDelegate> delegate;

- (instancetype)initWithDelegate:(id<ViewControllerAdDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

