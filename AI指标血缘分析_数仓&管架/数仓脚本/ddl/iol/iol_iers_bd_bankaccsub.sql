/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bd_bankaccsub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bd_bankaccsub
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bd_bankaccsub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_bankaccsub(
    accname varchar2(200) -- 
    ,accnum varchar2(40) -- 
    ,acctype number(38) -- 
    ,banknotespec varchar2(1) -- 
    ,code varchar2(40) -- 
    ,concertedmny number(16,4) -- 
    ,cooverdraf varchar2(1) -- 
    ,creationtime varchar2(19) -- 
    ,creator varchar2(20) -- 
    ,dataoriginflag number(38) -- 
    ,def1 varchar2(101) -- 
    ,def10 varchar2(101) -- 
    ,def11 varchar2(101) -- 
    ,def12 varchar2(101) -- 
    ,def13 varchar2(101) -- 
    ,def14 varchar2(101) -- 
    ,def15 varchar2(101) -- 
    ,def16 varchar2(101) -- 
    ,def17 varchar2(101) -- 
    ,def18 varchar2(101) -- 
    ,def19 varchar2(101) -- 
    ,def2 varchar2(101) -- 
    ,def20 varchar2(101) -- 
    ,def3 varchar2(101) -- 
    ,def4 varchar2(101) -- 
    ,def5 varchar2(101) -- 
    ,def6 varchar2(101) -- 
    ,def7 varchar2(101) -- 
    ,def8 varchar2(101) -- 
    ,def9 varchar2(101) -- 
    ,defrozendate varchar2(19) -- 
    ,dr number(10) -- 
    ,fronzenmny number(16,4) -- 
    ,fronzenstate number(38) -- 
    ,frozendate varchar2(19) -- 
    ,isconcerted varchar2(1) -- 
    ,isdefault varchar2(1) -- 
    ,istrade varchar2(1) -- 
    ,modifiedtime varchar2(19) -- 
    ,modifier varchar2(20) -- 
    ,name varchar2(300) -- 
    ,name2 varchar2(300) -- 
    ,name3 varchar2(300) -- 
    ,name4 varchar2(300) -- 
    ,name5 varchar2(300) -- 
    ,name6 varchar2(300) -- 
    ,overdraftmny number(16,4) -- 
    ,overdrafttype number(38) -- 
    ,payarea number(38) -- 
    ,pk_bankaccbas varchar2(20) -- 
    ,pk_bankaccsub varchar2(20) -- 
    ,pk_currtype varchar2(20) -- 
    ,ts varchar2(19) -- 
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
grant select on ${iol_schema}.iers_bd_bankaccsub to ${iml_schema};
grant select on ${iol_schema}.iers_bd_bankaccsub to ${icl_schema};
grant select on ${iol_schema}.iers_bd_bankaccsub to ${idl_schema};
grant select on ${iol_schema}.iers_bd_bankaccsub to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bd_bankaccsub is '个人银行账户子户';
comment on column ${iol_schema}.iers_bd_bankaccsub.accname is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.accnum is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.acctype is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.banknotespec is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.code is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.concertedmny is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.cooverdraf is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.creationtime is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.creator is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.dataoriginflag is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def1 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def10 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def11 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def12 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def13 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def14 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def15 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def16 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def17 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def18 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def19 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def2 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def20 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def3 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def4 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def5 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def6 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def7 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def8 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.def9 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.defrozendate is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.dr is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.fronzenmny is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.fronzenstate is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.frozendate is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.isconcerted is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.isdefault is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.istrade is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.modifiedtime is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.modifier is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.name is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.name2 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.name3 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.name4 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.name5 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.name6 is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.overdraftmny is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.overdrafttype is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.payarea is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.pk_bankaccbas is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.pk_bankaccsub is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.pk_currtype is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.ts is '';
comment on column ${iol_schema}.iers_bd_bankaccsub.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bd_bankaccsub.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bd_bankaccsub.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bd_bankaccsub.etl_timestamp is 'ETL处理时间戳';
