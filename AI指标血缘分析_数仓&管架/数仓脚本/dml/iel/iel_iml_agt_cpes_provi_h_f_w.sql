: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cpes_provi_h_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cpes_provi_h_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.provi_mtbl_id,chr(13),''),chr(10),'') as provi_mtbl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.dtl_id,chr(13),''),chr(10),'') as dtl_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bus_prod_id,chr(13),''),chr(10),'') as bus_prod_id
,t1.interest as interest
,t1.provi_start_dt as provi_start_dt
,t1.provi_end_dt as provi_end_dt
,t1.actl_end_provi_dt as actl_end_provi_dt
,t1.provi_dt as provi_dt
,t1.int_accr_exp_dt as int_accr_exp_dt
,t1.int_accr_days as int_accr_days
,t1.provied_int as provied_int
,t1.surp_int as surp_int
,t1.daily_provi_amt as daily_provi_amt
,replace(replace(t1.provi_bus_type_cd,chr(13),''),chr(10),'') as provi_bus_type_cd
,replace(replace(t1.provi_status_cd,chr(13),''),chr(10),'') as provi_status_cd
,replace(replace(t1.provi_excep_cd,chr(13),''),chr(10),'') as provi_excep_cd
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
from ${iml_schema}.agt_cpes_provi_h t1 
where  (start_dt <= to_date('${batch_date}', 'yyyymmdd') and
       start_dt >= to_date('${batch_date}', 'yyyymmdd') - 6)
    or (end_dt <= to_date('${batch_date}', 'yyyymmdd') and
       end_dt >= to_date('${batch_date}', 'yyyymmdd') - 6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cpes_provi_h_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes