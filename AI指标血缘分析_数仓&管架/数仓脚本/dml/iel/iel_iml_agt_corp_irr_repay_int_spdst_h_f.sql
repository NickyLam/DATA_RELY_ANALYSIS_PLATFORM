: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_irr_repay_int_spdst_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_corp_irr_repay_int_spdst_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,t.exec_dt as exec_dt
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.value_dt as value_dt
    ,t.acru_nomal_pric as acru_nomal_pric
    ,t.curr_issue_recvbl_pric as curr_issue_recvbl_pric
    ,t.curr_issue_int_recvbl as curr_issue_int_recvbl
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_corp_irr_repay_int_spdst_h t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_irr_repay_int_spdst_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes