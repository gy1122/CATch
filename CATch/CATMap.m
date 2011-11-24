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
@synthesize startPointCount;
@synthesize bgImage;

- (id) initWithFile:(NSString *)path
{
    [super init];
    
    collisionFrameCount = 0;
    tunnelCount = 0;
    startPointCount = 0;
    
    NSError *parseError = nil;
	NSBundle *bundle = [NSBundle mainBundle];
    
    [self parseXMLFileAtURL:[NSURL fileURLWithPath: [bundle pathForResource:path ofType:@"xml"]] parseError:&parseError];
    
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

- (void) addStartPoint:(CGPoint)point
{
    startPoints[startPointCount] = point;
    startPointCount++;
}

- (CGPoint) getStartPoint:(int)i
{
    return startPoints[i];
}

#pragma mark - Related to moving

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

#pragma mark - Map loading

//
// load a game level
//
-(BOOL)parseXMLFileAtURL:(NSURL *)file parseError:(NSError **)error {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:file];
	// we'll do the parsing
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	
	NSError *parseError = [parser parserError];
	if(parseError && error) {
		*error = parseError;
	}
	
	[parser release];
	
	return (parseError) ? YES : NO; 
}

//
// the XML parser calls here with all the elements for the level
//
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if(qName) {
		elementName = qName;
	}
	
    if([elementName isEqualToString:@"background"]) {
		bgImage = [UIImage imageNamed:[attributeDict valueForKey:@"file"]];
	} 
	else if([elementName isEqualToString:@"bound"]) {
		float x = [[attributeDict valueForKey:@"x"] floatValue];
		float y = [[attributeDict valueForKey:@"y"] floatValue];
        float w = [[attributeDict valueForKey:@"width"] floatValue];
        float h = [[attributeDict valueForKey:@"height"] floatValue];
        boundary = CGRectMake(x, y, w, h);
	} 
    else if([elementName isEqualToString:@"block"]) {
		float x = [[attributeDict valueForKey:@"x"] floatValue];
		float y = [[attributeDict valueForKey:@"y"] floatValue];
        float w = [[attributeDict valueForKey:@"width"] floatValue];
        float h = [[attributeDict valueForKey:@"height"] floatValue];
		[self addFrame:CGRectMake(x, y, w, h)];
	}
    else if([elementName isEqualToString:@"tunnel"]) {
		float inx = [[attributeDict valueForKey:@"inX"] floatValue];
		float iny = [[attributeDict valueForKey:@"inY"] floatValue];
        float outx = [[attributeDict valueForKey:@"outX"] floatValue];
        float outy = [[attributeDict valueForKey:@"outY"] floatValue];
		[self addTunnel:CGPointMake(inx, iny) outPoint:CGPointMake(outx, outy)];
	}
	else if([elementName isEqualToString:@"player"]) {
		float x = [[attributeDict valueForKey:@"x"] floatValue];
		float y = [[attributeDict valueForKey:@"y"] floatValue];
        [self addStartPoint:CGPointMake(x, y)];
	} 
}

//
// the level did not load, file not found, etc.
//
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	NSLog(@"Error on XML Parse: %@", [parseError localizedDescription] );
}

@end
