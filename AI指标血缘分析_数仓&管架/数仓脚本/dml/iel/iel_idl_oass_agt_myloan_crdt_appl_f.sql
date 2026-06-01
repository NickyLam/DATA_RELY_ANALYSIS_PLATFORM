: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_myloan_crdt_appl_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_myloan_crdt_appl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.crdt_appl_id as crdt_appl_id
,t1.appl_flow_num as appl_flow_num
,t1.prod_id as prod_id
,t1.appl_dt as appl_dt
,t1.cust_name as cust_name
,t1.cust_id as cust_id
,t1.crdt_lmt as crdt_lmt
,t1.apv_start_tm as apv_start_tm
,t1.apv_end_tm as apv_end_tm
,t1.apv_status_cd as apv_status_cd
,t1.final_jud_advise_sucs_flg as final_jud_advise_sucs_flg
,t1.final_jud_advise_tm as final_jud_advise_tm
,t1.cust_mgr_id as cust_mgr_id
,t1.rgst_org_id as rgst_org_id
,t1.farm_flg as farm_flg
,t1.refuse_rs as refuse_rs
,t1.mobile_no as mobile_no
,t1.crdt_sugst_lmt as crdt_sugst_lmt
,t1.netw_vrfction_status_cd as netw_vrfction_status_cd
,t1.prod_name as prod_name
,t1.apv_rest_cd as apv_rest_cd
,t1.bus_scene_cd as bus_scene_cd
,t1.lmt_status_cd as lmt_status_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.bank_supv_custs_mang_lab as bank_supv_custs_mang_lab
,t1.pbc_custs_mang_lab as pbc_custs_mang_lab
,t1.appl_id as appl_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_myloan_crdt_appl t1
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_myloan_crdt_appl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
