: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ptl_raised_amt_i
CreateDate: 20240719
FileName:   ${iel_data_path}/fams_ptl_raised_amt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.portfolio_id,chr(13),''),chr(10),'') as portfolio_id
,replace(replace(t1.cdate,chr(13),''),chr(10),'') as cdate
,raise_amt
,tdy_raise_amt
,replace(replace(t1.vdate,chr(13),''),chr(10),'') as vdate
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_ptl_raised_amt t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ptl_raised_amt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
