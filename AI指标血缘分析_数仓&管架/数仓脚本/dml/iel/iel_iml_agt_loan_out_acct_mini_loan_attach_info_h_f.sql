: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_out_acct_mini_loan_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_out_acct_mini_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.recver_open_bank_cate_cd,chr(13),''),chr(10),'') as recver_open_bank_cate_cd
,replace(replace(t1.mini_loan_stl_acct_id,chr(13),''),chr(10),'') as mini_loan_stl_acct_id
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,prep_entred_tran_cnt
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.bank_int_flg,chr(13),''),chr(10),'') as bank_int_flg
,init_tran_dt
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,replace(replace(t1.loan_tenor_cd,chr(13),''),chr(10),'') as loan_tenor_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.pay_way_cd,chr(13),''),chr(10),'') as pay_way_cd
,replace(replace(t1.mini_loan_repay_num_id_one,chr(13),''),chr(10),'') as mini_loan_repay_num_id_one
,replace(replace(t1.mini_loan_repay_num_id_two,chr(13),''),chr(10),'') as mini_loan_repay_num_id_two
,replace(replace(t1.entr_pay_acct_id,chr(13),''),chr(10),'') as entr_pay_acct_id
,replace(replace(t1.entr_pay_acct_name,chr(13),''),chr(10),'') as entr_pay_acct_name
,tran_dt
,loan_repay_int_intrv
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,replace(replace(t1.out_acct_status_cd,chr(13),''),chr(10),'') as out_acct_status_cd
,replace(replace(t1.repay_comnt_descb,chr(13),''),chr(10),'') as repay_comnt_descb
,replace(replace(t1.prtcpt_deduct_flg,chr(13),''),chr(10),'') as prtcpt_deduct_flg
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,out_acct_appl_dt
,actl_out_acct_dt
,replace(replace(t1.stud_loan_prod_id,chr(13),''),chr(10),'') as stud_loan_prod_id
,replace(replace(t1.major_guartor_id,chr(13),''),chr(10),'') as major_guartor_id
,replace(replace(t1.major_guartor_name,chr(13),''),chr(10),'') as major_guartor_name
,replace(replace(t1.secd_repay_acct_name,chr(13),''),chr(10),'') as secd_repay_acct_name
,replace(replace(t1.secd_repay_acct_id,chr(13),''),chr(10),'') as secd_repay_acct_id
,forwd_tran_dt
,replace(replace(t1.forwd_tran_flow_num,chr(13),''),chr(10),'') as forwd_tran_flow_num

from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_out_acct_mini_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
