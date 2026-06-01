: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_lp_acct_od_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_lp_acct_od_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,t.tran_tm as tran_tm
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t.wdraw_amt_and_comm_fee as wdraw_amt_and_comm_fee
,t.od_amt as od_amt
,replace(replace(t.od_acct_id,chr(13),''),chr(10),'') as od_acct_id
,replace(replace(t.od_acct_sub_acct_id,chr(13),''),chr(10),'') as od_acct_sub_acct_id
,t.od_comm_fee as od_comm_fee
,t.paid_comm_fee as paid_comm_fee
,t.unpaid_comm_fee as unpaid_comm_fee
,t.repay_dt as repay_dt
,replace(replace(t.repay_flow_num,chr(13),''),chr(10),'') as repay_flow_num
,t.paid_od_amt as paid_od_amt
,t.unpaid_od_amt as unpaid_od_amt
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.revs_status_cd,chr(13),''),chr(10),'') as revs_status_cd
,t.revs_dt as revs_dt
,replace(replace(t.revs_flow_num,chr(13),''),chr(10),'') as revs_flow_num
,t.revs_tm as revs_tm
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd
,replace(replace(t.acrs_mon_flg,chr(13),''),chr(10),'') as acrs_mon_flg
,t.od_free_int_term as od_free_int_term
 from iml.evt_lp_acct_od_tran_dtl t 
 where t.etl_dt = to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_lp_acct_od_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes