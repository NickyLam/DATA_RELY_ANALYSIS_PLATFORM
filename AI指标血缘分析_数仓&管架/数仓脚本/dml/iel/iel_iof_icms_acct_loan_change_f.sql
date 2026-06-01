: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_acct_loan_change_f
CreateDate: 20260126
FileName:   ${iel_data_path}/icms_acct_loan_change.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,replace(replace(t1.oldmaturitydate,chr(13),''),chr(10),'') as oldmaturitydate
,replace(replace(t1.loantermunit,chr(13),''),chr(10),'') as loantermunit
,loanterm
,replace(replace(t1.oldloantermunit,chr(13),''),chr(10),'') as oldloantermunit
,oldloanterm
,replace(replace(t1.accountingorgid,chr(13),''),chr(10),'') as accountingorgid
,replace(replace(t1.oldaccountingorgid,chr(13),''),chr(10),'') as oldaccountingorgid
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.defaultdueday,chr(13),''),chr(10),'') as defaultdueday
,replace(replace(t1.ratechangeflag,chr(13),''),chr(10),'') as ratechangeflag
,replace(replace(t1.olddefaultdueday,chr(13),''),chr(10),'') as olddefaultdueday
,replace(replace(t1.fbfromdate,chr(13),''),chr(10),'') as fbfromdate
,replace(replace(t1.fbtodate,chr(13),''),chr(10),'') as fbtodate
,replace(replace(t1.revertflag,chr(13),''),chr(10),'') as revertflag
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t1.attribute5,chr(13),''),chr(10),'') as attribute5
,replace(replace(t1.attribute6,chr(13),''),chr(10),'') as attribute6
,replace(replace(t1.attribute7,chr(13),''),chr(10),'') as attribute7
,replace(replace(t1.attribute8,chr(13),''),chr(10),'') as attribute8
,replace(replace(t1.attribute9,chr(13),''),chr(10),'') as attribute9
,replace(replace(t1.attribute10,chr(13),''),chr(10),'') as attribute10
,replace(replace(t1.attribute11,chr(13),''),chr(10),'') as attribute11
,replace(replace(t1.accruedate,chr(13),''),chr(10),'') as accruedate
,replace(replace(t1.accountno,chr(13),''),chr(10),'') as accountno
,replace(replace(t1.attribute12,chr(13),''),chr(10),'') as attribute12
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.attribute13,chr(13),''),chr(10),'') as attribute13
,replace(replace(t1.attribute14,chr(13),''),chr(10),'') as attribute14
,replace(replace(t1.attribute15,chr(13),''),chr(10),'') as attribute15
,replace(replace(t1.attribute16,chr(13),''),chr(10),'') as attribute16
,replace(replace(t1.attribute17,chr(13),''),chr(10),'') as attribute17
,replace(replace(t1.attribute18,chr(13),''),chr(10),'') as attribute18
,replace(replace(t1.attribute19,chr(13),''),chr(10),'') as attribute19
,replace(replace(t1.attribute20,chr(13),''),chr(10),'') as attribute20
,replace(replace(t1.attribute21,chr(13),''),chr(10),'') as attribute21
,replace(replace(t1.attribute22,chr(13),''),chr(10),'') as attribute22
,replace(replace(t1.attribute23,chr(13),''),chr(10),'') as attribute23
,replace(replace(t1.attribute24,chr(13),''),chr(10),'') as attribute24
,replace(replace(t1.attribute25,chr(13),''),chr(10),'') as attribute25
,replace(replace(t1.attribute26,chr(13),''),chr(10),'') as attribute26
,replace(replace(t1.finalmerger,chr(13),''),chr(10),'') as finalmerger
,replace(replace(t1.attribute27,chr(13),''),chr(10),'') as attribute27
,replace(replace(t1.attribute28,chr(13),''),chr(10),'') as attribute28
,replace(replace(t1.attribute29,chr(13),''),chr(10),'') as attribute29
,replace(replace(t1.attribute30,chr(13),''),chr(10),'') as attribute30
,replace(replace(t1.attribute31,chr(13),''),chr(10),'') as attribute31
,replace(replace(t1.attribute32,chr(13),''),chr(10),'') as attribute32
,replace(replace(t1.attribute33,chr(13),''),chr(10),'') as attribute33
,replace(replace(t1.transferinterest,chr(13),''),chr(10),'') as transferinterest
,replace(replace(t1.termchangetype,chr(13),''),chr(10),'') as termchangetype

from ${iol_schema}.icms_acct_loan_change t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_acct_loan_change.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
