: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_mercht_clear_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_mercht_clear_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.midgrod_tran_dt as midgrod_tran_dt
,t1.unionpay_tran_dt as unionpay_tran_dt
,t1.core_tran_dt as core_tran_dt
,t1.clear_day_term as clear_day_term
,replace(replace(t1.midgrod_tran_flow_num,chr(13),''),chr(10),'') as midgrod_tran_flow_num
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.unionpay_org_id,chr(13),''),chr(10),'') as unionpay_org_id
,replace(replace(t1.actl_enter_acct_id,chr(13),''),chr(10),'') as actl_enter_acct_id
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.sign_org_name,chr(13),''),chr(10),'') as sign_org_name
,replace(replace(t1.expd_mercht_name,chr(13),''),chr(10),'') as expd_mercht_name
,t1.tran_amt as tran_amt
,t1.mercht_serv_fee as mercht_serv_fee
,t1.comm_fee as comm_fee
,t1.consm_amt as consm_amt
,t1.rtn_goods_amt as rtn_goods_amt
,t1.consm_revs_amt as consm_revs_amt
,t1.rtn_goods_revs_amt as rtn_goods_revs_amt
,t1.debit_adj_amt as debit_adj_amt
,t1.crdt_adj_amt as crdt_adj_amt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.enter_acct_status_cd,chr(13),''),chr(10),'') as enter_acct_status_cd
,t1.tran_tot as tran_tot
,replace(replace(t1.hxb_acct_flg,chr(13),''),chr(10),'') as hxb_acct_flg
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
from ${iml_schema}.evt_mercht_clear_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_mercht_clear_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes