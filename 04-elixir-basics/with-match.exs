result =
  with {:ok, file} = File.open("/etc/passwd"),
       content = IO.read(file, :all),
       :ok = File.close(file),
       [_, uid, gid] <- Regex.run(~r/^xxx:.*?:(\d+):(\d+)/m, content),
       do: "Group: #{gid}, User: #{uid}"

IO.puts(inspect(result))
