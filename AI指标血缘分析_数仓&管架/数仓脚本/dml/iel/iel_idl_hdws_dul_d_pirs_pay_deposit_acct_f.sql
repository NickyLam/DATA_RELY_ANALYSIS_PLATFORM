: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pirs_pay_deposit_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pirs_pay_deposit_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_char(t1.etl_dt,'YYYY-MM-DD') as etl_dt
,replace(replace(t1.org_num,chr(13),''),chr(10),'') as org_num
,t1.acct_num as acct_num
,replace(replace(t1.cardkind,chr(13),''),chr(10),'') as cardkind
,t1.bal as bal
,replace(replace(t1.cust_typ,chr(13),''),chr(10),'') as cust_typ
,t1.elebal as elebal
from ${idl_schema}.hdws_dul_d_pirs_pay_deposit_acct t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pirs_pay_deposit_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes