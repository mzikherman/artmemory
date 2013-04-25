_.midTruncate = (string, startLength, endLength = startLength, ellipsis = '...') ->
  return '' unless string
  return string unless string.length > (startLength + endLength + 1)
  "#{string[0..startLength-1]}#{ellipsis}#{string[-endLength..-1]}"
