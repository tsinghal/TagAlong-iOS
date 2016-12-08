//
//  HomeController.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/7/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     [self dismissViewControllerAnimated:YES completion:nil];
 }

@end
