//
//  Product.h
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *imageURL;
@property double price;

@end
