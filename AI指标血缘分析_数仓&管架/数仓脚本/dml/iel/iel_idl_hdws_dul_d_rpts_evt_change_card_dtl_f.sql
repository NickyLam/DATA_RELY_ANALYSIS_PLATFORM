: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_change_card_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_change_card_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
evt_id
,etl_dt
,trn_dt
,new_dpst_acct_num
,new_sub_num
,new_vchr_num
,new_vchr_typ_cd
,status_cd
,old_dpst_acct_num
,old_sub_num
,old_vchr_num
,old_vchr_typ_cd
,data_src_cd
,etl_task_name
from ${idl_schema}.hdws_dul_d_rpts_evt_change_card_dtl
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_change_card_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes