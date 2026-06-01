: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_bil_disct_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_bil_disct_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(bil_num,chr(10),''),chr(13),'') as bil_num
      ,replace(replace(acct_num,chr(10),''),chr(13),'') as acct_num
      ,replace(replace(bil_typ,chr(10),''),chr(13),'') as bil_typ
      ,disct_amt
      ,bil_amt
      ,int_start_dt
      ,sell_dt
      ,due_day
      ,bil_dt
      ,dcnt_buy_back_rate
      ,disct_out_retn_rate
      ,dcnt_buy_back_int
      ,disct_out_retn_int
      ,replace(replace(bil_status,chr(10),''),chr(13),'') as bil_status
      ,replace(replace(org_num,chr(10),''),chr(13),'') as org_num
      ,replace(replace(ccy,chr(10),''),chr(13),'') as ccy
      ,replace(replace(acpt_open_bank_name,chr(10),''),chr(13),'') as acpt_open_bank_name
      ,replace(replace(disct_typ_flg,chr(10),''),chr(13),'') as disct_typ_flg
      ,replace(replace(buy_sell_typ_cd,chr(10),''),chr(13),'') as buy_sell_typ_cd
      ,replace(replace(buy_sell_biz_typ_cd,chr(10),''),chr(13),'') as buy_sell_biz_typ_cd
      ,replace(replace(bil_status_cd,chr(10),''),chr(13),'') as bil_status_cd
      ,replace(replace(buy_mode_cd,chr(10),''),chr(13),'') as buy_mode_cd
      ,replace(replace(bil_deal_status_cd,chr(10),''),chr(13),'') as bil_deal_status_cd 
from idl.hdws_dul_d_ccrm_bil_disct_dtl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_bil_disct_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes