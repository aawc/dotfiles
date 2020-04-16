function echo_run -d "Echo a command before executing it"
  if not count $argv > /dev/null
    return
  end

  echo "Executing: $argv"
  $argv;
end
