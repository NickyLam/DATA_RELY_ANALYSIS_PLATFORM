: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_intstl_tran_flow_evt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_intstl_tran_flow_evt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_evt_id,chr(13),''),chr(10),'') as src_evt_id
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name
,replace(replace(t1.bus_tab_flow_num,chr(13),''),chr(10),'') as bus_tab_flow_num
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.bus_teller_id,chr(13),''),chr(10),'') as bus_teller_id
,t1.tran_cmplt_tm as tran_cmplt_tm
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.auth_status_cd,chr(13),''),chr(10),'') as auth_status_cd
,replace(replace(t1.submit_status_cd,chr(13),''),chr(10),'') as submit_status_cd
,t1.check_dt as check_dt
,replace(replace(t1.auth_curr_cd,chr(13),''),chr(10),'') as auth_curr_cd
,t1.auth_amt as auth_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,replace(replace(t1.modif_teller_id,chr(13),''),chr(10),'') as modif_teller_id
,replace(replace(t1.ord_tab_flow_num,chr(13),''),chr(10),'') as ord_tab_flow_num
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.bus_belong_org_id,chr(13),''),chr(10),'') as bus_belong_org_id
,replace(replace(t1.org_idf_cd,chr(13),''),chr(10),'') as org_idf_cd
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.revs_flow_num,chr(13),''),chr(10),'') as revs_flow_num
,replace(replace(t1.revs_rs,chr(13),''),chr(10),'') as revs_rs
from ${iml_schema}.evt_intstl_tran_flow_evt t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_intstl_tran_flow_evt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes