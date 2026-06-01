: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_evt_wld_coll_flow_i
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_evt_wld_coll_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.batch_doc_name as batch_doc_name
,t1.seq_num as seq_num
,t1.coll_flow_num as coll_flow_num
,t1.case_id as case_id
,t1.cust_id as cust_id
,t1.way_cd as way_cd
,t1.coll_act_type_cd as coll_act_type_cd
,t1.coll_dt as coll_dt
,t1.coll_rest_type_cd as coll_rest_type_cd
,t1.promis_repay_amt as promis_repay_amt
,t1.promis_repay_dt as promis_repay_dt
,t1.remark as remark
,t1.org_id as org_id
,t1.create_tm as create_tm
,t1.final_modif_tm as final_modif_tm

from ${idl_schema}.crps_evt_wld_coll_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_evt_wld_coll_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
