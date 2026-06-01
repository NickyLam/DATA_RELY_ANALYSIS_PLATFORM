: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1utjgptsignacct_f
CreateDate: 20240220
FileName:   ${iel_data_path}/mpcs_a1utjgptsignacct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.syscd,chr(13),''),chr(10),'') as syscd
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.accountname,chr(13),''),chr(10),'') as accountname
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.signdate,chr(13),''),chr(10),'') as signdate
,replace(replace(t1.signtime,chr(13),''),chr(10),'') as signtime
,replace(replace(t1.offdate,chr(13),''),chr(10),'') as offdate
,replace(replace(t1.offtime,chr(13),''),chr(10),'') as offtime
,replace(replace(t1.oprbrn,chr(13),''),chr(10),'') as oprbrn
,replace(replace(t1.oprtlr,chr(13),''),chr(10),'') as oprtlr
,replace(replace(t1.chkbrn,chr(13),''),chr(10),'') as chkbrn
,replace(replace(t1.chktlr,chr(13),''),chr(10),'') as chktlr
,replace(replace(t1.autbrn,chr(13),''),chr(10),'') as autbrn
,replace(replace(t1.auttlr,chr(13),''),chr(10),'') as auttlr
,replace(replace(t1.companyname,chr(13),''),chr(10),'') as companyname
,replace(replace(t1.projectname,chr(13),''),chr(10),'') as projectname
,replace(replace(t1.contactnum,chr(13),''),chr(10),'') as contactnum
,replace(replace(t1.telphome,chr(13),''),chr(10),'') as telphome
,replace(replace(t1.opbankname,chr(13),''),chr(10),'') as opbankname
,replace(replace(t1.opbankcode,chr(13),''),chr(10),'') as opbankcode
,replace(replace(t1.remarks,chr(13),''),chr(10),'') as remarks
,replace(replace(t1.accountstatus,chr(13),''),chr(10),'') as accountstatus
,replace(replace(t1.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t1.sndflag,chr(13),''),chr(10),'') as sndflag
,replace(replace(t1.returncode,chr(13),''),chr(10),'') as returncode
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.openbrn,chr(13),''),chr(10),'') as openbrn
,replace(replace(t1.historicalflag,chr(13),''),chr(10),'') as historicalflag
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t1.xzqhbm,chr(13),''),chr(10),'') as xzqhbm
,replace(replace(t1.updt,chr(13),''),chr(10),'') as updt

from ${iol_schema}.mpcs_a1utjgptsignacct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1utjgptsignacct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
