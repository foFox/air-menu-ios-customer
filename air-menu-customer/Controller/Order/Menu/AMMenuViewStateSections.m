//
//  AMMenuViewStateSections.m
//  Air Menu C
//
//  Created by Robert Lis on 21/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuViewStateSections.h"
#import "AMMenuSectionCell.h"
#import "AMMenuViewController.h"

@interface AMMenuViewStateSections() <AMMenuSectionCellDelegate>
@end

@implementation AMMenuViewStateSections

#pragma mark - Collection View Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menu.menuSections.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu_section_cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.menu.menuSections[indexPath.row] name];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - Section Cell Delegate

-(void)didTapCell:(AMMenuSectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AMMenuSection *section = self.menu.menuSections[1];
    self.viewController.itemsState.sectionOfItems = section;
    self.viewController.currentState = self.viewController.itemsState;
    [cell.button setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
}

@end
