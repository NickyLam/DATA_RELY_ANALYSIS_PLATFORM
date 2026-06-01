/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_comb_prod_post_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_comb_prod_post_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_comb_prod_post_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_comb_prod_post_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,seller_id varchar2(100) -- 销售商编号
    ,vtual_bank_acct_id varchar2(100) -- 虚拟银行账户编号
    ,dtl_prod_id varchar2(100) -- 明细产品编号
    ,imp_dt date -- 导入日期
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,cust_id varchar2(100) -- 客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,ec_flg_cd varchar2(30) -- 钞汇标志代码
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_acct_id varchar2(100) -- 交易账户编号
    ,ta_cd varchar2(30) -- TA代码
    ,ta_tran_acct_id varchar2(100) -- TA交易账户编号
    ,finc_acct_id varchar2(100) -- 理财账户编号
    ,tot_lot number(30,8) -- 总份额
    ,froz_lot number(30,8) -- 冻结份额
    ,lonterm_froz_lot number(30,8) -- 长期冻结份额
    ,loc_froz_lot number(30,8) -- 本地冻结份额
    ,comb_invest_lot number(30,8) -- 组合投资份额
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,init_divd_way_cd varchar2(30) -- 原分红方式代码
    ,divd_ratio number(18,8) -- 分红比例
    ,yd_tot_lot number(30,8) -- 昨日总份额
    ,tot_amt number(30,2) -- 总金额
    ,pric number(30,2) -- 本金
    ,curr_aval_lmt number(30,2) -- 当前可用额度
    ,prod_mk_val number(30,2) -- 产品市值
    ,acm_inco number(30,2) -- 累计收入
    ,cap number(30,2) -- 在途资金
    ,float_prft_loss number(30,8) -- 浮动盈亏
    ,unpaid_prft number(30,2) -- 未付收益
    ,froz_unpaid_prft number(30,2) -- 冻结的未付收益
    ,td_add_unpaid_prft number(30,2) -- 当天新增未付收益
    ,prft_dt date -- 收益日期
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
grant select on ${iml_schema}.agt_comb_prod_post_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_comb_prod_post_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_comb_prod_post_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_comb_prod_post_info_h is '组合产品持仓信息历史';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.seller_id is '销售商编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.vtual_bank_acct_id is '虚拟银行账户编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.dtl_prod_id is '明细产品编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.imp_dt is '导入日期';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.comb_prod_id is '组合产品编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.ec_flg_cd is '钞汇标志代码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.tran_acct_id is '交易账户编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.tot_lot is '总份额';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.froz_lot is '冻结份额';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.lonterm_froz_lot is '长期冻结份额';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.loc_froz_lot is '本地冻结份额';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.comb_invest_lot is '组合投资份额';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.init_divd_way_cd is '原分红方式代码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.divd_ratio is '分红比例';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.yd_tot_lot is '昨日总份额';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.tot_amt is '总金额';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.pric is '本金';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.curr_aval_lmt is '当前可用额度';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.prod_mk_val is '产品市值';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.acm_inco is '累计收入';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.cap is '在途资金';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.float_prft_loss is '浮动盈亏';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.unpaid_prft is '未付收益';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.froz_unpaid_prft is '冻结的未付收益';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.td_add_unpaid_prft is '当天新增未付收益';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.prft_dt is '收益日期';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_comb_prod_post_info_h.etl_timestamp is 'ETL处理时间戳';
