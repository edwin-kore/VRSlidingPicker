//
//  VRCollectionView.m
//  VRSlidingPicker
//
//  Created by Venu on 8/5/15.
//  Copyright (c) 2015 VRCo. All rights reserved.
//

#import "VRCollectionView.h"
#import "VRCollectionViewCell.h"

@interface VRCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    CGFloat cellWidth;
}
@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation VRCollectionView

- (void)loadWithDataSource:(NSArray*)dataSource{
    self.dataSource = dataSource;
    [self loadView];
}

- (void)loadView{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    cellWidth = bounds.size.width/7;
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [collectionViewLayout setItemSize:CGSizeMake(cellWidth, 50.0f)];
    [collectionViewLayout setMinimumInteritemSpacing:0.0f];
    [collectionViewLayout setMinimumLineSpacing:0.0f];
    [collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[VRCollectionViewCell class] forCellWithReuseIdentifier:@"VRCell"];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self addSubview:self.collectionView];
    
    //Arrow
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.arrowImageView setImage:[UIImage imageNamed:@"arrow_up"]];
    [self addSubview:self.arrowImageView];
}

- (void)layoutSubviews{
    CGRect frame = self.bounds;
    frame.size.height = 50.0f;
    [self.collectionView setFrame:frame];
    
    frame.size.height = 30.0f;
    frame.size.width = 30.0f;
    frame.origin.y = self.collectionView.frame.size.height;
    frame.origin.x = (self.collectionView.frame.size.width - frame.size.width)/2;
    [self.arrowImageView setFrame:frame];
}

#pragma mark - CollectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

#pragma mark - CollectionView Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Setup cell identifier
    static NSString *cellIdentifier = @"VRCell";
    
    VRCollectionViewCell *cell = (VRCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *data = [self.dataSource objectAtIndex:indexPath.row];
    [cell.label setText:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= DuplicateValues && indexPath.row <= NumberOfDays+DuplicateValues) {
        NSLog(@"IndexPathRow:%ld",(long)indexPath.row);
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:indexPath.row - DuplicateValues inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        if ([self.delegate respondsToSelector:@selector(didSelectTheDay:)]) {
            [self.delegate didSelectTheDay:(indexPath.row - DuplicateValues)];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollIndex = 0.0f;
    CGFloat numberOfCellsAtOffset = scrollView.contentOffset.x/cellWidth;
    CGFloat decimalValue = numberOfCellsAtOffset - floorf(numberOfCellsAtOffset);
    if (decimalValue > 0.5) {
        scrollIndex = ceilf(numberOfCellsAtOffset);
    }else{
        scrollIndex = floorf(numberOfCellsAtOffset);
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:scrollIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectTheDay:)]) {
        [self.delegate didSelectTheDay:(scrollIndex)];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        CGFloat scrollIndex = 0.0f;
        CGFloat numberOfCellsAtOffset = scrollView.contentOffset.x/cellWidth;
        CGFloat decimalValue = numberOfCellsAtOffset - floorf(numberOfCellsAtOffset);
        if (decimalValue > 0.5) {
            scrollIndex = ceilf(numberOfCellsAtOffset);
        }else{
            scrollIndex = floorf(numberOfCellsAtOffset);
        }
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:scrollIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        if ([self.delegate respondsToSelector:@selector(didSelectTheDay:)]) {
            [self.delegate didSelectTheDay:(scrollIndex)];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
