: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_elec_addr_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_elec_addr_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
    ,replace(replace(t.elec_addr_type_cd,chr(13),''),chr(10),'') as elec_addr_type_cd
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,t.start_dt as start_dt
    ,replace(replace(t.elec_addr,chr(13),''),chr(10),'') as elec_addr
    ,replace(replace(t.main_elec_addr_flg,chr(13),''),chr(10),'') as main_elec_addr_flg
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.dd_area_cd,chr(13),''),chr(10),'') as dd_area_cd
    ,replace(replace(t.ext_num,chr(13),''),chr(10),'') as ext_num
from ${iml_schema}.pty_party_elec_addr_h t
where t.start_dt <=to_date('${batch_date}','yyyymmdd') and t.end_dt >to_date('${batch_date}','yyyymmdd')
union all
select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.elec_addr_type_cd,chr(13),''),chr(10),'') as elec_addr_type_cd
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,t1.start_dt as start_dt
,replace(replace(t1.elec_addr,chr(13),''),chr(10),'') as elec_addr
,replace(replace(t1.main_elec_addr_flg,chr(13),''),chr(10),'') as main_elec_addr_flg
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.dd_area_cd,chr(13),''),chr(10),'') as dd_area_cd
,replace(replace(t1.ext_num,chr(13),''),chr(10),'') as ext_num
from ${iml_schema}.pty_party_elec_addr_h_ecif1_static_data t1
where 1 = 1 
and not exists (select 1 from ${iml_schema}.pty_party_elec_addr_h b 
                        where t1.party_id=b.party_id 
                          and t1.src_sys_cd=b.src_sys_cd 
                          and t1.elec_addr_type_cd=b.elec_addr_type_cd
                          and b.start_dt<= to_date('${batch_date}','yyyymmdd')
                          and b.end_dt> to_date('${batch_date}','yyyymmdd'))" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_elec_addr_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes