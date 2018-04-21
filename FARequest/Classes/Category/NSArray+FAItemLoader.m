//
//  NSArray+FAItemLoader.m
//  items loader
//
//  Created by Fadi Abuzant on 4/21/18.
//  Copyright © 2018 Fadi Abuzant. All rights reserved.
//

#import "NSArray+FAItemLoader.h"

@implementation NSArray (FAItemLoader)

#pragma mark - pageNumber
NSString const *pageNumberKey = @"FAItemLoader.pageNumberKey";

-(int)pageNumber {
    return [objc_getAssociatedObject(self, &pageNumberKey) intValue];
}

-(void)setPageNumber:(int)value {
    objc_setAssociatedObject(self, &pageNumberKey, [NSNumber numberWithInt:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - hasNext
NSString const *hasNextKey = @"FAItemLoader.hasNextKey";

-(BOOL)hasNext {
    return [objc_getAssociatedObject(self, &hasNextKey) boolValue];
}

-(void)setHasNext:(BOOL)value {
    objc_setAssociatedObject(self, &hasNextKey, [NSNumber numberWithBool:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - isLoading
NSString const *isLoadingKey = @"FAItemLoader.isLoadingKey";

-(BOOL)isLoading {
    return [objc_getAssociatedObject(self, &isLoadingKey) boolValue];
}

-(void)setIsLoading:(BOOL)value {
    objc_setAssociatedObject(self, &isLoadingKey, [NSNumber numberWithBool:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - tableView
NSString const *tableViewKey = @"FAItemLoader.tableViewKey";

-(UITableView*)tableView {
    return objc_getAssociatedObject(self, &tableViewKey);
}

-(void)setTableView:(UITableView*)value {
    objc_setAssociatedObject(self, &tableViewKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - refreshControl
NSString const *refreshControlKey = @"FAItemLoader.refreshControlKey";

-(UIRefreshControl*)refreshControl {
    return objc_getAssociatedObject(self, &refreshControlKey);
}

-(void)setRefreshControl:(UIRefreshControl*)value {
    objc_setAssociatedObject(self, &refreshControlKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - refreshTable
NSString const *refreshTableKey = @"FAItemLoader.refreshTableKey";

-(refreshTable)refresh {
    return objc_getAssociatedObject(self, &refreshTableKey);
}

-(void)setRefresh:(refreshTable)value {
    objc_setAssociatedObject(self, &refreshTableKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Add refreshControl to tableView
-(void)tableViewWithRefreshTable:(refreshTable)refresh{
    if (!self.refreshControl)
        self.refreshControl = [[UIRefreshControl alloc]init];
    [self tableViewWithRefreshControl:self.refreshControl refreshControlColor:[UIColor blackColor] tableView:self.tableView refreshTable:refresh];
}

-(void)tableViewWithRefreshControlColor:(UIColor*)color refreshTable:(refreshTable)refresh{
    if (!self.refreshControl)
        self.refreshControl = [[UIRefreshControl alloc]init];
    [self tableViewWithRefreshControl:self.refreshControl refreshControlColor:color tableView:self.tableView refreshTable:refresh];
}

-(void)tableViewWithRefreshControlColor:(UIColor*)color tableView:(UITableView*)tableView refreshTable:(refreshTable)refresh{
    if (!self.refreshControl)
        self.refreshControl = [[UIRefreshControl alloc]init];
    if (!self.tableView)
        self.tableView = tableView;
    [self tableViewWithRefreshControl:self.refreshControl refreshControlColor:color tableView:tableView refreshTable:refresh];
}

-(void)tableViewWithRefreshControl:(UIRefreshControl*)refreshControl refreshControlColor:(UIColor*)color refreshTable:(refreshTable)refresh{
    [self tableViewWithRefreshControl:refreshControl refreshControlColor:color tableView:self.tableView refreshTable:refresh];
}

-(void)tableViewWithRefreshControl:(UIRefreshControl*)refreshControl refreshControlColor:(UIColor*)color tableView:(UITableView*)tableView refreshTable:(refreshTable)refresh{
    [refreshControl setTintColor:color];
    if (!self.tableView)
        self.tableView = tableView;
    if(tableView)
        [tableView addSubview:refreshControl];
    
    [self setRefresh:refresh];
    [refreshControl addTarget:self action:@selector(startRefreshTable:) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)startRefreshTable:(id)sender  {
    if ([self refresh]) {
        [self refresh]();
    }
}

-(void)beginRefreshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.refreshControl beginRefreshing];
            [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        });
    });
    
}

-(void)reset{
    self.pageNumber = 0;
    self.isLoading = false;
    self.hasNext = true;
    if ([self isKindOfClass:[NSMutableArray class]])
        [((NSMutableArray*)self) removeAllObjects];
    
    if (self.tableView)
        [self.tableView reloadData];
}

#pragma mark - noItems
-(BOOL)noItems {
    return !self.isLoading && !self.hasNext && !self.count;
}

-(BOOL)loadMore {
    return self.hasNext && self.count;
}

#pragma mark - add new item
-(void)addObjectWithoutUniqueProparty:(NSString*)propartyName Object:(id)object Override:(BOOL)override{
    [self addArrayWithoutUniqueProparty:propartyName Array:@[object] Override:override];
}

-(void)addArrayWithoutUniqueProparty:(NSString*)propartyName Array:(NSArray*)array Override:(BOOL)override{
    if ([self isKindOfClass:[NSMutableArray class]]) {
        for (id object in array) {
            @try {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %%@",propartyName] , [object valueForKey:propartyName]];
                NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
                if (filteredArray.count) {
                    //update array item if found
                    if (override)
                        [(NSMutableArray*)self replaceObjectAtIndex:[self indexOfObject:filteredArray.firstObject] withObject:object];
                } else {
                    //add item if not exist
                    [(NSMutableArray*)self addObject:object];
                }
            } @catch (NSException *exception) {
                [(NSMutableArray*)self addObject:object];
            } @finally {
                
            }
        }
    }
}


@end
