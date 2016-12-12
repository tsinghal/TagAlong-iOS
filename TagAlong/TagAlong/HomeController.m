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
@import FirebaseStorage;
@import Firebase;

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
@property (strong, nonatomic) FIRStorageReference *storageRef;
@end

@implementation HomeController

- (void)viewDidLoad {

    //register table cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CustomTableViewCell class])];
    
    //get reference to firebase database
    self.ref = [[FIRDatabase database] reference];
    
    [self setSeg:NO];
    
    _count = 5;
    _postCount = 0;
    
    
    //READ FROM FIREBASE THROUGH SHARED USER DATA MODEL
    self.userData = [UserDataModel sharedModel];
    
    //firebase storage
    [self configureStorage];
    
    [super viewDidLoad];
    
    
}

//storage for image download from firebase
- (void)configureStorage {
    NSString *storageUrl = [FIRApp defaultApp].options.storageBucket;
    self.storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"gs://%@", storageUrl]];
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
    
    //restructure data and look of cell
    
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
            
            //downloading image from Firebase
                
            FIRStorageReference *imageRef = [self.storageRef child:key];
            [imageRef dataWithMaxSize:2.8 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        [self showDialog:@"Image size was too big"];
                    
                    } else {
                    
                        // image returned and resized
                       UIImage *tempImage =[UIImage imageWithData:data];
                        CGSize size=CGSizeMake(80, 80);
                        UIImage *temp = [self imageWithImage:tempImage scaledToSize:size];
                        [cell.imageView setImage:temp];
                        cell.imageView.image =  temp;
                        
                    }
                }];
            }
             flag++;
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

//credits: stackoverflow for image scaling
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// to give more information about clicked cell
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
                NSString *tempType = [tempUser objectForKey:kType];
                NSString *tempTime = [tempUser objectForKey:kTime];
                NSString *tempLocation = [tempUser objectForKey:kLocation];
                
                NSString *complete = [NSString stringWithFormat:@"%@'s %@", tempName,
                                      @"Preferences"];
                NSString *msg = [NSString stringWithFormat:@"Type: %@\r\n Time: %@\r\n Location: %@",tempType, tempTime, tempLocation];
                
                //alert box for more info
                UIAlertController *prompt =
                [UIAlertController alertControllerWithTitle: complete
                                                    message: msg
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * _Nonnull action) {
                                               [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                               
                                           }];
                [prompt addAction:okAction];
                [self presentViewController:prompt animated:YES completion:nil];
            }
            flag++;
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];

}
//popup dialogs
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

- (IBAction)postPressed:(id)sender {
    _postCount++;               //number of times post button is pressed
    
    if([self seg] == NO){       //if filters haven't been chosen yet

        [self showDialog:@"Please select filters"];
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
        //NSLog(@"Signed Out");
    }
    
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    else{
        NSLog(@"Signed Out");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     
     if ([segue.identifier isEqualToString:@"logout"]) {
       [self signOut];
         
     }else if ([segue.identifier isEqualToString:@"filter"]){
         
         [self setSeg:YES];
         
         FiltersViewController *fc = (FiltersViewController *)segue.destinationViewController;
         
         fc.completionHandler = ^(NSString *type, NSString *time, NSString *location){
             
             
             if (type != nil && time != nil && location != nil){
                 
                 _usertime = time;
                 _usertype = type;
                 _userlocation = location;
             }
             
             [self dismissViewControllerAnimated:YES completion:nil];
         };
        
     }
 }

@end
