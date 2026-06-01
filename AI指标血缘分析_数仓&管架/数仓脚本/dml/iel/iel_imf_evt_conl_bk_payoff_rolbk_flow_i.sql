: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_conl_bk_payoff_rolbk_flow_i
CreateDate: 20250211
FileName:   ${iel_data_path}/evt_conl_bk_payoff_rolbk_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_tm
,replace(replace(t1.tran_rest_cd,chr(13),''),chr(10),'') as tran_rest_cd
,midgrod_dt
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.tran_inside_acct_acct_num,chr(13),''),chr(10),'') as tran_inside_acct_acct_num
,replace(replace(t1.tran_inside_acct_name,chr(13),''),chr(10),'') as tran_inside_acct_name
,replace(replace(t1.tran_out_acct_id,chr(13),''),chr(10),'') as tran_out_acct_id
,replace(replace(t1.tran_out_acct_name,chr(13),''),chr(10),'') as tran_out_acct_name
,replace(replace(t1.tran_in_acct_id,chr(13),''),chr(10),'') as tran_in_acct_id
,replace(replace(t1.tran_in_acct_name,chr(13),''),chr(10),'') as tran_in_acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,core_dt
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_conl_bk_payoff_rolbk_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_conl_bk_payoff_rolbk_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
