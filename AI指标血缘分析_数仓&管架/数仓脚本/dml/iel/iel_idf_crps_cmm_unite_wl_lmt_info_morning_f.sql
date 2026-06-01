: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_cmm_unite_wl_lmt_info_morning_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crps_cmm_unite_wl_lmt_info_morning.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,lmt_cont_id
,lmt_rela_appl_id
,cust_id
,bus_breed_id
,actv_flg
,circl_flg
,low_risk_bus_flg
,cust_type_cd
,curr_cd
,status_cd
,bus_breed_name
,tenor
,begin_dt
,modif_dt
,exp_dt
,belong_org_id
,belong_brch_id
,acct_instit_id
,mgmt_org_id
,crdt_lmt
,occu_crdt_lmt
,surp_crdt_lmt
,crdt_open_amt
,incr_lmt_lmt
from ${idl_schema}.crps_cmm_unite_wl_lmt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_lmt_info_morning.f.${batch_date}.dat" \
        charset=utf8
        safe=yes