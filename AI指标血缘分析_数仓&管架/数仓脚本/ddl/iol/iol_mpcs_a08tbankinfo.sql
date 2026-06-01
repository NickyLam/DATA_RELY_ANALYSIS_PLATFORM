/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tbankinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tbankinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tbankinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbankinfo(
    bkcd varchar2(21) -- 
    ,bkstatus varchar2(2) -- 
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
grant select on ${iol_schema}.mpcs_a08tbankinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tbankinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tbankinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tbankinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tbankinfo is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.bkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.bkstatus is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.banktype is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.bkctgycd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.drctbkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.bkname is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.bksname is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.lglprsn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.hghptcpt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.brbkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.chrgbkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.ndcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.citycd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.sgn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.tel is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.chngnb is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.fctvdt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.ifctvdt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfo.acctbkcdinf is '入账行行号信息';
comment on column ${iol_schema}.mpcs_a08tbankinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tbankinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tbankinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tbankinfo.etl_timestamp is 'ETL处理时间戳';
