/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_type_vatf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_type_vatf
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_type_vatf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_vatf(
    stacid varchar2(19) -- 账套标记
    ,taxscd varchar2(2) -- 税种代码
    ,deptcd varchar2(12) -- 机构编号
    ,vatxrt number(17,8) -- 税率
    ,begndt varchar2(8) -- 生效日期
    ,endddt varchar2(8) -- 失效日期
    ,smrytx varchar2(400) -- 备注
    ,attribute1 varchar2(4000) -- 弹性域列(备用)
    ,attribute2 varchar2(4000) -- 弹性域列(备用)
    ,attribute3 varchar2(4000) -- 弹性域列(备用)
    ,attribute4 varchar2(4000) -- 弹性域列(备用)
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
grant select on ${iol_schema}.tgls_tax_type_vatf to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_type_vatf to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_type_vatf to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_type_vatf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_type_vatf is '增值税附加定义表';
comment on column ${iol_schema}.tgls_tax_type_vatf.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_type_vatf.taxscd is '税种代码';
comment on column ${iol_schema}.tgls_tax_type_vatf.deptcd is '机构编号';
comment on column ${iol_schema}.tgls_tax_type_vatf.vatxrt is '税率';
comment on column ${iol_schema}.tgls_tax_type_vatf.begndt is '生效日期';
comment on column ${iol_schema}.tgls_tax_type_vatf.endddt is '失效日期';
comment on column ${iol_schema}.tgls_tax_type_vatf.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_type_vatf.attribute1 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_vatf.attribute2 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_vatf.attribute3 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_vatf.attribute4 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_vatf.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_type_vatf.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_type_vatf.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_type_vatf.etl_timestamp is 'ETL处理时间戳';
