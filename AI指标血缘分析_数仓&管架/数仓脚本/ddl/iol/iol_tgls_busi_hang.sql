/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_busi_hang
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_busi_hang
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_busi_hang purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_busi_hang(
    stacid number(9) -- 账套
    ,systid varchar2(8) -- 交易来源系统编号
    ,trandt varchar2(16) -- 交易日期
    ,transq varchar2(128) -- 交易流水
    ,tablcd varchar2(240) -- 接口表编码
    ,trdata varchar2(4000) -- 交易流水数据json数组
    ,status varchar2(2) -- 处理状态：0未处理1已处理
    ,sourtp varchar2(2) -- 来源（1：手工终止2：错账冲销3:手工补录流水）
    ,dealtp varchar2(2) -- 处理方式（1：业务系统重传2：手工修改流水3：标记为重复流水4：已修改核算规则5：已补录核算规则6：无修改重新解析）
    ,retran varchar2(128) -- 关联流水号
    ,soursq varchar2(128) -- 源流水号
    ,sourdt varchar2(16) -- 源交易日期
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
grant select on ${iol_schema}.tgls_busi_hang to ${iml_schema};
grant select on ${iol_schema}.tgls_busi_hang to ${icl_schema};
grant select on ${iol_schema}.tgls_busi_hang to ${idl_schema};
grant select on ${iol_schema}.tgls_busi_hang to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_busi_hang is '交易流水挂账表';
comment on column ${iol_schema}.tgls_busi_hang.stacid is '账套';
comment on column ${iol_schema}.tgls_busi_hang.systid is '交易来源系统编号';
comment on column ${iol_schema}.tgls_busi_hang.trandt is '交易日期';
comment on column ${iol_schema}.tgls_busi_hang.transq is '交易流水';
comment on column ${iol_schema}.tgls_busi_hang.tablcd is '接口表编码';
comment on column ${iol_schema}.tgls_busi_hang.trdata is '交易流水数据json数组';
comment on column ${iol_schema}.tgls_busi_hang.status is '处理状态：0未处理1已处理';
comment on column ${iol_schema}.tgls_busi_hang.sourtp is '来源（1：手工终止2：错账冲销3:手工补录流水）';
comment on column ${iol_schema}.tgls_busi_hang.dealtp is '处理方式（1：业务系统重传2：手工修改流水3：标记为重复流水4：已修改核算规则5：已补录核算规则6：无修改重新解析）';
comment on column ${iol_schema}.tgls_busi_hang.retran is '关联流水号';
comment on column ${iol_schema}.tgls_busi_hang.soursq is '源流水号';
comment on column ${iol_schema}.tgls_busi_hang.sourdt is '源交易日期';
comment on column ${iol_schema}.tgls_busi_hang.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_busi_hang.etl_timestamp is 'ETL处理时间戳';
