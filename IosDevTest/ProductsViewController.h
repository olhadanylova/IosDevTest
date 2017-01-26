//
//  MasterViewController.h
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailsViewController;

@interface ProductsViewController : UITableViewController
@property (strong, nonatomic) ProductDetailsViewController *detailViewController;
@end

