//
//  BetaFirstViewController.m
//  Beacon
//
//  Created by Zuokun Yu on 2/24/14.
//  Copyright (c) 2014 Hunter YY. All rights reserved.
//

#import "BetaFirstViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface BetaFirstViewController ()

@end

@implementation BetaFirstViewController{
    GMSMapView *mapView_;
}

- (void)viewDidLoad
{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.808138
                                                            longitude:-73.963814
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(40.808138, -73.963814);
    marker.title = @"Columbia University";
    marker.snippet = @"";
    marker.map = mapView_;
    
    //[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
