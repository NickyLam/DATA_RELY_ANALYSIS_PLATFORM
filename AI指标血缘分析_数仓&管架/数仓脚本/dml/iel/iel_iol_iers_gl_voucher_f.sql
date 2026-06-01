: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_gl_voucher_f
CreateDate: 20230111
FileName:   ${iel_data_path}/iers_gl_voucher.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.addclass,chr(13),''),chr(10),'') as addclass
,replace(replace(t1.adjustperiod,chr(13),''),chr(10),'') as adjustperiod
,replace(replace(t1.approver,chr(13),''),chr(10),'') as approver
,attachment
,replace(replace(t1.billmaker,chr(13),''),chr(10),'') as billmaker
,replace(replace(t1.checkeddate,chr(13),''),chr(10),'') as checkeddate
,contrastflag
,replace(replace(t1.convertflag,chr(13),''),chr(10),'') as convertflag
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.deleteclass,chr(13),''),chr(10),'') as deleteclass
,replace(replace(t1.detailmodflag,chr(13),''),chr(10),'') as detailmodflag
,replace(replace(t1.discardflag,chr(13),''),chr(10),'') as discardflag
,dr
,replace(replace(t1.errmessage,chr(13),''),chr(10),'') as errmessage
,replace(replace(t1.errmessageh,chr(13),''),chr(10),'') as errmessageh
,replace(replace(t1.explanation,chr(13),''),chr(10),'') as explanation
,replace(replace(t1.free1,chr(13),''),chr(10),'') as free1
,replace(replace(t1.free10,chr(13),''),chr(10),'') as free10
,replace(replace(t1.free2,chr(13),''),chr(10),'') as free2
,replace(replace(t1.free3,chr(13),''),chr(10),'') as free3
,replace(replace(t1.free4,chr(13),''),chr(10),'') as free4
,replace(replace(t1.free5,chr(13),''),chr(10),'') as free5
,replace(replace(t1.free6,chr(13),''),chr(10),'') as free6
,replace(replace(t1.free7,chr(13),''),chr(10),'') as free7
,replace(replace(t1.free8,chr(13),''),chr(10),'') as free8
,replace(replace(t1.free9,chr(13),''),chr(10),'') as free9
,replace(replace(t1.isdifflag,chr(13),''),chr(10),'') as isdifflag
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.modifyclass,chr(13),''),chr(10),'') as modifyclass
,replace(replace(t1.modifyflag,chr(13),''),chr(10),'') as modifyflag
,num
,replace(replace(t1.offervoucher,chr(13),''),chr(10),'') as offervoucher
,replace(replace(t1.period,chr(13),''),chr(10),'') as period
,replace(replace(t1.pk_accountingbook,chr(13),''),chr(10),'') as pk_accountingbook
,replace(replace(t1.pk_casher,chr(13),''),chr(10),'') as pk_casher
,replace(replace(t1.pk_checked,chr(13),''),chr(10),'') as pk_checked
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_manager,chr(13),''),chr(10),'') as pk_manager
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_org_v,chr(13),''),chr(10),'') as pk_org_v
,replace(replace(t1.pk_prepared,chr(13),''),chr(10),'') as pk_prepared
,replace(replace(t1.pk_setofbook,chr(13),''),chr(10),'') as pk_setofbook
,replace(replace(t1.pk_sourcepk,chr(13),''),chr(10),'') as pk_sourcepk
,replace(replace(t1.pk_system,chr(13),''),chr(10),'') as pk_system
,replace(replace(t1.pk_voucher,chr(13),''),chr(10),'') as pk_voucher
,replace(replace(t1.pk_vouchertype,chr(13),''),chr(10),'') as pk_vouchertype
,replace(replace(t1.preaccountflag,chr(13),''),chr(10),'') as preaccountflag
,replace(replace(t1.prepareddate,chr(13),''),chr(10),'') as prepareddate
,replace(replace(t1.signdate,chr(13),''),chr(10),'') as signdate
,replace(replace(t1.signflag,chr(13),''),chr(10),'') as signflag
,replace(replace(t1.tallydate,chr(13),''),chr(10),'') as tallydate
,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'') as tempsaveflag
,totalcredit
,totalcreditglobal
,totalcreditgroup
,totaldebit
,totaldebitglobal
,totaldebitgroup
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,voucherkind
,replace(replace(t1.year,chr(13),''),chr(10),'') as year
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_gl_voucher t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_gl_voucher.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
