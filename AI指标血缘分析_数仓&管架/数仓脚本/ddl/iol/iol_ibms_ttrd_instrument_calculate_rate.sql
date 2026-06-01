/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_instrument_calculate_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_instrument_calculate_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_instrument_calculate_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_instrument_calculate_rate(
    id number(22,0) -- 主键
    ,i_code varchar2(75) -- 
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,beg_date varchar2(15) -- 生效日期
    ,nominal_rate number(12,6) -- 名义利率
    ,added_rate number(12,6) -- 增值税率
    ,slotting_addrate number(12,6) -- 通道附加税率
    ,slotting_rate number(12,6) -- 通道费率
    ,slotting_daycounter varchar2(45) -- 通道费计息基准
    ,trustee_rate number(12,6) -- 托管费率
    ,trustee_daycounter varchar2(45) -- 托管费计息基准
    ,other_rate number(12,6) -- 其他费率
    ,other_daycounter varchar2(45) -- 其他费用计息基准
    ,nominal_daycounter varchar2(45) -- 名义利率计息基准
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
grant select on ${iol_schema}.ibms_ttrd_instrument_calculate_rate to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument_calculate_rate to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument_calculate_rate to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument_calculate_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_instrument_calculate_rate is '金融工具计算利率表';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.i_code is '';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.a_type is '';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.m_type is '';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.beg_date is '生效日期';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.nominal_rate is '名义利率';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.added_rate is '增值税率';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.slotting_addrate is '通道附加税率';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.slotting_rate is '通道费率';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.slotting_daycounter is '通道费计息基准';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.trustee_rate is '托管费率';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.trustee_daycounter is '托管费计息基准';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.other_rate is '其他费率';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.other_daycounter is '其他费用计息基准';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.nominal_daycounter is '名义利率计息基准';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_instrument_calculate_rate.etl_timestamp is 'ETL处理时间戳';
