13718  for x in $(git status | grep  "/" | grep -v mod | grep -v bran | grep -v "\.\."); do cd $x; git remote -v |tail -1 | awk '{print $2}'; cd ..; done
13719  for x in $(git status | grep  "/" | grep -v mod | grep -v bran | grep -v "\.\."); do cd $x; git remote -v |tail -1 | awk '{print $2'$x'}'; cd ..; done
13720  for x in $(git status | grep  "/" | grep -v mod | grep -v bran | grep -v "\.\."); do cd $x; git remote -v |tail -1 | awk '{print $2 '$x'}'; cd ..; done
13721  for x in $(git status | grep  "/" | grep -v mod | grep -v bran | grep -v "\.\."); do cd $x; git remote -v |tail -1 | awk '{print $2 "'$x'"}'; cd ..; done
13722  for x in $(git status | grep  "/" | grep -v mod | grep -v bran | grep -v "\.\."); do cd $x; git remote -v |tail -1 | awk '{print $2 "  '$x'"}'; cd ..; done
13723  for x in $(git status | grep  "/" | grep -v mod | grep -v bran | grep -v "\.\."); do cd $x; git remote -v |tail -1 | awk '{print $2 "  forked-plugins/'$x'"}'; cd ..; done
13724  for x in $(git status | grep  "/" | grep -v mod | grep -v bran | grep -v "\.\."); do cd $x; git remote -v |tail -1 | awk '{print $2 "  forked-plugins/'$x'"}'; cd ..; done
13725  cd ..
13726  cat >sss
13727  ls
13728  cat sss
13729  cat sss | while read x; do echo "asd" $x; done
13730  cat sss | while read x; do git submodule add  $x; done
