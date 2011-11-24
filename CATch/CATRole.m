//
//  CATRole.m
//  CATch
//
//  Created by Tiger Yang on 2011/11/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CATRole.h"

@implementation CATRole

@synthesize managed;
@synthesize native;
@synthesize info;
@synthesize hSpeed, vSpeed;
@synthesize newPoint;
@synthesize curMotion;

- (id) initWithRole:(RoleNative)n point:(CGPoint)p managed:(BOOL)m
{
    managed = m;
    
    native = n;
    info.position = p;
    info.rotation = -1;
    info.state = PLAYER_STATE_NONE;
    
    vSpeed = 0.0f;
    hSpeed = 0.0f;
    
    CGRect imageRect = CGRectMake(info.position.x, info.position.y, native.weight, native.height);
    curMotion = [[UIImageView alloc] initWithFrame:imageRect];
    curMotion.image = [native.motionIdle objectAtIndex:0];
    [curMotion sizeThatFits:CGSizeMake(native.weight, native.height)];
    animationIndex = 0;
    
    [native.face retain];
    [native.motionIdle retain];
    [native.motionMove retain];
    
    return self;
}

- (void) dealloc 
{
    [native.face release];
    [native.motionIdle release];
    [native.motionMove release];
    native.face = nil;
    native.motionIdle = nil;
    native.motionMove = nil;
    
    [curMotion release];
    curMotion = nil;
    
    [super dealloc];
}

- (void) setState:(PlayerStateFlag)state
{
    info.state = info.state|state;
}

- (void) resetState:(PlayerStateFlag)state
{
    info.state = info.state&(~state);
}

- (void) calcNextPoint:(UIAcceleration *)acc
{
    //curMotion.transform = CGAffineTransformMakeRotation(atan2f(acc.x, acc.y));
    info.rotation = atan2f(acc.x, acc.y);
    
    hSpeed += acc.x;
    vSpeed -= acc.y;
    
    if (hSpeed >  native.maxSpeed) hSpeed =  native.maxSpeed;
    if (hSpeed < -native.maxSpeed) hSpeed = -native.maxSpeed;
    if (vSpeed >  native.maxSpeed) vSpeed =  native.maxSpeed;
    if (vSpeed < -native.maxSpeed) vSpeed = -native.maxSpeed;
    
    newPoint.x = info.position.x + hSpeed;
    newPoint.y = info.position.y + vSpeed;
}

- (void) update
{
    curMotion.center = newPoint;
    info.position = newPoint;
    curMotion.image = [native.motionMove objectAtIndex:(animationIndex % [native.motionMove count])];
    animationIndex++;
    
    curMotion.transform = CGAffineTransformMakeRotation(info.rotation);
}

- (float) getBound
{
    // return sqrt((native.weight)*(native.weight) + (native.height)*(native.height))/2.0;
    return native.weight/2;
}

@end
