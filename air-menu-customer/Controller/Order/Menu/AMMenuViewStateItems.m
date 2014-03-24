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
#import "UILabel+AttributesCopy.h"
#import "UITextView+AttributesCopy.h"

@interface AMMenuViewStateItems() <AMMenuSectionCellDelegate>
@property (nonatomic, readwrite, strong) NSNumberFormatter *formatter;
@property (nonatomic, readwrite, strong) AMMenuItemCell *sampleCell;
@end

@implementation AMMenuViewStateItems

#pragma mark - Lifecycle

-(id)initWithController:(AMMenuViewController *)controller restaurant:(AMRestaurant *)restaurant collectionView:(UICollectionView *)collectionView
{
    self = [super initWithController:controller restaurant:restaurant collectionView:collectionView];
    if(self)
    {
        self.formatter = [[NSNumberFormatter alloc] init];
        self.sampleCell = [[AMMenuItemCell alloc] initWithFrame:CGRectZero];
        [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [self.formatter setPositiveFormat:@"##0.00"];
    }
    return self;
}

#pragma mark - Collection View Data Source

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
        [cell.itemNameLabel setTextWithExistingAttributes:item.name];
        [cell.itemPriceLabel setTextWithExistingAttributes:[[self.formatter stringFromNumber:item.price] stringByAppendingString:@" €"]];
        [cell.itemDescriptionLabel setTextWithExistingAttributes:item.details];
        CGFloat offset = cell.itemNameLabel.bounds.size.width - cell.itemPriceLabel.bounds.size.width;
        CGRect priceLabelRect = CGRectApplyAffineTransform(cell.itemPriceLabel.bounds, CGAffineTransformMakeTranslation(offset, 0));
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:priceLabelRect];
        cell.itemNameLabel.textContainer.exclusionPaths = @[path];
        return cell;
    }
}
#pragma mark - Collection View Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return CGSizeMake(self.viewController.view.bounds.size.width, 80);
    }
    else
    {
        AMMenuItem *item = self.sectionOfItems.menuItems[indexPath.row - 1];
        CGFloat nameHeight = [self nameFieldHeightForString:item.name withWidth:280 withPrice:[[self.formatter stringFromNumber:item.price] stringByAppendingString:@" €"]];
        CGFloat descriptionHeight = [self sizeOfDescriptionLabelWithString:item.details].height;
        if(item.details && ![item.details isEqualToString:@""])
        {
            descriptionHeight += 20.0f;
        }
        else
        {
            descriptionHeight -= 20.0f;
        }
        return CGSizeMake(self.viewController.view.bounds.size.width, ceilf(nameHeight) + ceilf(descriptionHeight) + 40.0f);
    }
}

#pragma mark - Section Cell Delegate

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
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma mark - Other

-(CGFloat)nameFieldHeightForString:(NSString *)name withWidth:(CGFloat)width withPrice:(NSString *)price
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:name attributes:self.sampleCell.itemNameLabel.attributes];
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(width, CGFLOAT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    layoutManager.textStorage = textStorage;
    CGRect exclusionRect = CGRectMake(width - [self sizeOfPriceFieldWithString:price].width,
                                      0,
                                      [self sizeOfPriceFieldWithString:price].width,
                                      [self sizeOfPriceFieldWithString:price].height);
    container.exclusionPaths = @[[UIBezierPath bezierPathWithRect:exclusionRect]];
    [layoutManager addTextContainer:container];
    CGRect rect = [layoutManager boundingRectForGlyphRange:NSMakeRange(0, [textStorage length]) inTextContainer:container];
    return rect.size.height;
}

-(CGSize)sizeOfPriceFieldWithString:(NSString *)price
{
    return [price sizeWithAttributes:self.sampleCell.itemPriceLabel.attributes];
}

-(CGSize)sizeOfDescriptionLabelWithString:(NSString *)description
{
    return [description boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:self.sampleCell.itemDescriptionLabel.attributes
                                     context:nil].size;
    
}

@end
