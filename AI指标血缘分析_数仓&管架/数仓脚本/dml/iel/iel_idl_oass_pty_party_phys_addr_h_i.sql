: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_phys_addr_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_party_phys_addr_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.src_sys_cd as src_sys_cd
,t1.phys_addr_type_cd as phys_addr_type_cd
,t1.seq_num as seq_num
,t1.cont_addr as cont_addr
,t1.zip_cd as zip_cd
,t1.tel_num as tel_num
,t1.fax_num as fax_num
,t1.cty_rg_cd as cty_rg_cd
,t1.phys_addr as phys_addr
,t1.dist_cd as dist_cd
,t1.addr_status_type_cd as addr_status_type_cd
,t1.fc_flg as fc_flg
,t1.prov_cd as prov_cd
,t1.city_cd as city_cd
,t1.rg_county_cd as rg_county_cd
,t1.street_name as street_name
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_phys_addr_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_phys_addr_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
