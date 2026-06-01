: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_bd_account_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_bd_account.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,acclev
,accproperty
,replace(replace(t1.balancetype,chr(13),''),chr(10),'') as balancetype
,replace(replace(t1.balanflag,chr(13),''),chr(10),'') as balanflag
,balanorient
,replace(replace(t1.bankacc,chr(13),''),chr(10),'') as bankacc
,replace(replace(t1.billdate,chr(13),''),chr(10),'') as billdate
,replace(replace(t1.billnumber,chr(13),''),chr(10),'') as billnumber
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype
,replace(replace(t1.bothorient,chr(13),''),chr(10),'') as bothorient
,cashtype
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.combineform,chr(13),''),chr(10),'') as combineform
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,dataoriginflag
,dr
,enablestate
,replace(replace(t1.incurflag,chr(13),''),chr(10),'') as incurflag
,replace(replace(t1.inneracc,chr(13),''),chr(10),'') as inneracc
,replace(replace(t1.innercode,chr(13),''),chr(10),'') as innercode
,replace(replace(t1.innerinfo,chr(13),''),chr(10),'') as innerinfo
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.name2,chr(13),''),chr(10),'') as name2
,replace(replace(t1.name3,chr(13),''),chr(10),'') as name3
,replace(replace(t1.name4,chr(13),''),chr(10),'') as name4
,replace(replace(t1.name5,chr(13),''),chr(10),'') as name5
,replace(replace(t1.name6,chr(13),''),chr(10),'') as name6
,replace(replace(t1.nparallelaccounts,chr(13),''),chr(10),'') as nparallelaccounts
,replace(replace(t1.outflag,chr(13),''),chr(10),'') as outflag
,replace(replace(t1.parallelaccounts,chr(13),''),chr(10),'') as parallelaccounts
,replace(replace(t1.pid,chr(13),''),chr(10),'') as pid
,replace(replace(t1.pk_accchart,chr(13),''),chr(10),'') as pk_accchart
,replace(replace(t1.pk_account,chr(13),''),chr(10),'') as pk_account
,replace(replace(t1.pk_acctype,chr(13),''),chr(10),'') as pk_acctype
,replace(replace(t1.pk_originalaccount,chr(13),''),chr(10),'') as pk_originalaccount
,replace(replace(t1.price,chr(13),''),chr(10),'') as price
,replace(replace(t1.quantity,chr(13),''),chr(10),'') as quantity
,replace(replace(t1.remcode,chr(13),''),chr(10),'') as remcode
,sumprint_level
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.unit,chr(13),''),chr(10),'') as unit
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_bd_account t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_bd_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
