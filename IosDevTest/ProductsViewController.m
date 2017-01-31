//
//  ProductsViewController.m
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductDetailsViewController.h"
#import "CustomCell.h"
#import "Backendless.h"
#import "Product.h"

#define PAGESIZE 10

static int offset = 0;

@interface ProductsViewController () {
    long totalDataCount;
    BackendlessDataQuery *query;
    NSMutableArray *loadedProducts;
}
@end


@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (ProductDetailsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    loadedProducts = [[NSMutableArray alloc] init];
    totalDataCount = [[[[backendless.persistenceService of:[Product class]] find:nil] data] count];
    [self getFirstPageAsync];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


#pragma mark - Paging

/**
 Implements async getting first page.
 
 This method is called right after view did load.
 */
- (void)getFirstPageAsync {
    query = [BackendlessDataQuery query];
    query.queryOptions.pageSize = @(PAGESIZE);
    [[backendless.persistenceService of:[Product class]] find:query
                                                     response:^(BackendlessCollection *products) {
                                                         [self getPageAsync:products];
                                                     }
                                                        error:^(Fault *fault) {
                                                            NSLog(@"Server reported an error: %@", fault);
                                                        }];
}


/**
 Implements async getting every next page after the first page.
 */
- (void)getNextPageAsync {
    offset += PAGESIZE;
    [[[backendless.persistenceService of:[Product class]] find:query]
     getPage:offset
     pageSize:PAGESIZE
     response:^(BackendlessCollection *products) {
         [self getPageAsync:products];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}


/**
 Implements getting page from BackendlessCollection.
 
 @param products BackendlessCollection class that represents object collections returned by the find methods.
 */
- (void)getPageAsync:(BackendlessCollection *)products {
    for (Product *product in [products getCurrentPage]) {
        [loadedProducts addObject:product];
    }
    
    [self loadImagesAsync];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    // Scroll to the last cell.
    if ([loadedProducts count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([loadedProducts count] - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    // Make "Load More" button disabled if all data is loaded.
    if ([loadedProducts count] == totalDataCount) {
        self.buttonLoadMore.enabled = NO;
        self.buttonLoadMore.title = @"All data loaded";
    }
    else {
        self.buttonLoadMore.enabled = YES;
        self.buttonLoadMore.title = @"Load More";
    }
}


/**
 Implements async getting product image from product image URL.
 */
- (void)loadImagesAsync {
    for (int i = 0; i < [loadedProducts count]; i++) {
        Product *product = loadedProducts[i];
        if (!product.image && ![product.imageURL isEqualToString:@""]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^{
                               NSURL *imageURL = [NSURL URLWithString:product.imageURL];
                               NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                               
                               // Completion header.
                               dispatch_sync(dispatch_get_main_queue(), ^{
                                   product.image = [UIImage imageWithData:imageData];
                                   
                                   // Reload product cell to show image.
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                   
                               });
                           });
        }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [loadedProducts count];
}


- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    Product *product = loadedProducts[indexPath.row];
    
    // If product image hasn't been loaded yet it's image sets to "noimage.png".
    if (!product.image) {
        cell.imgView.image = [UIImage imageNamed:@"noimage.png"];
    }
    // If product image has already been loaded.
    else {
        cell.imgView.image = product.image;
    }
    
    cell.productNameLabel.text = product.productName;
    cell.productDescriptionLabel.text = product.productDescription;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Product *product = loadedProducts[indexPath.row];
        ProductDetailsViewController *productDetailsVC = (ProductDetailsViewController *)[[segue destinationViewController] topViewController];
        [productDetailsVC setProduct:product];
    }
}


#pragma mark - Buttons actions

- (IBAction)pressedLoadMore:(id)sender {
    [self getNextPageAsync];
}

@end
