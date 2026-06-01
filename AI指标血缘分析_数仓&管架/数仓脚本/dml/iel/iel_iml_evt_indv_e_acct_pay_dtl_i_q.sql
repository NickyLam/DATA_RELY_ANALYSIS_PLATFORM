: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_indv_e_acct_pay_dtl_i_q
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_indv_e_acct_pay_dtl_q.i.${batch_date}.dat
IF_mark:    i_q
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pay_id,chr(13),''),chr(10),'') as pay_id
,replace(replace(t1.fin_acct_tran_dtl_id,chr(13),''),chr(10),'') as fin_acct_tran_dtl_id
,replace(replace(t1.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.init_pay_id,chr(13),''),chr(10),'') as init_pay_id
,replace(replace(t1.payment_flow_num,chr(13),''),chr(10),'') as payment_flow_num
,replace(replace(t1.pay_type_cd,chr(13),''),chr(10),'') as pay_type_cd
,replace(replace(t1.mode_pay_type_cd,chr(13),''),chr(10),'') as mode_pay_type_cd
,replace(replace(t1.from_mem_cd,chr(13),''),chr(10),'') as from_mem_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.mode_pay_flg,chr(13),''),chr(10),'') as mode_pay_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,t1.acct_tm as acct_tm
,t1.tran_tm as tran_tm
,t1.tran_amt as tran_amt
,t1.actl_amt as actl_amt
,t1.actl_bal as actl_bal
,t1.aval_bal as aval_bal
,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_open_bank_num,chr(13),''),chr(10),'') as cntpty_acct_open_bank_num
,replace(replace(t1.cntpty_acct_open_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_name
,t1.final_update_tm as final_update_tm
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
from ${iml_schema}.evt_indv_e_acct_pay_dtl t1
where t1.etl_dt > add_months(to_date('${batch_date}','yyyymmdd') ,-3) and t1.etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_indv_e_acct_pay_dtl_q.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes