//
//  FirstViewController.h
//  ValeEuropeu
//
//  Created by Moacir Lamego on 04/04/16.
//  Copyright © 2016 Moacir Lamego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "IntroControll.h"


#define urlImage @"http://www.blusistemas.com.br/download/valeeuropeu/revista/img"

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) CGRect frame;


@end

