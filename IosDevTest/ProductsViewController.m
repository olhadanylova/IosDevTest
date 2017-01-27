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

#define PAGESIZE 3

static long size;
static int offset;

@interface ProductsViewController () {
    BackendlessDataQuery *query;
    int numberOfRows;
    NSMutableArray *loadedProducts;
}
@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (ProductDetailsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    loadedProducts = [[NSMutableArray alloc] init];
    [self retrieveProductsOnLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


#pragma mark - Paging

// Retrieve first PAGESIZE products.
- (void)retrieveProductsOnLoad {
    offset = 0;
    query = [BackendlessDataQuery query];
    query.queryOptions.pageSize = @(PAGESIZE);
    [[backendless.persistenceService of:[Product class]] find:query
                                                     response:^(BackendlessCollection *products) { [self getPageAsync:products offset:offset]; }
                                                        error:^(Fault *fault) { NSLog(@"Server reported an error: %@", fault); }];
}


- (void)getPageAsync:(BackendlessCollection *)products offset:(int)offset {
    for (Product *p in [products getCurrentPage]) [loadedProducts addObject:p];
    [self loadImagesAsync];
    // Current products count.
    size = [[products getCurrentPage] count];
    if (!size) return;
    numberOfRows += size;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    // Scroll to the last cell.
        NSIndexPath* ip = [NSIndexPath indexPathForRow:([loadedProducts count] - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


// Images load asynchronically from product image URL
- (void)loadImagesAsync {
    for (int i = 0; i < [loadedProducts count]; i++) {
        Product *p = loadedProducts[i];
        if (!p.image && p.imageURL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^{
                               NSURL *imageURL = [NSURL URLWithString:p.imageURL];
                               NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                               
                               //This is your completion handler
                               dispatch_sync(dispatch_get_main_queue(), ^{
                                   //If self.image is atomic (not declared with nonatomic)
                                   // you could have set it directly above
                                   p.image = [UIImage imageWithData:imageData];
                                   // Reload product cell to show image
                                   NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
                                   [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
                                   
                               });
                           });
        }
    }
}


- (void)reloadTableViewAfterGetPage {
    
    numberOfRows += size;
    
    
    //
    
    // Scroll to the last cell.
    //    NSIndexPath* ip = [NSIndexPath indexPathForRow:([loadedProducts count] - 1) inSection:0];
    //    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    
    
    
    //
    
    // If all data is displeyed Load More button disabled.
    //    BackendlessCollection *products = [[backendless.persistenceService of:[Product class]] find:nil];
    //    if (numberOfRows == [[products getCurrentPage] count]) {
    //        self.buttonLoadMore.enabled = NO;
    //        self.buttonLoadMore.title = @"All data loaded";
    //    }
    //    else {
    //        self.buttonLoadMore.enabled = YES;
    //        self.buttonLoadMore.title = @"Load More";
    //    }
}


#pragma mark - Buttons actions

- (IBAction)pressedLoadMore:(id)sender {
    // Increase the position of the object from which to retrieve next products.
    offset += size;
    [[[backendless.persistenceService of:[Product class]] find:query]   // = BackendlessCollection *products
     getPage:offset pageSize:PAGESIZE
     response:^(BackendlessCollection *products) { [self getPageAsync:products offset:offset]; }
     error:^(Fault *fault) { NSLog(@"Server reported an error: %@", fault); }];
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


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfRows;
}


- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    Product *p = loadedProducts[indexPath.row];
    
    cell.productNameLabel.text = p.productName;
    
    if (!p.image) cell.imgView.image = [UIImage imageNamed:@"noimage.png"];
    else cell.imgView.image = p.image;
    
    cell.descriptionLabel.text = p.description;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
