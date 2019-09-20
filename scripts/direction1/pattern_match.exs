table = :ets.new(:words, [])

IO.stream(:stdio, :line)
|> Stream.flat_map(&String.split(&1, [" ", "\n"]))
|> Enum.each(fn word ->
  :ets.update_counter(
    table, word, {2, 1}, {word, 0}
  )
end)

:ets.tab2list(table)
|> Enum.sort(fn {_, a}, {_, b} -> b < a end)
|> Enum.each(fn {word, count} ->
  IO.puts(String.pad_leading(
    Integer.to_string(count), 8) <> " " <> word
  )
end)
