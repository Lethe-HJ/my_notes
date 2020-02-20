grep 提取行
`grep [OPTION] REG FILENAME`

cut提取列

cut -f 2 student.txt
提取第2列
cut -f 2,4 student.txt
提取第2到4列
cut -c 2- student.txt
提取第2个字符到文本结尾
cut -c 2-5 student.txt
提取第2个字符到第5个字符
cut -d ":" -f 1,3 student.txt
以:为分隔符提取文件的1到3列

cut对空格符的支持不好

df -h 查询分区情况