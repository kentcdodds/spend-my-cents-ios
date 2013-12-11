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
@property (nonatomic) dispatch_queue_t downloadQueue;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation ProductCardView

#pragma mark - Properties

- (dispatch_queue_t)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = dispatch_queue_create("image downloader", NULL);
    }
    
    return _downloadQueue;
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void) setupWithProduct: (NSDictionary *)product {
    if ([product isKindOfClass:[NSDictionary class]]) {
        self.asin = product[@"ASIN"];
        self.title = product[@"title"];
        self.manufacturer = product[@"manufacturer"];
        self.url = product[@"url"];
        self.imageUrl = product[@"imageUrl"];
    } else {
        // hi
    }
}

- (NSString *) getCardContents {
    if (self.asin) {
        return [NSString stringWithFormat:@"%@\n\nMade by: %@\n\nASIN: %@", self.title, self.manufacturer, self.asin];
    } else {
        return @"No info available!\nSorry!";
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    self.faceUp = true;
    
    if (self.isFaceUp) {
        self.label.text = [self getCardContents];
    } else {/*
        dispatch_async(self.downloadQueue, ^{
            NSString *randomUrl = [self randomImageUrl];
            
            if (!self.imageCache[randomUrl]) {
                // If the image for the given URL isn't already cached, get it now
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:randomUrl]];
                self.imageCache[randomUrl] = [UIImage imageWithData:imageData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = self.imageCache[randomUrl];
            });
        });*/
    }
    
    // And here you could choose a different border color if the card is selected
//    [[UIColor blackColor] setStroke];
  //  [roundedRect stroke];
}

@end