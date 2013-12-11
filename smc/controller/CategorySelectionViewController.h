//
//  CategorySelectionViewController.h
//  smc
//
//  Created by Kent C. Dodds on 12/11/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface CategorySelectionViewController : UIViewController

@property (strong, nonatomic) MainViewController *delegate;
@property (weak, nonatomic) NSArray *categories;

@end
