: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_chn_termn_equip_basic_info_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/chn_termn_equip_basic_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(equip_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(chn_id,chr(13),''),chr(10),'')
,replace(replace(termn_id,chr(13),''),chr(10),'')
,replace(replace(belong_org_id,chr(13),''),chr(10),'')
,replace(replace(in_bank_flg,chr(13),''),chr(10),'')
,replace(replace(equip_type_cd,chr(13),''),chr(10),'')
,replace(replace(equip_type_name,chr(13),''),chr(10),'')
,replace(replace(equip_model,chr(13),''),chr(10),'')
,replace(replace(equip_status_cd,chr(13),''),chr(10),'')
,replace(replace(equip_matnce_id,chr(13),''),chr(10),'')
,equip_install_dt
,replace(replace(cash_flg,chr(13),''),chr(10),'')
,replace(replace(install_way_cd,chr(13),''),chr(10),'')
,replace(replace(dist_cd,chr(13),''),chr(10),'')
,replace(replace(equip_ser_num,chr(13),''),chr(10),'')
,replace(replace(equip_addr,chr(13),''),chr(10),'')
,replace(replace(termn_status_cd,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.chn_termn_equip_basic_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/chn_termn_equip_basic_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
