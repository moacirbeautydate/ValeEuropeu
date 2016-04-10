#import "IntroControll.h"
#import "UIImageView+Async.h"
#import "GlobalVariables.h"
#import "ImageCache.h"


#define  IPAD          (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@implementation IntroControll 

@synthesize pageControl;

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        //Initial Background images
        if(IPAD) {
            CGRect fram = frame;
            fram.origin.y = 50;
            frame = fram;
        } else {
            frame.size.height = frame.size.height-50;
        }
        
        self.backgroundColor = [UIColor blackColor];
        
        backgroundImage1 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage1 setContentMode:UIViewContentModeScaleToFill];
        [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage1];

        backgroundImage2 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage2 setContentMode:UIViewContentModeScaleToFill];
        [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage2];

        //Initial ScrollView
        scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //Initial PageView
        pageControl = [[DDPageControl alloc] init];
        pageControl.numberOfPages = pagesArray.count;
        [pageControl sizeToFit];
        
        
        if ([[UIScreen mainScreen] bounds].size.height < 568) {
            [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-58)];
        } else {
            [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-75)];
        }
        
        pageControl.layer.cornerRadius = 15;
        pageControl.layer.masksToBounds = NO;
        pageControl.layer.borderWidth = .1;
        pageControl.layer.borderColor = (__bridge CGColorRef)([UIColor clearColor]);
    
        [pageControl setDefersCurrentPageDisplay: YES] ;
        [pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
        [pageControl setOnColor: [UIColor colorWithWhite: 1.0f alpha: 1.0f]] ;
        [pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
        [pageControl setIndicatorDiameter: 8.0f] ;
        [pageControl setIndicatorSpace: 10.0f] ;
        [pageControl setLineWidth: 1.0f] ;
        
        [pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
        
//        [self addSubview:pageControl];
        
        //Create pages
        pages = pagesArray;
        
        scrollView.contentSize = CGSizeMake(pages.count * frame.size.width, frame.size.height);
        
        currentPhotoNum = 0;
        
        //insert TextViews into ScrollView
        for(int i = 0; i <  pages.count; i++) {
            
            if(IPAD) {
                CGRect fram = frame;
                fram.origin.y = 200;
                frame = fram;
            }
            
            IntroView *view = [[IntroView alloc] initWithFrame:frame model:[pages objectAtIndex:i]];
            view.frame = CGRectOffset(view.frame, i*frame.size.width, 0);
            [scrollView addSubview:view];
        }
        
        [self initShow];
    }
    
    return self;
}

- (void) tick {
    [UIView animateWithDuration:5.0 animations:^{
        [scrollView setContentOffset:CGPointMake((currentPhotoNum+1 == pages.count ? 0 : currentPhotoNum+1)*self.frame.size.width, 0) animated:YES];
    }];
}

- (void)startTickTimer
{
    if (!timer)
    {
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)stopTickTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void) getImageBackGround2:(NSString*) urlString {
    if ([[GlobalVariables shared].dictImage objectForKey:urlString] != nil) {
        [backgroundImage2 setImage:[[GlobalVariables shared].dictImage objectForKey:[ImageCache sha1:urlString border:NO]]];
    } else {
        [backgroundImage2 setImageFromStringURL:[(IntroModel*) [pages objectAtIndex:currentPhotoNum+1] imageName] withBorder:NO];
    }
}

- (void) initShow {
    int scrollPhotoNumber = (int) MAX(0, MIN(pages.count-1, (int)(scrollView.contentOffset.x / self.frame.size.width)));
    
    
    if ([GlobalVariables shared].primeiraVez) {
        [GlobalVariables shared].primeiraVez=NO;
        backgroundImage1.image = [(IntroModel*)[pages objectAtIndex:currentPhotoNum] image];

        if (currentPhotoNum+1 != [pages count]) {
            [backgroundImage2 setImageFromStringURL:[(IntroModel*) [pages objectAtIndex:currentPhotoNum+1] imageName] withBorder:NO];
        }
    } else
    if(scrollPhotoNumber != currentPhotoNum) {
        
        currentPhotoNum = scrollPhotoNumber;
        
        if (currentPhotoNum+1 != [pages count]) {
            [self getImageBackGround2:[(IntroModel*) [pages objectAtIndex:currentPhotoNum+1] imageName]];
//            [backgroundImage2 setImageFromStringURL:[(IntroModel*) [pages objectAtIndex:currentPhotoNum+1] imageName] withBorder:NO];
        }
        
        if ([[[pages objectAtIndex:currentPhotoNum] imageName] isEqualToString:@"IMG001"]) {
            backgroundImage1.image = [(IntroModel*)[pages objectAtIndex:currentPhotoNum] image];
        } else
            [backgroundImage1 setImageFromStringURL:[(IntroModel*)[pages objectAtIndex:currentPhotoNum] imageName] withBorder:NO];
    }
    
    float offset =  scrollView.contentOffset.x - (currentPhotoNum * self.frame.size.width);
    
    //left
    if(offset < 0) {
        pageControl.currentPage = 0;
        
        offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
        backgroundImage2.alpha = 0;
        backgroundImage1.alpha = (offset / self.frame.size.width);
    
    //other
    } else if(offset != 0) {
        //last
        if(scrollPhotoNumber == pages.count-1) {
            pageControl.currentPage = pages.count-1;
            
            backgroundImage1.alpha = 1.0 - (offset / self.frame.size.width);
        } else {
            
            pageControl.currentPage = (offset > self.frame.size.width/2) ? currentPhotoNum+1 : currentPhotoNum;
            
            backgroundImage2.alpha = offset / self.frame.size.width;
            backgroundImage1.alpha = 1.0 - backgroundImage2.alpha;
        }
        
        [pageControl updateCurrentPageDisplay] ;
    //stable
    } else {
//        if(timer != nil) {
//            pageControl.currentPage = currentPhotoNum;
//            backgroundImage1.alpha = 1;
//            backgroundImage2.alpha = 0;
//        }
        pageControl.currentPage = currentPhotoNum;
        backgroundImage1.alpha = 1;
        backgroundImage2.alpha = 0;
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scroll
{
    [self initShow];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }

    [self initShow];
}

- (void)pageControlClicked:(id)sender
{
	DDPageControl *thePageControl = (DDPageControl *)sender ;
	
	// we need to scroll to the new index
	[scrollView setContentOffset: CGPointMake(scrollView.bounds.size.width * thePageControl.currentPage, scrollView.contentOffset.y) animated: YES];
}

@end
