: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_src_dw_agt_ln_ac_amt_info_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_src_dw_agt_ln_ac_amt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,etl_dt_ora
,loan_total_term
,loan_new_term
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,loan_total_bal
,loan_bal
,day_accr_int
,paid_prcp
,paid_int
,paid_pnlt
,paid_compd_int
,paid_cost
,aggr_rcvable_int_amt
,int_on_bs_bal
,int_off_bs_bal
,on_int
,off_int
,provn
,prev_adj_int_dt
,next_adj_int_dt
,next_stl_dt
,actl_write_off_prcp
,actl_write_off_int
,rcva_acr_intr
,rcva_owe_int
,rcva_accr_pnlt
,rcva_pnlt
,accr_cmpd_intr
,rcva_cmpd_intr
,dun_acr_intr
,dun_owe_int
,dun_accr_pnlt
,dun_pnlt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg

from ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_src_dw_agt_ln_ac_amt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
