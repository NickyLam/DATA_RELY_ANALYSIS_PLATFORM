: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pirs_pay_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pirs_pay_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_char(etl_dt,'YYYY-MM-DD')
,replace(replace(t1.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t1.tran_typ,chr(13),''),chr(10),'') as tran_typ
,t1.tran_num as tran_num
,t1.tran_amt as tran_amt
,replace(replace(t1.overbank_flg,chr(13),''),chr(10),'') as overbank_flg
,replace(replace(t1.cust_typ,chr(13),''),chr(10),'') as cust_typ
from ${idl_schema}.hdws_dul_d_pirs_pay_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pirs_pay_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes