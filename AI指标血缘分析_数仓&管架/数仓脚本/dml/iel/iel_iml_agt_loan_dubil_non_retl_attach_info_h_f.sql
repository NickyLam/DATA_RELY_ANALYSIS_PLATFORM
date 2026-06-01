: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_dubil_non_retl_attach_info_h_f
CreateDate: 20250516
FileName:   ${iel_data_path}/agt_loan_dubil_non_retl_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,wrtoff_dt
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.benefc_open_bank_no,chr(13),''),chr(10),'') as benefc_open_bank_no
,replace(replace(t1.bnft_bank_name,chr(13),''),chr(10),'') as bnft_bank_name
,replace(replace(t1.pre_recv_int_flg,chr(13),''),chr(10),'') as pre_recv_int_flg
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,ped
,surp_perds
,eh_issue_deduct_amt
,advc_amt
,replace(replace(t1.wrtoff_type_cd,chr(13),''),chr(10),'') as wrtoff_type_cd
,replace(replace(t1.wrtoff_flow_num,chr(13),''),chr(10),'') as wrtoff_flow_num
,replace(replace(t1.open_flow_num,chr(13),''),chr(10),'') as open_flow_num
,open_dt
,fee_rat
,replace(replace(t1.benefc_open_bank_name,chr(13),''),chr(10),'') as benefc_open_bank_name
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,replace(replace(t1.attach_rgst_dubil_flg,chr(13),''),chr(10),'') as attach_rgst_dubil_flg
,acm_rtn_pric
,acm_rtn_int
,next_term_rpp_dt
,next_term_rpp_amt
,next_term_repay_int_dt
,next_term_repay_int_amt
,replace(replace(t1.matn_flg,chr(13),''),chr(10),'') as matn_flg
,replace(replace(t1.attach_rgst_check_teller_id,chr(13),''),chr(10),'') as attach_rgst_check_teller_id
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bill_kind_cd,chr(13),''),chr(10),'') as bill_kind_cd
,replace(replace(t1.batch_data_src_cd,chr(13),''),chr(10),'') as batch_data_src_cd
,replace(replace(t1.acpt_bank_no,chr(13),''),chr(10),'') as acpt_bank_no
,replace(replace(t1.acpt_bank_name,chr(13),''),chr(10),'') as acpt_bank_name
,replace(replace(t1.bill_uniq_ind_no,chr(13),''),chr(10),'') as bill_uniq_ind_no
,replace(replace(t1.transf_type_cd,chr(13),''),chr(10),'') as transf_type_cd
,discount_int_rat
,replace(replace(t1.dir_paste_bank_no,chr(13),''),chr(10),'') as dir_paste_bank_no
,replace(replace(t1.dir_paste_bank_name,chr(13),''),chr(10),'') as dir_paste_bank_name
,replace(replace(t1.refac_status_cd,chr(13),''),chr(10),'') as refac_status_cd
,replace(replace(t1.refac_batch_pkg_id,chr(13),''),chr(10),'') as refac_batch_pkg_id
,refac_batch_exp_dt
,refac_invalid_tm
,replace(replace(t1.edu_hea_flg,chr(13),''),chr(10),'') as edu_hea_flg
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.dep_agt_id,chr(13),''),chr(10),'') as dep_agt_id

from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_dubil_non_retl_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
