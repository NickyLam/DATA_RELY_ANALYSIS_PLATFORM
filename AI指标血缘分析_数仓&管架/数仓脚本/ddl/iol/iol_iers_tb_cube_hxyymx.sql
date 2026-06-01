/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_tb_cube_hxyymx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_tb_cube_hxyymx
whenever sqlerror continue none;
drop table ${iol_schema}.iers_tb_cube_hxyymx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_tb_cube_hxyymx(
    pk_obj varchar2(30) -- 发布对象PK
    ,uniqkey varchar2(149) -- 单元格标识
    ,pk_mvtype varchar2(30) -- 多视图类型主键
    ,code_mvtype varchar2(75) -- 多视图类型
    ,pk_version varchar2(30) -- 预算版本
    ,code_version varchar2(75) -- 预算版本编码
    ,pk_curr varchar2(30) -- 货币主键
    ,code_curr varchar2(75) -- 货币编码
    ,pk_entity varchar2(30) -- 实体主键
    ,code_entity varchar2(75) -- 实体编码
    ,pk_measure varchar2(30) -- 测量主键
    ,code_measure varchar2(75) -- 测量编码
    ,pk_year varchar2(30) -- 会计年度主键
    ,code_year varchar2(75) -- 会计年
    ,pk_quarter varchar2(30) -- 季度主键
    ,code_quarter varchar2(75) -- 季度编码
    ,pk_month varchar2(30) -- 会计月份主键
    ,code_month varchar2(75) -- 会计月份
    ,value number(38,8) -- 值
    ,txtvalue varchar2(1536) -- 发送值
    ,status2 number(38) -- 状态2
    ,status3 number(38) -- 状态3
    ,ts varchar2(29) -- 时间戳
    ,dr number(38) -- 删除标志
    ,pk_dept varchar2(30) -- 部门
    ,code_dept varchar2(75) -- 部门编码
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
grant select on ${iol_schema}.iers_tb_cube_hxyymx to ${iml_schema};
grant select on ${iol_schema}.iers_tb_cube_hxyymx to ${icl_schema};
grant select on ${iol_schema}.iers_tb_cube_hxyymx to ${idl_schema};
grant select on ${iol_schema}.iers_tb_cube_hxyymx to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_tb_cube_hxyymx is '';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_obj is '发布对象PK';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.uniqkey is '单元格标识';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_mvtype is '多视图类型主键';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_mvtype is '多视图类型';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_version is '预算版本';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_version is '预算版本编码';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_curr is '货币主键';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_curr is '货币编码';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_entity is '实体主键';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_entity is '实体编码';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_measure is '测量主键';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_measure is '测量编码';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_year is '会计年度主键';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_year is '会计年';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_quarter is '季度主键';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_quarter is '季度编码';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_month is '会计月份主键';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_month is '会计月份';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.value is '值';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.txtvalue is '发送值';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.status2 is '状态2';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.status3 is '状态3';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.ts is '时间戳';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.dr is '删除标志';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.pk_dept is '部门';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.code_dept is '部门编码';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.start_dt is '开始时间';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.end_dt is '结束时间';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.id_mark is '增删标志';
comment on column ${iol_schema}.iers_tb_cube_hxyymx.etl_timestamp is 'ETL处理时间戳';
