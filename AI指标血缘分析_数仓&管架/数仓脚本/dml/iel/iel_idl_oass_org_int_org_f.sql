: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_org_int_org_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_org_int_org.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.org_name as org_name
,t1.org_abbr as org_abbr
,t1.org_type_cd as org_type_cd
,t1.org_found_dt as org_found_dt
,t1.org_close_dt as org_close_dt
,t1.enty_org_flg as enty_org_flg
,t1.accti_org_flg as accti_org_flg
,t1.bus_org_flg as bus_org_flg
,t1.admin_org_flg as admin_org_flg
,t1.acct_instit_flg as acct_instit_flg
,t1.vtual_org_flg as vtual_org_flg
,t1.org_lev_cd as org_lev_cd
,t1.org_status_cd as org_status_cd
,t1.org_bus_status_cd as org_bus_status_cd
,t1.unify_orgnz_id as unify_orgnz_id
,t1.fin_lics_num as fin_lics_num
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.org_id as org_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_org_int_org t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_org_int_org.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
