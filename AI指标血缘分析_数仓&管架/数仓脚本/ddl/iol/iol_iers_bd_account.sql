/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bd_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bd_account
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bd_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_account(
    acclev number(38,0) -- 科目级次
    ,accproperty number(38,0) -- 科目属性
    ,balancetype varchar2(2) -- 
    ,balanflag varchar2(2) -- 
    ,balanorient number(38,0) -- 科目方向
    ,bankacc varchar2(2) -- 
    ,billdate varchar2(2) -- 单据日期
    ,billnumber varchar2(2) -- 
    ,billtype varchar2(2) -- 单据类型
    ,bothorient varchar2(2) -- 
    ,cashtype number(38,0) -- 现金分类
    ,code varchar2(60) -- 科目编码
    ,combineform varchar2(2) -- 合并报表科目
    ,currency varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 数据来源
    ,dr number(10,0) -- 删除标志
    ,enablestate number(38,0) -- 使用状态
    ,incurflag varchar2(2) -- 
    ,inneracc varchar2(2) -- 
    ,innercode varchar2(300) -- 内部码
    ,innerinfo varchar2(2) -- 
    ,name varchar2(450) -- 名称
    ,name2 varchar2(450) -- 名称2
    ,name3 varchar2(450) -- 名称3
    ,name4 varchar2(450) -- 名称4
    ,name5 varchar2(450) -- 名称5
    ,name6 varchar2(450) -- 名称6
    ,nparallelaccounts varchar2(2) -- 平行记账例外科目
    ,outflag varchar2(2) -- 表外科目
    ,parallelaccounts varchar2(2) -- 平行记账标志
    ,pid varchar2(30) -- 上级科目
    ,pk_accchart varchar2(30) -- 创建科目表
    ,pk_account varchar2(30) -- 主键
    ,pk_acctype varchar2(30) -- 科目类型
    ,pk_originalaccount varchar2(30) -- 原始科目主键
    ,price varchar2(2) -- 单价
    ,quantity varchar2(2) -- 
    ,remcode varchar2(75) -- 助记码
    ,sumprint_level number(38,0) -- 
    ,ts varchar2(29) -- 时间戳
    ,unit varchar2(30) -- 
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
grant select on ${iol_schema}.iers_bd_account to ${iml_schema};
grant select on ${iol_schema}.iers_bd_account to ${icl_schema};
grant select on ${iol_schema}.iers_bd_account to ${idl_schema};
grant select on ${iol_schema}.iers_bd_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bd_account is '会计科目基本信息表';
comment on column ${iol_schema}.iers_bd_account.acclev is '科目级次';
comment on column ${iol_schema}.iers_bd_account.accproperty is '科目属性';
comment on column ${iol_schema}.iers_bd_account.balancetype is '';
comment on column ${iol_schema}.iers_bd_account.balanflag is '';
comment on column ${iol_schema}.iers_bd_account.balanorient is '科目方向';
comment on column ${iol_schema}.iers_bd_account.bankacc is '';
comment on column ${iol_schema}.iers_bd_account.billdate is '单据日期';
comment on column ${iol_schema}.iers_bd_account.billnumber is '';
comment on column ${iol_schema}.iers_bd_account.billtype is '单据类型';
comment on column ${iol_schema}.iers_bd_account.bothorient is '';
comment on column ${iol_schema}.iers_bd_account.cashtype is '现金分类';
comment on column ${iol_schema}.iers_bd_account.code is '科目编码';
comment on column ${iol_schema}.iers_bd_account.combineform is '合并报表科目';
comment on column ${iol_schema}.iers_bd_account.currency is '';
comment on column ${iol_schema}.iers_bd_account.dataoriginflag is '数据来源';
comment on column ${iol_schema}.iers_bd_account.dr is '删除标志';
comment on column ${iol_schema}.iers_bd_account.enablestate is '使用状态';
comment on column ${iol_schema}.iers_bd_account.incurflag is '';
comment on column ${iol_schema}.iers_bd_account.inneracc is '';
comment on column ${iol_schema}.iers_bd_account.innercode is '内部码';
comment on column ${iol_schema}.iers_bd_account.innerinfo is '';
comment on column ${iol_schema}.iers_bd_account.name is '名称';
comment on column ${iol_schema}.iers_bd_account.name2 is '名称2';
comment on column ${iol_schema}.iers_bd_account.name3 is '名称3';
comment on column ${iol_schema}.iers_bd_account.name4 is '名称4';
comment on column ${iol_schema}.iers_bd_account.name5 is '名称5';
comment on column ${iol_schema}.iers_bd_account.name6 is '名称6';
comment on column ${iol_schema}.iers_bd_account.nparallelaccounts is '平行记账例外科目';
comment on column ${iol_schema}.iers_bd_account.outflag is '表外科目';
comment on column ${iol_schema}.iers_bd_account.parallelaccounts is '平行记账标志';
comment on column ${iol_schema}.iers_bd_account.pid is '上级科目';
comment on column ${iol_schema}.iers_bd_account.pk_accchart is '创建科目表';
comment on column ${iol_schema}.iers_bd_account.pk_account is '主键';
comment on column ${iol_schema}.iers_bd_account.pk_acctype is '科目类型';
comment on column ${iol_schema}.iers_bd_account.pk_originalaccount is '原始科目主键';
comment on column ${iol_schema}.iers_bd_account.price is '单价';
comment on column ${iol_schema}.iers_bd_account.quantity is '';
comment on column ${iol_schema}.iers_bd_account.remcode is '助记码';
comment on column ${iol_schema}.iers_bd_account.sumprint_level is '';
comment on column ${iol_schema}.iers_bd_account.ts is '时间戳';
comment on column ${iol_schema}.iers_bd_account.unit is '';
comment on column ${iol_schema}.iers_bd_account.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bd_account.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bd_account.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bd_account.etl_timestamp is 'ETL处理时间戳';
