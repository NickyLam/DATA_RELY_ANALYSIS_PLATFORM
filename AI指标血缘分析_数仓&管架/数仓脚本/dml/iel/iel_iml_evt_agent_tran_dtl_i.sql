: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_agent_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_agent_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,t1.src_etl_dt as src_etl_dt 
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id 
,replace(replace(t1.batch_type_cd,chr(13),''),chr(10),'') as batch_type_cd 
,t1.agent_bus_idf_id as agent_bus_idf_id 
,t1.inter_bus_dt as inter_bus_dt 
,replace(replace(t1.inter_bus_flow_num,chr(13),''),chr(10),'') as inter_bus_flow_num 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name 
,t1.tran_amt as tran_amt 
,t1.sucs_amt as sucs_amt 
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num 
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd 
,replace(replace(t1.exec_status_cd,chr(13),''),chr(10),'') as exec_status_cd 
,t1.tran_dt as tran_dt 
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num 
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info 
,replace(replace(t1.agent_acct_entry_flg,chr(13),''),chr(10),'') as agent_acct_entry_flg 
,replace(replace(t1.deduct_lowt_bal_flg,chr(13),''),chr(10),'') as deduct_lowt_bal_flg 
,replace(replace(t1.forgn_return_cd,chr(13),''),chr(10),'') as forgn_return_cd 
,t1.init_tran_dt as init_tran_dt 
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num 
,replace(replace(t1.charge_org_id,chr(13),''),chr(10),'') as charge_org_id 
,replace(replace(t1.margin_main_acct_id,chr(13),''),chr(10),'') as margin_main_acct_id 
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id 
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id 
,t1.margin_exp_dt as margin_exp_dt 
,replace(replace(t1.sys_idf,chr(13),''),chr(10),'') as sys_idf 
from ${iml_schema}.evt_agent_tran_dtl t1 
where src_etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_agent_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes