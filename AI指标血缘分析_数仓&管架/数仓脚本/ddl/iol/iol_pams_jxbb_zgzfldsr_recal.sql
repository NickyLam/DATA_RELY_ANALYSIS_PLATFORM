/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zgzfldsr_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zgzfldsr_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zgzfldsr_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zgzfldsr_recal(
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
    ,recal_dt number(22) -- 重算窗口日期
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
grant select on ${iol_schema}.pams_jxbb_zgzfldsr_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zgzfldsr_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zgzfldsr_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zgzfldsr_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zgzfldsr_recal is '绩效对象-票据贴现收益_重算';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.sjrq is '数据日期';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.zcbm is '资产编码';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.zcmc is '资产名称';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.zcqxr is '资产起息日';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.zcdqr is '资产到期日';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.fzdqr is '负债到期日';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.jxjc is '计息基础';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.csfxje is '初始发行金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.cxje is '存续金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.zcsyl is '资产收益率%';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.fhfcbl is '分行分成比例%';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.zjcb is '资金成本';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.fzcb is '负债成本';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.fhfcje is '分行分成金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.shfhfcje is '分行分成金额-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.tzfcje is '调整分成金额';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.shtzfcje is '调整分成金额-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.fhfchj is '分行分成合计';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.shfhfchj is '分行分成合计-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.ssfh is '所属分行';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.sskhjlgh is '所属客户经理工号';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.hyfcbl is '行员分成比例';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.shkhjlfchj is '客户经理分成合计-税后';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.sszhjgdh is '所属支行机构代号';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.sszhjgmc is '所属支行机构名称';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.beiz is '备注';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.recal_dt is '重算窗口日期';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zgzfldsr_recal.etl_timestamp is 'ETL处理时间戳';
