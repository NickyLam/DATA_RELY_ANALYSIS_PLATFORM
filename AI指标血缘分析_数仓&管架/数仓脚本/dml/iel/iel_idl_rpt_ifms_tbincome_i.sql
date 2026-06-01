: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ifms_tbincome_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ifms_tbincome.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cfm_date as cfm_date
,replace(replace(t1.asset_acc,chr(13),''),chr(10),'') as asset_acc
,replace(replace(t1.ta_client,chr(13),''),chr(10),'') as ta_client
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t1.share_class,chr(13),''),chr(10),'') as share_class
,replace(replace(t1.seller_code,chr(13),''),chr(10),'') as seller_code
,t1.income as income
,t1.frozen_income as frozen_income
,t1.income_new as income_new
,t1.real_vol as real_vol
,t1.frozen_vol as frozen_vol
,t1.return_fee as return_fee
,t1.return_fee_new as return_fee_new
,t1.amt1 as amt1
 from iol.ifms_tbincome T1
where cfm_date>to_char(to_date('${batch_date}','yyyymmdd')-30,'yyyymmdd') and start_dt<=to_date('${batch_date}','yyyymmdd') and end_dt>to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ifms_tbincome.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes