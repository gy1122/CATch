//
//  CATMap.h
//  CATch
//
//  Created by Tiger Yang on 2011/11/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCollisionFrameCount 512
#define kTunnelCount 64

typedef struct {
    CGPoint inPoint;
    CGPoint outPoint;
} Tunnel;

@interface CATMap : NSObject {
    CGRect  collisionFrame[kCollisionFrameCount];
    CGRect  boundary;
    int     collisionFrameCount;
    
    Tunnel  tunnel[kTunnelCount];
    int     tunnelCount;
}

@property(nonatomic) CGRect boundary;
@property(nonatomic) int collisionFrameCount;
@property(nonatomic) int tunnelCount;

- (void) addFrame:(CGRect)rect;
- (void) addTunnel:(CGPoint)inPoint outPoint:(CGPoint)outPoint;
- (BOOL) checkCollisionX:(CGRect)rect left:(BOOL)l;
- (BOOL) checkCollisionY:(CGRect)rect top:(BOOL)l;
- (CGPoint) checkInTunnel:(CGRect)rect;

@end
