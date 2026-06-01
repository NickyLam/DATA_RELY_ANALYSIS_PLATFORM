/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lx_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lx_repay_plan
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lx_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_repay_plan(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,src_appl_flow_num varchar2(100) -- 源申请流水号
    ,dubil_id varchar2(100) -- 借据编号
    ,curr_perds varchar2(60) -- 当前期数
    ,pd_status_cd varchar2(30) -- 期次状态代码
    ,tot_perds number(10) -- 总期数
    ,prod_id varchar2(100) -- 产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,distr_dt date -- 放款日期
    ,value_dt date -- 起息日期
    ,repay_dt date -- 还款日期
    ,payoff_dt date -- 结清日期
    ,grace_period number(10) -- 宽限期
    ,rpbl_pric number(30,8) -- 应还本金
    ,rpbl_int number(30,8) -- 应还利息
    ,pric_bal number(30,2) -- 本金余额
    ,int_bal number(30,2) -- 利息余额
    ,guar_fee number(30,8) -- 担保费
    ,consul_serv_fee number(30,8) -- 咨询服务费
    ,crdt_estim_fee number(30,8) -- 信用评估费
    ,provi_int number(30,8) -- 计提利息
    ,remark varchar2(500) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_lx_repay_plan to ${icl_schema};
grant select on ${iml_schema}.agt_lx_repay_plan to ${idl_schema};
grant select on ${iml_schema}.agt_lx_repay_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lx_repay_plan is '乐信还款计划';
comment on column ${iml_schema}.agt_lx_repay_plan.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lx_repay_plan.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lx_repay_plan.src_appl_flow_num is '源申请流水号';
comment on column ${iml_schema}.agt_lx_repay_plan.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_lx_repay_plan.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_lx_repay_plan.pd_status_cd is '期次状态代码';
comment on column ${iml_schema}.agt_lx_repay_plan.tot_perds is '总期数';
comment on column ${iml_schema}.agt_lx_repay_plan.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lx_repay_plan.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lx_repay_plan.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lx_repay_plan.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_lx_repay_plan.value_dt is '起息日期';
comment on column ${iml_schema}.agt_lx_repay_plan.repay_dt is '还款日期';
comment on column ${iml_schema}.agt_lx_repay_plan.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_lx_repay_plan.grace_period is '宽限期';
comment on column ${iml_schema}.agt_lx_repay_plan.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_lx_repay_plan.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_lx_repay_plan.pric_bal is '本金余额';
comment on column ${iml_schema}.agt_lx_repay_plan.int_bal is '利息余额';
comment on column ${iml_schema}.agt_lx_repay_plan.guar_fee is '担保费';
comment on column ${iml_schema}.agt_lx_repay_plan.consul_serv_fee is '咨询服务费';
comment on column ${iml_schema}.agt_lx_repay_plan.crdt_estim_fee is '信用评估费';
comment on column ${iml_schema}.agt_lx_repay_plan.provi_int is '计提利息';
comment on column ${iml_schema}.agt_lx_repay_plan.remark is '备注';
comment on column ${iml_schema}.agt_lx_repay_plan.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lx_repay_plan.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lx_repay_plan.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lx_repay_plan.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lx_repay_plan.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lx_repay_plan.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lx_repay_plan.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lx_repay_plan.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lx_repay_plan.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lx_repay_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lx_repay_plan.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lx_repay_plan.etl_timestamp is 'ETL处理时间戳';
