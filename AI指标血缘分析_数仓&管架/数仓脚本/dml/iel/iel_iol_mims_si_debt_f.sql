: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_si_debt_f
CreateDate: 20230919
FileName:   ${iel_data_path}/mims_si_debt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.debtcode,chr(13),''),chr(10),'') as debtcode
,replace(replace(t1.certificatecode,chr(13),''),chr(10),'') as certificatecode
,replace(replace(t1.debtname,chr(13),''),chr(10),'') as debtname
,amount
,replace(replace(t1.issuercode,chr(13),''),chr(10),'') as issuercode
,replace(replace(t1.issuername,chr(13),''),chr(10),'') as issuername
,replace(replace(t1.issuertype,chr(13),''),chr(10),'') as issuertype
,replace(replace(t1.isborrower,chr(13),''),chr(10),'') as isborrower
,replace(replace(t1.ishaveoutrating,chr(13),''),chr(10),'') as ishaveoutrating
,replace(replace(t1.outratingresult,chr(13),''),chr(10),'') as outratingresult
,replace(replace(t1.issueroutorg,chr(13),''),chr(10),'') as issueroutorg
,replace(replace(t1.issueroutresult,chr(13),''),chr(10),'') as issueroutresult
,replace(replace(t1.issuercountry,chr(13),''),chr(10),'') as issuercountry
,replace(replace(t1.issuercountryresult,chr(13),''),chr(10),'') as issuercountryresult
,replace(replace(t1.issuerresult,chr(13),''),chr(10),'') as issuerresult
,faceamount
,stoppayment
,replace(replace(t1.paytype,chr(13),''),chr(10),'') as paytype
,rate
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.isfirst,chr(13),''),chr(10),'') as isfirst
,replace(replace(t1.publishreson,chr(13),''),chr(10),'') as publishreson
,replace(replace(t1.deadlinetype,chr(13),''),chr(10),'') as deadlinetype
,replace(replace(t1.ismarket,chr(13),''),chr(10),'') as ismarket
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tdcurrency,chr(13),''),chr(10),'') as tdcurrency

from ${iol_schema}.mims_si_debt t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_si_debt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
