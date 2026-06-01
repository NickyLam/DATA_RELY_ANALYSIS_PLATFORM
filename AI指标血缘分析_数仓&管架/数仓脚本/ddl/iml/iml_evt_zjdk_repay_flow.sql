/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_zjdk_repay_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_zjdk_repay_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_zjdk_repay_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_zjdk_repay_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,repay_flow_num varchar2(250) -- 还款流水号
    ,intnal_dubil_id varchar2(100) -- 借据编号
    ,zjdk_prod_id varchar2(100) -- 字节产品编号
    ,acct_dt date -- 账务日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_amt number(30,8) -- 交易金额
    ,actl_recv_amt number(30,8) -- 实收金额
    ,pric_amt number(30,8) -- 本金发生额
    ,int_amt number(30,8) -- 利息发生额
    ,pnlt_amt number(30,8) -- 罚息发生额
    ,paid_adv_repay_comm_fee number(30,8) -- 已还提前还款手续费
    ,non_acru_flg varchar2(10) -- 非应计标志
    ,repay_num_id varchar2(100) -- 还款账户编号
    ,repay_num_type_cd varchar2(30) -- 还款账户类型代码
    ,repay_num_open_acct_org_name varchar2(500) -- 还款账户开户机构名称
    ,plat_indent_id varchar2(100) -- 平台订单编号
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
grant select on ${iml_schema}.evt_zjdk_repay_flow to ${icl_schema};
grant select on ${iml_schema}.evt_zjdk_repay_flow to ${idl_schema};
grant select on ${iml_schema}.evt_zjdk_repay_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_zjdk_repay_flow is '字节小微贷还款流水';
comment on column ${iml_schema}.evt_zjdk_repay_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.intnal_dubil_id is '借据编号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.zjdk_prod_id is '字节产品编号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.acct_dt is '账务日期';
comment on column ${iml_schema}.evt_zjdk_repay_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_zjdk_repay_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_zjdk_repay_flow.actl_recv_amt is '实收金额';
comment on column ${iml_schema}.evt_zjdk_repay_flow.pric_amt is '本金发生额';
comment on column ${iml_schema}.evt_zjdk_repay_flow.int_amt is '利息发生额';
comment on column ${iml_schema}.evt_zjdk_repay_flow.pnlt_amt is '罚息发生额';
comment on column ${iml_schema}.evt_zjdk_repay_flow.paid_adv_repay_comm_fee is '已还提前还款手续费';
comment on column ${iml_schema}.evt_zjdk_repay_flow.non_acru_flg is '非应计标志';
comment on column ${iml_schema}.evt_zjdk_repay_flow.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.repay_num_type_cd is '还款账户类型代码';
comment on column ${iml_schema}.evt_zjdk_repay_flow.repay_num_open_acct_org_name is '还款账户开户机构名称';
comment on column ${iml_schema}.evt_zjdk_repay_flow.plat_indent_id is '平台订单编号';
comment on column ${iml_schema}.evt_zjdk_repay_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_zjdk_repay_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_zjdk_repay_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_zjdk_repay_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_zjdk_repay_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_zjdk_repay_flow.etl_timestamp is 'ETL处理时间戳';
