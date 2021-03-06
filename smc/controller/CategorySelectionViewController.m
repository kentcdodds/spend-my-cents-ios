//
//  CategorySelectionViewController.m
//  smc
//
//  Created by Kent C. Dodds on 12/11/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import "CategorySelectionViewController.h"

@interface CategorySelectionViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *categorySelection;
@property (weak, nonatomic) NSArray *categories;
@property (nonatomic) int selectedCategoryIndex;
@end

@implementation CategorySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.categorySelection selectRow:[self.delegate getCategoryIndex] inComponent:0 animated:NO];
}

- (IBAction)doneTapped:(id)sender {
    [self.delegate setCategoryIndex: self.selectedCategoryIndex];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCategoryIndex = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self.delegate getCategories] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.delegate getCategories][row];
}
@end
