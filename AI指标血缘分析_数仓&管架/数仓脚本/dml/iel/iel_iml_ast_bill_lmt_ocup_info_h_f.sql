: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_bill_lmt_ocup_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_bill_lmt_ocup_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.crdt_cont_id,chr(13),''),chr(10),'') as crdt_cont_id
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.crdt_ocup_cust_id,chr(13),''),chr(10),'') as crdt_ocup_cust_id
,replace(replace(t1.crdt_cust_mgr_teller_id,chr(13),''),chr(10),'') as crdt_cust_mgr_teller_id
,replace(replace(t1.crdt_cust_mgr_belong_org_name,chr(13),''),chr(10),'') as crdt_cust_mgr_belong_org_name
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ast_bill_lmt_ocup_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_bill_lmt_ocup_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes