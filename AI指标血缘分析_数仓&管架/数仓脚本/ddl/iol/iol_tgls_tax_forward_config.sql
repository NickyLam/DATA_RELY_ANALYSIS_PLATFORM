/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_forward_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_forward_config
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_forward_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_forward_config(
    stacid number(19) -- 账套标记
    ,itemcd varchar2(30) -- 结转自科目编号
    ,valuetp varchar2(1) -- 结转取值类型
    ,lenddt varchar2(1) -- 结转记账方向
    ,pnjudge varchar2(1) -- 正负判断
    ,forwdt varchar2(1) -- 结转时点
    ,extend1 varchar2(20) -- 扩展字段1
    ,extend2 varchar2(32) -- 扩展字段2
    ,extend3 varchar2(64) -- 扩展字段3
    ,taxfwsq varchar2(30) -- 流水号
    ,itemcdto varchar2(30) -- 结转至科目编号
    ,orderi number -- 顺序
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
grant select on ${iol_schema}.tgls_tax_forward_config to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_forward_config to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_forward_config to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_forward_config to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_forward_config is '季末增值税结转配置表';
comment on column ${iol_schema}.tgls_tax_forward_config.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_forward_config.itemcd is '结转自科目编号';
comment on column ${iol_schema}.tgls_tax_forward_config.valuetp is '结转取值类型';
comment on column ${iol_schema}.tgls_tax_forward_config.lenddt is '结转记账方向';
comment on column ${iol_schema}.tgls_tax_forward_config.pnjudge is '正负判断';
comment on column ${iol_schema}.tgls_tax_forward_config.forwdt is '结转时点';
comment on column ${iol_schema}.tgls_tax_forward_config.extend1 is '扩展字段1';
comment on column ${iol_schema}.tgls_tax_forward_config.extend2 is '扩展字段2';
comment on column ${iol_schema}.tgls_tax_forward_config.extend3 is '扩展字段3';
comment on column ${iol_schema}.tgls_tax_forward_config.taxfwsq is '流水号';
comment on column ${iol_schema}.tgls_tax_forward_config.itemcdto is '结转至科目编号';
comment on column ${iol_schema}.tgls_tax_forward_config.orderi is '顺序';
comment on column ${iol_schema}.tgls_tax_forward_config.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_forward_config.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_forward_config.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_forward_config.etl_timestamp is 'ETL处理时间戳';
