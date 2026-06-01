: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_coa_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_coa_relaf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.evt_id
,t.biz_sys_evt_id
,t.global_chn_seq_num
,t.txn_dt
,t.accting_coa_id
,t.db_cr_flg
,t.src_sys_cd
,t.data_src_cd
,t.etl_dt
from idl.hdws_iml_evt_coa_rela t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_coa_relaf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes