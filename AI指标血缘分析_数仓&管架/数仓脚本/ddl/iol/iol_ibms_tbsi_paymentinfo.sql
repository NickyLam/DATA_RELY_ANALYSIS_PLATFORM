/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tbsi_paymentinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tbsi_paymentinfo
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tbsi_paymentinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbsi_paymentinfo(
    i_code varchar2(150) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,tg_code varchar2(15) -- 任务组代码
    ,pi_id varchar2(15) -- 现金流id
    ,stream_id varchar2(150) -- 利率流id
    ,pi_fixed number(38,6) -- 是否是确定现金流
    ,pi_calcenddate varchar2(15) -- 计息结束日期
    ,pi_paymentdate varchar2(15) -- 支付日
    ,pi_amount number(38,6) -- 金额
    ,pi_discount number(38,6) -- 折现率
    ,pi_notionalamount number(38,6) -- 金额中的本金部分
    ,pi_notionalamount_forcasted number(38,6) -- 金额中的本金部分中的预测部分
    ,pi_interestamount number(38,6) -- 金额中的利息部分
    ,pi_interestamount_forcasted number(38,6) -- 金额中的利息部分中的预测部分
    ,pi_prenotionalamount number(38,6) -- 发生前本金
    ,pi_nextnotionalamount number(38,6) -- 发生后本金
    ,pi_premium number(38,6) -- 期权费
    ,pi_premium_forcasted number(38,6) -- 期权费中的预测部分
    ,pi_probability number(38,6) -- 概率
    ,imp_time varchar2(29) -- 更新时间
    ,real_i_code varchar2(45) -- 真实的金融工具代码
    ,pi_calcstartdate varchar2(15) -- 计息开始日期
    ,pi_currency varchar2(5) -- 币种
    ,pi_settlecurrency varchar2(5) -- 结算币种
    ,pi_discounttime number(38,6) -- 贴现年化时间
    ,pe_code varchar2(45) -- 定价环境代码
    ,beg_date varchar2(15) -- 计算日期
    ,pi_cumudefaultrate number(38,6) -- 累积违约概率
    ,i_code_rpt varchar2(195) -- 
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
grant select on ${iol_schema}.ibms_tbsi_paymentinfo to ${iml_schema};
grant select on ${iol_schema}.ibms_tbsi_paymentinfo to ${icl_schema};
grant select on ${iol_schema}.ibms_tbsi_paymentinfo to ${idl_schema};
grant select on ${iol_schema}.ibms_tbsi_paymentinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tbsi_paymentinfo is '现金流明细表';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.tg_code is '任务组代码';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_id is '现金流id';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.stream_id is '利率流id';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_fixed is '是否是确定现金流';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_calcenddate is '计息结束日期';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_paymentdate is '支付日';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_amount is '金额';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_discount is '折现率';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_notionalamount is '金额中的本金部分';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_notionalamount_forcasted is '金额中的本金部分中的预测部分';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_interestamount is '金额中的利息部分';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_interestamount_forcasted is '金额中的利息部分中的预测部分';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_prenotionalamount is '发生前本金';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_nextnotionalamount is '发生后本金';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_premium is '期权费';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_premium_forcasted is '期权费中的预测部分';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_probability is '概率';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.imp_time is '更新时间';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.real_i_code is '真实的金融工具代码';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_calcstartdate is '计息开始日期';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_currency is '币种';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_settlecurrency is '结算币种';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_discounttime is '贴现年化时间';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pe_code is '定价环境代码';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.beg_date is '计算日期';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.pi_cumudefaultrate is '累积违约概率';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.i_code_rpt is '';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tbsi_paymentinfo.etl_timestamp is 'ETL处理时间戳';
