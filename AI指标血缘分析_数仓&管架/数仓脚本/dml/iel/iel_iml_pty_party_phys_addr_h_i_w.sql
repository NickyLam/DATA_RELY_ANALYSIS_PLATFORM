: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_phys_addr_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_phys_addr_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd 
,replace(replace(t1.phys_addr_type_cd,chr(13),''),chr(10),'') as phys_addr_type_cd 
,case when trim(t1.seq_num) is null then '1' else replace(replace(t1.seq_num,chr(13),''),chr(10),'')  end as seq_num 
,t1.start_dt as start_dt 
,replace(replace(t1.cont_addr,chr(13),''),chr(10),'') as cont_addr 
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd 
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num 
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num 
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd 
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr 
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd 
,replace(replace(t1.addr_status_type_cd,chr(13),''),chr(10),'') as addr_status_type_cd 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_party_phys_addr_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_phys_addr_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes