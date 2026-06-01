: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_cc_contractinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_cc_contractinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
    ,replace(replace(t.custid,chr(13),''),chr(10),'') as custid
    ,replace(replace(t.regioncode,chr(13),''),chr(10),'') as regioncode
    ,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.mforgid,chr(13),''),chr(10),'') as mforgid
    ,replace(replace(t.custmgr,chr(13),''),chr(10),'') as custmgr
    ,replace(replace(t.credittype,chr(13),''),chr(10),'') as credittype
    ,replace(replace(t.loandirect,chr(13),''),chr(10),'') as loandirect
    ,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
    ,t.amt as amt
    ,t.balance as balance
    ,t.coveragerate as coveragerate
    ,t.assuremoney as assuremoney
    ,replace(replace(t.occurdate,chr(13),''),chr(10),'') as occurdate
    ,replace(replace(t.duedate,chr(13),''),chr(10),'') as duedate
    ,replace(replace(t.guartype,chr(13),''),chr(10),'') as guartype
    ,replace(replace(t.mainguartype,chr(13),''),chr(10),'') as mainguartype
    ,replace(replace(t.createdate,chr(13),''),chr(10),'') as createdate
    ,replace(replace(t.updatedate,chr(13),''),chr(10),'') as updatedate
    ,t.payamt as payamt
    ,replace(replace(t.fiveclass,chr(13),''),chr(10),'') as fiveclass
    ,t.balanceout as balanceout
    ,t.balancein as balancein
    ,t.balance13 as balance13
    ,replace(replace(t.squarestate,chr(13),''),chr(10),'') as squarestate
    ,replace(replace(t.tenclass,chr(13),''),chr(10),'') as tenclass
    ,replace(replace(t.reqno,chr(13),''),chr(10),'') as reqno
    ,replace(replace(t.barsign,chr(13),''),chr(10),'') as barsign
    ,replace(replace(t.creditaggreement,chr(13),''),chr(10),'') as creditaggreement
    ,replace(replace(t.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
    ,replace(replace(t.applycode,chr(13),''),chr(10),'') as applycode
    ,replace(replace(t.txtcontractno,chr(13),''),chr(10),'') as txtcontractno
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.mims_cc_contractinfo t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_cc_contractinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes