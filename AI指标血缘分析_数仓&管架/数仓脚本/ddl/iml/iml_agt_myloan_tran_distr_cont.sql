/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_myloan_tran_distr_cont
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_myloan_tran_distr_cont
whenever sqlerror continue none;
drop table ${iml_schema}.agt_myloan_tran_distr_cont purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_tran_distr_cont(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,distr_cap_flow_num varchar2(100) -- 放款资金流水号
    ,prod_code varchar2(100) -- 产品码
    ,brwer_name varchar2(250) -- 借款人名称
    ,brwer_cert_type_cd varchar2(10) -- 借款人证件类型代码
    ,brwer_cert_no varchar2(100) -- 借款人证件号码
    ,loan_status_cd varchar2(10) -- 贷款状态代码
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,loan_cap_dom_overs_flg varchar2(10) -- 贷款资金境内外标志
    ,appl_disb_tm timestamp -- 申请支用时间
    ,distr_dt date -- 放款日期
    ,curr_cd varchar2(10) -- 币种代码
    ,distr_amt number(30,2) -- 放款金额
    ,loan_value_dt date -- 贷款起息日期
    ,loan_exp_dt date -- 贷款到期日期
    ,loan_tenor varchar2(60) -- 贷款期限
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,grace_period_days number(10) -- 宽限期天数
    ,int_rat_type_cd varchar2(10) -- 利率类型代码
    ,loan_day_int_rat number(18,8) -- 贷款日利率
    ,pric_repay_ped_type_cd varchar2(10) -- 本金还款周期类型代码
    ,int_repay_ped_type_cd varchar2(10) -- 利息还款周期类型代码
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,crdt_id varchar2(100) -- 授信编号
    ,recvbl_num_type_cd varchar2(100) -- 收款账号类型代码
    ,recvbl_house_hold_name varchar2(250) -- 收款账号户主名称
    ,recvbl_num varchar2(100) -- 收款账号
    ,recvbl_bank_name varchar2(250) -- 收款银行名称
    ,repay_num_type_cd varchar2(100) -- 还款账号类型代码
    ,repay_house_hold_name varchar2(250) -- 还款账号户主名称
    ,repay_num varchar2(100) -- 还款账号
    ,repay_bank_name varchar2(250) -- 还款银行名称
    ,user_id varchar2(100) -- 用户编号
    ,dist_cd varchar2(10) -- 行政区划代码
    ,loan_year_int_rat number(18,8) -- 贷款年利率
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_myloan_tran_distr_cont to ${icl_schema};
grant select on ${iml_schema}.agt_myloan_tran_distr_cont to ${idl_schema};
grant select on ${iml_schema}.agt_myloan_tran_distr_cont to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_myloan_tran_distr_cont is '网商贷资产转入放款合约';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.agt_id is '协议编号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.lp_id is '法人编号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.cont_id is '合同编号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.distr_cap_flow_num is '放款资金流水号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.prod_code is '产品码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.brwer_name is '借款人名称';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.brwer_cert_type_cd is '借款人证件类型代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.brwer_cert_no is '借款人证件号码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_cap_dom_overs_flg is '贷款资金境内外标志';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.appl_disb_tm is '申请支用时间';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_value_dt is '贷款起息日期';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.grace_period_days is '宽限期天数';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_day_int_rat is '贷款日利率';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.pric_repay_ped_type_cd is '本金还款周期类型代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.int_repay_ped_type_cd is '利息还款周期类型代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.crdt_id is '授信编号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.recvbl_num_type_cd is '收款账号类型代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.recvbl_house_hold_name is '收款账号户主名称';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.recvbl_num is '收款账号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.recvbl_bank_name is '收款银行名称';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.repay_num_type_cd is '还款账号类型代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.repay_house_hold_name is '还款账号户主名称';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.repay_num is '还款账号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.repay_bank_name is '还款银行名称';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.user_id is '用户编号';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.dist_cd is '行政区划代码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.loan_year_int_rat is '贷款年利率';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.create_dt is '创建日期';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.update_dt is '更新日期';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.id_mark is '增删标志';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.job_cd is '任务编码';
comment on column ${iml_schema}.agt_myloan_tran_distr_cont.etl_timestamp is 'ETL处理时间戳';
