: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_bd_accasoa_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_bd_accasoa.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.allowclose,chr(13),''),chr(10),'') as allowclose
,replace(replace(t1.balancetype,chr(13),''),chr(10),'') as balancetype
,replace(replace(t1.balanflag,chr(13),''),chr(10),'') as balanflag
,replace(replace(t1.bankacc,chr(13),''),chr(10),'') as bankacc
,replace(replace(t1.billdate,chr(13),''),chr(10),'') as billdate
,replace(replace(t1.billnumber,chr(13),''),chr(10),'') as billnumber
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype
,replace(replace(t1.bothorient,chr(13),''),chr(10),'') as bothorient
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.ctrlmodules,chr(13),''),chr(10),'') as ctrlmodules
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,dataoriginflag
,replace(replace(t1.def1,chr(13),''),chr(10),'') as def1
,replace(replace(t1.def2,chr(13),''),chr(10),'') as def2
,replace(replace(t1.def3,chr(13),''),chr(10),'') as def3
,replace(replace(t1.def4,chr(13),''),chr(10),'') as def4
,replace(replace(t1.def5,chr(13),''),chr(10),'') as def5
,replace(replace(t1.dispname,chr(13),''),chr(10),'') as dispname
,replace(replace(t1.dispname2,chr(13),''),chr(10),'') as dispname2
,replace(replace(t1.dispname3,chr(13),''),chr(10),'') as dispname3
,replace(replace(t1.dispname4,chr(13),''),chr(10),'') as dispname4
,replace(replace(t1.dispname5,chr(13),''),chr(10),'') as dispname5
,replace(replace(t1.dispname6,chr(13),''),chr(10),'') as dispname6
,dr
,enablestate
,replace(replace(t1.endflag,chr(13),''),chr(10),'') as endflag
,replace(replace(t1.incurflag,chr(13),''),chr(10),'') as incurflag
,replace(replace(t1.innerinfo,chr(13),''),chr(10),'') as innerinfo
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.name2,chr(13),''),chr(10),'') as name2
,replace(replace(t1.name3,chr(13),''),chr(10),'') as name3
,replace(replace(t1.name4,chr(13),''),chr(10),'') as name4
,replace(replace(t1.name5,chr(13),''),chr(10),'') as name5
,replace(replace(t1.name6,chr(13),''),chr(10),'') as name6
,replace(replace(t1.pk_accasoa,chr(13),''),chr(10),'') as pk_accasoa
,replace(replace(t1.pk_accchart,chr(13),''),chr(10),'') as pk_accchart
,replace(replace(t1.pk_account,chr(13),''),chr(10),'') as pk_account
,replace(replace(t1.price,chr(13),''),chr(10),'') as price
,replace(replace(t1.quantity,chr(13),''),chr(10),'') as quantity
,replace(replace(t1.remcode,chr(13),''),chr(10),'') as remcode
,sumprint_level
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.unit,chr(13),''),chr(10),'') as unit
,replace(replace(t1.usedesc,chr(13),''),chr(10),'') as usedesc
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_bd_accasoa t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_bd_accasoa.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
