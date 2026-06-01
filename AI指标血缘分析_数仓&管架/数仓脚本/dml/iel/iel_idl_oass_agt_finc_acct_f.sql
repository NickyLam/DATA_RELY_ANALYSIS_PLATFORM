: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_finc_acct_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_finc_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.ta_cd as ta_cd
,t1.finc_acct_id as finc_acct_id
,t1.belong_org_id as belong_org_id
,t1.ta_tran_acct_id as ta_tran_acct_id
,t1.cust_mgr_id as cust_mgr_id
,t1.open_acct_way_cd as open_acct_way_cd
,t1.cust_type_cd as cust_type_cd
,t1.bus_cate_cd as bus_cate_cd
,t1.acct_status_cd as acct_status_cd
,t1.open_dt as open_dt
,t1.sign_acct_id as sign_acct_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.intnal_cust_acct as intnal_cust_acct

from ${idl_schema}.oass_agt_finc_acct t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_finc_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
