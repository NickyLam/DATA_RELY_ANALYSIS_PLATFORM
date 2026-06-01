/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tbefixsign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tbefixsign
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tbefixsign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbefixsign(
    unitcd varchar2(30) -- 
    ,cntrsq varchar2(24) -- 
    ,citycd varchar2(9) -- 
    ,cntrtp varchar2(6) -- 
    ,bustype varchar2(8) -- 
    ,servtype varchar2(18) -- 
    ,cntrno varchar2(90) -- 
    ,cntrst varchar2(2) -- 
    ,iotype varchar2(2) -- 
    ,recvbk varchar2(21) -- 
    ,rebkna varchar2(180) -- 
    ,recvac varchar2(48) -- 
    ,recvna varchar2(180) -- 
    ,pyerbk varchar2(21) -- 
    ,pybkna varchar2(180) -- 
    ,pyerac varchar2(48) -- 
    ,pyerna varchar2(180) -- 
    ,signdt varchar2(12) -- 
    ,cncldt varchar2(12) -- 
    ,userid varchar2(15) -- 
    ,brchno varchar2(9) -- 
    ,modidt varchar2(21) -- 
    ,modius varchar2(9) -- 
    ,remark varchar2(90) -- 
    ,rcvupbrn varchar2(21) -- 
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
grant select on ${iol_schema}.mpcs_a08tbefixsign to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tbefixsign to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tbefixsign to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tbefixsign to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tbefixsign is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.unitcd is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.cntrsq is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.citycd is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.cntrtp is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.bustype is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.servtype is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.cntrno is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.cntrst is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.iotype is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.recvbk is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.rebkna is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.recvac is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.recvna is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.pyerbk is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.pybkna is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.pyerac is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.pyerna is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.signdt is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.cncldt is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.userid is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.brchno is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.modidt is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.modius is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.remark is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.rcvupbrn is '';
comment on column ${iol_schema}.mpcs_a08tbefixsign.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tbefixsign.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tbefixsign.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tbefixsign.etl_timestamp is 'ETL处理时间戳';
