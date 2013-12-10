//
//  MainViewController.m
//  smc
//
//  Created by Kent C. Dodds on 12/7/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import "MainViewController.h"
#import "ProductCardCollectionViewCell.h"
#import "ProductCardView.h"

@interface MainViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSArray *products;
@property (weak, nonatomic) IBOutlet UICollectionView *productsCollectionView;
@property (nonatomic) int itemPage;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)) {
        self.searchField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    self.products = @[@1, @2, @3, @4, @5,
                      @6, @7, @8, @9, @10];
    [self.productsCollectionView reloadData];
}

- (IBAction)searchButtonPressed:(id)sender {
    [self.searchField resignFirstResponder];
    self.itemPage = 1;
    [self doSearch];
}

-(void)handleReturnedData:(NSData *)data resp:(NSURLResponse *) response err:(NSError *) error append:(bool) append {
    if (!error) {
        NSError *jsonError = nil;
        NSArray *products = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError && [products isKindOfClass:[NSArray class]]) {
            NSLog(@"Success!");
            if (append) {
                NSMutableArray *allProducts = [NSMutableArray arrayWithArray: self.products];
                [allProducts addObjectsFromArray: products];
                self.products = [NSArray arrayWithArray:allProducts];
            } else {
                self.products = products;
            }
            [self.productsCollectionView reloadData];
        } else {
            NSLog(@"There was problem with the response");
        }
    } else {
        NSLog(@"There was a problem with the request");
    }
}

-(void)doSearch {
    NSURLSession *session = [NSURLSession sharedSession];
//    NSInteger myInt = [myString intValue];
    int price = [self.searchField.text intValue] * 100;
    NSString *category = @"All";
    NSString *urlTemplate = @"http://www.spendmycents.com/products?simplifyResponse=true&searchIndex=%@&price=%d&itemPage=%d";
    NSString *formattedUrl = [NSString stringWithFormat:urlTemplate, category, price, self.itemPage];
    NSLog(formattedUrl);
    NSURL *url = [NSURL URLWithString:formattedUrl];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self handleReturnedData:data resp:response err:error append:self.itemPage != 1];
    }];
    [task resume];
}

# pragma mark - collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.products count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCardCollectionViewCell *cell = (ProductCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCardCell" forIndexPath:indexPath];
    [cell setupCellWithProduct:self.products[indexPath.item]];
    return cell;
}

@end
