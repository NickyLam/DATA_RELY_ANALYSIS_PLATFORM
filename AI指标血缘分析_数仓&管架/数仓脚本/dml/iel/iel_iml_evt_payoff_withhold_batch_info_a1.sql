: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_payoff_withhold_batch_info_a1
CreateDate: 20250508
FileName:   ${iel_data_path}/evt_payoff_withhold_batch_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,batch_dt
,replace(replace(t1.batch_flow_num,chr(13),''),chr(10),'') as batch_flow_num
,replace(replace(t1.sign_id,chr(13),''),chr(10),'') as sign_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.batch_data_doc_name,chr(13),''),chr(10),'') as batch_data_doc_name
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
,replace(replace(t1.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd
,replace(replace(t1.deduct_acct_id,chr(13),''),chr(10),'') as deduct_acct_id
,replace(replace(t1.deduct_acct_name,chr(13),''),chr(10),'') as deduct_acct_name
,tot
,tot_amt
,sucs_cnt
,sucs_amt
,fail_cnt
,fail_amt
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.actl_deduct_acct_id,chr(13),''),chr(10),'') as actl_deduct_acct_id
,replace(replace(t1.midgrod_tran_flow_num,chr(13),''),chr(10),'') as midgrod_tran_flow_num

from ${iml_schema}.evt_payoff_withhold_batch_info t1
where etl_dt between trunc(SYSDATE,'yy') and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_payoff_withhold_batch_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
