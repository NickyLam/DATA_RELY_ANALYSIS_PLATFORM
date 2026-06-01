/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_type
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type(
    stacid varchar2(19) -- 账套标记
    ,taxscd varchar2(2) -- 税种代码
    ,smrytx varchar2(400) -- 备注
    ,cfitem varchar2(30) -- 结转至科目编号
    ,dfitem varchar2(30) -- 借方科目编号
    ,cfname varchar2(200) -- 贷方科目名称
    ,dfname varchar2(200) -- 借方科目名称
    ,wlitem varchar2(30) -- 往来科目编号
    ,wlname varchar2(200) -- 往来科目名称
    ,begndt varchar2(8) -- 起始日期
    ,endddt varchar2(8) -- 终止日期
    ,booktp varchar2(1) -- 税费户类型（1：国税，2：地税）
    ,attribute1 varchar2(4000) -- 弹性域列(备用)
    ,attribute2 varchar2(4000) -- 弹性域列(备用)
    ,attribute3 varchar2(4000) -- 弹性域列(备用)
    ,attribute4 varchar2(4000) -- 弹性域列(备用)
    ,shitem varchar2(30) -- 上划科目编号
    ,shname varchar2(200) -- 上划科目名称
    ,fcwmod varchar2(2) -- 外币计提方式
    ,convrt varchar2(2) -- 折算汇率
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
grant select on ${iol_schema}.tgls_tax_type to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_type to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_type to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_type is '税种定义表';
comment on column ${iol_schema}.tgls_tax_type.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_type.taxscd is '税种代码';
comment on column ${iol_schema}.tgls_tax_type.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_type.cfitem is '结转至科目编号';
comment on column ${iol_schema}.tgls_tax_type.dfitem is '借方科目编号';
comment on column ${iol_schema}.tgls_tax_type.cfname is '贷方科目名称';
comment on column ${iol_schema}.tgls_tax_type.dfname is '借方科目名称';
comment on column ${iol_schema}.tgls_tax_type.wlitem is '往来科目编号';
comment on column ${iol_schema}.tgls_tax_type.wlname is '往来科目名称';
comment on column ${iol_schema}.tgls_tax_type.begndt is '起始日期';
comment on column ${iol_schema}.tgls_tax_type.endddt is '终止日期';
comment on column ${iol_schema}.tgls_tax_type.booktp is '税费户类型（1：国税，2：地税）';
comment on column ${iol_schema}.tgls_tax_type.attribute1 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type.attribute2 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type.attribute3 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type.attribute4 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type.shitem is '上划科目编号';
comment on column ${iol_schema}.tgls_tax_type.shname is '上划科目名称';
comment on column ${iol_schema}.tgls_tax_type.fcwmod is '外币计提方式';
comment on column ${iol_schema}.tgls_tax_type.convrt is '折算汇率';
comment on column ${iol_schema}.tgls_tax_type.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_type.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_type.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_type.etl_timestamp is 'ETL处理时间戳';
