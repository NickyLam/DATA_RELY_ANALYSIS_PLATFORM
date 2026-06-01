: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_bill_redcst_batch_f
CreateDate: 20230804
FileName:   ${iel_data_path}/agt_bill_redcst_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
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
,appl_dt
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
,bill_cnt
,bill_tot
,repo_amt
,hold_tenor
,replace(replace(t1.clear_speed_cd,chr(13),''),chr(10),'') as clear_speed_cd
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,stl_amt
,exp_stl_amt
,stl_dt
,exp_stl_dt
,int_rat
,int_paybl
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.apv_rest_cd,chr(13),''),chr(10),'') as apv_rest_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.msg_status_cd,chr(13),''),chr(10),'') as msg_status_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,final_modif_tm
,replace(replace(t1.creator_id,chr(13),''),chr(10),'') as creator_id
,create_dt
,update_dt

from ${iml_schema}.agt_bill_redcst_batch t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_redcst_batch.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
