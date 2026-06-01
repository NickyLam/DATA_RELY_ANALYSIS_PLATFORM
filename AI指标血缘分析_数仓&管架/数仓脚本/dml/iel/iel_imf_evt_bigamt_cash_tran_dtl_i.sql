: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_bigamt_cash_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bigamt_cash_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.tran_card_id,chr(13),''),chr(10),'') as tran_card_id
,replace(replace(t1.dep_draw_type_cd,chr(13),''),chr(10),'') as dep_draw_type_cd
,replace(replace(t1.dep_draw_type_comnt,chr(13),''),chr(10),'') as dep_draw_type_comnt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,t1.tran_dt as tran_dt
,t1.modif_dt as modif_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.modif_teller_id,chr(13),''),chr(10),'') as modif_teller_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.bigamt_cash_precon_id,chr(13),''),chr(10),'') as bigamt_cash_precon_id
,replace(replace(t1.indus_categy_cd,chr(13),''),chr(10),'') as indus_categy_cd
,replace(replace(t1.indus_gen_cd,chr(13),''),chr(10),'') as indus_gen_cd
,replace(replace(t1.indus_middle_class_cd,chr(13),''),chr(10),'') as indus_middle_class_cd
,replace(replace(t1.indus_sclass_cd,chr(13),''),chr(10),'') as indus_sclass_cd
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,t1.redt_amt_tot as redt_amt_tot
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.agent_type_cd,chr(13),''),chr(10),'') as agent_type_cd
,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'') as agent_cert_type_cd
,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,t1.tran_tm as tran_tm
from ${iml_schema}.evt_bigamt_cash_tran_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bigamt_cash_tran_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes