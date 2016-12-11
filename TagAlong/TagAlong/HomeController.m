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

@interface HomeController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    //register table cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CustomTableViewCell class])];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [self.model numberOfFlashcards];
    //return number of users;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Create a cell

    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomTableViewCell class]) forIndexPath:indexPath];
    
    
    //Flashcard *card = [self.model flashcardAtIndex:indexPath.row];
    //user here
    
    //Modify a cell
    
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
