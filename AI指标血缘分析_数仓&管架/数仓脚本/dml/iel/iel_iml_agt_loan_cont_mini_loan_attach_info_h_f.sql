: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_cont_mini_loan_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_cont_mini_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.stud_loan_deflt_prod_id,chr(13),''),chr(10),'') as stud_loan_deflt_prod_id
,loan_usage_tran_amt
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.comm_fee_mode_pay_cd,chr(13),''),chr(10),'') as comm_fee_mode_pay_cd
,indv_loan_comm_fee_rat
,comm_fee_amt
,replace(replace(t1.mini_loan_stl_acct_id,chr(13),''),chr(10),'') as mini_loan_stl_acct_id
,replace(replace(t1.major_guartor_name,chr(13),''),chr(10),'') as major_guartor_name
,replace(replace(t1.major_guartor_id,chr(13),''),chr(10),'') as major_guartor_id
,replace(replace(t1.secd_repay_acct_id,chr(13),''),chr(10),'') as secd_repay_acct_id
,replace(replace(t1.secd_repay_acct_name,chr(13),''),chr(10),'') as secd_repay_acct_name
,replace(replace(t1.repay_comnt_descb,chr(13),''),chr(10),'') as repay_comnt_descb
,resv_pric
,loan_ratio
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,replace(replace(t1.bank_int_flg,chr(13),''),chr(10),'') as bank_int_flg

from ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_cont_mini_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
