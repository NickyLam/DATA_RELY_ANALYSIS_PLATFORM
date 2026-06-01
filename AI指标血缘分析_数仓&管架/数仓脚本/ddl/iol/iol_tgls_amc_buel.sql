/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_buel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_buel
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_buel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_buel(
    stacid number(19) -- 账套标记
    ,elemcd varchar2(20) -- 要素编号
    ,elemna varchar2(50) -- 要素名称
    ,busitp varchar2(20) -- 业务类型
    ,elemtp varchar2(1) -- 要素类型
    ,formul varchar2(1000) -- 计算公式
    ,formna varchar2(1000) -- 计算公式名称
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
grant select on ${iol_schema}.tgls_amc_buel to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_buel to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_buel to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_buel to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_buel is '常用业务要素表';
comment on column ${iol_schema}.tgls_amc_buel.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_buel.elemcd is '要素编号';
comment on column ${iol_schema}.tgls_amc_buel.elemna is '要素名称';
comment on column ${iol_schema}.tgls_amc_buel.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_buel.elemtp is '要素类型';
comment on column ${iol_schema}.tgls_amc_buel.formul is '计算公式';
comment on column ${iol_schema}.tgls_amc_buel.formna is '计算公式名称';
comment on column ${iol_schema}.tgls_amc_buel.remark is '规则说明';
comment on column ${iol_schema}.tgls_amc_buel.vlidtg is '是否启用';
comment on column ${iol_schema}.tgls_amc_buel.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_buel.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_buel.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_buel.etl_timestamp is 'ETL处理时间戳';
