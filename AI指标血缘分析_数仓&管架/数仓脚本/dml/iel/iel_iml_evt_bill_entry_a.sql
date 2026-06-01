: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bill_entry_a
CreateDate: 20230602
FileName:   ${iel_data_path}/evt_bill_entry.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
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
,int_accr_exp_dt
,int_accr_days
,interest
,fac_val_amt
,buyer_pay_int_amt
,actl_recv_amt
,actl_amt
,comm_fee
,todos
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.intfc_return_code,chr(13),''),chr(10),'') as intfc_return_code
,replace(replace(t1.intfc_return_type_cd,chr(13),''),chr(10),'') as intfc_return_type_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,entry_tm
,update_tm
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,replace(replace(t1.rgst_cter_ccution_id,chr(13),''),chr(10),'') as rgst_cter_ccution_id
,replace(replace(t1.bank_core_entry_flow_num,chr(13),''),chr(10),'') as bank_core_entry_flow_num
,replace(replace(t1.fin_org_id,chr(13),''),chr(10),'') as fin_org_id
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id

from ${iml_schema}.evt_bill_entry t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_entry.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
