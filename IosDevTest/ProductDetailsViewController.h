//
//  ProductDetailsViewController.h
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;

@interface ProductDetailsViewController : UIViewController

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UILabel *productNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

