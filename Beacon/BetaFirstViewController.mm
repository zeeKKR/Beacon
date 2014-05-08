//
//  BetaFirstViewController.m
//  Beacon
//
//  Created by Zuokun Yu on 2/24/14.
//  Copyright (c) 2014 Hunter YY. All rights reserved.
//

#import "BetaFirstViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FrequencyConstants.h"

@interface BetaFirstViewController ()

@property (nonatomic, assign) RingBuffer *ringBuffer;
@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *latitude;
@property (nonatomic) BOOL dropPin;
@property (retain, nonatomic) NSTimer *timer;


@end

@implementation BetaFirstViewController{
    GMSMapView *mapView_;
}

// Says whether a given number of zero crossings is within a certain range
BOOL inFrequencyRange(vDSP_Length zeroCrossings, int range){
    zeroCrossings = NSUInteger(zeroCrossings);
    return zeroCrossings > range - 2 && zeroCrossings < range + 2;
}

int nCrossings(NSArray *data){
    float average = 0.0;
    int total = 0;
    
    for(int n = 1; n < [data count]; n++) {
        average += [[data objectAtIndex:n] floatValue];
    }
    average = average / [data count];
    
    for(int n = 1; n < [data count] - 1; n++) {
        float val1 = [[data objectAtIndex:n] floatValue];
        float val2 = [[data objectAtIndex:n+1] floatValue];
        if ((val1 < average && val2 > average) || (val1 > average && val2 < average)) {
            total++;
        }
    }
    return total;
}

int binaryToDecimal(NSString* num){
    int len = [num length];
    int sum = 0;
    int pow = 0;
    
    for(int i = len - 1; i >= 0; i--){
        NSString *singleCharSubstring = [num substringWithRange:NSMakeRange(i, 1)];
        NSInteger result = [singleCharSubstring integerValue];
        sum += result * 2^pow;
        pow++;
    }
    
    return sum;
}

- (void)viewDidLoad
{
    BetaAppDelegate *appDelegate;
    appDelegate = [(BetaAppDelegate *)[UIApplication sharedApplication] delegate];
    appDelegate.global_string = @"foo";
    
    //[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.808138
                                                            longitude:-73.963814
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    
    
    //__weak BetaFirstViewController * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];
    
    
    
    // MEASURE SOME DECIBELS!
    // ==================================================
   __block float dbVal = 0.0;
//   [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {

//       vDSP_vsq(data, 1, data, 1, numFrames*numChannels);
//       float meanVal = 0.0;
//       vDSP_meanv(data, 1, &meanVal, numFrames*numChannels);
//       
//       float one = 1.0;
//       vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
//       dbVal = dbVal + 0.2*(meanVal - dbVal);
//       printf("Decibel level: %f\n", dbVal);
    
//       vDSP_Length crossing;
//       vDSP_Length total;
//       const vDSP_Length numCrossings = numFrames;
//       
//       vDSP_nzcros(data, 1, numCrossings, &crossing, &total, numFrames*numChannels);
    
//       NSLog(@"total %lu", total);
//       
//       for(int i = 0; i < 1024; i++){
//           NSLog(@"%i:%f",i ,data[i]);
//       }
       
//       NSArray *tmp = [NSArray array];
//       for(int i = 0; i < 1024; i++){
//           tmp = [tmp arrayByAddingObject:[NSNumber numberWithFloat: data[i]]];
//       }
//       NSLog(@"%d", nCrossings(tmp));
//       appDelegate.global_string = [NSString stringWithFormat:@"%f", dbVal];

//   }];
    
    
    
    // AUDIO FILE READING OHHH YEAHHHH
    // ========================================
//    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"TLC" withExtension:@"mp3"];
//    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"samplefile" withExtension:@"wav"];
//    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"2000" withExtension:@"wav"];
//    [NSThread sleepForTimeInterval:(5)];
//    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"Columbia1" withExtension:@"wav"];
//    BOOL flag = 0;
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"Columbia2" withExtension:@"wav"];
    BOOL flag = 1;
    self.fileReader = [[AudioFileReader alloc]
                       initWithAudioFileURL:inputFileURL
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numOutputChannels];
    
    [self.fileReader play];
    self.fileReader.currentTime = 0.0;
    
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [self.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
     }];
    
    
    // START IT UP YO
    [self.audioManager play];

}

- (void) viewDidAppear:(BOOL)animated{
    _latitude = @"40.8091";
    _longitude = @"-73.9638";
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rotatewarmup) userInfo:nil repeats:YES];
}

-(void)rotatewarmup{
    //_latitude = @"40.809318";
    //_longitude = @"-73.959274";
    
    double lat = [_latitude doubleValue];
    double lng = [_longitude doubleValue];
    
    NSString *latLong = [NSString stringWithFormat:@"Lat: %f Long %f", lat, lng];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = latLong;
    marker.map = mapView_;
    
    NSLog(@"%f", lat);
    
    BetaAppDelegate *appDelegate;
    appDelegate = [(BetaAppDelegate *)[UIApplication sharedApplication] delegate];
    appDelegate.global_string = [NSString stringWithFormat:@"Latitude: %f, Longitude: %f", lat, lng];

}

@end
