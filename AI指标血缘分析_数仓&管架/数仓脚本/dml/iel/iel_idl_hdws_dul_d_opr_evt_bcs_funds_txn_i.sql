: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_evt_bcs_funds_txn_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_evt_bcs_funds_txn.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(evt_id,chr(10),''),chr(13),'') as evt_id
      ,txn_dt
      ,replace(replace(reg_ord_nbr,chr(10),''),chr(13),'') as reg_ord_nbr
      ,replace(replace(bal_chg_typ_cd,chr(10),''),chr(13),'') as bal_chg_typ_cd
      ,replace(replace(acct_num,chr(10),''),chr(13),'') as acct_num
      ,replace(replace(inv_acct_num,chr(10),''),chr(13),'') as inv_acct_num
      ,replace(replace(sub_num,chr(10),''),chr(13),'') as sub_num
      ,replace(replace(db_cr_dir,chr(10),''),chr(13),'') as db_cr_dir
      ,replace(replace(comn_bil_flg,chr(10),''),chr(13),'') as comn_bil_flg
      ,replace(replace(stmt_jnl,chr(10),''),chr(13),'') as stmt_jnl
      ,replace(replace(instr_tab_typ,chr(10),''),chr(13),'') as instr_tab_typ
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,replace(replace(sub_trx_cd,chr(10),''),chr(13),'') as sub_trx_cd
      ,replace(replace(sub_trx_ord_nbr,chr(10),''),chr(13),'') as sub_trx_ord_nbr
      ,replace(replace(proc_num,chr(10),''),chr(13),'') as proc_num
      ,replace(replace(dtl_instr_typ,chr(10),''),chr(13),'') as dtl_instr_typ
      ,amt
      ,replace(replace(txn_dept,chr(10),''),chr(13),'') as txn_dept
      ,replace(replace(txn_type,chr(10),''),chr(13),'') as txn_type
      ,replace(replace(entry_wthr_prtc_reve,chr(10),''),chr(13),'') as entry_wthr_prtc_reve
      ,etl_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_opr_evt_bcs_funds_txn 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_evt_bcs_funds_txn.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes