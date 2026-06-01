/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tbankinfotmp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tbankinfotmp
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tbankinfotmp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbankinfotmp(
    trndt varchar2(15) -- 
    ,transmitdt varchar2(30) -- 
    ,transseq varchar2(24) -- 
    ,sndbrn varchar2(21) -- 
    ,sndupbrn varchar2(21) -- 
    ,rcvbrn varchar2(21) -- 
    ,rcvupbrn varchar2(21) -- 
    ,syscd varchar2(6) -- 
    ,chngtp varchar2(6) -- 
    ,bkcd varchar2(21) -- 
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
grant select on ${iol_schema}.mpcs_a08tbankinfotmp to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tbankinfotmp to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tbankinfotmp to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tbankinfotmp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tbankinfotmp is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.trndt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.transmitdt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.transseq is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.sndbrn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.sndupbrn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.rcvbrn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.rcvupbrn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.syscd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.chngtp is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.bkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.bkstatus is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.banktype is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.bkctgycd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.drctbkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.bkname is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.bksname is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.lglprsn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.hghptcpt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.brbkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.chrgbkcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.ndcd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.citycd is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.sgn is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.tel is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.chngnb is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.fctvdt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.ifctvdt is '';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.acctbkcdinf is '入账行行号信息';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tbankinfotmp.etl_timestamp is 'ETL处理时间戳';
