/*
 Generic queue.
 */

@import Foundation;

@interface NSMutableArray (QueueAdditions)

- (id)dequeue;
- (void)enqueue:(id)obj;
- (id)peek:(int)index;
- (id)peekHead;
- (id)peekTail;
- (BOOL)empty;

@end