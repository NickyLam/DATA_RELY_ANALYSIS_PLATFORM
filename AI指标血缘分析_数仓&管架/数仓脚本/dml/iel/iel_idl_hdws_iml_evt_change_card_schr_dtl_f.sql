: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_change_card_schr_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_change_card_schr_dtlf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.evt_id
,t.etl_dt
,t.trn_dt
,t.new_dpst_acct_num
,t.new_sub_num
,t.new_vchr_num
,t.new_vchr_typ_cd
,t.status_cd
,t.old_dpst_acct_num
,t.old_sub_num
,t.old_vchr_num
,t.old_vchr_typ_cd
,t.data_src_cd
,t.data_src_cd
,t.etl_task_name
from idl.hdws_iml_evt_change_card_schr_dtl t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_change_card_schr_dtlf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes