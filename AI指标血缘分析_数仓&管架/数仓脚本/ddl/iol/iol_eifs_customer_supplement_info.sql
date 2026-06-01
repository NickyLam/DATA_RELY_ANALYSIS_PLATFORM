/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_customer_supplement_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_customer_supplement_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_customer_supplement_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_customer_supplement_info(
    custno varchar2(30) -- 
    ,custle varchar2(383) -- 
    ,custlv varchar2(15) -- 
    ,statlv varchar2(15) -- 
    ,jonttg varchar2(2) -- 
    ,doubtp varchar2(15) -- 
    ,tttrib number(18,2) -- 
    ,ttrema number(18,2) -- 
    ,risklv varchar2(15) -- 
    ,datatp varchar2(15) -- 
    ,roletp varchar2(15) -- 
    ,isincu varchar2(2) -- 
    ,iscred varchar2(2) -- 
    ,credid varchar2(15) -- 
    ,credln number(18,2) -- 
    ,prsntp varchar2(2) -- 
    ,renatg varchar2(2) -- 
    ,rgstad varchar2(30) -- 
    ,sjcate varchar2(2) -- 
    ,oralla varchar2(90) -- 
    ,plvscd varchar2(12) -- 
    ,health varchar2(12) -- 
    ,fvrttx varchar2(383) -- 
    ,chartg varchar2(2) -- 
    ,credre varchar2(2) -- 
    ,fmlynm number(20) -- 
    ,school varchar2(383) -- 
    ,insrid varchar2(30) -- 
    ,lncdno varchar2(30) -- 
    ,lncdpw varchar2(12) -- 
    ,lncdtg varchar2(2) -- 
    ,lncddt varchar2(12) -- 
    ,lncdst varchar2(12) -- 
    ,lcditg varchar2(2) -- 
    ,lcdidt varchar2(12) -- 
    ,lcdrdt varchar2(12) -- 
    ,incmfy number(18,2) -- 
    ,hmyrpy number(18,2) -- 
    ,gudian varchar2(30) -- 
    ,relatg varchar2(2) -- 
    ,remark varchar2(383) -- 
    ,slrybk varchar2(150) -- 
    ,slryno varchar2(30) -- 
    ,nwhock number(18,2) -- 
    ,workyr number(20) -- 
    ,workdt varchar2(12) -- 
    ,wkexis varchar2(2) -- 
    ,limacd varchar2(12) -- 
    ,homads varchar2(383) -- 
    ,idadss varchar2(383) -- 
    ,hutype varchar2(12) -- 
    ,hmsupp number(20) -- 
    ,hmasse number(18,2) -- 
    ,identf varchar2(30) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,other_occupation varchar2(75) -- 
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
grant select on ${iol_schema}.eifs_customer_supplement_info to ${iml_schema};
grant select on ${iol_schema}.eifs_customer_supplement_info to ${icl_schema};
grant select on ${iol_schema}.eifs_customer_supplement_info to ${idl_schema};
grant select on ${iol_schema}.eifs_customer_supplement_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_customer_supplement_info is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.custno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.custle is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.custlv is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.statlv is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.jonttg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.doubtp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.tttrib is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.ttrema is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.risklv is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.datatp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.roletp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.isincu is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.iscred is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.credid is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.credln is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.prsntp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.renatg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.rgstad is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.sjcate is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.oralla is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.plvscd is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.health is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.fvrttx is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.chartg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.credre is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.fmlynm is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.school is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.insrid is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lncdno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lncdpw is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lncdtg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lncddt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lncdst is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lcditg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lcdidt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.lcdrdt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.incmfy is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.hmyrpy is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.gudian is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.relatg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.remark is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.slrybk is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.slryno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.nwhock is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.workyr is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.workdt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.wkexis is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.limacd is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.homads is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.idadss is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.hutype is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.hmsupp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.hmasse is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.identf is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.last_updated_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.last_updated_tx_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.created_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.created_tx_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.other_occupation is '';
comment on column ${iol_schema}.eifs_customer_supplement_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_customer_supplement_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_customer_supplement_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_customer_supplement_info.etl_timestamp is 'ETL处理时间戳';
