# High Performance String Processing - ElixirConf US 2019

This repo contains the different script versions I described in my talk: https://www.youtube.com/watch?v=Y83p_VsvRFA.

You might also want to take a look at the slides: https://files.jola.dev/talks/elixirconf-2019/.

If you want to use the sample input I used to do all my measurements, you can find it here: https://files.jola.dev/words.txt.

# How to run it

You can run scripts with `mix run`, and most of them with `elixir` as well. I used GNU `time` to measure execution time and memory usage.

If you're on OSX the built in `time` doesn't measure memory. Install it with `brew install gnu-time`.

You can use the provided shell script, `measure`, to measure runs, but you might need to adjust it for your platform. Note that it shows the output by default, which is noisy, but all measurements from the are done with the output to terminal. Redirecting to `/dev/null` is faster, but might skew results.

```sh
./measure scripts/direction1/unicode.exs
```
