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


- (void)configureView {
    self.title = [NSString stringWithFormat:@"%@ Details", self.product.productName];
    
    if (!self.product.image) self.imgView.image = [UIImage imageNamed:@"noimage.png"];
    else self.imgView.image = self.product.image;
    
    self.productNameLabel.text = self.product.productName;
    self.priceLabel.text = [@(self.product.price) stringValue];
    self.descriptionLabel.text = self.product.description;
}

@end
