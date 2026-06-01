/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lx_out_acct_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lx_out_acct_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lx_out_acct_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_out_acct_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,dubil_id varchar2(100) -- 借据编号
    ,rela_cont_id varchar2(100) -- 关联合同编号
    ,lim_appl_id varchar2(100) -- 用信申请编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,org_id varchar2(100) -- 机构编号
    ,prod_id varchar2(100) -- 产品编号
    ,asset_crdt_id varchar2(100) -- 资方授信编号
    ,asset_type_cd varchar2(30) -- 资产类型代码
    ,distr_dt date -- 放款日期
    ,distr_amt number(30,8) -- 放款金额
    ,curr_cd varchar2(30) -- 币种代码
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,fix_out_acct_day varchar2(10) -- 固定出账日
    ,fix_repay_day varchar2(10) -- 固定还款日
    ,loan_tenor number(10) -- 贷款期限
    ,year_int_rat number(30,2) -- 年利率
    ,loan_usage varchar2(500) -- 贷款用途
    ,mobile_no varchar2(60) -- 手机号码
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_open_bank_num varchar2(100) -- 收款账户开户行号
    ,recvbl_bank_card_num varchar2(100) -- 收款银行卡号
    ,recvbl_bank_card_ibank_no varchar2(100) -- 收款银行卡联行号
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,fin_guar_mode_cd varchar2(10) -- 联合融担标志
    ,apv_status_cd varchar2(60) -- 审批状态代码
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,core_distr_sucs_flg varchar2(60) -- 核心放款成功标志
    ,core_distr_fail_descb varchar2(4000) -- 核心放款失败描述
    ,out_line_tran_acct_sucs_flg varchar2(60) -- 行外转账成功标志
    ,out_line_distr_fail_descb varchar2(4000) -- 行外放款失败描述
    ,core_revs_sucs_flg varchar2(60) -- 核心冲正成功标志
    ,core_revs_fail_descb varchar2(4000) -- 核心冲正失败描述
    ,rgst_dt date -- 登记日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,final_update_dt date -- 最后更新日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
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
grant select on ${iml_schema}.agt_lx_out_acct_appl to ${icl_schema};
grant select on ${iml_schema}.agt_lx_out_acct_appl to ${idl_schema};
grant select on ${iml_schema}.agt_lx_out_acct_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lx_out_acct_appl is '乐信出账申请';
comment on column ${iml_schema}.agt_lx_out_acct_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.rela_cont_id is '关联合同编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.lim_appl_id is '用信申请编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lx_out_acct_appl.org_id is '机构编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.asset_crdt_id is '资方授信编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.agt_lx_out_acct_appl.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_lx_out_acct_appl.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_lx_out_acct_appl.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lx_out_acct_appl.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_lx_out_acct_appl.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_lx_out_acct_appl.fix_out_acct_day is '固定出账日';
comment on column ${iml_schema}.agt_lx_out_acct_appl.fix_repay_day is '固定还款日';
comment on column ${iml_schema}.agt_lx_out_acct_appl.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_lx_out_acct_appl.year_int_rat is '年利率';
comment on column ${iml_schema}.agt_lx_out_acct_appl.loan_usage is '贷款用途';
comment on column ${iml_schema}.agt_lx_out_acct_appl.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_lx_out_acct_appl.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_lx_out_acct_appl.recvbl_acct_open_bank_num is '收款账户开户行号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.recvbl_bank_card_num is '收款银行卡号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.recvbl_bank_card_ibank_no is '收款银行卡联行号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_lx_out_acct_appl.fin_guar_mode_cd is '联合融担标志';
comment on column ${iml_schema}.agt_lx_out_acct_appl.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_lx_out_acct_appl.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.core_distr_sucs_flg is '核心放款成功标志';
comment on column ${iml_schema}.agt_lx_out_acct_appl.core_distr_fail_descb is '核心放款失败描述';
comment on column ${iml_schema}.agt_lx_out_acct_appl.out_line_tran_acct_sucs_flg is '行外转账成功标志';
comment on column ${iml_schema}.agt_lx_out_acct_appl.out_line_distr_fail_descb is '行外放款失败描述';
comment on column ${iml_schema}.agt_lx_out_acct_appl.core_revs_sucs_flg is '核心冲正成功标志';
comment on column ${iml_schema}.agt_lx_out_acct_appl.core_revs_fail_descb is '核心冲正失败描述';
comment on column ${iml_schema}.agt_lx_out_acct_appl.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lx_out_acct_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lx_out_acct_appl.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lx_out_acct_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lx_out_acct_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lx_out_acct_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lx_out_acct_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lx_out_acct_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lx_out_acct_appl.etl_timestamp is 'ETL处理时间戳';
