/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondanalysiscnbd2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondanalysiscnbd2
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondanalysiscnbd2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondanalysiscnbd2(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,b_anal_matu_cnbd number(20,4) -- 待偿期(年)
    ,b_anal_dirty_cnbd number(20,4) -- 估价全价
    ,b_anal_accrint_cnbd number(20,4) -- 应计利息
    ,b_anal_net_cnbd number(20,4) -- 估价净价
    ,b_anal_yield_cnbd number(20,4) -- 估价收益率(%)
    ,b_anal_modidura_cnbd number(20,4) -- 估价修正久期
    ,b_anal_cnvxty_cnbd number(20,4) -- 估价凸性
    ,b_anal_vobp_cnbd number(20,4) -- 估价基点价值
    ,b_anal_sprdura_cnbd number(20,4) -- 估价利差久期
    ,b_anal_sprcnxt_cnbd number(20,4) -- 估价利差凸性
    ,b_anal_accrintclose_cnbd number(20,4) -- 日终应计利息
    ,b_anal_price number(20,4) -- 市场全价
    ,b_anal_netprice number(20,4) -- 市场净价
    ,b_anal_yield number(20,4) -- 市场收益率(%)
    ,b_anal_modifiedduration number(20,4) -- 市场修正久期
    ,b_anal_convexity number(20,4) -- 市场凸性
    ,b_anal_bpvalue number(20,4) -- 市场基点价值
    ,b_anal_sduration number(20,4) -- 市场利差久期
    ,b_anal_scnvxty number(20,4) -- 市场利差凸性
    ,b_anal_interestduration_cnbd number(20,4) -- 估价利率久期
    ,b_anal_interestcnvxty_cnbd number(20,4) -- 估价利率凸性
    ,b_anal_interestduration number(20,4) -- 市场利率久期
    ,b_anal_interestcnvxty number(20,4) -- 市场利率凸性
    ,b_anal_price_cnbd number(20,4) -- 日终估价全价
    ,b_anal_bpyield number(20,4) -- 点差收益率(%)
    ,b_anal_exchange varchar2(60) -- 流通场所
    ,b_anal_credibility varchar2(60) -- 可信度
    ,b_anal_residualpri number(20,4) -- 剩余本金
    ,b_anal_exercise_rate number(20,6) -- 估算的行权后票面利率
    ,b_anal_priority number(1,0) -- 优先级
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
grant select on ${iol_schema}.wind_cbondanalysiscnbd2 to ${iml_schema};
grant select on ${iol_schema}.wind_cbondanalysiscnbd2 to ${icl_schema};
grant select on ${iol_schema}.wind_cbondanalysiscnbd2 to ${idl_schema};
grant select on ${iol_schema}.wind_cbondanalysiscnbd2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondanalysiscnbd2 is '中债登估值(中票短融)';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_matu_cnbd is '待偿期(年)';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_dirty_cnbd is '估价全价';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_accrint_cnbd is '应计利息';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_net_cnbd is '估价净价';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_yield_cnbd is '估价收益率(%)';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_modidura_cnbd is '估价修正久期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_cnvxty_cnbd is '估价凸性';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_vobp_cnbd is '估价基点价值';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_sprdura_cnbd is '估价利差久期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_sprcnxt_cnbd is '估价利差凸性';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_accrintclose_cnbd is '日终应计利息';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_price is '市场全价';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_netprice is '市场净价';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_yield is '市场收益率(%)';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_modifiedduration is '市场修正久期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_convexity is '市场凸性';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_bpvalue is '市场基点价值';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_sduration is '市场利差久期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_scnvxty is '市场利差凸性';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_interestduration_cnbd is '估价利率久期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_interestcnvxty_cnbd is '估价利率凸性';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_interestduration is '市场利率久期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_interestcnvxty is '市场利率凸性';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_price_cnbd is '日终估价全价';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_bpyield is '点差收益率(%)';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_exchange is '流通场所';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_credibility is '可信度';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_residualpri is '剩余本金';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_exercise_rate is '估算的行权后票面利率';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.b_anal_priority is '优先级';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondanalysiscnbd2.etl_timestamp is 'ETL处理时间戳';
