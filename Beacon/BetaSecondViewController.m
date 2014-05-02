//
//  BetaSecondViewController.m
//  Beacon
//
//  Created by Zuokun Yu on 2/24/14.
//  Copyright (c) 2014 Hunter YY. All rights reserved.
//

#import "BetaSecondViewController.h"

@interface BetaSecondViewController ()
@property (retain, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (retain, nonatomic) NSTimer *timer;

@end

@implementation BetaSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    BetaAppDelegate *appDelegate;
    appDelegate = [(BetaAppDelegate *)[UIApplication sharedApplication] delegate];
    self.latitudeLabel.text = appDelegate.global_string;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(rotatewarmup) userInfo:nil repeats:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)rotatewarmup
{
    BetaAppDelegate *appDelegate;
    appDelegate = [(BetaAppDelegate *)[UIApplication sharedApplication] delegate];
    self.latitudeLabel.text = appDelegate.global_string;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_latitudeLabel release];
    [super dealloc];
}
@end
