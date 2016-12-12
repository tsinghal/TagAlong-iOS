//
//  UserDataModel.h
//  TagAlong
//
//  Created by Tushar Singhal on 12/11/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@import FirebaseDatabase;

@interface UserDataModel : NSObject


@property (readonly, nonatomic) NSUInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *users;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *firebaseUsers;

// Creating the model
+ (instancetype) sharedModel;

// Accessing number of users in model
- (NSUInteger) numberOfUsers;

// Accessing a user – sets currentIndex appropriately
- (User *) userAtIndex: (NSUInteger)index;

// Inserting a user
- (void) insertWithName: (NSString *) name
                     description: (NSString *) des
                   type: (NSString *) ty
                 time: (NSString *) ti
               location: (NSString *) l;
- (void) insertWithName: (NSString *) name
            description: (NSString *) des
                   type: (NSString *) ty
                   time: (NSString *) ti
               location: (NSString *) l
                    atIndex: (NSUInteger) index;

@end
