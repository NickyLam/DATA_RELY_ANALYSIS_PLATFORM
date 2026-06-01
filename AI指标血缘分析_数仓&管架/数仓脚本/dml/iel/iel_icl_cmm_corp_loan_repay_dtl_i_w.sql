: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_repay_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_loan_repay_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t.repay_flow_id,chr(13),''),chr(10),'') as repay_flow_id
,t.repay_dt as repay_dt
,t.repay_perds as repay_perds
,replace(replace(t.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
,replace(replace(t.repay_chn_cd,chr(13),''),chr(10),'') as repay_chn_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.curr_nomal_pric_bal as curr_nomal_pric_bal
,t.currt_adv_repay_pric as currt_adv_repay_pric
,t.currt_repay_pric as currt_repay_pric
,t.currt_repay_int as currt_repay_int
,t.currt_repay_pnlt as currt_repay_pnlt
,t.currt_repay_comp_int as currt_repay_comp_int
,t.currt_repay_fee as currt_repay_fee
from ${icl_schema}.cmm_corp_loan_repay_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6   ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_repay_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes