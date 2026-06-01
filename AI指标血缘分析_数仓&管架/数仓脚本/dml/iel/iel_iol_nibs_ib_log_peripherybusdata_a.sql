: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_log_peripherybusdata_a
CreateDate: 20230719
FileName:   ${iel_data_path}/nibs_ib_log_peripherybusdata.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.txn_dt,chr(13),''),chr(10),'') as txn_dt
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.program_id,chr(13),''),chr(10),'') as program_id
,replace(replace(t1.txn_name,chr(13),''),chr(10),'') as txn_name
,replace(replace(t1.txn_chn,chr(13),''),chr(10),'') as txn_chn
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.ta_name,chr(13),''),chr(10),'') as ta_name
,replace(replace(t1.prd_cd,chr(13),''),chr(10),'') as prd_cd
,replace(replace(t1.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t1.bank_acct_num,chr(13),''),chr(10),'') as bank_acct_num
,replace(replace(t1.fin_acct_num,chr(13),''),chr(10),'') as fin_acct_num
,replace(replace(t1.lot,chr(13),''),chr(10),'') as lot
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.amt,chr(13),''),chr(10),'') as amt
,replace(replace(t1.disct_rate,chr(13),''),chr(10),'') as disct_rate
,replace(replace(t1.txn_status,chr(13),''),chr(10),'') as txn_status
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.error_msg,chr(13),''),chr(10),'') as error_msg
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(t1.adt,chr(13),''),chr(10),'') as adt
,replace(replace(t1.frz_reas,chr(13),''),chr(10),'') as frz_reas
,replace(replace(t1.huge_rede_flg,chr(13),''),chr(10),'') as huge_rede_flg
,replace(replace(t1.divi_mode,chr(13),''),chr(10),'') as divi_mode
,replace(replace(t1.divi_mode_name,chr(13),''),chr(10),'') as divi_mode_name
,replace(replace(t1.txn_status_name,chr(13),''),chr(10),'') as txn_status_name
,replace(replace(t1.txn_tm,chr(13),''),chr(10),'') as txn_tm
,replace(replace(t1.txn_med_typ,chr(13),''),chr(10),'') as txn_med_typ
,replace(replace(t1.txn_med,chr(13),''),chr(10),'') as txn_med
,replace(replace(t1.pty_risk_rank,chr(13),''),chr(10),'') as pty_risk_rank
,replace(replace(t1.prd_risk_rank,chr(13),''),chr(10),'') as prd_risk_rank
,replace(replace(t1.contr_id,chr(13),''),chr(10),'') as contr_id
,replace(replace(t1.xtra_chrg_fee,chr(13),''),chr(10),'') as xtra_chrg_fee
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.assoc_dt,chr(13),''),chr(10),'') as assoc_dt
,replace(replace(t1.cash_remit_flg,chr(13),''),chr(10),'') as cash_remit_flg
,replace(replace(t1.curt_bus_status,chr(13),''),chr(10),'') as curt_bus_status
,replace(replace(t1.curt_bus_status_name,chr(13),''),chr(10),'') as curt_bus_status_name
,replace(replace(t1.enter_prd_cd,chr(13),''),chr(10),'') as enter_prd_cd
,replace(replace(t1.oppo_retl_cd,chr(13),''),chr(10),'') as oppo_retl_cd
,replace(replace(t1.oppo_fin_acct_num,chr(13),''),chr(10),'') as oppo_fin_acct_num
,replace(replace(t1.tgt_bank_acct_num,chr(13),''),chr(10),'') as tgt_bank_acct_num
,replace(replace(t1.prd_templ_num,chr(13),''),chr(10),'') as prd_templ_num
,replace(replace(t1.wthr_can_canc_flg,chr(13),''),chr(10),'') as wthr_can_canc_flg
,replace(replace(t1.scene_num,chr(13),''),chr(10),'') as scene_num
,replace(replace(t1.txn_org,chr(13),''),chr(10),'') as txn_org
,replace(replace(t1.txn_tell,chr(13),''),chr(10),'') as txn_tell
,replace(replace(t1.busitype,chr(13),''),chr(10),'') as busitype
,replace(replace(t1.compang_code,chr(13),''),chr(10),'') as compang_code
,replace(replace(t1.issue_fee,chr(13),''),chr(10),'') as issue_fee
,replace(replace(t1.blendingstatu,chr(13),''),chr(10),'') as blendingstatu
,replace(replace(t1.blendingtype,chr(13),''),chr(10),'') as blendingtype
,replace(replace(t1.blip_id,chr(13),''),chr(10),'') as blip_id
,replace(replace(t1.blip_scndate,chr(13),''),chr(10),'') as blip_scndate
,replace(replace(t1.blendingdesc,chr(13),''),chr(10),'') as blendingdesc

from ${iol_schema}.nibs_ib_log_peripherybusdata t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_log_peripherybusdata.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
