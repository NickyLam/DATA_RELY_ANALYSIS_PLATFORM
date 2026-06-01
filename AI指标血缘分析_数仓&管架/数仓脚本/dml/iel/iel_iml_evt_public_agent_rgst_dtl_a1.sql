: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_public_agent_rgst_dtl_a1
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_public_agent_rgst_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.agent_evt_cate_id,chr(13),''),chr(10),'') as agent_evt_cate_id
,t1.tran_amt as tran_amt
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.bus_vouch_no,chr(13),''),chr(10),'') as bus_vouch_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.public_agent_name,chr(13),''),chr(10),'') as public_agent_name
,replace(replace(t1.public_agent_cust_id,chr(13),''),chr(10),'') as public_agent_cust_id
,replace(replace(t1.public_agent_cert_no,chr(13),''),chr(10),'') as public_agent_cert_no
,replace(replace(t1.public_agent_cert_type_cd,chr(13),''),chr(10),'') as public_agent_cert_type_cd
,replace(replace(t1.public_agent_licen_issue_autho_cty_rg_cd,chr(13),''),chr(10),'') as public_agent_licen_issue_autho_cty_rg_cd
,t1.public_agent_cert_effect_dt as public_agent_cert_effect_dt
,t1.public_agent_cert_invalid_dt as public_agent_cert_invalid_dt
,replace(replace(t1.public_agent_tel_num,chr(13),''),chr(10),'') as public_agent_tel_num
,replace(replace(t1.agent_reason,chr(13),''),chr(10),'') as agent_reason
,replace(replace(t1.public_agent_rela,chr(13),''),chr(10),'') as public_agent_rela
,t1.tran_tm as tran_tm
,replace(replace(t1.agent_vrif_emply_a_id,chr(13),''),chr(10),'') as agent_vrif_emply_a_id
,replace(replace(t1.agent_vrif_emply_b_id,chr(13),''),chr(10),'') as agent_vrif_emply_b_id
,replace(replace(t1.vrif_ps_tel_num,chr(13),''),chr(10),'') as vrif_ps_tel_num
,t1.vrif_tm as vrif_tm
,replace(replace(t1.vrif_rest,chr(13),''),chr(10),'') as vrif_rest
,replace(replace(t1.agent_idf_cd,chr(13),''),chr(10),'') as agent_idf_cd
from ${iml_schema}.evt_public_agent_rgst_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_public_agent_rgst_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes