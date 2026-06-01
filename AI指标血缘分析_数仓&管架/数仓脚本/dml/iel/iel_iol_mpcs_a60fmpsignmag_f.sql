: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a60fmpsignmag_f
CreateDate: 20240724
FileName:   ${iel_data_path}/mpcs_a60fmpsignmag.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.signdate,chr(13),''),chr(10),'') as signdate
,replace(replace(t1.signtime,chr(13),''),chr(10),'') as signtime
,replace(replace(t1.oprbrn,chr(13),''),chr(10),'') as oprbrn
,replace(replace(t1.oprtlr,chr(13),''),chr(10),'') as oprtlr
,replace(replace(t1.chkbrn,chr(13),''),chr(10),'') as chkbrn
,replace(replace(t1.chktlr,chr(13),''),chr(10),'') as chktlr
,replace(replace(t1.autbrn,chr(13),''),chr(10),'') as autbrn
,replace(replace(t1.auttlr,chr(13),''),chr(10),'') as auttlr
,replace(replace(t1.bankaccount,chr(13),''),chr(10),'') as bankaccount
,replace(replace(t1.presalecode,chr(13),''),chr(10),'') as presalecode
,replace(replace(t1.companyname,chr(13),''),chr(10),'') as companyname
,replace(replace(t1.projectname,chr(13),''),chr(10),'') as projectname
,replace(replace(t1.contactnum,chr(13),''),chr(10),'') as contactnum
,replace(replace(t1.contactadd,chr(13),''),chr(10),'') as contactadd
,replace(replace(t1.recommend,chr(13),''),chr(10),'') as recommend
,replace(replace(t1.remarks,chr(13),''),chr(10),'') as remarks

from ${iol_schema}.mpcs_a60fmpsignmag t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a60fmpsignmag.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
