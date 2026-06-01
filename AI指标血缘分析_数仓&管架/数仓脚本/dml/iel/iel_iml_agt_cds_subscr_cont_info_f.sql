: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cds_subscr_cont_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cds_subscr_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.subscr_tot as subscr_tot
    ,t.effect_dt as effect_dt
    ,t.invalid_dt as invalid_dt
    ,t.exp_dt as exp_dt
    ,t.value_dt as value_dt
    ,replace(replace(t.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
    ,replace(replace(t.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
    ,t.agt_rat as agt_rat
    ,replace(replace(t.pric_tran_in_acct_num,chr(13),''),chr(10),'') as pric_tran_in_acct_num
    ,replace(replace(t.int_tran_in_acct_num,chr(13),''),chr(10),'') as int_tran_in_acct_num
    ,replace(replace(t.liab_acct_num,chr(13),''),chr(10),'') as liab_acct_num
    ,replace(replace(t.dep_rcpt_acct_num,chr(13),''),chr(10),'') as dep_rcpt_acct_num
    ,replace(replace(t.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
    ,replace(replace(t.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
    ,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
    ,replace(replace(t.sign_emply_id,chr(13),''),chr(10),'') as sign_emply_id
    ,replace(replace(t.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
    ,t.sign_dt as sign_dt
    ,replace(replace(t.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
    ,t.revo_dt as revo_dt
    ,replace(replace(t.dep_prod_acct_id,chr(13),''),chr(10),'') as dep_prod_acct_id
    ,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
    ,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
    ,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
    ,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.src_prod_id,chr(13),''),chr(10),'') as src_prod_id
    ,t.tm_stamp as tm_stamp
from iml.agt_cds_subscr_cont_info t 
  where t.create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cds_subscr_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes