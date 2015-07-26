//
//  FirstViewController.h
//  MediFlir3D
//
//  Created by Phaninder Pasupula on 25/07/2015.
//  Copyright (c) 2015 Phaninder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLIROneSDK/FLIROneSDK.h>
#import <FLIROneSDK/FLIROneSDKSimulation.h>

@interface FirstViewController : UIViewController <FLIROneSDKImageReceiverDelegate,FLIROneSDKStreamManagerDelegate>

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)viewLibrary:  (UIButton *)sender;

@end

