: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_sugst_pay_appl_evt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_sugst_pay_appl_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.appl_tran_type_cd,chr(13),''),chr(10),'') as appl_tran_type_cd
,t1.appl_dt as appl_dt
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,t1.fac_val_amt as fac_val_amt
,t1.draw_dt as draw_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.sugst_payer_cate_cd,chr(13),''),chr(10),'') as sugst_payer_cate_cd
,replace(replace(t1.sugst_payer_soci_crdt_cd,chr(13),''),chr(10),'') as sugst_payer_soci_crdt_cd
,replace(replace(t1.sugst_payer_name,chr(13),''),chr(10),'') as sugst_payer_name
,replace(replace(t1.sugst_payer_open_bank_num,chr(13),''),chr(10),'') as sugst_payer_open_bank_num
,replace(replace(t1.sugst_payer_org_cd,chr(13),''),chr(10),'') as sugst_payer_org_cd
,replace(replace(t1.pay_bank_no,chr(13),''),chr(10),'') as pay_bank_no
,replace(replace(t1.pay_bank_reply_cd,chr(13),''),chr(10),'') as pay_bank_reply_cd
,replace(replace(t1.pay_bank_refuse_rs_cd,chr(13),''),chr(10),'') as pay_bank_refuse_rs_cd
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.clear_rest_cd,chr(13),''),chr(10),'') as clear_rest_cd
,replace(replace(t1.cash_org_role_type_cd,chr(13),''),chr(10),'') as cash_org_role_type_cd
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.modif_teller_id,chr(13),''),chr(10),'') as modif_teller_id
,replace(replace(t1.final_modif_tm,chr(13),''),chr(10),'') as final_modif_tm
,t1.final_modif_dt as final_modif_dt
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
from ${iml_schema}.evt_sugst_pay_appl_evt t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_sugst_pay_appl_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes