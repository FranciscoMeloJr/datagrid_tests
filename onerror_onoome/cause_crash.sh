echo "Causing a crash"
rm *.class
javac Recur.java

#java -XX:OnError="echo banana" Recur
java -XX:OnError="touch /home/fdemeloj/Downloads/cases/go/banana.txt" Recur &
#java -XX:OnError="touch banana.txt" XX:ErrorFile=/path Recur &

###
sleep 20s
killpid=$(jcmd | grep Recur | awk 'NR==1 {print $1}')
kill -11 $killpid
rm hs*