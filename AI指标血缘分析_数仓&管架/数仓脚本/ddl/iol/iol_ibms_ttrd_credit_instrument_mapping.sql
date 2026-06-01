/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_credit_instrument_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_credit_instrument_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_credit_instrument_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_credit_instrument_mapping(
    confirm_i_code varchar2(75) -- 交易单限额指令金融工具
    ,confirm_a_type varchar2(30) -- 交易单限额指令金融工具
    ,confirm_m_type varchar2(30) -- 交易单限额指令金融工具
    ,approve_i_code varchar2(75) -- 审批单限额指令金融工具
    ,approve_a_type varchar2(30) -- 审批单限额指令金融工具
    ,approve_m_type varchar2(30) -- 审批单限额指令金融工具
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
grant select on ${iol_schema}.ibms_ttrd_credit_instrument_mapping to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_credit_instrument_mapping to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_credit_instrument_mapping to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_credit_instrument_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_credit_instrument_mapping is '授信审批单交易单金融工具映射表';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.confirm_i_code is '交易单限额指令金融工具';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.confirm_a_type is '交易单限额指令金融工具';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.confirm_m_type is '交易单限额指令金融工具';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.approve_i_code is '审批单限额指令金融工具';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.approve_a_type is '审批单限额指令金融工具';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.approve_m_type is '审批单限额指令金融工具';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_credit_instrument_mapping.etl_timestamp is 'ETL处理时间戳';
