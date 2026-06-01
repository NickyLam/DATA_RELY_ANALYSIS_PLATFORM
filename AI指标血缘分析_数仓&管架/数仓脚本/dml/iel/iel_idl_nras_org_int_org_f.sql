: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_nras_org_int_org_f
CreateDate: 20180529
FileName:   ${iel_data_path}/org_int_org.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,org_id
,lp_id
,org_name
,org_abbr
,org_type_cd
,org_found_dt
,org_close_dt
,enty_org_flg
,accti_org_flg
,bus_org_flg
,admin_org_flg
,acct_instit_flg
,vtual_org_flg
,org_lev_cd
,org_status_cd
,org_bus_status_cd
,unify_orgnz_id
,fin_lics_num from idl.nras_org_int_org where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_int_org.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes