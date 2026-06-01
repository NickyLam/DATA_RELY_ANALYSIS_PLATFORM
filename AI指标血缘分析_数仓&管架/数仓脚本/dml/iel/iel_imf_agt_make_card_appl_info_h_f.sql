: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_make_card_appl_info_h_f
CreateDate: 20260227
FileName:   ${iel_data_path}/agt_make_card_appl_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,appl_dt
,replace(replace(t1.make_card_doc_batch_no,chr(13),''),chr(10),'') as make_card_doc_batch_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.make_card_appl_type_cd,chr(13),''),chr(10),'') as make_card_appl_type_cd
,make_card_qtty
,replace(replace(t1.make_card_status_cd,chr(13),''),chr(10),'') as make_card_status_cd
,replace(replace(t1.card_prod_id,chr(13),''),chr(10),'') as card_prod_id
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.lucky_card_flg,chr(13),''),chr(10),'') as lucky_card_flg
,replace(replace(t1.make_card_type_cd,chr(13),''),chr(10),'') as make_card_type_cd
,replace(replace(t1.pre_make_card_cty_rg_cd,chr(13),''),chr(10),'') as pre_make_card_cty_rg_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_tm
,replace(replace(t1.card_draw_way_cd,chr(13),''),chr(10),'') as card_draw_way_cd
,replace(replace(t1.choice_num_type_cd,chr(13),''),chr(10),'') as choice_num_type_cd
,replace(replace(t1.recv_flg,chr(13),''),chr(10),'') as recv_flg
,make_card_dt
,replace(replace(t1.card_corp_abbr,chr(13),''),chr(10),'') as card_corp_abbr

from ${iml_schema}.agt_make_card_appl_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_make_card_appl_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
