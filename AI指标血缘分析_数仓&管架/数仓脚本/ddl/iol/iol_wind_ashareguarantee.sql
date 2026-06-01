/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareguarantee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareguarantee
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareguarantee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareguarantee(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_compcode varchar2(60) -- 公司ID
    ,relation varchar2(60) -- 担保方与披露方关系
    ,guarantor varchar2(150) -- 担保方公司名称
    ,relation2 varchar2(60) -- 被担保方与披露方关系
    ,securedparty varchar2(150) -- 被担保方公司名称
    ,method varchar2(60) -- 担保方式
    ,amount number(20,4) -- 担保金额(元)
    ,crncy_code varchar2(15) -- 币种
    ,term number(20,4) -- 担保期限(年)
    ,start_dt varchar2(12) -- 担保起始日期
    ,end_dt varchar2(12) -- 担保终止日期
    ,is_complete number(1,0) -- 是否履行完毕
    ,is_related number(1,0) -- 是否关联交易
    ,trade_dt varchar2(12) -- 交易日期
    ,report_period varchar2(12) -- 报告期
    ,is_overdue number(1,0) -- 担保是否逾期
    ,overdue_amount number(20,4) -- 担保逾期金额(元)
    ,is_counterguarantee number(1,0) -- 是否存在反担保
    ,ann_dt varchar2(12) -- 公告日期
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
grant select on ${iol_schema}.wind_ashareguarantee to ${iml_schema};
grant select on ${iol_schema}.wind_ashareguarantee to ${icl_schema};
grant select on ${iol_schema}.wind_ashareguarantee to ${idl_schema};
grant select on ${iol_schema}.wind_ashareguarantee to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareguarantee is '中国A股担保事件';
comment on column ${iol_schema}.wind_ashareguarantee.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareguarantee.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareguarantee.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_ashareguarantee.relation is '担保方与披露方关系';
comment on column ${iol_schema}.wind_ashareguarantee.guarantor is '担保方公司名称';
comment on column ${iol_schema}.wind_ashareguarantee.relation2 is '被担保方与披露方关系';
comment on column ${iol_schema}.wind_ashareguarantee.securedparty is '被担保方公司名称';
comment on column ${iol_schema}.wind_ashareguarantee.method is '担保方式';
comment on column ${iol_schema}.wind_ashareguarantee.amount is '担保金额(元)';
comment on column ${iol_schema}.wind_ashareguarantee.crncy_code is '币种';
comment on column ${iol_schema}.wind_ashareguarantee.term is '担保期限(年)';
comment on column ${iol_schema}.wind_ashareguarantee.start_dt is '担保起始日期';
comment on column ${iol_schema}.wind_ashareguarantee.end_dt is '担保终止日期';
comment on column ${iol_schema}.wind_ashareguarantee.is_complete is '是否履行完毕';
comment on column ${iol_schema}.wind_ashareguarantee.is_related is '是否关联交易';
comment on column ${iol_schema}.wind_ashareguarantee.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_ashareguarantee.report_period is '报告期';
comment on column ${iol_schema}.wind_ashareguarantee.is_overdue is '担保是否逾期';
comment on column ${iol_schema}.wind_ashareguarantee.overdue_amount is '担保逾期金额(元)';
comment on column ${iol_schema}.wind_ashareguarantee.is_counterguarantee is '是否存在反担保';
comment on column ${iol_schema}.wind_ashareguarantee.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareguarantee.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareguarantee.etl_timestamp is 'ETL处理时间戳';
