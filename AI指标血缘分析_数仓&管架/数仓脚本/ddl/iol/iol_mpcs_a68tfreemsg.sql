/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tfreemsg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tfreemsg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tfreemsg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tfreemsg(
    msgseq varchar2(24) -- 
    ,consigndt varchar2(12) -- 
    ,bustype varchar2(8) -- 
    ,sndupbrn varchar2(21) -- 
    ,sndbrn varchar2(21) -- 
    ,rcvupbrn varchar2(21) -- 
    ,rcvbrn varchar2(21) -- 
    ,transtype varchar2(2) -- 
    ,status varchar2(3) -- 
    ,dotime varchar2(12) -- 
    ,sndtlr varchar2(750) -- 
    ,msgsrc varchar2(2) -- 
    ,info varchar2(1500) -- 
    ,magebrn varchar2(9) -- 
    ,refdid varchar2(30) -- 
    ,msgno varchar2(30) -- 
    ,befsdt varchar2(12) -- 
    ,errcode varchar2(12) -- 
    ,errms varchar2(384) -- 
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
grant select on ${iol_schema}.mpcs_a68tfreemsg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tfreemsg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tfreemsg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tfreemsg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tfreemsg is '深同城自由格式登记簿';
comment on column ${iol_schema}.mpcs_a68tfreemsg.msgseq is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.consigndt is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.bustype is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.sndupbrn is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.sndbrn is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.rcvupbrn is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.rcvbrn is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.transtype is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.status is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.dotime is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.sndtlr is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.msgsrc is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.info is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.magebrn is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.refdid is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.msgno is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.befsdt is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.errcode is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.errms is '';
comment on column ${iol_schema}.mpcs_a68tfreemsg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a68tfreemsg.etl_timestamp is 'ETL处理时间戳';
