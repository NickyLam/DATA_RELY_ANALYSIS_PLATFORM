: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2a_dpst_acct_i_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2a_dpst_acct_i.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.acct_type,chr(13),''),chr(10),'') as acct_type
    ,replace(replace(t.acct_sts,chr(13),''),chr(10),'') as acct_sts
    ,replace(replace(t.subject_id,chr(13),''),chr(10),'') as subject_id
    ,replace(replace(t.prd_id,chr(13),''),chr(10),'') as prd_id
    ,replace(replace(t.curr_iden,chr(13),''),chr(10),'') as curr_iden
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.open_amt as open_amt
    ,t.bal_amt as bal_amt
    ,t.last_bal_amt as last_bal_amt
    ,t.avl_amt as avl_amt
    ,t.open_dt as open_dt
    ,t.int_dt as int_dt
    ,t.mature_dt as mature_dt
    ,t.term_cd as term_cd
    ,t.close_dt as close_dt
    ,replace(replace(t.card_no,chr(13),''),chr(10),'') as card_no
    ,replace(replace(t.agent_name,chr(13),''),chr(10),'') as agent_name
    ,replace(replace(t.agent_nat,chr(13),''),chr(10),'') as agent_nat
    ,replace(replace(t.agent_cert_type,chr(13),''),chr(10),'') as agent_cert_type
    ,replace(replace(t.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
    ,replace(replace(t.rsrv_01,chr(13),''),chr(10),'') as rsrv_01
    ,replace(replace(t.rsrv_02,chr(13),''),chr(10),'') as rsrv_02
    ,replace(replace(t.rsrv_03,chr(13),''),chr(10),'') as rsrv_03
    ,replace(replace(t.rsrv_04,chr(13),''),chr(10),'') as rsrv_04
    ,replace(replace(t.opr_id,chr(13),''),chr(10),'') as opr_id
    ,replace(replace(t.open_tm,chr(13),''),chr(10),'') as open_tm
    ,replace(replace(t.close_tm,chr(13),''),chr(10),'') as close_tm
    ,replace(replace(t.card_style,chr(13),''),chr(10),'') as card_style
    ,replace(replace(t.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
    ,replace(replace(t.acc_type1,chr(13),''),chr(10),'') as acc_type1
    ,replace(replace(t.is_merch,chr(13),''),chr(10),'') as is_merch
    ,replace(replace(t.is_ebank,chr(13),''),chr(10),'') as is_ebank
    ,replace(replace(t.mobile_bank_phone,chr(13),''),chr(10),'') as mobile_bank_phone
    ,replace(replace(t.open_chnl,chr(13),''),chr(10),'') as open_chnl
    ,replace(replace(t.agent_flag,chr(13),''),chr(10),'') as agent_flag
    ,replace(replace(t.agent_tel,chr(13),''),chr(10),'') as agent_tel
    ,t.last_occur_dt as last_occur_dt
    ,replace(replace(t.oth_agent_cert_type,chr(13),''),chr(10),'') as oth_agent_cert_type
    ,replace(replace(t.oth_card_style,chr(13),''),chr(10),'') as oth_card_style
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amls_t2a_dpst_acct_i t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2a_dpst_acct_i.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes