: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_agt_bcdl_cust_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_agt_bcdl_cust_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,agt_id
,lp_id
,cust_id
,cust_name
,sign_id
,sign_dt
,cust_open_acct_org_id
,sign_org_id
,cert_type_cd
,cert_no
,status_cd from idl.rpt_agt_bcdl_cust_sign_info where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_agt_bcdl_cust_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes