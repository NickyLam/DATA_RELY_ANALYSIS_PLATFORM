: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_core_basic_tran_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_core_basic_tran.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,evt_id
,lp_id
,tran_dt
,tran_flow_num
,tran_tm
,tran_kind_cd
,tran_code
,tran_chn_id
,tran_org_id
,termn_id
,tran_teller_id
,check_teller_id
,auth_teller_id
,bal_chk_flg
,tran_status_cd
,ova_flow_num
,ext_flow_num
from idl.aml_evt_core_basic_tran
where tran_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_core_basic_tran.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes