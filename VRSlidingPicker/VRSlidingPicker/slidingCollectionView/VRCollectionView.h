//
//  VRCollectionView.h
//  VRSlidingPicker
//
//  Created by Venu on 8/5/15.
//  Copyright (c) 2015 VRCo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NumberOfDays 31
#define cellHeight 50.0f
#define DuplicateValues 3

@protocol VRCollectionViewDelegate <NSObject>

@optional
- (void) didSelectTheDay:(NSInteger)integer;

@end
@interface VRCollectionView : UIView{
    
}
@property (nonatomic, weak) id<VRCollectionViewDelegate> delegate;
- (id)initWithDataSource:(NSArray*)dataSource;
- (void)loadWithDataSource:(NSArray*)dataSource;

@end
