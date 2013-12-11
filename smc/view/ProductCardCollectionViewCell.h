//
//  ProductCardCollectionViewCell.h
//  smc
//
//  Created by Kent C. Dodds on 12/10/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCardView.h"

@interface ProductCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet ProductCardView *productCardView;

- (void) setupCellWithProduct: (NSDictionary *) product;
- (void) setLabelText: (NSString *) s;

@end
