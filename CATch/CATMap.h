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
#define kStartPointCount 16

typedef struct {
    CGPoint inPoint;
    CGPoint outPoint;
} Tunnel;

@interface CATMap : NSObject <NSXMLParserDelegate> {
    CGRect  collisionFrame[kCollisionFrameCount];
    CGRect  boundary;
    int     collisionFrameCount;
    
    Tunnel  tunnel[kTunnelCount];
    int     tunnelCount;
    
    CGPoint startPoints[kStartPointCount];
    int     startPointCount;
}

@property(nonatomic) CGRect boundary;
@property(nonatomic) int collisionFrameCount;
@property(nonatomic) int tunnelCount;
@property(nonatomic) int startPointCount;

- (void) addFrame:(CGRect)rect;
- (void) addTunnel:(CGPoint)inPoint outPoint:(CGPoint)outPoint;
- (void) addStartPoint:(CGPoint)point;
- (CGPoint) getStartPoint:(int)i;
- (BOOL) checkCollisionX:(CGRect)rect left:(BOOL)l;
- (BOOL) checkCollisionY:(CGRect)rect top:(BOOL)l;
- (CGPoint) checkInTunnel:(CGRect)rect;

-(BOOL)parseXMLFileAtURL:(NSURL *)file parseError:(NSError **)error;

@end
