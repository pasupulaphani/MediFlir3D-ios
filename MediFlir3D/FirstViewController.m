//
//  FirstViewController.m
//  MediFlir3D
//
//  Created by Phaninder Pasupula on 25/07/2015.
//  Copyright (c) 2015 Phaninder. All rights reserved.
//

#import "FirstViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface FirstViewController () <DBRestClientDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thermalImageView;
@property (strong, nonatomic) UIImage *thermalImage;

@property (nonatomic, strong) DBRestClient *restClient;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
    [[FLIROneSDKSimulation sharedInstance] connectWithFrameBundleName:@"sampleframes_hq" withBatteryChargePercentage:@42];
    [[FLIROneSDKStreamManager sharedInstance] setImageOptions:
        FLIROneSDKImageOptionsBlendedMSXRGBA8888Image];
    


    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;

}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager
            didReceiveBlendedMSXRGBA8888Image:(NSData *)msxImage
            imageSize:(CGSize)size {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.thermalImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image
                                                       andData:msxImage andSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.thermalImageView setImage:self.thermalImage];
        });
    });
    
}

- (IBAction)viewLibrary:(id)sender {
    [FLIROneSDKLibraryViewController presentLibraryFromViewController:self];
}

- (IBAction)takePhoto:(UIButton *)sender {

    NSLog(@"takePhoto");
    
    NSURL *filepath = [[FLIROneSDKLibraryManager sharedInstance] libraryFilepathForCurrentTimestampWithExtension:@"png"];
    
    NSLog(@"filePath %@", [filepath path]);
    
    [[FLIROneSDKStreamManager sharedInstance] capturePhotoWithFilepath:filepath];


}

-(void) FLIROneSDKDidFinishCapturingPhoto:(FLIROneSDKCaptureStatus)captureStatus withFilepath:(NSURL *)filepath {
    
    
    // dropbox upload
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    NSString *filename = @"working.png";
    
    NSLog(@"uploadPhoto");
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:[filepath path]];
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
