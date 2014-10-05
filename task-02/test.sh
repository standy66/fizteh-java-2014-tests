#!/bin/bash
rm test.dat;
touch test.dat;
exec_string="java -cp ./classes -Ddb.file=./test.dat $1";
diff_string="diff - temp.file -i -E -Z -b -w -B -y";
echo -e "testing: put русский_текст поддерживается (passed as stdin)"
echo "put русский_текст поддерживается" | exec $exec_string > /dev/null;
echo -e '$found\nподдерживается' > temp.file;
echo -e "testing: get русский_текст (passed as stdin)"
echo "get русский_текст; exit;" | exec $exec_string | exec $diff_string;
if [ $? -ne 0 ]; then
	echo -e "Test fail\n";
else
	echo -e "Test OK\n";
fi

echo -e 'new\nnew' > temp.file;
echo -e "testing: put a b; put c d; exit (passed as arguments)"
exec $exec_string "put a b;" "     put" c d | exec $diff_string;
if [ $? -ne 0 ]; then
	echo -e "Test fail\n";
else
	echo -e "Test OK\n";
fi

echo -e "testing: get a; get c; exit (passed as arguments)"
echo -e 'found\nb\nfound\nd' > temp.file;
exec $exec_string "get a;get c" | exec $diff_string;
if [ $? -ne 0 ]; then
	echo -e "Test fail\n";
else
	echo -e "Test OK\n";
fi

echo -e "testing: put; (passed as arguments)"
exec $exec_string "put;" &2> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "Test fail\n";
else
	echo -e "Test OK\n";
fi

rm temp.file
rm test.dat
