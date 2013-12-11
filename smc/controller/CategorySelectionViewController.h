//
//  CategorySelectionViewController.h
//  smc
//
//  Created by Kent C. Dodds on 12/11/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@protocol SetCategoryDelegate;

@interface CategorySelectionViewController : UIViewController

@property (strong, nonatomic) id <SetCategoryDelegate> delegate;
@property (weak, nonatomic) NSArray *categories;
@property (nonatomic) int selectedCategoryIndex;

@end

@protocol SetCategoryDelegate <NSObject>

- (void)setCategoryIndex:(int)index;

@end