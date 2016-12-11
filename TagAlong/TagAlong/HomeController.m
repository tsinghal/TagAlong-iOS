//
//  HomeController.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/7/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "HomeController.h"
#import "FiltersViewController.h"
#import "CustomTableViewCell.h"
@import FirebaseAuth;
@import FirebaseDatabase;

@interface HomeController () <UITableViewDelegate, UITableViewDataSource> {
    FIRDatabaseHandle _refHandle;
}



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *users;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    //register table cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CustomTableViewCell class])];
 
    _users = [[NSMutableArray alloc] init];
    
    [self configureDatabase];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [self.model numberOfFlashcards];
    //return number of users;
    return 10;
}

- (void)dealloc {
    [[_ref child:@"users"] removeObserverWithHandle:_refHandle];
}


- (void)configureDatabase {
    self.ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    _refHandle = [[_ref child:@"users"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_users addObject:snapshot];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_users.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Dequeue cell
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomTableViewCell class]) forIndexPath:indexPath];
    
    
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *messageSnapshot = _users[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[@"name"];
    NSString *text = message[@"description"];
    cell.cellName.text = [NSString stringWithFormat:@"%@", name];
    cell.cellDescription.text = [NSString stringWithFormat:@"%@",text];
    //cell.cellImage.image = [UIImage imageNamed: @"ic_account_circle"];
    /*NSString *photoURL = message[MessageFieldsphotoURL];
    if (photoURL) {
        NSURL *URL = [NSURL URLWithString:photoURL];
        if (URL) {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            if (data) {
                cell.imageView.image = [UIImage imageWithData:data];
            }
        }
    }*/
    
    return cell;
}


- (IBAction)postPressed:(id)sender {
    UIAlertController *prompt =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"Give a brief description of yours"
                                 preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakPrompt = prompt;
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   UIAlertController *strongPrompt = weakPrompt;
                                   NSString *userInput = strongPrompt.textFields[0].text;
                                   if (!userInput.length)
                                   {
                                       return;
                                   }
                                   
                               }];
    [prompt addTextFieldWithConfigurationHandler:nil];
    [prompt addAction:okAction];
    [self presentViewController:prompt animated:YES completion:nil];

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
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     
     if ([segue.identifier isEqualToString:@"logout"]) {
       [self signOut];
     }else if ([segue.identifier isEqualToString:@"filter"]){
        
     }else if ([segue.identifier isEqualToString:@"notification"]){
         
     }
 }

@end
