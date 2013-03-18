//
//  MGPlayingCardView.h
//  Matchismo
//
//  Created by Daniel Slomovits on 3/17/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGPlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong,nonatomic) NSString* suit;
@property (nonatomic) BOOL faceUp;

@end
