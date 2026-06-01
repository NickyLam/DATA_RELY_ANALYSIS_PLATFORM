/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_dkmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_dkmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_dkmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_dkmx_recal(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,kmh varchar2(60) -- 科目号
    ,cph varchar2(60) -- 产品号
    ,ywpz varchar2(60) -- 业务品种
    ,fpjs varchar2(6) -- 分配角色
    ,bz varchar2(9) -- 币种
    ,zhye number(25,4) -- 账户余额
    ,zlbl number(19,5) -- 认领比例
    ,hyye number(25,4) -- 行员余额
    ,hyylj number(25,4) -- 行员月累计
    ,hyjlj number(25,4) -- 行员季累计
    ,hybnlj number(25,4) -- 行员半年累计
    ,hynlj number(25,4) -- 行员年累计
    ,hyymlj number(25,4) -- 行员月末累计
    ,hydkje number(25,4) -- 行员贷款金额
    ,zhzlbl number(19,5) -- 折后增量比例
    ,zlblylj number(19,5) -- 增量比例月累计
    ,zlbljlj number(19,5) -- 增量比例季累计
    ,zlblnlj number(19,5) -- 增量比例年累计
    ,zlblymlj number(19,5) -- 增量比例月末累计
    ,khdkje number(25,4) -- 客户贷款金额
    ,khdkye number(25,4) -- 客户贷款余额
    ,khkhbs varchar2(6) -- 客户开户标识
    ,nll number(15,7) -- 年利率
    ,gxsj timestamp -- 更新时间
    ,hxbz varchar2(3) -- 核销标志
    ,lsdkbs varchar2(6) -- 绿色贷款标识
    ,xwdkbs varchar2(3) -- 小微贷款标识
    ,sfzydk varchar2(3) -- 是否质押贷款
    ,fdbptdk varchar2(3) -- 非打包平台贷款
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_nbzz_dkmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_dkmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_dkmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_dkmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_dkmx_recal is '内部总账_贷款账户明细_重算';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.cph is '产品号';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.ywpz is '业务品种';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hybnlj is '行员半年累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hyymlj is '行员月末累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hydkje is '行员贷款金额';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.zhzlbl is '折后增量比例';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.zlblylj is '增量比例月累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.zlbljlj is '增量比例季累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.zlblnlj is '增量比例年累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.zlblymlj is '增量比例月末累计';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.khdkje is '客户贷款金额';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.khdkye is '客户贷款余额';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.khkhbs is '客户开户标识';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.nll is '年利率';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.gxsj is '更新时间';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.hxbz is '核销标志';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.lsdkbs is '绿色贷款标识';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.sfzydk is '是否质押贷款';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.fdbptdk is '非打包平台贷款';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_dkmx_recal.etl_timestamp is 'ETL处理时间戳';
