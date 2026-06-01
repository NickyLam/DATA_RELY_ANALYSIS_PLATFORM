/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_lcmd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_lcmd
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_lcmd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_lcmd(
    stacid number(19) -- 账套标记
    ,prcscd varchar2(20) -- 交易场景代码
    ,busitp varchar2(20) -- 业务类型
    ,eventp varchar2(16) -- 交易事件类型
    ,amtftg varchar2(1) -- 是否计量触发(0-否，1-是)
    ,tfcond varchar2(20) -- 触发条件
    ,fisttg varchar2(1) -- 是否首次交易(0-否，1-是)
    ,vlidtg varchar2(1) -- 是否启用(0-否，1-是)
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
grant select on ${iol_schema}.tgls_amc_lcmd to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_lcmd to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_lcmd to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_lcmd to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_lcmd is '生命周期模型表';
comment on column ${iol_schema}.tgls_amc_lcmd.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_lcmd.prcscd is '交易场景代码';
comment on column ${iol_schema}.tgls_amc_lcmd.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_lcmd.eventp is '交易事件类型';
comment on column ${iol_schema}.tgls_amc_lcmd.amtftg is '是否计量触发(0-否，1-是)';
comment on column ${iol_schema}.tgls_amc_lcmd.tfcond is '触发条件';
comment on column ${iol_schema}.tgls_amc_lcmd.fisttg is '是否首次交易(0-否，1-是)';
comment on column ${iol_schema}.tgls_amc_lcmd.vlidtg is '是否启用(0-否，1-是)';
comment on column ${iol_schema}.tgls_amc_lcmd.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_lcmd.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_lcmd.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_lcmd.etl_timestamp is 'ETL处理时间戳';
