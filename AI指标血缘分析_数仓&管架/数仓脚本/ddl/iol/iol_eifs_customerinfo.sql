/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_customerinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_customerinfo
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_customerinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_customerinfo(
    partyid varchar2(30) -- 
    ,customername varchar2(300) -- 
    ,englishname varchar2(300) -- 
    ,custbriefname varchar2(30) -- 
    ,hadusedname varchar2(300) -- 
    ,gender varchar2(3) -- 
    ,residentflag varchar2(2) -- 
    ,whetherbankstaff varchar2(2) -- 
    ,birthdate varchar2(15) -- 
    ,nationality varchar2(6) -- 
    ,administrativedivisionscode varchar2(15) -- 
    ,customergrade varchar2(3) -- 
    ,riskgrade varchar2(6) -- 
    ,qualify varchar2(6) -- 
    ,maritalstatus varchar2(3) -- 
    ,highestdegree varchar2(2) -- 
    ,placeorigin varchar2(15) -- 
    ,nation varchar2(6) -- 
    ,whetherfarmer varchar2(2) -- 
    ,personalmonthrevenue varchar2(27) -- 
    ,familymonthrevenue varchar2(27) -- 
    ,yearincome varchar2(33) -- 
    ,familyannualincome varchar2(33) -- 
    ,whethershareholder varchar2(2) -- 
    ,whetherbankkeycustomer varchar2(2) -- 
    ,whetherbankblacklist varchar2(2) -- 
    ,creditrrating varchar2(5) -- 
    ,recommendationtype varchar2(2) -- 
    ,recommendationnum varchar2(30) -- 
    ,marketingnum varchar2(30) -- 
    ,belongdepartment varchar2(75) -- 
    ,whetherindividualmerchant varchar2(2) -- 
    ,individualbusinesslicense varchar2(30) -- 
    ,workstatus varchar2(3) -- 
    ,livestatus varchar2(5) -- 
    ,interests varchar2(3) -- 
    ,bloodtype varchar2(2) -- 
    ,individualsites varchar2(300) -- 
    ,nickname varchar2(90) -- 
    ,headportrait varchar2(300) -- 
    ,isinterconnectcheck varchar2(3) -- 
    ,remarks varchar2(75) -- 
    ,customerfeature1 varchar2(15) -- 
    ,customerfeature2 varchar2(15) -- 
    ,contactcertificatetypeid varchar2(8) -- 
    ,infostring varchar2(30) -- 
    ,fromdate varchar2(15) -- 
    ,thrudate varchar2(15) -- 
    ,certificatevalid varchar2(8) -- 
    ,authorg varchar2(30) -- 
    ,authaddrcode varchar2(30) -- 
    ,authaddrname varchar2(30) -- 
    ,addr varchar2(93) -- 
    ,ismaincertificate varchar2(2) -- 
    ,fax varchar2(45) -- 
    ,wechat varchar2(45) -- 
    ,qq varchar2(45) -- 
    ,momo varchar2(45) -- 
    ,weibo varchar2(45) -- 
    ,email varchar2(75) -- 
    ,othertel varchar2(45) -- 
    ,homephone varchar2(45) -- 
    ,officephone varchar2(45) -- 
    ,hukouaddr varchar2(300) -- 
    ,residentaddr varchar2(300) -- 
    ,custcontactaddr varchar2(300) -- 
    ,custcompanyaddr varchar2(300) -- 
    ,workunitname varchar2(180) -- 
    ,workunitaddr varchar2(300) -- 
    ,workunitphone varchar2(45) -- 
    ,workunitproperty varchar2(6) -- 
    ,workunitbelongindustry varchar2(12) -- 
    ,workunitzipcode varchar2(15) -- 
    ,workpermitno varchar2(30) -- 
    ,industry varchar2(8) -- 
    ,otheroccupation varchar2(8) -- 
    ,title varchar2(6) -- 
    ,duty varchar2(6) -- 
    ,workmonthlyincome varchar2(27) -- 
    ,workproperty varchar2(15) -- 
    ,entrydate varchar2(15) -- 
    ,quitdate varchar2(15) -- 
    ,gradeupgrade varchar2(15) -- 
    ,relpeocerttypeid varchar2(8) -- 
    ,relpeocertnum varchar2(30) -- 
    ,relpeoname varchar2(150) -- 
    ,relpeobirthdate varchar2(15) -- 
    ,relpeogender varchar2(3) -- 
    ,relationpeopletype varchar2(8) -- 
    ,custcommuddr varchar2(300) -- 
    ,custcommuddrzip varchar2(30) -- 
    ,residentaddrzip varchar2(30) -- 
    ,relpeonum varchar2(45) -- 
    ,relpeounitname varchar2(180) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.eifs_customerinfo to ${iml_schema};
grant select on ${iol_schema}.eifs_customerinfo to ${icl_schema};
grant select on ${iol_schema}.eifs_customerinfo to ${idl_schema};
grant select on ${iol_schema}.eifs_customerinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_customerinfo is '';
comment on column ${iol_schema}.eifs_customerinfo.partyid is '';
comment on column ${iol_schema}.eifs_customerinfo.customername is '';
comment on column ${iol_schema}.eifs_customerinfo.englishname is '';
comment on column ${iol_schema}.eifs_customerinfo.custbriefname is '';
comment on column ${iol_schema}.eifs_customerinfo.hadusedname is '';
comment on column ${iol_schema}.eifs_customerinfo.gender is '';
comment on column ${iol_schema}.eifs_customerinfo.residentflag is '';
comment on column ${iol_schema}.eifs_customerinfo.whetherbankstaff is '';
comment on column ${iol_schema}.eifs_customerinfo.birthdate is '';
comment on column ${iol_schema}.eifs_customerinfo.nationality is '';
comment on column ${iol_schema}.eifs_customerinfo.administrativedivisionscode is '';
comment on column ${iol_schema}.eifs_customerinfo.customergrade is '';
comment on column ${iol_schema}.eifs_customerinfo.riskgrade is '';
comment on column ${iol_schema}.eifs_customerinfo.qualify is '';
comment on column ${iol_schema}.eifs_customerinfo.maritalstatus is '';
comment on column ${iol_schema}.eifs_customerinfo.highestdegree is '';
comment on column ${iol_schema}.eifs_customerinfo.placeorigin is '';
comment on column ${iol_schema}.eifs_customerinfo.nation is '';
comment on column ${iol_schema}.eifs_customerinfo.whetherfarmer is '';
comment on column ${iol_schema}.eifs_customerinfo.personalmonthrevenue is '';
comment on column ${iol_schema}.eifs_customerinfo.familymonthrevenue is '';
comment on column ${iol_schema}.eifs_customerinfo.yearincome is '';
comment on column ${iol_schema}.eifs_customerinfo.familyannualincome is '';
comment on column ${iol_schema}.eifs_customerinfo.whethershareholder is '';
comment on column ${iol_schema}.eifs_customerinfo.whetherbankkeycustomer is '';
comment on column ${iol_schema}.eifs_customerinfo.whetherbankblacklist is '';
comment on column ${iol_schema}.eifs_customerinfo.creditrrating is '';
comment on column ${iol_schema}.eifs_customerinfo.recommendationtype is '';
comment on column ${iol_schema}.eifs_customerinfo.recommendationnum is '';
comment on column ${iol_schema}.eifs_customerinfo.marketingnum is '';
comment on column ${iol_schema}.eifs_customerinfo.belongdepartment is '';
comment on column ${iol_schema}.eifs_customerinfo.whetherindividualmerchant is '';
comment on column ${iol_schema}.eifs_customerinfo.individualbusinesslicense is '';
comment on column ${iol_schema}.eifs_customerinfo.workstatus is '';
comment on column ${iol_schema}.eifs_customerinfo.livestatus is '';
comment on column ${iol_schema}.eifs_customerinfo.interests is '';
comment on column ${iol_schema}.eifs_customerinfo.bloodtype is '';
comment on column ${iol_schema}.eifs_customerinfo.individualsites is '';
comment on column ${iol_schema}.eifs_customerinfo.nickname is '';
comment on column ${iol_schema}.eifs_customerinfo.headportrait is '';
comment on column ${iol_schema}.eifs_customerinfo.isinterconnectcheck is '';
comment on column ${iol_schema}.eifs_customerinfo.remarks is '';
comment on column ${iol_schema}.eifs_customerinfo.customerfeature1 is '';
comment on column ${iol_schema}.eifs_customerinfo.customerfeature2 is '';
comment on column ${iol_schema}.eifs_customerinfo.contactcertificatetypeid is '';
comment on column ${iol_schema}.eifs_customerinfo.infostring is '';
comment on column ${iol_schema}.eifs_customerinfo.fromdate is '';
comment on column ${iol_schema}.eifs_customerinfo.thrudate is '';
comment on column ${iol_schema}.eifs_customerinfo.certificatevalid is '';
comment on column ${iol_schema}.eifs_customerinfo.authorg is '';
comment on column ${iol_schema}.eifs_customerinfo.authaddrcode is '';
comment on column ${iol_schema}.eifs_customerinfo.authaddrname is '';
comment on column ${iol_schema}.eifs_customerinfo.addr is '';
comment on column ${iol_schema}.eifs_customerinfo.ismaincertificate is '';
comment on column ${iol_schema}.eifs_customerinfo.fax is '';
comment on column ${iol_schema}.eifs_customerinfo.wechat is '';
comment on column ${iol_schema}.eifs_customerinfo.qq is '';
comment on column ${iol_schema}.eifs_customerinfo.momo is '';
comment on column ${iol_schema}.eifs_customerinfo.weibo is '';
comment on column ${iol_schema}.eifs_customerinfo.email is '';
comment on column ${iol_schema}.eifs_customerinfo.othertel is '';
comment on column ${iol_schema}.eifs_customerinfo.homephone is '';
comment on column ${iol_schema}.eifs_customerinfo.officephone is '';
comment on column ${iol_schema}.eifs_customerinfo.hukouaddr is '';
comment on column ${iol_schema}.eifs_customerinfo.residentaddr is '';
comment on column ${iol_schema}.eifs_customerinfo.custcontactaddr is '';
comment on column ${iol_schema}.eifs_customerinfo.custcompanyaddr is '';
comment on column ${iol_schema}.eifs_customerinfo.workunitname is '';
comment on column ${iol_schema}.eifs_customerinfo.workunitaddr is '';
comment on column ${iol_schema}.eifs_customerinfo.workunitphone is '';
comment on column ${iol_schema}.eifs_customerinfo.workunitproperty is '';
comment on column ${iol_schema}.eifs_customerinfo.workunitbelongindustry is '';
comment on column ${iol_schema}.eifs_customerinfo.workunitzipcode is '';
comment on column ${iol_schema}.eifs_customerinfo.workpermitno is '';
comment on column ${iol_schema}.eifs_customerinfo.industry is '';
comment on column ${iol_schema}.eifs_customerinfo.otheroccupation is '';
comment on column ${iol_schema}.eifs_customerinfo.title is '';
comment on column ${iol_schema}.eifs_customerinfo.duty is '';
comment on column ${iol_schema}.eifs_customerinfo.workmonthlyincome is '';
comment on column ${iol_schema}.eifs_customerinfo.workproperty is '';
comment on column ${iol_schema}.eifs_customerinfo.entrydate is '';
comment on column ${iol_schema}.eifs_customerinfo.quitdate is '';
comment on column ${iol_schema}.eifs_customerinfo.gradeupgrade is '';
comment on column ${iol_schema}.eifs_customerinfo.relpeocerttypeid is '';
comment on column ${iol_schema}.eifs_customerinfo.relpeocertnum is '';
comment on column ${iol_schema}.eifs_customerinfo.relpeoname is '';
comment on column ${iol_schema}.eifs_customerinfo.relpeobirthdate is '';
comment on column ${iol_schema}.eifs_customerinfo.relpeogender is '';
comment on column ${iol_schema}.eifs_customerinfo.relationpeopletype is '';
comment on column ${iol_schema}.eifs_customerinfo.custcommuddr is '';
comment on column ${iol_schema}.eifs_customerinfo.custcommuddrzip is '';
comment on column ${iol_schema}.eifs_customerinfo.residentaddrzip is '';
comment on column ${iol_schema}.eifs_customerinfo.relpeonum is '';
comment on column ${iol_schema}.eifs_customerinfo.relpeounitname is '';
comment on column ${iol_schema}.eifs_customerinfo.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_customerinfo.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_customerinfo.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_customerinfo.etl_timestamp is 'ETL处理时间戳';
