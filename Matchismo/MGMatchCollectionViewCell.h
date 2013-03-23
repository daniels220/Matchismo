//
//  MGMatchCollectionViewCell.h
//  Matchismo
//
//  Created by Daniel Slomovits on 3/22/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCardView.h"

@interface MGMatchCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutletCollection(MGCardView) NSArray *twoCardViews;
@property (weak, nonatomic) IBOutlet MGCardView *thirdCardView;
@property (weak,nonatomic,readonly) NSArray* cardViews;
@end
