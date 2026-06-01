: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_org_int_org_addr_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/org_int_org_addr_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t.cty_or_rg_cd,chr(13),''),chr(10),'') as cty_or_rg_cd
,replace(replace(t.prov_cd,chr(13),''),chr(10),'') as prov_cd
,replace(replace(t.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t.county_cd,chr(13),''),chr(10),'') as county_cd
,replace(replace(t.dtl_addr,chr(13),''),chr(10),'') as dtl_addr
,replace(replace(t.princ_emply_id,chr(13),''),chr(10),'') as princ_emply_id
,replace(replace(t.princ_name,chr(13),''),chr(10),'') as princ_name
,replace(replace(t.ddd_area_cd,chr(13),''),chr(10),'') as ddd_area_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.org_int_org_addr_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_int_org_addr_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes