/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_bd_psndoc
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.nhrs_bd_psndoc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_bd_psndoc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_bd_psndoc_op purge;
drop table ${iol_schema}.nhrs_bd_psndoc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_psndoc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_bd_psndoc where 0=1;

create table ${iol_schema}.nhrs_bd_psndoc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_bd_psndoc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_bd_psndoc_cl(
            addr -- 
            ,birthdate -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,dr -- 
            ,email -- 
            ,enablestate -- 
            ,homephone -- 
            ,id -- 
            ,idtype -- 
            ,isshopassist -- 
            ,joinworkdate -- 
            ,mnecode -- 
            ,mobile -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,officephone -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_psndoc -- 
            ,sex -- 
            ,ts -- 
            ,usedname -- 
            ,bloodtype -- 
            ,censusaddr -- 
            ,characterrpr -- 
            ,country -- 
            ,die_date -- 
            ,die_remark -- 
            ,edu -- 
            ,fax -- 
            ,fileaddress -- 
            ,health -- 
            ,ishiskeypsn -- 
            ,joinpolitydate -- 
            ,marital -- 
            ,marriagedate -- 
            ,nationality -- 
            ,nativeplace -- 
            ,penelauth -- 
            ,permanreside -- 
            ,photo -- 
            ,pk_degree -- 
            ,pk_hrorg -- 
            ,polity -- 
            ,postalcode -- 
            ,previewphoto -- 
            ,prof -- 
            ,retiredate -- 
            ,secret_email -- 
            ,shortname -- 
            ,titletechpost -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,glbdef12 -- 
            ,glbdef13 -- 
            ,glbdef14 -- 
            ,glbdef15 -- 
            ,glbdef16 -- 
            ,glbdef17 -- 
            ,glbdef18 -- 
            ,glbdef19 -- 
            ,glbdef20 -- 
            ,glbdef21 -- 
            ,glbdef22 -- 
            ,glbdef23 -- 
            ,glbdef24 -- 
            ,glbdef25 -- 
            ,glbdef26 -- 
            ,glbdef27 -- 
            ,glbdef28 -- 
            ,glbdef29 -- 
            ,glbdef30 -- 
            ,glbdef31 -- 
            ,glbdef32 -- 
            ,glbdef40 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_bd_psndoc_op(
            addr -- 
            ,birthdate -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,dr -- 
            ,email -- 
            ,enablestate -- 
            ,homephone -- 
            ,id -- 
            ,idtype -- 
            ,isshopassist -- 
            ,joinworkdate -- 
            ,mnecode -- 
            ,mobile -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,officephone -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_psndoc -- 
            ,sex -- 
            ,ts -- 
            ,usedname -- 
            ,bloodtype -- 
            ,censusaddr -- 
            ,characterrpr -- 
            ,country -- 
            ,die_date -- 
            ,die_remark -- 
            ,edu -- 
            ,fax -- 
            ,fileaddress -- 
            ,health -- 
            ,ishiskeypsn -- 
            ,joinpolitydate -- 
            ,marital -- 
            ,marriagedate -- 
            ,nationality -- 
            ,nativeplace -- 
            ,penelauth -- 
            ,permanreside -- 
            ,photo -- 
            ,pk_degree -- 
            ,pk_hrorg -- 
            ,polity -- 
            ,postalcode -- 
            ,previewphoto -- 
            ,prof -- 
            ,retiredate -- 
            ,secret_email -- 
            ,shortname -- 
            ,titletechpost -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,glbdef12 -- 
            ,glbdef13 -- 
            ,glbdef14 -- 
            ,glbdef15 -- 
            ,glbdef16 -- 
            ,glbdef17 -- 
            ,glbdef18 -- 
            ,glbdef19 -- 
            ,glbdef20 -- 
            ,glbdef21 -- 
            ,glbdef22 -- 
            ,glbdef23 -- 
            ,glbdef24 -- 
            ,glbdef25 -- 
            ,glbdef26 -- 
            ,glbdef27 -- 
            ,glbdef28 -- 
            ,glbdef29 -- 
            ,glbdef30 -- 
            ,glbdef31 -- 
            ,glbdef32 -- 
            ,glbdef40 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.addr, o.addr) as addr -- 
    ,nvl(n.birthdate, o.birthdate) as birthdate -- 
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.def1, o.def1) as def1 -- 
    ,nvl(n.def10, o.def10) as def10 -- 
    ,nvl(n.def11, o.def11) as def11 -- 
    ,nvl(n.def12, o.def12) as def12 -- 
    ,nvl(n.def13, o.def13) as def13 -- 
    ,nvl(n.def14, o.def14) as def14 -- 
    ,nvl(n.def15, o.def15) as def15 -- 
    ,nvl(n.def16, o.def16) as def16 -- 
    ,nvl(n.def17, o.def17) as def17 -- 
    ,nvl(n.def18, o.def18) as def18 -- 
    ,nvl(n.def19, o.def19) as def19 -- 
    ,nvl(n.def2, o.def2) as def2 -- 
    ,nvl(n.def20, o.def20) as def20 -- 
    ,nvl(n.def3, o.def3) as def3 -- 
    ,nvl(n.def4, o.def4) as def4 -- 
    ,nvl(n.def5, o.def5) as def5 -- 
    ,nvl(n.def6, o.def6) as def6 -- 
    ,nvl(n.def7, o.def7) as def7 -- 
    ,nvl(n.def8, o.def8) as def8 -- 
    ,nvl(n.def9, o.def9) as def9 -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.homephone, o.homephone) as homephone -- 
    ,nvl(n.id, o.id) as id -- 
    ,nvl(n.idtype, o.idtype) as idtype -- 
    ,nvl(n.isshopassist, o.isshopassist) as isshopassist -- 
    ,nvl(n.joinworkdate, o.joinworkdate) as joinworkdate -- 
    ,nvl(n.mnecode, o.mnecode) as mnecode -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.name2, o.name2) as name2 -- 
    ,nvl(n.name3, o.name3) as name3 -- 
    ,nvl(n.name4, o.name4) as name4 -- 
    ,nvl(n.name5, o.name5) as name5 -- 
    ,nvl(n.name6, o.name6) as name6 -- 
    ,nvl(n.officephone, o.officephone) as officephone -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 
    ,nvl(n.sex, o.sex) as sex -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.usedname, o.usedname) as usedname -- 
    ,nvl(n.bloodtype, o.bloodtype) as bloodtype -- 
    ,nvl(n.censusaddr, o.censusaddr) as censusaddr -- 
    ,nvl(n.characterrpr, o.characterrpr) as characterrpr -- 
    ,nvl(n.country, o.country) as country -- 
    ,nvl(n.die_date, o.die_date) as die_date -- 
    ,nvl(n.die_remark, o.die_remark) as die_remark -- 
    ,nvl(n.edu, o.edu) as edu -- 
    ,nvl(n.fax, o.fax) as fax -- 
    ,nvl(n.fileaddress, o.fileaddress) as fileaddress -- 
    ,nvl(n.health, o.health) as health -- 
    ,nvl(n.ishiskeypsn, o.ishiskeypsn) as ishiskeypsn -- 
    ,nvl(n.joinpolitydate, o.joinpolitydate) as joinpolitydate -- 
    ,nvl(n.marital, o.marital) as marital -- 
    ,nvl(n.marriagedate, o.marriagedate) as marriagedate -- 
    ,nvl(n.nationality, o.nationality) as nationality -- 
    ,nvl(n.nativeplace, o.nativeplace) as nativeplace -- 
    ,nvl(n.penelauth, o.penelauth) as penelauth -- 
    ,nvl(n.permanreside, o.permanreside) as permanreside -- 
    ,nvl(n.photo, o.photo) as photo -- 
    ,nvl(n.pk_degree, o.pk_degree) as pk_degree -- 
    ,nvl(n.pk_hrorg, o.pk_hrorg) as pk_hrorg -- 
    ,nvl(n.polity, o.polity) as polity -- 
    ,nvl(n.postalcode, o.postalcode) as postalcode -- 
    ,nvl(n.previewphoto, o.previewphoto) as previewphoto -- 
    ,nvl(n.prof, o.prof) as prof -- 
    ,nvl(n.retiredate, o.retiredate) as retiredate -- 
    ,nvl(n.secret_email, o.secret_email) as secret_email -- 
    ,nvl(n.shortname, o.shortname) as shortname -- 
    ,nvl(n.titletechpost, o.titletechpost) as titletechpost -- 
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 
    ,nvl(n.glbdef2, o.glbdef2) as glbdef2 -- 
    ,nvl(n.glbdef3, o.glbdef3) as glbdef3 -- 
    ,nvl(n.glbdef4, o.glbdef4) as glbdef4 -- 
    ,nvl(n.glbdef5, o.glbdef5) as glbdef5 -- 
    ,nvl(n.glbdef6, o.glbdef6) as glbdef6 -- 
    ,nvl(n.glbdef7, o.glbdef7) as glbdef7 -- 
    ,nvl(n.glbdef8, o.glbdef8) as glbdef8 -- 
    ,nvl(n.glbdef9, o.glbdef9) as glbdef9 -- 
    ,nvl(n.glbdef10, o.glbdef10) as glbdef10 -- 
    ,nvl(n.glbdef11, o.glbdef11) as glbdef11 -- 
    ,nvl(n.glbdef12, o.glbdef12) as glbdef12 -- 
    ,nvl(n.glbdef13, o.glbdef13) as glbdef13 -- 
    ,nvl(n.glbdef14, o.glbdef14) as glbdef14 -- 
    ,nvl(n.glbdef15, o.glbdef15) as glbdef15 -- 
    ,nvl(n.glbdef16, o.glbdef16) as glbdef16 -- 
    ,nvl(n.glbdef17, o.glbdef17) as glbdef17 -- 
    ,nvl(n.glbdef18, o.glbdef18) as glbdef18 -- 
    ,nvl(n.glbdef19, o.glbdef19) as glbdef19 -- 
    ,nvl(n.glbdef20, o.glbdef20) as glbdef20 -- 
    ,nvl(n.glbdef21, o.glbdef21) as glbdef21 -- 
    ,nvl(n.glbdef22, o.glbdef22) as glbdef22 -- 
    ,nvl(n.glbdef23, o.glbdef23) as glbdef23 -- 
    ,nvl(n.glbdef24, o.glbdef24) as glbdef24 -- 
    ,nvl(n.glbdef25, o.glbdef25) as glbdef25 -- 
    ,nvl(n.glbdef26, o.glbdef26) as glbdef26 -- 
    ,nvl(n.glbdef27, o.glbdef27) as glbdef27 -- 
    ,nvl(n.glbdef28, o.glbdef28) as glbdef28 -- 
    ,nvl(n.glbdef29, o.glbdef29) as glbdef29 -- 
    ,nvl(n.glbdef30, o.glbdef30) as glbdef30 -- 
    ,nvl(n.glbdef31, o.glbdef31) as glbdef31 -- 
    ,nvl(n.glbdef32, o.glbdef32) as glbdef32 -- 
    ,nvl(n.glbdef40, o.glbdef40) as glbdef40 -- 
    ,case when
            n.pk_psndoc is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psndoc is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psndoc is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_bd_psndoc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_bd_psndoc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psndoc = n.pk_psndoc
