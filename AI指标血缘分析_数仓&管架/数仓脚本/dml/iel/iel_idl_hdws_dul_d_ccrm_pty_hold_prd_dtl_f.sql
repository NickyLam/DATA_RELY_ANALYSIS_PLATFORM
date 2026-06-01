: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_pty_hold_prd_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_pty_hold_prd_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(prd_typ,chr(10),''),chr(13),'') as prd_typ
      ,replace(replace(sign_acct_num,chr(10),''),chr(13),'') as sign_acct_num
      ,sign_dt
      ,replace(replace(sign_org,chr(10),''),chr(13),'') as sign_org
      ,replace(replace(status,chr(10),''),chr(13),'') as status
      ,remit_contr_tm
      ,replace(replace(sign_ceph_num,chr(10),''),chr(13),'') as sign_ceph_num 
from idl.hdws_dul_d_ccrm_pty_hold_prd_dtl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_pty_hold_prd_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes