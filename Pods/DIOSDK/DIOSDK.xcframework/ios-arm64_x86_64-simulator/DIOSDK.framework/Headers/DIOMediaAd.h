//
//  DIOMediaAd.h
//  DIOSDK
//
//  Created by Ariel Malka on 2/26/19.
//  Copyright © 2019 Display.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SafariServices/SafariServices.h>

#import <DIOSDK/DIOAdUnit.h>
#import <DIOSDK/DIOMediaPlayer.h>
#import <DIOSDK/DIOEndCard.h>

static const NSInteger kDIOAudioAccentColor = 0xDFEE47;

NS_ASSUME_NONNULL_BEGIN

@interface DIOMediaAd : DIOAdUnit <DIOEndCardDelegate, DIOMediaPlayerDelegate, SFSafariViewControllerDelegate>

@property (nonatomic, strong) DIOMediaPlayer *player;
@property (nonatomic, strong, nullable) DIOEndCard *endCard;
@property (nonatomic, strong) id mediaData;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) BOOL isStreaming;
@property (nonatomic, strong) NSString *clickURL;
@property (nonatomic) BOOL defaultMute;
@property (nonatomic) BOOL allowPlaybackWhenOutOfView;
@property (nonatomic, strong) NSString* ctaText;
@property (nonatomic) int mediaDuration;

- (BOOL)useBlurredEndCard;
- (BOOL)prefersEndCardClickUrl;
- (void)logMediaPlayerError:(NSError*)error;
- (void)parseMediaFile;
- (BOOL)safeParseMediaFileWithErrorHandler:(void (^)(NSError*))errorHandler;
- (void)triggerOmLoadedEvent;
- (void)createMediaAdSession:(nullable UIView*)videoView;
- (void)replaceVideoWithEndcard:(UIView*)view;
- (id)getVideoEvents;
- (void)handleMediaStart;
- (void)handleMediaComplete;
- (void)handleMediaClick;
- (void)mediaPreloadDidFailWithError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
