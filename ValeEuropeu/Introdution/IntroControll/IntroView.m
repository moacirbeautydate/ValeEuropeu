#import "IntroView.h"

@implementation IntroView

- (id)initWithFrame:(CGRect)frame model:(IntroModel*)model
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (UIColor *)colorFromRGB:(float) red green:(float) green blue:(float) blue alpha:(float) alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}
@end
