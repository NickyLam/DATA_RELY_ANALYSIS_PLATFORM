/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_agree_dep_agt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_agree_dep_agt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_agree_dep_agt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_agree_dep_agt_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dep_agt_id varchar2(250) -- 存款协议编号
    ,sign_seq_num varchar2(60) -- 签约序号
    ,prod_id varchar2(100) -- 产品编号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,sign_agt_status_cd varchar2(30) -- 签约协议状态代码
    ,acct_id varchar2(100) -- 账户编号
    ,acct_prod_id varchar2(100) -- 账户产品编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,dep_tenor number(10) -- 存款期限
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,int_rat_apv_form_num varchar2(60) -- 利率审批单号
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio varchar2(30) -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point varchar2(30) -- 分户级利率浮动点数
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,file_amt number(30,2) -- 靠档金额
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,last_effect_dt date -- 上一生效日期
    ,last_invalid_dt date -- 上一失效日期
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
grant select on ${iml_schema}.agt_agree_dep_agt_h to ${icl_schema};
grant select on ${iml_schema}.agt_agree_dep_agt_h to ${idl_schema};
grant select on ${iml_schema}.agt_agree_dep_agt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_agree_dep_agt_h is '协定存款协议历史';
comment on column ${iml_schema}.agt_agree_dep_agt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.dep_agt_id is '存款协议编号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.sign_seq_num is '签约序号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_agree_dep_agt_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_agree_dep_agt_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.sign_agt_status_cd is '签约协议状态代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.acct_prod_id is '账户产品编号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.dep_tenor is '存款期限';
comment on column ${iml_schema}.agt_agree_dep_agt_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.int_rat_apv_form_num is '利率审批单号';
comment on column ${iml_schema}.agt_agree_dep_agt_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_agree_dep_agt_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_agree_dep_agt_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_agree_dep_agt_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_agree_dep_agt_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_agree_dep_agt_h.file_amt is '靠档金额';
comment on column ${iml_schema}.agt_agree_dep_agt_h.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.last_effect_dt is '上一生效日期';
comment on column ${iml_schema}.agt_agree_dep_agt_h.last_invalid_dt is '上一失效日期';
comment on column ${iml_schema}.agt_agree_dep_agt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_agree_dep_agt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_agree_dep_agt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_agree_dep_agt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_agree_dep_agt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_agree_dep_agt_h.etl_timestamp is 'ETL处理时间戳';
