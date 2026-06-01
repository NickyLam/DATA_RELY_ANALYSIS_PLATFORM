/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_wxbank_account_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_wxbank_account_info
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_wxbank_account_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_wxbank_account_info(
    wai_ecifno varchar2(20) -- 客户号
    ,wai_accno varchar2(100) -- 银行卡号
    ,wai_acctype varchar2(10) -- 卡板类型
    ,wai_cardtype varchar2(12) -- 卡类型
    ,wai_infopushflag varchar2(14) -- 动账推送标识 1-推送 0-不推送
    ,wai_lastupdatetime varchar2(14) -- 最后更新时间
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
grant select on ${iol_schema}.osbs_wxbank_account_info to ${iml_schema};
grant select on ${iol_schema}.osbs_wxbank_account_info to ${icl_schema};
grant select on ${iol_schema}.osbs_wxbank_account_info to ${idl_schema};
grant select on ${iol_schema}.osbs_wxbank_account_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_wxbank_account_info is '微信银行绑卡信息表';
comment on column ${iol_schema}.osbs_wxbank_account_info.wai_ecifno is '客户号';
comment on column ${iol_schema}.osbs_wxbank_account_info.wai_accno is '银行卡号';
comment on column ${iol_schema}.osbs_wxbank_account_info.wai_acctype is '卡板类型';
comment on column ${iol_schema}.osbs_wxbank_account_info.wai_cardtype is '卡类型';
comment on column ${iol_schema}.osbs_wxbank_account_info.wai_infopushflag is '动账推送标识 1-推送 0-不推送';
comment on column ${iol_schema}.osbs_wxbank_account_info.wai_lastupdatetime is '最后更新时间';
comment on column ${iol_schema}.osbs_wxbank_account_info.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_wxbank_account_info.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_wxbank_account_info.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_wxbank_account_info.etl_timestamp is 'ETL处理时间戳';
