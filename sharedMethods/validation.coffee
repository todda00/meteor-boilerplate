root = exports ? this
root.NonEmptyNumericArray = Match.Where((x) ->
  check x, [Number]
  x.length > 0
)
root.NonEmptyString = Match.Where((x) ->
  check x, String
  x.length > 0
)