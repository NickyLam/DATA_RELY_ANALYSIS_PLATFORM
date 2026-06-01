/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_telbank_cap_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_telbank_cap_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_telbank_cap_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_telbank_cap_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,call_flow_num varchar2(100) -- 呼叫流水号
    ,in_call_num varchar2(60) -- 呼入电话号码
    ,aud_sys_cd varchar2(30) -- 语音系统代码
    ,tran_cd varchar2(100) -- 交易代码
    ,tran_tm timestamp -- 交易时间
    ,return_code varchar2(100) -- 返回码
    ,return_info varchar2(2000) -- 返回信息
    ,cust_name varchar2(200) -- 客户名称
    ,pay_acct_id varchar2(60) -- 付款账户编号
    ,pay_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_name varchar2(500) -- 付款行名称
    ,recvbl_acct_id varchar2(60) -- 收款账户编号
    ,recvbl_acct_name varchar2(100) -- 收款账户名称
    ,recv_bank_no varchar2(60) -- 收款行行号
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,avl_aging_cd varchar2(30) -- 到账时效代码
    ,tran_amt number(30,8) -- 交易金额
    ,comm_fee number(30,8) -- 手续费
    ,curr_cd varchar2(60) -- 币种代码
    ,chn_cd varchar2(60) -- 渠道代码
    ,dep_term varchar2(60) -- 存期
    ,redt_flg varchar2(60) -- 转存标志
    ,operr_id varchar2(60) -- 操作员编号
    ,sign_org_name varchar2(500) -- 签约机构名称
    ,dep_term_cd varchar2(60) -- 存期代码
    ,sav_type_cd varchar2(60) -- 储种代码
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
grant select on ${iml_schema}.evt_telbank_cap_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_telbank_cap_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_telbank_cap_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_telbank_cap_tran_flow is '电话银行资金交易流水';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.call_flow_num is '呼叫流水号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.in_call_num is '呼入电话号码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.aud_sys_cd is '语音系统代码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.return_info is '返回信息';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.pay_bank_no is '付款行行号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.pay_bank_name is '付款行名称';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.avl_aging_cd is '到账时效代码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.comm_fee is '手续费';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.dep_term is '存期';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.redt_flg is '转存标志';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.operr_id is '操作员编号';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.sign_org_name is '签约机构名称';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.dep_term_cd is '存期代码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.sav_type_cd is '储种代码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_telbank_cap_tran_flow.etl_timestamp is 'ETL处理时间戳';
