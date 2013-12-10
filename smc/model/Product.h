//
//  Product.h
//  smc
//
//  Created by Kent C. Dodds on 12/6/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *manufacturer;
@property (strong, nonatomic) NSString *productUrl;

@end
