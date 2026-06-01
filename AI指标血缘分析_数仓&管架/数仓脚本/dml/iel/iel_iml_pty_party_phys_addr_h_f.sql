: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_phys_addr_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_phys_addr_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
    ,replace(replace(t.phys_addr_type_cd,chr(13),''),chr(10),'') as phys_addr_type_cd
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,t.start_dt as start_dt
    ,replace(replace(t.cont_addr,chr(13),''),chr(10),'') as cont_addr
    ,replace(replace(t.zip_cd,chr(13),''),chr(10),'') as zip_cd
    ,replace(replace(t.tel_num,chr(13),''),chr(10),'') as tel_num
    ,replace(replace(t.fax_num,chr(13),''),chr(10),'') as fax_num
    ,replace(replace(t.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
    ,replace(replace(t.phys_addr,chr(13),''),chr(10),'') as phys_addr
    ,replace(replace(t.dist_cd,chr(13),''),chr(10),'') as dist_cd
    ,replace(replace(t.addr_status_type_cd,chr(13),''),chr(10),'') as addr_status_type_cd
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.fc_flg,chr(13),''),chr(10),'') as fc_flg
    ,replace(replace(t.prov_cd,chr(13),''),chr(10),'') as prov_cd
    ,replace(replace(t.city_cd,chr(13),''),chr(10),'') as city_cd
    ,replace(replace(t.rg_county_cd,chr(13),''),chr(10),'') as rg_county_cd
    ,replace(replace(t.street_name,chr(13),''),chr(10),'') as street_name
    ,replace(replace(t.src_table_name,chr(13),''),chr(10),'') as src_table_name
from iml.pty_party_phys_addr_h t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') 
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
    ,replace(replace(t.phys_addr_type_cd,chr(13),''),chr(10),'') as phys_addr_type_cd
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,t.start_dt as start_dt
    ,replace(replace(t.cont_addr,chr(13),''),chr(10),'') as cont_addr
    ,replace(replace(t.zip_cd,chr(13),''),chr(10),'') as zip_cd
    ,replace(replace(t.tel_num,chr(13),''),chr(10),'') as tel_num
    ,replace(replace(t.fax_num,chr(13),''),chr(10),'') as fax_num
    ,replace(replace(t.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
    ,replace(replace(t.phys_addr,chr(13),''),chr(10),'') as phys_addr
    ,replace(replace(t.dist_cd,chr(13),''),chr(10),'') as dist_cd
    ,replace(replace(t.addr_status_type_cd,chr(13),''),chr(10),'') as addr_status_type_cd
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.fc_flg,chr(13),''),chr(10),'') as fc_flg
    ,replace(replace(t.prov_cd,chr(13),''),chr(10),'') as prov_cd
    ,replace(replace(t.city_cd,chr(13),''),chr(10),'') as city_cd
    ,replace(replace(t.rg_county_cd,chr(13),''),chr(10),'') as rg_county_cd
    ,replace(replace(t.street_name,chr(13),''),chr(10),'') as street_name
    ,' ' as src_table_name
from iml.pty_party_phys_addr_h_ecif1_static_data t
  where 1 = 1 
   and not exists (select 1 from iml.pty_party_phys_addr_h b 
                        where t.party_id=b.party_id 
                          and t.src_sys_cd=b.src_sys_cd 
                          and t.phys_addr_type_cd=b.phys_addr_type_cd
                          and b.start_dt<= to_date('${batch_date}','yyyymmdd')
                          and b.end_dt> to_date('${batch_date}','yyyymmdd')) " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_phys_addr_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes