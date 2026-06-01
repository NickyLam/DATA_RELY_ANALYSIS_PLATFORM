: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bill_redcst_exp_redem_batch_i
CreateDate: 20230602
FileName:   ${iel_data_path}/evt_bill_redcst_exp_redem_batch.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.exp_redem_batch_ser_num,chr(13),''),chr(10),'') as exp_redem_batch_ser_num
,replace(replace(t1.bill_redcst_ser_num,chr(13),''),chr(10),'') as bill_redcst_ser_num
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,bus_dt
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.clear_bus_type_cd,chr(13),''),chr(10),'') as clear_bus_type_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.cap_acct_id,chr(13),''),chr(10),'') as cap_acct_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,actl_stl_amt
,stl_bill_cnt
,stl_int_paybl
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,final_modif_tm
,start_dt
,end_dt

from ${iml_schema}.evt_bill_redcst_exp_redem_batch t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_redcst_exp_redem_batch.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
