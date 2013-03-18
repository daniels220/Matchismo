//
//  MGSetCardView.h
//  Matchismo
//
//  Created by Daniel Slomovits on 3/17/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGSetCardView : UIView

@property (strong,nonatomic) UIColor* color;
@property (strong,nonatomic) NSString* symbol;
@property (nonatomic) CGFloat shading;
@property (nonatomic) NSUInteger number;

@property (nonatomic) BOOL selected;

@end
