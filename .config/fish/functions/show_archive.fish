function show_archive --description "List contents of compressed files"
  for file in $argv
    if test -f $file
      echo -s "Listing: " (set_color --bold blue) $file (set_color normal)
      switch $file
        case *.tar
          tar -tf $file
        case *.tar.bz2 *.tbz2
          bunzip2 -c $file | tar -tf - --
        case *.tar.gz *.tgz
          tar -ztf $file
        case *.zip *.ZIP
          unzip -l $file
        case '*'
          echo "Extension not recognized, cannot list contents of $file"
      end
    else
      echo "$file is not a valid file"
    end
  end
end
