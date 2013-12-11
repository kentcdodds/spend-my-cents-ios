//
//  ProductCardView.m
//  smc
//
//  Created by Kent C. Dodds on 12/10/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import "ProductCardView.h"

#define CORNER_RADIUS                   (self.bounds.size.width * 0.0667)

@interface ProductCardView()

@end

@implementation ProductCardView

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
}

@end