: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_post_f
CreateDate: 20221021
FileName:   ${iel_data_path}/uuss_uus_post.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(postcode,chr(13),''),chr(10),'')
,replace(replace(organcode,chr(13),''),chr(10),'')
,replace(replace(postname,chr(13),''),chr(10),'')
,replace(replace(isbasepost,chr(13),''),chr(10),'')
,replace(replace(linecode,chr(13),''),chr(10),'')
,replace(replace(serialcode,chr(13),''),chr(10),'')
,replace(replace(type,chr(13),''),chr(10),'')
,replace(replace(enablestate,chr(13),''),chr(10),'')
,replace(replace(placecode,chr(13),''),chr(10),'')
,replace(replace(currdate,chr(13),''),chr(10),'')
,replace(replace(currtime,chr(13),''),chr(10),'')
,replace(replace(updatedate,chr(13),''),chr(10),'')
,replace(replace(updatetime,chr(13),''),chr(10),'')
,replace(replace(createuser,chr(13),''),chr(10),'')
,replace(replace(updateuser,chr(13),''),chr(10),'')

from ${iol_schema}.uuss_uus_post t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_post.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
