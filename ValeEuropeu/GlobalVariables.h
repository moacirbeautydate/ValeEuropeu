//
//  WTTGlobalVariables.h
//  WorldTracerTablet
//
//  Created by Moacir Lamego on 29/01/15.
//  Copyright (c) 2015 CINQ Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject

+ (GlobalVariables *)shared;

@property (nonatomic) BOOL primeiraVez;
@property (nonatomic) NSMutableDictionary* dictImage;

@end
