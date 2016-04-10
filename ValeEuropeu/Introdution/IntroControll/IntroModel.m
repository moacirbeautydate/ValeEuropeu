#import "IntroModel.h"
#import "ImageCache.h"
#import "GlobalVariables.h"

@implementation IntroModel

@synthesize image, imageName;

- (id) initWithImage:(NSString*)imageText {
    self = [super init];
    if(self != nil) {
        UIImage* img = [[[GlobalVariables shared] dictImage] objectForKey:imageText];
        if (img) {
            image = img;
        } else {
            if (image) {
                [[[GlobalVariables shared] dictImage] setObject:image forKey:imageText];
            }
            imageName = imageText;
            image = [UIImage imageNamed:imageText];
        }
    }
    
    return self;
}

@end
