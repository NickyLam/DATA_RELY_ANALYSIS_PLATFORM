/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_stage_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_stage_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_stage_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_stage_info(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,stage_no number(5) -- 期次
    ,accounting_status varchar2(3) -- 核算状态
    ,accounting_status_prev varchar2(3) -- 上次核算状态
    ,due_date date -- 单据到期日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,gintp_amt number(17,2) -- 宽限期利息
    ,gintp_amt_prev number(17,2) -- 上日宽限期利息
    ,godip_amt number(17,2) -- 宽限期复利
    ,godip_amt_prev number(17,2) -- 上日宽限期复利
    ,godpp_amt number(17,2) -- 宽限期罚息
    ,godpp_amt_prev number(17,2) -- 上日宽限期罚息
    ,gprd_amt number(17,2) -- 宽限期本金
    ,gprd_amt_prev number(17,2) -- 上日宽限期本金
    ,intp_amt number(17,2) -- 逾期利息
    ,intp_amt_prev number(17,2) -- 账户上日逾期利息
    ,odip_amt number(17,2) -- 复利余额
    ,odip_amt_prev number(17,2) -- 上日逾期复利
    ,odpp_amt number(17,2) -- 逾期罚息余额
    ,odpp_amt_prev number(17,2) -- 上日逾期罚息
    ,prd_amt number(17,2) -- 逾期本金
    ,prd_amt_prev number(17,2) -- 上日逾期本金
    ,last_bal_upd_date date -- 上次动户日期
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
grant select on ${iol_schema}.ncbs_cl_stage_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_stage_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_stage_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_stage_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_stage_info is '贷款期次信息表';
comment on column ${iol_schema}.ncbs_cl_stage_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_stage_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_stage_info.company is '法人';
comment on column ${iol_schema}.ncbs_cl_stage_info.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_stage_info.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_stage_info.accounting_status_prev is '上次核算状态';
comment on column ${iol_schema}.ncbs_cl_stage_info.due_date is '单据到期日';
comment on column ${iol_schema}.ncbs_cl_stage_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_stage_info.gintp_amt is '宽限期利息';
comment on column ${iol_schema}.ncbs_cl_stage_info.gintp_amt_prev is '上日宽限期利息';
comment on column ${iol_schema}.ncbs_cl_stage_info.godip_amt is '宽限期复利';
comment on column ${iol_schema}.ncbs_cl_stage_info.godip_amt_prev is '上日宽限期复利';
comment on column ${iol_schema}.ncbs_cl_stage_info.godpp_amt is '宽限期罚息';
comment on column ${iol_schema}.ncbs_cl_stage_info.godpp_amt_prev is '上日宽限期罚息';
comment on column ${iol_schema}.ncbs_cl_stage_info.gprd_amt is '宽限期本金';
comment on column ${iol_schema}.ncbs_cl_stage_info.gprd_amt_prev is '上日宽限期本金';
comment on column ${iol_schema}.ncbs_cl_stage_info.intp_amt is '逾期利息';
comment on column ${iol_schema}.ncbs_cl_stage_info.intp_amt_prev is '账户上日逾期利息';
comment on column ${iol_schema}.ncbs_cl_stage_info.odip_amt is '复利余额';
comment on column ${iol_schema}.ncbs_cl_stage_info.odip_amt_prev is '上日逾期复利';
comment on column ${iol_schema}.ncbs_cl_stage_info.odpp_amt is '逾期罚息余额';
comment on column ${iol_schema}.ncbs_cl_stage_info.odpp_amt_prev is '上日逾期罚息';
comment on column ${iol_schema}.ncbs_cl_stage_info.prd_amt is '逾期本金';
comment on column ${iol_schema}.ncbs_cl_stage_info.prd_amt_prev is '上日逾期本金';
comment on column ${iol_schema}.ncbs_cl_stage_info.last_bal_upd_date is '上次动户日期';
comment on column ${iol_schema}.ncbs_cl_stage_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_stage_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_stage_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_stage_info.etl_timestamp is 'ETL处理时间戳';
