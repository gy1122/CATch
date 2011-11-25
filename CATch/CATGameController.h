//
//  CATGameController.h
//  CATch
//
//  Created by Tiger Yang on 2011/11/25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CATMap;
@class CATRole;
@class CATViewController;

@interface CATGameController : NSObject {
    CATMap              *map;
    CATRole             *roleMe;
    CATRole             *roleOpp;
    
    CATViewController   *delegate;
}

@property(nonatomic,assign) id delegate;

- (id)initWiteView:(CATViewController *)del;

- (void)getMyNextPosition:(UIAcceleration *)acc;
- (BOOL)checkCaught;

@end
