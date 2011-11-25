//
//  CATViewController.m
//  CATch
//
//  Created by Tiger Yang on 2011/11/22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CATViewController.h"
#import "CATGameController.h"
#import "CATMap.h"
#import "CATRole.h"
#import "CATUtil.h"

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
    
    gameController = [[CATGameController alloc] initWiteView:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
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
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        return NO;
    if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return NO;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return NO;
    return YES;
}

- (void)dealloc
{
    [gameController release];
    gameController = nil;
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
    [gameController getMyNextPosition:acc];
    if ([gameController checkCaught])
    {
        [timer invalidate]; 
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"You caught him!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


@end
