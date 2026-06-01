/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_dubil_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_dubil_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_dubil_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_dubil_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,prod_id varchar2(100) -- 产品编号
    ,prod_cls_cd varchar2(30) -- 产品类别代码
    ,curr_cd varchar2(30) -- 币种代码
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,indus_type_cd varchar2(30) -- 行业类型代码
    ,loan_tenor_cate_cd varchar2(30) -- 贷款期限类别代码
    ,loan_tenor number(10) -- 贷款期限
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,loan_status_cd varchar2(30) -- 贷款状态代码
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,distr_status_cd varchar2(30) -- 放款状态代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,cont_id varchar2(100) -- 合同编号
    ,cont_mon_tenor number(10) -- 合同月期限
    ,loan_amt number(30,2) -- 贷款金额
    ,loan_bal number(30,2) -- 贷款余额
    ,loan_int_rat number(30,8) -- 贷款利率
    ,ovdue_int_rat number(30,8) -- 逾期利率
    ,value_dt date -- 起息日期
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_day varchar2(10) -- 还款日
    ,int_set_way_cd varchar2(30) -- 结息方式代码
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(30) -- 利率调整周期代码
    ,int_rat_adj_ped number(10) -- 利率调整周期
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,int_rat_flo_val number(30,8) -- 利率浮动值
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,td_acru_int number(30,8) -- 当日应计利息
    ,recvbl_over_int number(30,8) -- 应收欠息
    ,recvbl_acru_pnlt number(30,8) -- 应收应计罚息
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,repay_num_id varchar2(100) -- 还款账户编号
    ,repay_num_name varchar2(500) -- 还款账户名称
    ,repay_org_id varchar2(100) -- 还款机构编号
    ,repay_org_name varchar2(500) -- 还款机构名称
    ,distr_acct_id varchar2(100) -- 放款账户编号
    ,distr_acct_name varchar2(500) -- 放款账户名称
    ,distr_org_id varchar2(100) -- 放款机构编号
    ,distr_org_name varchar2(500) -- 放款机构名称
    ,appl_delay_repay_sucs_cnt number(10) -- 申请延期还款成功次数
    ,aval_lmt number(30,8) -- 可用额度
    ,clear_tran_id varchar2(100) -- 清算交易编号
    ,fin_org_id varchar2(100) -- 财务机构编号
    ,tax_flg varchar2(10) -- 涉税标志
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_wyd_dubil_h to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_dubil_h to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_dubil_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_dubil_h is '微业贷借据信息历史';
comment on column ${iml_schema}.agt_wyd_dubil_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wyd_dubil_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.prod_cls_cd is '产品类别代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.loan_tenor_cate_cd is '贷款期限类别代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_wyd_dubil_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_wyd_dubil_h.distr_status_cd is '放款状态代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_wyd_dubil_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_wyd_dubil_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wyd_dubil_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.cont_mon_tenor is '合同月期限';
comment on column ${iml_schema}.agt_wyd_dubil_h.loan_amt is '贷款金额';
comment on column ${iml_schema}.agt_wyd_dubil_h.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_wyd_dubil_h.loan_int_rat is '贷款利率';
comment on column ${iml_schema}.agt_wyd_dubil_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_wyd_dubil_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_wyd_dubil_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.repay_day is '还款日';
comment on column ${iml_schema}.agt_wyd_dubil_h.int_set_way_cd is '结息方式代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.int_rat_adj_ped is '利率调整周期';
comment on column ${iml_schema}.agt_wyd_dubil_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.int_rat_flo_val is '利率浮动值';
comment on column ${iml_schema}.agt_wyd_dubil_h.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_wyd_dubil_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_wyd_dubil_h.td_acru_int is '当日应计利息';
comment on column ${iml_schema}.agt_wyd_dubil_h.recvbl_over_int is '应收欠息';
comment on column ${iml_schema}.agt_wyd_dubil_h.recvbl_acru_pnlt is '应收应计罚息';
comment on column ${iml_schema}.agt_wyd_dubil_h.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_wyd_dubil_h.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.repay_num_name is '还款账户名称';
comment on column ${iml_schema}.agt_wyd_dubil_h.repay_org_id is '还款机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.repay_org_name is '还款机构名称';
comment on column ${iml_schema}.agt_wyd_dubil_h.distr_acct_id is '放款账户编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.distr_acct_name is '放款账户名称';
comment on column ${iml_schema}.agt_wyd_dubil_h.distr_org_id is '放款机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.distr_org_name is '放款机构名称';
comment on column ${iml_schema}.agt_wyd_dubil_h.appl_delay_repay_sucs_cnt is '申请延期还款成功次数';
comment on column ${iml_schema}.agt_wyd_dubil_h.aval_lmt is '可用额度';
comment on column ${iml_schema}.agt_wyd_dubil_h.clear_tran_id is '清算交易编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.fin_org_id is '财务机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.tax_flg is '涉税标志';
comment on column ${iml_schema}.agt_wyd_dubil_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_dubil_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_dubil_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_dubil_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_dubil_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_dubil_h.etl_timestamp is 'ETL处理时间戳';
