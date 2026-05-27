
#import <DIOSDK/DIOMediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIOPureAudioPlayer : DIOMediaPlayer

- (instancetype)initWithPrimer:(BOOL)primerMessage;
- (void)setUsePrimer:(BOOL)usePrimerMessage;

@end

NS_ASSUME_NONNULL_END
