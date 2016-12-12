//
//  User.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/11/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initWithName: (NSString *) name description: (NSString *) des type: (NSString *) ty time: (NSString *) ti location:(NSString *) l{
    
    self = [super init];
    
    if(self){
        _name = name;
        _descript = des;
        _type = ty;
        _time = ti;
        _location = l;
    }
    return self;
}


- (instancetype) initWithDictionary: (NSDictionary *) card {
    self = [super init];
    
    if (self) {
        
        
        _name = [card valueForKey: kName];
        _descript = [card valueForKey: kDescription];
        _type = [card valueForKey: kType];
        _time = [card valueForKey: kTime];
        _location = [card valueForKey: kLocation];
    }
    return self;
}

- (NSDictionary *) dictionary {
    
    NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.name, kName,
                          self.descript, kDescription,
                          self.type, kType,
                          self.time, kTime,
                          self.location, kLocation, nil];
    return user;
}


@end
