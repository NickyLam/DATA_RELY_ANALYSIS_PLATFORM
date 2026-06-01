: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_out_acct_ibank_ifin_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_out_acct_ibank_ifin_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.actl_finer_id,chr(13),''),chr(10),'') as actl_finer_id
,replace(replace(t1.int_accr_ped_cd,chr(13),''),chr(10),'') as int_accr_ped_cd
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.distr_acct_name,chr(13),''),chr(10),'') as distr_acct_name
,replace(replace(t1.distr_acct_open_bank_name,chr(13),''),chr(10),'') as distr_acct_open_bank_name
,replace(replace(t1.distr_acct_id,chr(13),''),chr(10),'') as distr_acct_id
,replace(replace(t1.repay_cnt_type_cd,chr(13),''),chr(10),'') as repay_cnt_type_cd

from ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_out_acct_ibank_ifin_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
