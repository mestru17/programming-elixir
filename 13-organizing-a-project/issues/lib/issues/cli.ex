defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @default_count 4
  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{user, project, count}`, or `:help` if help was given.
  """
  def parse_args(argv) do
    argv
    |> OptionParser.parse(switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}) do
    body
  end

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 -> i1["created_at"] >= i2["created_at"] end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  # Exercise: OrganizingAProject-4
  defp _print_table_for_columns(list_of_issues, columns) do
    rows =
      for issue <- list_of_issues do
        for column <- columns, do: issue[column]
      end

    header_widths = Enum.map(columns, &String.length/1)

    widths =
      Enum.reduce(rows, header_widths, fn row, max_widths ->
        row
        |> Enum.map(&to_string/1)
        |> Enum.map(&String.length/1)
        |> Enum.zip(max_widths)
        |> Enum.map(fn {max, next} -> max(max, next) end)
      end)

    columns
    |> Enum.map(&" #{&1}")
    |> Enum.zip(widths)
    |> Enum.map(fn {column, width} -> String.pad_trailing(column, width + 1) end)
    |> Enum.join(" |")
    |> IO.puts()

    widths
    |> Enum.map(&String.duplicate("-", &1 + 2))
    |> Enum.join("+")
    |> IO.puts()

    Enum.each(rows, fn row ->
      row
      |> Enum.map(&to_string/1)
      |> Enum.map(&" #{&1}")
      |> Enum.zip(widths)
      |> Enum.map(fn {cell, width} -> String.pad_trailing(cell, width + 1) end)
      |> Enum.join(" |")
      |> IO.puts()
    end)
  end
end
