//
//  MainViewController.h
//  StorecastAssignment
//
//  Created by MBE on 09.12.16.
//  Copyright © 2016 MBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
