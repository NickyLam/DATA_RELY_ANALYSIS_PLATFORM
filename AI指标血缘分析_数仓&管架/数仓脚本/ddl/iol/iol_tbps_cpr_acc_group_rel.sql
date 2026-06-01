/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_acc_group_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_acc_group_rel
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_acc_group_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_acc_group_rel(
    agr_accountno varchar2(32) -- 账号
    ,agr_ecifno varchar2(32) -- 客户号
    ,agr_channel varchar2(4) -- 渠道
    ,agr_grpid varchar2(32) -- 功能组
    ,agr_authmodel varchar2(1) -- 审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义
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
grant select on ${iol_schema}.tbps_cpr_acc_group_rel to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_acc_group_rel to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_acc_group_rel to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_acc_group_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_acc_group_rel is '账号与功能组关系表';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.agr_accountno is '账号';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.agr_ecifno is '客户号';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.agr_channel is '渠道';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.agr_grpid is '功能组';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.agr_authmodel is '审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_acc_group_rel.etl_timestamp is 'ETL处理时间戳';
