: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_batch_open_info_dtl_rgst_b_f
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_batch_open_info_dtl_rgst_b.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_subdv_type_cd,chr(13),''),chr(10),'') as cust_subdv_type_cd
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,open_dt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.card_draw_way_cd,chr(13),''),chr(10),'') as card_draw_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.begin_card_no,chr(13),''),chr(10),'') as begin_card_no
,replace(replace(t1.termnt_card_no,chr(13),''),chr(10),'') as termnt_card_no
,replace(replace(t1.card_psbook_idf_cd,chr(13),''),chr(10),'') as card_psbook_idf_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,replace(replace(t1.general_storage_flg,chr(13),''),chr(10),'') as general_storage_flg
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.vouch_prefix,chr(13),''),chr(10),'') as vouch_prefix
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,tran_amt
,replace(replace(t1.wdraw_way_cd,chr(13),''),chr(10),'') as wdraw_way_cd
,replace(replace(t1.tran_revd_flg,chr(13),''),chr(10),'') as tran_revd_flg
,replace(replace(t1.batch_proc_status_cd,chr(13),''),chr(10),'') as batch_proc_status_cd
,tran_tm
,replace(replace(t1.batch_open_type_cd,chr(13),''),chr(10),'') as batch_open_type_cd
,replace(replace(t1.memo_code,chr(13),''),chr(10),'') as memo_code
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.tran_remark_descb,chr(13),''),chr(10),'') as tran_remark_descb
,replace(replace(t1.dep_char_cd,chr(13),''),chr(10),'') as dep_char_cd
,replace(replace(t1.allow_sell_check_flg,chr(13),''),chr(10),'') as allow_sell_check_flg

from ${iml_schema}.evt_batch_open_info_dtl_rgst_b t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_batch_open_info_dtl_rgst_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
