: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_intstl_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_intstl_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_prior_level_cd,chr(13),''),chr(10),'') as acct_prior_level_cd
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,t1.acct_bank_id as acct_bank_id
,replace(replace(t1.acct_bank_name,chr(13),''),chr(10),'') as acct_bank_name
,replace(replace(t1.acct_bank_type_cd,chr(13),''),chr(10),'') as acct_bank_type_cd
,replace(replace(t1.acct_bank_party_id,chr(13),''),chr(10),'') as acct_bank_party_id
,replace(replace(t1.open_org_acct_id,chr(13),''),chr(10),'') as open_org_acct_id
,replace(replace(t1.open_org_acct_name,chr(13),''),chr(10),'') as open_org_acct_name
,replace(replace(t1.open_org_acct_type_cd,chr(13),''),chr(10),'') as open_org_acct_type_cd
,replace(replace(t1.open_acct_org_party_id,chr(13),''),chr(10),'') as open_acct_org_party_id
,replace(replace(t1.pos_acct_flg,chr(13),''),chr(10),'') as pos_acct_flg
,replace(replace(t1.pay_back_flg,chr(13),''),chr(10),'') as pay_back_flg
,t1.del_flg as del_flg
,t1.edit_id as edit_id
,t1.debit_crdt_dir_cd as debit_crdt_dir_cd
,replace(replace(t1.acct_bank_flg,chr(13),''),chr(10),'') as acct_bank_flg
,replace(replace(t1.swift_acct_name,chr(13),''),chr(10),'') as swift_acct_name
,replace(replace(t1.hxb_acct_flg,chr(13),''),chr(10),'') as hxb_acct_flg
,replace(replace(t1.acct_bank_bic_code,chr(13),''),chr(10),'') as acct_bank_bic_code
,replace(replace(t1.inter_bank_acct_id,chr(13),''),chr(10),'') as inter_bank_acct_id
,replace(replace(t1.enty_group_id,chr(13),''),chr(10),'') as enty_group_id
,replace(replace(t1.acct_num_name_comnt,chr(13),''),chr(10),'') as acct_num_name_comnt
,replace(replace(t1.acct_usage_type_cd,chr(13),''),chr(10),'') as acct_usage_type_cd
,replace(replace(t1.subj_cd,chr(13),''),chr(10),'') as subj_cd
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.fori_exch_acct_char_cd,chr(13),''),chr(10),'') as fori_exch_acct_char_cd
,replace(replace(t1.create_dt,chr(13),''),chr(10),'') as create_dt
,replace(replace(t1.update_dt,chr(13),''),chr(10),'') as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_intstl_acct t1 where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_intstl_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes