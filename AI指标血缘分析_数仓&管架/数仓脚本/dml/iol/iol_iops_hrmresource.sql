/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iops_hrmresource
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iops_hrmresource_ex purge;
alter table ${iol_schema}.iops_hrmresource add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.iops_hrmresource;

-- 2.3 insert data to ex table
create table ${iol_schema}.iops_hrmresource_ex nologging
compress
as
select * from ${iol_schema}.iops_hrmresource where 0=1;

insert /*+ append */ into ${iol_schema}.iops_hrmresource_ex(
    id -- 
    ,loginid -- 
    ,password -- 
    ,lastname -- 
    ,sex -- 
    ,birthday -- 
    ,nationality -- 
    ,systemlanguage -- 
    ,maritalstatus -- 
    ,telephone -- 
    ,mobile -- 
    ,mobilecall -- 
    ,email -- 
    ,locationid -- 
    ,workroom -- 
    ,homeaddress -- 
    ,resourcetype -- 
    ,startdate -- 
    ,enddate -- 
    ,jobtitle -- 
    ,jobactivitydesc -- 
    ,joblevel -- 
    ,seclevel -- 
    ,departmentid -- 
    ,subcompanyid1 -- 
    ,costcenterid -- 
    ,managerid -- 
    ,assistantid -- 
    ,bankid1 -- 
    ,accountid1 -- 
    ,resourceimageid -- 
    ,createrid -- 
    ,createdate -- 
    ,lastmodid -- 
    ,lastmoddate -- 
    ,lastlogindate -- 
    ,datefield1 -- 
    ,datefield2 -- 
    ,datefield3 -- 
    ,datefield4 -- 
    ,datefield5 -- 
    ,numberfield1 -- 
    ,numberfield2 -- 
    ,numberfield3 -- 
    ,numberfield4 -- 
    ,numberfield5 -- 
    ,textfield1 -- 
    ,textfield2 -- 
    ,textfield3 -- 
    ,textfield4 -- 
    ,textfield5 -- 
    ,tinyintfield1 -- 
    ,tinyintfield2 -- 
    ,tinyintfield3 -- 
    ,tinyintfield4 -- 
    ,tinyintfield5 -- 
    ,certificatenum -- 
    ,nativeplace -- 
    ,educationlevel -- 
    ,bememberdate -- 
    ,bepartydate -- 
    ,workcode -- 
    ,regresidentplace -- 
    ,healthinfo -- 
    ,residentplace -- 
    ,policy -- 
    ,degree -- 
    ,height -- 
    ,usekind -- 
    ,jobcall -- 
    ,accumfundaccount -- 
    ,birthplace -- 
    ,folk -- 
    ,residentphone -- 
    ,residentpostcode -- 
    ,extphone -- 
    ,managerstr -- 
    ,status -- 
    ,fax -- 
    ,islabouunion -- 
    ,weight -- 
    ,tempresidentnumber -- 
    ,probationenddate -- 
    ,countryid -- 
    ,passwdchgdate -- 
    ,needusb -- 
    ,serial -- 
    ,account -- 
    ,lloginid -- 
    ,needdynapass -- 
    ,dsporder -- 
    ,passwordstate -- 
    ,accounttype -- 
    ,belongto -- 
    ,dactylogram -- 
    ,assistantdactylogram -- 
    ,passwordlock -- 
    ,sumpasswordwrong -- 
    ,oldpassword1 -- 
    ,oldpassword2 -- 
    ,msgstyle -- 
    ,messagerurl -- 
    ,pinyinlastname -- 
    ,tokenkey -- 
    ,userusbtype -- 
    ,outkey -- 
    ,adsjgs -- 
    ,adgs -- 
    ,adbm -- 
    ,mobileshowtype -- 
    ,usbstate -- 
    ,totalspace -- 
    ,occupyspace -- 
    ,ecology_pinyin_search -- 
    ,isadaccount -- 
    ,accountname -- 
    ,haschangepwd -- 
    ,created -- 
    ,creater -- 
    ,modified -- 
    ,modifier -- 
    ,passwordlocktime -- 
    ,mobilecaflag -- 
    ,salt -- 
    ,companystartdate -- 
    ,workstartdate -- 
    ,secondarypwd -- 
    ,usesecondarypwd -- 
    ,classification -- 
    ,uuid -- 
    ,passwordlockreason -- 
    ,companyworkyear -- 
    ,workyear -- 
    ,dismissdate -- 
    ,enckey -- 
    ,crc -- 
    ,usbscope -- 
    ,tenant_key -- 
    ,clauthtype -- 
    ,hashdata -- 
    ,signdata -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 
    ,loginid -- 
    ,password -- 
    ,lastname -- 
    ,sex -- 
    ,birthday -- 
    ,nationality -- 
    ,systemlanguage -- 
    ,maritalstatus -- 
    ,telephone -- 
    ,mobile -- 
    ,mobilecall -- 
    ,email -- 
    ,locationid -- 
    ,workroom -- 
    ,homeaddress -- 
    ,resourcetype -- 
    ,startdate -- 
    ,enddate -- 
    ,jobtitle -- 
    ,jobactivitydesc -- 
    ,joblevel -- 
    ,seclevel -- 
    ,departmentid -- 
    ,subcompanyid1 -- 
    ,costcenterid -- 
    ,managerid -- 
    ,assistantid -- 
    ,bankid1 -- 
    ,accountid1 -- 
    ,resourceimageid -- 
    ,createrid -- 
    ,createdate -- 
    ,lastmodid -- 
    ,lastmoddate -- 
    ,lastlogindate -- 
    ,datefield1 -- 
    ,datefield2 -- 
    ,datefield3 -- 
    ,datefield4 -- 
    ,datefield5 -- 
    ,numberfield1 -- 
    ,numberfield2 -- 
    ,numberfield3 -- 
    ,numberfield4 -- 
    ,numberfield5 -- 
    ,textfield1 -- 
    ,textfield2 -- 
    ,textfield3 -- 
    ,textfield4 -- 
    ,textfield5 -- 
    ,tinyintfield1 -- 
    ,tinyintfield2 -- 
    ,tinyintfield3 -- 
    ,tinyintfield4 -- 
    ,tinyintfield5 -- 
    ,certificatenum -- 
    ,nativeplace -- 
    ,educationlevel -- 
    ,bememberdate -- 
    ,bepartydate -- 
    ,workcode -- 
    ,regresidentplace -- 
    ,healthinfo -- 
    ,residentplace -- 
    ,policy -- 
    ,degree -- 
    ,height -- 
    ,usekind -- 
    ,jobcall -- 
    ,accumfundaccount -- 
    ,birthplace -- 
    ,folk -- 
    ,residentphone -- 
    ,residentpostcode -- 
    ,extphone -- 
    ,managerstr -- 
    ,status -- 
    ,fax -- 
    ,islabouunion -- 
    ,weight -- 
    ,tempresidentnumber -- 
    ,probationenddate -- 
    ,countryid -- 
    ,passwdchgdate -- 
    ,needusb -- 
    ,serial -- 
    ,account -- 
    ,lloginid -- 
    ,needdynapass -- 
    ,dsporder -- 
    ,passwordstate -- 
    ,accounttype -- 
    ,belongto -- 
    ,dactylogram -- 
    ,assistantdactylogram -- 
    ,passwordlock -- 
    ,sumpasswordwrong -- 
    ,oldpassword1 -- 
    ,oldpassword2 -- 
    ,msgstyle -- 
    ,messagerurl -- 
    ,pinyinlastname -- 
    ,tokenkey -- 
    ,userusbtype -- 
    ,outkey -- 
    ,adsjgs -- 
    ,adgs -- 
    ,adbm -- 
    ,mobileshowtype -- 
    ,usbstate -- 
    ,totalspace -- 
    ,occupyspace -- 
    ,ecology_pinyin_search -- 
    ,isadaccount -- 
    ,accountname -- 
    ,haschangepwd -- 
    ,created -- 
    ,creater -- 
    ,modified -- 
    ,modifier -- 
    ,passwordlocktime -- 
    ,mobilecaflag -- 
    ,salt -- 
    ,companystartdate -- 
    ,workstartdate -- 
    ,secondarypwd -- 
    ,usesecondarypwd -- 
    ,classification -- 
    ,uuid -- 
    ,passwordlockreason -- 
    ,companyworkyear -- 
    ,workyear -- 
    ,dismissdate -- 
    ,enckey -- 
    ,crc -- 
    ,usbscope -- 
    ,tenant_key -- 
    ,clauthtype -- 
    ,hashdata -- 
    ,signdata -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.iops_hrmresource
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.iops_hrmresource exchange partition p_${batch_date} with table ${iol_schema}.iops_hrmresource_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iops_hrmresource to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.iops_hrmresource_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iops_hrmresource',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);