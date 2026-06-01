: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_pty_indv_pty_iden_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_pty_indv_pty_iden_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.pty_id,chr(13),''),chr(10),'') as pty_id
    ,t.etl_dt_ora as etl_dt_ora
    ,replace(replace(t.iden_typ_cd,chr(13),''),chr(10),'') as iden_typ_cd
    ,replace(replace(t.iden_num,chr(13),''),chr(10),'') as iden_num
    ,t.iden_eff_dt as iden_eff_dt
    ,t.iden_due_dt as iden_due_dt
    ,replace(replace(t.iden_issue_org,chr(13),''),chr(10),'') as iden_issue_org
    ,replace(replace(t.iden_issue_pla,chr(13),''),chr(10),'') as iden_issue_pla
    ,replace(replace(t.iden_issue_cty_cd,chr(13),''),chr(10),'') as iden_issue_cty_cd
    ,replace(replace(t.open_iden_flg,chr(13),''),chr(10),'') as open_iden_flg
    ,replace(replace(t.prim_iden_flg,chr(13),''),chr(10),'') as prim_iden_flg
    ,replace(replace(t.iden_status_cd,chr(13),''),chr(10),'') as iden_status_cd
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
from iol.rcds_src_dw_pty_indv_pty_iden_info t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_pty_indv_pty_iden_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes