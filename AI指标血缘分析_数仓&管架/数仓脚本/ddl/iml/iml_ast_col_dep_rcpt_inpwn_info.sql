/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_dep_rcpt_inpwn_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_dep_rcpt_inpwn_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_dep_rcpt_inpwn_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_dep_rcpt_inpwn_info(
    col_id varchar2(100) -- 押品编号
    ,lp_id varchar2(100) -- 法人编号
    ,dep_rcpt_type_cd varchar2(30) -- 存单类型代码
    ,dep_rcpt_amt number(30,8) -- 存单金额
    ,dep_rcpt_int_rat number(30,8) -- 存单利率
    ,dep_term number(22) -- 存期
    ,curr_cd varchar2(30) -- 币种代码
    ,subscr_acct_id varchar2(100) -- 认购账户编号
    ,stop_pay_acct_id varchar2(100) -- 止付账户编号
    ,liab_acct_id varchar2(100) -- 负债账户编号
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_name varchar2(500) -- 账户名称
    ,aval_amt number(30,8) -- 账户可用余额
    ,vouch_no varchar2(100) -- 凭证号码
    ,effect_dt date -- 生效日期
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,prod_id varchar2(100) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,cust_id varchar2(100) -- 客户编号
    ,other_comnt varchar2(4000) -- 其他说明
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
grant select on ${iml_schema}.ast_col_dep_rcpt_inpwn_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_dep_rcpt_inpwn_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_dep_rcpt_inpwn_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_dep_rcpt_inpwn_info is '押品存单质押信息';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.col_id is '押品编号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.dep_rcpt_type_cd is '存单类型代码';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.dep_rcpt_amt is '存单金额';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.dep_rcpt_int_rat is '存单利率';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.dep_term is '存期';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.subscr_acct_id is '认购账户编号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.stop_pay_acct_id is '止付账户编号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.liab_acct_id is '负债账户编号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.sub_acct_num is '子账号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.acct_name is '账户名称';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.aval_amt is '账户可用余额';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.vouch_no is '凭证号码';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.effect_dt is '生效日期';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.value_dt is '起息日期';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.exp_dt is '到期日期';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.prod_id is '产品编号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.prod_name is '产品名称';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.cust_id is '客户编号';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_dep_rcpt_inpwn_info.etl_timestamp is 'ETL处理时间戳';
