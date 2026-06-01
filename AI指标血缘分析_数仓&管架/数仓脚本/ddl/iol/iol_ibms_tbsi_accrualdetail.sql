/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tbsi_accrualdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tbsi_accrualdetail
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tbsi_accrualdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbsi_accrualdetail(
    i_code varchar2(150) -- 
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,tg_code varchar2(15) -- 
    ,ad_cfid varchar2(15) -- 现金流id
    ,stream_id varchar2(150) -- 利率流id
    ,ad_startdate varchar2(15) -- 计息开始日期
    ,ad_enddate varchar2(15) -- 计息结束日期
    ,ad_fixingdate varchar2(15) -- 定息日期
    ,self_id varchar2(15) -- 计息明细id
    ,ad_actualrate number(38,6) -- 实际利率
    ,ad_yearfraction number(38,6) -- 年化时间
    ,ad_fixingrate number(38,6) -- 定息利率
    ,ad_spread number(38,6) -- 利差
    ,ad_caprate number(38,6) -- 利率上限
    ,ad_floorrate number(38,6) -- 利率下限
    ,ad_multiplier number(38,6) -- 基准利率倍数
    ,imp_time varchar2(29) -- 更新时间
    ,real_i_code varchar2(45) -- 
    ,ad_paymentdate varchar2(15) -- 支付日期
    ,ad_interestamount number(38,6) -- 计息区间利息
    ,pe_code varchar2(45) -- 定价环境代码
    ,i_code_rpt varchar2(195) -- 
    ,ad_notionalamount number(38,6) -- 计息区间本金
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
grant select on ${iol_schema}.ibms_tbsi_accrualdetail to ${iml_schema};
grant select on ${iol_schema}.ibms_tbsi_accrualdetail to ${icl_schema};
grant select on ${iol_schema}.ibms_tbsi_accrualdetail to ${idl_schema};
grant select on ${iol_schema}.ibms_tbsi_accrualdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tbsi_accrualdetail is '';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.i_code is '';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.a_type is '';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.m_type is '';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.tg_code is '';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_cfid is '现金流id';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.stream_id is '利率流id';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_startdate is '计息开始日期';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_enddate is '计息结束日期';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_fixingdate is '定息日期';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.self_id is '计息明细id';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_actualrate is '实际利率';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_yearfraction is '年化时间';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_fixingrate is '定息利率';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_spread is '利差';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_caprate is '利率上限';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_floorrate is '利率下限';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_multiplier is '基准利率倍数';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.imp_time is '更新时间';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.real_i_code is '';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_paymentdate is '支付日期';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_interestamount is '计息区间利息';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.pe_code is '定价环境代码';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.i_code_rpt is '';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.ad_notionalamount is '计息区间本金';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tbsi_accrualdetail.etl_timestamp is 'ETL处理时间戳';
