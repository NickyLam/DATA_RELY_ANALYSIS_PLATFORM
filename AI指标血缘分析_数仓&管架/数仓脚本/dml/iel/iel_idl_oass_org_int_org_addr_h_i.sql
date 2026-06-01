: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_org_int_org_addr_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_org_int_org_addr_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.tel_num as tel_num
,t1.zip_cd as zip_cd
,t1.cty_or_rg_cd as cty_or_rg_cd
,t1.prov_cd as prov_cd
,t1.city_cd as city_cd
,t1.county_cd as county_cd
,t1.dtl_addr as dtl_addr
,t1.princ_emply_id as princ_emply_id
,t1.princ_name as princ_name
,t1.ddd_area_cd as ddd_area_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.org_id as org_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_org_int_org_addr_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_org_int_org_addr_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
