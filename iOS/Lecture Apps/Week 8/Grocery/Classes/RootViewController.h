//
//  RootViewController.h
//  Grocery
//
//  Created by Aileen Pierce on 10/21/11.
//  Copyright 2011 University of Colorado at Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsViewController.h"

@interface RootViewController : UITableViewController {
	IBOutlet ItemsViewController *itemView;
	NSDictionary *storeList;
	
}

@property (nonatomic, retain) IBOutlet ItemsViewController *itemView;
@property (nonatomic, retain) NSDictionary *storeList;


@end
