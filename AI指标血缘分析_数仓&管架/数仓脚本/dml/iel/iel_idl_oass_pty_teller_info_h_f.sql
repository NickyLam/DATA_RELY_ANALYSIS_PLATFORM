: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_teller_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_teller_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.teller_id as teller_id
,t1.teller_name as teller_name
,t1.org_id as org_id
,t1.teller_status_cd as teller_status_cd
,t1.teller_type_cd as teller_type_cd
,t1.emply_id as emply_id
,t1.cust_mgr_id as cust_mgr_id
,t1.cust_mgr_flg as cust_mgr_flg
,t1.cust_mgr_lev_cd as cust_mgr_lev_cd
,t1.teller_lev_cd as teller_lev_cd
,t1.teller_director_id as teller_director_id
,t1.high_teller_flg as high_teller_flg
,t1.teller_create_dt as teller_create_dt
,t1.logon_dt as logon_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.teller_subclass_cd as teller_subclass_cd
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_teller_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_teller_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
