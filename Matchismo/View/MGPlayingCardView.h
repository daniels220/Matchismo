//
//  MGPlayingCardView.h
//  Matchismo
//
//  Created by Daniel Slomovits on 3/17/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCardView.h"

@interface MGPlayingCardView : MGCardView

@property (nonatomic) NSUInteger rank;
@property (strong,nonatomic) NSString* suit;

@end
