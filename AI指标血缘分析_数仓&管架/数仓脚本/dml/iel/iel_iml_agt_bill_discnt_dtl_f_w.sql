: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_discnt_dtl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_discnt_dtl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select  
        t1.etl_dt as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.buy_dtl_id,chr(13),''),chr(10),'') as buy_dtl_id
,replace(replace(t1.buy_way_cd,chr(13),''),chr(10),'') as buy_way_cd
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.discnt_type_cd,chr(13),''),chr(10),'') as discnt_type_cd
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.city_wide_flg,chr(13),''),chr(10),'') as city_wide_flg
,replace(replace(t1.rher_name,chr(13),''),chr(10),'') as rher_name
,t1.int_accr_exp_dt as int_accr_exp_dt
,t1.defer_days as defer_days
,t1.int_accr_days as int_accr_days
,replace(replace(t1.not_ngbl_flg,chr(13),''),chr(10),'') as not_ngbl_flg
,t1.int_amt as int_amt
,replace(replace(t1.onl_clear_flg,chr(13),''),chr(10),'') as onl_clear_flg
,t1.buyer_pay_int as buyer_pay_int
,t1.actl_amt as actl_amt
,replace(replace(t1.discnt_appl_enter_acct_num,chr(13),''),chr(10),'') as discnt_appl_enter_acct_num
,replace(replace(t1.discnt_appl_enter_acct_bk_no,chr(13),''),chr(10),'') as discnt_appl_enter_acct_bk_no
,replace(replace(t1.dscnt_props_cate_cd,chr(13),''),chr(10),'') as dscnt_props_cate_cd
,replace(replace(t1.dscnt_props_name,chr(13),''),chr(10),'') as dscnt_props_name
,replace(replace(t1.dscnt_props_orgnz_cd,chr(13),''),chr(10),'') as dscnt_props_orgnz_cd
,replace(replace(t1.dscnt_props_acct_num,chr(13),''),chr(10),'') as dscnt_props_acct_num
,replace(replace(t1.dscnt_props_udtake_bk_no,chr(13),''),chr(10),'') as dscnt_props_udtake_bk_no
,replace(replace(t1.tran_cont_id,chr(13),''),chr(10),'') as tran_cont_id
,t1.entry_dt as entry_dt
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,t1.recv_dt as recv_dt
,replace(replace(t1.buy_dtl_status_cd,chr(13),''),chr(10),'') as buy_dtl_status_cd
,t1.final_modif_tm as final_modif_tm
,replace(replace(t1.modif_teller_id,chr(13),''),chr(10),'') as modif_teller_id
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.quick_discnt_status_cd,chr(13),''),chr(10),'') as quick_discnt_status_cd
,replace(replace(t1.quick_discnt_flg,chr(13),''),chr(10),'') as quick_discnt_flg
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_bill_discnt_dtl t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discnt_dtl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes