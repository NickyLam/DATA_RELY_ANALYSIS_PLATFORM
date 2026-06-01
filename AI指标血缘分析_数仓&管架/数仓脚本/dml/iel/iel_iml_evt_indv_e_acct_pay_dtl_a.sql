: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_indv_e_acct_pay_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_indv_e_acct_pay_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.pay_id,chr(13),''),chr(10),'') as pay_id
    ,replace(replace(t.fin_acct_tran_dtl_id,chr(13),''),chr(10),'') as fin_acct_tran_dtl_id
    ,replace(replace(t.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.init_pay_id,chr(13),''),chr(10),'') as init_pay_id
    ,replace(replace(t.payment_flow_num,chr(13),''),chr(10),'') as payment_flow_num
    ,replace(replace(t.pay_type_cd,chr(13),''),chr(10),'') as pay_type_cd
    ,replace(replace(t.mode_pay_type_cd,chr(13),''),chr(10),'') as mode_pay_type_cd
    ,replace(replace(t.from_mem_cd,chr(13),''),chr(10),'') as from_mem_cd
    ,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
    ,replace(replace(t.mode_pay_flg,chr(13),''),chr(10),'') as mode_pay_flg
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,replace(replace(t.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
    ,t.acct_tm as acct_tm
    ,t.tran_tm as tran_tm
    ,t.tran_amt as tran_amt
    ,t.actl_amt as actl_amt
    ,t.actl_bal as actl_bal
    ,t.aval_bal as aval_bal
    ,replace(replace(t.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
    ,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
    ,replace(replace(t.cntpty_acct_open_bank_num,chr(13),''),chr(10),'') as cntpty_acct_open_bank_num
    ,replace(replace(t.cntpty_acct_open_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_name
    ,t.final_update_tm as final_update_tm
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.postsc,chr(13),''),chr(10),'') as postsc
    ,t.create_affair_tm as create_affair_tm
from iml.evt_indv_e_acct_pay_dtl t
  where to_char(t.acct_tm,'yyyymmdd') <= '${batch_date}' and to_char(t.acct_tm,'yyyymmdd') >= '20210101' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_indv_e_acct_pay_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes