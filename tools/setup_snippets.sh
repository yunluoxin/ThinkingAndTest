rm -r ~/Library/Developer/Xcode/UserData/CodeSnippets.backup
echo "complete del"

mv ~/Library/Developer/Xcode/UserData/CodeSnippets ~/Library/Developer/Xcode/UserData/CodeSnippets.backup
echo 'back up done'

current_path=`pwd`
ln -s ${current_path}/CodeSnippets ~/Library/Developer/Xcode/UserData/CodeSnippets
