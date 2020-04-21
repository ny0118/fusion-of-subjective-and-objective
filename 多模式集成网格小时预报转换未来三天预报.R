#多模式集成网格小时预报场NC，
#计算对应24h、48h、72h的AQI、PM10、PM2.5、O3 
#by R
#Author： Yang Nan
#2020-04-13

#未完成部分
#(1)批量标准化处理。PM2.5、PM10、O3、AQI的024、048、072

getwd()
setwd("E:/XX/")

#(1)读取NC文件小时数据信息---------
library(ncdf4) 
nc <- nc_open('AQI_Grid_2020040708.nc') 

print(nc)

PM25 <- ncvar_get( nc = nc, varid = 'PM25')
PM10 <- ncvar_get( nc = nc, varid = 'PM10')
O3 <- ncvar_get( nc = nc, varid = 'O3')
AQI <- ncvar_get( nc = nc, varid = 'AQI')

longitude<-ncvar_get( nc = nc, varid = 'lon')
latidue<-ncvar_get( nc = nc, varid = 'lat')

nc_close( nc )

#分别取出未来24h、48h、72h的小时数据计算------------
#1. PM2.5为对应平均---------------------
PM25_24h<-PM25[,,1:24]
PM25_48h<-PM25[,,25:48]
PM25_72h<-PM25[,,49:72]

PM25_24h_mean<-apply(PM25_24h, 1:2, mean)
PM25_48h_mean<-apply(PM25_48h, 1:2, mean)
PM25_72h_mean<-apply(PM25_72h, 1:2, mean)

max(PM25_24h_mean)
min(PM25_24h_mean)

PM25_24_48_72<-PM25[,,1:3]
PM25_24_48_72[,,1]<-PM25_24h_mean
PM25_24_48_72[,,2]<-PM25_48h_mean
PM25_24_48_72[,,3]<-PM25_72h_mean

#2. PM10为对应平均---------------------
PM10_24h<-PM10[,,1:24]
PM10_48h<-PM10[,,25:48]
PM10_72h<-PM10[,,49:72]

PM10_24h_mean<-apply(PM10_24h, 1:2, mean)
PM10_48h_mean<-apply(PM10_48h, 1:2, mean)
PM10_72h_mean<-apply(PM10_72h, 1:2, mean)

max(PM10_24h_mean)
min(PM10_24h_mean)

PM10_24_48_72<-PM10[,,1:3]
PM10_24_48_72[,,1]<-PM10_24h_mean
PM10_24_48_72[,,2]<-PM10_48h_mean
PM10_24_48_72[,,3]<-PM10_72h_mean

#3. O3为MDA8，即8小时滑动平均最大值---------------------
O3_24h<-O3[,,1:24]
O3_48h<-O3[,,25:48]
O3_72h<-O3[,,49:72]

#x <- c(1:24)
#filter(x,rep(1/8,8))

#定义滑动平均函数
mav <- function(x,n=8){stats::filter(x,rep(1/n,n), sides=1)}

O3_24h_mav<-apply(O3_24h, 1:2, mav)
O3_48h_mav<-apply(O3_48h, 1:2, mav)
O3_72h_mav<-apply(O3_72h, 1:2, mav)

O3_24h_mav[is.na(O3_24h_mav)]= -9999
O3_48h_mav[is.na(O3_48h_mav)]= -9999
O3_72h_mav[is.na(O3_72h_mav)]= -9999

O3_24h_MDA8<-apply(O3_24h_mav, 2:3,max)
O3_48h_MDA8<-apply(O3_48h_mav, 2:3,max)
O3_72h_MDA8<-apply(O3_72h_mav, 2:3,max)

dim(O3_24h_mav)
dim(O3_24h_MDA8)

max(O3_24h_MDA8)
min(O3_24h_MDA8)

max(O3_24h)

O3_24_48_72<-O3[,,1:3]
O3_24_48_72[,,1]<-O3_24h_MDA8
O3_24_48_72[,,2]<-O3_48h_MDA8
O3_24_48_72[,,3]<-O3_72h_MDA8

#4. AQI---------------------
PM25_IAQI<-PM25_24_48_72
PM10_IAQI<-PM10_24_48_72
O3_IAQI<-O3_24_48_72


#IAQI(PM2.5)=0-50-100-150-200-300-400-500---------
#PM2.5=0-35-75-115-150-250-350-500
max(PM25_IAQI)
min(PM25_IAQI)

PM25_IAQI=ifelse(
  #IAQI=0-50
  (PM25_24_48_72>=0 & PM25_24_48_72<35),(50-0)/(35-0)*(PM25_24_48_72-0)+0,
  ifelse(
    #IAQI=50-100
    (PM25_24_48_72>=35 & PM25_24_48_72<75),(100-50)/(75-35)*(PM25_24_48_72-35)+50,
    ifelse(
      #IAQI=100-150
      (PM25_24_48_72>=75 & PM25_24_48_72<115),(150-100)/(115-75)*(PM25_24_48_72-75)+100,
      ifelse(
        #IAQI=150-200
        (PM25_24_48_72>=115 & PM25_24_48_72<150),(200-150)/(150-115)*(PM25_24_48_72-115)+150,
        ifelse(
          #IAQI=200-300
          (PM25_24_48_72>=150 & PM25_24_48_72<250),(300-200)/(250-150)*(PM25_24_48_72-150)+200,
          ifelse(
            #IAQI=300-400
            (PM25_24_48_72>=250 & PM25_24_48_72<350),(400-300)/(350-250)*(PM25_24_48_72-250)+300,
            ifelse(
              #IAQI=400-500
              (PM25_24_48_72>=350 & PM25_24_48_72<500),(500-400)/(500-350)*(PM25_24_48_72-350)+400,
              ifelse(
                #IAQI>500
                (PM25_24_48_72>=500),500,NA
              )
            )
          )
        )
      )
    )
  )
)

