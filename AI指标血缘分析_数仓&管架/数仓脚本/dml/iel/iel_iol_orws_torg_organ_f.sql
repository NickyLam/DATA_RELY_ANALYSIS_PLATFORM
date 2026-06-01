: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_torg_organ_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_torg_organ.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.organid as organid 
,t1.ownerorganid as ownerorganid 
,replace(replace(t1.organcode,chr(13),''),chr(10),'') as organcode 
,replace(replace(t1.organnum,chr(13),''),chr(10),'') as organnum 
,replace(replace(t1.organname,chr(13),''),chr(10),'') as organname 
,replace(replace(t1.invoicename,chr(13),''),chr(10),'') as invoicename 
,replace(replace(t1.shortname,chr(13),''),chr(10),'') as shortname 
,t1.organtype as organtype 
,t1.isbuildaccunt as isbuildaccunt 
,replace(replace(t1.address,chr(13),''),chr(10),'') as address 
,t1.builddate as builddate 
,t1.invaliddate as invaliddate 
,replace(replace(t1.corporation,chr(13),''),chr(10),'') as corporation 
,replace(replace(t1.master,chr(13),''),chr(10),'') as master 
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode 
,replace(replace(t1.linkphone,chr(13),''),chr(10),'') as linkphone 
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax 
,replace(replace(t1.email,chr(13),''),chr(10),'') as email 
,replace(replace(t1.taxno,chr(13),''),chr(10),'') as taxno 
,t1.personnelnum as personnelnum 
,t1.isused as isused 
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark 
,replace(replace(t1.ext1,chr(13),''),chr(10),'') as ext1 
,replace(replace(t1.ext2,chr(13),''),chr(10),'') as ext2 
,replace(replace(t1.ext3,chr(13),''),chr(10),'') as ext3 
,t1.officedate as officedate 
,replace(replace(t1.managermaster,chr(13),''),chr(10),'') as managermaster 
,t1.mofficedate as mofficedate 
,t1.status as status 
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.orws_torg_organ t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_torg_organ.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes