#import <UIKit/UIKit.h>
#import "DDPageControl.h"
#import "IntroView.h"


@interface IntroControll : UIView<UIScrollViewDelegate> {
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    UIImageView *backgroundGradientImage;
    
    UIScrollView *scrollView;
    NSArray *pages;
    
    NSTimer *timer;
    
    int currentPhotoNum;
    
}

@property (nonatomic) DDPageControl *pageControl;

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pages;
- (void)startTickTimer;
- (void)stopTickTimer;

@end
