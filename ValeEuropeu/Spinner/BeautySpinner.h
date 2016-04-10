//
//  BeautySpinner.h
//
//  Created by Moacir Lamego on 31/07/15.
//

#import <UIKit/UIKit.h>

typedef enum {
    SpinnerSmall = 0,
    SpinnerBig = 1
} SpinnerSize;

#define IMAGE_SMALL_SPIN    [UIImage imageNamed:@"icon_offline_carregando"]
#define IMAGE_BIG_SPIN      [UIImage imageNamed:@"main-refreshList-loading"]

#define SPIN_ANIMATION_DURATION  0.3

@interface BeautySpinner : UIView

@property (nonatomic) SpinnerSize size;
@property (nonatomic) BOOL initAnimating;
@property (nonatomic) BOOL isLoading;

- (id)initWithSize:(SpinnerSize)size;
- (void)startAnimating;
- (void)stopAnimating;

@end
