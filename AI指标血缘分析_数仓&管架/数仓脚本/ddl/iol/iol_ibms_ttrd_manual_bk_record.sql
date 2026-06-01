/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_manual_bk_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_manual_bk_record
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_manual_bk_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_manual_bk_record(
    record_id number(16,0) -- 记录id
    ,account_date varchar2(15) -- 记账日期
    ,bkkpg_org_id varchar2(45) -- 记账机构号
    ,flow_id varchar2(45) -- 分录流水号
    ,hostflow_no varchar2(45) -- 核心流水号
    ,create_user number(22,0) -- 录入柜员id
    ,create_user_name varchar2(150) -- 录入柜员名称
    ,acct_user number(22,0) -- 记账柜员id
    ,acct_user_name varchar2(150) -- 记账柜员名称
    ,erase_user number(22,0) -- 抹账授权柜员id
    ,erase_user_name varchar2(150) -- 抹账授权柜员名称
    ,create_time varchar2(29) -- 录入时间
    ,account_time varchar2(29) -- 记账时间
    ,erase_time varchar2(29) -- 抹账时间
    ,state number(22,0) -- 状态:0,新建 1,未记账 2,已记账
    ,remark varchar2(900) -- 备注
    ,inst_id number(16,0) -- 券/资金指令号
    ,acct_review_user number(22,0) -- 记账复核人
    ,acct_review_user_name varchar2(150) -- 记账复核人名称
    ,eraseuser number(22,0) -- 抹账人
    ,eraseuser_name varchar2(150) -- 抹账人名称
    ,acct_type varchar2(2) -- 状态:0,仅核心记账  1,核心、资金系统记账
    ,trade_id varchar2(150) -- 
    ,bk_flag varchar2(2) -- 记账标识，0：内部户，1：科目
    ,obj_id varchar2(45) -- 核算余额id
    ,party_id varchar2(45) -- 当事人编号
    ,party_name varchar2(330) -- 当事人编号
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
grant select on ${iol_schema}.ibms_ttrd_manual_bk_record to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_manual_bk_record to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_manual_bk_record to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_manual_bk_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_manual_bk_record is '手工记账记录信息表';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.record_id is '记录id';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.account_date is '记账日期';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.bkkpg_org_id is '记账机构号';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.flow_id is '分录流水号';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.hostflow_no is '核心流水号';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.create_user is '录入柜员id';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.create_user_name is '录入柜员名称';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.acct_user is '记账柜员id';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.acct_user_name is '记账柜员名称';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.erase_user is '抹账授权柜员id';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.erase_user_name is '抹账授权柜员名称';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.create_time is '录入时间';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.account_time is '记账时间';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.erase_time is '抹账时间';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.state is '状态:0,新建 1,未记账 2,已记账';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.inst_id is '券/资金指令号';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.acct_review_user is '记账复核人';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.acct_review_user_name is '记账复核人名称';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.eraseuser is '抹账人';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.eraseuser_name is '抹账人名称';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.acct_type is '状态:0,仅核心记账  1,核心、资金系统记账';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.trade_id is '';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.bk_flag is '记账标识，0：内部户，1：科目';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.obj_id is '核算余额id';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.party_id is '当事人编号';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.party_name is '当事人编号';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_manual_bk_record.etl_timestamp is 'ETL处理时间戳';
