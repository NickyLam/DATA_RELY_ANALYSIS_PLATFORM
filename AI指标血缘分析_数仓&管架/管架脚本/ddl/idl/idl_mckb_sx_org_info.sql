/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_sx_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_sx_org_info
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_sx_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_sx_org_info(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,appldt varchar2(10) -- 申请日期
    ,appl_cnt number(20) -- 申请笔数
    ,appl_pass_cnt number(20) -- 通过笔数
    ,appl_pass_percent number(38,4) -- 通过率
    ,crdt_avg number(38,4) -- 授信件均
    ,final_pass_repay number(38,4) -- 平均定价
    ,final_pass_cnt number(20) -- 终审通过笔数
    ,final_passing_rat number(38,4) -- 终审通过率
    ,tele_pass_cnt number(20) -- 电核通过笔数
    ,tele_pass_percent number(38,4) -- 电核通过率
    ,elec_enegy_crdt_avg number(38,4) -- 电核授信件均
    ,face_pass_cnt number(20) -- 面签通过笔数
    ,face_pass_percent number(38,4) -- 面签通过率
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mckb_sx_org_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_sx_org_info is '整体-进件-授信-易贷';
comment on column ${idl_schema}.mckb_sx_org_info.org_id is '机构编号';
comment on column ${idl_schema}.mckb_sx_org_info.org_name is '机构名称';
comment on column ${idl_schema}.mckb_sx_org_info.appldt is '申请日期';
comment on column ${idl_schema}.mckb_sx_org_info.appl_cnt is '申请笔数';
comment on column ${idl_schema}.mckb_sx_org_info.appl_pass_cnt is '通过笔数';
comment on column ${idl_schema}.mckb_sx_org_info.appl_pass_percent is '通过率';
comment on column ${idl_schema}.mckb_sx_org_info.crdt_avg is '授信件均';
comment on column ${idl_schema}.mckb_sx_org_info.final_pass_repay is '平均定价';
comment on column ${idl_schema}.mckb_sx_org_info.final_pass_cnt is '终审通过笔数';
comment on column ${idl_schema}.mckb_sx_org_info.final_passing_rat is '终审通过率';
comment on column ${idl_schema}.mckb_sx_org_info.tele_pass_cnt is '电核通过笔数';
comment on column ${idl_schema}.mckb_sx_org_info.tele_pass_percent is '电核通过率';
comment on column ${idl_schema}.mckb_sx_org_info.elec_enegy_crdt_avg is '电核授信件均';
comment on column ${idl_schema}.mckb_sx_org_info.face_pass_cnt is '面签通过笔数';
comment on column ${idl_schema}.mckb_sx_org_info.face_pass_percent is '面签通过率';
comment on column ${idl_schema}.mckb_sx_org_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_sx_org_info.etl_timestamp is 'ETL处理时间戳';