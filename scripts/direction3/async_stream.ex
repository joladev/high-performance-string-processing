defmodule StreamWorker do
  @bytes_read_chunk 1024000
  @table_options [:public, {:write_concurrency, true}]

  def start() do
    table = :ets.new(:words_count, @table_options)
    pattern = :binary.compile_pattern([" ", "\n"])

    input_stream = IO.binstream(:stdio, @bytes_read_chunk)
    task_fun = fn data ->
      words = String.split(data, pattern)
      process_words(table, words, nil, nil)
    end
    task_stream = Task.async_stream(input_stream, task_fun)

    reducer = fn {:ok, {prefix, _} = element}, {_, suffix} ->
      case {suffix, prefix} do
        {"", prefix} -> count_word(table, prefix)
        {suffix, ""} -> count_word(table, suffix)
        {suffix, prefix} -> count_word(table, suffix <> prefix)
      end

      {[], element}
    end

    transform_stream = Stream.transform(task_stream, {"", ""}, reducer)

    Stream.run(transform_stream)

    :ets.tab2list(table)
    |> Enum.sort(fn {_, lhs}, {_, rhs} -> lhs > rhs end)
    |> Enum.map(fn {word, count} ->
      [String.pad_leading(
        Integer.to_string(count), 8
      ), " ", word, "\n"]
    end)
    |> IO.binwrite()
  end

  defp process_words(table, [head | rest], nil, suffix) do
    process_words(table, rest, head, suffix)
  end

  defp process_words(table, [suffix], prefix, nil) do
    process_words(table, [], prefix, suffix)
  end

  defp process_words(table, [head | rest], prefix, suffix) do
    count_word(table, head)
    process_words(table, rest, prefix, suffix)
  end

  defp process_words(_, [], prefix, suffix) do
    {prefix, suffix}
  end

  defp count_word(table, word) do
    :ets.update_counter(table, word, {2, 1}, {nil, 0})
  end
end

StreamWorker.start()
