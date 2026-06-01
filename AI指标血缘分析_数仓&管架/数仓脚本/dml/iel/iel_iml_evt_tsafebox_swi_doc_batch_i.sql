: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_tsafebox_swi_doc_batch_i
CreateDate: 20240330
FileName:   ${iel_data_path}/evt_tsafebox_swi_doc_batch.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,rgst_dt
,replace(replace(t1.doc_name,chr(13),''),chr(10),'') as doc_name
,tot
,sucs_cnt
,fail_cnt
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.rest_descb,chr(13),''),chr(10),'') as rest_descb
,proc_start_tm
,proc_end_tm

from ${iml_schema}.evt_tsafebox_swi_doc_batch t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_tsafebox_swi_doc_batch.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
