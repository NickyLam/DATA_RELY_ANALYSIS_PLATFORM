: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_hold_prd_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_hold_prd_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(sign_agt_id,chr(10),''),chr(13),'') as sign_agt_id
      ,etl_dt
      ,last_update_dt
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(prd_typ_cd,chr(10),''),chr(13),'') as prd_typ_cd
      ,replace(replace(sign_acct_num,chr(10),''),chr(13),'') as sign_acct_num
      ,sign_dt
      ,replace(replace(sign_org_id,chr(10),''),chr(13),'') as sign_org_id
      ,replace(replace(sign_org_name,chr(10),''),chr(13),'') as sign_org_name
      ,replace(replace(sign_tell_id,chr(10),''),chr(13),'') as sign_tell_id
      ,replace(replace(status_prd_status_cd,chr(10),''),chr(13),'') as status_prd_status_cd
      ,remit_contr_tm
      ,replace(replace(remit_org_id,chr(10),''),chr(13),'') as remit_org_id
      ,replace(replace(remit_org_name,chr(10),''),chr(13),'') as remit_org_name
      ,replace(replace(remit_tell_id,chr(10),''),chr(13),'') as remit_tell_id
      ,replace(replace(sign_ceph_num,chr(10),''),chr(13),'') as sign_ceph_num
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name 
from idl.hdws_dul_d_rpts_pty_hold_prd_dtl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_hold_prd_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes