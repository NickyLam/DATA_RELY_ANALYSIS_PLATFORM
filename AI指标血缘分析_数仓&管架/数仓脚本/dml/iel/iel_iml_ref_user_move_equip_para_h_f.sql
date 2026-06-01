: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_user_move_equip_para_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_user_move_equip_para_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.main_acct_idf_id,chr(13),''),chr(10),'') as main_acct_idf_id
,replace(replace(t1.move_termn_type_cd,chr(13),''),chr(10),'') as move_termn_type_cd
,replace(replace(t1.save_chip_idf_id,chr(13),''),chr(10),'') as save_chip_idf_id
,replace(replace(t1.equip_card_no,chr(13),''),chr(10),'') as equip_card_no
,replace(replace(t1.equip_card_idf_id,chr(13),''),chr(10),'') as equip_card_idf_id
,replace(replace(t1.equip_card_status_cd,chr(13),''),chr(10),'') as equip_card_status_cd
,oper_tm
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.card_holder_name,chr(13),''),chr(10),'') as card_holder_name
,replace(replace(t1.rsrv_mobile_no,chr(13),''),chr(10),'') as rsrv_mobile_no
,replace(replace(t1.init_chn_cd,chr(13),''),chr(10),'') as init_chn_cd
,replace(replace(t1.agt_claus_id,chr(13),''),chr(10),'') as agt_claus_id
,claus_acpt_dt
,replace(replace(t1.vp,chr(13),''),chr(10),'') as vp

from ${iml_schema}.ref_user_move_equip_para_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_user_move_equip_para_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
