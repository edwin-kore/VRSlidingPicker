//
//  VRCollectionViewCell.m
//  VRSlidingPicker
//
//  Created by Venu on 8/5/15.
//  Copyright (c) 2015 VRCo. All rights reserved.
//

#import "VRCollectionViewCell.h"

@implementation VRCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"VRCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] > 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
