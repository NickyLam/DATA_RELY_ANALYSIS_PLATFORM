/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_accr_adj_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_accr_adj_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_accr_adj_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_accr_adj_hist(
    branch varchar2(12) -- 机构编号
    ,business_unit varchar2(10) -- 账套
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,adj_counter number(5) -- 计提调整次数
    ,adj_seq_no varchar2(50) -- 计提调整序号
    ,company varchar2(20) -- 法人
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,reversal varchar2(1) -- 是否冲正标志
    ,tran_source varchar2(1) -- 交易发起方
    ,int_class varchar2(6) -- 利息分类
    ,accounting_status varchar2(3) -- 核算状态
    ,adjust_date date -- 调整日期
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,adj_reason varchar2(200) -- 计提调整原因
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,accr_adj_type varchar2(5) -- 计提调整类型
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
grant select on ${iol_schema}.ncbs_cl_acct_accr_adj_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_accr_adj_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_accr_adj_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_accr_adj_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_accr_adj_hist is '账户计提调整历史表';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.adj_counter is '计提调整次数';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.adj_seq_no is '计提调整序号';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.tran_source is '交易发起方';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.adjust_date is '调整日期';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.adj_reason is '计提调整原因';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.accr_adj_type is '计提调整类型';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_accr_adj_hist.etl_timestamp is 'ETL处理时间戳';
