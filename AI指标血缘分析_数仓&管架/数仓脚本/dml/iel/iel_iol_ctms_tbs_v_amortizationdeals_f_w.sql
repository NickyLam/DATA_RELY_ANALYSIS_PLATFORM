: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_amortizationdeals_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_amortizationdeals_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(deal_id,chr(10),''),chr(13),'') as deal_id
,replace(replace(deal_name,chr(10),''),chr(13),'') as deal_name
,replace(replace(aspclient_id,chr(10),''),chr(13),'') as aspclient_id
,replace(replace(calcdate,chr(10),''),chr(13),'') as calcdate
,replace(replace(balance_id,chr(10),''),chr(13),'') as balance_id
,replace(replace(holdamount,chr(10),''),chr(13),'') as holdamount
,replace(replace(cleanpricecost,chr(10),''),chr(13),'') as cleanpricecost
,replace(replace(amortizeamount,chr(10),''),chr(13),'') as amortizeamount
,replace(replace(cleanpricecost2,chr(10),''),chr(13),'') as cleanpricecost2
,replace(replace(erate,chr(10),''),chr(13),'') as erate
,replace(replace(keepfolder_id,chr(10),''),chr(13),'') as keepfolder_id
,replace(replace(assettype,chr(10),''),chr(13),'') as assettype
,replace(replace(majorassetcode,chr(10),''),chr(13),'') as majorassetcode
,replace(replace(lastmodified,chr(10),''),chr(13),'') as lastmodified
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_v_amortizationdeals
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_amortizationdeals_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes