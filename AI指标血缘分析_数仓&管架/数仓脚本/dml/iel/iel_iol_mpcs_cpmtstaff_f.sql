: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_cpmtstaff_f
CreateDate: 20240101
FileName:   ${iel_data_path}/mpcs_cpmtstaff.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.staffno,chr(13),''),chr(10),'') as staffno
,replace(replace(t1.tlrtype,chr(13),''),chr(10),'') as tlrtype
,replace(replace(t1.staffname,chr(13),''),chr(10),'') as staffname
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.birthday,chr(13),''),chr(10),'') as birthday
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t1.ofinstno,chr(13),''),chr(10),'') as ofinstno
,replace(replace(t1.ofdeptno,chr(13),''),chr(10),'') as ofdeptno
,replace(replace(t1.stafftype,chr(13),''),chr(10),'') as stafftype
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.safemode,chr(13),''),chr(10),'') as safemode
,replace(replace(t1.signpswd,chr(13),''),chr(10),'') as signpswd
,replace(replace(t1.pswdchgdt,chr(13),''),chr(10),'') as pswdchgdt
,replace(replace(t1.rowstat,chr(13),''),chr(10),'') as rowstat
,replace(replace(t1.upddt,chr(13),''),chr(10),'') as upddt
,replace(replace(t1.updtm,chr(13),''),chr(10),'') as updtm
,replace(replace(t1.ygno,chr(13),''),chr(10),'') as ygno
,replace(replace(t1.motto,chr(13),''),chr(10),'') as motto
,replace(replace(t1.ofdeptnm,chr(13),''),chr(10),'') as ofdeptnm

from ${iol_schema}.mpcs_cpmtstaff t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_cpmtstaff.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
