: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_agt_intnal_cap_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_agt_intnal_cap_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select agt_id
,lp_id
,acct_id
,acct_name
,acct_status_cd
,curr_cd
,cap_type_cd
,belong_org_id
,etl_dt
,job_cd from idl.icrm_agt_intnal_cap_acct where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_agt_intnal_cap_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes