//
//  UIImageView+Async.m
//
//  Created by Moacir Lamego on 31/07/15.
//


#import "UIImageView+Async.h"
#import "ImageCache.h"
#import <objc/runtime.h>

static void *CustomObjectStringKey = @"CustomObjectStringKey";
static void *CustomObjectSpinnerKey = @"CustomObjectSpinnerKey";
static void *CustomObjectSizeKey = @"CustomObjectSizeKey";

@interface UIImageView ()

@end

@implementation UIImageView (Async)

#pragma mark - Setters e Getters

- (NSString*)stringUrl
{
    return objc_getAssociatedObject(self, CustomObjectStringKey);
}

- (void)setStringUrl:(NSString *)stringUrl
{
    objc_setAssociatedObject(self, CustomObjectStringKey, stringUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BeautySpinner*)spinner
{
	return objc_getAssociatedObject(self, CustomObjectSpinnerKey);
}

- (void)setSpinner:(BeautySpinner *)spinner
{
	objc_setAssociatedObject(self, CustomObjectSpinnerKey, spinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)forcedSize
{
    return [objc_getAssociatedObject(self, CustomObjectSizeKey) CGSizeValue];
}

- (void)setForcedSize:(CGSize)forcedSize
{
    objc_setAssociatedObject(self, CustomObjectSizeKey, [NSValue valueWithCGSize:forcedSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Set imag async

- (void)removeSpinner
{
	[self.spinner stopAnimating];
	[self.spinner removeFromSuperview];
	self.spinner = nil;
	[self setBackgroundColor:[UIColor clearColor]];
}

- (void)setImageFromURL:(NSURL*)url withBorder:(BOOL)border
{
    [self setImageFromStringURL:url.absoluteString withBorder:border];
}

- (void)setImageFromStringURL:(NSString*)stringUrl withBorder:(BOOL)border
{
    // Retira imagem (se houver); Seta cor de fundo
    BOOL fade = (self.image == nil);
    [self setImage:nil];
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    // Insere spinner
	if (!self.spinner) {
		self.spinner = [[BeautySpinner alloc] initWithSize:SpinnerBig];
    
		self.spinner.frame = CGRectMake(self.frame.size.width/2 + self.spinner.frame.size.width/2,
										self.frame.size.height/2,
										self.spinner.frame.size.width,
										self.spinner.frame.size.height);
    
		[self.spinner startAnimating];
		[self addSubview:self.spinner];
	}
    
    // Aplica imagem obtida assincronamente
    CGSize requestSize = (CGSizeEqualToSize(self.forcedSize, CGSizeZero)) ? self.frame.size : self.forcedSize;
    [ImageCache asyncRequestImageFromStringURL:stringUrl size:requestSize border:border forceRemote:NO success:^(UIImage *image)
    {
        if (fade)
        {
            [UIView transitionWithView:self
                              duration:FADE_ANIMATION_DURATION
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^
             {
                 [self setImage:image];
                 [self.spinner setHidden:YES];
                 
             } completion:^(BOOL finished)
             {
                 [self removeSpinner];
             }];
        }
        else
        {
            [self setImage:image];
            [self.spinner setHidden:YES];
            [self removeSpinner];
        }
        
    } fail:^(NSError *error)
    {
		[self removeSpinner];
        [self setImage:DEFAULT_IMG];
    }];
}


- (void)setImageFromStringURL:(NSString*)stringUrl withBorder:(BOOL)border andBackgroundList:(BOOL)backList
{
    // Retira imagem (se houver); Seta cor de fundo
    BOOL fade = (self.image == nil);
    [self setImage:nil];
    if(backList) {
        [self setImage:[UIImage imageNamed:@"fallback_list"]];
    }
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    // Insere spinner
    if (!self.spinner)
    {
        self.spinner = [[BeautySpinner alloc] initWithSize:SpinnerBig];
        
        self.spinner.frame = CGRectMake(self.frame.size.width/2 + self.spinner.frame.size.width/2,
                                        self.frame.size.height/2,
                                        self.spinner.frame.size.width,
                                        self.spinner.frame.size.height);
        
        [self.spinner startAnimating];
        [self addSubview:self.spinner];
    }
    
    // Aplica imagem obtida assincronamente
    CGSize requestSize = (CGSizeEqualToSize(self.forcedSize, CGSizeZero)) ? self.frame.size : self.forcedSize;
    [ImageCache asyncRequestImageFromStringURL:stringUrl size:requestSize border:border forceRemote:NO success:^(UIImage *image)
     {
         if (fade)
         {
             [UIView transitionWithView:self
                               duration:FADE_ANIMATION_DURATION
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^
              {
                  [self setImage:image];
                  [self.spinner setHidden:YES];
                  
              } completion:^(BOOL finished)
              {
                  [self removeSpinner];
              }];
         }
         else
         {
             [self setImage:image];
             [self.spinner setHidden:YES];
             [self removeSpinner];
         }
         
     } fail:^(NSError *error)
     {
         [self removeSpinner];
         [self setImage:DEFAULT_IMG];
     }];
}


- (void)setCoverCollageWithCover1:(NSString*)strUrl1 cover2:(NSString*)strUrl2 cover3:(NSString*)strUrl3 cover4:(NSString*)strUrl4
{
    // Retira imagem (se houver); Seta cor de fundo
    [self setImage:nil];
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    // Insere spinner
	if (!self.spinner)
	{
		self.spinner = [[BeautySpinner alloc] initWithSize:SpinnerBig];
		
		self.spinner.frame = CGRectMake(self.frame.size.width/2 - self.spinner.frame.size.width/2,
										self.frame.size.height/2 - self.spinner.frame.size.height/2,
										self.spinner.frame.size.width,
										self.spinner.frame.size.height);
		
		[self.spinner startAnimating];
		[self addSubview:self.spinner];
	}
    
    // Monta mosaico de capas
    CGSize requestSize = (CGSizeEqualToSize(self.forcedSize, CGSizeZero)) ? self.frame.size : self.forcedSize;
    [ImageCache mountImg1:strUrl1 img2:strUrl2 img3:strUrl3 img4:strUrl4 size:requestSize success:^(UIImage *image, NSString *path)
    {
        [UIView transitionWithView:self
                          duration:FADE_ANIMATION_DURATION
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^
         {
             [self setImage:image];
             [self.spinner setHidden:YES];
             
         } completion:^(BOOL finished)
         {
			 [self removeSpinner];
         }];
        
    } fail:^(NSError *error)
    {
		[self removeSpinner];
        [self setImage:DEFAULT_IMG];
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.stringUrl)
    {
        [self setImageFromStringURL:self.stringUrl withBorder:YES];
    }
}

@end