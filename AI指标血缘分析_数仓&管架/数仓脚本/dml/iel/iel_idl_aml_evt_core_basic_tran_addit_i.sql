: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_core_basic_tran_addit_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_core_basic_tran_addit.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,evt_id
,lp_id
,tran_flow_num
,tran_dt
,agent_name
,agent_cert_type_cd
,agent_cert_no
,agent_nation_cd
,agent_gender_cd
,agent_cert_exp_dt
,agent_phone
,agent_licen_issue_autho_site
,agent_type_cd
,agent_rs
,operr_cert_type_cd
,operr_cert_no
,operr_name
,memo
,comnt_remark_postsc
,ext_field_1
,ext_field_2
,ext_field_3
,ext_field_4
,ext_field_5
,ext_field_6
,ext_field_7
,ext_field_8
from idl.aml_evt_core_basic_tran_addit
where tran_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_core_basic_tran_addit.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes