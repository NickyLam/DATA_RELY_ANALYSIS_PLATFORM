: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_taxable_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_taxable_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.taxable_flow_num,chr(13),''),chr(10),'') as taxable_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.bus_sys_id,chr(13),''),chr(10),'') as bus_sys_id
,t1.tran_dt as tran_dt
,replace(replace(t1.sumos_seq_num,chr(13),''),chr(10),'') as sumos_seq_num
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bus_cate_cd,chr(13),''),chr(10),'') as bus_cate_cd
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,t1.tax_inc_tran_amt as tax_inc_tran_amt
,t1.tax_rat as tax_rat
,t1.tax_amt as tax_amt
,t1.exclude_tax_tran_amt as exclude_tax_tran_amt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tax_way_cd,chr(13),''),chr(10),'') as tax_way_cd
,replace(replace(t1.taxable_idf_cd,chr(13),''),chr(10),'') as taxable_idf_cd
,replace(replace(t1.tax_item_id,chr(13),''),chr(10),'') as tax_item_id
,replace(replace(t1.open_invoice_curr_cd,chr(13),''),chr(10),'') as open_invoice_curr_cd
,t1.convt_exch_rat as convt_exch_rat
,t1.net_price_convt_amt as net_price_convt_amt
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,t1.tax_lmt_convt_amt as tax_lmt_convt_amt
,replace(replace(t1.net_price_subj_id,chr(13),''),chr(10),'') as net_price_subj_id
,replace(replace(t1.tax_lmt_subj_id,chr(13),''),chr(10),'') as tax_lmt_subj_id
,replace(replace(t1.intnal_prod_id,chr(13),''),chr(10),'') as intnal_prod_id
from ${iml_schema}.evt_taxable_tran_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_taxable_tran_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes