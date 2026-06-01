: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_payoff_withhold_batch_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_payoff_withhold_batch_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.batch_dt as batch_dt
    ,replace(replace(t.batch_flow_num,chr(13),''),chr(10),'') as batch_flow_num
    ,replace(replace(t.sign_id,chr(13),''),chr(10),'') as sign_id
    ,replace(replace(t.batch_id,chr(13),''),chr(10),'') as batch_id
    ,replace(replace(t.batch_data_doc_name,chr(13),''),chr(10),'') as batch_data_doc_name
    ,replace(replace(t.memo_cd,chr(13),''),chr(10),'') as memo_cd
    ,replace(replace(t.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
    ,replace(replace(t.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd
    ,replace(replace(t.deduct_acct_id,chr(13),''),chr(10),'') as deduct_acct_id
    ,replace(replace(t.deduct_acct_name,chr(13),''),chr(10),'') as deduct_acct_name
    ,t.tot as tot
    ,t.tot_amt as tot_amt
    ,t.sucs_cnt as sucs_cnt
    ,t.sucs_amt as sucs_amt
    ,t.fail_cnt as fail_cnt
    ,t.fail_amt as fail_amt
    ,replace(replace(t.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
    ,replace(replace(t.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,replace(replace(t.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
    ,replace(replace(t.actl_deduct_acct_id,chr(13),''),chr(10),'') as actl_deduct_acct_id
    ,replace(replace(t.midgrod_tran_flow_num,chr(13),''),chr(10),'') as midgrod_tran_flow_num
from iml.evt_payoff_withhold_batch_info t
  where t.batch_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_payoff_withhold_batch_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes