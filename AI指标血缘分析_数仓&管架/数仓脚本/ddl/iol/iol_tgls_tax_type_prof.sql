/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_type_prof
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_type_prof
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_type_prof purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_prof(
    stacid varchar2(19) -- 账套标记
    ,rulecd varchar2(30) -- 规则编码
    ,deptcd varchar2(12) -- 机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,itemna varchar2(200) -- 科目名称
    ,valutp varchar2(2) -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
    ,amntcd varchar2(9) -- 借贷方向(贷方：c,借方：d)
    ,flagcd varchar2(1) -- 应税标识(是：0,否：1)
    ,fromcd varchar2(4000) -- 合成公式
    ,opercd varchar2(1) -- 运算符代码
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
grant select on ${iol_schema}.tgls_tax_type_prof to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_type_prof to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_type_prof to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_type_prof to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_type_prof is '利润总额定义表';
comment on column ${iol_schema}.tgls_tax_type_prof.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_type_prof.rulecd is '规则编码';
comment on column ${iol_schema}.tgls_tax_type_prof.deptcd is '机构编号';
comment on column ${iol_schema}.tgls_tax_type_prof.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_tax_type_prof.itemna is '科目名称';
comment on column ${iol_schema}.tgls_tax_type_prof.valutp is '取值类型(发生额:am,期初余额:bb,期末余额:eb)';
comment on column ${iol_schema}.tgls_tax_type_prof.amntcd is '借贷方向(贷方：c,借方：d)';
comment on column ${iol_schema}.tgls_tax_type_prof.flagcd is '应税标识(是：0,否：1)';
comment on column ${iol_schema}.tgls_tax_type_prof.fromcd is '合成公式';
comment on column ${iol_schema}.tgls_tax_type_prof.opercd is '运算符代码';
comment on column ${iol_schema}.tgls_tax_type_prof.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_type_prof.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_type_prof.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_type_prof.etl_timestamp is 'ETL处理时间戳';
