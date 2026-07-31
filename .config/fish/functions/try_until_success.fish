function try_until_success -d "Repeat a command until it succeeds"
  # Parse arguments
  argparse -n try_until_success 'd/delay=' 'n/max-attempts=' 'h/help' -- $argv
  or return 1

  # Handle help
  if set -q _flag_help
    echo "Usage: try_until_success [options] <command> [arguments...]"
    echo "Options:"
    echo "  -d, --delay=SECONDS          Delay between attempts in seconds (default: 1)"
    echo "  -n, --max-attempts=NUMBER    Maximum number of attempts (default: 20)"
    echo "  -h, --help                   Show this help message"
    return 0
  end

  # Check if command is provided
  if not count $argv > /dev/null
    echo "Error: No command provided." >&2
    echo "Usage: try_until_success [options] <command> [arguments...]" >&2
    return 1
  end

  # Initialize delay
  set -l delay 1
  if set -q _flag_delay
    set delay $_flag_delay
  end

  # Initialize max attempts
  set -l max_attempts 20
  if set -q _flag_max_attempts
    set max_attempts $_flag_max_attempts
  end

  set -l attempt 1
  while true
    # Run the command
    $argv

    set -l exit_status $status
    if test $exit_status -eq 0
      return 0
    end

    if begin test $max_attempts -gt 0; and test $attempt -ge $max_attempts; end
      echo "Command failed after $attempt attempt(s) with status $exit_status." >&2
      return $exit_status
    end

    echo "Attempt $attempt failed with status $exit_status. Retrying in $delay second(s)..." >&2
    sleep $delay
    set attempt (math $attempt + 1)
  end
end
