: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_sl_appl_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_sl_appl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.flow_no,chr(13),''),chr(10),'') as flow_no
,replace(replace(t.sl_house_nature,chr(13),''),chr(10),'') as sl_house_nature
,replace(replace(t.sl_house_name,chr(13),''),chr(10),'') as sl_house_name
,replace(replace(t.is_gage_sts,chr(13),''),chr(10),'') as is_gage_sts
,replace(replace(t.house_gage_owner,chr(13),''),chr(10),'') as house_gage_owner
,replace(replace(t.o_loan_bk,chr(13),''),chr(10),'') as o_loan_bk
,t.o_loan_spls_cptl as o_loan_spls_cptl
,t.next_bk_reply_amt as next_bk_reply_amt
,replace(replace(t.sl_type,chr(13),''),chr(10),'') as sl_type
,t.transaction_amt as transaction_amt
,t.price_amt as price_amt
,t.capital_super_amt as capital_super_amt
,replace(replace(t.cus_source,chr(13),''),chr(10),'') as cus_source
,replace(replace(t.guar_com_id,chr(13),''),chr(10),'') as guar_com_id
,t.create_time as create_time
,t.update_time as update_time
from iol.heps_sl_appl_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_sl_appl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes