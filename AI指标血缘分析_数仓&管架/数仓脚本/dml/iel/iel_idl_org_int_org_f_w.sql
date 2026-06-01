: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_org_int_org_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/org_int_org_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.org_id as org_id
,t.lp_id as lp_id
,t.org_name as org_name
,t.org_abbr as org_abbr
,t.org_type_cd as org_type_cd
,t.org_found_dt as org_found_dt
,t.org_close_dt as org_close_dt
,t.enty_org_flg as enty_org_flg
,t.accti_org_flg as accti_org_flg
,t.bus_org_flg as bus_org_flg
,t.admin_org_flg as admin_org_flg
,t.acct_instit_flg as acct_instit_flg
,t.vtual_org_flg as vtual_org_flg
,t.org_lev_cd as org_lev_cd
,t.org_status_cd as org_status_cd
,t.org_bus_status_cd as org_bus_status_cd
,t.unify_orgnz_id as unify_orgnz_id
,t.fin_lics_num as fin_lics_num
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
from ${idl_schema}.org_int_org t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_int_org_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes