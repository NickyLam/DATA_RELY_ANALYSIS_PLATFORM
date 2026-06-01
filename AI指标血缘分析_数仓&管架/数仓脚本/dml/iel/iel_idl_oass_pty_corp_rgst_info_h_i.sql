: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_corp_rgst_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_corp_rgst_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.found_dt as found_dt
,t1.rgst_cd as rgst_cd
,t1.oper_field_prop_cd as oper_field_prop_cd
,t1.oper_range as oper_range
,t1.corp_rgst_type_cd as corp_rgst_type_cd
,t1.paid_in_capital as paid_in_capital
,t1.paid_in_capital_curr_cd as paid_in_capital_curr_cd
,t1.invtor_cty_cd as invtor_cty_cd
,t1.rgst_cap as rgst_cap
,t1.rgst_cap_curr_cd as rgst_cap_curr_cd
,t1.asset_tot as asset_tot
,t1.leg_oper_situ as leg_oper_situ
,t1.oper_field_area as oper_field_area
,t1.major_prod_serv_situ as major_prod_serv_situ
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.work_rg_dist_cd as work_rg_dist_cd
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_corp_rgst_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_corp_rgst_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
