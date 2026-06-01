/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_bu_om_external_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_bu_om_external_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_bu_om_external_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_bu_om_external_rate(
    source_ccy varchar2(12) -- 基础币种
    ,target_ccy varchar2(12) -- 标价币种
    ,effect_date varchar2(104) -- 生效日期
    ,ext_middle_rate number(15,8) -- 外管中间价
    ,company varchar2(80) -- 法人
    ,tran_timestamp varchar2(104) -- 交易时间戳
    ,om_user_id varchar2(80) -- 用户id
    ,market_source varchar2(4) -- 行情来源
    ,rate_seq_no varchar2(400) -- 汇率同步序列号
    ,quote_type varchar2(4) -- 牌价类型
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
grant select on ${iol_schema}.ncbs_bu_om_external_rate to ${iml_schema};
grant select on ${iol_schema}.ncbs_bu_om_external_rate to ${icl_schema};
grant select on ${iol_schema}.ncbs_bu_om_external_rate to ${idl_schema};
grant select on ${iol_schema}.ncbs_bu_om_external_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_bu_om_external_rate is '外管中间价表';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.source_ccy is '基础币种';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.target_ccy is '标价币种';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.effect_date is '生效日期';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.ext_middle_rate is '外管中间价';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.company is '法人';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.om_user_id is '用户id';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.market_source is '行情来源';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.rate_seq_no is '汇率同步序列号';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.quote_type is '牌价类型';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_bu_om_external_rate.etl_timestamp is 'ETL处理时间戳';
