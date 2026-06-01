/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_acel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_acel
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_acel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_acel(
    stacid number(19) -- 账套标记
    ,elemcd varchar2(16) -- 要素编号
    ,elemna varchar2(100) -- 要素名称
    ,busitp varchar2(20) -- 业务类型
    ,elemtp varchar2(1) -- 要素类型
    ,status varchar2(1) -- 是否启用
    ,usedtp varchar2(1) -- 使用状态
    ,tablna varchar2(20) -- 涉及表名
    ,tablcl varchar2(11) -- 涉及表列名
    ,engist varchar2(1) -- 与会计引擎交易流水是否存在对应关系
    ,crpdtp varchar2(1) -- 与会计引擎中字段对应关系
    ,varicd varchar2(120) -- 对应会计引擎交易流水数据结构变量编码
    ,desctx varchar2(255) -- 说明
    ,sortno number(10) -- 排序
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
grant select on ${iol_schema}.tgls_amc_acel to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_acel to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_acel to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_acel to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_acel is '会计计量分户要素定义表';
comment on column ${iol_schema}.tgls_amc_acel.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_acel.elemcd is '要素编号';
comment on column ${iol_schema}.tgls_amc_acel.elemna is '要素名称';
comment on column ${iol_schema}.tgls_amc_acel.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_acel.elemtp is '要素类型';
comment on column ${iol_schema}.tgls_amc_acel.status is '是否启用';
comment on column ${iol_schema}.tgls_amc_acel.usedtp is '使用状态';
comment on column ${iol_schema}.tgls_amc_acel.tablna is '涉及表名';
comment on column ${iol_schema}.tgls_amc_acel.tablcl is '涉及表列名';
comment on column ${iol_schema}.tgls_amc_acel.engist is '与会计引擎交易流水是否存在对应关系';
comment on column ${iol_schema}.tgls_amc_acel.crpdtp is '与会计引擎中字段对应关系';
comment on column ${iol_schema}.tgls_amc_acel.varicd is '对应会计引擎交易流水数据结构变量编码';
comment on column ${iol_schema}.tgls_amc_acel.desctx is '说明';
comment on column ${iol_schema}.tgls_amc_acel.sortno is '排序';
comment on column ${iol_schema}.tgls_amc_acel.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_acel.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_acel.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_acel.etl_timestamp is 'ETL处理时间戳';
