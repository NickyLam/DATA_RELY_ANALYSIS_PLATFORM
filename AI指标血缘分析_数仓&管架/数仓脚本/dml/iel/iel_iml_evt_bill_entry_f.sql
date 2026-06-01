: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bill_entry_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bill_entry.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       t1.etl_dt as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.entry_bill_id,chr(13),''),chr(10),'') as entry_bill_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.entry_tran_num,chr(13),''),chr(10),'') as entry_tran_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,t1.int_accr_exp_dt as int_accr_exp_dt
,t1.int_accr_days as int_accr_days
,t1.interest as interest
,t1.fac_val_amt as fac_val_amt
,t1.buyer_pay_int_amt as buyer_pay_int_amt
,t1.actl_recv_amt as actl_recv_amt
,t1.actl_amt as actl_amt
,t1.comm_fee as comm_fee
,t1.todos as todos
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.intfc_return_code,chr(13),''),chr(10),'') as intfc_return_code
,replace(replace(t1.intfc_return_type_cd,chr(13),''),chr(10),'') as intfc_return_type_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,t1.entry_tm as entry_tm
,t1.update_tm as update_tm
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,replace(replace(t1.rgst_cter_ccution_id,chr(13),''),chr(10),'') as rgst_cter_ccution_id
,replace(replace(t1.bank_core_entry_flow_num,chr(13),''),chr(10),'') as bank_core_entry_flow_num
,replace(replace(t1.fin_org_id,chr(13),''),chr(10),'') as fin_org_id
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg 
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
from ${iml_schema}.evt_bill_entry t1 
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_entry.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes