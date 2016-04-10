//
//  UIImageView+Async.h
//
//  Created by Moacir Lamego on 31/07/15.
//

#import <UIKit/UIKit.h>
#import "BeautySpinner.h"

#define FADE_ANIMATION_DURATION     .3f
#define DEFAULT_IMG                 [UIImage imageNamed:@"default_image"]

@interface UIImageView (Async)

@property (nonatomic,strong) NSString *stringUrl;
@property (nonatomic,strong) BeautySpinner *spinner;
@property (nonatomic)        CGSize forcedSize;

- (void)setImageFromURL:(NSURL*)url withBorder:(BOOL)border;
- (void)setImageFromStringURL:(NSString*)stringUrl withBorder:(BOOL)border;
- (void)setImageFromStringURL:(NSString*)stringUrl withBorder:(BOOL)border andBackgroundList:(BOOL)backList;

- (CGSize)forcedSize;
- (void)setForcedSize:(CGSize)forcedSize;

- (void)setCoverCollageWithCover1:(NSString*)strUrl1 cover2:(NSString*)strUrl2 cover3:(NSString*)strUrl3 cover4:(NSString*)strUrl4;

@end
