/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_lcmd_trcd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_lcmd_trcd
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_lcmd_trcd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_lcmd_trcd(
    stacid number(19) -- 账套标记
    ,prcscd varchar2(20) -- 交易场景代码
    ,trancd varchar2(20) -- 子交易代码
    ,condcd varchar2(20) -- 子交易执行条件
    ,sortno number -- 子交易执行顺序
    ,valide varchar2(1) -- 启用标识,0-否1-是
    ,busitp varchar2(16) -- 业务类型
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
grant select on ${iol_schema}.tgls_amc_lcmd_trcd to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_lcmd_trcd to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_lcmd_trcd to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_lcmd_trcd to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_lcmd_trcd is '生命周期模型子表';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.prcscd is '交易场景代码';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.trancd is '子交易代码';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.condcd is '子交易执行条件';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.sortno is '子交易执行顺序';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.valide is '启用标识,0-否1-是';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_lcmd_trcd.etl_timestamp is 'ETL处理时间戳';
