: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cds_transf_appl_h_f
CreateDate: 20240606
FileName:   ${iel_data_path}/agt_cds_transf_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.transf_id,chr(13),''),chr(10),'') as transf_id
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.core_teller_id,chr(13),''),chr(10),'') as core_teller_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,tran_tm
,dep_days
,int_accr_surp_days
,transf_tot_cosdetn
,transf_exp_dt
,replace(replace(t1.dir_transf_flg,chr(13),''),chr(10),'') as dir_transf_flg
,order_begin_dt
,tran_in_fee
,order_end_dt
,transf_pric
,transf_int_rat
,replace(replace(t1.cds_transf_type_cd,chr(13),''),chr(10),'') as cds_transf_type_cd
,replace(replace(t1.transf_status_cd,chr(13),''),chr(10),'') as transf_status_cd
,replace(replace(t1.benefc_cust_id,chr(13),''),chr(10),'') as benefc_cust_id
,transf_dt
,asign_yld_rat
,tran_out_fee
,final_modif_dt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.tran_in_cust_acct_num,chr(13),''),chr(10),'') as tran_in_cust_acct_num
,replace(replace(t1.stl_acct_sub_acct_num,chr(13),''),chr(10),'') as stl_acct_sub_acct_num
,replace(replace(t1.stl_cust_acct_num,chr(13),''),chr(10),'') as stl_cust_acct_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no

from ${iml_schema}.agt_cds_transf_appl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cds_transf_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
