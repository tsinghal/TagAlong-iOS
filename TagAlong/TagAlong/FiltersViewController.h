//
//  FiltersViewController.h
//  TagAlong
//
//  Created by Tushar Singhal on 12/8/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionHandler)(NSString *type, NSString *time, NSString *location);

@interface FiltersViewController : UIViewController

@property (copy, nonatomic) CompletionHandler completionHandler;

@end