where (
        o.pk_psndoc is null
    )
    or (
        n.pk_psndoc is null
    )
    or (
        o.addr <> n.addr
        or o.birthdate <> n.birthdate
        or o.code <> n.code
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.def1 <> n.def1
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def2 <> n.def2
        or o.def20 <> n.def20
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.dr <> n.dr
        or o.email <> n.email
        or o.enablestate <> n.enablestate
        or o.homephone <> n.homephone
        or o.id <> n.id
        or o.idtype <> n.idtype
        or o.isshopassist <> n.isshopassist
        or o.joinworkdate <> n.joinworkdate
        or o.mnecode <> n.mnecode
        or o.mobile <> n.mobile
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.officephone <> n.officephone
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.sex <> n.sex
        or o.ts <> n.ts
        or o.usedname <> n.usedname
        or o.bloodtype <> n.bloodtype
        or o.censusaddr <> n.censusaddr
        or o.characterrpr <> n.characterrpr
        or o.country <> n.country
        or o.die_date <> n.die_date
        or o.die_remark <> n.die_remark
        or o.edu <> n.edu
        or o.fax <> n.fax
        or o.fileaddress <> n.fileaddress
        or o.health <> n.health
        or o.ishiskeypsn <> n.ishiskeypsn
        or o.joinpolitydate <> n.joinpolitydate
        or o.marital <> n.marital
        or o.marriagedate <> n.marriagedate
        or o.nationality <> n.nationality
        or o.nativeplace <> n.nativeplace
        or o.penelauth <> n.penelauth
        or o.permanreside <> n.permanreside
        or o.photo <> n.photo
        or o.pk_degree <> n.pk_degree
        or o.pk_hrorg <> n.pk_hrorg
        or o.polity <> n.polity
        or o.postalcode <> n.postalcode
        or o.previewphoto <> n.previewphoto
        or o.prof <> n.prof
        or o.retiredate <> n.retiredate
        or o.secret_email <> n.secret_email
        or o.shortname <> n.shortname
        or o.titletechpost <> n.titletechpost
        or o.glbdef1 <> n.glbdef1
        or o.glbdef2 <> n.glbdef2
        or o.glbdef3 <> n.glbdef3
        or o.glbdef4 <> n.glbdef4
        or o.glbdef5 <> n.glbdef5
        or o.glbdef6 <> n.glbdef6
        or o.glbdef7 <> n.glbdef7
        or o.glbdef8 <> n.glbdef8
        or o.glbdef9 <> n.glbdef9
        or o.glbdef10 <> n.glbdef10
        or o.glbdef11 <> n.glbdef11
        or o.glbdef12 <> n.glbdef12
        or o.glbdef13 <> n.glbdef13
        or o.glbdef14 <> n.glbdef14
        or o.glbdef15 <> n.glbdef15
        or o.glbdef16 <> n.glbdef16
        or o.glbdef17 <> n.glbdef17
        or o.glbdef18 <> n.glbdef18
        or o.glbdef19 <> n.glbdef19
        or o.glbdef20 <> n.glbdef20
        or o.glbdef21 <> n.glbdef21
        or o.glbdef22 <> n.glbdef22
        or o.glbdef23 <> n.glbdef23
        or o.glbdef24 <> n.glbdef24
        or o.glbdef25 <> n.glbdef25
        or o.glbdef26 <> n.glbdef26
        or o.glbdef27 <> n.glbdef27
        or o.glbdef28 <> n.glbdef28
        or o.glbdef29 <> n.glbdef29
        or o.glbdef30 <> n.glbdef30
        or o.glbdef31 <> n.glbdef31
        or o.glbdef32 <> n.glbdef32
        or o.glbdef40 <> n.glbdef40
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_bd_psndoc_cl(
            addr -- 
            ,birthdate -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,dr -- 
            ,email -- 
            ,enablestate -- 
            ,homephone -- 
            ,id -- 
            ,idtype -- 
            ,isshopassist -- 
            ,joinworkdate -- 
            ,mnecode -- 
            ,mobile -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,officephone -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_psndoc -- 
            ,sex -- 
            ,ts -- 
            ,usedname -- 
            ,bloodtype -- 
            ,censusaddr -- 
            ,characterrpr -- 
            ,country -- 
            ,die_date -- 
            ,die_remark -- 
            ,edu -- 
            ,fax -- 
            ,fileaddress -- 
            ,health -- 
            ,ishiskeypsn -- 
            ,joinpolitydate -- 
            ,marital -- 
            ,marriagedate -- 
            ,nationality -- 
            ,nativeplace -- 
            ,penelauth -- 
            ,permanreside -- 
            ,photo -- 
            ,pk_degree -- 
            ,pk_hrorg -- 
            ,polity -- 
            ,postalcode -- 
            ,previewphoto -- 
            ,prof -- 
            ,retiredate -- 
            ,secret_email -- 
            ,shortname -- 
            ,titletechpost -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,glbdef12 -- 
            ,glbdef13 -- 
            ,glbdef14 -- 
            ,glbdef15 -- 
            ,glbdef16 -- 
            ,glbdef17 -- 
            ,glbdef18 -- 
            ,glbdef19 -- 
            ,glbdef20 -- 
            ,glbdef21 -- 
            ,glbdef22 -- 
            ,glbdef23 -- 
            ,glbdef24 -- 
            ,glbdef25 -- 
            ,glbdef26 -- 
            ,glbdef27 -- 
            ,glbdef28 -- 
            ,glbdef29 -- 
            ,glbdef30 -- 
            ,glbdef31 -- 
            ,glbdef32 -- 
            ,glbdef40 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_bd_psndoc_op(
            addr -- 
            ,birthdate -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,dr -- 
            ,email -- 
            ,enablestate -- 
            ,homephone -- 
            ,id -- 
            ,idtype -- 
            ,isshopassist -- 
            ,joinworkdate -- 
            ,mnecode -- 
            ,mobile -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,officephone -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_psndoc -- 
            ,sex -- 
            ,ts -- 
            ,usedname -- 
            ,bloodtype -- 
            ,censusaddr -- 
            ,characterrpr -- 
            ,country -- 
            ,die_date -- 
            ,die_remark -- 
            ,edu -- 
            ,fax -- 
            ,fileaddress -- 
            ,health -- 
            ,ishiskeypsn -- 
            ,joinpolitydate -- 
            ,marital -- 
            ,marriagedate -- 
            ,nationality -- 
            ,nativeplace -- 
            ,penelauth -- 
            ,permanreside -- 
            ,photo -- 
            ,pk_degree -- 
            ,pk_hrorg -- 
            ,polity -- 
            ,postalcode -- 
            ,previewphoto -- 
            ,prof -- 
            ,retiredate -- 
            ,secret_email -- 
            ,shortname -- 
            ,titletechpost -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,glbdef12 -- 
            ,glbdef13 -- 
            ,glbdef14 -- 
            ,glbdef15 -- 
            ,glbdef16 -- 
            ,glbdef17 -- 
            ,glbdef18 -- 
            ,glbdef19 -- 
            ,glbdef20 -- 
            ,glbdef21 -- 
            ,glbdef22 -- 
            ,glbdef23 -- 
            ,glbdef24 -- 
            ,glbdef25 -- 
            ,glbdef26 -- 
            ,glbdef27 -- 
            ,glbdef28 -- 
            ,glbdef29 -- 
            ,glbdef30 -- 
            ,glbdef31 -- 
            ,glbdef32 -- 
            ,glbdef40 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.addr -- 
    ,o.birthdate -- 
    ,o.code -- 
    ,o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.def1 -- 
    ,o.def10 -- 
    ,o.def11 -- 
    ,o.def12 -- 
    ,o.def13 -- 
    ,o.def14 -- 
    ,o.def15 -- 
    ,o.def16 -- 
    ,o.def17 -- 
    ,o.def18 -- 
    ,o.def19 -- 
    ,o.def2 -- 
    ,o.def20 -- 
    ,o.def3 -- 
    ,o.def4 -- 
    ,o.def5 -- 
    ,o.def6 -- 
    ,o.def7 -- 
    ,o.def8 -- 
    ,o.def9 -- 
    ,o.dr -- 
    ,o.email -- 
    ,o.enablestate -- 
    ,o.homephone -- 
    ,o.id -- 
    ,o.idtype -- 
    ,o.isshopassist -- 
    ,o.joinworkdate -- 
    ,o.mnecode -- 
    ,o.mobile -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.name -- 
    ,o.name2 -- 
    ,o.name3 -- 
    ,o.name4 -- 
    ,o.name5 -- 
    ,o.name6 -- 
    ,o.officephone -- 
    ,o.pk_group -- 
    ,o.pk_org -- 
    ,o.pk_psndoc -- 
    ,o.sex -- 
    ,o.ts -- 
    ,o.usedname -- 
    ,o.bloodtype -- 
    ,o.censusaddr -- 
    ,o.characterrpr -- 
    ,o.country -- 
    ,o.die_date -- 
    ,o.die_remark -- 
    ,o.edu -- 
    ,o.fax -- 
    ,o.fileaddress -- 
    ,o.health -- 
    ,o.ishiskeypsn -- 
    ,o.joinpolitydate -- 
    ,o.marital -- 
    ,o.marriagedate -- 
    ,o.nationality -- 
    ,o.nativeplace -- 
    ,o.penelauth -- 
    ,o.permanreside -- 
    ,o.photo -- 
    ,o.pk_degree -- 
    ,o.pk_hrorg -- 
    ,o.polity -- 
    ,o.postalcode -- 
    ,o.previewphoto -- 
    ,o.prof -- 
    ,o.retiredate -- 
    ,o.secret_email -- 
    ,o.shortname -- 
    ,o.titletechpost -- 
    ,o.glbdef1 -- 
    ,o.glbdef2 -- 
    ,o.glbdef3 -- 
    ,o.glbdef4 -- 
    ,o.glbdef5 -- 
    ,o.glbdef6 -- 
    ,o.glbdef7 -- 
    ,o.glbdef8 -- 
    ,o.glbdef9 -- 
    ,o.glbdef10 -- 
    ,o.glbdef11 -- 
    ,o.glbdef12 -- 
    ,o.glbdef13 -- 
    ,o.glbdef14 -- 
    ,o.glbdef15 -- 
    ,o.glbdef16 -- 
    ,o.glbdef17 -- 
    ,o.glbdef18 -- 
    ,o.glbdef19 -- 
    ,o.glbdef20 -- 
    ,o.glbdef21 -- 
    ,o.glbdef22 -- 
    ,o.glbdef23 -- 
    ,o.glbdef24 -- 
    ,o.glbdef25 -- 
    ,o.glbdef26 -- 
    ,o.glbdef27 -- 
    ,o.glbdef28 -- 
    ,o.glbdef29 -- 
    ,o.glbdef30 -- 
    ,o.glbdef31 -- 
    ,o.glbdef32 -- 
    ,o.glbdef40 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.nhrs_bd_psndoc_bk o
    left join ${iol_schema}.nhrs_bd_psndoc_op n
        on
            o.pk_psndoc = n.pk_psndoc
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_bd_psndoc_cl d
        on
            o.pk_psndoc = d.pk_psndoc
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_bd_psndoc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_bd_psndoc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_bd_psndoc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_bd_psndoc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_bd_psndoc exchange partition p_${batch_date} with table ${iol_schema}.nhrs_bd_psndoc_cl;
alter table ${iol_schema}.nhrs_bd_psndoc exchange partition p_20991231 with table ${iol_schema}.nhrs_bd_psndoc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_bd_psndoc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_bd_psndoc_op purge;
drop table ${iol_schema}.nhrs_bd_psndoc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_bd_psndoc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_bd_psndoc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
