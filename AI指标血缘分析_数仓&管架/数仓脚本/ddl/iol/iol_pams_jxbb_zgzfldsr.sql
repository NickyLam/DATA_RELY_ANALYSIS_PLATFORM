/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zgzfldsr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zgzfldsr
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zgzfldsr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zgzfldsr(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,sjrq number(22) -- 数据日期
    ,zcbm varchar2(300) -- 资产编码
    ,zcmc varchar2(1500) -- 资产名称
    ,zcqxr number(22) -- 资产起息日
    ,zcdqr number(22) -- 资产到期日
    ,fzdqr number(22) -- 负债到期日
    ,jxjc varchar2(1500) -- 计息基础
    ,csfxje number(25,4) -- 初始发行金额
    ,cxje number(25,4) -- 存续金额
    ,zcsyl number(25,4) -- 资产收益率%
    ,fhfcbl number(25,4) -- 分行分成比例%
    ,zjcb number(25,4) -- 资金成本
    ,fzcb varchar2(1500) -- 负债成本
    ,fhfcje number(25,4) -- 分行分成金额
    ,shfhfcje number(25,4) -- 分行分成金额-税后
    ,tzfcje number(25,4) -- 调整分成金额
    ,shtzfcje number(25,4) -- 调整分成金额-税后
    ,fhfchj number(25,4) -- 分行分成合计
    ,shfhfchj number(25,4) -- 分行分成合计-税后
    ,ssfh varchar2(300) -- 所属分行
    ,sskhjlgh varchar2(90) -- 所属客户经理工号
    ,hyfcbl number(25,4) -- 行员分成比例
    ,shkhjlfchj number(25,4) -- 客户经理分成合计-税后
    ,sszhjgdh varchar2(90) -- 所属支行机构代号
    ,sszhjgmc varchar2(300) -- 所属支行机构名称
    ,beiz varchar2(3000) -- 备注
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
grant select on ${iol_schema}.pams_jxbb_zgzfldsr to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zgzfldsr to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zgzfldsr to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zgzfldsr to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zgzfldsr is '内部总账_资管总分联动收入';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.sjrq is '数据日期';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.zcbm is '资产编码';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.zcmc is '资产名称';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.zcqxr is '资产起息日';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.zcdqr is '资产到期日';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.fzdqr is '负债到期日';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.jxjc is '计息基础';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.csfxje is '初始发行金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.cxje is '存续金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.zcsyl is '资产收益率%';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.fhfcbl is '分行分成比例%';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.zjcb is '资金成本';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.fzcb is '负债成本';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.fhfcje is '分行分成金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.shfhfcje is '分行分成金额-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.tzfcje is '调整分成金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.shtzfcje is '调整分成金额-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.fhfchj is '分行分成合计';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.shfhfchj is '分行分成合计-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.ssfh is '所属分行';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.sskhjlgh is '所属客户经理工号';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.hyfcbl is '行员分成比例';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.shkhjlfchj is '客户经理分成合计-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.sszhjgdh is '所属支行机构代号';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.sszhjgmc is '所属支行机构名称';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.beiz is '备注';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr.etl_timestamp is 'ETL处理时间戳';
