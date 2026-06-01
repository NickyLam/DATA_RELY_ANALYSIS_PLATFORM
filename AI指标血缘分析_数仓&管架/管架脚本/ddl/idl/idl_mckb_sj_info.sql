/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_sj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_sj_info
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_sj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_sj_info(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,reject_reason_small varchar2(4000) -- 首拒原因
    ,t_1_cnt number(20) -- T-1申请笔数
    ,t_2_cnt number(20) -- T-2申请笔数
    ,t_3_cnt number(20) -- T-3申请笔数
    ,t_4_cnt number(20) -- T-4申请笔数
    ,t_5_cnt number(20) -- T-5申请笔数
    ,t_6_cnt number(20) -- T-6申请笔数
    ,t_7_cnt number(20) -- T-7申请笔数
    ,prod_cls_name varchar2(150) -- 产品分类(易贷，字节)
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
grant select on ${idl_schema}.mckb_sj_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_sj_info is '整体-拒绝发布';
comment on column ${idl_schema}.mckb_sj_info.org_id is '机构编号';
comment on column ${idl_schema}.mckb_sj_info.org_name is '机构名称';
comment on column ${idl_schema}.mckb_sj_info.reject_reason_small is '首拒原因';
comment on column ${idl_schema}.mckb_sj_info.t_1_cnt is 'T-1申请笔数';
comment on column ${idl_schema}.mckb_sj_info.t_2_cnt is 'T-2申请笔数';
comment on column ${idl_schema}.mckb_sj_info.t_3_cnt is 'T-3申请笔数';
comment on column ${idl_schema}.mckb_sj_info.t_4_cnt is 'T-4申请笔数';
comment on column ${idl_schema}.mckb_sj_info.t_5_cnt is 'T-5申请笔数';
comment on column ${idl_schema}.mckb_sj_info.t_6_cnt is 'T-6申请笔数';
comment on column ${idl_schema}.mckb_sj_info.t_7_cnt is 'T-7申请笔数';
comment on column ${idl_schema}.mckb_sj_info.prod_cls_name is '产品分类(易贷，字节)';
comment on column ${idl_schema}.mckb_sj_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_sj_info.etl_timestamp is 'ETL处理时间戳';