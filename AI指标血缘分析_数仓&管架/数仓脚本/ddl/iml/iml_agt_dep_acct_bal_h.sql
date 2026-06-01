/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_bal_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,curr_bal number(30,2) -- 当前余额
    ,ld_bal number(30,2) -- 上日余额
    ,acct_inpwn_amt number(30,2) -- 账户质押金额
    ,finc_rgst_b_acct_amt number(30,2) -- 理财登记薄账户金额
    ,long_hang_amt number(30,2) -- 久悬金额
    ,acct_od_amt number(30,2) -- 账户透支金额
    ,od_tot_amt number(30,2) -- 透支总金额
    ,last_activ_acct_dt date -- 上一动户日期
    ,cust_id varchar2(100) -- 客户编号
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,up_ld_tot_bal number(30,2) -- 上上日汇总余额
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
grant select on ${iml_schema}.agt_dep_acct_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_bal_h is '存款账户余额历史';
comment on column ${iml_schema}.agt_dep_acct_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_bal_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_bal_h.curr_bal is '当前余额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.ld_bal is '上日余额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.acct_inpwn_amt is '账户质押金额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.finc_rgst_b_acct_amt is '理财登记薄账户金额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.long_hang_amt is '久悬金额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.acct_od_amt is '账户透支金额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.od_tot_amt is '透支总金额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.last_activ_acct_dt is '上一动户日期';
comment on column ${iml_schema}.agt_dep_acct_bal_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_bal_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dep_acct_bal_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_dep_acct_bal_h.up_ld_tot_bal is '上上日汇总余额';
comment on column ${iml_schema}.agt_dep_acct_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_bal_h.etl_timestamp is 'ETL处理时间戳';
