//
//  FirstViewController.m
//  ValeEuropeu
//
//  Created by Moacir Lamego on 04/04/16.
//  Copyright © 2016 Moacir Lamego. All rights reserved.
//

#import "FirstViewController.h"
#import "ImageCache.h"
#import "UIImageView+Async.h"




@interface FirstViewController ()


@end

@implementation FirstViewController {
    UIImage* img;
    IntroControll *page;

}
@synthesize frame;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i=2; i <= 68; i ++) {
        NSString *pathForFile = [NSString stringWithFormat:@"%@%03d.jpg",urlImage, i];
        
        
        [ImageCache asyncRequestImageFromStringURL:pathForFile size:CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width) border:YES forceRemote:NO success:^(UIImage *image) {
//            NSLog(@"OK: %@", pathForFile);
        } fail:^(NSError *error)
         {
//             NSLog(@"Erro: %@ - %@", pathForFile, error);
         }];
    }

    IntroModel *model1 = [[IntroModel alloc] initWithImage:@"IMG001"];
    IntroModel *model2 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 2]];
    IntroModel *model3 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 3]];
    IntroModel *model4 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 4]];
    IntroModel *model5 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 5]];
    IntroModel *model6 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 6]];
    IntroModel *model7 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 7]];
    IntroModel *model8 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 8]];
    IntroModel *model9 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 9]];
    IntroModel *model10 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 10]];
    IntroModel *model11 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 11]];
    IntroModel *model12 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 12]];
    IntroModel *model13 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 13]];
    IntroModel *model14 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 14]];
    IntroModel *model15 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 15]];
    IntroModel *model16 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 16]];
    IntroModel *model17 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 17]];
    IntroModel *model18 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 18]];
    IntroModel *model19 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 19]];
    IntroModel *model20 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 20]];
    IntroModel *model21 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 21]];
    IntroModel *model22 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 22]];
    IntroModel *model23 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 23]];
    IntroModel *model24 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 24]];
    IntroModel *model25 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 25]];
    IntroModel *model26 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 26]];
    IntroModel *model27 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 27]];
    IntroModel *model28 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 28]];
    IntroModel *model29 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 29]];
    IntroModel *model30 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 30]];
    IntroModel *model31 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 31]];
    IntroModel *model32 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 32]];
    IntroModel *model33 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 33]];
    IntroModel *model34 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 34]];
    IntroModel *model35 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 35]];
    IntroModel *model36 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 36]];
    IntroModel *model37 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 37]];
    IntroModel *model38 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 38]];
    IntroModel *model39 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 39]];
    IntroModel *model40 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 40]];
    IntroModel *model41 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 41]];
    IntroModel *model42 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 42]];
    IntroModel *model43 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 43]];
    IntroModel *model44 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 44]];
    IntroModel *model45 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 45]];
    IntroModel *model46 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 46]];
    IntroModel *model47 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 47]];
    IntroModel *model48 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 48]];
    IntroModel *model49 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 49]];
    IntroModel *model50 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 50]];
    IntroModel *model51 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 51]];
    IntroModel *model52 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 52]];
    IntroModel *model53 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 53]];
    IntroModel *model54 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 54]];
    IntroModel *model55 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 55]];
    IntroModel *model56 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 56]];
    IntroModel *model57 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 57]];
    IntroModel *model58 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 58]];
    IntroModel *model59 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 59]];
    IntroModel *model60 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 60]];
    IntroModel *model61 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 61]];
    IntroModel *model62 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 62]];
    IntroModel *model63 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 63]];
    IntroModel *model64 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 64]];
    IntroModel *model65 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 65]];
    IntroModel *model66 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 66]];
    IntroModel *model67 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 67]];
    IntroModel *model68 = [[IntroModel alloc] initWithImage:[NSString stringWithFormat:@"%@%03d.jpg",urlImage, 68]];

    page = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                          pages:@[model1, model2, model3, model4,model5,model6,model7,model8,model9,model10,
                                                  model11, model12, model13,model14,model15,model16,model17,model18,model19,model20,
                                                  model21, model22, model23,model24,model25,model26,model27,model28,model29,model30,
                                                  model31, model32, model33,model34,model35,model36,model37,model38,model39,model40,
                                                  model41, model42, model43,model44,model45,model46,model47,model48,model49,model50,
                                                  model51, model52, model53,model54,model55,model56,model57,model58,model59,model60,
                                                  model61, model62, model63,model64,model65,model66,model67,model68
                                                  ]];
    
    frame = self.view.frame;
    
    [self.view addSubview:page];
    [self.view sendSubviewToBack:page];
    
    page.pageControl.currentPage = 1;
    page.pageControl.currentPage = 0;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
