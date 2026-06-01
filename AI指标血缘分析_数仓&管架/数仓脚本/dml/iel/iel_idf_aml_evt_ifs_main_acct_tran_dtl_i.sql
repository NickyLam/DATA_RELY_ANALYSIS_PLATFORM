: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_evt_ifs_main_acct_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_ifs_main_acct_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,tran_flow_id
,acct_id
,dep_sub_acct_id
,cust_id
,ext_prod_id
,tran_dt
,tran_tm
,tran_type_cd
,tran_chn_cd
,tran_status_cd
,tran_org_id
,call_sys_id
,ext_flow_id
from ${idl_schema}.aml_evt_ifs_main_acct_tran_dtl
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_ifs_main_acct_tran_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes