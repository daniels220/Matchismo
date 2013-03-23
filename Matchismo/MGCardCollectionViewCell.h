//
//  MGSetCardCollectionViewCell.h
//  Matchismo
//
//  Created by Daniel Slomovits on 3/17/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCardView.h"

@interface MGCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet MGCardView *cardView;
@end
