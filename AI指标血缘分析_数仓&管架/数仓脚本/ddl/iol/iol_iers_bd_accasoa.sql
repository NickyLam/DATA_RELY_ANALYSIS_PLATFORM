/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bd_accasoa
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bd_accasoa
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bd_accasoa purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_accasoa(
    allowclose varchar2(2) -- 提前关账
    ,balancetype varchar2(2) -- 结算方式
    ,balanflag varchar2(2) -- 余额方向控制
    ,bankacc varchar2(2) -- 银行账号
    ,billdate varchar2(2) -- 票据日期
    ,billnumber varchar2(2) -- 票据号
    ,billtype varchar2(2) -- 票据类型
    ,bothorient varchar2(2) -- 账簿余额双向显示
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,ctrlmodules varchar2(750) -- 受控模块
    ,currency varchar2(30) -- 默认币种
    ,dataoriginflag number(38,0) -- 数据来源
    ,def1 varchar2(152) -- 自定义项1
    ,def2 varchar2(152) -- 自定义项2
    ,def3 varchar2(152) -- 自定义项3
    ,def4 varchar2(152) -- 自定义项4
    ,def5 varchar2(152) -- 自定义项5
    ,dispname varchar2(2250) -- 科目显示名称
    ,dispname2 varchar2(2250) -- 科目显示名称2
    ,dispname3 varchar2(2250) -- 科目显示名称3
    ,dispname4 varchar2(2250) -- 科目显示名称4
    ,dispname5 varchar2(2250) -- 科目显示名称5
    ,dispname6 varchar2(2250) -- 科目显示名称6
    ,dr number(10,0) -- 删除标志
    ,enablestate number(38,0) -- 启用状态
    ,endflag varchar2(2) -- 末级标志
    ,incurflag varchar2(2) -- 发生额方向控制
    ,innerinfo varchar2(2) -- 内部交易信息
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,name varchar2(450) -- 科目名称
    ,name2 varchar2(450) -- 科目名称2
    ,name3 varchar2(450) -- 科目名称3
    ,name4 varchar2(450) -- 科目名称4
    ,name5 varchar2(450) -- 科目名称5
    ,name6 varchar2(450) -- 科目名称6
    ,pk_accasoa varchar2(30) -- 主键
    ,pk_accchart varchar2(30) -- 所属科目表
    ,pk_account varchar2(30) -- 科目主键
    ,price varchar2(2) -- 单价
    ,quantity varchar2(2) -- 数量
    ,remcode varchar2(75) -- 助记码
    ,sumprint_level number(38,0) -- 汇总打印级次
    ,ts varchar2(29) -- 时间戳
    ,unit varchar2(30) -- 默认计量单位
    ,usedesc varchar2(900) -- 使用说明
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
grant select on ${iol_schema}.iers_bd_accasoa to ${iml_schema};
grant select on ${iol_schema}.iers_bd_accasoa to ${icl_schema};
grant select on ${iol_schema}.iers_bd_accasoa to ${idl_schema};
grant select on ${iol_schema}.iers_bd_accasoa to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bd_accasoa is '会计科目表';
comment on column ${iol_schema}.iers_bd_accasoa.allowclose is '提前关账';
comment on column ${iol_schema}.iers_bd_accasoa.balancetype is '结算方式';
comment on column ${iol_schema}.iers_bd_accasoa.balanflag is '余额方向控制';
comment on column ${iol_schema}.iers_bd_accasoa.bankacc is '银行账号';
comment on column ${iol_schema}.iers_bd_accasoa.billdate is '票据日期';
comment on column ${iol_schema}.iers_bd_accasoa.billnumber is '票据号';
comment on column ${iol_schema}.iers_bd_accasoa.billtype is '票据类型';
comment on column ${iol_schema}.iers_bd_accasoa.bothorient is '账簿余额双向显示';
comment on column ${iol_schema}.iers_bd_accasoa.creationtime is '创建时间';
comment on column ${iol_schema}.iers_bd_accasoa.creator is '创建人';
comment on column ${iol_schema}.iers_bd_accasoa.ctrlmodules is '受控模块';
comment on column ${iol_schema}.iers_bd_accasoa.currency is '默认币种';
comment on column ${iol_schema}.iers_bd_accasoa.dataoriginflag is '数据来源';
comment on column ${iol_schema}.iers_bd_accasoa.def1 is '自定义项1';
comment on column ${iol_schema}.iers_bd_accasoa.def2 is '自定义项2';
comment on column ${iol_schema}.iers_bd_accasoa.def3 is '自定义项3';
comment on column ${iol_schema}.iers_bd_accasoa.def4 is '自定义项4';
comment on column ${iol_schema}.iers_bd_accasoa.def5 is '自定义项5';
comment on column ${iol_schema}.iers_bd_accasoa.dispname is '科目显示名称';
comment on column ${iol_schema}.iers_bd_accasoa.dispname2 is '科目显示名称2';
comment on column ${iol_schema}.iers_bd_accasoa.dispname3 is '科目显示名称3';
comment on column ${iol_schema}.iers_bd_accasoa.dispname4 is '科目显示名称4';
comment on column ${iol_schema}.iers_bd_accasoa.dispname5 is '科目显示名称5';
comment on column ${iol_schema}.iers_bd_accasoa.dispname6 is '科目显示名称6';
comment on column ${iol_schema}.iers_bd_accasoa.dr is '删除标志';
comment on column ${iol_schema}.iers_bd_accasoa.enablestate is '启用状态';
comment on column ${iol_schema}.iers_bd_accasoa.endflag is '末级标志';
comment on column ${iol_schema}.iers_bd_accasoa.incurflag is '发生额方向控制';
comment on column ${iol_schema}.iers_bd_accasoa.innerinfo is '内部交易信息';
comment on column ${iol_schema}.iers_bd_accasoa.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_bd_accasoa.modifier is '最后修改人';
comment on column ${iol_schema}.iers_bd_accasoa.name is '科目名称';
comment on column ${iol_schema}.iers_bd_accasoa.name2 is '科目名称2';
comment on column ${iol_schema}.iers_bd_accasoa.name3 is '科目名称3';
comment on column ${iol_schema}.iers_bd_accasoa.name4 is '科目名称4';
comment on column ${iol_schema}.iers_bd_accasoa.name5 is '科目名称5';
comment on column ${iol_schema}.iers_bd_accasoa.name6 is '科目名称6';
comment on column ${iol_schema}.iers_bd_accasoa.pk_accasoa is '主键';
comment on column ${iol_schema}.iers_bd_accasoa.pk_accchart is '所属科目表';
comment on column ${iol_schema}.iers_bd_accasoa.pk_account is '科目主键';
comment on column ${iol_schema}.iers_bd_accasoa.price is '单价';
comment on column ${iol_schema}.iers_bd_accasoa.quantity is '数量';
comment on column ${iol_schema}.iers_bd_accasoa.remcode is '助记码';
comment on column ${iol_schema}.iers_bd_accasoa.sumprint_level is '汇总打印级次';
comment on column ${iol_schema}.iers_bd_accasoa.ts is '时间戳';
comment on column ${iol_schema}.iers_bd_accasoa.unit is '默认计量单位';
comment on column ${iol_schema}.iers_bd_accasoa.usedesc is '使用说明';
comment on column ${iol_schema}.iers_bd_accasoa.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bd_accasoa.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bd_accasoa.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bd_accasoa.etl_timestamp is 'ETL处理时间戳';
