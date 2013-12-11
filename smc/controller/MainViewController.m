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
#import "ProductModalViewController.h"

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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.productsCollectionView reloadData];
            });
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self handleReturnedData:data resp:response err:error append:self.itemPage != 1];
    }];
    [task resume];
}

- (IBAction)cardTapped:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.productsCollectionView];
    NSIndexPath *indexPath = [self.productsCollectionView indexPathForItemAtPoint:location];
    
    if (indexPath && indexPath.item < [self.products count]) {
        UIStoryboard *storyBoard = [self storyboard];
        ProductModalViewController *modal  = [storyBoard instantiateViewControllerWithIdentifier:@"ProductModalViewController"];
        NSDictionary *product = self.products[indexPath.item];
        modal.product = product;
        modal.productImage = self.imageCache[product[@"imageUrl"]];
        [self presentViewController:modal animated:YES completion:nil];
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
    if (indexPath.item >= [self.products count]) {
        cell.productCardView.imageView.alpha = 0;
        cell.productCardView.button.alpha = 1;
    } else {
        NSDictionary *product = self.products[indexPath.item];
        NSLog(@"%d - %@", indexPath.item, product[@"ASIN"]);
        [self setCellImage:cell withProduct:product];
    }
    return cell;
}

@end
