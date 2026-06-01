: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_self_equip_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_self_equip_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.equip_id,chr(13),''),chr(10),'') as equip_id
,replace(replace(t1.equip_ip_addr_id,chr(13),''),chr(10),'') as equip_ip_addr_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.in_bank_flg,chr(13),''),chr(10),'') as in_bank_flg
,replace(replace(t1.self_equip_model,chr(13),''),chr(10),'') as self_equip_model
,replace(replace(t1.self_equip_type_cd,chr(13),''),chr(10),'') as self_equip_type_cd
,replace(replace(t1.equip_type_name,chr(13),''),chr(10),'') as equip_type_name
,replace(replace(t1.equip_type_name_cn_descb,chr(13),''),chr(10),'') as equip_type_name_cn_descb
,replace(replace(t1.equip_status_cd,chr(13),''),chr(10),'') as equip_status_cd
,replace(replace(t1.equip_matnce_id,chr(13),''),chr(10),'') as equip_matnce_id
,t1.equip_install_dt as equip_install_dt
,replace(replace(t1.cash_flg,chr(13),''),chr(10),'') as cash_flg
,replace(replace(t1.install_way_cd,chr(13),''),chr(10),'') as install_way_cd
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.equip_install_addr,chr(13),''),chr(10),'') as equip_install_addr
,replace(replace(t1.equip_kind_name,chr(13),''),chr(10),'') as equip_kind_name
from ${icl_schema}.cmm_self_equip_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_self_equip_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes