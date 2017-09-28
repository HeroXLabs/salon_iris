defmodule SalonIris do
  @moduledoc """
  Documentation for SalonIris.
  """

  alias __MODULE__.{Customer}

  def html_to_csv(from, to) do
    from
    |> File.read!
    |> parse
    |> to_csv
    |> write_to_file(to)
  end

  def parse(html) do
    html
    |> Floki.find("tr")
    |> Enum.map(&Floki.raw_html/1)
    |> Enum.map(&parse_customer/1)
  end

  def to_csv([%Customer{} | _] = customers) do
    header = "first_name,last_name,phone_number,email"
    content =
      customers
      |> Enum.reduce(header, fn c, acc -> acc <> "\n" <> to_csv(c) end)
    content <> "\n"
  end
  def to_csv(%Customer{} = c) do
    [c.first_name, c.last_name, c.phone_number, c.email]
    |> Enum.join(",")
  end

  def parse_customer(html) do
    html
    |> Floki.find("td")
    |> do_parse_customer
  end

  defp do_parse_customer(row) do
    %Customer{
      id: id(row),
      first_name: first_name(row),
      last_name: last_name(row),
      phone_number: phone_number(row),
      email: email(row)
    }
  end

  defp write_to_file(content, path) do
    File.write!(path, content)
  end

  defp id([{"td", _, [v]}, _, _, _, _, _, _, _, _, _, _, _, _]), do: v
  defp id(_), do: ""

  defp first_name([_, {"td", _, [v]}, _, _, _, _, _, _, _, _, _, _, _]), do: v
  defp first_name(_), do: ""

  defp last_name([_, _, {"td", _, [v]}, _, _, _, _, _, _, _, _, _, _]), do: v
  defp last_name(_), do: ""

  defp phone_number([_, _, _, _, _, _, _, {"td", _, [v]}, _, _, _, _, _]), do: v
  defp phone_number([_, _, _, _, _, _, _, _, {"td", _, [v]}, _, _, _, _]), do: v
  defp phone_number([_, _, _, _, _, _, _, _, _, {"td", _, [v]}, _, _, _]), do: v
  defp phone_number(_), do: ""

  defp email([_, _, _, _, _, _, _, _, _, _, {"td", _, [v]}, _, _]), do: v
  defp email(_), do: ""
end
