: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cabs_kub_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/kub_user.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
   replace(replace(rtrim(userid),chr(13),''),chr(10),'')  as userid
  ,replace(replace(rtrim(userna),chr(13),''),chr(10),'')  as userna
  ,replace(replace(rtrim(brchno),chr(13),''),chr(10),'')  as brchno 
from idl.cabs_kub_user where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/kub_user.txt" \
        charset=zhs16gbk
        safe=yes
