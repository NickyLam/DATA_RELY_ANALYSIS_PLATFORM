/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_payfan_tran_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_payfan_tran_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_payfan_tran_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payfan_tran_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,trdpty_indent_id varchar2(100) -- 第三方订单编号
    ,mercht_id varchar2(100) -- 商户编号
    ,mercht_name varchar2(750) -- 商户名称
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_dt date -- 交易日期
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_acct_name varchar2(750) -- 付款账户名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_num_name varchar2(750) -- 收款账号名称
    ,indent_amt number(30,2) -- 订单金额
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,postsc varchar2(750) -- 附言
    ,resp_code varchar2(150) -- 响应码
    ,resp_info varchar2(750) -- 响应信息
    ,create_tm timestamp -- 创建时间
    ,modif_tm timestamp -- 修改时间
    ,bank_bus_flow_num varchar2(100) -- 银行业务流水号
    ,trdpty_batch_flow_num varchar2(100) -- 第三方批次流水号
    ,bank_batch_flow_num varchar2(100) -- 银行批次流水号
    ,pay_flow_num varchar2(100) -- 支付流水号
    ,core_flow_num varchar2(100) -- 核心流水号
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
grant select on ${iml_schema}.agt_payfan_tran_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_payfan_tran_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_payfan_tran_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_payfan_tran_info_h is '代付交易信息历史';
comment on column ${iml_schema}.agt_payfan_tran_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.trdpty_indent_id is '第三方订单编号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.mercht_name is '商户名称';
comment on column ${iml_schema}.agt_payfan_tran_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_payfan_tran_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_payfan_tran_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_payfan_tran_info_h.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.agt_payfan_tran_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.recvbl_num_name is '收款账号名称';
comment on column ${iml_schema}.agt_payfan_tran_info_h.indent_amt is '订单金额';
comment on column ${iml_schema}.agt_payfan_tran_info_h.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.agt_payfan_tran_info_h.postsc is '附言';
comment on column ${iml_schema}.agt_payfan_tran_info_h.resp_code is '响应码';
comment on column ${iml_schema}.agt_payfan_tran_info_h.resp_info is '响应信息';
comment on column ${iml_schema}.agt_payfan_tran_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.agt_payfan_tran_info_h.modif_tm is '修改时间';
comment on column ${iml_schema}.agt_payfan_tran_info_h.bank_bus_flow_num is '银行业务流水号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.trdpty_batch_flow_num is '第三方批次流水号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.bank_batch_flow_num is '银行批次流水号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.pay_flow_num is '支付流水号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.core_flow_num is '核心流水号';
comment on column ${iml_schema}.agt_payfan_tran_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_payfan_tran_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_payfan_tran_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_payfan_tran_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_payfan_tran_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_payfan_tran_info_h.etl_timestamp is 'ETL处理时间戳';
