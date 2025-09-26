```
defmodule ForXDY do
  def sum(x, y) do
    start_r = x
    end_r = x * y
    resolutions = start_r..end_r

    predicates =
      for(resolution <- resolutions) do
        fn outcome_product_line ->
          Enum.reduce(outcome_product_line, fn a, b -> a + b end) == resolution
        end
      end

    result = Probability.calculate([{Die.new(y), x}], predicates)
    resolutions |> Enum.zip(result) |> Enum.map(fn {x, y} -> %{r: x, p: y} end)
  end
end

chart =
  Vl.new(width: 400, height: 400)
  |> Vl.mark(:bar)
  |> Vl.encode_field(:x, "r", type: :quantitative)
  |> Vl.encode_field(:y, "p", type: :quantitative)
  |> KV.render()

KV.push_many(chart, ForXDY.sum(2, 6))

chart =
  Vl.new(width: 400, height: 400)
  |> Vl.mark(:bar)
  |> Vl.encode_field(:x, "r", type: :quantitative)
  |> Vl.encode_field(:y, "p", type: :quantitative)
  |> KV.render()

KV.push_many(chart, ForXDY.sum(3, 6))
```

```
sum2d6 =
  ForXDY.sum(2, 6)
  |> Scale.scale()
  |> Enum.map(fn %{p: p, r: r} -> %{p2d6: p, r2d6: r} end)

sum3d6 =
  ForXDY.sum(3, 6)
  |> Scale.scale()
  |> Enum.map(fn %{p: p, r: r} -> %{p3d6: p, r3d6: r} end)

sum4d6 =
  ForXDY.sum(4, 6)
  |> Scale.scale()
  |> Enum.map(fn %{p: p, r: r} -> %{p4d6: p, r4d6: r} end)

chart =
  Vl.new(width: 400, height: 400)
  |> Vl.layers([
    Vl.new()
    |> Vl.mark(:line, color: "green")
    |> Vl.encode_field(:x, "r2d6", type: :quantitative)
    |> Vl.encode_field(:y, "p2d6", type: :quantitative),
    Vl.new()
    |> Vl.mark(:line, color: "darkblue")
    |> Vl.encode_field(:x, "r3d6", type: :quantitative)
    |> Vl.encode_field(:y, "p3d6", type: :quantitative),
    Vl.new()
    |> Vl.mark(:line, color: "orange")
    |> Vl.encode_field(:x, "r4d6", type: :quantitative)
    |> Vl.encode_field(:y, "p4d6", type: :quantitative)
  ])
  |> KV.render()

KV.push_many(chart, sum2d6 ++ sum3d6 ++ sum4d6)
```

---

```
defmodule ForD6Pool do
  def data_for(count) do
    result =
      Probability.calculate(
        [{Die.new(6), count}],
        [
          fn rolled ->
            Enum.any?(rolled, fn x -> x >= 5 end)
          end,
          fn rolled ->
            Enum.any?(rolled, fn x -> x >= 3 end) && Enum.all?(rolled, fn x -> x < 5 end)
          end,
          fn rolled ->
            Enum.all?(rolled, fn x -> x < 3 end)
          end
        ])
    [:c_success, :b_mixed, :a_failure]
    |> Enum.zip(result)
    |> Enum.map(fn {x, y} -> %{r: x, p: y} end)
  end
end

pool_1 =
  ForD6Pool.data_for(1)
  |> Enum.map(fn %{p: p, r: r} -> %{p_1: p, r_1: r} end)

pool_2 =
  ForD6Pool.data_for(2)
  |> Enum.map(fn %{p: p, r: r} -> %{p_2: p, r_2: r} end)

pool_3 =
  ForD6Pool.data_for(3)
  |> Enum.map(fn %{p: p, r: r} -> %{p_3: p, r_3: r} end)

pool_4 =
  ForD6Pool.data_for(4)
  |> Enum.map(fn %{p: p, r: r} -> %{p_4: p, r_4: r} end)

chart =
  Vl.new(width: 400, height: 400)
  |> Vl.layers([
    Vl.new()
    |> Vl.mark(:line, color: "green")
    |> Vl.encode_field(:x, "r_1", type: :ordinal)
    |> Vl.encode_field(:y, "p_1", type: :quantitative),
    Vl.new()
    |> Vl.mark(:line, color: "pink")
    |> Vl.encode_field(:x, "r_2", type: :ordinal)
    |> Vl.encode_field(:y, "p_2", type: :quantitative),
    Vl.new()
    |> Vl.mark(:line, color: "orange")
    |> Vl.encode_field(:x, "r_3", type: :ordinal)
    |> Vl.encode_field(:y, "p_3", type: :quantitative),
    Vl.new()
    |> Vl.mark(:line, color: "red")
    |> Vl.encode_field(:x, "r_4", type: :ordinal)
    |> Vl.encode_field(:y, "p_4", type: :quantitative)
  ])
  |> KV.render()

KV.push_many(chart, pool_1 ++ pool_2 ++ pool_3 ++ pool_4)
```
