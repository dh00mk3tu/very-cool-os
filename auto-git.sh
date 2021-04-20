time=$(date)
echo $time
n=1
echo "============================Auto Git============================"
echo "|| This script is now monitoring this current directory       ||"
echo "|| Enter the update interval between each push (Eg. 1 = 1 min)||"
echo "================================================================"
echo "-------------------"
read -p "Interval Time: " inter
echo "-------------------"
echo 
echo 
echo 
echo 
echo
while :

do 
    if [ -d .git ]; then
        echo "====================================="
        echo "|| This is the current Repo Status ||"
        echo "====================================="
        git add .
        git status
        echo "-----------------------------------------------------------------------------------------"
        git commit -m "This commit is made by Auto-Git. Commit-$n, $time"
        echo "-----------------------------------------------------------------------------------------"

        git push
        echo "--------------------"
        echo "|| Commit $n Made ||"
        echo "--------------------"
        # echo "-------------------------"
        # echo "|| No Changes to Commit||"
        # echo "-------------------------"
        # git commit -m "This commit is made by Auto-Git. Commit-$n, $time"

        n=$(($n + 1));
    else
        echo "==================================="
        echo "|| Fatal! This is Not a Git Repo ||"
        echo "==================================="

        git rev-parse --git-dir 2> /dev/null;
        exit 1;
    fi;
    d=$(($inter * 60));
    sleep $d;
done