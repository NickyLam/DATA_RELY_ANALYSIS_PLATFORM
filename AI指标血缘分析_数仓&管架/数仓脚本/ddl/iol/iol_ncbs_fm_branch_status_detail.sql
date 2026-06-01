/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_branch_status_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_branch_status_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_branch_status_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_branch_status_detail(
    branch varchar2(12) -- 机构编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,reg_value varchar2(50) -- 登记值
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,branch_reg_type varchar2(1) -- 机构操作类型
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
grant select on ${iol_schema}.ncbs_fm_branch_status_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_branch_status_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_status_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_status_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_branch_status_detail is '机构状态历史登记明细表';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.branch is '机构编号';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.company is '法人';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.reg_value is '登记值';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.branch_reg_type is '机构操作类型';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_branch_status_detail.etl_timestamp is 'ETL处理时间戳';
