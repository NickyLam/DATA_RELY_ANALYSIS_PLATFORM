: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_dep_vouch_cate_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_dep_vouch_cate_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.vouch_type_descb,chr(13),''),chr(10),'') as vouch_type_descb
,replace(replace(t1.vouch_form_cd,chr(13),''),chr(10),'') as vouch_form_cd
,replace(replace(t1.vouch_bill_idf_cd,chr(13),''),chr(10),'') as vouch_bill_idf_cd
,t1.vouch_id_length as vouch_id_length
,replace(replace(t1.have_prefix_flg,chr(13),''),chr(10),'') as have_prefix_flg
,replace(replace(t1.cash_check_flg,chr(13),''),chr(10),'') as cash_check_flg
,replace(replace(t1.check_flg,chr(13),''),chr(10),'') as check_flg
,replace(replace(t1.have_num_flg,chr(13),''),chr(10),'') as have_num_flg
,replace(replace(t1.hq_insto_flg,chr(13),''),chr(10),'') as hq_insto_flg
,replace(replace(t1.lmt_org_use_flg,chr(13),''),chr(10),'') as lmt_org_use_flg
,replace(replace(t1.allow_cannib_flg,chr(13),''),chr(10),'') as allow_cannib_flg
,replace(replace(t1.sell_permit_flg,chr(13),''),chr(10),'') as sell_permit_flg
,t1.mou_hange_days as mou_hange_days
,t1.loss_reissue_days as loss_reissue_days
,t1.public_agent_mou_hange_days as public_agent_mou_hange_days
,t1.invalid_dt as invalid_dt
,t1.effect_dt as effect_dt
,replace(replace(t1.accrd_seq_use_flg,chr(13),''),chr(10),'') as accrd_seq_use_flg
,replace(replace(t1.dep_cate_cd,chr(13),''),chr(10),'') as dep_cate_cd
,replace(replace(t1.obank_bill_flg,chr(13),''),chr(10),'') as obank_bill_flg
,replace(replace(t1.apprv_flg,chr(13),''),chr(10),'') as apprv_flg
,replace(replace(t1.have_price_doc_fix_denom_flg,chr(13),''),chr(10),'') as have_price_doc_fix_denom_flg
,replace(replace(t1.have_price_doc_fix_denom_group,chr(13),''),chr(10),'') as have_price_doc_fix_denom_group
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_dep_vouch_cate_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_dep_vouch_cate_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes