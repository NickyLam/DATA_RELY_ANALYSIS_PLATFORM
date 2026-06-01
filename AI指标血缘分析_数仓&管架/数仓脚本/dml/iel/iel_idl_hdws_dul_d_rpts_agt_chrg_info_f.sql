: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_chrg_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_chrg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.chrg_id,chr(13),''),chr(10),'') as chrg_id
,replace(replace(t1.chrg_categ_cd,chr(13),''),chr(10),'') as chrg_categ_cd
,replace(replace(t1.chrg_item_cd,chr(13),''),chr(10),'') as chrg_item_cd
,replace(replace(t1.chrg_item_name,chr(13),''),chr(10),'') as chrg_item_name
,replace(replace(t1.chrg_item_coa_cd,chr(13),''),chr(10),'') as chrg_item_coa_cd
,replace(replace(t1.reg_org_id,chr(13),''),chr(10),'') as reg_org_id
,replace(replace(t1.reg_tell_id,chr(13),''),chr(10),'') as reg_tell_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.chrg_agt_id,chr(13),''),chr(10),'') as chrg_agt_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.chrg_amt as chrg_amt
,t1.recv_amt as recv_amt
,t1.chrg_dt as chrg_dt
,t1.mend_curt_dt as mend_curt_dt
,replace(replace(t1.amort_flg,chr(13),''),chr(10),'') as amort_flg
,t1.amort_stdt as amort_stdt
,t1.amort_end_dt as amort_end_dt
,replace(replace(t1.amort_enter_acct_num,chr(13),''),chr(10),'') as amort_enter_acct_num
,t1.amor_amt as amor_amt
,t1.unam_amt as unam_amt
,t1.amor_days as amor_days
,replace(replace(t1.chrg_biz_type_cd,chr(13),''),chr(10),'') as chrg_biz_type_cd
,replace(replace(t1.biz_id,chr(13),''),chr(10),'') as biz_id
from ${idl_schema}.hdws_dul_d_rpts_agt_chrg_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_chrg_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes