//
//  SecondViewController.m
//  MediFlir3D
//
//  Created by Phaninder Pasupula on 25/07/2015.
//  Copyright (c) 2015 Phaninder. All rights reserved.
//

#import "SecondViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface SecondViewController () <DBRestClientDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thermalImageView2_1;
@property (strong, nonatomic) UIImage *thermalImage2_1;

@property (weak, nonatomic) IBOutlet UIImageView *thermalImageView2_2;
@property (strong, nonatomic) UIImage *thermalImage2_2;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
    [[FLIROneSDKSimulation sharedInstance] connectWithFrameBundleName:@"sampleframes_hq" withBatteryChargePercentage:@42];
    [[FLIROneSDKStreamManager sharedInstance] setImageOptions:
     FLIROneSDKImageOptionsBlendedMSXRGBA8888Image];
    
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager
didReceiveBlendedMSXRGBA8888Image:(NSData *)msxImage
                        imageSize:(CGSize)size {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.thermalImage2_1 = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image
                                                        andData:msxImage andSize:size];
        self.thermalImage2_2 = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image
                                                        andData:msxImage andSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.thermalImageView2_1 setImage:self.thermalImage2_1];
            [self.thermalImageView2_2 setImage:self.thermalImage2_2];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
