/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_dkzhqmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_dkzhqmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_dkzhqmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_dkzhqmx(
    jxdxdh number(38,0) -- 绩效对象代号
    ,qsrq number(38,0) -- 起始日期
    ,jsrq number(38,0) -- 结束日期
    ,bz varchar2(9) -- 币种
    ,jgdh varchar2(30) -- 机构代号
    ,kmh varchar2(60) -- 科目号
    ,cph varchar2(60) -- 产品号
    ,ywpz varchar2(60) -- 业务品种
    ,yqkm varchar2(60) -- 逾期科目
    ,khrq number(38,0) -- 开户日期
    ,ffrq number(38,0) -- 发放日期
    ,qxrq number(38,0) -- 起息日期
    ,dqrq number(38,0) -- 到期日期
    ,xhrq number(38,0) -- 销户日期
    ,qx varchar2(15) -- 期限
    ,nll number(15,7) -- 年利率
    ,qynll number(15,7) -- 逾期年利率
    ,bjyqts number(38,0) -- 本金逾期天数
    ,lxyqts number(38,0) -- 利息逾期天数
    ,zhzt varchar2(6) -- 账户状态
    ,zhdh varchar2(120) -- 账号
    ,zzh varchar2(300) -- 子账号
    ,hxbz varchar2(3) -- 核销标志
    ,sndkbz varchar2(30) -- 涉农贷款标志
    ,lhdkbz varchar2(30) -- 绿色贷款标志
    ,wldkbz varchar2(30) -- 网络贷款标志
    ,se number(32,8) -- 税额
    ,drlxsr number(32,8) -- 当日利息收入
    ,jqrq number(38,0) -- 结清日期
    ,xwdkbs varchar2(3) -- 小微贷款标识
    ,yqxyss number(26,5) -- 预计信用损失
    ,jjzt varchar2(15) -- 借据状态
    ,gylrzcplx varchar2(30) -- 
    ,zycklx varchar2(90) -- 
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
grant select on ${iol_schema}.pams_jxdx_dkzhqmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_dkzhqmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzhqmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzhqmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_dkzhqmx is '绩效对象_贷款账户全明细';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.qsrq is '起始日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.jsrq is '结束日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.ywpz is '业务品种';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.yqkm is '逾期科目';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.ffrq is '发放日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.qx is '期限';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.nll is '年利率';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.qynll is '逾期年利率';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.bjyqts is '本金逾期天数';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.lxyqts is '利息逾期天数';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.zhzt is '账户状态';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.zhdh is '账号';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.zzh is '子账号';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.hxbz is '核销标志';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.sndkbz is '涉农贷款标志';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.lhdkbz is '绿色贷款标志';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.wldkbz is '网络贷款标志';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.se is '税额';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.drlxsr is '当日利息收入';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.jqrq is '结清日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.yqxyss is '预计信用损失';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.jjzt is '借据状态';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.gylrzcplx is '';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.zycklx is '';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_dkzhqmx.etl_timestamp is 'ETL处理时间戳';
