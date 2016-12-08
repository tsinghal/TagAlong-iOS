//
//  HomeController.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/7/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "HomeController.h"
@import FirebaseAuth;

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)signOut {
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *name = user.displayName;
    if (user) {
        NSLog(@"Your name is %@", name);
    }
    
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     [self signOut];
     [self dismissViewControllerAnimated:YES completion:nil];
 }

@end
