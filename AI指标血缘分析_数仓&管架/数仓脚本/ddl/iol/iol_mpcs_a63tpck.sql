/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a63tpck
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a63tpck
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a63tpck purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a63tpck(
    custno varchar2(30) -- 
    ,entworkdt varchar2(12) -- 
    ,entseqno varchar2(45) -- 
    ,signno varchar2(38) -- 
    ,acctno varchar2(39) -- 
    ,trncd varchar2(15) -- 
    ,rqpck varchar2(4000) -- 
    ,rspck varchar2(4000) -- 
    ,trnts timestamp -- 
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
grant select on ${iol_schema}.mpcs_a63tpck to ${iml_schema};
grant select on ${iol_schema}.mpcs_a63tpck to ${icl_schema};
grant select on ${iol_schema}.mpcs_a63tpck to ${idl_schema};
grant select on ${iol_schema}.mpcs_a63tpck to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a63tpck is '交易报文表';
comment on column ${iol_schema}.mpcs_a63tpck.custno is '';
comment on column ${iol_schema}.mpcs_a63tpck.entworkdt is '';
comment on column ${iol_schema}.mpcs_a63tpck.entseqno is '';
comment on column ${iol_schema}.mpcs_a63tpck.signno is '';
comment on column ${iol_schema}.mpcs_a63tpck.acctno is '';
comment on column ${iol_schema}.mpcs_a63tpck.trncd is '';
comment on column ${iol_schema}.mpcs_a63tpck.rqpck is '';
comment on column ${iol_schema}.mpcs_a63tpck.rspck is '';
comment on column ${iol_schema}.mpcs_a63tpck.trnts is '';
comment on column ${iol_schema}.mpcs_a63tpck.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a63tpck.etl_timestamp is 'ETL处理时间戳';
