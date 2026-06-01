/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tfreemsg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tfreemsg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tfreemsg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tfreemsg(
    msgseq varchar2(24) -- 
    ,consigndt varchar2(12) -- 
    ,sndct varchar2(6) -- 
    ,sndupbrn varchar2(21) -- 
    ,sndbrn varchar2(21) -- 
    ,rcvct varchar2(6) -- 
    ,rcvupbrn varchar2(21) -- 
    ,rcvbrn varchar2(21) -- 
    ,transtype varchar2(2) -- 
    ,status varchar2(3) -- 
    ,dotime varchar2(12) -- 
    ,sndtlr varchar2(15) -- 
    ,msgsrc varchar2(2) -- 
    ,info varchar2(1500) -- 
    ,magebrn varchar2(9) -- 
    ,refdid varchar2(30) -- 
    ,msgno varchar2(30) -- 
    ,bepsdt varchar2(12) -- 
    ,errcode varchar2(12) -- 
    ,errms varchar2(384) -- 
    ,ourcnapsver varchar2(3) -- 
    ,othercnapsver varchar2(3) -- 
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
grant select on ${iol_schema}.mpcs_a08tfreemsg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tfreemsg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tfreemsg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tfreemsg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tfreemsg is '大小额自由格式登记簿';
comment on column ${iol_schema}.mpcs_a08tfreemsg.msgseq is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.consigndt is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.sndct is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.sndupbrn is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.sndbrn is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.rcvct is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.rcvupbrn is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.rcvbrn is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.transtype is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.status is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.dotime is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.sndtlr is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.msgsrc is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.info is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.magebrn is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.refdid is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.msgno is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.bepsdt is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.errcode is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.errms is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.ourcnapsver is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.othercnapsver is '';
comment on column ${iol_schema}.mpcs_a08tfreemsg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tfreemsg.etl_timestamp is 'ETL处理时间戳';
