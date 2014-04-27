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
@property (nonatomic) BOOL waitingForInfo; // boolean that says whether you are waiting for information or in between digits
@property (nonatomic) NSString *currentInfo; // variable that says what variable you are currently updating

@end

@implementation BetaFirstViewController{
    GMSMapView *mapView_;
}

BOOL inFrequencyRange(vDSP_Length zeroCrossings, int range){
    return NSLocationInRange(zeroCrossings, NSMakeRange(range - 5, range + 5));
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //__weak UIViewController * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];
    
    
    // Basic playthru example
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
    //        float volume = 0.5;
    //        vDSP_vsmul(data, 1, &volume, data, 1, numFrames*numChannels);
    //        wself.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
    //    }];
    //
    //
    //    [self.audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
    //        wself.ringBuffer->FetchInterleavedData(outData, numFrames, numChannels);
    //    }];
    
    
    // MAKE SOME NOOOOO OIIIISSSEEE
    // ==================================================
    //     [self.audioManager setOutputBlock:^(float *newdata, UInt32 numFrames, UInt32 thisNumChannels)
    //         {
    //             for (int i = 0; i < numFrames * thisNumChannels; i++) {
    //                 newdata[i] = (rand() % 100) / 100.0f / 2;
    //         }
    //     }];
    
    
    // MEASURE SOME DECIBELS!
    // ==================================================
    //    __block float dbVal = 0.0;
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
    //
    //        vDSP_vsq(data, 1, data, 1, numFrames*numChannels);
    //        float meanVal = 0.0;
    //        vDSP_meanv(data, 1, &meanVal, numFrames*numChannels);
    //
    //        float one = 1.0;
    //        vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
    //        dbVal = dbVal + 0.2*(meanVal - dbVal);
    //        printf("Decibel level: %f\n", dbVal);
    //
    //    }];
    
    // SIGNAL GENERATOR!
    //    __block float frequency = 2000.0;
    //    __block float phase = 0.0;
    //    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //
    //         float samplingRate = wself.audioManager.samplingRate;
    //         for (int i=0; i < numFrames; ++i)
    //         {
    //             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
    //             {
    //                 float theta = phase * M_PI * 2;
    //                 data[i*numChannels + iChannel] = sin(theta);
    //             }
    //             phase += 1.0 / (samplingRate / frequency);
    //             if (phase > 1.0) phase = -1;
    //         }
    //     }];
    
    
    // DALEK VOICE!
    // (aka Ring Modulator)
    
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //         wself.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
    //     }];
    //
    //    __block float frequency = 100.0;
    //    __block float phase = 0.0;
    //    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //         wself.ringBuffer->FetchInterleavedData(data, numFrames, numChannels);
    //
    //         float samplingRate = wself.audioManager.samplingRate;
    //         for (int i=0; i < numFrames; ++i)
    //         {
    //             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
    //             {
    //                 float theta = phase * M_PI * 2;
    //                 data[i*numChannels + iChannel] *= sin(theta);
    //             }
    //             phase += 1.0 / (samplingRate / frequency);
    //             if (phase > 1.0) phase = -1;
    //         }
    //     }];
    //
    
    // VOICE-MODULATED OSCILLATOR
    
    //    __block float magnitude = 0.0;
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //         vDSP_rmsqv(data, 1, &magnitude, numFrames*numChannels);
    //     }];
    //
    //    __block float frequency = 100.0;
    //    __block float phase = 0.0;
    //    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //
    //         printf("Magnitude: %f\n", magnitude);
    //         float samplingRate = wself.audioManager.samplingRate;
    //         for (int i=0; i < numFrames; ++i)
    //         {
    //             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
    //             {
    //                 float theta = phase * M_PI * 2;
    //                 data[i*numChannels + iChannel] = magnitude*sin(theta);
    //             }
    //             phase += 1.0 / (samplingRate / (frequency));
    //             if (phase > 1.0) phase = -1;
    //         }
    //     }];
    
    
    // AUDIO FILE READING OHHH YEAHHHH
    // ========================================
//    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"TLC" withExtension:@"mp3"];
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"mix" withExtension:@"mp3"];
    self.fileReader = [[AudioFileReader alloc]
                       initWithAudioFileURL:inputFileURL
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numOutputChannels];
    
    [self.fileReader play];
    self.fileReader.currentTime = 0.0;
    
    
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [self.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         
         vDSP_Length crossing;
         vDSP_Length total;
         const vDSP_Length numCrossings = numFrames;
         
         vDSP_nzcros(data, 1, numCrossings, &crossing, &total, numFrames*numChannels);
         
         if(inFrequencyRange(total, freq_change_digit)) {
             _waitingForInfo = YES;
         } else if (_waitingForInfo) {
             _waitingForInfo = YES;
             if (inFrequencyRange(total, freq_lat)) {
                 _currentInfo = @"lat";
             } else if (inFrequencyRange(total, freq_long)) {
                 _currentInfo = @"long";
             } else {
                 NSString *digit = @(total).stringValue; //get the digit by matching with the frequency
                 if ([_currentInfo isEqualToString:@"lat"]) {
                     [_latitude stringByAppendingString:digit];
                     // if complete, then expect another tone
                 } else if ([_currentInfo isEqualToString:@"long"]) {
                     [_longitude stringByAppendingString:digit];
                     // if complete, then expect another tone
                 }
             }
         }
         
         printf("Total: %lu\n", total);
           
     }];
    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {

        
    }];
    
    // AUDIO FILE WRITING YEAH!
    // ========================================
    //    NSArray *pathComponents = [NSArray arrayWithObjects:
    //                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
    //                               @"My Recording.m4a",
    //                               nil];
    //    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    //    NSLog(@"URL: %@", outputFileURL);
    //
    //    self.fileWriter = [[AudioFileWriter alloc]
    //                       initWithAudioFileURL:outputFileURL
    //                       samplingRate:self.audioManager.samplingRate
    //                       numChannels:self.audioManager.numInputChannels];
    //
    //
    //    __block int counter = 0;
    //    self.audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels) {
    //        [wself.fileWriter writeNewAudio:data numFrames:numFrames numChannels:numChannels];
    //        counter += 1;
    //        if (counter > 400) { // roughly 5 seconds of audio
    //            wself.audioManager.inputBlock = nil;
    //        }
    //    };
    
    // START IT UP YO
    [self.audioManager play];
    
}

@end
