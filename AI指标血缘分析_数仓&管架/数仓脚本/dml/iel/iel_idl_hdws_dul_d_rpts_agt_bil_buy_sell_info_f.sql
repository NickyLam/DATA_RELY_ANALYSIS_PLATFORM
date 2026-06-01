: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_bil_buy_sell_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_bil_buy_sell_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(buy_sell_id,chr(10),''),chr(13),'') as buy_sell_id
      ,etl_dt
      ,replace(replace(bil_id,chr(10),''),chr(13),'') as bil_id
      ,replace(replace(buy_sell_pty_id,chr(10),''),chr(13),'') as buy_sell_pty_id
      ,replace(replace(buy_sell_org_id,chr(10),''),chr(13),'') as buy_sell_org_id
      ,replace(replace(buy_sell_typ_cd,chr(10),''),chr(13),'') as buy_sell_typ_cd
      ,buy_sell_dt
      ,replace(replace(buy_sell_prd_typ_cd,chr(10),''),chr(13),'') as buy_sell_prd_typ_cd
      ,replace(replace(buy_sell_biz_typ_cd,chr(10),''),chr(13),'') as buy_sell_biz_typ_cd
      ,replace(replace(rate_typ_cd,chr(10),''),chr(13),'') as rate_typ_cd
      ,rate
      ,replace(replace(rede_rate_typ_cd,chr(10),''),chr(13),'') as rede_rate_typ_cd
      ,rede_rate
      ,bidir_bout_dt
      ,purch_resale_dt
      ,rede_open_day
      ,rede_end_day
      ,replace(replace(pay_mode_cd,chr(10),''),chr(13),'') as pay_mode_cd
      ,pay_ratio
      ,replace(replace(disct_typ_cd,chr(10),''),chr(13),'') as disct_typ_cd
      ,replace(replace(inner_flg,chr(10),''),chr(13),'') as inner_flg
      ,actl_txn_amt
      ,int
      ,replace(replace(txn_org_id,chr(10),''),chr(13),'') as txn_org_id
      ,replace(replace(bil_org_id,chr(10),''),chr(13),'') as bil_org_id
      ,int_due_day
      ,int_days
      ,adj_days
      ,hldy_days
      ,amor_days
      ,bil_dt
      ,replace(replace(bil_status_cd,chr(10),''),chr(13),'') as bil_status_cd
      ,bidir_bout_due_day
      ,purch_resale_due_day
      ,amor_int
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(pty_mgr_name,chr(10),''),chr(13),'') as pty_mgr_name
      ,replace(replace(dept_id,chr(10),''),chr(13),'') as dept_id
      ,replace(replace(dept_name,chr(10),''),chr(13),'') as dept_name
      ,replace(replace(due_status_cd,chr(10),''),chr(13),'') as due_status_cd
      ,replace(replace(bil_provi_typ_cd,chr(10),''),chr(13),'') as bil_provi_typ_cd
      ,replace(replace(buy_mode_cd,chr(10),''),chr(13),'') as buy_mode_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(acct_seq_num,chr(10),''),chr(13),'') as acct_seq_num
      ,replace(replace(bil_num,chr(10),''),chr(13),'') as bil_num 
from idl.hdws_dul_d_rpts_agt_bil_buy_sell_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_bil_buy_sell_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes