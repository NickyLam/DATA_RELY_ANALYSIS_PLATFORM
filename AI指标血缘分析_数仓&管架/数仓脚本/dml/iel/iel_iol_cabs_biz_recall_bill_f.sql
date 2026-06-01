: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cabs_biz_recall_bill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cabs_biz_recall_bill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.account,chr(13),''),chr(10),'') as account
    ,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
    ,replace(replace(t.curr_flag,chr(13),''),chr(10),'') as curr_flag
    ,replace(replace(t.clerk_mobile,chr(13),''),chr(10),'') as clerk_mobile
    ,replace(replace(t.message,chr(13),''),chr(10),'') as message
    ,replace(replace(t.no_sign,chr(13),''),chr(10),'') as no_sign
    ,replace(replace(t.org_code,chr(13),''),chr(10),'') as org_code
    ,replace(replace(t.oper_clerk,chr(13),''),chr(10),'') as oper_clerk
    ,t.oper_date as oper_date
    ,replace(replace(t.oper_rlt,chr(13),''),chr(10),'') as oper_rlt
    ,replace(replace(t.bill_no,chr(13),''),chr(10),'') as bill_no
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_address,chr(13),''),chr(10),'') as cust_address
    ,replace(replace(t.acc_nanme,chr(13),''),chr(10),'') as acc_nanme
    ,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
    ,t.balance as balance
    ,replace(replace(t.brs_fqcy,chr(13),''),chr(10),'') as brs_fqcy
    ,replace(replace(t.term_no,chr(13),''),chr(10),'') as term_no
from iol.cabs_biz_recall_bill t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cabs_biz_recall_bill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes