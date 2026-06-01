: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_redcst_batch_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_redcst_batch_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,replace(replace(t1.quot_bill_id,chr(13),''),chr(10),'') as quot_bill_id
,replace(replace(t1.appl_form_modif_rela_id,chr(13),''),chr(10),'') as appl_form_modif_rela_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,t1.appl_dt as appl_dt
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.cfm_ps_id,chr(13),''),chr(10),'') as cfm_ps_id
,replace(replace(t1.pbc_org_cd,chr(13),''),chr(10),'') as pbc_org_cd
,replace(replace(t1.pbc_org_acquirer_id,chr(13),''),chr(10),'') as pbc_org_acquirer_id
,replace(replace(t1.pbc_org_acquirer_name,chr(13),''),chr(10),'') as pbc_org_acquirer_name
,replace(replace(t1.pbc_org_checker_id,chr(13),''),chr(10),'') as pbc_org_checker_id
,replace(replace(t1.pbc_org_checker_name,chr(13),''),chr(10),'') as pbc_org_checker_name
,replace(replace(t1.pbc_org_apver_id,chr(13),''),chr(10),'') as pbc_org_apver_id
,replace(replace(t1.pbc_org_apver_name,chr(13),''),chr(10),'') as pbc_org_apver_name
,replace(replace(t1.apver_apv_opinion,chr(13),''),chr(10),'') as apver_apv_opinion
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,t1.bill_cnt as bill_cnt
,t1.bill_tot as bill_tot
,t1.repo_amt as repo_amt
,t1.hold_tenor as hold_tenor
,replace(replace(t1.clear_speed_cd,chr(13),''),chr(10),'') as clear_speed_cd
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,t1.stl_amt as stl_amt
,t1.exp_stl_amt as exp_stl_amt
,t1.stl_dt as stl_dt
,t1.exp_stl_dt as exp_stl_dt
,t1.int_rat as int_rat
,t1.int_paybl as int_paybl
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.apv_rest_cd,chr(13),''),chr(10),'') as apv_rest_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.msg_status_cd,chr(13),''),chr(10),'') as msg_status_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,t1.final_modif_tm as final_modif_tm
,replace(replace(t1.creator_id,chr(13),''),chr(10),'') as creator_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_bill_redcst_batch t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_redcst_batch_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes