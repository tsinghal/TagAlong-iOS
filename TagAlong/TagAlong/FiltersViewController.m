//
//  FiltersViewController.m
//  TagAlong
//
//  Created by Tushar Singhal on 12/8/16.
//  Copyright © 2016 Tushar Singhal. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;

@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSArray *times;
@property (strong, nonatomic) NSArray *locations;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _types = @[@"Workout", @"Jogging",@"Ping Pong", @"Football", @"Tennis"];
    _times = @[@"Workout", @"Jogging",@"Ping Pong", @"Football", @"Badminton"];
    _locations = @[@"Lyon Center", @"Track Field",@"Lorenzo Gym", @"Gateway Gym", @"Marks Stadium"];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(pickerView == _typePicker){
        return _types.count;
    }
    else if(pickerView == _timePicker){
        return _times.count;
    }
    else if(pickerView == _locationPicker)
        return _locations.count;
    return 0;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
   

    if(pickerView == _typePicker){
        NSString *string = _types[row];
        NSAttributedString *attString =
        [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

        return attString;
    }
    else if(pickerView == _timePicker){
        NSString *string = _times[row];
        NSAttributedString *attString =
        [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        return attString;
    }
    else if(pickerView == _locationPicker){
        NSString *string = _locations[row];
        NSAttributedString *attString =
        [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        return attString;
    }
    
    return nil;
    
}

/*
- (IBAction)savePressed:(id)sender {
    NSUInteger selectedFirstNameIndex = [_typePicker selectedRowInComponent:0];
    NSUInteger selectedLastNameIndex = [_timePicker selectedRowInComponent:0];
    
    NSString *firstName = _types[selectedFirstNameIndex];
    NSString *lastName = _times[selectedLastNameIndex];
    
    NSLog(@"%@ %@", firstName, lastName);
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
