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

#pragma mark - scrollView
NSString const *scrollViewKey = @"FAItemLoader.scrollViewKey";

-(UIScrollView*)scrollView {
    return objc_getAssociatedObject(self, &scrollViewKey);
}

-(void)setScrollView:(UIScrollView*)value {
    objc_setAssociatedObject(self, &scrollViewKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - refreshControl
NSString const *refreshControlKey = @"FAItemLoader.refreshControlKey";

-(UIRefreshControl*)refreshControl {
    return objc_getAssociatedObject(self, &refreshControlKey);
}

-(void)setRefreshControl:(UIRefreshControl*)value {
    objc_setAssociatedObject(self, &refreshControlKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - refreshView
NSString const *refreshViewKey = @"FAItemLoader.refreshViewKey";

-(refreshView)refresh {
    return objc_getAssociatedObject(self, &refreshViewKey);
}

-(void)setRefresh:(refreshView)value {
    objc_setAssociatedObject(self, &refreshViewKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Add refreshControl to tableView
-(void)scrollViewWithRefreshView:(refreshView)refresh{
    if (!self.refreshControl)
        self.refreshControl = [[UIRefreshControl alloc]init];
    [self scrollViewWithRefreshControl:self.refreshControl refreshControlColor:[UIColor blackColor] scrollView:self.scrollView refreshView:refresh];
}

-(void)scrollViewWithRefreshControlColor:(UIColor*)color refreshView:(refreshView)refresh{
    if (!self.refreshControl)
        self.refreshControl = [[UIRefreshControl alloc]init];
    [self scrollViewWithRefreshControl:self.refreshControl refreshControlColor:color scrollView:self.scrollView refreshView:refresh];
}

-(void)scrollViewWithRefreshControlColor:(UIColor*)color scrollView:(UIScrollView*)scrollView refreshView:(refreshView)refresh{
    if (!self.refreshControl)
        self.refreshControl = [[UIRefreshControl alloc]init];
    if (!self.scrollView)
        self.scrollView = scrollView;
    [self scrollViewWithRefreshControl:self.refreshControl refreshControlColor:color scrollView:scrollView refreshView:refresh];
}

-(void)scrollViewWithRefreshControl:(UIRefreshControl*)refreshControl refreshControlColor:(UIColor*)color refreshView:(refreshView)refresh{
    [self scrollViewWithRefreshControl:refreshControl refreshControlColor:color scrollView:self.scrollView refreshView:refresh];
}

-(void)scrollViewWithRefreshControl:(UIRefreshControl*)refreshControl refreshControlColor:(UIColor*)color scrollView:(UIScrollView*)scrollView refreshView:(refreshView)refresh{
    [refreshControl setTintColor:color];
    if (!self.scrollView)
        self.scrollView = scrollView;
    if(scrollView){
        [scrollView addSubview:refreshControl];
        [scrollView setAlwaysBounceVertical:YES];
    }
    
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
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y - self.refreshControl.frame.size.height) animated:YES];
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
    
    if (self.scrollView && [self.scrollView isKindOfClass:[UITableView class]])
        [((UITableView*)self.scrollView) reloadData];
    else if (self.scrollView && [self.scrollView isKindOfClass:[UICollectionView class]])
        [((UICollectionView*)self.scrollView) reloadData];
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
