/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_out_acct_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_out_acct_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_out_acct_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_out_acct_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,cont_id varchar2(100) -- 合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,cert_no varchar2(250) -- 证件号码
    ,distr_amt number(30,8) -- 放款金额
    ,distr_dt date -- 放款日期
    ,distr_mode_pay_cd varchar2(60) -- 放款支付方式代码
    ,distr_sucs_flg varchar2(10) -- 放款成功标志
    ,enter_id varchar2(250) -- 入账账户编号
    ,enter_name varchar2(500) -- 入账账户名称
    ,enter_open_bank_name varchar2(500) -- 入账账户开户行名称
    ,stl_acct_num_id varchar2(250) -- 结算账号编号
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,exp_dt date -- 到期日期
    ,tran_dt date -- 交易日期
    ,grace_days number(10) -- 宽限天数
    ,loan_org_id varchar2(250) -- 贷款机构编号
    ,loan_arriv_dt_term date -- 贷款到账日期
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,loan_tenor number(10) -- 贷款期限
    ,main_guar_way_cd varchar2(100) -- 主担保方式代码
    ,int_set_way_cd varchar2(60) -- 结息方式代码
    ,int_set_ped_cd varchar2(30) -- 结息周期代码
    ,ped_corp_cd varchar2(30) -- 周期单位代码
    ,int_rat_mode_cd varchar2(60) -- 利率模式代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(30,8) -- 基准利率
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,float_range number(30,8) -- 浮动点数
    ,exec_int_rat number(30,8) -- 执行利率
    ,ovdue_int_rat number(30,8) -- 逾期利率
    ,ovdue_int_rat_float_way_cd varchar2(60) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val number(30,8) -- 逾期利率浮动值
    ,out_acct_org_id varchar2(100) -- 出账机构编号
    ,clear_tran_id varchar2(250) -- 清算交易编号
    ,happ_dt varchar2(500) -- 发生日期
    ,flow_dt date -- 流程日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
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
grant select on ${iml_schema}.agt_wph_out_acct_appl to ${icl_schema};
grant select on ${iml_schema}.agt_wph_out_acct_appl to ${idl_schema};
grant select on ${iml_schema}.agt_wph_out_acct_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_out_acct_appl is '唯品会出账申请';
comment on column ${iml_schema}.agt_wph_out_acct_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wph_out_acct_appl.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.cert_no is '证件号码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_wph_out_acct_appl.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_wph_out_acct_appl.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.distr_sucs_flg is '放款成功标志';
comment on column ${iml_schema}.agt_wph_out_acct_appl.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.enter_name is '入账账户名称';
comment on column ${iml_schema}.agt_wph_out_acct_appl.enter_open_bank_name is '入账账户开户行名称';
comment on column ${iml_schema}.agt_wph_out_acct_appl.stl_acct_num_id is '结算账号编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wph_out_acct_appl.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_wph_out_acct_appl.grace_days is '宽限天数';
comment on column ${iml_schema}.agt_wph_out_acct_appl.loan_org_id is '贷款机构编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.loan_arriv_dt_term is '贷款到账日期';
comment on column ${iml_schema}.agt_wph_out_acct_appl.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_wph_out_acct_appl.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.int_set_way_cd is '结息方式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.int_set_ped_cd is '结息周期代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.ped_corp_cd is '周期单位代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.base_rat is '基准利率';
comment on column ${iml_schema}.agt_wph_out_acct_appl.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.float_range is '浮动点数';
comment on column ${iml_schema}.agt_wph_out_acct_appl.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_wph_out_acct_appl.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_wph_out_acct_appl.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${iml_schema}.agt_wph_out_acct_appl.out_acct_org_id is '出账机构编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.clear_tran_id is '清算交易编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.happ_dt is '发生日期';
comment on column ${iml_schema}.agt_wph_out_acct_appl.flow_dt is '流程日期';
comment on column ${iml_schema}.agt_wph_out_acct_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wph_out_acct_appl.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wph_out_acct_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_out_acct_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_out_acct_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_out_acct_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_out_acct_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_out_acct_appl.etl_timestamp is 'ETL处理时间戳';
