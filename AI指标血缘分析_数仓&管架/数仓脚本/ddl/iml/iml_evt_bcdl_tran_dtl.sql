/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bcdl_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bcdl_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bcdl_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bcdl_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 交易客户编号
    ,corp_work_dt date -- 企业工作日期
    ,corp_flow_num varchar2(100) -- 企业流水号
    ,corp_work_dt_batch date -- 企业工作日期(批次)
    ,corp_flow_num_batch varchar2(100) -- 企业流水号(批次)
    ,work_dt_batch date -- 工作日期(批次)
    ,flow_num_batch varchar2(60) -- 流水号(批次)
    ,tran_step_cd varchar2(10) -- 交易步骤代码
    ,acct_dt date -- 账务日期
    ,check_entry_status_cd varchar2(10) -- 对账核对状态代码
    ,chn_cd varchar2(10) -- 渠道代码
    ,chn_dt date -- 渠道日期
    ,chn_flow_num varchar2(100) -- 渠道流水号
    ,core_tran_dt date -- 核心交易日期
    ,core_tran_flow_num varchar2(60) -- 核心交易流水号
    ,init_sys_idf_id varchar2(100) -- 原系统标识编号
    ,org_id varchar2(60) -- 机构编号
    ,pay_acct varchar2(90) -- 付款账户
    ,pay_acct_num_name varchar2(750) -- 付款账号户名
    ,recver_type_cd varchar2(10) -- 收款人类型代码
    ,recvbl_num varchar2(60) -- 收款账号
    ,recvbl_num_acct_name varchar2(750) -- 收款账号户名
    ,recv_bank_no varchar2(100) -- 收款行行号
    ,recv_bank_name varchar2(750) -- 收款行名称
    ,curr_cd varchar2(10) -- 币种代码
    ,ec_idf_cd varchar2(10) -- 钞汇标识代码
    ,tran_amt number(30,2) -- 交易金额
    ,comm_fee number(30,2) -- 手续费
    ,memo_cd varchar2(10) -- 摘要代码
    ,postsc varchar2(200) -- 附言
    ,dtl_status_cd varchar2(10) -- 明细状态代码
    ,resp_code varchar2(45) -- 响应码
    ,resp_info varchar2(3000) -- 响应信息
    ,sync_rest_dt timestamp -- 同步结果日期
    ,sync_rest_cnt number(10) -- 同步结果次数
    ,sorc_sys_tran_timestamp timestamp -- 源系统交易时间戳
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,output_ip_addr varchar2(500) -- 输出IP地址
    ,output_mac_val varchar2(500) -- 输出MAC值
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
grant select on ${iml_schema}.evt_bcdl_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_bcdl_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_bcdl_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bcdl_tran_dtl is '银企直联转账交易明细';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.corp_work_dt is '企业工作日期';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.corp_flow_num is '企业流水号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.corp_work_dt_batch is '企业工作日期(批次)';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.corp_flow_num_batch is '企业流水号(批次)';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.work_dt_batch is '工作日期(批次)';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.flow_num_batch is '流水号(批次)';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.tran_step_cd is '交易步骤代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.acct_dt is '账务日期';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.check_entry_status_cd is '对账核对状态代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.chn_flow_num is '渠道流水号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.init_sys_idf_id is '原系统标识编号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.org_id is '机构编号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.pay_acct is '付款账户';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.pay_acct_num_name is '付款账号户名';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.recver_type_cd is '收款人类型代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.recvbl_num is '收款账号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.recvbl_num_acct_name is '收款账号户名';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.comm_fee is '手续费';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.memo_cd is '摘要代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.postsc is '附言';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.dtl_status_cd is '明细状态代码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.resp_code is '响应码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.resp_info is '响应信息';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.sync_rest_dt is '同步结果日期';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.sync_rest_cnt is '同步结果次数';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.sorc_sys_tran_timestamp is '源系统交易时间戳';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.output_ip_addr is '输出IP地址';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.output_mac_val is '输出MAC值';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bcdl_tran_dtl.etl_timestamp is 'ETL处理时间戳';
