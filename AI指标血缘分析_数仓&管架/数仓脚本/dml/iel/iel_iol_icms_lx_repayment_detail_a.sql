: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_lx_repayment_detail_a
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_repayment_detail.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.assetid,chr(13),''),chr(10),'') as assetid
,replace(replace(t1.capitalloanno,chr(13),''),chr(10),'') as capitalloanno
,replace(replace(t1.repayterm,chr(13),''),chr(10),'') as repayterm
,replace(replace(t1.repaymenttype,chr(13),''),chr(10),'') as repaymenttype
,replace(replace(t1.settledate,chr(13),''),chr(10),'') as settledate
,replace(replace(t1.realamounttotal,chr(13),''),chr(10),'') as realamounttotal
,replace(replace(t1.lxbusinesssum,chr(13),''),chr(10),'') as lxbusinesssum
,replace(replace(t1.lxintamt,chr(13),''),chr(10),'') as lxintamt
,replace(replace(t1.lxqodpamt,chr(13),''),chr(10),'') as lxqodpamt
,replace(replace(t1.guarantyfee,chr(13),''),chr(10),'') as guarantyfee
,replace(replace(t1.simulationfee,chr(13),''),chr(10),'') as simulationfee
,replace(replace(t1.creditassessfee,chr(13),''),chr(10),'') as creditassessfee
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.repaymentacctype,chr(13),''),chr(10),'') as repaymentacctype
,replace(replace(t1.repayacctno,chr(13),''),chr(10),'') as repayacctno
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.repaydate,chr(13),''),chr(10),'') as repaydate

from ${iol_schema}.icms_lx_repayment_detail t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_repayment_detail.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
