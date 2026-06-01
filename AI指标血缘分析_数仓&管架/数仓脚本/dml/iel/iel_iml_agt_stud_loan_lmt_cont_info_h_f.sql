: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_stud_loan_lmt_cont_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_stud_loan_lmt_cont_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id 
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
    ,replace(replace(t.cont_flow_num,chr(13),''),chr(10),'') as cont_flow_num
    ,replace(replace(t.lmt_appl_id,chr(13),''),chr(10),'') as lmt_appl_id
    ,replace(replace(t.lmt_apv_id,chr(13),''),chr(10),'') as lmt_apv_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.stud_loan_corp_id,chr(13),''),chr(10),'') as stud_loan_corp_id
    ,replace(replace(t.stud_loan_corp_name,chr(13),''),chr(10),'') as stud_loan_corp_name
    ,t.cont_amt as cont_amt
    ,t.cont_start_dt as cont_start_dt
    ,t.cont_exp_dt as cont_exp_dt
    ,replace(replace(t.tenor,chr(13),''),chr(10),'') as tenor
    ,replace(replace(t.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
    ,t.occu_lmt as occu_lmt
    ,t.surp_lmt as surp_lmt
    ,replace(replace(t.lmt_status_cd,chr(13),''),chr(10),'') as lmt_status_cd
    ,replace(replace(t.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
    ,replace(replace(t.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
    ,replace(replace(t.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
    ,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
    ,replace(replace(t.director_org_id,chr(13),''),chr(10),'') as director_org_id
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
    ,t.final_modif_dt as final_modif_dt
    ,t.lmt_actv_tm as lmt_actv_tm
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_stud_loan_lmt_cont_info_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') 
and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_stud_loan_lmt_cont_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes