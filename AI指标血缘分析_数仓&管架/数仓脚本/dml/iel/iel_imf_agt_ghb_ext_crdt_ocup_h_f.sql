: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_ghb_ext_crdt_ocup_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_ghb_ext_crdt_ocup_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t1.apv_form_num,chr(13),''),chr(10),'') as apv_form_num
,replace(replace(t1.tran_odd_no,chr(13),''),chr(10),'') as tran_odd_no
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.intnal_vch_acct_id,chr(13),''),chr(10),'') as intnal_vch_acct_id
,replace(replace(t1.acct_acctnt_cls_cd,chr(13),''),chr(10),'') as acct_acctnt_cls_cd
,replace(replace(t1.acct_b_cate_cd,chr(13),''),chr(10),'') as acct_b_cate_cd
,replace(replace(t1.crdt_side_cust_id,chr(13),''),chr(10),'') as crdt_side_cust_id
,replace(replace(t1.crdt_side_name,chr(13),''),chr(10),'') as crdt_side_name
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,t1.occu_lmt as occu_lmt
,t1.ocup_surp_lmt as ocup_surp_lmt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_ghb_ext_crdt_ocup_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ghb_ext_crdt_ocup_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes