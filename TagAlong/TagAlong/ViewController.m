//
//  ViewController.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/5/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "ViewController.h"
#import "SignUpController.h"
@import FirebaseAuth;


@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (nonatomic, assign, getter=isWorking) BOOL working;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.usernameField becomeFirstResponder];
    [self setWorking:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginPressed:(id)sender {
    // Sign In with credentials.
    NSString *email = _usernameField.text;
    NSString *password = _passwordField.text;
    
    BOOL check;
    check = [self checkEmail];  //check email is fine
    if(!check)
        return;
    check = [self checkPassword];   //check password not empty
    if(!check)
        return;
    
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (error) {               //failed
                                 
                                 [self showDialog:@"Login Failed"];
                                 [self setWorking:NO];
                                 
                                 return;
                             }else{                     //signed in
                                
                                 [self setWorking:YES];
                                 [self performSegueWithIdentifier:@"main" sender:self];
                             
                             }
                             printf("success");
                         }];
}

- (BOOL)checkEmail{
   if((_usernameField.text.length == 0 )|| ![_usernameField.text hasSuffix:@"@usc.edu"] )
   {
       [self showDialog:@"Please enter a valid USC email address"];
   }
    return true;
}

- (BOOL)checkPassword{
    if(_passwordField.text.length == 0)
    {
        [self showDialog:@"Please enter a password"];
    }
    return true;
}

- (IBAction)resetPressed:(id)sender {
    
    [self checkEmail];
    [[FIRAuth auth] sendPasswordResetWithEmail:_usernameField.text
                                    completion:^(NSError * _Nullable error) {
                                        if (error) {
                                            NSLog(@"%@", error.localizedDescription);
                                            [self showDialog:@"User does not exist"];
                                        }
                                        else{
                                            [self showDialog:@"Password Reset Email Sent"];
                                        }
                                    }];
   
    
}
- (IBAction)signUpPressed:(id)sender {
    [self performSegueWithIdentifier:@"signUp" sender:self];
}

//shows a pop up dialog
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
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"main"]) {
        if([self isWorking] == YES){
            _usernameField.text = @"";
            _passwordField.text = @"";
            [self setWorking:false];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
           
        }
    }else{
        _usernameField.text = @"";
        _passwordField.text = @"";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}*/

@end
