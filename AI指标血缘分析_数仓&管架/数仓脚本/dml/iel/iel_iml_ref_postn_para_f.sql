: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_postn_para_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_postn_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.post_id,chr(13),''),chr(10),'') as post_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.post_name,chr(13),''),chr(10),'') as post_name
,replace(replace(t1.base_post_flg,chr(13),''),chr(10),'') as base_post_flg
,replace(replace(t1.strip_line_id,chr(13),''),chr(10),'') as strip_line_id
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id
,replace(replace(t1.type_cd,chr(13),''),chr(10),'') as type_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_postn_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_postn_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
