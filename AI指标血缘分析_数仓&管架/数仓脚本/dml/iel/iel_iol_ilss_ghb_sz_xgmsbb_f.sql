: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_xgmsbb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_xgmsbb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.skssqq,chr(13),''),chr(10),'') as skssqq
,replace(replace(t.skssqz,chr(13),''),chr(10),'') as skssqz
,replace(replace(t.sbrq,chr(13),''),chr(10),'') as sbrq
,t.ewblxh as ewblxh
,replace(replace(t.lmc,chr(13),''),chr(10),'') as lmc
,t.ynsehj as ynsehj
,t.bqmse as bqmse
,t.bqybtse as bqybtse
,t.bqyjse as bqyjse
,t.bqynse as bqynse
,t.hdynse as hdynse
,t.wdqzdmse as wdqzdmse
,t.xwqymse as xwqymse
,t.bqynsejze as bqynsejze
,t.ckmsxse as ckmsxse
,t.hdxse as hdxse
,t.msxse as msxse
,t.qtmsxse as qtmsxse
,t.skqjkjdptfpbhsxse as skqjkjdptfpbhsxse
,t.skqjkjdptfpxse as skqjkjdptfpxse
,t.swjgdkdzzszyfpbhsxse as swjgdkdzzszyfpbhsxse
,t.wdqzdxse as wdqzdxse
,t.xsczbdcbhsxse as xsczbdcbhsxse
,t.xssygdysgdzcbhsxse as xssygdysgdzcbhsxse
,t.xwqymsxse as xwqymsxse
,t.yzzzsbhsxse as yzzzsbhsxse
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_xgmsbb t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_xgmsbb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes