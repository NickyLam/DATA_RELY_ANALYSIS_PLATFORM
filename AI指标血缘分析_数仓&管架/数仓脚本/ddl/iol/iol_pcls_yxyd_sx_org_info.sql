/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_yxyd_sx_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_yxyd_sx_org_info
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_yxyd_sx_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_yxyd_sx_org_info(
    bank_nm varchar2(4000) -- 分行名称
    ,appl_cnt number(22,0) -- 申请笔数
    ,monthcreated1 varchar2(4000) -- 申请月
    ,appl_pass_cnt number(22,0) -- 申请通过笔数
    ,appl_pass_percent number(38,6) -- 授信通过率（笔数）
    ,final_pass_cnt number(22,0) -- 终审通过笔数
    ,final_pass_percent number(38,6) -- 终审通过率
    ,final_pass_credit number(38,8) -- 额度
    ,final_pass_repay number(38,6) -- 定价
    ,tele_pass_cnt number(22,0) -- 电核通过笔数
    ,tele_pass_percent number(38,6) -- 电核通过率
    ,face_pass_cnt number(22,0) -- 面签通过笔数
    ,face_pass_percent number(38,6) -- 面签通过率
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
grant select on ${iol_schema}.pcls_yxyd_sx_org_info to ${iml_schema};
grant select on ${iol_schema}.pcls_yxyd_sx_org_info to ${icl_schema};
grant select on ${iol_schema}.pcls_yxyd_sx_org_info to ${idl_schema};
grant select on ${iol_schema}.pcls_yxyd_sx_org_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_yxyd_sx_org_info is '分行好易贷自营授信表';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.bank_nm is '分行名称';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.appl_cnt is '申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.monthcreated1 is '申请月';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.appl_pass_cnt is '申请通过笔数';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.appl_pass_percent is '授信通过率（笔数）';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.final_pass_cnt is '终审通过笔数';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.final_pass_percent is '终审通过率';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.final_pass_credit is '额度';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.final_pass_repay is '定价';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.tele_pass_cnt is '电核通过笔数';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.tele_pass_percent is '电核通过率';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.face_pass_cnt is '面签通过笔数';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.face_pass_percent is '面签通过率';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_yxyd_sx_org_info.etl_timestamp is 'ETL处理时间戳';
