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
#import "Photo.h"
@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionText;
@property NSDictionary *photoInfo;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];

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
        self.photoInfo = info;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Media is a video
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadImage{
    NSData *imageData = UIImageJPEGRepresentation(self.photoInfo[@"UIImagePickerControllerOriginalImage"], 0.5f);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@-image", [PFUser currentUser][@"username"]] data:imageData];

    Photo *photo = [Photo object];
    photo.user = [PFUser currentUser];
    photo.imageFile = imageFile;
    photo.description = self.descriptionText.text;
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    photo.ACL = photoACL;

    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Success upload");
    }];
}

- (IBAction)onShareButtonPressed:(id)sender {
    [self uploadImage];
}

-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}


@end
