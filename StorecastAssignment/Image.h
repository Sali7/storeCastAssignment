//
//  Image.h
//  StorecastAssignment
//
//  Created by MBE on 09.12.16.
//  Copyright © 2016 MBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject

@property(nonatomic, retain)NSString *imageId;
@property(nonatomic, retain)NSString *imageTitle;
@property(nonatomic, retain)NSURL *imageUrl;

- (id)initWithId:(NSString*)imageId title:(NSString*)imageTitle url:(NSURL*)imageUrl;

@end
