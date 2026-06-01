/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_type_inco
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_type_inco
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_type_inco purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_inco(
    stacid varchar2(19) -- 账套标记
    ,taxscd varchar2(2) -- 税种代码
    ,deptcd varchar2(12) -- 机构编号
    ,vatxrt number(8) -- 缴纳税费
    ,begndt varchar2(8) -- 起始日期
    ,endddt varchar2(8) -- 终止日期
    ,smrytx varchar2(400) -- 备注
    ,proffm varchar2(4000) -- 利润总额公式
    ,busifm varchar2(4000) -- 营业总额公式
    ,nstzfm varchar2(4000) -- 纳税调整公式
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
grant select on ${iol_schema}.tgls_tax_type_inco to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_type_inco to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_type_inco to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_type_inco to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_type_inco is '企业所得税定义表';
comment on column ${iol_schema}.tgls_tax_type_inco.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_type_inco.taxscd is '税种代码';
comment on column ${iol_schema}.tgls_tax_type_inco.deptcd is '机构编号';
comment on column ${iol_schema}.tgls_tax_type_inco.vatxrt is '缴纳税费';
comment on column ${iol_schema}.tgls_tax_type_inco.begndt is '起始日期';
comment on column ${iol_schema}.tgls_tax_type_inco.endddt is '终止日期';
comment on column ${iol_schema}.tgls_tax_type_inco.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_type_inco.proffm is '利润总额公式';
comment on column ${iol_schema}.tgls_tax_type_inco.busifm is '营业总额公式';
comment on column ${iol_schema}.tgls_tax_type_inco.nstzfm is '纳税调整公式';
comment on column ${iol_schema}.tgls_tax_type_inco.attribute1 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_inco.attribute2 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_inco.attribute3 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_inco.attribute4 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_inco.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_type_inco.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_type_inco.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_type_inco.etl_timestamp is 'ETL处理时间戳';
