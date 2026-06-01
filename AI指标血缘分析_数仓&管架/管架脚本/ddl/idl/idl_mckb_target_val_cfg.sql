/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_target_val_cfg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_target_val_cfg
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_target_val_cfg purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_target_val_cfg(
    kb_name varchar2(200) -- 看板名称
    ,org_no varchar2(50) -- 机构编号
    ,org_name varchar2(200) -- 机构编号
    ,target_val number(38,8) -- 目标值
    ,unit varchar2(10) -- 单位
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mckb_target_val_cfg to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_target_val_cfg is '看板目标值配置表';
comment on column ${idl_schema}.mckb_target_val_cfg.kb_name is '看板名称';
comment on column ${idl_schema}.mckb_target_val_cfg.org_no is '机构编号';
comment on column ${idl_schema}.mckb_target_val_cfg.org_name is '机构编号';
comment on column ${idl_schema}.mckb_target_val_cfg.target_val is '目标值';
comment on column ${idl_schema}.mckb_target_val_cfg.unit is '单位';
comment on column ${idl_schema}.mckb_target_val_cfg.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_target_val_cfg.etl_timestamp is 'ETL处理时间戳';