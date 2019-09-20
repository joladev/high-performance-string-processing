table = :ets.new(:words, [{:write_concurrency, true}, :public])
space = :binary.compile_pattern([" ", "\n"])

IO.binstream(:stdio, :line)
|> Flow.from_enumerable()
|> Flow.flat_map(&String.split(&1, space))
|> Flow.each(fn word ->
  :ets.update_counter(table, word, {2, 1}, {word, 0})
end)
|> Flow.run()

:ets.tab2list(table)
|> Enum.sort(fn {_, a}, {_, b} -> b < a end)
|> Enum.map(fn {word, count} ->
  [String.pad_leading(
    Integer.to_string(count), 8
  ), " ", word, "\n"] end)
|> IO.binwrite()
