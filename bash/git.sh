#!/bin/bash
#http://blog.csdn.net/sinat_20177327/article/details/76062030
#http://kbroman.org/github_tutorial/pages/init.html

operation=$1
folder=$2


#create a new repository on the command line

#echo "# temp" >> README.md
#git init
#git add README.md
#git remote add origin https://github.com/yingzi1982/temp.git
uploadFolder=$1

git add $uploadFolder
git commit -m "add new files in $uploadFolder..."
git pull origin master
git push origin master
if [ $operation == 'push' ]
then
git add $folder
git commit -m "add new files in $folder..."
#git pull origin master
git push origin master
elif [ $operation == 'pull' ]
then
git reset --hard HEAD
git clean -xffd
git pull
fi
