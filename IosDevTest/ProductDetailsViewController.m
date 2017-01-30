//
//  ProductDetailsViewController.m
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "Product.h"


@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}


/**
 Configures product details view with product's data.
 */
- (void)configureView {
    self.title = [NSString stringWithFormat:@"%@ Details", self.product.productName];
    
    // If product image hasn't been loaded yet it's image sets to "noimage.png".
    if (!self.product.image) {
        self.imgView.image = [UIImage imageNamed:@"noimage.png"];
    }
    // If product image has already been loaded.
    else {
        self.imgView.image = self.product.image;
    }
    
    self.productNameLabel.text = self.product.productName;
    self.priceLabel.text = [@(self.product.price) stringValue];
    self.descriptionTextView.text = self.product.productDescription;
}

@end
