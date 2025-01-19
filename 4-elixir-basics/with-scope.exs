content = "Now is the time"

lp =
  with {:ok, file} = File.open("/etc/passwd"),
       content = IO.read(file, :all),
       :ok = File.close(file),
       [_, uid, gid] = Regex.run(~r/^lp:.*?:(\d+):(\d+)/m, content) do
    "Group: #{gid}, User: #{uid}"
  end

IO.puts(lp)
IO.puts(content)

defmodule User do
  def ids(name) do
    with {:ok, file} = File.open("/etc/passwd"),
         content = IO.read(file, :all),
         :ok = File.close(file),
         [_, uid, gid] = Regex.run(~r/^#{name}:.*?:(\d+):(\d+)/m, content) do
      {uid, gid}
    end
  end
end

{lp_uid, lp_gid} = User.ids("lp")
IO.puts(lp_uid)
IO.puts(lp_gid)
