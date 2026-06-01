: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cabs_atchus_f
CreateDate: 20180529
FileName:   ${iel_data_path}/atchus.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(rtrim(acctno),chr(13),''),chr(10),'') as acctno 
,replace(replace(rtrim(atchus),chr(13),''),chr(10),'') as atchus
,replace(replace(rtrim(atchnm),chr(13),''),chr(10),'') as atchnm  
from idl.cabs_atchus where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/atchus.txt" \
        charset=zhs16gbk
        safe=yes
