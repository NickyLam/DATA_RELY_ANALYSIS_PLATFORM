/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_ifm0001t
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_ifm0001t
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_ifm0001t purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_ifm0001t(
    sccode varchar2(48) -- 
    ,bankacc varchar2(48) -- 
    ,serialno varchar2(36) -- 
    ,account varchar2(48) -- 
    ,clientname varchar2(120) -- 
    ,tacode varchar2(9) -- 
    ,prdcode varchar2(30) -- 
    ,prdname varchar2(375) -- 
    ,frozencause varchar2(2) -- 
    ,lawno varchar2(36) -- 
    ,orgname varchar2(90) -- 
    ,enddate varchar2(12) -- 
    ,status varchar2(2) -- 
    ,taname varchar2(90) -- 
    ,statusname varchar2(30) -- 
    ,clientno varchar2(48) -- 
    ,flag varchar2(2) -- 
    ,trandt varchar2(15) -- 核心交易日期
    ,transq varchar2(30) -- 核心交易流水
    ,acctno varchar2(60) -- 保证金账号
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
grant select on ${iol_schema}.mims_yp_ifm0001t to ${iml_schema};
grant select on ${iol_schema}.mims_yp_ifm0001t to ${icl_schema};
grant select on ${iol_schema}.mims_yp_ifm0001t to ${idl_schema};
grant select on ${iol_schema}.mims_yp_ifm0001t to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_ifm0001t is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.sccode is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.bankacc is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.serialno is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.account is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.clientname is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.tacode is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.prdcode is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.prdname is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.frozencause is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.lawno is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.orgname is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.enddate is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.status is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.taname is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.statusname is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.clientno is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.flag is '';
comment on column ${iol_schema}.mims_yp_ifm0001t.trandt is '核心交易日期';
comment on column ${iol_schema}.mims_yp_ifm0001t.transq is '核心交易流水';
comment on column ${iol_schema}.mims_yp_ifm0001t.acctno is '保证金账号';
comment on column ${iol_schema}.mims_yp_ifm0001t.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_ifm0001t.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_ifm0001t.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_ifm0001t.etl_timestamp is 'ETL处理时间戳';
