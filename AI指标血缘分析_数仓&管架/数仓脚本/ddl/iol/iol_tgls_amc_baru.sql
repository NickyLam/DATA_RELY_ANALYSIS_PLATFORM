/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_baru
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_baru
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_baru purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_baru(
    stacid number(19) -- 账套标记
    ,acruid number(9) -- 会计规则表主键
    ,busitp varchar2(20) -- 业务类型
    ,acelto varchar2(20) -- 目标要素
    ,acelna varchar2(100) -- 目标要素名称
    ,condcd varchar2(20) -- 执行条件
    ,scelfm varchar2(20) -- 来源要素
    ,scelna varchar2(50) -- 来源要素名称
    ,defval varchar2(20) -- 赋常数值
    ,vlidtg varchar2(1) -- 是否启用
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
grant select on ${iol_schema}.tgls_amc_baru to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_baru to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_baru to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_baru to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_baru is '基础信息计量加工规则';
comment on column ${iol_schema}.tgls_amc_baru.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_baru.acruid is '会计规则表主键';
comment on column ${iol_schema}.tgls_amc_baru.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_baru.acelto is '目标要素';
comment on column ${iol_schema}.tgls_amc_baru.acelna is '目标要素名称';
comment on column ${iol_schema}.tgls_amc_baru.condcd is '执行条件';
comment on column ${iol_schema}.tgls_amc_baru.scelfm is '来源要素';
comment on column ${iol_schema}.tgls_amc_baru.scelna is '来源要素名称';
comment on column ${iol_schema}.tgls_amc_baru.defval is '赋常数值';
comment on column ${iol_schema}.tgls_amc_baru.vlidtg is '是否启用';
comment on column ${iol_schema}.tgls_amc_baru.sortno is '排序';
comment on column ${iol_schema}.tgls_amc_baru.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_baru.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_baru.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_baru.etl_timestamp is 'ETL处理时间戳';
