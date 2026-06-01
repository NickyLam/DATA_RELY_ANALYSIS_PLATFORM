: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_branch_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_branch_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,brh_no
,brh_name
,brh_class
,bln_up_brh_id
,tele_no
,address
,postno
,other_area_flag
,ip
,status
,effect_date
,expire_date
,brh_type
,brh_attr
,brh_manage_type
,bln_brh_no
,ubank_no
,acct_brh_id
,acct_brh_name
,bop_financ_org_code
,last_upd_oper_id
,last_upd_time
,cert_bind_status
,bln_brh_rep_no
from ${idl_schema}.odss_branch_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_branch_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes