//
//  AMMenuViewState.m
//  Air Menu C
//
//  Created by Robert Lis on 21/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuViewState.h"
#import "AMMenuViewController.h"

@implementation AMMenuViewState
-(id)initWithController:(AMMenuViewController *)controller restaurant:(AMRestaurant *)restaurant
{
    self = [super init];
    if(self)
    {
        self.viewController = controller;
        self.restaurant = restaurant;
    }
    return self;
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"AMMenuViewState is an abstract class"
                                 userInfo:nil];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"AMMenuViewState is an abstract class"
                                 userInfo:nil];
}

#pragma mark - Collection View Data Source

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.viewController.view.bounds.size.width, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


@end
