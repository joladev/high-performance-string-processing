IO.stream(:stdio, :line)
|> Stream.flat_map(&String.split/1)
|> Enum.reduce(%{}, fn x, acc ->
  Map.update(acc, x, 1, &(&1 + 1))
end)
|> Enum.sort(fn {_, a}, {_, b} -> b < a end)
|> Enum.each(fn {word, count} ->
  IO.puts(String.pad_leading(
    Integer.to_string(count), 8) <> " " <> word
  )
end)
