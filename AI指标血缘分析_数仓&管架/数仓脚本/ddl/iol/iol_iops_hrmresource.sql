/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iops_hrmresource
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iops_hrmresource
whenever sqlerror continue none;
drop table ${iol_schema}.iops_hrmresource purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iops_hrmresource(
    id number(38,0) -- 
    ,loginid varchar2(3000) -- 
    ,password varchar2(4000) -- 
    ,lastname varchar2(4000) -- 
    ,sex varchar2(300) -- 
    ,birthday varchar2(500) -- 
    ,nationality number(38,0) -- 
    ,systemlanguage number(38,0) -- 
    ,maritalstatus varchar2(300) -- 
    ,telephone varchar2(4000) -- 
    ,mobile varchar2(4000) -- 
    ,mobilecall varchar2(4000) -- 
    ,email varchar2(4000) -- 
    ,locationid number(38,0) -- 
    ,workroom varchar2(4000) -- 
    ,homeaddress varchar2(4000) -- 
    ,resourcetype varchar2(300) -- 
    ,startdate varchar2(500) -- 
    ,enddate varchar2(500) -- 
    ,jobtitle number(38,0) -- 
    ,jobactivitydesc varchar2(4000) -- 
    ,joblevel number(38,0) -- 
    ,seclevel number(38,0) -- 
    ,departmentid number(38,0) -- 
    ,subcompanyid1 number(38,0) -- 
    ,costcenterid number(38,0) -- 
    ,managerid number(38,0) -- 
    ,assistantid number(38,0) -- 
    ,bankid1 number(38,0) -- 
    ,accountid1 varchar2(4000) -- 
    ,resourceimageid number(38,0) -- 
    ,createrid number(38,0) -- 
    ,createdate varchar2(500) -- 
    ,lastmodid number(38,0) -- 
    ,lastmoddate varchar2(500) -- 
    ,lastlogindate varchar2(500) -- 
    ,datefield1 varchar2(3000) -- 
    ,datefield2 varchar2(3000) -- 
    ,datefield3 varchar2(3000) -- 
    ,datefield4 varchar2(3000) -- 
    ,datefield5 varchar2(3000) -- 
    ,numberfield1 number(38,12) -- 
    ,numberfield2 number(38,12) -- 
    ,numberfield3 number(38,12) -- 
    ,numberfield4 number(38,12) -- 
    ,numberfield5 number(38,12) -- 
    ,textfield1 varchar2(4000) -- 
    ,textfield2 varchar2(4000) -- 
    ,textfield3 varchar2(4000) -- 
    ,textfield4 varchar2(4000) -- 
    ,textfield5 varchar2(4000) -- 
    ,tinyintfield1 number(38,0) -- 
    ,tinyintfield2 number(38,0) -- 
    ,tinyintfield3 number(38,0) -- 
    ,tinyintfield4 number(38,0) -- 
    ,tinyintfield5 number(38,0) -- 
    ,certificatenum varchar2(4000) -- 
    ,nativeplace varchar2(4000) -- 
    ,educationlevel number(38,0) -- 
    ,bememberdate varchar2(500) -- 
    ,bepartydate varchar2(500) -- 
    ,workcode varchar2(4000) -- 
    ,regresidentplace varchar2(4000) -- 
    ,healthinfo varchar2(300) -- 
    ,residentplace varchar2(4000) -- 
    ,policy varchar2(4000) -- 
    ,degree varchar2(4000) -- 
    ,height varchar2(3000) -- 
    ,usekind number(38,0) -- 
    ,jobcall number(38,0) -- 
    ,accumfundaccount varchar2(4000) -- 
    ,birthplace varchar2(4000) -- 
    ,folk varchar2(4000) -- 
    ,residentphone varchar2(4000) -- 
    ,residentpostcode varchar2(4000) -- 
    ,extphone varchar2(4000) -- 
    ,managerstr varchar2(4000) -- 
    ,status number(38,0) -- 
    ,fax varchar2(4000) -- 
    ,islabouunion varchar2(300) -- 
    ,weight number(38,0) -- 
    ,tempresidentnumber varchar2(4000) -- 
    ,probationenddate varchar2(500) -- 
    ,countryid number(38,0) -- 
    ,passwdchgdate varchar2(500) -- 
    ,needusb number(38,0) -- 
    ,serial varchar2(4000) -- 
    ,account varchar2(3000) -- 
    ,lloginid varchar2(4000) -- 
    ,needdynapass number(38,0) -- 
    ,dsporder number(38,12) -- 
    ,passwordstate number(38,0) -- 
    ,accounttype number(38,0) -- 
    ,belongto number(38,0) -- 
    ,dactylogram varchar2(4000) -- 
    ,assistantdactylogram varchar2(4000) -- 
    ,passwordlock number(38,0) -- 
    ,sumpasswordwrong number(38,0) -- 
    ,oldpassword1 varchar2(4000) -- 
    ,oldpassword2 varchar2(4000) -- 
    ,msgstyle varchar2(4000) -- 
    ,messagerurl varchar2(4000) -- 
    ,pinyinlastname varchar2(4000) -- 
    ,tokenkey varchar2(4000) -- 
    ,userusbtype varchar2(3000) -- 
    ,outkey varchar2(4000) -- 
    ,adsjgs varchar2(4000) -- 
    ,adgs varchar2(4000) -- 
    ,adbm varchar2(4000) -- 
    ,mobileshowtype number(38,0) -- 
    ,usbstate number(38,0) -- 
    ,totalspace number(38,12) -- 
    ,occupyspace number(38,12) -- 
    ,ecology_pinyin_search varchar2(4000) -- 
    ,isadaccount varchar2(300) -- 
    ,accountname varchar2(4000) -- 
    ,haschangepwd varchar2(3000) -- 
    ,created timestamp -- 
    ,creater number(38,0) -- 
    ,modified timestamp -- 
    ,modifier number(38,0) -- 
    ,passwordlocktime timestamp -- 
    ,mobilecaflag varchar2(3000) -- 
    ,salt varchar2(4000) -- 
    ,companystartdate varchar2(3000) -- 
    ,workstartdate varchar2(3000) -- 
    ,secondarypwd varchar2(4000) -- 
    ,usesecondarypwd number(38,0) -- 
    ,classification varchar2(300) -- 
    ,uuid varchar2(4000) -- 
    ,passwordlockreason varchar2(3000) -- 
    ,companyworkyear number(10,2) -- 
    ,workyear number(10,2) -- 
    ,dismissdate varchar2(500) -- 
    ,enckey varchar2(4000) -- 
    ,crc varchar2(4000) -- 
    ,usbscope number(38,0) -- 
    ,tenant_key varchar2(4000) -- 
    ,clauthtype varchar2(4000) -- 
    ,hashdata varchar2(4000) -- 
    ,signdata varchar2(4000) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.iops_hrmresource to ${iml_schema};
grant select on ${iol_schema}.iops_hrmresource to ${icl_schema};
grant select on ${iol_schema}.iops_hrmresource to ${idl_schema};
grant select on ${iol_schema}.iops_hrmresource to ${iel_schema};

-- comment
comment on table ${iol_schema}.iops_hrmresource is '';
comment on column ${iol_schema}.iops_hrmresource.id is '';
comment on column ${iol_schema}.iops_hrmresource.loginid is '';
comment on column ${iol_schema}.iops_hrmresource.password is '';
comment on column ${iol_schema}.iops_hrmresource.lastname is '';
comment on column ${iol_schema}.iops_hrmresource.sex is '';
comment on column ${iol_schema}.iops_hrmresource.birthday is '';
comment on column ${iol_schema}.iops_hrmresource.nationality is '';
comment on column ${iol_schema}.iops_hrmresource.systemlanguage is '';
comment on column ${iol_schema}.iops_hrmresource.maritalstatus is '';
comment on column ${iol_schema}.iops_hrmresource.telephone is '';
comment on column ${iol_schema}.iops_hrmresource.mobile is '';
comment on column ${iol_schema}.iops_hrmresource.mobilecall is '';
comment on column ${iol_schema}.iops_hrmresource.email is '';
comment on column ${iol_schema}.iops_hrmresource.locationid is '';
comment on column ${iol_schema}.iops_hrmresource.workroom is '';
comment on column ${iol_schema}.iops_hrmresource.homeaddress is '';
comment on column ${iol_schema}.iops_hrmresource.resourcetype is '';
comment on column ${iol_schema}.iops_hrmresource.startdate is '';
comment on column ${iol_schema}.iops_hrmresource.enddate is '';
comment on column ${iol_schema}.iops_hrmresource.jobtitle is '';
comment on column ${iol_schema}.iops_hrmresource.jobactivitydesc is '';
comment on column ${iol_schema}.iops_hrmresource.joblevel is '';
comment on column ${iol_schema}.iops_hrmresource.seclevel is '';
comment on column ${iol_schema}.iops_hrmresource.departmentid is '';
comment on column ${iol_schema}.iops_hrmresource.subcompanyid1 is '';
comment on column ${iol_schema}.iops_hrmresource.costcenterid is '';
comment on column ${iol_schema}.iops_hrmresource.managerid is '';
comment on column ${iol_schema}.iops_hrmresource.assistantid is '';
comment on column ${iol_schema}.iops_hrmresource.bankid1 is '';
comment on column ${iol_schema}.iops_hrmresource.accountid1 is '';
comment on column ${iol_schema}.iops_hrmresource.resourceimageid is '';
comment on column ${iol_schema}.iops_hrmresource.createrid is '';
comment on column ${iol_schema}.iops_hrmresource.createdate is '';
comment on column ${iol_schema}.iops_hrmresource.lastmodid is '';
comment on column ${iol_schema}.iops_hrmresource.lastmoddate is '';
comment on column ${iol_schema}.iops_hrmresource.lastlogindate is '';
comment on column ${iol_schema}.iops_hrmresource.datefield1 is '';
comment on column ${iol_schema}.iops_hrmresource.datefield2 is '';
comment on column ${iol_schema}.iops_hrmresource.datefield3 is '';
comment on column ${iol_schema}.iops_hrmresource.datefield4 is '';
comment on column ${iol_schema}.iops_hrmresource.datefield5 is '';
comment on column ${iol_schema}.iops_hrmresource.numberfield1 is '';
comment on column ${iol_schema}.iops_hrmresource.numberfield2 is '';
comment on column ${iol_schema}.iops_hrmresource.numberfield3 is '';
comment on column ${iol_schema}.iops_hrmresource.numberfield4 is '';
comment on column ${iol_schema}.iops_hrmresource.numberfield5 is '';
comment on column ${iol_schema}.iops_hrmresource.textfield1 is '';
comment on column ${iol_schema}.iops_hrmresource.textfield2 is '';
comment on column ${iol_schema}.iops_hrmresource.textfield3 is '';
comment on column ${iol_schema}.iops_hrmresource.textfield4 is '';
comment on column ${iol_schema}.iops_hrmresource.textfield5 is '';
comment on column ${iol_schema}.iops_hrmresource.tinyintfield1 is '';
comment on column ${iol_schema}.iops_hrmresource.tinyintfield2 is '';
comment on column ${iol_schema}.iops_hrmresource.tinyintfield3 is '';
comment on column ${iol_schema}.iops_hrmresource.tinyintfield4 is '';
comment on column ${iol_schema}.iops_hrmresource.tinyintfield5 is '';
comment on column ${iol_schema}.iops_hrmresource.certificatenum is '';
comment on column ${iol_schema}.iops_hrmresource.nativeplace is '';
comment on column ${iol_schema}.iops_hrmresource.educationlevel is '';
comment on column ${iol_schema}.iops_hrmresource.bememberdate is '';
comment on column ${iol_schema}.iops_hrmresource.bepartydate is '';
comment on column ${iol_schema}.iops_hrmresource.workcode is '';
comment on column ${iol_schema}.iops_hrmresource.regresidentplace is '';
comment on column ${iol_schema}.iops_hrmresource.healthinfo is '';
comment on column ${iol_schema}.iops_hrmresource.residentplace is '';
comment on column ${iol_schema}.iops_hrmresource.policy is '';
comment on column ${iol_schema}.iops_hrmresource.degree is '';
comment on column ${iol_schema}.iops_hrmresource.height is '';
comment on column ${iol_schema}.iops_hrmresource.usekind is '';
comment on column ${iol_schema}.iops_hrmresource.jobcall is '';
comment on column ${iol_schema}.iops_hrmresource.accumfundaccount is '';
comment on column ${iol_schema}.iops_hrmresource.birthplace is '';
comment on column ${iol_schema}.iops_hrmresource.folk is '';
comment on column ${iol_schema}.iops_hrmresource.residentphone is '';
comment on column ${iol_schema}.iops_hrmresource.residentpostcode is '';
comment on column ${iol_schema}.iops_hrmresource.extphone is '';
comment on column ${iol_schema}.iops_hrmresource.managerstr is '';
comment on column ${iol_schema}.iops_hrmresource.status is '';
comment on column ${iol_schema}.iops_hrmresource.fax is '';
comment on column ${iol_schema}.iops_hrmresource.islabouunion is '';
comment on column ${iol_schema}.iops_hrmresource.weight is '';
comment on column ${iol_schema}.iops_hrmresource.tempresidentnumber is '';
comment on column ${iol_schema}.iops_hrmresource.probationenddate is '';
comment on column ${iol_schema}.iops_hrmresource.countryid is '';
comment on column ${iol_schema}.iops_hrmresource.passwdchgdate is '';
comment on column ${iol_schema}.iops_hrmresource.needusb is '';
comment on column ${iol_schema}.iops_hrmresource.serial is '';
comment on column ${iol_schema}.iops_hrmresource.account is '';
comment on column ${iol_schema}.iops_hrmresource.lloginid is '';
comment on column ${iol_schema}.iops_hrmresource.needdynapass is '';
comment on column ${iol_schema}.iops_hrmresource.dsporder is '';
comment on column ${iol_schema}.iops_hrmresource.passwordstate is '';
comment on column ${iol_schema}.iops_hrmresource.accounttype is '';
comment on column ${iol_schema}.iops_hrmresource.belongto is '';
comment on column ${iol_schema}.iops_hrmresource.dactylogram is '';
comment on column ${iol_schema}.iops_hrmresource.assistantdactylogram is '';
comment on column ${iol_schema}.iops_hrmresource.passwordlock is '';
comment on column ${iol_schema}.iops_hrmresource.sumpasswordwrong is '';
comment on column ${iol_schema}.iops_hrmresource.oldpassword1 is '';
comment on column ${iol_schema}.iops_hrmresource.oldpassword2 is '';
comment on column ${iol_schema}.iops_hrmresource.msgstyle is '';
comment on column ${iol_schema}.iops_hrmresource.messagerurl is '';
comment on column ${iol_schema}.iops_hrmresource.pinyinlastname is '';
comment on column ${iol_schema}.iops_hrmresource.tokenkey is '';
comment on column ${iol_schema}.iops_hrmresource.userusbtype is '';
comment on column ${iol_schema}.iops_hrmresource.outkey is '';
comment on column ${iol_schema}.iops_hrmresource.adsjgs is '';
comment on column ${iol_schema}.iops_hrmresource.adgs is '';
comment on column ${iol_schema}.iops_hrmresource.adbm is '';
comment on column ${iol_schema}.iops_hrmresource.mobileshowtype is '';
comment on column ${iol_schema}.iops_hrmresource.usbstate is '';
comment on column ${iol_schema}.iops_hrmresource.totalspace is '';
comment on column ${iol_schema}.iops_hrmresource.occupyspace is '';
comment on column ${iol_schema}.iops_hrmresource.ecology_pinyin_search is '';
comment on column ${iol_schema}.iops_hrmresource.isadaccount is '';
comment on column ${iol_schema}.iops_hrmresource.accountname is '';
comment on column ${iol_schema}.iops_hrmresource.haschangepwd is '';
comment on column ${iol_schema}.iops_hrmresource.created is '';
comment on column ${iol_schema}.iops_hrmresource.creater is '';
comment on column ${iol_schema}.iops_hrmresource.modified is '';
comment on column ${iol_schema}.iops_hrmresource.modifier is '';
comment on column ${iol_schema}.iops_hrmresource.passwordlocktime is '';
comment on column ${iol_schema}.iops_hrmresource.mobilecaflag is '';
comment on column ${iol_schema}.iops_hrmresource.salt is '';
comment on column ${iol_schema}.iops_hrmresource.companystartdate is '';
comment on column ${iol_schema}.iops_hrmresource.workstartdate is '';
comment on column ${iol_schema}.iops_hrmresource.secondarypwd is '';
comment on column ${iol_schema}.iops_hrmresource.usesecondarypwd is '';
comment on column ${iol_schema}.iops_hrmresource.classification is '';
comment on column ${iol_schema}.iops_hrmresource.uuid is '';
comment on column ${iol_schema}.iops_hrmresource.passwordlockreason is '';
comment on column ${iol_schema}.iops_hrmresource.companyworkyear is '';
comment on column ${iol_schema}.iops_hrmresource.workyear is '';
comment on column ${iol_schema}.iops_hrmresource.dismissdate is '';
comment on column ${iol_schema}.iops_hrmresource.enckey is '';
comment on column ${iol_schema}.iops_hrmresource.crc is '';
comment on column ${iol_schema}.iops_hrmresource.usbscope is '';
comment on column ${iol_schema}.iops_hrmresource.tenant_key is '';
comment on column ${iol_schema}.iops_hrmresource.clauthtype is '';
comment on column ${iol_schema}.iops_hrmresource.hashdata is '';
comment on column ${iol_schema}.iops_hrmresource.signdata is '';
comment on column ${iol_schema}.iops_hrmresource.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.iops_hrmresource.etl_timestamp is 'ETL处理时间戳';
