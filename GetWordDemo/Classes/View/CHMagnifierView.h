//
//  CHMagnifierView.h
//  Magnifier
//
//  Created by Chenhao on 14-2-25.
//  Copyright (c) 2014年 Chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMagnifierView : UIWindow

@property (nonatomic) UIView *viewToMagnify;

@property (nonatomic) CGPoint pointToMagnify;

@end
