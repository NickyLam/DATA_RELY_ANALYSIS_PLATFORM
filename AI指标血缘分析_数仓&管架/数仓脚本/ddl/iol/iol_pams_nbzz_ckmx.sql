/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_ckmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_ckmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_ckmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_ckmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,kmh varchar2(30) -- 科目号
    ,bz varchar2(5) -- 币种
    ,fpjs varchar2(3) -- 分配角色
    ,sfhx varchar2(2) -- 是否核心
    ,sfp2p varchar2(2) -- 是否p2p
    ,dbznck varchar2(2) -- 是否单边智能存款
    ,zhye number(25,4) -- 账户余额_0A
    ,zlbl number(19,5) -- 增量比例
    ,hyye number(25,4) -- 行员余额_0A
    ,hyylj number(25,4) -- 行员月累计_0A
    ,hyjlj number(25,4) -- 行员季累计_0A
    ,hybnlj number(25,4) -- 行员半年累计_0A
    ,hynlj number(25,4) -- 行员年累计_0A
    ,hyymlj number(25,4) -- 行员月末累计_0A
    ,zlblylj number(19,5) -- 增量比例月累计
    ,zlbljlj number(19,5) -- 增量比例季累计
    ,zlblnlj number(19,5) -- 增量比例年累计
    ,zlblymlj number(19,5) -- 增量比例月末累计
    ,gxsj timestamp -- 更新时间
    ,khkhbs varchar2(3) -- 客户开户标识
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,zhjrjye number(25,4) -- 账户季日均余额
    ,zhyrjye number(25,4) -- 账户月日均余额
    ,nll number(15,7) -- 年利率
    ,kzhckbz varchar2(2) -- 跨支行存款标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_nbzz_ckmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_ckmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_ckmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_ckmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_ckmx is '内部总账_存款账户明细_YYYYMM';
comment on column ${iol_schema}.pams_nbzz_ckmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_ckmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_ckmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_ckmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_ckmx.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_ckmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_ckmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_ckmx.sfhx is '是否核心';
comment on column ${iol_schema}.pams_nbzz_ckmx.sfp2p is '是否p2p';
comment on column ${iol_schema}.pams_nbzz_ckmx.dbznck is '是否单边智能存款';
comment on column ${iol_schema}.pams_nbzz_ckmx.zhye is '账户余额_0A';
comment on column ${iol_schema}.pams_nbzz_ckmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_ckmx.hyye is '行员余额_0A';
comment on column ${iol_schema}.pams_nbzz_ckmx.hyylj is '行员月累计_0A';
comment on column ${iol_schema}.pams_nbzz_ckmx.hyjlj is '行员季累计_0A';
comment on column ${iol_schema}.pams_nbzz_ckmx.hybnlj is '行员半年累计_0A';
comment on column ${iol_schema}.pams_nbzz_ckmx.hynlj is '行员年累计_0A';
comment on column ${iol_schema}.pams_nbzz_ckmx.hyymlj is '行员月末累计_0A';
comment on column ${iol_schema}.pams_nbzz_ckmx.zlblylj is '增量比例月累计';
comment on column ${iol_schema}.pams_nbzz_ckmx.zlbljlj is '增量比例季累计';
comment on column ${iol_schema}.pams_nbzz_ckmx.zlblnlj is '增量比例年累计';
comment on column ${iol_schema}.pams_nbzz_ckmx.zlblymlj is '增量比例月末累计';
comment on column ${iol_schema}.pams_nbzz_ckmx.gxsj is '更新时间';
comment on column ${iol_schema}.pams_nbzz_ckmx.khkhbs is '客户开户标识';
comment on column ${iol_schema}.pams_nbzz_ckmx.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_nbzz_ckmx.zhjrjye is '账户季日均余额';
comment on column ${iol_schema}.pams_nbzz_ckmx.zhyrjye is '账户月日均余额';
comment on column ${iol_schema}.pams_nbzz_ckmx.nll is '年利率';
comment on column ${iol_schema}.pams_nbzz_ckmx.kzhckbz is '跨支行存款标志';
comment on column ${iol_schema}.pams_nbzz_ckmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_ckmx.etl_timestamp is 'ETL处理时间戳';
