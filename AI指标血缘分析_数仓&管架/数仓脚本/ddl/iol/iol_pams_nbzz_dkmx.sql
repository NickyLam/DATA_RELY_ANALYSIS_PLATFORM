/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_dkmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_dkmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_dkmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_dkmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,kmh varchar2(30) -- 科目号
    ,cph varchar2(30) -- 产品号
    ,ywpz varchar2(30) -- 业务品种
    ,fpjs varchar2(3) -- 分配角色
    ,bz varchar2(5) -- 币种
    ,zhye number(25,4) -- 账户余额_0A
    ,zlbl number(19,5) -- 增量比例
    ,hyye number(25,4) -- 行员余额_0A
    ,hyylj number(25,4) -- 行员月累计_0A
    ,hyjlj number(25,4) -- 行员季累计_0A
    ,hybnlj number(25,4) -- 行员半年累计_0A
    ,hynlj number(25,4) -- 行员年累计_0A
    ,hyymlj number(25,4) -- 行员月末累计_0A
    ,hydkje number(25,4) -- 行员贷款金额_0A
    ,zhzlbl number(19,5) -- 折后增量比例
    ,zlblylj number(19,5) -- 增量比例月累计
    ,zlbljlj number(19,5) -- 增量比例季累计
    ,zlblnlj number(19,5) -- 增量比例年累计
    ,zlblymlj number(19,5) -- 增量比例月末累计
    ,khdkje number(25,4) -- 客户贷款金额
    ,khdkye number(25,4) -- 客户贷款余额
    ,khkhbs varchar2(3) -- 客户开户标识
    ,nll number(15,7) -- 年利率
    ,gxsj timestamp -- 更新时间
    ,hxbz varchar2(2) -- hxbz
    ,lsdkbs varchar2(3) -- lsdkbs
    ,xwdkbs varchar2(2) -- 
    ,sfzydk varchar2(2) -- 
    ,fdbptdk varchar2(2) -- 
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
grant select on ${iol_schema}.pams_nbzz_dkmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_dkmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_dkmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_dkmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_dkmx is '内部总账_贷款账户明细_YYYYMM';
comment on column ${iol_schema}.pams_nbzz_dkmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_dkmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_dkmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dkmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dkmx.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_dkmx.cph is '产品号';
comment on column ${iol_schema}.pams_nbzz_dkmx.ywpz is '业务品种';
comment on column ${iol_schema}.pams_nbzz_dkmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_dkmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_dkmx.zhye is '账户余额_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_dkmx.hyye is '行员余额_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.hyylj is '行员月累计_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.hyjlj is '行员季累计_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.hybnlj is '行员半年累计_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.hynlj is '行员年累计_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.hyymlj is '行员月末累计_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.hydkje is '行员贷款金额_0A';
comment on column ${iol_schema}.pams_nbzz_dkmx.zhzlbl is '折后增量比例';
comment on column ${iol_schema}.pams_nbzz_dkmx.zlblylj is '增量比例月累计';
comment on column ${iol_schema}.pams_nbzz_dkmx.zlbljlj is '增量比例季累计';
comment on column ${iol_schema}.pams_nbzz_dkmx.zlblnlj is '增量比例年累计';
comment on column ${iol_schema}.pams_nbzz_dkmx.zlblymlj is '增量比例月末累计';
comment on column ${iol_schema}.pams_nbzz_dkmx.khdkje is '客户贷款金额';
comment on column ${iol_schema}.pams_nbzz_dkmx.khdkye is '客户贷款余额';
comment on column ${iol_schema}.pams_nbzz_dkmx.khkhbs is '客户开户标识';
comment on column ${iol_schema}.pams_nbzz_dkmx.nll is '年利率';
comment on column ${iol_schema}.pams_nbzz_dkmx.gxsj is '更新时间';
comment on column ${iol_schema}.pams_nbzz_dkmx.hxbz is 'hxbz';
comment on column ${iol_schema}.pams_nbzz_dkmx.lsdkbs is 'lsdkbs';
comment on column ${iol_schema}.pams_nbzz_dkmx.xwdkbs is '';
comment on column ${iol_schema}.pams_nbzz_dkmx.sfzydk is '';
comment on column ${iol_schema}.pams_nbzz_dkmx.fdbptdk is '';
comment on column ${iol_schema}.pams_nbzz_dkmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_dkmx.etl_timestamp is 'ETL处理时间戳';
