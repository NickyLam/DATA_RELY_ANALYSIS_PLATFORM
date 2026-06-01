/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_moru
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_moru
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_moru purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_moru(
    stacid number(19) -- 账套标记
    ,acruid number(9) -- 会计规则表主键
    ,busitp varchar2(20) -- 业务类型
    ,trancd varchar2(20) -- 子交易代码
    ,acelto varchar2(20) -- 目标要素
    ,acelna varchar2(50) -- 目标要素名称
    ,condcd varchar2(20) -- 执行条件
    ,condna varchar2(50) -- 执行条件名称
    ,formul varchar2(2000) -- 计算公式
    ,formna varchar2(4000) -- 计算公式名称
    ,remark varchar2(255) -- 规则说明
    ,vlidtg varchar2(1) -- 是否启用
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
grant select on ${iol_schema}.tgls_amc_moru to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_moru to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_moru to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_moru to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_moru is '金额信息计量加工规则';
comment on column ${iol_schema}.tgls_amc_moru.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_moru.acruid is '会计规则表主键';
comment on column ${iol_schema}.tgls_amc_moru.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_moru.trancd is '子交易代码';
comment on column ${iol_schema}.tgls_amc_moru.acelto is '目标要素';
comment on column ${iol_schema}.tgls_amc_moru.acelna is '目标要素名称';
comment on column ${iol_schema}.tgls_amc_moru.condcd is '执行条件';
comment on column ${iol_schema}.tgls_amc_moru.condna is '执行条件名称';
comment on column ${iol_schema}.tgls_amc_moru.formul is '计算公式';
comment on column ${iol_schema}.tgls_amc_moru.formna is '计算公式名称';
comment on column ${iol_schema}.tgls_amc_moru.remark is '规则说明';
comment on column ${iol_schema}.tgls_amc_moru.vlidtg is '是否启用';
comment on column ${iol_schema}.tgls_amc_moru.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_moru.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_moru.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_moru.etl_timestamp is 'ETL处理时间戳';
