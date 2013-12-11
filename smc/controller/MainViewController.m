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
#import "CategorySelectionViewController.h"
#import "TSMessage.h"

@interface MainViewController () <UICollectionViewDataSource, UIGestureRecognizerDelegate, SetCategoryDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UICollectionView *productsCollectionView;

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSMutableDictionary *imageCache;
@property (strong, nonatomic) NSArray *categories;

@property (nonatomic) int itemPage;
@property (nonatomic) int selectedCardIndex;
@property (nonatomic) int selectedCategoryIndex;

@property (nonatomic) dispatch_queue_t downloadQueue;

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
    self.categories = @[@"All", @"Apparel", @"Appliances", @"Arts and Crafts", @"Automotive",
                        @"Baby", @"Beauty", @"Blended", @"Books",
                        @"Classical", @"Collectibles",
                        @"DVD", @"Digital Music",
                        @"Electronics",
                        @"Gift Cards", @"Gourmet Food", @"Grocery",
                        @"Health Personal Care", @"Home Garden",
                        @"Industrial",
                        @"Jewelry",
                        @"Kindle Store", @"Kitchen",
                        @"Lawn And Garden",
                        @"Marketplace", @"MP3 Downloads", @"Magazines", @"Miscellaneous",
                        @"Music", @"Music Tracks", @"Musical Instruments", @"Mobile Apps",
                        @"Office Products", @"Outdoor Living",
                        @"PC Hardware", @"Pet Supplies", @"Photo",
                        @"Shoes", @"Software", @"Sporting Goods",
                        @"Tools", @"Toys",
                        @"Unbox Video",
                        @"VHS", @"Video", @"Video Games",
                        @"Watches", @"Wireless", @"Wireless Accessories"
                        ];
    
    self.selectedCardIndex = -1;
}

- (void)setCategoryIndex:(int)index {
    self.selectedCategoryIndex = index;
    if (self.selectedCategoryIndex > -1) {
        [self.categoryButton setTitle:self.categories[self.selectedCategoryIndex] forState:UIControlStateNormal];
    }
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

- (void)handleReturnedData:(NSData *)data resp:(NSURLResponse *) response err:(NSError *) error append:(bool) append {
    if (!error) {
        NSError *jsonError = nil;
        NSArray *products = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError && [products isKindOfClass:[NSArray class]]) {
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMessage:@"Error" :@"There was a problem with the response" :2 :TSMessageNotificationTypeError];
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:@"Error" :@"There was a problem with the request" :2 :TSMessageNotificationTypeError];
        });
    }
}

-(void)showMessage:(NSString *)title :(NSString *)description :(int)duration :(TSMessageNotificationType)type {
    [TSMessage showNotificationInViewController:self
                                          title:NSLocalizedString(title, nil)
                                       subtitle:NSLocalizedString(description, nil)
                                          image:nil
                                           type:type
                                       duration:duration
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

- (void)doSearch {
    [self showMessage:@"Searching" :@"Please Wait" :TSMessageNotificationDurationEndless :TSMessageNotificationTypeMessage];
    

    NSURLSession *session = [NSURLSession sharedSession];
    int price = [self.searchField.text doubleValue] * 100;
    NSString *category = self.categories[self.selectedCategoryIndex];
    if (!category) {
        category = @"All";
    } else {
        category = [category stringByReplacingOccurrencesOfString:@" "
                                             withString:@""];
    }
    NSString *urlTemplate = @"http://www.spendmycents.com/products?simplifyResponse=true&searchIndex=%@&price=%d&itemPage=%d";
    NSString *formattedUrl = [NSString stringWithFormat:urlTemplate, category, price, self.itemPage];
    NSLog(@"%@", formattedUrl);
    NSURL *url = [NSURL URLWithString:formattedUrl];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [TSMessage dismissActiveNotification];
        [self handleReturnedData:data resp:response err:error append:self.itemPage != 1];
    }];
    [task resume];
}

- (IBAction)categoryTapped:(id)sender {
    UIStoryboard *storyBoard = [self storyboard];
    CategorySelectionViewController *modal  = [storyBoard instantiateViewControllerWithIdentifier:@"CategorySelectionView"];
    modal.categories = self.categories;
    modal.selectedCategoryIndex = self.selectedCategoryIndex;
    modal.delegate = self;
    [self presentViewController:modal animated:YES completion:nil];
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
            [cell.productCardView.loadingIndicator stopAnimating];
            cell.productCardView.imageView.image = self.imageCache[imageUrl];
            cell.productCardView.imageView.alpha = 1;
        });
    });
}

# pragma mark - collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int all = [self.products count];
    int divisibleByTen = !fmod(all, 10);
    if (all > 0 && self.itemPage < 5 && divisibleByTen) {
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
        [cell.productCardView.loadingIndicator stopAnimating];
    } else {
        NSDictionary *product = self.products[indexPath.item];
        NSLog(@"%d - %@", indexPath.item, product[@"ASIN"]);
        [self setCellImage:cell withProduct:product];
    }
    return cell;
}

@end
