# Disable file completion by default, so it doesn't suggest files unless we are completing the command.
complete -c try_until_success -f

# Options completions
complete -c try_until_success -s d -l delay -d "Delay between attempts in seconds" -x
complete -c try_until_success -s n -l max-attempts -d "Maximum number of attempts" -x
complete -c try_until_success -s h -l help -d "Show help and exit"

# Delegate remaining positional arguments completion to commands
complete -c try_until_success -xa '(__fish_complete_command)'
