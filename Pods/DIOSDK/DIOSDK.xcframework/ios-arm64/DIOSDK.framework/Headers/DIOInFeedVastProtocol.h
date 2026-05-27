//
//  DIOInFeedVastProtocol.h
//  DIOSDK
//
//  Created by Roman Do on 03.06.2025.
//  Copyright © 2025 Display.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DIOInFeedVastProtocol <NSObject>

@property (nonatomic) bool headlineMode;
@property (nonatomic) bool adLabelHide;
@property (nonatomic) bool ctaHide;
@property (nonatomic) bool advertiserHide;
@property (nonatomic, strong) NSString* adLabelText;
@property (nonatomic, strong) NSString* ctaText;
@property (nonatomic) int rewarded;

@end

NS_ASSUME_NONNULL_END
