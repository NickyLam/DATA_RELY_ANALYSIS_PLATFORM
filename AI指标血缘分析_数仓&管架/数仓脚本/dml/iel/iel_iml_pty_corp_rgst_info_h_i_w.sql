: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_rgst_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_corp_rgst_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.found_dt as found_dt
,replace(replace(t.rgst_cd,chr(13),''),chr(10),'') as rgst_cd
,replace(replace(t.oper_field_prop_cd,chr(13),''),chr(10),'') as oper_field_prop_cd
,replace(replace(t.oper_range,chr(13),''),chr(10),'') as oper_range
,replace(replace(t.corp_rgst_type_cd,chr(13),''),chr(10),'') as corp_rgst_type_cd
,t.paid_in_capital as paid_in_capital
,replace(replace(t.paid_in_capital_curr_cd,chr(13),''),chr(10),'') as paid_in_capital_curr_cd
,replace(replace(t.invtor_cty_cd,chr(13),''),chr(10),'') as invtor_cty_cd
,t.rgst_cap as rgst_cap
,replace(replace(t.rgst_cap_curr_cd,chr(13),''),chr(10),'') as rgst_cap_curr_cd
,t.asset_tot as asset_tot
,replace(replace(t.leg_oper_situ,chr(13),''),chr(10),'') as leg_oper_situ
,t.oper_field_area as oper_field_area
,replace(replace(t.major_prod_serv_situ,chr(13),''),chr(10),'') as major_prod_serv_situ
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_corp_rgst_info_h t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_rgst_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes