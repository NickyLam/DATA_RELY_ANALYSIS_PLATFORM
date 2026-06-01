/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08thvbilltran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08thvbilltran
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08thvbilltran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08thvbilltran(
    mainsq varchar2(24) -- 
    ,trandt number(22) -- 
    ,packno varchar2(6) -- 
    ,busino varchar2(2) -- 
    ,biflag varchar2(24) -- 
    ,busifg varchar2(5) -- 
    ,errinf varchar2(192) -- 
    ,bepsdt varchar2(12) -- 
    ,sequno varchar2(18) -- 
    ,recvbk varchar2(18) -- 
    ,recvac varchar2(48) -- 
    ,recvna varchar2(90) -- 
    ,billbk varchar2(18) -- 
    ,billac varchar2(48) -- 
    ,billna varchar2(90) -- 
    ,crcycd varchar2(5) -- 
    ,billam number(15,2) -- 
    ,billno varchar2(24) -- 
    ,billdt varchar2(12) -- 
    ,notedt varchar2(12) -- 
    ,passwd varchar2(30) -- 
    ,bikind varchar2(5) -- 
    ,transt varchar2(3) -- 
    ,busflg varchar2(3) -- 
    ,dataid varchar2(60) -- 
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
grant select on ${iol_schema}.mpcs_a08thvbilltran to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08thvbilltran to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08thvbilltran to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08thvbilltran to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08thvbilltran is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.mainsq is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.trandt is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.packno is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.busino is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.biflag is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.busifg is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.errinf is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.bepsdt is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.sequno is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.recvbk is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.recvac is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.recvna is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.billbk is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.billac is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.billna is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.crcycd is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.billam is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.billno is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.billdt is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.notedt is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.passwd is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.bikind is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.transt is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.busflg is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.dataid is '';
comment on column ${iol_schema}.mpcs_a08thvbilltran.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08thvbilltran.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08thvbilltran.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08thvbilltran.etl_timestamp is 'ETL处理时间戳';
