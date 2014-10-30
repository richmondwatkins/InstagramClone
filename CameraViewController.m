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
#import "Tag.h"
@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionText;
@property NSDictionary *photoInfo;
@property NSMutableArray *tags;
@property UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tester;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *test2;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *test1;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tags = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];

    self.shareButton.hidden = YES;
    self.descriptionText.hidden = YES;

    self.imagePicker = [[UIImagePickerController alloc] init];

    self.imagePicker.delegate = self;

    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
}

-(void)viewDidDisappear:(BOOL)animated{
    self.imageView.image = nil;
    self.descriptionText.text = @"";
}


- (IBAction)onCameraRollButtonTapped:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)onCameraButtonTapped:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


- (void) navigationController: (UINavigationController *) navigationController  willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCamera:)];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(hideCamera:)];

        viewController.navigationItem.leftBarButtonItem = cancelButton;
        viewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:button];
    } else {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStylePlain target:self action:@selector(showLibrary:)];
        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:button];
        viewController.navigationItem.title = @"Take Photo";
        viewController.navigationController.navigationBarHidden = NO; // important
    }
}

-(void)hideCamera:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showCamera: (id) sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
}

- (void) showLibrary: (id) sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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

    self.shareButton.hidden = NO;
    self.descriptionText.hidden = NO;

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

        NSMutableArray *readyTags = [NSMutableArray array];
        for(NSString *tag in self.tags){
            Tag *photoTag = [Tag object];
            photoTag.photo = photo;
            photoTag.tagText = tag;
            [readyTags addObject:photoTag];
        }

        [PFObject saveAllInBackground:readyTags block:^(BOOL succeeded, NSError *error) {
            self.descriptionText.text = @"Success!";
        }];
    }];
}

- (IBAction)onShareButtonPressed:(id)sender {
    [self uploadImage];
}


-(void)textViewDidBeginEditing:(UITextView *)textView{

    self.test1.constant += 150;
    self.test2.constant += 150;

    textView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        self.test1.constant -= 150;
        self.test2.constant -= 150;
        [self.tags removeAllObjects];
        [textView resignFirstResponder];
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
        NSArray *matches = [regex matchesInString:textView.text options:0 range:NSMakeRange(0, textView.text.length)];
        for (NSTextCheckingResult *match in matches) {
            NSRange wordRange = [match rangeAtIndex:1];
            NSString* word = [textView.text substringWithRange:wordRange];
            word = [word lowercaseString];
            [self.tags addObject:word];
        }

        return NO;
    }
    return YES;
}


@end
