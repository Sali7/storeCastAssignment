//
//  MainViewController.m
//  StorecastAssignment
//
//  Created by MBE on 09.12.16.
//  Copyright © 2016 MBE. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ImageTableViewCell.h"

static int page = 1;
static int pagesNumber = 0;
static BOOL isSearch;

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *searchedImagesArray;
@property (strong, nonatomic) NSString *searchedText;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.imagesArray = [NSMutableArray new];
    self.searchedImagesArray = [NSMutableArray new];
    [self makeRequests:page];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeRequests:(NSInteger)page
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"4x3mqfykgft2uj2zynnw4b9w" forHTTPHeaderField:@"Api-Key"];
    
    if(isSearch){
        NSString *requestURL = [NSString stringWithFormat:@"https://api.gettyimages.com:443/v3/search/images?page=%ld&page_size=10&phrase=%@", (long)page, self.searchedText];
        [manager GET:requestURL
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self.searchedImagesArray addObjectsFromArray:(NSArray *) responseObject];
                 
                 NSLog(@"The Array: %@",responseObject);
                 
                 [self.tableView reloadData];
                 
                 NSDictionary *responseHeader = operation.response.allHeaderFields;
                 pagesNumber = (int)[[responseHeader objectForKey:@"x-pagination-page-count"] integerValue];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Request Failed: %@, %@", error, error.userInfo);
             }];
        
    } else{

        NSString *requestURL = [NSString stringWithFormat:@"https://api.gettyimages.com:443/v3/search/images?page=%ld&page_size=10&phrase=mobile", (long)page];
        [manager GET:requestURL
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *response = (NSDictionary *)responseObject;
                 [self.imagesArray addObjectsFromArray:(NSArray *) [response objectForKey:@"images"]];
                 
                 NSLog(@"The Array: %@",self.imagesArray);
                 NSDictionary *responseHeader = operation.response.allHeaderFields;
                 pagesNumber = (int)[[responseHeader objectForKey:@"x-pagination-page-count"] integerValue];
                 [self.tableView reloadData];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Request Failed: %@, %@", error, error.userInfo);
             }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(isSearch){
        if(page == pagesNumber){
            return [self.searchedImagesArray count];
        } else{
            return [self.searchedImagesArray count] + 1;
        }
    } else {
        if(page == pagesNumber){
            return [self.imagesArray count];
        } else{
            return [self.imagesArray count] + 1;
        }
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.imagesArray count] - 1 || indexPath.row == [self.searchedImagesArray count] - 1) {
        if(page < pagesNumber){
            page++;
            [self makeRequests:page];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isSearch){
        if (indexPath.row == [self.imagesArray count]) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            
            return cell;
        } else{
            static NSString *CellIdentifier = @"Cell";
            ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            NSDictionary *tempDictionary= [self.imagesArray objectAtIndex:indexPath.row];
            
            cell.imageId.text    = [tempDictionary objectForKey:@"id"];
            cell.imageTitle.text = [tempDictionary objectForKey:@"title"];
    
            NSDictionary *displaySize = [[tempDictionary objectForKey:@"display_sizes"] objectAtIndex:0];
            NSString *imageUri = [displaySize objectForKey:@"uri"];

            NSURL *url = [NSURL URLWithString:[imageUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
            cell.image.image = tmpImage;

            return cell;
       }
    }else{
        if (indexPath.row == [self.searchedImagesArray count]) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
            
            return cell;
        } else{
            static NSString *CellIdentifier = @"Cell";
            ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            NSDictionary *tempDictionary= [self.searchedImagesArray objectAtIndex:indexPath.row];
            
            cell.imageId.text    = [tempDictionary objectForKey:@"id"];
            cell.imageTitle.text = [tempDictionary objectForKey:@"title"];
            
            NSDictionary *displaySize = [[tempDictionary objectForKey:@"display_sizes"] objectAtIndex:0];
            NSString *imageUri = [displaySize objectForKey:@"uri"];
            
            NSURL *url = [NSURL URLWithString:[imageUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
            
            cell.image.image = tmpImage;
            
            return cell;
        }

    }
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    page = 1;
    
    if(text.length == 0)
    {
        //isFiltered = FALSE;
        self.searchedText = @"";
        isSearch = false;
        [self.tableView reloadData];
        
    }
    else
    {
        isSearch = true;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"4x3mqfykgft2uj2zynnw4b9w" forHTTPHeaderField:@"Api-Key"];

        if(![self.searchedText isEqualToString:text]){
            self.searchedImagesArray  = [NSMutableArray new];
        }
        
        self.searchedText = text;
        self.searchedText = [self.searchedText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSString *requestURL = [NSString stringWithFormat:@"https://api.gettyimages.com:443/v3/search/images?page=1&page_size=10&phrase=%@", self.searchedText];
        [manager GET:requestURL
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 //self.searchedMoviesArray = (NSMutableArray *) responseObject;
                 [self.searchedImagesArray addObjectsFromArray:(NSArray *) responseObject];
                 
                 NSLog(@"The Array: %@",responseObject);
                 
                 [self.tableView reloadData];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Request Failed: %@, %@", error, error.userInfo);
             }];
    }
    
    //[self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isSearch = false;
    
}

@end
