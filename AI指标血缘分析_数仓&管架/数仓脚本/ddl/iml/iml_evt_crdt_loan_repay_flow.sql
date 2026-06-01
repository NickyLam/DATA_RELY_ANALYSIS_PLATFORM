/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_crdt_loan_repay_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_crdt_loan_repay_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_crdt_loan_repay_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_crdt_loan_repay_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,dubil_id varchar2(100) -- 借据编号
    ,tran_dt date -- 交易日期
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_id varchar2(100) -- 证件编号
    ,curr_cd varchar2(30) -- 币种代码
    ,deduct_acct_num varchar2(100) -- 扣款账户编号
    ,repay_tran_flow_num varchar2(100) -- 还款交易流水号
    ,repay_type_cd varchar2(30) -- 还款类型代码
    ,rpbl_amt number(30,8) -- 应还金额
    ,actl_repay_amt number(30,8) -- 实际还款金额
    ,paid_pric number(30,8) -- 实还本金
    ,paid_int number(30,8) -- 实还利息
    ,paid_pnlt number(30,8) -- 实还罚息
    ,paid_comp_int number(30,8) -- 实还复利
    ,surp_pric number(30,8) -- 剩余本金
    ,repay_perds number(10) -- 还款期数
    ,revs_flg varchar2(10) -- 冲正标志
    ,happ_rs_cd varchar2(30) -- 发生原因代码
    ,callbk_id varchar2(250) -- 回收编号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,init_sys_id varchar2(100) -- 发起系统编号
    ,remark varchar2(2000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_crdt_loan_repay_flow to ${icl_schema};
grant select on ${iml_schema}.evt_crdt_loan_repay_flow to ${idl_schema};
grant select on ${iml_schema}.evt_crdt_loan_repay_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_crdt_loan_repay_flow is '信贷贷款还款流水';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.cert_id is '证件编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.deduct_acct_num is '扣款账户编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.repay_tran_flow_num is '还款交易流水号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.repay_type_cd is '还款类型代码';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.rpbl_amt is '应还金额';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.actl_repay_amt is '实际还款金额';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.paid_pric is '实还本金';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.paid_int is '实还利息';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.paid_pnlt is '实还罚息';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.paid_comp_int is '实还复利';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.surp_pric is '剩余本金';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.repay_perds is '还款期数';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.happ_rs_cd is '发生原因代码';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.callbk_id is '回收编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.init_sys_id is '发起系统编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.remark is '备注';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_crdt_loan_repay_flow.etl_timestamp is 'ETL处理时间戳';
