: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_corp_pty_iden_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_iden.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,iden_typ_cd
,iden_num
,iden_eff_dt
,iden_due_dt
,iden_issue_org
,iden_issue_pla
,iden_issue_cty_cd
,open_iden_flg
,prim_iden_flg
,iden_status_cd
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_corp_pty_iden 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_iden.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes