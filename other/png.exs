defmodule Png do
  defp png_header?(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>), do: true
  defp png_header?(_), do: false

  defp match_header!(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>), do: nil
  defp match_header!(_), do: raise("invalid png header")

  defp read_header(device), do: IO.binread(device, 8)

  defp read_chunk(device) do
    with <<length::size(32), type::binary-size(4)>> <- IO.binread(device, 8),
         <<data::binary-size(length), crc::binary-size(4)>> <- IO.binread(device, length + 4) do
      <<length::size(32), type::binary-size(4), data::binary-size(length), crc::binary-size(4)>>
    end
  end

  defp print_chunks(_device, :eof), do: nil

  defp print_chunks(
         device,
         <<length::size(32), type::binary-size(4), data::binary-size(length),
           crc::binary-size(4)>>
       ) do
    IO.puts("length: #{length}")
    IO.puts("type: #{type}")
    IO.puts("data: 0x#{Base.encode16(data)}")
    IO.puts("crc: 0x#{Base.encode16(crc)}")
    IO.puts("")
    print_chunks(device, read_chunk(device))
  end

  defp print_chunks(device), do: print_chunks(device, read_chunk(device))

  def print(path) do
    File.open!(path, fn device ->
      read_header(device) |> match_header!()
      print_chunks(device)
    end)
  end

  def png?(path) do
    File.open!(path, &read_header/1) |> png_header?()
  end
end
