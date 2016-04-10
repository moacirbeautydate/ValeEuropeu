//
//  BeautySpinner.h
//
//  Created by Moacir Lamego on 31/07/15.
//

#import "BeautySpinner.h"
#import <QuartzCore/QuartzCore.h>

@interface BeautySpinner ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CABasicAnimation *animation;

@end

@implementation BeautySpinner

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.size = SpinnerBig;
    [self _init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self _init];
    }
    
    return self;
}

- (id)initWithSize:(SpinnerSize)size
{
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        self.size = size;
        [self _init];
    }
    
    return self;
}

- (void)_init
{
    UIImage *image;
    
    switch (self.size)
    {
        case SpinnerSmall:
            image = IMAGE_SMALL_SPIN;
            break;
            
        case SpinnerBig:
            image = IMAGE_BIG_SPIN;
            break;
            
        default:
            image = IMAGE_BIG_SPIN;
            break;
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height)];
    [self addSubview:self.imageView];
    
    self.animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.animation.fromValue = [NSNumber numberWithFloat:0.0f];
    self.animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    self.animation.duration = 1.0f;
    self.animation.repeatCount = HUGE_VAL;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAlpha:0];
    
    if (self.initAnimating)
        [self startAnimating];
}

- (void)startAnimating
{
    self.isLoading = YES;
    
    [UIView animateWithDuration:SPIN_ANIMATION_DURATION animations:^
    {
        self.alpha = 1;
    }];
    
    [self.imageView.layer addAnimation:self.animation forKey:@"animation"];
}

- (void)stopAnimating
{
    self.isLoading = NO;
    
    [UIView animateWithDuration:SPIN_ANIMATION_DURATION animations:^
    {
        self.alpha = 0;
    } completion:^(BOOL finished)
    {
        [self.imageView.layer removeAllAnimations];
    }];
}

@end
