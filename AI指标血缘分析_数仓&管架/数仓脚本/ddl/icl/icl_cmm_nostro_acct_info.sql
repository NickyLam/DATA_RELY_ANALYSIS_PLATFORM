/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_nostro_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_nostro_acct_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_nostro_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_nostro_acct_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_sub_acct_id varchar2(60) -- 账户子账号
    ,ibank_obj_id varchar2(60) -- 同业对象编号
    ,asset_uniq_idf_id varchar2(100) -- 资产唯一标识编号
    ,cust_id varchar2(60) -- 客户编号
    ,subj_id varchar2(60) -- 科目编号
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,int_recvbl_subj_id varchar2(60) -- 应收利息科目编号
    ,int_income_subj_id varchar2(60) -- 利息收入科目编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(100) -- 账户名称
    ,open_bank_name varchar2(500) -- 开户行名称
    ,open_bank_lp_org_cust_id varchar2(60) -- 开户行法人机构客户编号
    ,open_bank_lp_name varchar2(100) -- 开户行法人名称
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,open_dt date -- 开户日期
    ,open_flow_num varchar2(100) -- 开户流水号
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_flow_num varchar2(100) -- 销户流水号
    ,acct_cls_cd varchar2(60) -- 账户分类代码
    ,acct_char_cd varchar2(10) -- 账户性质代码
    ,acct_char_descb varchar2(500) -- 账户性质描述
    ,acct_attr_descb varchar2(500) -- 账户属性描述
    ,obank_open_org_dist varchar2(250) -- 他行开户机构行政区划
    ,obank_nation varchar2(250) -- 他行国籍
    ,obank_cntpty_cls varchar2(250) -- 他行交易对手分类
    ,obank_open_org_lp_name varchar2(375) -- 他行开户机构法人名称
    ,obank_open_org_id varchar2(60) -- 他行开户机构编号
    ,obank_bank_no varchar2(250) -- 他行银行行号
    ,obank_swift_id varchar2(250) -- 他行SWIFT编号
    ,obank_acct_id varchar2(250) -- 他行账户编号
    ,obank_acct_name varchar2(250) -- 他行账户名称
    ,obank_curr_bal number(31,8) -- 他行当前余额
    ,obank_open_dt date -- 他行开户日期
    ,obank_clos_acct_dt date -- 他行销户日期
    ,int_start_dt date -- 计息开始日期
    ,int_end_dt date -- 计息结束日期
    ,exp_dt date -- 到期日期
    ,onl_bus_flg varchar2(10) -- 线上业务标志
    ,acct_status_cd varchar2(60) -- 账户状态代码
    ,use_range_cd varchar2(10) -- 使用范围代码
    ,acct_usage_cd varchar2(30) -- 账户用途代码
    ,curr_cd varchar2(60) -- 币种代码
    ,base_rat number(18,8) -- 基准利率
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,int_accr_base_cd varchar2(60) -- 计息基准代码
    ,cap_char_cd varchar2(10) -- 资金性质代码
    ,pay_int_freq varchar2(10) -- 付息频率
    ,int_rat_flo_val number(18,8) -- 利率浮动值
    ,exec_int_rat number(18,8) -- 执行利率
    ,int_recvbl number(31,8) -- 应收利息
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,td_acru_int number(30,2) -- 当日应计利息
    ,td_int_income number(30,8) -- 当日利息收入
    ,currt_bal number(30,2) -- 当期余额
    ,cl_curr_currt_bal number(30,2) -- 折本币当期余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_nostro_acct_info to ${idl_schema};
grant select on ${icl_schema}.cmm_nostro_acct_info to ${iel_schema};
grant select on ${icl_schema}.cmm_nostro_acct_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_nostro_acct_info is '存放同业账户信息';
comment on column ${icl_schema}.cmm_nostro_acct_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.cust_sub_acct_id is '账户子账号';
comment on column ${icl_schema}.cmm_nostro_acct_info.ibank_obj_id is '同业对象编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.asset_uniq_idf_id is '资产唯一标识编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_recvbl_subj_id is '应收利息科目编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_income_subj_id is '利息收入科目编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_nostro_acct_info.open_bank_name is '开户行名称';
comment on column ${icl_schema}.cmm_nostro_acct_info.open_bank_lp_org_cust_id is '开户行法人机构客户编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.open_bank_lp_name is '开户行法人名称';
comment on column ${icl_schema}.cmm_nostro_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.open_dt is '开户日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.open_flow_num is '开户流水号';
comment on column ${icl_schema}.cmm_nostro_acct_info.clos_acct_dt is '销户日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.clos_acct_flow_num is '销户流水号';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_cls_cd is '账户分类代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_char_cd is '账户性质代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_char_descb is '账户性质描述';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_attr_descb is '账户属性描述';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_open_org_dist is '他行开户机构行政区划';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_nation is '他行国籍';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_cntpty_cls is '他行交易对手分类';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_open_org_lp_name is '他行开户机构法人名称';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_open_org_id is '他行开户机构编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_bank_no is '他行银行行号';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_swift_id is '他行SWIFT编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_acct_id is '他行账户编号';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_acct_name is '他行账户名称';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_curr_bal is '他行当前余额';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_open_dt is '他行开户日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.obank_clos_acct_dt is '他行销户日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_start_dt is '计息开始日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_end_dt is '计息结束日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_nostro_acct_info.onl_bus_flg is '线上业务标志';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.use_range_cd is '使用范围代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.acct_usage_cd is '账户用途代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.cap_char_cd is '资金性质代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.pay_int_freq is '付息频率';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_rat_flo_val is '利率浮动值';
comment on column ${icl_schema}.cmm_nostro_acct_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_nostro_acct_info.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_nostro_acct_info.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_nostro_acct_info.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_nostro_acct_info.td_int_income is '当日利息收入';
comment on column ${icl_schema}.cmm_nostro_acct_info.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_nostro_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${icl_schema}.cmm_nostro_acct_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_nostro_acct_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_nostro_acct_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_nostro_acct_info.etl_timestamp is 'ETL处理时间戳';
