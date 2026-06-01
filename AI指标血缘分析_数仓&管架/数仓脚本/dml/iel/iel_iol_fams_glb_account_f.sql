: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_glb_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_glb_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.glacuuid,chr(13),''),chr(10),'') as glacuuid
,replace(replace(t1.acctname,chr(13),''),chr(10),'') as acctname
,replace(replace(t1.acctabbr,chr(13),''),chr(10),'') as acctabbr
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.booktype,chr(13),''),chr(10),'') as booktype
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,t1.lstmntdate as lstmntdate
,replace(replace(t1.acctparentid,chr(13),''),chr(10),'') as acctparentid
,t1.linkmodel as linkmodel
,t1.calyield as calyield
,replace(replace(t1.prodseries,chr(13),''),chr(10),'') as prodseries
,replace(replace(t1.prodflag,chr(13),''),chr(10),'') as prodflag
,replace(replace(t1.crttype,chr(13),''),chr(10),'') as crttype
,replace(replace(t1.innerclass1,chr(13),''),chr(10),'') as innerclass1
,t1.seriesnum as seriesnum
,replace(replace(t1.subtype,chr(13),''),chr(10),'') as subtype
,replace(replace(t1.endflag,chr(13),''),chr(10),'') as endflag
,replace(replace(t1.managemode,chr(13),''),chr(10),'') as managemode
,replace(replace(t1.measuremode,chr(13),''),chr(10),'') as measuremode
,replace(replace(t1.stockmethod,chr(13),''),chr(10),'') as stockmethod
,replace(replace(t1.amortizamethod,chr(13),''),chr(10),'') as amortizamethod
,replace(replace(t1.banbooksetsid,chr(13),''),chr(10),'') as banbooksetsid
,replace(replace(t1.finbooksetsid,chr(13),''),chr(10),'') as finbooksetsid
,replace(replace(t1.canal,chr(13),''),chr(10),'') as canal
,replace(replace(t1.fundsuse,chr(13),''),chr(10),'') as fundsuse
,replace(replace(t1.needlvl4subj,chr(13),''),chr(10),'') as needlvl4subj
,replace(replace(t1.profitmode,chr(13),''),chr(10),'') as profitmode
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_glb_account t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_glb_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes