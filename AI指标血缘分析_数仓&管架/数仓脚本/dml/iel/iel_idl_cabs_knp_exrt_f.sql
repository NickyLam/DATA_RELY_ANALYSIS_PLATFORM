: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cabs_knp_exrt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/knp_exrt.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
  replace(replace(rtrim(crcycd),chr(13),''),chr(10),'') as crcycd
 ,replace(replace(rtrim(crcyna),chr(13),''),chr(10),'') as crcyna 
 ,replace(replace(rtrim(crcyen),chr(13),''),chr(10),'') as crcyen 
 ,exunit
 ,replace(replace(rtrim(middpr),chr(13),''),chr(10),'') as middpr 
from idl.cabs_knp_exrt where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/knp_exrt.txt" \
        charset=zhs16gbk
        safe=yes
