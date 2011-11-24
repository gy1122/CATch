//
//  CATMap.m
//  CATch
//
//  Created by Tiger Yang on 2011/11/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CATMap.h"

@implementation CATMap

@synthesize collisionFrameCount;
@synthesize tunnelCount;
@synthesize boundary;

- (id) init
{
    [super init];
    collisionFrameCount = 0;
    tunnelCount = 0;
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) addFrame:(CGRect)rect
{
    collisionFrame[collisionFrameCount] = rect;
    collisionFrameCount++;
}

- (void) addTunnel:(CGPoint)inPoint outPoint:(CGPoint)outPoint
{
    tunnel[tunnelCount].inPoint = inPoint;
    tunnel[tunnelCount].outPoint = outPoint;
    tunnelCount++;
}

- (BOOL) checkCollisionX:(CGRect)rect left:(BOOL)l
{
    if ((l && CGRectGetMinX(rect) <= boundary.origin.x) || ((!l) && CGRectGetMaxX(rect) >= boundary.origin.x+boundary.size.width))
        return YES;

    for (int i = 0; i < collisionFrameCount; i++) 
    {
        if (CGRectIntersectsRect(rect, collisionFrame[i])) {
            if ((!l) && CGRectGetMaxX(rect) >= CGRectGetMinX(collisionFrame[i]) && rect.origin.x < collisionFrame[i].origin.x)
                return YES;
            if (l && CGRectGetMinX(rect) <= CGRectGetMaxX(collisionFrame[i]) && rect.origin.x > collisionFrame[i].origin.x)
                return YES;
        }
    }
   
    return NO;
}

- (BOOL) checkCollisionY:(CGRect)rect top:(BOOL)l
{
    if (((!l) && CGRectGetMinY(rect) <= boundary.origin.y) || (l && CGRectGetMaxY(rect) >= boundary.origin.y+boundary.size.height))
        return YES;
    
    for (int i = 0; i < collisionFrameCount; i++) 
    {
        if (CGRectIntersectsRect(rect, collisionFrame[i])) {
            if (l && CGRectGetMaxY(rect) >= CGRectGetMinY(collisionFrame[i]) && rect.origin.y < collisionFrame[i].origin.y)
                return YES;
            if ((!l) && CGRectGetMinY(rect) <= CGRectGetMaxY(collisionFrame[i]) && rect.origin.y > collisionFrame[i].origin.y)
                return YES;
        }
    }
    
    return NO;
}

- (CGPoint) checkInTunnel:(CGRect)rect
{
    for (int i = 0; i < tunnelCount; i++)
    {
        if (CGRectContainsPoint(rect, tunnel[i].inPoint))
            return tunnel[i].outPoint;
    }
    return CGPointMake(-1, -1);
}

@end
