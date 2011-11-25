//
//  CATMap2.h
//  CATch
//
//  Created by Tiger Yang on 2011/11/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBlockCountMax 64
#define kTunnelCount 64
#define kStartPointCount 16

typedef struct {
    CGPoint inPoint;
    CGPoint outPoint;
} Tunnel;

@interface CATMap2 : NSObject <NSXMLParserDelegate> {
    CGSize  blockSize;
    int     hBlockCount;
    int     vBlockCount;
    
    char    map[kBlockCountMax][kBlockCountMax];
    
    Tunnel  tunnel[kTunnelCount];
    int     tunnelCount;
    
    CGPoint startPoints[kStartPointCount];
    int     startPointCount;
    
    UIImage *bgImage;
}

@property(nonatomic) int tunnelCount;
@property(nonatomic) int startPointCount;
@property(nonatomic, retain) UIImage *bgImage;

- (id) initWithFile:(NSString *)path;

- (void) addObstacle:(CGPoint)point;
- (void) addTunnel:(CGPoint)inPoint outPoint:(CGPoint)outPoint;
- (void) addStartPoint:(CGPoint)point;
- (CGPoint) getStartPoint:(int)i;
- (BOOL) checkCollisionX:(CGRect)rect left:(BOOL)l;
- (BOOL) checkCollisionY:(CGRect)rect top:(BOOL)l;
- (CGPoint) checkInTunnel:(CGRect)rect;

-(BOOL)parseXMLFileAtURL:(NSURL *)file parseError:(NSError **)error;

@end
