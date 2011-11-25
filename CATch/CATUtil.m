//
//  CATUtil.m
//  CATch
//
//  Created by Tiger Yang on 2011/11/25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CATUtil.h"

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};