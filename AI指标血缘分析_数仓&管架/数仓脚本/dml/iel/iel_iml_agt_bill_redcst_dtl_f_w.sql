: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_redcst_dtl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_redcst_dtl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.redcst_dtl_id,chr(13),''),chr(10),'') as redcst_dtl_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,t1.fac_val_amt as fac_val_amt
,t1.bill_exp_dt as bill_exp_dt
,t1.actl_exp_dt as actl_exp_dt
,t1.surp_tenor as surp_tenor
,t1.int_paybl as int_paybl
,t1.stl_amt as stl_amt
,t1.exp_stl_amt as exp_stl_amt
,replace(replace(t1.lmt_ocup_status_cd,chr(13),''),chr(10),'') as lmt_ocup_status_cd
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.discount_bill_flg,chr(13),''),chr(10),'') as discount_bill_flg
,replace(replace(t1.remote_bill_flg,chr(13),''),chr(10),'') as remote_bill_flg
,replace(replace(t1.policy_std_flg,chr(13),''),chr(10),'') as policy_std_flg
,replace(replace(t1.refuse_flg,chr(13),''),chr(10),'') as refuse_flg
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,t1.bill_intrv_std_amt as bill_intrv_std_amt
,replace(replace(t1.bf_split_intrv_id,chr(13),''),chr(10),'') as bf_split_intrv_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,t1.init_bill_amt as init_bill_amt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_bill_redcst_dtl t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_redcst_dtl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes