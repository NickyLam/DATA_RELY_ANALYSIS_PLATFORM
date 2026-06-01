: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_party_id,chr(13),''),chr(10),'') as src_party_id
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.party_type_cd,chr(13),''),chr(10),'') as party_type_cd
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.src_party_type_cd,chr(13),''),chr(10),'') as src_party_type_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.pty_party t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd')  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes