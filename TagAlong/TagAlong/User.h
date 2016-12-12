//
//  User.h
//  TagAlong
//
//  Created by Tushar Singhal on 12/11/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString * const kName = @"name";
static NSString * const kDescription = @"description";
static NSString * const kType = @"type";
static NSString * const kTime = @"time";
static NSString * const kLocation = @"location";
static NSString const * kUsers = @"users";

@interface User : NSObject

@property (strong, readonly) NSString *name;
@property (strong, readonly) NSString *descript;
@property (strong, readonly) NSString *type;
@property (strong, readonly) NSString *time;
@property (strong, readonly) NSString *location;

- (instancetype) initWithName: (NSString *) name description: (NSString *) des type: (NSString *) ty time: (NSString *) ti location:(NSString *) l;

// public properties
// public methods
- (instancetype) initWithDictionary: (NSDictionary *) user;
- (NSDictionary *) dictionary;
@end
