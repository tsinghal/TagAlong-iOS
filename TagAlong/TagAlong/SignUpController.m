//
//  SignUpController.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/7/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "SignUpController.h"
#import "ViewController.h"
@import FirebaseAuth;
@import FirebaseStorage;
@import Firebase;

@interface SignUpController () <UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign, getter=isWorking) BOOL working;
@property (strong, nonatomic) FIRStorageReference *storageRef;

@property (strong, nonatomic) UIImage *originalImage;

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _working = NO;
    [self configureStorage];
}

//configure firebase storage for images
- (void)configureStorage {
    NSString *storageUrl = [FIRApp defaultApp].options.storageBucket;
    self.storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"gs://%@", storageUrl]];
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)createPressed:(id)sender {
    
    
    BOOL check;
    check = [self checkName];       //check name
    if(!check)
        return;
    check = [self checkEmail];      // check user email
    if(!check)
        return;
    check = [self checkPassword];      //check password not empty
    if(!check)
        return;
    
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                         if (error) {
                                            [self showDialog:@"The email address is already in use. Please choose a different email"];
                                            return;
                                         }else{
                                             [self setDisplayName:user];
                                             [self saveImage:user];
                                             [self performSegueWithIdentifier:@"login" sender:self];
                                         }
                                 
    }];
    [self setWorking:YES];
   
}

- (BOOL)checkName{
    if(_nameField.text.length == 0){
        [self showDialog:@"Please enter a name"];
        return false;
    }
    return true;
}

- (BOOL)checkEmail{
    if((_emailField.text.length == 0 )|| ![_emailField.text hasSuffix:@"@usc.edu"] )
    {
        [self showDialog:@"Please enter a valid USC email address"];
        return false;
    }
    return true;
}

- (BOOL)checkPassword{
    if(_passwordField.text.length == 0)
    {
        [self showDialog:@"Please enter a password"];
        return false;
    }
    else if(_passwordField.text.length < 6 ){
        [self showDialog:@"Password must be atleast 6 characters in length"];
        return false;
    }
    return true;
}

- (void)showDialog:(NSString *)show {
    UIAlertController *prompt =
    [UIAlertController alertControllerWithTitle:nil
                                        message:show
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   
                               }];
    [prompt addAction:okAction];
    [self presentViewController:prompt animated:YES completion:nil];
}

//set display name of the user created
- (void)setDisplayName:(FIRUser *)user {
    FIRUserProfileChangeRequest *changeRequest =
    [user profileChangeRequest];

    changeRequest.displayName = _nameField.text;
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
    }];
}

- (IBAction)cancelPressed:(id)sender {
    [self performSegueWithIdentifier:@"login" sender:self];
}

#pragma mark - IBActions

- (IBAction)selectPressed:(id)sender {
    
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    
    self.imageView.image = self.originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil]; //dismiss picker
}
//upload the user's image
- (void) saveImage:(FIRUser *)user{
    
    if(self.originalImage != NULL){
        
        NSData *imageData = UIImageJPEGRepresentation(self.originalImage, 0.8);
        
        // Create a reference to the file that has to be uploaded, save it by user's id name
        FIRStorageReference *imageRef = [_storageRef child:user.uid];
        
        // Create file metadata including the content type
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        
        // Upload data and metadata
        FIRStorageUploadTask *uploadTask = [imageRef putData:imageData metadata:metadata];
        
    }else{
        UIImage *temp = [UIImage imageNamed:@"person"];
        NSData *imageData = UIImageJPEGRepresentation(temp, 0.8);
        
        // Create a reference to the file that has to be uploaded, save it by user's id name
        FIRStorageReference *imageRef = [_storageRef child:user.uid];
        
        // Create file metadata including the content type
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        
        // Upload data and metadata
        FIRStorageUploadTask *uploadTask = [imageRef putData:imageData metadata:metadata];
        
    }
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *)
picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



@end
