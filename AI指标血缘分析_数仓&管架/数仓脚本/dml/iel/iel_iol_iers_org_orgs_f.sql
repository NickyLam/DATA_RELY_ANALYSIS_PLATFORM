: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_org_orgs_f
CreateDate: 20221215
FileName:   ${iel_data_path}/iers_org_orgs.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,address
,code
,countryzone
,creationtime
,creator
,dataoriginflag
,def1
,def10
,def11
,def12
,def13
,def14
,def15
,def16
,def17
,def18
,def19
,def2
,def20
,def3
,def4
,def5
,def6
,def7
,def8
,def9
,dr
,enablestate
,innercode
,isbusinessunit
,islastversion
,memo
,mnecode
,modifiedtime
,modifier
,name
,name2
,name3
,name4
,name5
,name6
,ncindustry
,organizationcode
,orgtype1
,orgtype10
,orgtype11
,orgtype12
,orgtype13
,orgtype14
,orgtype15
,orgtype16
,orgtype17
,orgtype18
,orgtype19
,orgtype2
,orgtype20
,orgtype21
,orgtype22
,orgtype23
,orgtype24
,orgtype25
,orgtype26
,orgtype27
,orgtype28
,orgtype29
,orgtype3
,orgtype30
,orgtype31
,orgtype32
,orgtype33
,orgtype34
,orgtype35
,orgtype36
,orgtype37
,orgtype38
,orgtype39
,orgtype4
,orgtype40
,orgtype41
,orgtype42
,orgtype43
,orgtype44
,orgtype45
,orgtype46
,orgtype47
,orgtype48
,orgtype49
,orgtype5
,orgtype50
,orgtype6
,orgtype7
,orgtype8
,orgtype9
,pk_fatherorg
,pk_format
,pk_group
,pk_org
,pk_ownorg
,pk_timezone
,pk_vid
,principal
,shortname
,shortname2
,shortname3
,shortname4
,shortname5
,shortname6
,tel
,ts
,venddate
,vname
,vname2
,vname3
,vname4
,vname5
,vname6
,vno
,vstartdate
,chargeleader
,entitytype
,isbalanceunit
,isretail
,pk_accperiodscheme
,pk_controlarea
,pk_corp
,pk_currtype
,pk_exratescheme
,reportconfirm
,workcalendar
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_org_orgs t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_org_orgs.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
