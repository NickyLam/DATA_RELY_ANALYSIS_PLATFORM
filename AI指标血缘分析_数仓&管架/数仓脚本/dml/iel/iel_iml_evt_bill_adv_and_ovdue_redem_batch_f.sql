: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bill_adv_and_ovdue_redem_batch_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bill_adv_and_ovdue_redem_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_batch_ser_num,chr(13),''),chr(10),'') as appl_batch_ser_num
,replace(replace(t1.redem_task_ser_num,chr(13),''),chr(10),'') as redem_task_ser_num
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.dial_quot_batch_ser_num,chr(13),''),chr(10),'') as dial_quot_batch_ser_num
,replace(replace(t1.init_bus_lmt_ocup_status_cd,chr(13),''),chr(10),'') as init_bus_lmt_ocup_status_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,t1.appl_dt as appl_dt
,replace(replace(t1.ghb_org_name,chr(13),''),chr(10),'') as ghb_org_name
,replace(replace(t1.ghb_org_id,chr(13),''),chr(10),'') as ghb_org_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_org_id,chr(13),''),chr(10),'') as cntpty_org_id
,replace(replace(t1.cntpty_bank_id,chr(13),''),chr(10),'') as cntpty_bank_id
,replace(replace(t1.cntpty_non_lp_prod_id,chr(13),''),chr(10),'') as cntpty_non_lp_prod_id
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,replace(replace(t1.redem_cate_cd,chr(13),''),chr(10),'') as redem_cate_cd
,replace(replace(t1.redem_ar_cd,chr(13),''),chr(10),'') as redem_ar_cd
,replace(replace(t1.redem_rest_cd,chr(13),''),chr(10),'') as redem_rest_cd
,replace(replace(t1.redem_intior_proc_opinion_descb,chr(13),''),chr(10),'') as redem_intior_proc_opinion_descb
,replace(replace(t1.redem_recv_proc_opinion_descb,chr(13),''),chr(10),'') as redem_recv_proc_opinion_descb
,replace(replace(t1.redem_intior_remark_descb,chr(13),''),chr(10),'') as redem_intior_remark_descb
,replace(replace(t1.redem_recv_remark_descb,chr(13),''),chr(10),'') as redem_recv_remark_descb
,replace(replace(t1.fs_proc_rest_cd,chr(13),''),chr(10),'') as fs_proc_rest_cd
,replace(replace(t1.fs_proc_opinion_descb,chr(13),''),chr(10),'') as fs_proc_opinion_descb
,replace(replace(t1.reply_idfg_cd,chr(13),''),chr(10),'') as reply_idfg_cd
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,t1.bill_tot_amt as bill_tot_amt
,t1.bill_cnt as bill_cnt
,t1.init_bus_repo_amt as init_bus_repo_amt
,t1.fst_stl_amt as fst_stl_amt
,t1.redem_stl_amt as redem_stl_amt
,t1.repo_int_rat as repo_int_rat
,t1.init_bus_int_paybl as init_bus_int_paybl
,t1.redem_int_paybl as redem_int_paybl
,t1.repo_yld_rat as repo_yld_rat
,t1.init_bus_fst_stl_amt as init_bus_fst_stl_amt
,t1.init_bus_exp_stl_dt as init_bus_exp_stl_dt
,replace(replace(t1.lmt_ocup_status_cd,chr(13),''),chr(10),'') as lmt_ocup_status_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.msg_proc_status_cd,chr(13),''),chr(10),'') as msg_proc_status_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,t1.final_modif_tm as final_modif_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_adv_and_ovdue_redem_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes