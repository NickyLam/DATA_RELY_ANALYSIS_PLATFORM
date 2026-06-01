: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_indv_pty_iden_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_indv_pty_iden_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,etl_dt
      ,replace(replace(iden_typ_cd,chr(10),''),chr(13),'') as iden_typ_cd
      ,replace(replace(iden_num,chr(10),''),chr(13),'') as iden_num
      ,iden_eff_dt
      ,iden_due_dt
      ,replace(replace(iden_issue_org,chr(10),''),chr(13),'') as iden_issue_org
      ,replace(replace(iden_issue_pla,chr(10),''),chr(13),'') as iden_issue_pla
      ,replace(replace(iden_issue_cty_cd,chr(10),''),chr(13),'') as iden_issue_cty_cd
      ,replace(replace(open_iden_flg,chr(10),''),chr(13),'') as open_iden_flg
      ,replace(replace(prim_iden_flg,chr(10),''),chr(13),'') as prim_iden_flg
      ,replace(replace(iden_status_cd,chr(10),''),chr(13),'') as iden_status_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_pty_indv_pty_iden_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_indv_pty_iden_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes