//
//  ViewController.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/5/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "ViewController.h"
@import FirebaseAuth;


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
    // Sign In with credentials.
    NSString *email = _usernameField.text;
    NSString *password = _passwordField.text;
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (error) {
                                 NSLog(@"%@", error.localizedDescription);
                                 return;
                             }
                             //[self signedIn:user];
                             printf("success");
                         }];
}
- (IBAction)signUpPressed:(id)sender {
}
- (IBAction)resetPressed:(id)sender {
}

@end
