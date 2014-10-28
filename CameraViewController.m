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

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

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
        [self uploadImage:info];

    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Media is a video
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadImage:(NSDictionary *)photoInfo{
    NSLog(@"%@",[PFUser currentUser]);
    NSData *imageData = UIImageJPEGRepresentation(photoInfo[@"UIImagePickerControllerOriginalImage"], 0.5f);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@-image", [PFUser currentUser][@"username"]] data:imageData];

    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFObject *photo = [PFObject objectWithClassName:@"Photo"];
        [photo setObject:imageFile forKey:@"imageFile"];

        photo.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

        PFUser *user = [PFUser currentUser];
        [photo setObject:user forKey:@"user"];

        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Success upload");
            }
            else{
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    } progressBlock:^(int percentDone) {
        NSLog(@"%i", percentDone);
    }];
    
}


@end
