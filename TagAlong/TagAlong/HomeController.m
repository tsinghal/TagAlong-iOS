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
#import "UserDataModel.h"
@import FirebaseAuth;
@import FirebaseDatabase;

@interface HomeController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (nonatomic, assign) BOOL seg;
@property(nonatomic,copy) NSString *usertime;
@property(nonatomic,copy) NSString *usertype;
@property(nonatomic,copy) NSString *userlocation;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger postCount;

@property (nonatomic, strong) UserDataModel *userData;
@end

@implementation HomeController

- (void)viewDidLoad {

    //register table cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CustomTableViewCell class])];
    
    self.ref = [[FIRDatabase database] reference];
    [self setSeg:NO];
    
    
    //FIRDatabaseReference *childRef = [[FIRDatabase database] referenceWithPath:@"users"];
    
    //read from firebase through model
    self.userData = [UserDataModel sharedModel];
    _count = 5;
    _postCount = 0;
    [super viewDidLoad];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return number of users;

    return _count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Dequeue cell
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomTableViewCell class]) forIndexPath:indexPath];
    
    
    /* Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *messageSnapshot = _users[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    NSString *name = message[@"name"];
    NSString *text = message[@"description"];
    cell.cellName.text = [NSString stringWithFormat:@"%@", name];
    cell.cellDescription.text = [NSString stringWithFormat:@"%@",text];
    //cell.cellImage.image = [UIImage imageNamed: @"ic_account_circle"];
    NSString *photoURL = message[MessageFieldsphotoURL];
    if (photoURL) {
        NSURL *URL = [NSURL URLWithString:photoURL];
        if (URL) {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            if (data) {
                cell.imageView.image = [UIImage imageWithData:data];
            }
        }
    }*/
    
    NSMutableArray *firebaseUsers = [[NSMutableArray alloc] init];
    
    [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        
        [firebaseUsers addObject:snapshot];
        
        FIRDataSnapshot *userSnapshot = firebaseUsers[0];
        NSDictionary<NSString *, NSString *> *database = userSnapshot.value;
        
        int flag = 0;
        
        for(NSString *key in [database allKeys]) {
            
            if(flag == indexPath.row){
            NSDictionary<NSString *, NSString *> *tempUser = [database objectForKey:key];
            
            // Get user values
            
            NSString *tempName = [tempUser objectForKey:kName];
            NSString *tempDescription = [tempUser objectForKey:kDescription];
            cell.cellName.text = tempName;
            cell.cellDescription.text = tempDescription;
            
            //NSString *tempType = [tempUser objectForKey:kType];
            //NSString *tempTime = [tempUser objectForKey:kTime];
            //NSString *tempLocation = [tempUser objectForKey:kLocation];
            
            }
             flag++;
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    return cell;
}



- (IBAction)postPressed:(id)sender {
    _postCount++;               //number of times post button is pressed
    
    if([self seg] == NO){
        UIAlertController *prompt =
        [UIAlertController alertControllerWithTitle:nil
                                            message:@"Please select filters"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       
                                   }];
        [prompt addAction:okAction];
        [self presentViewController:prompt animated:YES completion:nil];
        return;
    }
    
    //current user
    FIRUser *user = [FIRAuth auth].currentUser;
    
   
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
                                   [[[[_ref child:@"users"] child:user.uid] child:@"description"] setValue:userInput];
                                   
                               }];
    [prompt addTextFieldWithConfigurationHandler:nil];
    [prompt addAction:okAction];
    [self presentViewController:prompt animated:YES completion:nil];

    //save info in database
    [[[[_ref child:@"users"] child:user.uid] child:@"name"] setValue:user.displayName];
    [[[[_ref child:@"users"] child:user.uid] child:@"type"] setValue:_usertype];
    [[[[_ref child:@"users"] child:user.uid] child:@"time"] setValue:_usertime];
    [[[[_ref child:@"users"] child:user.uid] child:@"location"] setValue:_userlocation];
    _count++;
    if(_postCount > 2)
        _count--;
    [self.tableView reloadData];
    
}

//signs out user from firebase
- (void)signOut {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
        NSLog(@"Signed Out");
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
     
     
     if ([segue.identifier isEqualToString:@"logout"]) {
       [self signOut];
     }else if ([segue.identifier isEqualToString:@"filter"]){
         
         [self setSeg:YES];
         [self.postButton setEnabled:true];
         FiltersViewController *fc = (FiltersViewController *)segue.destinationViewController;
         
         fc.completionHandler = ^(NSString *type, NSString *time, NSString *location){
             
             
             if (type != nil && time != nil && location != nil){
                 
                 _usertime = time;
                 _usertype = type;
                 _userlocation = location;
             }
             
             [self dismissViewControllerAnimated:YES completion:nil];
         };
        
     }else if ([segue.identifier isEqualToString:@"notification"]){
         
     }
 }

@end
