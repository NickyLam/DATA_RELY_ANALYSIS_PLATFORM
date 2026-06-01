/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_lhwd_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_lhwd_repay_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_lhwd_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_lhwd_repay_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,partner_dubil_id varchar2(100) -- 合作方借据编号
    ,repay_flow_num varchar2(250) -- 还款流水号
    ,repay_dt date -- 还款日期
    ,repay_perds number(10) -- 还款期数
    ,repay_amt number(30,8) -- 还款金额
    ,curr_cd varchar2(30) -- 币种代码
    ,paid_pric number(30,8) -- 实还本金
    ,paid_int number(30,8) -- 实还利息
    ,paid_pnlt number(30,8) -- 实还罚息
    ,paid_comp_int number(30,8) -- 实还复利
    ,paid_adv_repay_comm_fee number(30,8) -- 已还提前还款手续费
    ,repay_num_type_cd varchar2(30) -- 还款账户类型代码
    ,repay_num_name varchar2(500) -- 还款账户名称
    ,repay_num_open_acct_org_name varchar2(500) -- 还款账户开户机构名称
    ,repay_num_id varchar2(100) -- 还款账户编号
    ,repay_type_cd varchar2(30) -- 还款类型代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,callbk_type_cd varchar2(30) -- 回收类型代码
    ,clear_tran_id varchar2(100) -- 清算交易编号
    ,intnal_tran_flow_num varchar2(100) -- 内部交易流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,batch_dt date -- 批次日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.evt_lhwd_repay_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_lhwd_repay_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_lhwd_repay_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_lhwd_repay_dtl is '联合网贷还款明细';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.partner_dubil_id is '合作方借据编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_dt is '还款日期';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_perds is '还款期数';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_amt is '还款金额';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.paid_pric is '实还本金';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.paid_int is '实还利息';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.paid_pnlt is '实还罚息';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.paid_comp_int is '实还复利';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.paid_adv_repay_comm_fee is '已还提前还款手续费';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_num_type_cd is '还款账户类型代码';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_num_name is '还款账户名称';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_num_open_acct_org_name is '还款账户开户机构名称';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_type_cd is '还款类型代码';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.callbk_type_cd is '回收类型代码';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.clear_tran_id is '清算交易编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.intnal_tran_flow_num is '内部交易流水号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.batch_dt is '批次日期';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.update_org_id is '更新机构编号';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_lhwd_repay_dtl.etl_timestamp is 'ETL处理时间戳';
