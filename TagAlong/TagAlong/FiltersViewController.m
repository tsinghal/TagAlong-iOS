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
- (IBAction)backPressed:(id)sender {
    
    NSUInteger selectedtypeIndex = [_typePicker selectedRowInComponent:0];
    NSUInteger selectedtimeIndex = [_timePicker selectedRowInComponent:0];
    NSUInteger selectedlocationIndex = [_locationPicker selectedRowInComponent:0];
    
    NSString *type = _types[selectedtypeIndex];
    NSString *time = _times[selectedtimeIndex];
    NSString *location = _locations[selectedlocationIndex];
    
    if (self.completionHandler){
        self.completionHandler(type, time, location);
    }
}


@end
