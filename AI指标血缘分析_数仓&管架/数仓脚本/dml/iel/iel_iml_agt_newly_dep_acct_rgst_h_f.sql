: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_newly_dep_acct_rgst_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_newly_dep_acct_rgst_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.liab_acct_num,chr(13),''),chr(10),'') as liab_acct_num
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t.prod_acct_num,chr(13),''),chr(10),'') as prod_acct_num
,replace(replace(t.acct_belong_bank_no,chr(13),''),chr(10),'') as acct_belong_bank_no
,replace(replace(t.basic_acct_open_bank_no,chr(13),''),chr(10),'') as basic_acct_open_bank_no
,replace(replace(t.basic_acct_open_bank_name,chr(13),''),chr(10),'') as basic_acct_open_bank_name
,replace(replace(t.basic_acct_num,chr(13),''),chr(10),'') as basic_acct_num
,t.book_bal as book_bal
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.fori_exch_acct_char_cd,chr(13),''),chr(10),'') as fori_exch_acct_char_cd
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,replace(replace(t.expot_flg,chr(13),''),chr(10),'') as expot_flg
,replace(replace(t.openup_opr_name,chr(13),''),chr(10),'') as openup_opr_name
,t.sucs_cnt as sucs_cnt
,replace(replace(t.trans_chgpflg_flg,chr(13),''),chr(10),'') as trans_chgpflg_flg
,replace(replace(t.bal_coll_acct_num,chr(13),''),chr(10),'') as bal_coll_acct_num
,replace(replace(t.sign_finc_acct_num,chr(13),''),chr(10),'') as sign_finc_acct_num
,replace(replace(t.sign_finc_prod_id,chr(13),''),chr(10),'') as sign_finc_prod_id
,replace(replace(t.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,t.matn_dt as matn_dt
,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_newly_dep_acct_rgst_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_newly_dep_acct_rgst_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes