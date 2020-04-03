#MICAPS 14类数据，空气污染气象条件等值线图
#把标号061-066替换成IAQI=0、50、100、150、200、300，六个等级 
#by R
#Author： Yang Nan
#2020-03-31
#待增加的开发功能：-------------
#（1）定时搜索转化处理
#（2）模块化
#（3）自动判断.024、.048、0.72并处理存储出对应文件名

#(1)读入空污文件并进行等值线替换--------------
getwd()
setwd("E:/XXXX/")

#read  data info
data_old = readLines("kw20032508.024")

data_new<-data_old

#把061-066替换成0、50、100、150、200、300

old_signal_name<-c("061","062","063","064","065","066")
new_signal_name<-c("000","050","100","150","200","300")

old_signal_sites<-c(" 061"," 062"," 063"," 064"," 065"," 066")
new_signal_sites<-c(" 000"," 050"," 100"," 150"," 200"," 300")

for (i in 1:6) {

  
posi_signal_old<-grep(old_signal_name[i],data_old)

posi_signal_old

char_signal_old<-data_old[posi_signal_old]
        
char_signal_old

nchar(char_signal_old)

#把圈等值线换掉
char_signal_old_CONTOURS<-char_signal_old[nchar(char_signal_old)<6]

char_signal_old_CONTOURS

length(char_signal_old_CONTOURS)

if (length(char_signal_old_CONTOURS)>0){
  #对等值线的标号进行替换
  char_signal_new_CONTOURS<-gsub(old_signal_name[i],new_signal_name[i],char_signal_old_CONTOURS)
  char_signal_new_CONTOURS
  
  for (n in 1:length(char_signal_new_CONTOURS)) {
    data_new[data_new==char_signal_old_CONTOURS[n]]<-char_signal_new_CONTOURS[n]
  }
}

#把站点换掉
char_signal_old_sites<-char_signal_old[nchar(char_signal_old)<10]

char_signal_old_sites

length(char_signal_old_sites)

if (length(char_signal_old_sites)>0){
  #对等值线的标号进行替换
  char_signal_new_sites<-gsub(old_signal_sites[i],new_signal_sites[i],char_signal_old_sites)
  char_signal_new_sites
  
  for (n in 1:length(char_signal_new_sites)) {
    data_new[data_new==char_signal_old_sites[n]]<-char_signal_new_sites[n]
  }
}




posi_signal_new<-grep(new_signal_name[i],data_new)

posi_signal_new

char_signal_new<-data_new[posi_signal_new]

#char_signal_new

char_signal_new<-char_signal_new[nchar(char_signal_new)<6]

char_signal_new

}


#（2）将结果存出---------------
#没有行信息，没有列信息，没有双引号，
#和MICAPS 14类数据初始文件一样。
write.table(data_new,"kw20032508-R改.024",col.names =FALSE,row.names =FALSE,quote=F)

