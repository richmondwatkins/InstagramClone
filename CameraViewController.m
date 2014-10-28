//
//  CameraViewController.m
//  InstagramClone
//
//  Created by Richmond on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreSer>
@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];

    imagePicker.delegate = self;

    imagePicker.sourceType =
    UIImagePickerControllerSourceTypeCamera;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    CameraOverlay *overlay = [[CameraOverlay alloc]
                              initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth)];

    imagePicker.showsCameraControls = NO;
    imagePicker.toolbarHidden = YES;
    imagePicker.cameraOverlayView = overlay;

    //    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
    //    imagePicker.cameraViewTransform = translate;

    //    CGAffineTransform scale = CGAffineTransformScale(translate, 1, 1);
    //    imagePicker.cameraViewTransform = scale;

    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSString *mediaType = info[UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        NSLog(@"%@",[PFUser currentUser]);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Media is a video
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
