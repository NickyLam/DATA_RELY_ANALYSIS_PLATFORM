: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_batch_tran_acct_dtl_a
CreateDate: 20250212
FileName:   ${iel_data_path}/evt_batch_tran_acct_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.heat_insu_acct_flg,chr(13),''),chr(10),'') as heat_insu_acct_flg
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,clear_dt
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,tran_dt
,tran_amt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc
,replace(replace(t1.cap_froz_flow_num,chr(13),''),chr(10),'') as cap_froz_flow_num
,replace(replace(t1.memo_code,chr(13),''),chr(10),'') as memo_code
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.cntpty_tran_type_cd,chr(13),''),chr(10),'') as cntpty_tran_type_cd
,replace(replace(t1.cntpty_tran_ref_no,chr(13),''),chr(10),'') as cntpty_tran_ref_no
,replace(replace(t1.cntpty_tran_flow_num,chr(13),''),chr(10),'') as cntpty_tran_flow_num
,replace(replace(t1.cntpty_subj_id,chr(13),''),chr(10),'') as cntpty_subj_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_open_acct_org_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_prod_id,chr(13),''),chr(10),'') as cntpty_acct_prod_id
,replace(replace(t1.cntpty_acct_curr_cd,chr(13),''),chr(10),'') as cntpty_acct_curr_cd
,replace(replace(t1.cntpty_sub_acct_num,chr(13),''),chr(10),'') as cntpty_sub_acct_num
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.real_cntpty_cust_acct_num,chr(13),''),chr(10),'') as real_cntpty_cust_acct_num
,replace(replace(t1.real_cntpty_name,chr(13),''),chr(10),'') as real_cntpty_name
,replace(replace(t1.real_cntpty_acct_type_cd,chr(13),''),chr(10),'') as real_cntpty_acct_type_cd
,replace(replace(t1.real_cntpty_org_id,chr(13),''),chr(10),'') as real_cntpty_org_id
,replace(replace(t1.real_cntpty_org_name,chr(13),''),chr(10),'') as real_cntpty_org_name
,replace(replace(t1.real_cntpty_cert_no,chr(13),''),chr(10),'') as real_cntpty_cert_no
,replace(replace(t1.real_cntpty_cert_type_cd,chr(13),''),chr(10),'') as real_cntpty_cert_type_cd
,replace(replace(t1.real_tran_happ_site,chr(13),''),chr(10),'') as real_tran_happ_site
,replace(replace(t1.serv_status_descb,chr(13),''),chr(10),'') as serv_status_descb
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_descb,chr(13),''),chr(10),'') as err_descb
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_batch_tran_acct_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_batch_tran_acct_dtl.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
