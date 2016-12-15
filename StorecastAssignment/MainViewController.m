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
#import "Image.h"

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
                 NSDictionary *response = (NSDictionary *)responseObject;
                 [self.searchedImagesArray addObjectsFromArray:(NSArray *) [response objectForKey:@"images"]];
                 
                 [self.tableView reloadData];
                 
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
           
                 [self.tableView reloadData];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Request Failed: %@, %@", error, error.userInfo);
             }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(isSearch){
        //if(page == pagesNumber){
        //    return [self.searchedImagesArray count];
        //} else{
            return [self.searchedImagesArray count] + 1;
        //}
    } else {
        //if(page == pagesNumber){
        //    return [self.imagesArray count];
        //} else{
            return [self.imagesArray count] + 1;
        //}
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.imagesArray count] - 1 || indexPath.row == [self.searchedImagesArray count] - 1) {
            page++;
            [self makeRequests:page];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDictionary;
    
    if(isSearch){
        tempDictionary= [self.searchedImagesArray objectAtIndex:indexPath.row];
    } else{
        tempDictionary= [self.imagesArray objectAtIndex:indexPath.row];
    }

    NSString *caption    = [tempDictionary objectForKey:@"caption"];

    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"" message:caption delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [messageAlert show];
    
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
            
            NSDictionary *displaySize = [[tempDictionary objectForKey:@"display_sizes"] objectAtIndex:0];
            NSString *imageUri = [displaySize objectForKey:@"uri"];
            NSURL *url = [NSURL URLWithString:[imageUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            Image *image = [[Image alloc] initWithId:[tempDictionary objectForKey:@"id"] title:[tempDictionary objectForKey:@"title"] url:url];
            
            cell.imageId.text    = image.imageId;
            cell.imageTitle.text = image.imageTitle;
    
            //Setting nil if any for safety
            cell.image.image = nil;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                NSData *data = [[NSData alloc] initWithContentsOfURL:image.imageUrl];
                UIImage *tmpImage = [[UIImage alloc] initWithData:data];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.image.image = tmpImage;
                });
            });
            

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
            
            NSDictionary *displaySize = [[tempDictionary objectForKey:@"display_sizes"] objectAtIndex:0];
            NSString *imageUri = [displaySize objectForKey:@"uri"];
            NSURL *url = [NSURL URLWithString:[imageUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            Image *image = [[Image alloc] initWithId:[tempDictionary objectForKey:@"id"] title:[tempDictionary objectForKey:@"title"] url:url];
            
            cell.imageId.text    = image.imageId;
            cell.imageTitle.text = image.imageTitle;

            //Setting nil if any for safety
            cell.image.image = nil;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                NSData *data = [[NSData alloc] initWithContentsOfURL:image.imageUrl];
                UIImage *tmpImage = [[UIImage alloc] initWithData:data];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.image.image = tmpImage;
                });
            });
            
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
        [self.tableView reloadData];

        self.searchedText = text;
        self.searchedText = [self.searchedText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSString *requestURL = [NSString stringWithFormat:@"https://api.gettyimages.com:443/v3/search/images?page=1&page_size=10&phrase=%@", self.searchedText];
        [manager GET:requestURL
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *response = (NSDictionary *)responseObject;
                 [self.searchedImagesArray addObjectsFromArray:(NSArray *) [response objectForKey:@"images"]];
                 
                 [self.tableView reloadData];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Request Failed: %@, %@", error, error.userInfo);
             }];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isSearch = false;
    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
    
}

@end
