/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bd_currtype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bd_currtype
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bd_currtype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_currtype(
    code varchar2(60) -- 币种编码
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,currdigit number(38,0) -- 金额小数位数
    ,currtypesign varchar2(75) -- 币种币符
    ,dataoriginflag number(38,0) -- 分布式
    ,dr number(10,0) -- 删除标志
    ,isdefault varchar2(2) -- 全局本位币
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,name varchar2(450) -- 币种名称
    ,name2 varchar2(450) -- 币种名称2
    ,name3 varchar2(450) -- 币种名称3
    ,name4 varchar2(450) -- 币种名称4
    ,name5 varchar2(450) -- 币种名称5
    ,name6 varchar2(450) -- 币种名称6
    ,pk_currtype varchar2(30) -- 币种主键
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,roundtype number(38,0) -- 金额进舍规则
    ,ts varchar2(29) -- 时间戳
    ,unitcurrdigit number(38,0) -- 单价小数位数
    ,unitroundtype number(38,0) -- 单价进舍规则
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
grant select on ${iol_schema}.iers_bd_currtype to ${iml_schema};
grant select on ${iol_schema}.iers_bd_currtype to ${icl_schema};
grant select on ${iol_schema}.iers_bd_currtype to ${idl_schema};
grant select on ${iol_schema}.iers_bd_currtype to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bd_currtype is '新费用币种';
comment on column ${iol_schema}.iers_bd_currtype.code is '币种编码';
comment on column ${iol_schema}.iers_bd_currtype.creationtime is '创建时间';
comment on column ${iol_schema}.iers_bd_currtype.creator is '创建人';
comment on column ${iol_schema}.iers_bd_currtype.currdigit is '金额小数位数';
comment on column ${iol_schema}.iers_bd_currtype.currtypesign is '币种币符';
comment on column ${iol_schema}.iers_bd_currtype.dataoriginflag is '分布式';
comment on column ${iol_schema}.iers_bd_currtype.dr is '删除标志';
comment on column ${iol_schema}.iers_bd_currtype.isdefault is '全局本位币';
comment on column ${iol_schema}.iers_bd_currtype.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_bd_currtype.modifier is '最后修改人';
comment on column ${iol_schema}.iers_bd_currtype.name is '币种名称';
comment on column ${iol_schema}.iers_bd_currtype.name2 is '币种名称2';
comment on column ${iol_schema}.iers_bd_currtype.name3 is '币种名称3';
comment on column ${iol_schema}.iers_bd_currtype.name4 is '币种名称4';
comment on column ${iol_schema}.iers_bd_currtype.name5 is '币种名称5';
comment on column ${iol_schema}.iers_bd_currtype.name6 is '币种名称6';
comment on column ${iol_schema}.iers_bd_currtype.pk_currtype is '币种主键';
comment on column ${iol_schema}.iers_bd_currtype.pk_group is '所属集团';
comment on column ${iol_schema}.iers_bd_currtype.pk_org is '所属组织';
comment on column ${iol_schema}.iers_bd_currtype.roundtype is '金额进舍规则';
comment on column ${iol_schema}.iers_bd_currtype.ts is '时间戳';
comment on column ${iol_schema}.iers_bd_currtype.unitcurrdigit is '单价小数位数';
comment on column ${iol_schema}.iers_bd_currtype.unitroundtype is '单价进舍规则';
comment on column ${iol_schema}.iers_bd_currtype.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bd_currtype.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bd_currtype.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bd_currtype.etl_timestamp is 'ETL处理时间戳';
