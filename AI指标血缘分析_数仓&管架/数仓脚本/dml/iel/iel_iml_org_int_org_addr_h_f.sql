: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_org_int_org_addr_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/org_int_org_addr_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(org_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(tel_num,chr(13),''),chr(10),'')
,replace(replace(zip_cd,chr(13),''),chr(10),'')
,replace(replace(cty_or_rg_cd,chr(13),''),chr(10),'')
,replace(replace(prov_cd,chr(13),''),chr(10),'')
,replace(replace(city_cd,chr(13),''),chr(10),'')
,replace(replace(county_cd,chr(13),''),chr(10),'')
,replace(replace(dtl_addr,chr(13),''),chr(10),'')
,replace(replace(princ_emply_id,chr(13),''),chr(10),'')
,replace(replace(princ_name,chr(13),''),chr(10),'')
,replace(replace(ddd_area_cd,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.org_int_org_addr_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_int_org_addr_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
