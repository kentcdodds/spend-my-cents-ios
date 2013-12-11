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

@interface MainViewController () <UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSArray *products;
@property (weak, nonatomic) IBOutlet UICollectionView *productsCollectionView;
@property (nonatomic) int itemPage;
@property (nonatomic) dispatch_queue_t downloadQueue;
@property (strong, nonatomic) NSMutableDictionary *imageCache;
@property (nonatomic) int selectedCardIndex;
@end

@implementation MainViewController

- (dispatch_queue_t)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = dispatch_queue_create("image downloader", NULL);
    }
    
    return _downloadQueue;
}

- (NSMutableDictionary *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    
    return _imageCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)) {
        self.searchField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    self.selectedCardIndex = -1;
}

- (IBAction)searchButtonPressed:(id)sender {
    [self.searchField resignFirstResponder];
    self.itemPage = 1;
    [self doSearch];
}

- (IBAction)moreButtonPressed:(id)sender {
    self.itemPage = self.itemPage + 1;
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
    int price = [self.searchField.text doubleValue] * 100;
    NSString *category = @"All";
    NSString *urlTemplate = @"http://www.spendmycents.com/products?simplifyResponse=true&searchIndex=%@&price=%d&itemPage=%d";
    NSString *formattedUrl = [NSString stringWithFormat:urlTemplate, category, price, self.itemPage];
    NSLog(@"%@", formattedUrl);
    NSURL *url = [NSURL URLWithString:formattedUrl];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self handleReturnedData:data resp:response err:error append:self.itemPage != 1];
    }];
    [task resume];
}

- (IBAction)cardTapped:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.productsCollectionView];
    NSIndexPath *indexPath = [self.productsCollectionView indexPathForItemAtPoint:location];
    
    if (indexPath) {
        if (indexPath.item > [self.products count]) {
            return;
        }
        ProductCardCollectionViewCell *cell = (ProductCardCollectionViewCell *)[self.productsCollectionView dequeueReusableCellWithReuseIdentifier:@"ProductCardCell" forIndexPath:indexPath];
        
        [UIView transitionWithView:cell duration:0.3f
                           options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            NSLog(@"Animation");
                            NSMutableArray *indexPaths = [NSMutableArray arrayWithArray:@[indexPath, [NSIndexPath indexPathWithIndex:self.selectedCardIndex]]];
                            NSArray *updateIndexPaths = [NSArray arrayWithArray:indexPaths];
                            if (self.selectedCardIndex == indexPath.item) {
                                self.selectedCardIndex = -1;
                                updateIndexPaths = @[indexPath];
                            } else {
                                if (self.selectedCardIndex == -1) {
                                    updateIndexPaths = @[indexPath];
                                }
                                self.selectedCardIndex = indexPath.item;
                            }
//                            [self.productsCollectionView reloadItemsAtIndexPaths:updateIndexPaths];
                            [self.productsCollectionView reloadData];
                        } completion:NULL];
    }
}

- (void) setCellContent: (ProductCardCollectionViewCell *)cell withProduct:(NSDictionary *)product {
    if (product[@"ASIN"]) {
        cell.productCardView.label.text = [NSString stringWithFormat:@"%@\n\nMade by: %@\n\nASIN: %@", product[@"title"], product[@"manufacturer"], product[@"ASIN"]];
    } else {
        cell.productCardView.label.text = @"No Information Available";
    }
}

- (void) setCellImage: (ProductCardCollectionViewCell *)cell withProduct:(NSDictionary *)product {
    NSString *imageUrl = product[@"imageUrl"];
    dispatch_async(self.downloadQueue, ^{
        if (!self.imageCache[imageUrl]) {
            // If the image for the given URL isn't already cached, get it now
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            self.imageCache[imageUrl] = [UIImage imageWithData:imageData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.productCardView.imageView.image = self.imageCache[imageUrl];
        });
    });
}

# pragma mark - collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int all = [self.products count];
    if (all > 0 && self.itemPage < 6) {
        all++;
    }
    return all;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCardCollectionViewCell *cell = (ProductCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCardCell" forIndexPath:indexPath];
    ProductCardView *pv = (ProductCardView *) cell.productCardView;
    
    if (indexPath.item >= [self.products count]) {
        pv.imageView.alpha = 0;
        pv.label.alpha = 0;
        pv.button.alpha = 1;
    } else {
        NSDictionary *product = self.products[indexPath.item];
        NSLog(@"%d - %@", indexPath.item, product[@"ASIN"]);
        
        if (indexPath.item == self.selectedCardIndex) {
            pv.imageView.alpha = 0;
            pv.label.alpha = 1;
        } else {
            pv.label.alpha = 0;
            pv.imageView.alpha = 1;
        }
        [self setCellContent:cell withProduct:product];
        [self setCellImage:cell withProduct:product];
    }
    return cell;
}

@end
