: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_rgst_info_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_corp_rgst_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,found_dt
,replace(replace(rgst_cd,chr(13),''),chr(10),'')
,replace(replace(oper_field_prop_cd,chr(13),''),chr(10),'')
,replace(replace(oper_range,chr(13),''),chr(10),'')
,replace(replace(corp_rgst_type_cd,chr(13),''),chr(10),'')
,paid_in_capital
,replace(replace(paid_in_capital_curr_cd,chr(13),''),chr(10),'')
,replace(replace(invtor_cty_cd,chr(13),''),chr(10),'')
,rgst_cap
,replace(replace(rgst_cap_curr_cd,chr(13),''),chr(10),'')
,asset_tot
,replace(replace(leg_oper_situ,chr(13),''),chr(10),'')
,oper_field_area
,replace(replace(major_prod_serv_situ,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,replace(replace(work_rg_dist_cd,chr(13),''),chr(10),'')

from ${iml_schema}.pty_corp_rgst_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_rgst_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
