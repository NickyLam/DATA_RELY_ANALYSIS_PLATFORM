: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_cpes_subj_busicode_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_cpes_subj_busicode_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        to_date('${batch_date}', 'yyyymmdd') as etl_dt
,replace(replace(t1.subj_no,chr(13),''),chr(10),'') as subj_no
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,replace(replace(t1.busi_code,chr(13),''),chr(10),'') as busi_code
,replace(replace(t1.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t1.amount_type,chr(13),''),chr(10),'') as amount_type
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_cpes_subj_busicode t1 
where (start_dt <= to_date('${batch_date}', 'yyyymmdd') and
       start_dt >= to_date('${batch_date}', 'yyyymmdd') - 6)
    or (end_dt <= to_date('${batch_date}', 'yyyymmdd') and
       end_dt >= to_date('${batch_date}', 'yyyymmdd') - 6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_cpes_subj_busicode_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes