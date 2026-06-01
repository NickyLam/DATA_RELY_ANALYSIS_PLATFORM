: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_bil_buy_sell_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_bil_buy_sell_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.buy_sell_id,chr(13),''),chr(10),'') as buy_sell_id
,t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,replace(replace(t1.bil_id,chr(13),''),chr(10),'') as bil_id
,replace(replace(t1.buy_sell_pty_id,chr(13),''),chr(10),'') as buy_sell_pty_id
,replace(replace(t1.buy_sell_org_id,chr(13),''),chr(10),'') as buy_sell_org_id
,replace(replace(t1.buy_sell_typ_cd,chr(13),''),chr(10),'') as buy_sell_typ_cd
,t1.buy_sell_dt as buy_sell_dt
,replace(replace(t1.buy_sell_prd_typ_cd,chr(13),''),chr(10),'') as buy_sell_prd_typ_cd
,replace(replace(t1.buy_sell_biz_typ_cd,chr(13),''),chr(10),'') as buy_sell_biz_typ_cd
,replace(replace(t1.rate_typ_cd,chr(13),''),chr(10),'') as rate_typ_cd
,t1.rate as rate
,replace(replace(t1.rede_rate_typ_cd,chr(13),''),chr(10),'') as rede_rate_typ_cd
,t1.rede_rate as rede_rate
,t1.bidir_bout_dt as bidir_bout_dt
,t1.purch_resale_dt as purch_resale_dt
,t1.rede_open_day as rede_open_day
,t1.rede_end_day as rede_end_day
,replace(replace(t1.pay_mode_cd,chr(13),''),chr(10),'') as pay_mode_cd
,t1.pay_ratio as pay_ratio
,replace(replace(t1.disct_typ_cd,chr(13),''),chr(10),'') as disct_typ_cd
,replace(replace(t1.inner_flg,chr(13),''),chr(10),'') as inner_flg
,t1.actl_txn_amt as actl_txn_amt
,t1.int as int
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.bil_org_id,chr(13),''),chr(10),'') as bil_org_id
,t1.int_due_day as int_due_day
,t1.int_days as int_days
,t1.adj_days as adj_days
,t1.hldy_days as hldy_days
,t1.amor_days as amor_days
,t1.bil_dt as bil_dt
,replace(replace(t1.bil_status_cd,chr(13),''),chr(10),'') as bil_status_cd
,t1.bidir_bout_due_day as bidir_bout_due_day
,t1.purch_resale_due_day as purch_resale_due_day
,t1.amor_int as amor_int
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.pty_mgr_name,chr(13),''),chr(10),'') as pty_mgr_name
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.dept_name,chr(13),''),chr(10),'') as dept_name
,replace(replace(t1.due_status_cd,chr(13),''),chr(10),'') as due_status_cd
,replace(replace(t1.bil_provi_typ_cd,chr(13),''),chr(10),'') as bil_provi_typ_cd
,replace(replace(t1.buy_mode_cd,chr(13),''),chr(10),'') as buy_mode_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,NVL2(t1.data_src_cd,'AGT_BIL_BUY_SELL_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_BIL_BUY_SELL_INFO') as etl_task_name
,replace(replace(t1.bil_biz_typ_cd,chr(13),''),chr(10),'') as bil_biz_typ_cd
,replace(replace(t1.bil_forehand_flg,chr(13),''),chr(10),'') as bil_forehand_flg
,replace(replace(t1.bil_bef_hand_name,chr(13),''),chr(10),'') as bil_bef_hand_name
,replace(replace(t1.bil_forehand_typ_cd,chr(13),''),chr(10),'') as bil_forehand_typ_cd
,replace(replace(t1.bil_contr_id,chr(13),''),chr(10),'') as bil_contr_id
,t1.contr_due_dt as contr_due_dt
,replace(replace(t1.txn_cnte_pty_ibank_num,chr(13),''),chr(10),'') as txn_cnte_pty_ibank_num
,replace(replace(t1.cntrpty_name,chr(13),''),chr(10),'') as cntrpty_name
,replace(replace(t1.acct_seq_num,chr(13),''),chr(10),'') as acct_seq_num
,replace(replace(t1.bil_num,chr(13),''),chr(10),'') as bil_num
from ${idl_schema}.hdws_iml_agt_bil_buy_sell_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_bil_buy_sell_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes