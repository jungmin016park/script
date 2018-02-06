# finding some word in C, C++ source
function cgrep()
{    find . -name .repo -prune -o -name .git -prune -o -name build -prune -o -type f \
  ( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \) \ 
  -exec grep --color -n "$@" {} +
}

# finding some word in .bb / cmake file
function mbgrep()
{    find . -name .repo -prune -o -name .git -prune -o -name build -prune -o -type f \
  ( -name '*.bb' -o -name '*.bbappend' -o -name 'CMakeLists.txt' \)  \
  -exec grep --color -n "$@" {} +
}
  
  
# move source's root dir
function croot()
{    T=$(gettop)    
    if [ "$T" ]; then        
      \cd $(gettop)
    else
      echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}



