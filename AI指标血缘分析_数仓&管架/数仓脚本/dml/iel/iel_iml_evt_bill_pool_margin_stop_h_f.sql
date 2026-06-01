: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bill_pool_margin_stop_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_bill_pool_margin_stop_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.stop_pay_dtl_id,chr(13),''),chr(10),'') as stop_pay_dtl_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t1.pymc_status_cd,chr(13),''),chr(10),'') as pymc_status_cd
,stop_pay_amt
,replace(replace(t1.stop_pay_flow_num,chr(13),''),chr(10),'') as stop_pay_flow_num
,replace(replace(t1.solu_pay_flow_num,chr(13),''),chr(10),'') as solu_pay_flow_num
,stop_pay_dt
,solu_pay_dt

from ${iml_schema}.evt_bill_pool_margin_stop_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_pool_margin_stop_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
