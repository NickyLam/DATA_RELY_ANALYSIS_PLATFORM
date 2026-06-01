: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_tag_term_final_data_f
CreateDate: 20241113
FileName:   ${iel_data_path}/icms_tag_term_final_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tagid,chr(13),''),chr(10),'') as tagid
,replace(replace(t1.taghirearchy,chr(13),''),chr(10),'') as taghirearchy
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.tagtype,chr(13),''),chr(10),'') as tagtype
,replace(replace(t1.reltagflowno,chr(13),''),chr(10),'') as reltagflowno
,replace(replace(t1.tagkey,chr(13),''),chr(10),'') as tagkey
,replace(replace(t1.tagvalue,chr(13),''),chr(10),'') as tagvalue
,replace(replace(t1.oldtagvalue,chr(13),''),chr(10),'') as oldtagvalue
,replace(replace(t1.tagname,chr(13),''),chr(10),'') as tagname
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate

from ${iol_schema}.icms_tag_term_final_data t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tag_term_final_data.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
