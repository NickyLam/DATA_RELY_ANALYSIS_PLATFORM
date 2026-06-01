: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_up_repay_tran_flow_f
CreateDate: 20250804
FileName:   ${iel_data_path}/evt_up_repay_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.repay_flow_num,chr(13),''),chr(10),'') as repay_flow_num
,tran_dt
,replace(replace(t1.fund_corp_id,chr(13),''),chr(10),'') as fund_corp_id
,replace(replace(t1.fund_corp_name,chr(13),''),chr(10),'') as fund_corp_name
,replace(replace(t1.belong_brch_org_id,chr(13),''),chr(10),'') as belong_brch_org_id
,replace(replace(t1.belong_brch_org_name,chr(13),''),chr(10),'') as belong_brch_org_name
,tot_amt
,td_sucs_amt
,td_uno_amt
,surp_lmt
,repayed_amt
,replace(replace(t1.clarify_status_cd,chr(13),''),chr(10),'') as clarify_status_cd

from ${iml_schema}.evt_up_repay_tran_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_up_repay_tran_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
