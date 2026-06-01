: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cpes_provi_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cpes_provi_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.provi_mtbl_id,chr(13),''),chr(10),'') as provi_mtbl_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.dtl_id,chr(13),''),chr(10),'') as dtl_id
,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t.bus_prod_id,chr(13),''),chr(10),'') as bus_prod_id
,t.interest as interest
,t.provi_start_dt as provi_start_dt
,t.provi_end_dt as provi_end_dt
,t.actl_end_provi_dt as actl_end_provi_dt
,t.provi_dt as provi_dt
,t.int_accr_exp_dt as int_accr_exp_dt
,t.int_accr_days as int_accr_days
,t.provied_int as provied_int
,t.surp_int as surp_int
,t.daily_provi_amt as daily_provi_amt
,replace(replace(t.provi_bus_type_cd,chr(13),''),chr(10),'') as provi_bus_type_cd
,replace(replace(t.provi_status_cd,chr(13),''),chr(10),'') as provi_status_cd
,replace(replace(t.provi_excep_cd,chr(13),''),chr(10),'') as provi_excep_cd
,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_cpes_provi_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cpes_provi_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes