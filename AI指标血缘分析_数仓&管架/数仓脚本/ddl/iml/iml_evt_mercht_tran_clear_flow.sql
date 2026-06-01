/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_mercht_tran_clear_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_mercht_tran_clear_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_mercht_tran_clear_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_tran_clear_flow(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,sender_brac_org_id varchar2(100) -- 发送方网点机构编号
    ,send_org_id varchar2(100) -- 发送机构编号
    ,intior_flow_num varchar2(100) -- 发起方流水号
    ,tran_trans_tm varchar2(30) -- 交易传输时间
    ,tran_dt date -- 交易日期
    ,cust_acct_id varchar2(100) -- 客户账户编号
    ,tran_amt number(30,2) -- 交易金额
    ,msg_type_cd varchar2(30) -- 报文类型代码
    ,tran_proc_cd varchar2(30) -- 交易处理代码
    ,mercht_type_cd varchar2(30) -- 商户类型代码
    ,mercht_id varchar2(100) -- 商户编号
    ,tran_serv_point_cond_cd varchar2(30) -- 交易服务点条件代码
    ,auth_reply_code varchar2(150) -- 授权应答编码
    ,belong_clear_org_id varchar2(100) -- 所属清算机构编号
    ,init_intior_flow_num varchar2(100) -- 原发起方流水号
    ,tran_return_cd varchar2(30) -- 交易返回代码
    ,tran_serv_point_input_way_cd varchar2(30) -- 交易服务点输入方式代码
    ,paybl_chn_comm_fee number(30,2) -- 应付渠道手续费
    ,recvbl_chn_comm_fee number(30,2) -- 应收渠道手续费
    ,init_tran_tm varchar2(30) -- 原交易时间
    ,card_iss_org_id varchar2(100) -- 发卡机构编号
    ,termn_type_cd varchar2(30) -- 终端类型代码
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
grant select on ${iml_schema}.evt_mercht_tran_clear_flow to ${icl_schema};
grant select on ${iml_schema}.evt_mercht_tran_clear_flow to ${idl_schema};
grant select on ${iml_schema}.evt_mercht_tran_clear_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_mercht_tran_clear_flow is '商户交易清算流水';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.sender_brac_org_id is '发送方网点机构编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.send_org_id is '发送机构编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.intior_flow_num is '发起方流水号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.tran_trans_tm is '交易传输时间';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.cust_acct_id is '客户账户编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.msg_type_cd is '报文类型代码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.tran_proc_cd is '交易处理代码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.mercht_type_cd is '商户类型代码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.tran_serv_point_cond_cd is '交易服务点条件代码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.auth_reply_code is '授权应答编码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.belong_clear_org_id is '所属清算机构编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.init_intior_flow_num is '原发起方流水号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.tran_return_cd is '交易返回代码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.tran_serv_point_input_way_cd is '交易服务点输入方式代码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.paybl_chn_comm_fee is '应付渠道手续费';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.recvbl_chn_comm_fee is '应收渠道手续费';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.init_tran_tm is '原交易时间';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.card_iss_org_id is '发卡机构编号';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.termn_type_cd is '终端类型代码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_mercht_tran_clear_flow.etl_timestamp is 'ETL处理时间戳';
