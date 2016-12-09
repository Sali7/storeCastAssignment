//
//  ImageTableViewCell.h
//  StorecastAssignment
//
//  Created by MBE on 09.12.16.
//  Copyright © 2016 MBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *imageId;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
