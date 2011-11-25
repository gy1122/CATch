//
//  CATGameController.m
//  CATch
//
//  Created by Tiger Yang on 2011/11/25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CATGameController.h"
#import "CATViewController.h"
#import "CATMap.h"
#import "CATRole.h"
#import "CATUtil.h"

@implementation CATGameController

@synthesize delegate;

- (id)initWiteView:(CATViewController *)del
{
    [super init];
    
    delegate = del;
    
    map = [[CATMap alloc] initWithFile:@"default"];
    
    roleMe =[CATRole roleMelonman];
    roleMe.newPoint = [map getStartPoint:0];
    [roleMe setState:PLAYER_STATE_GHOST];
    [delegate.view addSubview:roleMe.curMotion];
    [roleMe update];
    
    roleOpp = [CATRole roleFireRon];
    roleOpp.newPoint = [map getStartPoint:1];
    [delegate.view addSubview:roleOpp.curMotion];
    [roleOpp update];
    
    return self;
}

- (void)dealloc
{
    [roleMe release];
    [roleOpp release];
    [map release];
    
    roleMe = nil;
    roleOpp = nil;
    map = nil;
    
    [super dealloc];
}

#pragma mark - Game controller

- (void)getMyNextPosition:(UIAcceleration *)acc
{
    // Calculate the next position
    [roleMe calcNextPoint:acc];
    
    CGPoint p = roleMe.curMotion.center;
    double radius = [roleMe getBound];
    CGRect rectx = CGRectMake(roleMe.newPoint.x-radius, p.y-radius, 2*radius, 2*radius);
    CGRect recty = CGRectMake(p.x-radius, roleMe.newPoint.y-radius, 2*radius, 2*radius);
    
    BOOL lx = (roleMe.newPoint.x-roleMe.info.position.x<0);
    BOOL ly = (roleMe.newPoint.y-roleMe.info.position.y>0);
    
    // Make an attempt to move in both x and y deirction
    BOOL cx = [map checkCollisionX:rectx left:lx];
    BOOL cy = [map checkCollisionY:recty top:ly];
    
    // If collided, stay at the previous position
    if (cx && cy) {
        roleMe.newPoint = roleMe.info.position;
        roleMe.hSpeed = -roleMe.hSpeed/2;
        roleMe.vSpeed = -roleMe.vSpeed/2;
    } else if (cx && (!cy)) {
        roleMe.newPoint = CGPointMake(roleMe.info.position.x, roleMe.newPoint.y);
        roleMe.hSpeed = -roleMe.hSpeed/2;
    } else if ((!cx) && cy) {
        roleMe.newPoint = CGPointMake(roleMe.newPoint.x, roleMe.info.position.y);
        roleMe.vSpeed = -roleMe.vSpeed/2;
    }
    
    // Check if move into a tunnel
    CGPoint tpoint = [map checkInTunnel:CGRectMake(roleMe.newPoint.x-radius, roleMe.newPoint.y-radius, 2*radius, 2*radius)];
    if (!CGPointEqualToPoint(tpoint, CGPointMake(-1, -1)))
    {
        roleMe.newPoint = tpoint;
    }
    
    // Update the position
    [roleMe update];
}

// Check if you catch your enemy
- (BOOL)checkCaught
{
    // assert this is false
    if ((roleMe.info.state & PLAYER_STATE_GHOST) == 0) return NO;
    
    double radiusMe = [roleMe getBound];
    double radiusOpp = [roleMe getBound];
    if (DistanceBetweenTwoPoints(roleMe.curMotion.center, roleOpp.curMotion.center) <= (radiusMe+radiusOpp)*0.8) return YES;
    return NO;
}

@end
