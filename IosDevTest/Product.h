//
//  Product.h
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property float price;

@end
