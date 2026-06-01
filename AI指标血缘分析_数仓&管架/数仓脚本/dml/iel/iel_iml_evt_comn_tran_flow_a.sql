: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_comn_tran_flow_a
CreateDate: 20251217
FileName:   ${iel_data_path}/evt_comn_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.charge_doc_id,chr(13),''),chr(10),'') as charge_doc_id
,tran_dt
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.bus_type_id,chr(13),''),chr(10),'') as bus_type_id
,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd
,tran_amt
,replace(replace(t1.bus_acct_id,chr(13),''),chr(10),'') as bus_acct_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,brevs_bus_tran_dt
,replace(replace(t1.brevs_bus_tran_flow_num,chr(13),''),chr(10),'') as brevs_bus_tran_flow_num
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.evt_type_id,chr(13),''),chr(10),'') as evt_type_id
,amt_8
,amt_6
,amt_5
,replace(replace(t1.process_cd,chr(13),''),chr(10),'') as process_cd
,replace(replace(t1.cap_char_cd,chr(13),''),chr(10),'') as cap_char_cd
,replace(replace(t1.taxable_flg,chr(13),''),chr(10),'') as taxable_flg
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,core_tran_dt
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.emply_id,chr(13),''),chr(10),'') as emply_id

from ${iml_schema}.evt_comn_tran_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_comn_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
