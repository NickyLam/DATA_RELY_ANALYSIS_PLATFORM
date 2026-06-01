/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_type_defer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_type_defer
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_type_defer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_defer(
    stacid varchar2(19) -- 账套标记
    ,taxscd varchar2(2) -- 税种代码
    ,deptcd varchar2(12) -- 机构编号
    ,caclcd varchar2(30) -- 项目代码
    ,caclna varchar2(30) -- 项目说明
    ,begndt varchar2(8) -- 起始日期
    ,endddt varchar2(8) -- 终止日期
    ,smrytx varchar2(400) -- 备注
    ,aacode varchar2(30) -- 账面小于基础借方
    ,dacode varchar2(30) -- 账面大于基础借方
    ,aocode varchar2(30) -- 账面小于基础贷方
    ,docode varchar2(30) -- 账面大于基础贷方
    ,aaname varchar2(200) -- 账面小于基础借方科目名称
    ,daname varchar2(200) -- 账面大于基础借方科目名称
    ,aoname varchar2(200) -- 账面小于基础贷方科目名称
    ,doname varchar2(200) -- 账面大于基础贷方科目名称
    ,zmjzfm varchar2(4000) -- 账面价值公式
    ,jsjcfm varchar2(4000) -- 计税基础公式
    ,zjflag varchar2(1) -- 账面价值与计税基础比较（1：大于，2：小于，3大于或小于）
    ,itemtp varchar2(1) -- 项目类型（1：资产，2：负债）
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
grant select on ${iol_schema}.tgls_tax_type_defer to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_type_defer to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_type_defer to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_type_defer to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_type_defer is '递延所得税定义表';
comment on column ${iol_schema}.tgls_tax_type_defer.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_type_defer.taxscd is '税种代码';
comment on column ${iol_schema}.tgls_tax_type_defer.deptcd is '机构编号';
comment on column ${iol_schema}.tgls_tax_type_defer.caclcd is '项目代码';
comment on column ${iol_schema}.tgls_tax_type_defer.caclna is '项目说明';
comment on column ${iol_schema}.tgls_tax_type_defer.begndt is '起始日期';
comment on column ${iol_schema}.tgls_tax_type_defer.endddt is '终止日期';
comment on column ${iol_schema}.tgls_tax_type_defer.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_type_defer.aacode is '账面小于基础借方';
comment on column ${iol_schema}.tgls_tax_type_defer.dacode is '账面大于基础借方';
comment on column ${iol_schema}.tgls_tax_type_defer.aocode is '账面小于基础贷方';
comment on column ${iol_schema}.tgls_tax_type_defer.docode is '账面大于基础贷方';
comment on column ${iol_schema}.tgls_tax_type_defer.aaname is '账面小于基础借方科目名称';
comment on column ${iol_schema}.tgls_tax_type_defer.daname is '账面大于基础借方科目名称';
comment on column ${iol_schema}.tgls_tax_type_defer.aoname is '账面小于基础贷方科目名称';
comment on column ${iol_schema}.tgls_tax_type_defer.doname is '账面大于基础贷方科目名称';
comment on column ${iol_schema}.tgls_tax_type_defer.zmjzfm is '账面价值公式';
comment on column ${iol_schema}.tgls_tax_type_defer.jsjcfm is '计税基础公式';
comment on column ${iol_schema}.tgls_tax_type_defer.zjflag is '账面价值与计税基础比较（1：大于，2：小于，3大于或小于）';
comment on column ${iol_schema}.tgls_tax_type_defer.itemtp is '项目类型（1：资产，2：负债）';
comment on column ${iol_schema}.tgls_tax_type_defer.attribute1 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_defer.attribute2 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_defer.attribute3 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_defer.attribute4 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_defer.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_type_defer.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_type_defer.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_type_defer.etl_timestamp is 'ETL处理时间戳';
