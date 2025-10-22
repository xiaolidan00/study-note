import csv
DATA=[[1,'AAA'],
      [2,'BBB'],
      [3,'CCC']]
print('write csv')

f=open('bookdata.csv','w')
writer=csv.writer(f)
 
writer.writerows(DATA)
f.close()

print('READ DATA')
f=open('bookdata.csv','r')
reader=csv.reader(f)
for row in reader:
    if(len(row)>0):
        print('bookId='+row[0],'name='+row[1])

f.close()