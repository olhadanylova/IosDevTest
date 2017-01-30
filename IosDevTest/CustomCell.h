//
//  CustomCell.h
//  IosDevTest
//
//  Created by Olha Danylova on 27.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;

@interface CustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productDescriptionLabel;

@end
