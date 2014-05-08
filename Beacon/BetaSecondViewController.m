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
@property (retain, nonatomic) IBOutlet UILabel *Time;

@end

@implementation BetaSecondViewController

NSString *globalString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    
    BetaAppDelegate *appDelegate;
    appDelegate = [(BetaAppDelegate *)[UIApplication sharedApplication] delegate];
    self.latitudeLabel.text = appDelegate.global_string;
    self.Time.text = dateString;
    
    globalString = appDelegate.global_string;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(rotatewarmup) userInfo:nil repeats:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)rotatewarmup
{
    BOOL same = true;
    BetaAppDelegate *appDelegate;
    appDelegate = [(BetaAppDelegate *)[UIApplication sharedApplication] delegate];
    self.latitudeLabel.text = appDelegate.global_string;
    same = [globalString isEqualToString:appDelegate.global_string];
    if(!same){
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    self.Time.text = dateString;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_latitudeLabel release];
    [_Time release];
    [_Time release];
    [super dealloc];
}
@end
