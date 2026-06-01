: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_chn_termn_equip_basic_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/chn_termn_equip_basic_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.equip_id,chr(13),''),chr(10),'') as equip_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.in_bank_flg,chr(13),''),chr(10),'') as in_bank_flg
,replace(replace(t.equip_type_cd,chr(13),''),chr(10),'') as equip_type_cd
,replace(replace(t.equip_type_name,chr(13),''),chr(10),'') as equip_type_name
,replace(replace(t.equip_model,chr(13),''),chr(10),'') as equip_model
,replace(replace(t.equip_status_cd,chr(13),''),chr(10),'') as equip_status_cd
,replace(replace(t.equip_matnce_id,chr(13),''),chr(10),'') as equip_matnce_id
,t.equip_install_dt as equip_install_dt
,replace(replace(t.cash_flg,chr(13),''),chr(10),'') as cash_flg
,replace(replace(t.install_way_cd,chr(13),''),chr(10),'') as install_way_cd
,replace(replace(t.dist_cd,chr(13),''),chr(10),'') as dist_cd
,replace(replace(t.equip_ser_num,chr(13),''),chr(10),'') as equip_ser_num
,replace(replace(t.equip_addr,chr(13),''),chr(10),'') as equip_addr
,replace(replace(t.termn_status_cd,chr(13),''),chr(10),'') as termn_status_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.chn_termn_equip_basic_info_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/chn_termn_equip_basic_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes