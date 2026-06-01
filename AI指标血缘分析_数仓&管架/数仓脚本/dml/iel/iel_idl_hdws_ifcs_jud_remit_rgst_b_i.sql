: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ifcs_jud_remit_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ifcs_jud_remit_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.remit_dt
,t1.remit_flow_num
,t1.tran_flow_num
,t1.remit_way
,t1.remit_proof_type
,t1.proof_num
,t1.exec_org_cd
,t1.exec_cert_type_01
,t1.exec_cert_no_01
,t1.exec_cert_type_02
,t1.exec_cert_no_02
,t1.exec_ps_01
,t1.remit_rs
,t1.teller_no
,t1.org_no
,t1.init_froz_dt
,t1.init_froz_flow
,t1.remit_amt
,t1.exec_ps_02
,t1.remit_chn
,t1.remit_tm
from ${idl_schema}.hdws_ifcs_jud_remit_rgst_b t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ifcs_jud_remit_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes