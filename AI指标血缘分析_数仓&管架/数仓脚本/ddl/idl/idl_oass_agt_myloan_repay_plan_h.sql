/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_myloan_repay_plan_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_myloan_repay_plan_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_myloan_repay_plan_h(
etl_dt date --数据日期
,dubil_id varchar2(100) --借据编号
,pd_num varchar2(60) --期次号
,rpbl_int number(30,2) --应还利息
,rpbl_pric number(30,2) --应还本金
,inst_start_dt date --分期开始日期
,inst_end_dt date --分期结束日期
,inst_status_cd varchar2(10) --分期状态代码
,payoff_dt date --结清日期
,pric_turn_ovdue_dt date --本金转逾期日期
,int_turn_ovdue_dt date --利息转逾期日期
,pric_ovdue_days number(10,0) --本金逾期天数
,int_ovdue_days number(10,0) --利息逾期天数
,pric_bal number(30,2) --本金余额
,int_bal number(30,2) --利息余额
,rpbl_ovdue_pric_pnlt number(30,2) --应还逾期本金罚息
,rpbl_ovdue_int_pnlt number(30,2) --应还逾期利息罚息
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(100) --协议编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_myloan_repay_plan_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_myloan_repay_plan_h is '网商贷还款计划历史';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.dubil_id is '借据编号';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.pd_num is '期次号';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.rpbl_int is '应还利息';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.rpbl_pric is '应还本金';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.inst_start_dt is '分期开始日期';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.inst_end_dt is '分期结束日期';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.inst_status_cd is '分期状态代码';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.payoff_dt is '结清日期';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.pric_turn_ovdue_dt is '本金转逾期日期';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.int_turn_ovdue_dt is '利息转逾期日期';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.pric_ovdue_days is '本金逾期天数';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.int_ovdue_days is '利息逾期天数';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.pric_bal is '本金余额';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.int_bal is '利息余额';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.rpbl_ovdue_pric_pnlt is '应还逾期本金罚息';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.rpbl_ovdue_int_pnlt is '应还逾期利息罚息';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_myloan_repay_plan_h.lp_id is '法人编号';

