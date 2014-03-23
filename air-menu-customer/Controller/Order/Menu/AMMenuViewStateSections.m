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
#import <ObjectiveSugar/ObjectiveSugar.h>

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
    if(self.viewController.currentState == self)
    {
        AMMenuSection *section = self.menu.menuSections[indexPath.row];
        self.viewController.itemsState.sectionOfItems = section;
        self.viewController.currentState = self.viewController.itemsState;
        cell.indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [cell.button setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
        cell.delegate = (id <AMMenuSectionCellDelegate> )self.viewController.itemsState;
        
        [self.collectionView performBatchUpdates:^{
            [@0 upto:self.menu.menuSections.count - 1 do:^(NSInteger itemNumber){
                unless(itemNumber == indexPath.row)
                {
                    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:itemNumber inSection:0]]];
                }
            }];
            
            [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

            [@0 upto:section.menuItems.count - 1 do:^(NSInteger itemNumber) {
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:itemNumber + 1 inSection:0]]];
            }];
        }
        completion:nil];
    }
}

@end
