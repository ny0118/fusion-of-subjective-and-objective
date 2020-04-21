#coding: utf-8
#NAN Yang
#2020-04-20
#简单生成AQI_Grid_MICASP4.024  048 072
import meteva.base as meb
import numpy as np
import datetime
import os,sys
import xarray as xr


#显示当前路径
print(os.getcwd())#显示当前路径

# 更改路径，''里面为更改的路径
os.chdir('D:\Pyhton_conda\Fusion-of-subjective-and-objective')  # 更改路径，''里面为更改的路径
print(os.getcwd())  # 显示当前路径

for filename_all in os.listdir(r'D:\Pyhton_conda\Fusion-of-subjective-and-objective'):
    print(filename_all)
filename_all=os.listdir(r'D:\Pyhton_conda\Fusion-of-subjective-and-objective')

print("NAN Yang test start------------")
print(filename_all[0:3])
print(filename_all[0])
print(filename_all[1])
print(filename_all[2])
print('NAN Yang test end-----------------')

#读NC文件
print('---------------------')
filename = filename_all[0]
dataarray = xr.open_dataset(filename)  #通过xarray程序库读取nc文件中的所有内容
print(dataarray)
grd = meb.read_griddata_from_nc(filename)
print(grd)

meb.set_griddata_coords(grd,member_list = ["AQI"],
                        level_list = [0],
                        dtime_list = [24],
                        gtime=['2020040708'])
print(grd)  #通过set_coords可以重置每个坐标维度的信息

#存MICAPS4类文件
save_path = r".\m4_AQI_grid.024"
meb.write_griddata_to_micaps4(grd,save_path)

print('---------------------')
filename = filename_all[1]
dataarray = xr.open_dataset(filename)  #通过xarray程序库读取nc文件中的所有内容
print(dataarray)
grd = meb.read_griddata_from_nc(filename)
print(grd)

meb.set_griddata_coords(grd,member_list = ["AQI"],
                        level_list = [0],
                        dtime_list = [48],
                        gtime=['2020040708'])
print(grd)  #通过set_coords可以重置每个坐标维度的信息

#存MICAPS4类文件
save_path = r".\m4_AQI_grid.048"
meb.write_griddata_to_micaps4(grd,save_path)

print('---------------------')
filename = filename_all[2]
dataarray = xr.open_dataset(filename)  #通过xarray程序库读取nc文件中的所有内容
print(dataarray)
grd = meb.read_griddata_from_nc(filename)
print(grd)

meb.set_griddata_coords(grd,member_list = ["AQI"],
                        level_list = [0],
                        dtime_list = [72],
                        gtime=['2020040708'])
print(grd)  #通过set_coords可以重置每个坐标维度的信息

#存MICAPS4类文件
save_path = r".\m4_AQI_grid.072"
meb.write_griddata_to_micaps4(grd,save_path)


