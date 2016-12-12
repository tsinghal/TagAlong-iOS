//
//  CustomTableViewCell.h
//  TagAlong
//
//  Created by Tushar Singhal on 12/10/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellDescription;
@end
