: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_cpes_provi_dtl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_cpes_provi_dtl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.provi_dtl_id,chr(13),''),chr(10),'') as provi_dtl_id
,replace(replace(t1.provi_mtbl_id,chr(13),''),chr(10),'') as provi_mtbl_id
,replace(replace(t1.provi_entry_id,chr(13),''),chr(10),'') as provi_entry_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,t1.td_provi_int as td_provi_int
,replace(replace(t1.entry_sucs_flg,chr(13),''),chr(10),'') as entry_sucs_flg
,t1.entry_dt as entry_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.bus_prod_id,chr(13),''),chr(10),'') as bus_prod_id
,replace(replace(t1.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id
,replace(replace(t1.provi_post_subj_id,chr(13),''),chr(10),'') as provi_post_subj_id
,replace(replace(t1.sys_track_no,chr(13),''),chr(10),'') as sys_track_no
,replace(replace(t1.provi_type_cd,chr(13),''),chr(10),'') as provi_type_cd
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
from ${iml_schema}.evt_cpes_provi_dtl t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cpes_provi_dtl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes