//
//  ProductModalViewController.m
//  smc
//
//  Created by Kent C. Dodds on 12/11/13.
//  Copyright (c) 2013 Spend My Cents. All rights reserved.
//

#import "ProductModalViewController.h"

@interface ProductModalViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *manufacturer;
@property (weak, nonatomic) IBOutlet UILabel *asin;

@end

@implementation ProductModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.productTitle.text = self.product[@"title"];
    self.manufacturer.text = [NSString stringWithFormat:@"By: %@", self.product[@"manufacturer"]];
    self.asin.text = [NSString stringWithFormat:@"ASIN: %@", self.product[@"ASIN"]];
    self.imageView.image = self.productImage;
}

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)openInAmazonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.product[@"url"]]];
}

- (IBAction)share:(id)sender {
    NSString *textToShare = [NSString stringWithFormat:@"%@\n\n%@ - Found using the iOS app of SpendMyCents.com, the new reverse product search web app.", self.product[@"url"], self.product[@"title"]];
    UIImage *imageToShare = self.productImage;
    NSArray *itemsToShare = @[textToShare, imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact];
    [self presentViewController:activityVC animated:YES completion:nil];
}


@end
