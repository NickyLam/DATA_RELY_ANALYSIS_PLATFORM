: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_rp_naturer_info_h_a1
CreateDate: 20251106
FileName:   ${iel_data_path}/pty_rp_naturer_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rela_party_id,chr(13),''),chr(10),'') as rela_party_id
,replace(replace(t1.rela_party_name,chr(13),''),chr(10),'') as rela_party_name
,replace(replace(t1.rela_party_from_comb,chr(13),''),chr(10),'') as rela_party_from_comb
,replace(replace(t1.rela_party_from_descb_comb,chr(13),''),chr(10),'') as rela_party_from_descb_comb
,replace(replace(t1.sys_in_bus_id,chr(13),''),chr(10),'') as sys_in_bus_id
,replace(replace(t1.east_rela_party_type_cd,chr(13),''),chr(10),'') as east_rela_party_type_cd
,replace(replace(t1.east_rela_party_rela_type_cd,chr(13),''),chr(10),'') as east_rela_party_rela_type_cd
,replace(replace(t1.east_cert_type_cd,chr(13),''),chr(10),'') as east_cert_type_cd
,replace(replace(t1.ybj_rela_party_type_cd,chr(13),''),chr(10),'') as ybj_rela_party_type_cd
,replace(replace(t1.ybj_cert_type_cd,chr(13),''),chr(10),'') as ybj_cert_type_cd
,replace(replace(t1.rrp_non_type_cd,chr(13),''),chr(10),'') as rrp_non_type_cd
,replace(replace(t1.rrp_rela_party_type_cd,chr(13),''),chr(10),'') as rrp_rela_party_type_cd
,replace(replace(t1.dom_overs_idf_cd,chr(13),''),chr(10),'') as dom_overs_idf_cd
,replace(replace(t1.supv_org_cd,chr(13),''),chr(10),'') as supv_org_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.effect_status_cd,chr(13),''),chr(10),'') as effect_status_cd
,effect_tm
,invalid_tm
,replace(replace(t1.creator_id,chr(13),''),chr(10),'') as creator_id
,create_tm
,replace(replace(t1.create_org_id,chr(13),''),chr(10),'') as create_org_id
,replace(replace(t1.create_dept_id,chr(13),''),chr(10),'') as create_dept_id
,replace(replace(t1.ghb_post_id,chr(13),''),chr(10),'') as ghb_post_id
,replace(replace(t1.ghb_post_descb,chr(13),''),chr(10),'') as ghb_post_descb

from ${iml_schema}.pty_rp_naturer_info_h t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_rp_naturer_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
