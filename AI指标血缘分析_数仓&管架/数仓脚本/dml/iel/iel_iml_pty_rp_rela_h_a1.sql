: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_rp_rela_h_a1
CreateDate: 20251106
FileName:   ${iel_data_path}/pty_rp_rela_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rela_party_id,chr(13),''),chr(10),'') as rela_party_id
,replace(replace(t1.sys_in_bus_id,chr(13),''),chr(10),'') as sys_in_bus_id
,replace(replace(t1.rela_party_type_cd,chr(13),''),chr(10),'') as rela_party_type_cd
,replace(replace(t1.this_rela_party_bus_id,chr(13),''),chr(10),'') as this_rela_party_bus_id
,replace(replace(t1.super_rela_party_type_cd,chr(13),''),chr(10),'') as super_rela_party_type_cd
,replace(replace(t1.super_rela_party_id,chr(13),''),chr(10),'') as super_rela_party_id
,replace(replace(t1.super_rela_party_name,chr(13),''),chr(10),'') as super_rela_party_name
,replace(replace(t1.super_cert_type_cd,chr(13),''),chr(10),'') as super_cert_type_cd
,replace(replace(t1.super_cert_no,chr(13),''),chr(10),'') as super_cert_no
,replace(replace(t1.and_super_incid_rela_type_cd,chr(13),''),chr(10),'') as and_super_incid_rela_type_cd
,replace(replace(t1.and_super_eqty_rela_type_cd,chr(13),''),chr(10),'') as and_super_eqty_rela_type_cd
,hold_ratio
,replace(replace(t1.incid_rela_comnt,chr(13),''),chr(10),'') as incid_rela_comnt
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,effect_tm
,invalid_tm
,remit_tm
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.creator_id,chr(13),''),chr(10),'') as creator_id
,create_tm
,replace(replace(t1.create_org_id,chr(13),''),chr(10),'') as create_org_id
,replace(replace(t1.create_dept_id,chr(13),''),chr(10),'') as create_dept_id

from ${iml_schema}.pty_rp_rela_h t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_rp_rela_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
