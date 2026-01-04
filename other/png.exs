defmodule Png do
  defp header!(device) do
    case IO.binread(device, 8) do
      <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>> -> nil
      _ -> raise("invalid PNG header")
    end
  end

  defmodule Chunk do
    defstruct length: 0, type: "", data: "", crc: ""
  end

  defp chunk(device) do
    with <<length::size(32), type::binary-size(4)>> <- IO.binread(device, 8),
         <<data::binary-size(length), crc::binary-size(4)>> <- IO.binread(device, length + 4) do
      %Chunk{length: length, type: type, data: data, crc: crc}
    end
  end

  defmodule Ihdr do
    defstruct width: 0,
              height: 0,
              bit_depth: 1,
              color_type: 0,
              compression_method: 0,
              filter_method: 0,
              interlace_method: 0
  end

  defp ihdr!(device) do
    case chunk(device) do
      %Chunk{
        length: 13,
        type: "IHDR",
        data: <<
          width::size(32),
          height::size(32),
          bit_depth::size(8),
          color_type::size(8),
          compression_method::size(8),
          filter_method::size(8),
          interlace_method::size(8)
        >>,
        crc: _
      } ->
        %Ihdr{
          width: width,
          height: height,
          bit_depth: bit_depth,
          color_type: color_type,
          compression_method: compression_method,
          filter_method: filter_method,
          interlace_method: interlace_method
        }

      _ ->
        raise "invalid IHDR chunk"
    end
  end

  defp chunks!(device) do
    Stream.unfold(device, fn device ->
      case chunk(device) do
        :eof -> nil
        {:error, reason} -> raise("failed to read chunk: #{reason}")
        chunk -> {chunk, device}
      end
    end)
  end

  def inspect_chunks!(path) do
    File.open!(path, fn device ->
      header!(device)
      ihdr!(device) |> IO.inspect()
      chunks!(device) |> Enum.each(&IO.inspect/1)
    end)
  end
end
