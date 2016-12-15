//
//  Image.m
//  StorecastAssignment
//
//  Created by MBE on 09.12.16.
//  Copyright © 2016 MBE. All rights reserved.
//

#import "Image.h"

@implementation Image

- (id)initWithId:(NSString*)imageId title:(NSString*)imageTitle url:(NSURL*)imageUrl {
    self = [super init];
    if (self) {
        self.imageId      = imageId;
        self.imageTitle   = imageTitle;
        self.imageUrl     = imageUrl;

    }
    return self;
}

@end