#IAQI(O3_MDA8)=0-50 -100-150-200-300---------
#O3_MDA8      =0-100-150-215-265-800
max(O3_IAQI)
min(O3_IAQI)

O3_IAQI=ifelse(
  #IAQI=0-50
  (O3_24_48_72>=0 & O3_24_48_72<100),(50-0)/(100-0)*(O3_24_48_72-0)+0,
  ifelse(
    #IAQI=50-100
    (O3_24_48_72>=100 & O3_24_48_72<150),(100-50)/(150-100)*(O3_24_48_72-100)+50,
    ifelse(
      #IAQI=100-150
      (O3_24_48_72>=150 & O3_24_48_72<215),(150-100)/(215-150)*(O3_24_48_72-150)+100,
      ifelse(
        #IAQI=150-200
        (O3_24_48_72>=215 & O3_24_48_72<265),(200-150)/(265-215)*(O3_24_48_72-215)+150,
        ifelse(
          #IAQI=200-300
          (O3_24_48_72>=265 & O3_24_48_72<800),(300-200)/(800-265)*(O3_24_48_72-265)+200,
          ifelse(
            #IAQI=300
            (O3_24_48_72>=250),300,NA
          )
        )
      )
    )
  )
)


#IAQI(PM10)=0-50-100-150-200-300-400-500---------
#PM10      =0-50-150-250-350-420-500-600
max(PM10_IAQI)
min(PM10_IAQI)

PM10_IAQI=ifelse(
  #IAQI=0-50
  (PM10_24_48_72>=0 & PM10_24_48_72<50),(50-0)/(50-0)*(PM10_24_48_72-0)+0,
  ifelse(
    #IAQI=50-100
    (PM10_24_48_72>=50 & PM10_24_48_72<150),(100-50)/(150-50)*(PM10_24_48_72-50)+50,
    ifelse(
      #IAQI=100-150
      (PM10_24_48_72>=150 & PM10_24_48_72<250),(150-100)/(250-150)*(PM10_24_48_72-150)+100,
      ifelse(
        #IAQI=150-200
        (PM10_24_48_72>=250 & PM10_24_48_72<350),(200-150)/(350-250)*(PM10_24_48_72-250)+150,
        ifelse(
          #IAQI=200-300
          (PM10_24_48_72>=350 & PM10_24_48_72<420),(300-200)/(420-350)*(PM10_24_48_72-350)+200,
          ifelse(
            #IAQI=300-400
            (PM10_24_48_72>=420 & PM10_24_48_72<500),(400-300)/(500-420)*(PM10_24_48_72-420)+300,
            ifelse(
              #IAQI=400-500
              (PM10_24_48_72>=500 & PM10_24_48_72<600),(500-400)/(600-500)*(PM10_24_48_72-500)+400,
              ifelse(
                #IAQI>500
                (PM10_24_48_72>=600),500,NA
              )
            )
          )
        )
      )
    )
  )
)

#求AQI_24_48_72--------------------
AQI_24_48_72<-AQI[,,1:3]
for (i in 1:281) {
  for (j in 1:161) {
    for (k in 1:3) {
      AQI_24_48_72[i,j,k]<-max(PM25_IAQI[i,j,k],PM10_IAQI[i,j,k],O3_IAQI[i,j,k])

    }
  }
}


max(AQI_24_48_72)

max(PM25_IAQI)

max(PM10_IAQI)

max(O3_IAQI)




#(2)将计算完的结果写入新的NC文件-------------------
# Define some straightforward dimensions
lon <- ncdim_def( "lon", "degrees_east", vals=longitude)
lat <- ncdim_def( "lat", "degrees_north", vals=latidue)
time <- ncdim_def( "Time", "24h-48h-72h mean",vals=c(24,48,72))

#Make varables of various dimensionality, for illustration purposes
mv <- -9999 # missing value to use
aq_fcst_PM25<- ncvar_def( name = 'PM25', units = 'ug/m3', dim = list(lon,lat,time), missval = mv, prec = 'float' )
aq_fcst_PM10<- ncvar_def( name = 'PM10', units = 'ug/m3', dim = list(lon,lat,time), missval = mv, prec = 'float' )
aq_fcst_O3<- ncvar_def( name = 'O3', units = 'ug/m3', dim = list(lon,lat,time), missval = mv, prec = 'float' )
aq_fcst_AQI<- ncvar_def( name = 'AQI', units = '1', dim = list(lon,lat,time), missval = mv, prec = 'float' )

#创建文档
ncnew <- nc_create( filename = 'AQI_GRID_2020040708_024-048-072.nc', vars =list(aq_fcst_PM25,aq_fcst_PM10,aq_fcst_O3,aq_fcst_AQI) )

#写入数据
ncvar_put( nc = ncnew, varid = aq_fcst_PM25, vals = PM25_24_48_72 )
ncvar_put( nc = ncnew, varid = aq_fcst_PM10, vals = PM10_24_48_72 )
ncvar_put( nc = ncnew, varid = aq_fcst_O3, vals = O3_24_48_72 )
ncvar_put( nc = ncnew, varid = aq_fcst_AQI, vals = AQI_24_48_72 )



nc_close(ncnew)

