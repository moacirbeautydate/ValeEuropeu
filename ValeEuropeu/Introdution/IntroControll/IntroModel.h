#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface IntroModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, readonly) BOOL isInitialView;

- (id) initWithImage:(NSString*)imageText;

@end
