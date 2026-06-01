/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tsabankinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tsabankinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tsabankinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tsabankinfo(
    bkcd varchar2(21) -- 
    ,bkbepsrunsts varchar2(2) -- 
    ,bkhvpsrunsts varchar2(2) -- 
    ,bkibpsrunsts varchar2(2) -- 
    ,banktype varchar2(3) -- 
    ,bkctgycd varchar2(5) -- 
    ,drctbkcd varchar2(21) -- 
    ,bkname varchar2(180) -- 
    ,bksname varchar2(180) -- 
    ,lglprsn varchar2(21) -- 
    ,hghptcpt varchar2(105) -- 
    ,brbkcd varchar2(21) -- 
    ,chrgbkcd varchar2(21) -- 
    ,ndcd varchar2(6) -- 
    ,citycd varchar2(9) -- 
    ,sgn varchar2(15) -- 
    ,tel varchar2(150) -- 
    ,chngnb varchar2(12) -- 
    ,fctvdt varchar2(12) -- 
    ,ifctvdt varchar2(12) -- 
    ,acctbkcdinf varchar2(21) -- 入账行行号信息
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
grant select on ${iol_schema}.mpcs_a08tsabankinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tsabankinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tsabankinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tsabankinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tsabankinfo is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.bkcd is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.bkbepsrunsts is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.bkhvpsrunsts is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.bkibpsrunsts is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.banktype is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.bkctgycd is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.drctbkcd is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.bkname is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.bksname is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.lglprsn is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.hghptcpt is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.brbkcd is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.chrgbkcd is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.ndcd is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.citycd is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.sgn is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.tel is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.chngnb is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.fctvdt is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.ifctvdt is '';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.acctbkcdinf is '入账行行号信息';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tsabankinfo.etl_timestamp is 'ETL处理时间戳';
