//
//  NSArray+FAItemLoader.h
//  items loader
//
//  Created by Fadi Abuzant on 4/21/18.
//  Copyright © 2018 Fadi Abuzant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface NSArray (FAItemLoader)

typedef void (^ refreshTable)(void);

#pragma mark - pageNumber
-(int)pageNumber;

-(void)setPageNumber:(int)value;

#pragma mark - hasNext
-(BOOL)hasNext;

-(void)setHasNext:(BOOL)value;

#pragma mark - isLoading
-(BOOL)isLoading;

-(void)setIsLoading:(BOOL)value;

#pragma mark - tableView
-(UITableView*)tableView;

-(void)setTableView:(UITableView*)value;

#pragma mark - refreshControl
-(UIRefreshControl*)refreshControl;

-(void)setRefreshControl:(UIRefreshControl*)value;

-(void)beginRefreshing;

-(void)reset;

#pragma mark - Add refreshControl to tableView
-(void)tableViewWithRefreshTable:(refreshTable)refresh;

-(void)tableViewWithRefreshControlColor:(UIColor*)color refreshTable:(refreshTable)refresh;

-(void)tableViewWithRefreshControlColor:(UIColor*)color tableView:(UITableView*)tableView refreshTable:(refreshTable)refresh;

-(void)tableViewWithRefreshControl:(UIRefreshControl*)refreshControl refreshControlColor:(UIColor*)color refreshTable:(refreshTable)refresh;

-(void)tableViewWithRefreshControl:(UIRefreshControl*)refreshControl refreshControlColor:(UIColor*)color tableView:(UITableView*)tableView refreshTable:(refreshTable)refresh;

#pragma mark - noItems
-(BOOL)noItems;

-(BOOL)loadMore;

#pragma mark - add new item
-(void)addObjectWithoutUniqueProparty:(NSString*)propartyName Object:(id)object Override:(BOOL)override;

-(void)addArrayWithoutUniqueProparty:(NSString*)propartyName Array:(NSArray*)array Override:(BOOL)override;
@end
