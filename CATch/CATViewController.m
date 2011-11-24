//
//  CATViewController.m
//  CATch
//
//  Created by Tiger Yang on 2011/11/22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CATViewController.h"

#define kUpdateInterval (1.0f/60.0f)

@implementation CATViewController

@synthesize acc;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Initialize the accerometer
    UIAccelerometer *accerometer = [UIAccelerometer sharedAccelerometer];
    accerometer.delegate = self;
    accerometer.updateInterval = kUpdateInterval;
    
    map = [[CATMap alloc] initWithFile:@"default"];
    //map.boundary = self.view.bounds;
    //[map addFrame:CGRectMake(300, 300, 600, 20)];
    //[map addFrame:CGRectMake(300, 300, 20, 600)];
    //[map addTunnel:CGPointMake(600, 200) outPoint:CGPointMake(600, 800)];
    
    RoleNative native = {1, 100, 100, 20.0, nil, nil, nil};
    native.face = [UIImage imageNamed:@"melonman.png"];
    native.motionIdle = [NSArray arrayWithObject:[UIImage imageNamed:@"EEfireRon.png"]];
    native.motionMove = [NSArray arrayWithObjects:[UIImage imageNamed:@"melonman.png"],
                                                  [UIImage imageNamed:@"melonman2.png"],nil];
    roleMe = [[CATRole alloc] initWithRole:native point:[map getStartPoint:0] managed:YES];
    [self.view addSubview:roleMe.curMotion];
    
    [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc
{
    [map release];
    map = nil;
    
    [super dealloc];
}

#pragma mark - Accelerometer

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    self.acc = acceleration;
}

#pragma mark - GameLoop

- (void)gameLoop
{
    [self getMyNextPosition];
}

#pragma mark - Game controller

- (void)getMyNextPosition
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
    CGPoint tpoint = [map checkInTunnel:CGRectMake(roleMe.newPoint.x, roleMe.newPoint.y, 2*radius, 2*radius)];
    if (!CGPointEqualToPoint(tpoint, CGPointMake(-1, -1)))
    {
        roleMe.newPoint = tpoint;
    }
    
    // Update the position
    [roleMe update];
}


@end
