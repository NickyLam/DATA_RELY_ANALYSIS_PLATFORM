: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_chn_termn_equip_basic_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_chn_termn_equip_basic_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.chn_id as chn_id
,t1.termn_id as termn_id
,t1.belong_org_id as belong_org_id
,t1.in_bank_flg as in_bank_flg
,t1.equip_type_cd as equip_type_cd
,t1.equip_type_name as equip_type_name
,t1.equip_model as equip_model
,t1.equip_status_cd as equip_status_cd
,t1.equip_matnce_id as equip_matnce_id
,t1.equip_install_dt as equip_install_dt
,t1.cash_flg as cash_flg
,t1.install_way_cd as install_way_cd
,t1.dist_cd as dist_cd
,t1.equip_ser_num as equip_ser_num
,t1.equip_addr as equip_addr
,t1.termn_status_cd as termn_status_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.equip_id as equip_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_chn_termn_equip_basic_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_chn_termn_equip_basic_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
