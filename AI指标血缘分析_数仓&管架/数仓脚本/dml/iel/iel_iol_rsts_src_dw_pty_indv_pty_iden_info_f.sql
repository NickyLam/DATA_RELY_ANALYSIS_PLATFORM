: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_src_dw_pty_indv_pty_iden_info_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_src_dw_pty_indv_pty_iden_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,etl_dt_ora
,replace(replace(t1.iden_typ_cd,chr(13),''),chr(10),'') as iden_typ_cd
,replace(replace(t1.iden_num,chr(13),''),chr(10),'') as iden_num
,iden_eff_dt
,iden_due_dt
,replace(replace(t1.iden_issue_org,chr(13),''),chr(10),'') as iden_issue_org
,replace(replace(t1.iden_issue_pla,chr(13),''),chr(10),'') as iden_issue_pla
,replace(replace(t1.iden_issue_cty_cd,chr(13),''),chr(10),'') as iden_issue_cty_cd
,replace(replace(t1.open_iden_flg,chr(13),''),chr(10),'') as open_iden_flg
,replace(replace(t1.prim_iden_flg,chr(13),''),chr(10),'') as prim_iden_flg
,replace(replace(t1.iden_status_cd,chr(13),''),chr(10),'') as iden_status_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg

from ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_src_dw_pty_indv_pty_iden_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
