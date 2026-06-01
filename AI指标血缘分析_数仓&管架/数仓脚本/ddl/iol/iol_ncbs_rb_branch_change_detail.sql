/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_branch_change_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_branch_change_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_branch_change_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_branch_change_detail(
    acct_name varchar2(200) -- 账户名称
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,amend_seq_no varchar2(50) -- 变更序号
    ,busi_type varchar2(20) -- 业务种类
    ,change_flag varchar2(1) -- 更换标志
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_branch_change_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_branch_change_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_branch_change_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_branch_change_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_branch_change_detail is '日终批处理文件明细登记表';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.amend_seq_no is '变更序号';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.busi_type is '业务种类';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.change_flag is '更换标志';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_branch_change_detail.etl_timestamp is 'ETL处理时间戳';
