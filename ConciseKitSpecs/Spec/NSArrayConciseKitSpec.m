/* ConciseKit
 * Copyright 2010 Peter Jihoon Kim
 * Licensed under the MIT License.
 */
#import "SpecHelper.h"
#import "ConciseKit.h"

DESCRIBE(NSArrayConciseKit) {
  describe(@"NSArray (ConciseKit)", ^{
    __block NSArray *array;

    beforeEach(^{
      array = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
    });

    describe(@"$arr", ^{
      it(@"creates array", ^{
        assertThat($arr(@"foo", @"bar", @"baz"), equalTo(array));
      });
    });

    describe(@"-$first", ^{
      it(@"returns the first object", ^{
        assertThat([array $first], equalTo(@"foo"));
      });
    });

    describe(@"-$last", ^{
      it(@"returns the first object", ^{
        assertThat([array $last], equalTo(@"baz"));
      });
    });

    describe(@"-$at:", ^{
      it(@"returns the object at given index", ^{
        assertThat([array $at:1], equalTo(@"bar"));
      });
    });

    describe(@"-$each:", ^{
      it(@"runs block for each item, passing the item as an argument", ^{
        __block NSInteger i=0;
        [$arr($integer(1), $integer(2), $integer(3)) $each:^(id obj) {
          i += [obj integerValue];
        }];
        assertThatInteger(i, equalToInteger(6));
      });
    });

    describe(@"-$eachWithIndex:", ^{
      it(@"runs block for each item, passing the item and its index as arguments", ^{
        __block NSInteger i=0;
        [$arr($integer(1), $integer(2), $integer(3)) $eachWithIndex:^(id obj, NSUInteger j) {
          i += [obj integerValue] + j;
        }];
        assertThatInteger(i, equalToInteger(9));
      });
    });

    describe(@"-$eachWithStop:", ^{
      it(@"runs block for each item, passing the item as an argument, until stop is set to YES", ^{
        __block NSInteger i=0;
        [$arr($integer(1), $integer(2), $integer(3)) $eachWithStop:^(id obj, BOOL *stop) {
          i += [obj integerValue];
          if([obj integerValue] == 2) {
            *stop = YES;
          }
        }];
        assertThatInteger(i, equalToInteger(3));
      });
    });

    describe(@"-$eachWithIndexAndStop:", ^{
      it(@"runs block for each item, passing the item and its index as arguments, until stop is set to YES", ^{
        __block NSInteger i=0;
        [$arr($integer(1), $integer(2), $integer(3)) $eachWithIndexAndStop:^(id obj, NSUInteger j, BOOL *stop) {
          i += [obj integerValue] + j;
          if([obj integerValue] == 2) {
            *stop = YES;
          }
        }];
        assertThatInteger(i, equalToInteger(4));
      });
    });

    describe(@"-$map:", ^{
      it(@"runs block for each item, passing the item as an argument, and creates a new array containing the return values of the block", ^{
        array = [$arr($integer(1), $integer(2), $integer(3)) $map:^(id obj) {
          return (id)$integer([obj integerValue] * 2);
        }];
        assertThat(array, equalTo($arr($integer(2), $integer(4), $integer(6))));
      });
    });

    describe(@"-$mapWithIndex:", ^{
      it(@"runs block for each item, passing the item and its index as arguments and creates a new array containing the return values of the block", ^{
        array = [$arr($integer(1), $integer(2), $integer(3)) $mapWithIndex:^(id obj, NSUInteger j) {
          return (id)$integer([obj integerValue] * 2 + j);
        }];
        assertThat(array, equalTo($arr($integer(2), $integer(5), $integer(8))));
      });
    });
  });

  describe(@"NSMutableArray (ConciseKit)", ^{
    __block NSMutableArray *marray;

    beforeEach(^{
      marray = [NSMutableArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
    });

    describe(@"$marr", ^{
      it(@"creates mutable array", ^{
        NSMutableArray *marr = $marr(@"foo", @"bar", @"baz");
        assertThat(marr, equalTo(marray));
        [marr addObject:@"lol"];
        assertThat(marr, equalTo([NSArray arrayWithObjects:@"foo", @"bar", @"baz", @"lol", nil]));
      });
    });

    describe(@"-$push:", ^{
      it(@"adds an object", ^{
        [marray $push:@"obj"];
        assertThat([marray lastObject], equalTo(@"obj"));
      });

      it(@"returns self", ^{
        assertThat([marray $push:@"obj"], equalTo(marray));
      });
    });
  });
}
DESCRIBE_END