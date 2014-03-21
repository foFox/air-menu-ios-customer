//
//  AMMenuSectionCell.h
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FRDLivelyButton/FRDLivelyButton.h>

@protocol AMMenuSectionCellDelegate;
@interface AMMenuSectionCell : UICollectionViewCell
@property (nonatomic, readonly, weak) UILabel *textLabel;
@property (nonatomic, readonly, weak) FRDLivelyButton *button;
@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;
@property (nonatomic, readwrite, weak) id <AMMenuSectionCellDelegate> delegate;
@end

@protocol AMMenuSectionCellDelegate <NSObject>
-(void)didTapCell:(AMMenuSectionCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
