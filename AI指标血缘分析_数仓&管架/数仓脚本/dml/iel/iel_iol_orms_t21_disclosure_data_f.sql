: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orms_t21_disclosure_data_f
CreateDate: 20231107
FileName:   ${iel_data_path}/orms_t21_disclosure_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.seq,chr(13),''),chr(10),'') as seq
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.year,chr(13),''),chr(10),'') as year
,replace(replace(t1.datat1,chr(13),''),chr(10),'') as datat1
,replace(replace(t1.datat2,chr(13),''),chr(10),'') as datat2
,replace(replace(t1.datat3,chr(13),''),chr(10),'') as datat3
,replace(replace(t1.datat4,chr(13),''),chr(10),'') as datat4
,replace(replace(t1.datat5,chr(13),''),chr(10),'') as datat5
,replace(replace(t1.datat6,chr(13),''),chr(10),'') as datat6
,replace(replace(t1.datat7,chr(13),''),chr(10),'') as datat7
,replace(replace(t1.datat8,chr(13),''),chr(10),'') as datat8
,replace(replace(t1.datat9,chr(13),''),chr(10),'') as datat9
,replace(replace(t1.datat10,chr(13),''),chr(10),'') as datat10
,replace(replace(t1.average,chr(13),''),chr(10),'') as average
,replace(replace(t1.sumtotal,chr(13),''),chr(10),'') as sumtotal
,replace(replace(t1.versions_id,chr(13),''),chr(10),'') as versions_id

from ${iol_schema}.orms_t21_disclosure_data t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orms_t21_disclosure_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
