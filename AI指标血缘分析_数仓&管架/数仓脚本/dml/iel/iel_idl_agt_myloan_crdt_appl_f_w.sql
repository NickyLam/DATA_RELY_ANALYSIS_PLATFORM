: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_myloan_crdt_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_myloan_crdt_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.appl_id as appl_id
,t.lp_id as lp_id
,t.crdt_appl_id as crdt_appl_id
,t.appl_flow_num as appl_flow_num
,t.prod_id as prod_id
,t.appl_dt as appl_dt
,t.cust_name as cust_name
,t.cust_id as cust_id
,t.crdt_lmt as crdt_lmt
,t.apv_start_tm as apv_start_tm
,t.apv_end_tm as apv_end_tm
,t.apv_status_cd as apv_status_cd
,t.final_jud_advise_sucs_flg as final_jud_advise_sucs_flg
,t.final_jud_advise_tm as final_jud_advise_tm
,t.cust_mgr_id as cust_mgr_id
,t.rgst_org_id as rgst_org_id
,t.farm_flg as farm_flg
,t.refuse_rs as refuse_rs
,t.mobile_no as mobile_no
,t.crdt_sugst_lmt as crdt_sugst_lmt
,t.netw_vrfction_status_cd as netw_vrfction_status_cd
,t.prod_name as prod_name
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_myloan_crdt_appl t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_crdt_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes