/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_loan_distr_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_loan_distr_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_loan_distr_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_distr_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,loan_num varchar2(60) -- 贷款号
    ,seq_num varchar2(60) -- 序号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,distr_flow_num varchar2(100) -- 放款流水号
    ,cust_id varchar2(100) -- 客户编号
    ,contrior_id varchar2(500) -- 出资人编号
    ,once_open_distr_flg varchar2(10) -- 一次性开立发放标志
    ,distr_way_cd varchar2(30) -- 发放方式代码
    ,distr_dt date -- 放款日期
    ,distr_amt number(30,2) -- 放款金额
    ,discnt_int number(30,2) -- 贴现利息
    ,exp_dt date -- 到期日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_dt date -- 交易日期
    ,dubil_id varchar2(100) -- 借据编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,bus_tran_cate_cd varchar2(30) -- 业务交易码
    ,revs_flg varchar2(10) -- 冲正标志
    ,tran_revs_rs varchar2(500) -- 交易冲正原因
    ,revs_teller_id varchar2(100) -- 冲正柜员编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_loan_distr_flow to ${icl_schema};
grant select on ${iml_schema}.evt_loan_distr_flow to ${idl_schema};
grant select on ${iml_schema}.evt_loan_distr_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_loan_distr_flow is '贷款放款流水';
comment on column ${iml_schema}.evt_loan_distr_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_loan_distr_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_loan_distr_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_loan_distr_flow.loan_num is '贷款号';
comment on column ${iml_schema}.evt_loan_distr_flow.seq_num is '序号';
comment on column ${iml_schema}.evt_loan_distr_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_loan_distr_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_loan_distr_flow.distr_flow_num is '放款流水号';
comment on column ${iml_schema}.evt_loan_distr_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_loan_distr_flow.contrior_id is '出资人编号';
comment on column ${iml_schema}.evt_loan_distr_flow.once_open_distr_flg is '一次性开立发放标志';
comment on column ${iml_schema}.evt_loan_distr_flow.distr_way_cd is '发放方式代码';
comment on column ${iml_schema}.evt_loan_distr_flow.distr_dt is '放款日期';
comment on column ${iml_schema}.evt_loan_distr_flow.distr_amt is '放款金额';
comment on column ${iml_schema}.evt_loan_distr_flow.discnt_int is '贴现利息';
comment on column ${iml_schema}.evt_loan_distr_flow.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_loan_distr_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_loan_distr_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_loan_distr_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_loan_distr_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_loan_distr_flow.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.evt_loan_distr_flow.bus_tran_cate_cd is '业务交易码';
comment on column ${iml_schema}.evt_loan_distr_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_loan_distr_flow.tran_revs_rs is '交易冲正原因';
comment on column ${iml_schema}.evt_loan_distr_flow.revs_teller_id is '冲正柜员编号';
comment on column ${iml_schema}.evt_loan_distr_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_loan_distr_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_loan_distr_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_loan_distr_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_loan_distr_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_loan_distr_flow.etl_timestamp is 'ETL处理时间戳';
