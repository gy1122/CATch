//
//  CATRole.h
//  CATch
//
//  Created by Tiger Yang on 2011/11/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PLAYER_STATE_NONE = 0,
    
    PLAYER_STATE_MOVE = 1,
    PLAYER_STATE_GHOST = 2
} PlayerStateFlag;

// PlayerInfo is information to be sent to peers.
typedef struct {
    CGPoint     position;
    CGFloat     rotation;
    int         state;
} PlayerInfo;

typedef struct {
    int         roleId;
    int         height;
    int         weight;
    float       maxSpeed;
    float       accTune;
    
    UIImage     *face;
    NSArray     *motionIdle;
    NSArray     *motionMove;
} RoleNative;

@interface CATRole : NSObject {
    RoleNative      native;
    PlayerInfo      info;
    
    // managed
    float           vSpeed;
    float           hSpeed;
    CGPoint         newPoint;
    
    // display
    UIImageView     *curMotion;
    unsigned int    animationIndex;
}

@property(nonatomic) BOOL           managed;
@property(nonatomic) RoleNative     native;
@property(nonatomic) PlayerInfo     info;
@property(nonatomic) float          vSpeed;
@property(nonatomic) float          hSpeed;
@property(nonatomic) CGPoint        newPoint;
@property(nonatomic, retain) UIImageView    *curMotion;

- (id) initWithRole:(RoleNative)n;

- (void) setState:(PlayerStateFlag)state;
- (void) resetState:(PlayerStateFlag)state;

- (void) calcNextPoint:(UIAcceleration *)acc;
- (void) update;
- (void) updateWithInfo:(PlayerInfo)newInfo;

- (float) getBound;

+ (CATRole *)roleMelonman;
+ (CATRole *)roleFireRon;

@end
