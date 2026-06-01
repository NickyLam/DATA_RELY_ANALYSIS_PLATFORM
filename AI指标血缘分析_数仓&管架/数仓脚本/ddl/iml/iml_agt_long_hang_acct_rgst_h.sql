/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_long_hang_acct_rgst_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_long_hang_acct_rgst_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_long_hang_acct_rgst_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_long_hang_acct_rgst_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,acct_name varchar2(500) -- 账户名称
    ,bus_tran_dt date -- 业务交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,turn_long_hang_oper_type_cd varchar2(30) -- 转久悬操作类型代码
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,curr_bal number(30,2) -- 当前余额
    ,turn_dormt_acct_dt date -- 转不动户日期
    ,turn_long_hang_dt date -- 转久悬日期
    ,ex_dt date -- 出库日期
    ,int_amt number(30,2) -- 利息金额
    ,acct_pric_int_sum number(30,2) -- 账户本息合计
    ,acct_int_tax number(30,2) -- 账户利息税
    ,addit_remark varchar2(500) -- 附加备注
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.agt_long_hang_acct_rgst_h to ${icl_schema};
grant select on ${iml_schema}.agt_long_hang_acct_rgst_h to ${idl_schema};
grant select on ${iml_schema}.agt_long_hang_acct_rgst_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_long_hang_acct_rgst_h is '久悬户登记历史';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.turn_long_hang_oper_type_cd is '转久悬操作类型代码';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.curr_bal is '当前余额';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.turn_dormt_acct_dt is '转不动户日期';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.turn_long_hang_dt is '转久悬日期';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.ex_dt is '出库日期';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.acct_pric_int_sum is '账户本息合计';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.acct_int_tax is '账户利息税';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.addit_remark is '附加备注';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_long_hang_acct_rgst_h.etl_timestamp is 'ETL处理时间戳';
