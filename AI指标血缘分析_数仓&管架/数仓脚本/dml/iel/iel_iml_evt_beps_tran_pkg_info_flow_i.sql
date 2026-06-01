: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_beps_tran_pkg_info_flow_i
CreateDate: 20230606
FileName:   ${iel_data_path}/evt_beps_tran_pkg_info_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pkg_seq_num,chr(13),''),chr(10),'') as pkg_seq_num
,pkg_entr_dt
,replace(replace(t1.pkg_init_clear_bk_no,chr(13),''),chr(10),'') as pkg_init_clear_bk_no
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.pkg_init_clear_bk_rg_cd,chr(13),''),chr(10),'') as pkg_init_clear_bk_rg_cd
,replace(replace(t1.pkg_recv_clear_bk_no,chr(13),''),chr(10),'') as pkg_recv_clear_bk_no
,replace(replace(t1.pkg_recv_clear_bk_rg_code,chr(13),''),chr(10),'') as pkg_recv_clear_bk_rg_code
,tran_dt
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,replace(replace(t1.bank_int_proc_status_cd,chr(13),''),chr(10),'') as bank_int_proc_status_cd
,rtn_rcpt_day_tenor
,rtn_rcpt_dt
,tot
,tot_amt
,sucs_cnt
,sucs_amt
,fail_cnt
,fail_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,offs_bal_num_site
,offs_bal_dt
,replace(replace(t1.reissue_flg,chr(13),''),chr(10),'') as reissue_flg
,clear_dt
,replace(replace(t1.brac_org_id,chr(13),''),chr(10),'') as brac_org_id
,replace(replace(t1.pkg_tran_status_cd,chr(13),''),chr(10),'') as pkg_tran_status_cd
,replace(replace(t1.cont_pkg_idf_cd,chr(13),''),chr(10),'') as cont_pkg_idf_cd
,replace(replace(t1.init_pkg_init_clear_bk_no,chr(13),''),chr(10),'') as init_pkg_init_clear_bk_no
,init_pkg_entr_dt
,replace(replace(t1.init_pkg_midgrod_flow_num,chr(13),''),chr(10),'') as init_pkg_midgrod_flow_num
,replace(replace(t1.init_pkg_seq_num,chr(13),''),chr(10),'') as init_pkg_seq_num
,replace(replace(t1.reg_bus_batch_no,chr(13),''),chr(10),'') as reg_bus_batch_no
,replace(replace(t1.init_pkg_proc_status_cd,chr(13),''),chr(10),'') as init_pkg_proc_status_cd
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.send_flow_num,chr(13),''),chr(10),'') as send_flow_num
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd
,check_entry_dt
,replace(replace(t1.cntpty_sys_edit_cd,chr(13),''),chr(10),'') as cntpty_sys_edit_cd
,replace(replace(t1.entry_fail_flg,chr(13),''),chr(10),'') as entry_fail_flg
,replace(replace(t1.proc_idf_cd,chr(13),''),chr(10),'') as proc_idf_cd

from ${iml_schema}.evt_beps_tran_pkg_info_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_beps_tran_pkg_info_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
