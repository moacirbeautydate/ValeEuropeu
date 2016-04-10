//
//  WTTGlobalVariables.h
//  BeautyDate
//
//  Created by Moacir Lamego on 20/08/15.
//  Copyright (c) 2015 B2Beauty. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables

static GlobalVariables *_shared = nil;

+(GlobalVariables*) shared
{
    @synchronized([GlobalVariables class])
    {
        if (_shared == nil)
        {
            _shared = [[self alloc] init];
        }
    }
    
    return _shared;
}

-(id)init {
    if (self = [super init]) {
        self.primeiraVez = YES;
    }
    
    return self;
}
@end
