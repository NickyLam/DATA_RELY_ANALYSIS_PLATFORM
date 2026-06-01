/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ponl_bk_batch_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ponl_bk_batch_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ponl_bk_batch_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ponl_bk_batch_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_id varchar2(100) -- 批次编号
    ,dtl_flow_num varchar2(100) -- 明细流水号
    ,onl_bank_tran_flow_num varchar2(100) -- 网银交易流水号
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_acct_name varchar2(500) -- 付款账户名称
    ,pay_acct_type_cd varchar2(30) -- 付款账户类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,pay_dept_id varchar2(100) -- 付款部门编号
    ,pay_ec_idf_cd varchar2(30) -- 付款钞汇标识代码
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_type_cd varchar2(60) -- 收款账户类型代码
    ,recvbl_cust_type_cd varchar2(30) -- 收款客户类型代码
    ,recv_bank_no varchar2(100) -- 收款行行号
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,recv_bank_prov_cd varchar2(30) -- 收款行省份代码
    ,recv_bank_prov_name varchar2(100) -- 收款行省份名称
    ,recv_bank_city_cd varchar2(30) -- 收款行城市代码
    ,recv_bank_city_name varchar2(100) -- 收款行城市名称
    ,recv_bank_brac_id varchar2(100) -- 收款行网点编号
    ,recv_bank_brac_name varchar2(500) -- 收款行网点名称
    ,recvbl_clear_bk_no varchar2(100) -- 收款清算行行号
    ,recver_mobile_no varchar2(100) -- 收款人手机号码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_fee number(30,2) -- 交易费
    ,postsc varchar2(100) -- 附言
    ,remark varchar2(500) -- 备注
    ,tran_code varchar2(100) -- 交易码
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,save_recver_flg varchar2(30) -- 保存收款人标志
    ,advise_recver_flg varchar2(30) -- 通知收款人标志
    ,dtl_status_cd varchar2(30) -- 明细状态代码
    ,return_code varchar2(2000) -- 返回码
    ,return_info varchar2(2000) -- 返回信息
    ,proc_start_tm timestamp -- 处理开始时间
    ,proc_end_tm timestamp -- 处理结束时间
    ,proc_flow_num varchar2(100) -- 处理流水号
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,core_tran_dt date -- 核心交易日期
    ,tran_out_way_cd varchar2(60) -- 转出方式代码
    ,tran_out_dt date -- 转出日期
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
grant select on ${iml_schema}.evt_ponl_bk_batch_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_ponl_bk_batch_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_ponl_bk_batch_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ponl_bk_batch_tran_dtl is '个人网银批量交易明细';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.batch_id is '批次编号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.dtl_flow_num is '明细流水号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.onl_bank_tran_flow_num is '网银交易流水号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.pay_acct_type_cd is '付款账户类型代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.pay_dept_id is '付款部门编号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.pay_ec_idf_cd is '付款钞汇标识代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recvbl_cust_type_cd is '收款客户类型代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_prov_cd is '收款行省份代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_prov_name is '收款行省份名称';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_city_cd is '收款行城市代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_city_name is '收款行城市名称';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_brac_id is '收款行网点编号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recv_bank_brac_name is '收款行网点名称';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recvbl_clear_bk_no is '收款清算行行号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.recver_mobile_no is '收款人手机号码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.tran_fee is '交易费';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.postsc is '附言';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.remark is '备注';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.tran_code is '交易码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.save_recver_flg is '保存收款人标志';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.advise_recver_flg is '通知收款人标志';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.dtl_status_cd is '明细状态代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.return_code is '返回码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.return_info is '返回信息';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.proc_start_tm is '处理开始时间';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.proc_end_tm is '处理结束时间';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.proc_flow_num is '处理流水号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.tran_out_way_cd is '转出方式代码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.tran_out_dt is '转出日期';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ponl_bk_batch_tran_dtl.etl_timestamp is 'ETL处理时间戳';
