: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_batch_open_info_rgst_b_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_batch_open_info_rgst_b.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.batch_descb,chr(13),''),chr(10),'') as batch_descb
,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'') as tran_mode_cd
,t1.open_dt as open_dt
,replace(replace(t1.batch_open_type_cd,chr(13),''),chr(10),'') as batch_open_type_cd
,t1.batch_tot_qtty as batch_tot_qtty
,t1.batch_tot_amt as batch_tot_amt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,t1.bus_tran_dt as bus_tran_dt
,replace(replace(t1.cust_subdv_type_cd,chr(13),''),chr(10),'') as cust_subdv_type_cd
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.card_psbook_idf_cd,chr(13),''),chr(10),'') as card_psbook_idf_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.card_draw_way_cd,chr(13),''),chr(10),'') as card_draw_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.wdraw_way_cd,chr(13),''),chr(10),'') as wdraw_way_cd
,replace(replace(t1.begin_card_no,chr(13),''),chr(10),'') as begin_card_no
,replace(replace(t1.termnt_card_no,chr(13),''),chr(10),'') as termnt_card_no
,replace(replace(t1.batch_proc_status_cd,chr(13),''),chr(10),'') as batch_proc_status_cd
,t1.sucs_qtty as sucs_qtty
,t1.fail_qtty as fail_qtty
,replace(replace(t1.src_org_id,chr(13),''),chr(10),'') as src_org_id
,replace(replace(t1.target_org_id,chr(13),''),chr(10),'') as target_org_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.core_tran_teller_id,chr(13),''),chr(10),'') as core_tran_teller_id
,replace(replace(t1.src_chn_id,chr(13),''),chr(10),'') as src_chn_id
,t1.core_tran_dt as core_tran_dt
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg
,replace(replace(t1.ba_auth_flg,chr(13),''),chr(10),'') as ba_auth_flg
,replace(replace(t1.acct_apv_teller_id,chr(13),''),chr(10),'') as acct_apv_teller_id
,replace(replace(t1.ba_auth_teller_id,chr(13),''),chr(10),'') as ba_auth_teller_id
,t1.batch_begin_tm as batch_begin_tm
,t1.tran_tm as tran_tm
from ${iml_schema}.evt_batch_open_info_rgst_b t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_batch_open_info_rgst_b.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes