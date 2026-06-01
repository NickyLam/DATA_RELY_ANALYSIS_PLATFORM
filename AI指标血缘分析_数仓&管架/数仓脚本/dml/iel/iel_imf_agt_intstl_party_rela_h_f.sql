: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_intstl_party_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_intstl_party_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rela_id,chr(13),''),chr(10),'') as rela_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.agt_type_cd,chr(13),''),chr(10),'') as agt_type_cd
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name
,replace(replace(t1.role_type_cd,chr(13),''),chr(10),'') as role_type_cd
,replace(replace(t1.party_addr_rela_id,chr(13),''),chr(10),'') as party_addr_rela_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.addr_desc,chr(13),''),chr(10),'') as addr_desc
,replace(replace(t1.addr_ref_descb,chr(13),''),chr(10),'') as addr_ref_descb
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.addr_keyw,chr(13),''),chr(10),'') as addr_keyw
from ${iml_schema}.agt_intstl_party_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_intstl_party_rela_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes