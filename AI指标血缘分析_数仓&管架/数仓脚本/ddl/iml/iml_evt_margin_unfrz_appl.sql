/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_margin_unfrz_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_margin_unfrz_appl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_margin_unfrz_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_margin_unfrz_appl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,margin_acct_id varchar2(100) -- 保证金账户编号
    ,margin_acct_attr_cd varchar2(30) -- 保证金账户属性代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,curr_cd varchar2(30) -- 币种代码
    ,margin_acct_bal number(30,8) -- 保证金账户余额
    ,agt_rat number(30,8) -- 协议利率
    ,dep_base_rat number(30,8) -- 存款基准利率
    ,dep_term varchar2(30) -- 存期
    ,tran_out_prod_id varchar2(100) -- 转出产品编号
    ,tran_in_init_acct_flg varchar2(10) -- 转入原账户标志
    ,margin_tran_in_acct_id varchar2(100) -- 保证金转入账户编号
    ,margin_type_cd varchar2(30) -- 保证金类型代码
    ,bill_id varchar2(100) -- 票据编号
    ,bill_exp_dt date -- 票据到期日期
    ,margin_int_rat_level_cd varchar2(30) -- 保证金利率档次代码
    ,margin_exec_int_rat number(30,8) -- 保证金执行利率
    ,margin_int_rat_type_cd varchar2(30) -- 保证金利率类型代码
    ,int_rat_float_way_cd varchar2(30) -- 利率浮动方式代码
    ,int_rat_float_type_cd varchar2(30) -- 利率浮动类型代码
    ,flo_val number(18,8) -- 浮动值
    ,aldy_pay_margin_amt number(30,8) -- 已缴保证金金额
    ,sub_acct_num_froz_flow_num varchar2(100) -- 子账号冻结流水号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,froz_stop_pay_way_cd varchar2(30) -- 冻结止付方式代码
    ,froz_stop_pay_type_cd varchar2(30) -- 冻结止付类型代码
    ,froz_stop_pay_rs varchar2(500) -- 冻结止付原因
    ,off_bs_acct_id varchar2(100) -- 表外账户编号
    ,off_bs_acct_name varchar2(500) -- 表外账户名称
    ,off_bs_entry_dir_cd varchar2(30) -- 表外记账方向代码
    ,off_bs_memo varchar2(500) -- 表外摘要
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,init_agt_type_cd varchar2(30) -- 原协议类型代码
    ,init_agt_id varchar2(100) -- 原协议编号
    ,cont_flow_num varchar2(100) -- 合同流水号
    ,bus_begin_dt date -- 业务起始日期
    ,bus_exp_dt date -- 业务到期日期
    ,bus_amt number(30,8) -- 业务金额
    ,bus_bal number(30,8) -- 业务余额
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,flow_status_cd varchar2(30) -- 流程状态代码
    ,create_src_cd varchar2(30) -- 生成来源代码
    ,curr_brwer_flg varchar2(10) -- 当前借款人标志
    ,rels_open_flg varchar2(10) -- 释放敞口标志
    ,aldy_revo_flg varchar2(10) -- 已撤销标志
    ,batch_flow_num varchar2(100) -- 批次流水号
    ,init_tran_flow_num varchar2(100) -- 原交易流水号
    ,init_tran_dt date -- 原交易日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
    ,supp_comnt varchar2(500) -- 追加说明
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
grant select on ${iml_schema}.evt_margin_unfrz_appl to ${icl_schema};
grant select on ${iml_schema}.evt_margin_unfrz_appl to ${idl_schema};
grant select on ${iml_schema}.evt_margin_unfrz_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_margin_unfrz_appl is '保证金解冻申请';
comment on column ${iml_schema}.evt_margin_unfrz_appl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.cust_name is '客户名称';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_acct_id is '保证金账户编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_acct_attr_cd is '保证金账户属性代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_acct_bal is '保证金账户余额';
comment on column ${iml_schema}.evt_margin_unfrz_appl.agt_rat is '协议利率';
comment on column ${iml_schema}.evt_margin_unfrz_appl.dep_base_rat is '存款基准利率';
comment on column ${iml_schema}.evt_margin_unfrz_appl.dep_term is '存期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.tran_out_prod_id is '转出产品编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.tran_in_init_acct_flg is '转入原账户标志';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_tran_in_acct_id is '保证金转入账户编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_type_cd is '保证金类型代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.bill_id is '票据编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.bill_exp_dt is '票据到期日期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_int_rat_level_cd is '保证金利率档次代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_exec_int_rat is '保证金执行利率';
comment on column ${iml_schema}.evt_margin_unfrz_appl.margin_int_rat_type_cd is '保证金利率类型代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.flo_val is '浮动值';
comment on column ${iml_schema}.evt_margin_unfrz_appl.aldy_pay_margin_amt is '已缴保证金金额';
comment on column ${iml_schema}.evt_margin_unfrz_appl.sub_acct_num_froz_flow_num is '子账号冻结流水号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.froz_stop_pay_way_cd is '冻结止付方式代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.froz_stop_pay_type_cd is '冻结止付类型代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.froz_stop_pay_rs is '冻结止付原因';
comment on column ${iml_schema}.evt_margin_unfrz_appl.off_bs_acct_id is '表外账户编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.off_bs_acct_name is '表外账户名称';
comment on column ${iml_schema}.evt_margin_unfrz_appl.off_bs_entry_dir_cd is '表外记账方向代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.off_bs_memo is '表外摘要';
comment on column ${iml_schema}.evt_margin_unfrz_appl.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.init_agt_type_cd is '原协议类型代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.init_agt_id is '原协议编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.cont_flow_num is '合同流水号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.bus_begin_dt is '业务起始日期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.bus_exp_dt is '业务到期日期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.bus_amt is '业务金额';
comment on column ${iml_schema}.evt_margin_unfrz_appl.bus_bal is '业务余额';
comment on column ${iml_schema}.evt_margin_unfrz_appl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_margin_unfrz_appl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.flow_status_cd is '流程状态代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.create_src_cd is '生成来源代码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.curr_brwer_flg is '当前借款人标志';
comment on column ${iml_schema}.evt_margin_unfrz_appl.rels_open_flg is '释放敞口标志';
comment on column ${iml_schema}.evt_margin_unfrz_appl.aldy_revo_flg is '已撤销标志';
comment on column ${iml_schema}.evt_margin_unfrz_appl.batch_flow_num is '批次流水号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.init_tran_flow_num is '原交易流水号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.init_tran_dt is '原交易日期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.update_org_id is '更新机构编号';
comment on column ${iml_schema}.evt_margin_unfrz_appl.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_margin_unfrz_appl.supp_comnt is '追加说明';
comment on column ${iml_schema}.evt_margin_unfrz_appl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_margin_unfrz_appl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_margin_unfrz_appl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_margin_unfrz_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_margin_unfrz_appl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_margin_unfrz_appl.etl_timestamp is 'ETL处理时间戳';
