//
//  CATViewController.h
//  CATch
//
//  Created by Tiger Yang on 2011/11/22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATMap.h"
#import "CATRole.h"

@interface CATViewController : UIViewController <UIAccelerometerDelegate> {
    UIAcceleration      *acc;
    CATMap              *map;
    CATRole             *roleMe;
    CATRole             *roleOpp;
}

@property(nonatomic, retain) UIAcceleration *acc;

- (void)gameLoop;
- (void)getMyNextPosition;

@end

