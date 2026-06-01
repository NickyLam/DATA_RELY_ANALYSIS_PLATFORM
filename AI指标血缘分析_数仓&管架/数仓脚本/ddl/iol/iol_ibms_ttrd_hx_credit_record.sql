/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_hx_credit_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_hx_credit_record
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_hx_credit_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_hx_credit_record(
    id number(22) -- 序列,取s_ttrd_hx_credit_common
    ,ord_id varchar2(75) -- 占信审批单号
    ,intordid varchar2(75) -- 占信交易单号
    ,i_code varchar2(75) -- 占信金融工具代码
    ,a_type varchar2(30) -- 占信金融工具资产类型
    ,m_type varchar2(30) -- 占信金融工具市场类型
    ,secu_accid varchar2(45) -- 占信内部证券账户
    ,secu_actgtype varchar2(45) -- 占信账户会计分类
    ,credit_secu_type varchar2(30) -- 占信账户类别,bank-银行账簿,trade-交易账簿
    ,party_id varchar2(30) -- 授信方
    ,party_name varchar2(150) -- 授信方名称
    ,reply_code varchar2(150) -- 额度合同编号
    ,occupy_amount number(31,4) -- 占信额度
    ,remain_amount number(31,4) -- 占信释放剩余额度
    ,update_time varchar2(30) -- 更新时间
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
grant select on ${iol_schema}.ibms_ttrd_hx_credit_record to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_hx_credit_record to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_hx_credit_record to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_hx_credit_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_hx_credit_record is '华兴外部授信占用记录表';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.id is '序列,取s_ttrd_hx_credit_common';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.ord_id is '占信审批单号';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.intordid is '占信交易单号';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.i_code is '占信金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.a_type is '占信金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.m_type is '占信金融工具市场类型';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.secu_accid is '占信内部证券账户';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.secu_actgtype is '占信账户会计分类';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.credit_secu_type is '占信账户类别,bank-银行账簿,trade-交易账簿';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.party_id is '授信方';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.party_name is '授信方名称';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.reply_code is '额度合同编号';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.occupy_amount is '占信额度';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.remain_amount is '占信释放剩余额度';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_hx_credit_record.etl_timestamp is 'ETL处理时间戳';
