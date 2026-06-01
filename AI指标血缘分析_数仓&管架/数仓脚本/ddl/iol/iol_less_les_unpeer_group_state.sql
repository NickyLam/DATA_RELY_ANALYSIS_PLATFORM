/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol less_les_unpeer_group_state
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.less_les_unpeer_group_state
whenever sqlerror continue none;
drop table ${iol_schema}.less_les_unpeer_group_state purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.less_les_unpeer_group_state(
    datadate varchar2(8) -- 数据日期
    ,seqitem number(22) -- 序号
    ,customertype varchar2(100) -- 客户类型
    ,customername varchar2(200) -- 客户名称
    ,customercode varchar2(60) -- 客户代码
    ,sumexpse number(38,6) -- 风险暴露总和-合计
    ,unexemptriskexpse number(38,6) -- 风险暴露总和-其中：不可豁免风险暴露
    ,firstcapnarat number(38,6) -- 占一级资本净额比例-合计
    ,unexemptriskexpseprop number(38,6) -- 占一级资本净额比例-其中：不可豁免风险暴露
    ,afcomnriskexpse number(38,6) -- 一般风险暴露-合计
    ,anyloan number(38,6) -- 一般风险暴露-其中：各项贷款
    ,sumprod number(38,6) -- 一般风险暴露-其中：债券投资
    ,secuinvest number(38,6) -- 特定风险暴露-合计
    ,zgprod number(38,6) -- 特定风险暴露-资产管理产品
    ,trustprod number(38,6) -- 资产管理产品-其中：信托产品
    ,nbrk_evnchrem number(38,6) -- 资产管理产品-其中：非保本理财
    ,secuastmgmtprod number(38,6) -- 资产管理产品-其中：证券业资管产品
    ,zqprod number(38,6) -- 特定风险暴露-资产证券化产品
    ,aftradeacctriskexpse number(38,6) -- 交易账簿风险暴露
    ,aftradecpcrdtriskexpse number(38,6) -- 交易对手信用风险暴露
    ,afptentriskexpse number(38,6) -- 潜在风险暴露-合计
    ,bankacptdraft number(38,6) -- 潜在风险暴露-其中：银行承兑汇票
    ,documlc number(38,6) -- 潜在风险暴露-其中：跟单信用证
    ,bkltr number(38,6) -- 潜在风险暴露-其中：保函
    ,loanproms number(38,6) -- 潜在风险暴露-其中：贷款承诺
    ,afothriskexpse number(38,6) -- 其他风险暴露
    ,moveriskexpse number(38,6) -- 风险缓释转出的风险暴露（转入为负数）
    ,sumunexpse number(38,6) -- 不考虑风险缓释作用的风险暴露总和
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
grant select on ${iol_schema}.less_les_unpeer_group_state to ${iml_schema};
grant select on ${iol_schema}.less_les_unpeer_group_state to ${icl_schema};
grant select on ${iol_schema}.less_les_unpeer_group_state to ${idl_schema};
grant select on ${iol_schema}.less_les_unpeer_group_state to ${iel_schema};

-- comment
comment on table ${iol_schema}.less_les_unpeer_group_state is '非同业集团客户及经济依存客户大额风险暴露情况表';
comment on column ${iol_schema}.less_les_unpeer_group_state.datadate is '数据日期';
comment on column ${iol_schema}.less_les_unpeer_group_state.seqitem is '序号';
comment on column ${iol_schema}.less_les_unpeer_group_state.customertype is '客户类型';
comment on column ${iol_schema}.less_les_unpeer_group_state.customername is '客户名称';
comment on column ${iol_schema}.less_les_unpeer_group_state.customercode is '客户代码';
comment on column ${iol_schema}.less_les_unpeer_group_state.sumexpse is '风险暴露总和-合计';
comment on column ${iol_schema}.less_les_unpeer_group_state.unexemptriskexpse is '风险暴露总和-其中：不可豁免风险暴露';
comment on column ${iol_schema}.less_les_unpeer_group_state.firstcapnarat is '占一级资本净额比例-合计';
comment on column ${iol_schema}.less_les_unpeer_group_state.unexemptriskexpseprop is '占一级资本净额比例-其中：不可豁免风险暴露';
comment on column ${iol_schema}.less_les_unpeer_group_state.afcomnriskexpse is '一般风险暴露-合计';
comment on column ${iol_schema}.less_les_unpeer_group_state.anyloan is '一般风险暴露-其中：各项贷款';
comment on column ${iol_schema}.less_les_unpeer_group_state.sumprod is '一般风险暴露-其中：债券投资';
comment on column ${iol_schema}.less_les_unpeer_group_state.secuinvest is '特定风险暴露-合计';
comment on column ${iol_schema}.less_les_unpeer_group_state.zgprod is '特定风险暴露-资产管理产品';
comment on column ${iol_schema}.less_les_unpeer_group_state.trustprod is '资产管理产品-其中：信托产品';
comment on column ${iol_schema}.less_les_unpeer_group_state.nbrk_evnchrem is '资产管理产品-其中：非保本理财';
comment on column ${iol_schema}.less_les_unpeer_group_state.secuastmgmtprod is '资产管理产品-其中：证券业资管产品';
comment on column ${iol_schema}.less_les_unpeer_group_state.zqprod is '特定风险暴露-资产证券化产品';
comment on column ${iol_schema}.less_les_unpeer_group_state.aftradeacctriskexpse is '交易账簿风险暴露';
comment on column ${iol_schema}.less_les_unpeer_group_state.aftradecpcrdtriskexpse is '交易对手信用风险暴露';
comment on column ${iol_schema}.less_les_unpeer_group_state.afptentriskexpse is '潜在风险暴露-合计';
comment on column ${iol_schema}.less_les_unpeer_group_state.bankacptdraft is '潜在风险暴露-其中：银行承兑汇票';
comment on column ${iol_schema}.less_les_unpeer_group_state.documlc is '潜在风险暴露-其中：跟单信用证';
comment on column ${iol_schema}.less_les_unpeer_group_state.bkltr is '潜在风险暴露-其中：保函';
comment on column ${iol_schema}.less_les_unpeer_group_state.loanproms is '潜在风险暴露-其中：贷款承诺';
comment on column ${iol_schema}.less_les_unpeer_group_state.afothriskexpse is '其他风险暴露';
comment on column ${iol_schema}.less_les_unpeer_group_state.moveriskexpse is '风险缓释转出的风险暴露（转入为负数）';
comment on column ${iol_schema}.less_les_unpeer_group_state.sumunexpse is '不考虑风险缓释作用的风险暴露总和';
comment on column ${iol_schema}.less_les_unpeer_group_state.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.less_les_unpeer_group_state.etl_timestamp is 'ETL处理时间戳';
