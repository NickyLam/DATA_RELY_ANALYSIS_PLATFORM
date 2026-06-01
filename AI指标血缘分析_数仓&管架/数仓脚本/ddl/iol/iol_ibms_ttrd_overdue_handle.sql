/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_overdue_handle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_overdue_handle
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_overdue_handle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_overdue_handle(
    i_code varchar2(45) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,i_name varchar2(300) -- 金融工具名称
    ,is_ai_overdue varchar2(2) -- 利息是否逾期：1是0否
    ,amount_ai_overdue number(32,4) -- 利息逾期金额
    ,beg_date_ai_overdue varchar2(17) -- 利息逾期开始日
    ,is_cp_overdue varchar2(2) -- 本金是否逾期：1是0否
    ,amount_cp_overdue number(32,4) -- 本金逾期金额
    ,beg_date_cp_overdue varchar2(17) -- 本金逾期开始日
    ,transfer_table_type varchar2(2) -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
    ,statu varchar2(2) -- 状态 1:待复核,2:已生效
    ,check_name varchar2(75) -- 提交人/修改人
    ,check_time date -- 提交时间/修改时间
    ,review_user varchar2(75) -- 复核人
    ,review_time date -- 复核时间
    ,change_date varchar2(17) -- 变更日期
    ,is_si varchar2(2) -- 是次级标识
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
grant select on ${iol_schema}.ibms_ttrd_overdue_handle to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_overdue_handle to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_overdue_handle to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_overdue_handle to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_overdue_handle is '非标业务逾期处理表';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.is_ai_overdue is '利息是否逾期：1是0否';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.amount_ai_overdue is '利息逾期金额';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.beg_date_ai_overdue is '利息逾期开始日';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.is_cp_overdue is '本金是否逾期：1是0否';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.amount_cp_overdue is '本金逾期金额';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.beg_date_cp_overdue is '本金逾期开始日';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.transfer_table_type is '1:转表内,2:转表外,0:默认值,未进行过转表操作';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.statu is '状态 1:待复核,2:已生效';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.check_name is '提交人/修改人';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.check_time is '提交时间/修改时间';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.review_user is '复核人';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.review_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.change_date is '变更日期';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.is_si is '是次级标识';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_overdue_handle.etl_timestamp is 'ETL处理时间戳';
