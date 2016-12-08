//
//  NCMutableArray.m
//
//  Created by YLCHUN on 2016/9/29.
//  Copyright (c) 2014年 YLCHUN All rights reserved.
//

#import "NCMutableArray.h"

@interface NCMutableArray()<NSLocking>
{
//    NSMutableArray *_array;
    NSRecursiveLock *_safeLock;
}
@end

@implementation NCMutableArray

+ (instancetype)array {
   return [[self alloc]init];
}

+ (instancetype)arrayWithObject:(id)anObject{
    NCMutableArray *arr = [[self alloc]init];
    [arr addObject:anObject];
    return arr;
}

+ (instancetype)arrayWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION{
    va_list argumentList;
    va_start(argumentList, firstObj);
    NSMutableArray *_arr = [NSMutableArray array];
    [_arr addObject:firstObj];
    id obj;
    while ((obj = va_arg(argumentList, id))){
         [_arr addObject:obj];
    }
    va_end(argumentList);
    NCMutableArray *arr = [self arrayWithArray:_arr];
    return arr;
}

+ (instancetype)arrayWithArray:(NSArray*)array{
    NCMutableArray *arr = [[self alloc]init];
    [arr addObjectsFromArray:array];
    return arr;
}

- (instancetype)init {
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        _safeLock = [[NSRecursiveLock alloc] init];
        _array = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}

- (void)dealloc {
    if (_array) {
        _array = nil;
    }
}

- (NSUInteger)count {
    [_safeLock lock];
    NSInteger result = _array.count;
    [_safeLock unlock];
    return result;
}

- (id)objectAtIndex:(NSUInteger)index {
    [_safeLock lock];
   id result = [_array objectAtIndex:index];
    [_safeLock unlock];
    return result;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_safeLock lock];
    [_array insertObject:anObject atIndex:index];
    [_safeLock unlock];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_safeLock lock];
    [_array removeObjectAtIndex:index];
    [_safeLock unlock];
}

- (void)addObject:(id)anObject {
    [_safeLock lock];
    [_array addObject:anObject];
    [_safeLock unlock];
}

- (void)removeLastObject {
    [_safeLock lock];
    [_array removeLastObject];
    [_safeLock unlock];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_safeLock lock];
    [_array replaceObjectAtIndex:index withObject:anObject];
    [_safeLock unlock];
}

#pragma mark Optional

- (void)removeAllObjects {
    [_safeLock lock];
    [_array removeAllObjects];
    [_safeLock unlock];
}

- (NSUInteger)indexOfObject:(id)anObject {
    [_safeLock lock];
    NSInteger result = [_array indexOfObject:anObject];
    [_safeLock unlock];
    return result;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    [_safeLock lock];
    id result = _array[idx];
    [_safeLock unlock];
    return result;
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    [_safeLock lock];
    _array[index] = anObject;
    [_safeLock unlock];
}

- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block {
    [_array enumerateObjectsUsingBlock:block];
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block {
    [_array enumerateObjectsWithOptions:opts usingBlock:block];
}

- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block {
    [_array enumerateObjectsAtIndexes:s options:opts usingBlock:block];
}

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes {
    [_safeLock lock];
    NSArray *arr = [_array objectsAtIndexes:indexes];
    [_safeLock unlock];
    return arr;
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    [_safeLock lock];
    [_array exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    [_safeLock unlock];
}

- (void)removeObject:(id)anObject inRange:(NSRange)range {
    [_safeLock lock];
    [_array removeObject:anObject inRange:range];
    [_safeLock unlock];
}

- (void)removeObject:(id)anObject {
    [_safeLock lock];
    [_array removeObject:anObject];
    [_safeLock unlock];
}

- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    [_safeLock lock];
    [_array removeObjectIdenticalTo:anObject inRange:range];
    [_safeLock unlock];
}

- (void)removeObjectIdenticalTo:(id)anObject {
    [_safeLock lock];
    [_array removeObjectIdenticalTo:anObject];
    [_safeLock unlock];
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
    [_safeLock lock];
    [_array removeObjectsInArray:otherArray];
    [_safeLock unlock];
}

- (void)removeObjectsInRange:(NSRange)range {
    [_safeLock lock];
    [_array removeObjectsInRange:range];
    [_safeLock unlock];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
    [_safeLock lock];
    [_array replaceObjectsInRange:range withObjectsFromArray:otherArray range:range];
    [_safeLock unlock];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray {
    [_safeLock lock];
    [_array replaceObjectsInRange:range withObjectsFromArray:otherArray];
    [_safeLock unlock];
}

- (void)setArray:(NSArray *)otherArray {
    [_safeLock lock];
    [_array setArray:otherArray];
    [_safeLock unlock];
}

- (void)sortUsingFunction:(NSInteger (NS_NOESCAPE *)(id,  id, void * _Nullable))compare context:(nullable void *)context {
    [_safeLock lock];
    [_array sortUsingFunction:compare context:context];
    [_safeLock unlock];
}

- (void)sortUsingSelector:(SEL)comparator {
    [_safeLock lock];
    [_array sortUsingSelector:comparator];
    [_safeLock unlock];
}

- (BOOL)containsObject:(id)anObject {
    [_safeLock lock];
    BOOL result = [_array containsObject:anObject];
    [_safeLock unlock];
    return result;
}


- (void)addObjectsFromArray:(NSArray*)otherArray {
    [_safeLock lock];
    [_array addObjectsFromArray:otherArray];
    [_safeLock unlock];
}

//#pragma mark NSLocking
- (void)lock {
    [_safeLock lock];
}

- (void)unlock {
    [_safeLock unlock];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    NCMutableArray *arr = [NCMutableArray arrayWithArray:[self -> _array copy]];
    return arr;
}

- (instancetype)mutableCopyWithItems:(BOOL)flag {
    NSArray *_arr = [[NSArray alloc] initWithArray:[self -> _array mutableCopy] copyItems:flag];
    NCMutableArray *arr = [NCMutableArray arrayWithArray:_arr];
    return arr;
}

@end
