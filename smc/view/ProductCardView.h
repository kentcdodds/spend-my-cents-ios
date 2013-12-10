//
//  ProductCardView.h
//  smc
//
//  Created by Kent C. Dodds on 12/10/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCardView : UIView

@property (nonatomic, getter = isFaceUp) BOOL faceUp;

- (void) setupWithProduct: (NSDictionary *)product;
- (NSString *) getCardContents;

@end
