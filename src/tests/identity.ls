describe 'identity test' -> ``it``

  .. 'should pass.' ->  expect true .toBe true

describe 'performanceTest' -> ``it``

  .. 'should be a function.' -> expect performanceTest .toEqual jasmine.any Function
  

describe 'zip-and' -> ``it``

  .. 'should be a function.'                     -> expect zip-and .toEqual jasmine.any Function
  .. 'should bitwise and two arrays of numbers.' ->
    a = [9 3 4]
    b = [1 2 3]
    expect zip-and a, b .toEqual [1, 2, 0]

  .. 'should average runs in under 3 thousandths of a millisecond for n = 3' ->
    a = performanceTest 100000 false zip-and, [9 3 4], [ 1 2 3 ] .mean
    expect a .toBeLessThan 0.003

  .. 'should have max runtime in under .7 milliseconds for n = 3' ->
    a = performanceTest 100000 false zip-and, [9 3 4], [ 1 2 3 ] .max
    expect a .toBeLessThan 0.7

describe 'zip-xor' -> ``it``

  .. 'should be a function.'                     -> expect zip-xor .toEqual jasmine.any Function
  .. 'should bitwise xor two arrays of numbers.' ->
    a = [9 3 4]
    b = [1 2 3]
    expect zip-xor a, b .toEqual [8 1 7]

describe 'str-to-code' -> ``it``

  .. 'should be a function.'                                            -> expect str-to-code .toEqual jasmine.any Function
  .. 'should return an array when passed a string.'                     -> expect str-to-code 'a' .toEqual jasmine.any Array
  .. 'should return an array of numbers.'                               -> str-to-code 'abcdef' .map -> expect it .toEqual jasmine.any Number
  .. 'should return an array of numbers of length equal to the string.' -> expect (str-to-code 'abcdef' .length) .toBe 6

  .. 'should convert a string to an array of character codes.' ->
    a = 'hello'
    expect str-to-code a .toEqual [104, 101, 108, 108, 111]
    b = 'FnewioUFD73;??'
    expect str-to-code b .toEqual [70, 110, 101, 119, 105, 111, 85, 70, 68, 55, 51, 59, 63, 63]

describe 'str-to-bin' -> ``it``
  
  .. 'should be a function.'                                -> expect str-to-bin .toEqual jasmine.any Function
  .. 'should return an array.'                              -> expect str-to-bin 'a' .toEqual jasmine.any Array
  .. 'the array should be of strings.'                      -> str-to-bin 'hello'    .map -> expect it .toEqual jasmine.any String
  .. 'should return strings that can be parsed as numbers.' -> str-to-bin 'hElL8ad;' .map -> expect parseInt it .toEqual jasmine.any Number

  .. 'should return strings that are binary representation of character codes.' -> 

    expect (str-to-bin 'hello' .map -> parseInt it, 2) .toEqual [104, 101, 108, 108, 111]
    expect (str-to-bin 'FnewioUFD73;??' .map -> parseInt it, 2) .toEqual [70, 110, 101, 119, 105, 111, 85, 70, 68, 55, 51, 59, 63, 63]

describe 'str-and' -> ``it``

  .. 'should be a function.'    -> expect str-and .toEqual jasmine.any Function

  .. 'should take two strings.' ->

    ok    = -> str-and \hello \goodbye
    wrong = -> str-and 3460 {}
    expect ok .not.toThrow!
    expect wrong .toThrow!

  .. 'should return an array.'             -> expect str-and \hello \goodbye .toEqual jasmine.any Array
  .. 'should return an array of integers.' -> str-and \hello \goodbye .map -> expect it .toEqual Math.floor it

  .. 'should return integers that are the result of bitwise "anding" the string\'s character codes.' ->

    a = str-to-code \hello
    b = str-to-code \goodbye
    c = str-and  \hello \goodbye
    c.forEach (x, i) -> expect x .toEqual a[i] .&. b[i]

describe 'str-xor' -> ``it``

  .. 'should be a function.' -> expect str-xor .toEqual jasmine.any Function

  .. 'should take two strings.' ->

    ok    = -> str-xor \hello \goodbye
    wrong = -> str-xor 3460 {}
    expect ok .not.toThrow!
    expect wrong .toThrow!

  .. 'should return an array'              -> expect str-xor \hello \goodbye .toEqual jasmine.any Array
  .. 'should return an array of integers.' -> str-xor \hello \goodbye .map -> expect it .toEqual Math.floor it

  .. 'should return integers that are the result of bitwise xor the string\'s character codes.' ->

    a = str-to-code \hello
    b = str-to-code \goodbye
    c = str-xor  \hello \goodbye
    c.forEach (x, i) -> expect x .toEqual a[i] .^. b[i]

describe 'one-pos' -> ``it``

  randomInt = 0

  beforeEach ->
    randomInt = 1 + Math.floor Math.random! * 10

  .. 'should be a function.'                                          -> expect one-pos .toEqual jasmine.any Function
  .. 'should return a number.'                                        -> expect one-pos randomInt .toEqual jasmine.any Number
  .. 'should return an integer.'                                      -> expect one-pos randomInt .toEqual Math.floor one-pos randomInt
  .. 'should return the length of a number\'s binary representation.' -> expect one-pos randomInt .toEqual (randomInt.toString 2 .length)

describe 'get-index' -> ``it``

  .. 'should be a function.'    -> expect get-index .toEqual jasmine.any Function
  .. 'should return a number.'  -> expect get-index 6 3 .toEqual jasmine.any Number