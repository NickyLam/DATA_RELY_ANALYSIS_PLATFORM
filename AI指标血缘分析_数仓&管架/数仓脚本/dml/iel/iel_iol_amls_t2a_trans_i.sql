: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2a_trans_i
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2a_trans.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.tr_id,chr(13),''),chr(10),'') as tr_id
    ,t.tr_dt as tr_dt
    ,t.tr_tm as tr_tm
    ,replace(replace(t.tr_no,chr(13),''),chr(10),'') as tr_no
    ,replace(replace(t.rcv_pay_type,chr(13),''),chr(10),'') as rcv_pay_type
    ,replace(replace(t.rcv_pay_no,chr(13),''),chr(10),'') as rcv_pay_no
    ,replace(replace(t.tr_org_id,chr(13),''),chr(10),'') as tr_org_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.card_no,chr(13),''),chr(10),'') as card_no
    ,replace(replace(t.card_style,chr(13),''),chr(10),'') as card_style
    ,replace(replace(t.oth_card_style,chr(13),''),chr(10),'') as oth_card_style
    ,replace(replace(t.subject_id,chr(13),''),chr(10),'') as subject_id
    ,replace(replace(t.prd_id,chr(13),''),chr(10),'') as prd_id
    ,replace(replace(t.tr_chnl,chr(13),''),chr(10),'') as tr_chnl
    ,replace(replace(t.s_tr_chnl,chr(13),''),chr(10),'') as s_tr_chnl
    ,replace(replace(t.tr_cd,chr(13),''),chr(10),'') as tr_cd
    ,replace(replace(t.s_tr_cd,chr(13),''),chr(10),'') as s_tr_cd
    ,replace(replace(t.biz_type,chr(13),''),chr(10),'') as biz_type
    ,replace(replace(t.is_cash,chr(13),''),chr(10),'') as is_cash
    ,replace(replace(t.pay_type,chr(13),''),chr(10),'') as pay_type
    ,replace(replace(t.debit_credit,chr(13),''),chr(10),'') as debit_credit
    ,replace(replace(t.rcv_pay,chr(13),''),chr(10),'') as rcv_pay
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,replace(replace(t.is_local_curr,chr(13),''),chr(10),'') as is_local_curr
    ,t.tr_amt as tr_amt
    ,t.tr_cny_amt as tr_cny_amt
    ,t.tr_usd_amt as tr_usd_amt
    ,t.tr_bal_amt as tr_bal_amt
    ,replace(replace(t.tr_country,chr(13),''),chr(10),'') as tr_country
    ,replace(replace(t.tr_area,chr(13),''),chr(10),'') as tr_area
    ,replace(replace(t.fund_use,chr(13),''),chr(10),'') as fund_use
    ,replace(replace(t.agent_name,chr(13),''),chr(10),'') as agent_name
    ,replace(replace(t.agent_nat,chr(13),''),chr(10),'') as agent_nat
    ,replace(replace(t.agent_cert_type,chr(13),''),chr(10),'') as agent_cert_type
    ,replace(replace(t.oth_agent_cert_type,chr(13),''),chr(10),'') as oth_agent_cert_type
    ,replace(replace(t.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
    ,replace(replace(t.opp_name,chr(13),''),chr(10),'') as opp_name
    ,replace(replace(t.opp_acct_id,chr(13),''),chr(10),'') as opp_acct_id
    ,replace(replace(t.opp_acct_type,chr(13),''),chr(10),'') as opp_acct_type
    ,replace(replace(t.opp_is_cust,chr(13),''),chr(10),'') as opp_is_cust
    ,replace(replace(t.opp_cust_id,chr(13),''),chr(10),'') as opp_cust_id
    ,replace(replace(t.opp_cust_type,chr(13),''),chr(10),'') as opp_cust_type
    ,replace(replace(t.opp_off_shore,chr(13),''),chr(10),'') as opp_off_shore
    ,replace(replace(t.opp_card_no,chr(13),''),chr(10),'') as opp_card_no
    ,replace(replace(t.opp_card_style,chr(13),''),chr(10),'') as opp_card_style
    ,replace(replace(t.oth_opp_card_style,chr(13),''),chr(10),'') as oth_opp_card_style
    ,replace(replace(t.opp_cert_type,chr(13),''),chr(10),'') as opp_cert_type
    ,replace(replace(t.oth_opp_cert_type,chr(13),''),chr(10),'') as oth_opp_cert_type
    ,replace(replace(t.opp_cert_no,chr(13),''),chr(10),'') as opp_cert_no
    ,replace(replace(t.opp_org_id,chr(13),''),chr(10),'') as opp_org_id
    ,replace(replace(t.opp_org_name,chr(13),''),chr(10),'') as opp_org_name
    ,replace(replace(t.opp_org_type,chr(13),''),chr(10),'') as opp_org_type
    ,replace(replace(t.opp_org_country,chr(13),''),chr(10),'') as opp_org_country
    ,replace(replace(t.opp_org_area,chr(13),''),chr(10),'') as opp_org_area
    ,replace(replace(t.tr_go_country,chr(13),''),chr(10),'') as tr_go_country
    ,replace(replace(t.tr_go_area,chr(13),''),chr(10),'') as tr_go_area
    ,replace(replace(t.is_cross,chr(13),''),chr(10),'') as is_cross
    ,replace(replace(t.opr_id,chr(13),''),chr(10),'') as opr_id
    ,replace(replace(t.re_opr_id,chr(13),''),chr(10),'') as re_opr_id
    ,replace(replace(t.rev_cd,chr(13),''),chr(10),'') as rev_cd
    ,replace(replace(t.pbc_rltp,chr(13),''),chr(10),'') as pbc_rltp
    ,replace(replace(t.pbc_tsct,chr(13),''),chr(10),'') as pbc_tsct
    ,replace(replace(t.sys_id,chr(13),''),chr(10),'') as sys_id
    ,replace(replace(t.ip,chr(13),''),chr(10),'') as ip
    ,replace(replace(t.tr_ipv6,chr(13),''),chr(10),'') as tr_ipv6
    ,replace(replace(t.tr_mac,chr(13),''),chr(10),'') as tr_mac
    ,replace(replace(t.tr_note1,chr(13),''),chr(10),'') as tr_note1
    ,replace(replace(t.tr_note2,chr(13),''),chr(10),'') as tr_note2
    ,replace(replace(t.bank_pay_cd,chr(13),''),chr(10),'') as bank_pay_cd
    ,replace(replace(t.eqpt_cd,chr(13),''),chr(10),'') as eqpt_cd
    ,replace(replace(t.merch_id,chr(13),''),chr(10),'') as merch_id
    ,replace(replace(t.merch_type,chr(13),''),chr(10),'') as merch_type
    ,replace(replace(t.is_3rd_pay,chr(13),''),chr(10),'') as is_3rd_pay
    ,replace(replace(t.tr_crt_type,chr(13),''),chr(10),'') as tr_crt_type
    ,replace(replace(t.bh_exec,chr(13),''),chr(10),'') as bh_exec
    ,replace(replace(t.bs_exec,chr(13),''),chr(10),'') as bs_exec
    ,replace(replace(t.clct_sts,chr(13),''),chr(10),'') as clct_sts
    ,replace(replace(t.bh_valid,chr(13),''),chr(10),'') as bh_valid
    ,replace(replace(t.bs_valid,chr(13),''),chr(10),'') as bs_valid
    ,t.due_dt as due_dt
    ,replace(replace(t.rsrv_01,chr(13),''),chr(10),'') as rsrv_01
    ,replace(replace(t.rsrv_02,chr(13),''),chr(10),'') as rsrv_02
    ,replace(replace(t.rsrv_03,chr(13),''),chr(10),'') as rsrv_03
    ,replace(replace(t.rsrv_04,chr(13),''),chr(10),'') as rsrv_04
    ,replace(replace(t.pbc_chnl,chr(13),''),chr(10),'') as pbc_chnl
    ,replace(replace(t.non_dept_type,chr(13),''),chr(10),'') as non_dept_type
    ,replace(replace(t.oth_non_dept_type,chr(13),''),chr(10),'') as oth_non_dept_type
    ,replace(replace(t.pbc_orgkey,chr(13),''),chr(10),'') as pbc_orgkey
    ,replace(replace(t.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
    ,replace(replace(t.agent_tel,chr(13),''),chr(10),'') as agent_tel
    ,replace(replace(t.opp_acct_type1,chr(13),''),chr(10),'') as opp_acct_type1
    ,replace(replace(t.pos_owner,chr(13),''),chr(10),'') as pos_owner
    ,replace(replace(t.is_cadr_trans,chr(13),''),chr(10),'') as is_cadr_trans
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.oth_cert_type,chr(13),''),chr(10),'') as oth_cert_type
    ,replace(replace(t.atm_bank_code,chr(13),''),chr(10),'') as atm_bank_code
from iol.amls_t2a_trans t
  where to_char(t.tr_dt,'yyyymmdd') = '${batch_date}'  " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2a_trans.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes