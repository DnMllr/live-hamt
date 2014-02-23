{zip-with, map, maximum, minimum, mean} = require \prelude-ls

zip-and     = zip-with -> &0 .&. &1
zip-xor     = zip-with -> &0 .^. &1
str-to-code = -> map (.charCodeAt 0), it.split ''
str-to-bin  = -> map (.toString 2), str-to-code it
str-and     = -> zip-and (str-to-code &0), str-to-code &1
str-xor     = -> zip-xor (str-to-code &0), str-to-code &1
arr-and-str = -> zip-and &0, str-to-code &1
arr-xor-str = -> zip-xor &0, str-to-code &1



one-pos = ->

  n = 0

  while it > 0

    it = it .>>. 1
    n++

  n



get-index = (mask, lookup) ->

  count    = -1
  location = mask .&. lookup

  until location is 0

    count++ if mask .&. 1 is 1
    location = location .>>. 1
    mask     = mask     .>>. 1

  count



break-into-prefixes = (prefix-bit-size, string) ->

  bit-array   = [];
  prefix-mask = (1 .<<. prefix-bit-size) - 1

  for code in str-to-code string

    prefixes = [];

    while code > 0

      prefixes.unshift prefix-mask .&. code
      code = code .>>. prefix-bit-size

    bit-array = bit-array ++ prefixes

  bit-array



join-prefixes-into-string = (prefix-bit-size, prefix-arr) ->

  char  = 0
  count = 0
  chars = ''

  for prefix, i in prefix-arr by -1

    prefix = prefix .<<. prefix-bit-size * count
    char   = prefix .|. char

    if (96 < char < 123 or 64 < char < 91)

      chars = (String.fromCharCode char) + chars
      char  = 0
      count = 0

    else

      count++

  chars



break-into-masks        = (prefix-bit-size, string) -> break-into-prefixes prefix-bit-size, string .map -> 1 .<<. it
join-masks-into-string  = (prefix-bit-size, masks)  -> masks |> map (-> (one-pos it) - 1) |> join-prefixes-into-string prefix-bit-size, _


trie-from-masks = (prefix-bit-size, masks, value) ->

  pointer    = []
  pointer[0] = 1 .<<. (1 .<<. prefix-bit-size)
  pointer[1] = value

  while masks.length > 0
  
    pointer    = [0, pointer]
    pointer[0] = masks.pop!
  
  pointer



trie-from-str = (prefix-bit-size, key, value) ->

  masks = break-into-masks prefix-bit-size, key
  trie-from-masks prefix-bit-size, masks, value



insert-into-trie-str = (prefix-bit-size, trie, key, value) ->

  masks = break-into-masks prefix-bit-size, key
  insert-into-trie prefix-bit-size, trie, masks, value



retrieve-from-trie  = (prefix-bit-size, trie, key, value) ->

  masks   = break-into-masks prefix-bit-size, key
  pointer = trie

  for mask, i in masks

    index = get-index pointer[0], mask

    unless index is -1

      pointer = pointer[index + 1]
    
    else
    
      return

  mask  = 1 .<<. (1 .<<. prefix-bit-size)
  index = 1 + get-index pointer[0], mask
  pointer[index]


insert-into-trie = (prefix-bit-size, trie, masks, value) ->

  pointer = trie

  for mask, i in masks

    index   = get-index pointer[0], mask

    if index is -1
    
      pointer[0] = pointer[0] .|. mask
      index      = get-index pointer[0], mask
      pointer.splice index + 1, 0, trie-from-masks prefix-bit-size, (masks.slice i + 1), value
      return trie
    
    else
    
      pointer = pointer[index + 1]
  
  mask = (1 .<<. (1 .<<. prefix-bit-size))
  pointer[0] = pointer[0] .|. mask
  trie



test-break-and-join = (prefix-bit-size, string) ->

  original-str = string
  arr          = break-into-prefixes prefix-bit-size, string
  new-str      = join-prefixes-into-string prefix-bit-size, arr
  console.log new-str
  console.log original-str



test-break-and-join-masks = (prefix-bit-size, string) ->

  original-str = string
  arr          = break-into-masks prefix-bit-size, string
  new-str      = join-masks-into-string  prefix-bit-size, arr
  console.log new-str
  console.log original-str



pop-count = ->

  it  |> -> it - ((it .>>. 1) .&. 0x55555555)
      |> -> (it .&. 0x33333333) + ((it .>>. 2) .&. 0x33333333)
      |> -> (it .&. 0x0f0f0f0f) + ((it .>>. 4) .&. 0x0f0f0f0f)
      |> -> (it + (it .>>. 8))
      |> -> (it + (it .>>. 15)) .&. 63



break-lr = (str1, str2) ->

  for char, index in str1

    if char isnt str2[index]

      b1 = str1.substring index
      b2 = str2.substring index
      {l: b1 <? b2, r: b1 >? b2}



performanceTest = (times, pretty, cb, ...args) ->

  # unless perfomance?
  
  #   performance = {}

  #   performance.now = ->
  #     performance.now
  #     or performance.mozNow
  #     or performance.msNow
  #     or performance.oNow
  #     or performance.webkitNow
  #     or -> new Date!getTime!

  if &.length < 3

    throw new Error 'requires three arguments: how many times the function should run, whether it should return a pretty string (true), and the function to test. Optionally you may also pass arugments for the function.'

  if args.length > 0

    start = performance.now!
    laps = [];

    for i from 0 to times

      lap-start = performance.now!
      cb.apply @, args
      laps.push performance.now! - lap-start

    finished = performance.now! - start

    if pretty

      """
        It took #finished milliseconds to run the function #times times.
        The longest run was #{maximum laps}, while the shortest run was #{minimum laps}.
        The average run was #{mean laps}.
        The function was called with these arguments: #{args}
      """

    else

      {
        total : finished
        max   : maximum laps
        min   : minimum laps
        mean  : mean laps
        args  : args
      }

  else

    start = performance.now!
    laps = [];

    for i from 0 to times

      lap-start = performance.now!
      cb!
      laps.push performance.now! - lap-start

    finished = performance.now! - start

    if pretty

      """
        It took #finished milliseconds to run the function #times times.
        The longest run was #{maximum laps}, while the shortest run was #{minimum laps}.
        The average run was #{mean laps}.
      """

    else

      {
        total : finished
        max   : maximum laps
        min   : minimum laps
        mean  : mean laps
        args  : []
      }

randomString = ->
  alphabet = <[ a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ]>
  string   = ''
  while string.length < it
    string += alphabet[ Math.floor Math.random! * alphabet.length ]
  string

class hamt
  (@prefix, key, value) ->
    @trie = trie-from-str @prefix, key, value
  get: (key)        -> retrieve-from-trie @prefix, @trie, key
  set: (key,value) !-> @trie = insert-into-trie-str @prefix, @trie, key, value

  all-values : (trie = @trie) ->
    debugger
    values = []
    index  = get-index trie[0], (1 .<<. (1 .<<. @prefix))
    values.push trie[index + 1] if index > -1
    for slot in trie.slice 1
      values = values ++ @all-values slot
    values

test-retrival-speed = (max-bit-length, key, value) ->

  arr = []

  for x from 1 to max-bit-length
    arr.push new hamt x, key, value

  aa = ->
    it.get key

  arr.map -> performanceTest 1000 false aa, it .mean

insert-x-random-str-into-trie = (times, len, trie) ->

  for x from 0 to times
  
    rand-str = randomString len
    trie.set rand-str, rand-str

  trie