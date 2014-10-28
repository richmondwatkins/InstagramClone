//
//  CameraViewController.m
//  InstagramClone
//
//  Created by Richmond on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "CameraViewController.h"
#import <Parse/Parse.h>
@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];

    imagePicker.delegate = self;

    imagePicker.sourceType =
    UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSString *mediaType = info[UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.imageView.image = info[@"UIImagePickerControllerOriginalImage"];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Media is a video
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
