//
//  GroceryAppDelegate.h
//  Grocery
//
//  Created by Aileen Pierce on 10/21/11.
//  Copyright 2011 University of Colorado at Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroceryAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

