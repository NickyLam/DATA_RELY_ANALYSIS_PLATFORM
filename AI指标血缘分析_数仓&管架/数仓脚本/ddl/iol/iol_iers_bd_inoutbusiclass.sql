/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bd_inoutbusiclass
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bd_inoutbusiclass
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bd_inoutbusiclass purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_inoutbusiclass(
    code varchar2(60) -- 收支项目编码
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dataoriginflag number(38,0) -- 数据来源
    ,def1 varchar2(152) -- 自定义项1
    ,def2 varchar2(152) -- 自定义项2
    ,def3 varchar2(152) -- 自定义项3
    ,def4 varchar2(152) -- 自定义项4
    ,def5 varchar2(152) -- 自定义项5
    ,dr number(10,0) -- 删除标志
    ,enablestate number(38,0) -- 启用状态
    ,innercode varchar2(300) -- 内部编码
    ,memo varchar2(450) -- 备注
    ,mnecode varchar2(75) -- 助记码
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,name varchar2(450) -- 收支项目名称
    ,name2 varchar2(450) -- 收支项目名称2
    ,name3 varchar2(450) -- 收支项目名称3
    ,name4 varchar2(450) -- 收支项目名称4
    ,name5 varchar2(450) -- 收支项目名称5
    ,name6 varchar2(450) -- 收支项目名称6
    ,pk_group varchar2(30) -- 所属集团
    ,pk_inoutbusiclass varchar2(30) -- 收支项目主键
    ,pk_org varchar2(30) -- 所属组织
    ,pk_parent varchar2(30) -- 上级收支项目
    ,seq varchar2(30) -- 内部编码序号
    ,ts varchar2(29) -- 时间戳
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
grant select on ${iol_schema}.iers_bd_inoutbusiclass to ${iml_schema};
grant select on ${iol_schema}.iers_bd_inoutbusiclass to ${icl_schema};
grant select on ${iol_schema}.iers_bd_inoutbusiclass to ${idl_schema};
grant select on ${iol_schema}.iers_bd_inoutbusiclass to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bd_inoutbusiclass is '收支项目表';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.code is '收支项目编码';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.creationtime is '创建时间';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.creator is '创建人';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.dataoriginflag is '数据来源';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.def1 is '自定义项1';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.def2 is '自定义项2';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.def3 is '自定义项3';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.def4 is '自定义项4';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.def5 is '自定义项5';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.dr is '删除标志';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.enablestate is '启用状态';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.innercode is '内部编码';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.memo is '备注';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.mnecode is '助记码';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.modifier is '最后修改人';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.name is '收支项目名称';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.name2 is '收支项目名称2';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.name3 is '收支项目名称3';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.name4 is '收支项目名称4';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.name5 is '收支项目名称5';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.name6 is '收支项目名称6';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.pk_group is '所属集团';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.pk_inoutbusiclass is '收支项目主键';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.pk_org is '所属组织';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.pk_parent is '上级收支项目';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.seq is '内部编码序号';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.ts is '时间戳';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bd_inoutbusiclass.etl_timestamp is 'ETL处理时间戳';
