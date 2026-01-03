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
      chunks!(device) |> Enum.each(&IO.inspect/1)
    end)
  end
end
