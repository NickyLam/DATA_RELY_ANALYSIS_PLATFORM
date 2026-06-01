: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cabs_maindata_f
CreateDate: 20180529
FileName:   ${iel_data_path}/maindata.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(rtrim(idbank  ),chr(13),''),chr(10),'') as idbank  
,replace(replace(rtrim(bankname),chr(13),''),chr(10),'') as bankname
,replace(replace(rtrim(custid  ),chr(13),''),chr(10),'') as custid  
,replace(replace(rtrim(accno   ),chr(13),''),chr(10),'') as accno   
,replace(replace(rtrim(accson  ),chr(13),''),chr(10),'') as accson  
,replace(replace(rtrim(acctypy ),chr(13),''),chr(10),'') as acctypy 
,replace(replace(rtrim(accname ),chr(13),''),chr(10),'') as accname 
,replace(replace(rtrim(opendate),chr(13),''),chr(10),'') as opendate
,replace(replace(rtrim(cdebflag),chr(13),''),chr(10),'') as cdebflag
,replace(replace(rtrim(currtype),chr(13),''),chr(10),'') as currtype
,replace(replace(rtrim(subnoc  ),chr(13),''),chr(10),'') as subnoc  
,bal                                                     as bal       
,replace(replace(rtrim(stamt   ),chr(13),''),chr(10),'') as stamt   
,replace(replace(rtrim(maxtamt ),chr(13),''),chr(10),'') as maxtamt 
,replace(replace(rtrim(avbal   ),chr(13),''),chr(10),'') as avbal   
,replace(replace(rtrim(accstate),chr(13),''),chr(10),'') as accstate
,replace(replace(rtrim(zip     ),chr(13),''),chr(10),'') as zip     
,replace(replace(rtrim(address ),chr(13),''),chr(10),'') as address 
,replace(replace(rtrim(respon  ),chr(13),''),chr(10),'') as respon  
,replace(replace(rtrim(call    ),chr(13),''),chr(10),'') as call    
,replace(replace(rtrim(phone   ),chr(13),''),chr(10),'') as phone   
from idl.cabs_maindata where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/maindata.txt" \
        charset=zhs16gbk
        safe=yes
