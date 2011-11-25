//
//  CATViewController.h
//  CATch
//
//  Created by Tiger Yang on 2011/11/22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATMap;
@class CATRole;
@class CATGameController;

@interface CATViewController : UIViewController <UIAccelerometerDelegate> {
    UIAcceleration      *acc;
    NSTimer             *timer;
    
    CATGameController   *gameController;
}

@property(nonatomic, retain) UIAcceleration *acc;

- (void)gameLoop;

@end

