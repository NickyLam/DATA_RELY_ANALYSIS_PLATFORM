: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_corp_stl_card_rela_info_h_f
CreateDate: 20240829
FileName:   ${iel_data_path}/agt_corp_stl_card_rela_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.acct_num_sub_acct_num,chr(13),''),chr(10),'') as acct_num_sub_acct_num
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.acct_prod_id,chr(13),''),chr(10),'') as acct_prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.card_prod_id,chr(13),''),chr(10),'') as card_prod_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.deflt_acct_num_flg,chr(13),''),chr(10),'') as deflt_acct_num_flg
,replace(replace(t1.main_card_flg,chr(13),''),chr(10),'') as main_card_flg
,replace(replace(t1.main_card_card_no,chr(13),''),chr(10),'') as main_card_card_no
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg
,replace(replace(t1.auto_coll_seq_type_cd,chr(13),''),chr(10),'') as auto_coll_seq_type_cd
,replace(replace(t1.coll_seq_num,chr(13),''),chr(10),'') as coll_seq_num
,replace(replace(t1.linkg_deduct_flg,chr(13),''),chr(10),'') as linkg_deduct_flg
,replace(replace(t1.card_stop_use_flg,chr(13),''),chr(10),'') as card_stop_use_flg
,replace(replace(t1.in_card_interturn_flg,chr(13),''),chr(10),'') as in_card_interturn_flg
,replace(replace(t1.dep_flg,chr(13),''),chr(10),'') as dep_flg
,replace(replace(t1.tranbl_flg,chr(13),''),chr(10),'') as tranbl_flg
,replace(replace(t1.cash_flg,chr(13),''),chr(10),'') as cash_flg
,replace(replace(t1.inco_decide_expns_flg,chr(13),''),chr(10),'') as inco_decide_expns_flg
,tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,tran_timestamp

from ${iml_schema}.agt_corp_stl_card_rela_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_stl_card_rela_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
