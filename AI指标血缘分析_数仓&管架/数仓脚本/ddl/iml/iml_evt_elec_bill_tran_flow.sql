/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_elec_bill_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_elec_bill_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_elec_bill_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_elec_bill_tran_flow(
    evt_id varchar2(60) -- 事件编号
    ,bill_id varchar2(60) -- 票据编号
    ,lp_id varchar2(60) -- 法人编号
    ,info_type_cd varchar2(10) -- 信息类型代码
    ,bill_num varchar2(60) -- 票据号码
    ,reqer_cate_cd varchar2(30) -- 请求方类别代码
    ,reqer_name varchar2(750) -- 请求方名称
    ,reqer_orgnz_cd varchar2(30) -- 请求方组织机构代码
    ,reqer_acct_num varchar2(60) -- 请求方账号
    ,reqer_open_bank_no varchar2(60) -- 请求方开户行行号
    ,recver_name varchar2(750) -- 接收方名称
    ,recver_orgnz_cd varchar2(30) -- 接收方组织机构代码
    ,recver_acct_num varchar2(60) -- 接收方账号
    ,recver_open_bank_no varchar2(60) -- 接收方开户行行号
    ,recv_dt date -- 签收日期
    ,onl_clear_cd varchar2(10) -- 线上清算代码
    ,not_ngbl_cd varchar2(10) -- 不得转让代码
    ,int_rat number(18,8) -- 利率
    ,redem_int_rat number(18,8) -- 赎回利率
    ,tran_amt number(30,2) -- 交易金额
    ,redem_actl_amt number(30,2) -- 赎回实付金额
    ,discnt_kind_cd varchar2(10) -- 贴现种类代码
    ,appl_dt date -- 申请日期
    ,sugst_pay_amt number(30,2) -- 提示付款金额
    ,refuse_pay_cd varchar2(10) -- 拒付代码
    ,recs_type_cd varchar2(10) -- 追索类型代码
    ,payoff_dt date -- 清偿日期
    ,lh_buy_tran_id varchar2(60) -- 上手买入交易编号
    ,tran_status_descb varchar2(375) -- 交易状态描述
    ,bill_status_cd varchar2(30) -- 票据状态代码
    ,tran_id varchar2(60) -- 交易编号
    ,h_data_flg varchar2(100) -- 历史数据标志
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
grant select on ${iml_schema}.evt_elec_bill_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_elec_bill_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_elec_bill_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_elec_bill_tran_flow is '电子票据交易流水事件';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.bill_id is '票据编号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.info_type_cd is '信息类型代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.bill_num is '票据号码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.reqer_cate_cd is '请求方类别代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.reqer_name is '请求方名称';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.reqer_orgnz_cd is '请求方组织机构代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.reqer_acct_num is '请求方账号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.reqer_open_bank_no is '请求方开户行行号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.recver_name is '接收方名称';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.recver_orgnz_cd is '接收方组织机构代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.recver_acct_num is '接收方账号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.recver_open_bank_no is '接收方开户行行号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.recv_dt is '签收日期';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.onl_clear_cd is '线上清算代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.not_ngbl_cd is '不得转让代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.int_rat is '利率';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.redem_int_rat is '赎回利率';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.redem_actl_amt is '赎回实付金额';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.discnt_kind_cd is '贴现种类代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.sugst_pay_amt is '提示付款金额';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.refuse_pay_cd is '拒付代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.recs_type_cd is '追索类型代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.payoff_dt is '清偿日期';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.lh_buy_tran_id is '上手买入交易编号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.tran_status_descb is '交易状态描述';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.bill_status_cd is '票据状态代码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.tran_id is '交易编号';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.h_data_flg is '历史数据标志';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_elec_bill_tran_flow.etl_timestamp is 'ETL处理时间戳';
