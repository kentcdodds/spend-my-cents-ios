//
//  ProductCardCollectionViewCell.m
//  smc
//
//  Created by Kent C. Dodds on 12/10/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import "ProductCardCollectionViewCell.h"

@interface ProductCardCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ProductCardCollectionViewCell


- (void) setupCellWithProduct:(NSDictionary *)product {
    //[self.productCardView setupWithProduct:product];
    
    //NSString *contents = [self.productCardView getCardContents];
//    self.label.text = contents;
    self.label.text = @"Hi!";
}


@end
