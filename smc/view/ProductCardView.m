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

@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *manufacturer;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *asin;

@end

@implementation ProductCardView

#pragma mark - Properties

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void) setupWithProduct: (NSDictionary *)product {
    self.asin = product[@"ASIN"];
    self.title = product[@"title"];
    self.manufacturer = product[@"manufacturer"];
    self.url = product[@"url"];
    self.imageUrl = product[@"imageUrl"];
}

- (NSString *) getCardContents {
    return [NSString stringWithFormat:@"card contents"];
}

#pragma mark - Drawing
/*
- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    UIRectFill(self.bounds);
    
    if (self.isFaceUp) {
    } else {
        //[[UIImage imageNamed:self.cardbackImagename] drawInRect:self.bounds];
    }
    
    // And here you could choose a different border color if the card is selected
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}
*/
@end