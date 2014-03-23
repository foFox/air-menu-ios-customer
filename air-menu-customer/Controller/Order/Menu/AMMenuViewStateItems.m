//
//  AMMenuViewStateItems.m
//  Air Menu C
//
//  Created by Robert Lis on 21/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuViewStateItems.h"
#import "AMMenuViewController.h"
#import "AMMenuSectionCell.h"
#import "AMMenuItemCell.h"

@interface AMMenuViewStateItems() <AMMenuSectionCellDelegate>
@end

@implementation AMMenuViewStateItems

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sectionOfItems.menuItems.count + 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        AMMenuSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu_section_cell" forIndexPath:indexPath];
        cell.textLabel.text = [self.sectionOfItems name];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    else
    {
        AMMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu_item_cell" forIndexPath:indexPath];
        AMMenuItem *item = self.sectionOfItems.menuItems[indexPath.row - 1];
        cell.itemNameLabel.text = item.name;
        cell.itemPriceLabel.text = item.price.description;
        cell.itemDescriptionLabel.text = item.details;
        return cell;
    }
}

-(void)didTapCell:(AMMenuSectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewController.currentState == self)
    {
        NSUInteger indexOfSection = [self.menu.menuSections indexOfObject:self.sectionOfItems];
        self.viewController.currentState = self.viewController.sectionsState;
        cell.indexPath = [NSIndexPath indexPathForItem:indexOfSection inSection:0];
        cell.delegate = (id <AMMenuSectionCellDelegate> )self.viewController.sectionsState;
        [cell.button setStyle:kFRDLivelyButtonStyleCaretDown animated:YES];

        [self.collectionView performBatchUpdates:^{
            [@1 upto:self.sectionOfItems.menuItems.count do:^(NSInteger itemNumber) {
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:itemNumber inSection:0]]];
            }];
            
            [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:indexOfSection inSection:0]];
            
            [@0 upto:self.menu.menuSections.count - 1 do:^(NSInteger itemNumber) {
                unless(itemNumber == indexOfSection)
                {
                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:itemNumber inSection:0]]];
                }
            }];
        } completion:nil];
    }
}
@end
