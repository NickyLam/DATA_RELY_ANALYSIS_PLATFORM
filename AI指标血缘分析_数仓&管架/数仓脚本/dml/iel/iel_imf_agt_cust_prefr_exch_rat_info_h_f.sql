: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_cust_prefr_exch_rat_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cust_prefr_exch_rat_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.int_rat_apv_form_id,chr(13),''),chr(10),'') as int_rat_apv_form_id
,replace(replace(t1.prefr_exch_rat_type_cd,chr(13),''),chr(10),'') as prefr_exch_rat_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.appl_org_id,chr(13),''),chr(10),'') as appl_org_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,t1.tran_dt as tran_dt
,t1.offset_prefr_val as offset_prefr_val
,t1.prefr_begin_dt as prefr_begin_dt
,t1.prefr_exp_dt as prefr_exp_dt
,t1.prefr_days as prefr_days
,replace(replace(t1.prefr_status_cd,chr(13),''),chr(10),'') as prefr_status_cd
,replace(replace(t1.exch_rat_prefr_way_cd,chr(13),''),chr(10),'') as exch_rat_prefr_way_cd
,t1.single_acct_prefr_val as single_acct_prefr_val
,replace(replace(t1.wrt_guat_type_cd,chr(13),''),chr(10),'') as wrt_guat_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_cust_prefr_exch_rat_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_prefr_exch_rat_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes