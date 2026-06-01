: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_bill_discount_click_bag_batch_i
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_bill_discount_click_bag_batch.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_ser_num,chr(13),''),chr(10),'') as batch_ser_num
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,bus_dt
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.anony_flg,chr(13),''),chr(10),'') as anony_flg
,replace(replace(t1.tran_range_cd,chr(13),''),chr(10),'') as tran_range_cd
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bill_attr_cd,chr(13),''),chr(10),'') as bill_attr_cd
,replace(replace(t1.part_bag_option_flg,chr(13),''),chr(10),'') as part_bag_option_flg
,quot_valid_tm
,stop_stl_tm
,replace(replace(t1.clear_speed_cd,chr(13),''),chr(10),'') as clear_speed_cd
,bill_cnt
,bill_tot
,yld_rat
,weight_avg_surp_tenor
,stl_amt
,discnt_int_rat
,int_paybl
,stl_dt
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd
,replace(replace(t1.cntpty_clear_mode,chr(13),''),chr(10),'') as cntpty_clear_mode
,replace(replace(t1.cntpty_org_cd,chr(13),''),chr(10),'') as cntpty_org_cd
,replace(replace(t1.cntpty_non_lp_prod_id,chr(13),''),chr(10),'') as cntpty_non_lp_prod_id
,replace(replace(t1.cntpty_tran_teller_id,chr(13),''),chr(10),'') as cntpty_tran_teller_id
,replace(replace(t1.pay_cfm_flg,chr(13),''),chr(10),'') as pay_cfm_flg
,shortest_surp_tenor
,lont_surp_tenor
,bill_exp_begin_day
,bill_exp_stop_day
,min_singl_fac_val_amt
,replace(replace(t1.crdt_main_type_cd,chr(13),''),chr(10),'') as crdt_main_type_cd
,replace(replace(t1.crdt_main_code,chr(13),''),chr(10),'') as crdt_main_code
,replace(replace(t1.cntpty_type_cd,chr(13),''),chr(10),'') as cntpty_type_cd
,replace(replace(t1.acpt_bank_type_cd,chr(13),''),chr(10),'') as acpt_bank_type_cd
,replace(replace(t1.acpt_bank_id,chr(13),''),chr(10),'') as acpt_bank_id
,replace(replace(t1.discnt_bank_type_cd,chr(13),''),chr(10),'') as discnt_bank_type_cd
,replace(replace(t1.discnt_bank_id,chr(13),''),chr(10),'') as discnt_bank_id
,replace(replace(t1.guar_incre_crdt_bk_type_cd,chr(13),''),chr(10),'') as guar_incre_crdt_bk_type_cd
,replace(replace(t1.guar_incre_crdt_bank_id,chr(13),''),chr(10),'') as guar_incre_crdt_bank_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.msg_proc_status_cd,chr(13),''),chr(10),'') as msg_proc_status_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.final_modif_tm,chr(13),''),chr(10),'') as final_modif_tm
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.ctr_nt_ser_num,chr(13),''),chr(10),'') as ctr_nt_ser_num
,replace(replace(t1.quot_bill_id,chr(13),''),chr(10),'') as quot_bill_id
,replace(replace(t1.click_bag_type_cd,chr(13),''),chr(10),'') as click_bag_type_cd
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,quot_forward_cnt
,replace(replace(t1.batch_type_cd,chr(13),''),chr(10),'') as batch_type_cd
,replace(replace(t1.ibank_crdt_lmt_ocup_status_cd,chr(13),''),chr(10),'') as ibank_crdt_lmt_ocup_status_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,start_dt
,end_dt

from ${iml_schema}.evt_bill_discount_click_bag_batch t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_discount_click_bag_batch.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
