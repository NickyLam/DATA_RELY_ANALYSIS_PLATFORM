/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_repay_plan
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_repay_plan(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,perds number(10) -- 期数
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,exp_dt date -- 到期日期
    ,value_dt date -- 起息日期
    ,currt_rpbl_pric number(30,8) -- 当期应还本金
    ,currt_paid_pric number(30,8) -- 当期实还本金
    ,currt_rpbl_tot_int number(30,8) -- 当期应还总利息
    ,currt_paid_int number(30,8) -- 当期实还利息
    ,currt_aldy_payoff_flg varchar2(10) -- 当期已结清标志
    ,currt_payoff_dt date -- 当期结清日期
    ,ovdue_amt number(30,8) -- 逾期金额
    ,defer_dt date -- 顺延日期
    ,rpbl_int number(30,8) -- 应还利息
    ,rpbl_pric_pnlt number(30,8) -- 应还本金罚息
    ,rpbl_int_pnlt number(30,8) -- 应还利息罚息
    ,paid_int number(30,8) -- 实还利息
    ,paid_pric_pnlt number(30,8) -- 实还本金罚息
    ,paid_int_pnlt number(30,8) -- 实还利息罚息
    ,pric_status_cd varchar2(30) -- 本金状态代码
    ,derate_int number(30,8) -- 减免利息
    ,derate_pnlt number(30,8) -- 减免罚息
    ,pric_turn_ovdue_dt date -- 本金转逾期日期
    ,int_turn_ovdue_dt date -- 利息转逾期日期
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
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
grant select on ${iml_schema}.agt_wyd_repay_plan to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_repay_plan to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_repay_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_repay_plan is '微业贷还款计划';
comment on column ${iml_schema}.agt_wyd_repay_plan.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.perds is '期数';
comment on column ${iml_schema}.agt_wyd_repay_plan.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_repay_plan.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.value_dt is '起息日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.currt_rpbl_pric is '当期应还本金';
comment on column ${iml_schema}.agt_wyd_repay_plan.currt_paid_pric is '当期实还本金';
comment on column ${iml_schema}.agt_wyd_repay_plan.currt_rpbl_tot_int is '当期应还总利息';
comment on column ${iml_schema}.agt_wyd_repay_plan.currt_paid_int is '当期实还利息';
comment on column ${iml_schema}.agt_wyd_repay_plan.currt_aldy_payoff_flg is '当期已结清标志';
comment on column ${iml_schema}.agt_wyd_repay_plan.currt_payoff_dt is '当期结清日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.ovdue_amt is '逾期金额';
comment on column ${iml_schema}.agt_wyd_repay_plan.defer_dt is '顺延日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_wyd_repay_plan.rpbl_pric_pnlt is '应还本金罚息';
comment on column ${iml_schema}.agt_wyd_repay_plan.rpbl_int_pnlt is '应还利息罚息';
comment on column ${iml_schema}.agt_wyd_repay_plan.paid_int is '实还利息';
comment on column ${iml_schema}.agt_wyd_repay_plan.paid_pric_pnlt is '实还本金罚息';
comment on column ${iml_schema}.agt_wyd_repay_plan.paid_int_pnlt is '实还利息罚息';
comment on column ${iml_schema}.agt_wyd_repay_plan.pric_status_cd is '本金状态代码';
comment on column ${iml_schema}.agt_wyd_repay_plan.derate_int is '减免利息';
comment on column ${iml_schema}.agt_wyd_repay_plan.derate_pnlt is '减免罚息';
comment on column ${iml_schema}.agt_wyd_repay_plan.pric_turn_ovdue_dt is '本金转逾期日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.int_turn_ovdue_dt is '利息转逾期日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.pric_ovdue_days is '本金逾期天数';
comment on column ${iml_schema}.agt_wyd_repay_plan.int_ovdue_days is '利息逾期天数';
comment on column ${iml_schema}.agt_wyd_repay_plan.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_repay_plan.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_repay_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_repay_plan.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_repay_plan.etl_timestamp is 'ETL处理时间戳';
