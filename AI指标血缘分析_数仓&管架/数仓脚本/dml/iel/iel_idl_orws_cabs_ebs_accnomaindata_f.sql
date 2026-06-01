: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_cabs_ebs_accnomaindata_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_cabs_ebs_accnomaindata.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.autoid as autoid
,replace(replace(t.voucherno,chr(13),''),chr(10),'') as voucherno
,replace(replace(t.accno,chr(13),''),chr(10),'') as accno
,replace(replace(t.accnoson,chr(13),''),chr(10),'') as accnoson
,replace(replace(t.accnoindex,chr(13),''),chr(10),'') as accnoindex
,t.credit as credit
,t.totalamount_month as totalamount_month
,t.maxamount_month as maxamount_month
,t.avbalance_month as avbalance_month
,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t.checkflag,chr(13),''),chr(10),'') as checkflag
,replace(replace(t.finalcheckflag,chr(13),''),chr(10),'') as finalcheckflag
,replace(replace(t.sendmode,chr(13),''),chr(10),'') as sendmode
,replace(replace(t.acccycle,chr(13),''),chr(10),'') as acccycle
,replace(replace(t.signflag,chr(13),''),chr(10),'') as signflag
,replace(replace(t.sealaccno,chr(13),''),chr(10),'') as sealaccno
,replace(replace(t.acctype,chr(13),''),chr(10),'') as acctype
,replace(replace(t.subjectno,chr(13),''),chr(10),'') as subjectno
,replace(replace(t.keyflag,chr(13),''),chr(10),'') as keyflag
,replace(replace(t.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t.saveloanflag,chr(13),''),chr(10),'') as saveloanflag
,replace(replace(t.productno,chr(13),''),chr(10),'') as productno
,replace(replace(t.productdesc,chr(13),''),chr(10),'') as productdesc
,replace(replace(t.faceflag,chr(13),''),chr(10),'') as faceflag
,replace(replace(t.docdate,chr(13),''),chr(10),'') as docdate
,replace(replace(t.singleaccno,chr(13),''),chr(10),'') as singleaccno
,replace(replace(t.currtype,chr(13),''),chr(10),'') as currtype
,t.matchflag as matchflag
,replace(replace(t.idbank,chr(13),''),chr(10),'') as idbank
,replace(replace(t.idbranch,chr(13),''),chr(10),'') as idbranch
,replace(replace(t.idcenter,chr(13),''),chr(10),'') as idcenter
,replace(replace(t.bankname,chr(13),''),chr(10),'') as bankname
,replace(replace(t.yjflag,chr(13),''),chr(10),'') as yjflag
,replace(replace(t.regaddress,chr(13),''),chr(10),'') as regaddress
,replace(replace(t.acchalfyearback,chr(13),''),chr(10),'') as acchalfyearback
from iol.cabs_ebs_accnomaindata t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_cabs_ebs_accnomaindata.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes