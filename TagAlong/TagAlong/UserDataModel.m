//
//  UserDataModel.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/11/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "UserDataModel.h"



@implementation UserDataModel

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        // read the database and make users
        
        _users = [[NSMutableArray alloc] init];
        
        self.ref = [[FIRDatabase database] reference];
        _firebaseUsers = [[NSMutableArray alloc] init];
        
        [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            [_firebaseUsers addObject:snapshot];
            
            FIRDataSnapshot *userSnapshot = _firebaseUsers[0];
            NSDictionary<NSString *, NSString *> *database = userSnapshot.value;
            
            for(NSString *key in [database allKeys]) {
            
                NSDictionary<NSString *, NSString *> *tempUser = [database objectForKey:key];
               
                // Get user values
                
                NSString *tempName = [tempUser objectForKey:kName];
                NSString *tempDescription = [tempUser objectForKey:kDescription];
                NSString *tempType = [tempUser objectForKey:kType];
                NSString *tempTime = [tempUser objectForKey:kTime];
                NSString *tempLocation = [tempUser objectForKey:kLocation];
                
                //make user
                User *user = [[User alloc] initWithName:tempName description:tempDescription type:tempType time:tempTime location:tempLocation];
                
                [_users addObject:user];
                [self print:user];
                
            }
            
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
        
     
    }
    NSLog(@"Number1 : %lu", (unsigned long)[self.users count]);
     return self;
}

// Creating the model
+ (instancetype) sharedModel{
    
    static UserDataModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[UserDataModel alloc] init];
    });
    
    
    return _sharedModel;
}

// Accessing number of users in model
- (NSUInteger) numberOfUsers{
    return _users.count;
}

- (void) print: (User*)x{
    NSLog(@"%@", x.name);
}

- (User *)userAtIndex:(NSUInteger)index{
    _currentIndex = index;
    return self.users[index];
    
}

// Inserting a user
- (void) insertWithName: (NSString *) name
            description: (NSString *) des
                   type: (NSString *) ty
                   time: (NSString *) ti
               location: (NSString *) l{
    
    User *add = [[User alloc] initWithName:name description:des type:ty time:ti location:l];
    [self.users addObject:add];
    
}
- (void) insertWithName: (NSString *) name
            description: (NSString *) des
                   type: (NSString *) ty
                   time: (NSString *) ti
               location: (NSString *) l
                atIndex: (NSUInteger) index{
    
    User *add = [[User alloc] initWithName:name description:des type:ty time:ti location:l];
    
    if(index < self.users.count)
        [self.users insertObject:add atIndex:index];
    else if (index == self.users.count)
        [self.users addObject:add];
}



@end
