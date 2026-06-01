: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_pub_tran_flow_i
CreateDate: 20251202
FileName:   ${iel_data_path}/ref_pub_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.chn_tran_flow_num,chr(13),''),chr(10),'') as chn_tran_flow_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.bank_org_id,chr(13),''),chr(10),'') as bank_org_id
,replace(replace(t1.src_chn_id,chr(13),''),chr(10),'') as src_chn_id
,replace(replace(t1.src_module_cd,chr(13),''),chr(10),'') as src_module_cd
,chn_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.evt_cate,chr(13),''),chr(10),'') as evt_cate
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,tran_amt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,bus_tran_dt
,replace(replace(t1.bus_proc_status_cd,chr(13),''),chr(10),'') as bus_proc_status_cd
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.revs_flow_num,chr(13),''),chr(10),'') as revs_flow_num
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.sign_cntpty_curr_cd,chr(13),''),chr(10),'') as sign_cntpty_curr_cd
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.init_tran_ref_no,chr(13),''),chr(10),'') as init_tran_ref_no
,replace(replace(t1.create_entry_flg,chr(13),''),chr(10),'') as create_entry_flg
,entry_spdst_start_dt
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.gl,chr(13),''),chr(10),'') as gl

from ${iml_schema}.ref_pub_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_pub_tran_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
