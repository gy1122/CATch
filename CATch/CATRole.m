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

- (id) initWithRole:(RoleNative)n
{
    native = n;
    info.position = CGPointMake(0.0f, 0.0f);
    info.rotation = 0;
    info.state = PLAYER_STATE_NONE;
    
    vSpeed = 0.0f;
    hSpeed = 0.0f;
    
    CGRect imageRect = CGRectMake(info.position.x, info.position.y, native.weight, native.height);
    curMotion = [[UIImageView alloc] initWithFrame:imageRect];
    curMotion.opaque = NO;
    curMotion.image = [native.motionMove objectAtIndex:0];
    curMotion.backgroundColor = [UIColor clearColor];
    curMotion.contentMode = UIViewContentModeScaleAspectFit;
    curMotion.center = info.position;
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

#pragma mark - State modifications

- (void) setState:(PlayerStateFlag)state
{
    info.state = info.state|state;
}

- (void) resetState:(PlayerStateFlag)state
{
    info.state = info.state&(~state);
}

#pragma mark - Move related

- (void) calcNextPoint:(UIAcceleration *)acc
{
    //curMotion.transform = CGAffineTransformMakeRotation(atan2f(acc.x, acc.y));
    info.rotation = atan2f(acc.y, -acc.x);
    
    hSpeed += acc.y * native.accTune;
    vSpeed += acc.x * native.accTune;
    
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

- (void) updateWithInfo:(PlayerInfo)newInfo
{
    self.info = newInfo;
    [self update];
}

- (float) getBound
{
    // return sqrt((native.weight)*(native.weight) + (native.height)*(native.height))/2.0;
    return native.weight/2;
}

#pragma mark - Roles with native;

+ (CATRole *)roleMelonman
{
    RoleNative native;
    native.roleId = 1;
    native.weight = 100;
    native.height = 100;
    native.maxSpeed = 20.0f;
    native.accTune = 1.5f;
    native.face = [UIImage imageNamed:@"melonman.png"];
    native.motionIdle = [NSArray arrayWithObject:[UIImage imageNamed:@"melonman.png"]];
    native.motionMove = [NSArray arrayWithObjects:[UIImage imageNamed:@"melonman.png"],
                         [UIImage imageNamed:@"melonman2.png"],nil];
    CATRole *role = [[CATRole alloc] initWithRole:native];
    
    return role;
}

+ (CATRole *)roleFireRon
{
    RoleNative native;
    native.roleId = 1;
    native.weight = 100;
    native.height = 100;
    native.maxSpeed = 20.0f;
    native.accTune = 1.5f;
    native.face = [UIImage imageNamed:@"EEfireRon.png"];
    native.motionIdle = [NSArray arrayWithObject:[UIImage imageNamed:@"EEfireRon.png"]];
    native.motionMove = [NSArray arrayWithObject:[UIImage imageNamed:@"EEfireRon.png"]];
    CATRole *role = [[CATRole alloc] initWithRole:native];
    
    return role;
}

@end
