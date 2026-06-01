/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_pl_analy_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_pl_analy_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_pl_analy_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_pl_analy_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,pl_analy_type_cd varchar2(30) -- 损益分析类型代码
    ,analy_dt date -- 分析日期
    ,bond_id varchar2(100) -- 债券编号
    ,bond_name varchar2(500) -- 债券名称
    ,bond_type_cd varchar2(30) -- 债券类型代码
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,denom number(30,2) -- 面额
    ,surp_pric number(30,2) -- 剩余本金
    ,avg_cost number(30,2) -- 平均成本
    ,dpa_net_price number(30,2) -- 折溢摊净价
    ,acru_int number(30,2) -- 应计利息
    ,subj_type_cd varchar2(30) -- 科目类型代码
    ,bond_descb varchar2(500) -- 债券描述
    ,curr_cd varchar2(30) -- 币种代码
    ,coret_duran number(30,14) -- 修正久期
    ,pvbp number(30,14) -- DV01
    ,inv_port_id varchar2(100) -- 投组编号
    ,inv_port_name varchar2(500) -- 投组名称
    ,inv_port_thd_cls_name varchar2(500) -- 投组三分类名称
    ,acct_b_id varchar2(100) -- 账薄编号
    ,acct_b_cd varchar2(30) -- 账薄代码
    ,acct_b_name varchar2(500) -- 账薄名称
    ,dept_org_id varchar2(100) -- 部门机构编号
    ,prod_id varchar2(100) -- 产品编号
    ,exp_yld_rat number(30,14) -- 到期收益率
    ,pend_ped varchar2(250) -- 待偿期
    ,int_income number(30,8) -- 利息收入
    ,pda number(30,8) -- 折溢摊
    ,bs_spd number(30,8) -- 买卖价差
    ,float_prft_loss number(30,8) -- 浮动盈亏
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
grant select on ${iml_schema}.evt_pl_analy_flow to ${icl_schema};
grant select on ${iml_schema}.evt_pl_analy_flow to ${idl_schema};
grant select on ${iml_schema}.evt_pl_analy_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_pl_analy_flow is '损益分析流水';
comment on column ${iml_schema}.evt_pl_analy_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_pl_analy_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_pl_analy_flow.pl_analy_type_cd is '损益分析类型代码';
comment on column ${iml_schema}.evt_pl_analy_flow.analy_dt is '分析日期';
comment on column ${iml_schema}.evt_pl_analy_flow.bond_id is '债券编号';
comment on column ${iml_schema}.evt_pl_analy_flow.bond_name is '债券名称';
comment on column ${iml_schema}.evt_pl_analy_flow.bond_type_cd is '债券类型代码';
comment on column ${iml_schema}.evt_pl_analy_flow.value_dt is '起息日期';
comment on column ${iml_schema}.evt_pl_analy_flow.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_pl_analy_flow.denom is '面额';
comment on column ${iml_schema}.evt_pl_analy_flow.surp_pric is '剩余本金';
comment on column ${iml_schema}.evt_pl_analy_flow.avg_cost is '平均成本';
comment on column ${iml_schema}.evt_pl_analy_flow.dpa_net_price is '折溢摊净价';
comment on column ${iml_schema}.evt_pl_analy_flow.acru_int is '应计利息';
comment on column ${iml_schema}.evt_pl_analy_flow.subj_type_cd is '科目类型代码';
comment on column ${iml_schema}.evt_pl_analy_flow.bond_descb is '债券描述';
comment on column ${iml_schema}.evt_pl_analy_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_pl_analy_flow.coret_duran is '修正久期';
comment on column ${iml_schema}.evt_pl_analy_flow.pvbp is 'DV01';
comment on column ${iml_schema}.evt_pl_analy_flow.inv_port_id is '投组编号';
comment on column ${iml_schema}.evt_pl_analy_flow.inv_port_name is '投组名称';
comment on column ${iml_schema}.evt_pl_analy_flow.inv_port_thd_cls_name is '投组三分类名称';
comment on column ${iml_schema}.evt_pl_analy_flow.acct_b_id is '账薄编号';
comment on column ${iml_schema}.evt_pl_analy_flow.acct_b_cd is '账薄代码';
comment on column ${iml_schema}.evt_pl_analy_flow.acct_b_name is '账薄名称';
comment on column ${iml_schema}.evt_pl_analy_flow.dept_org_id is '部门机构编号';
comment on column ${iml_schema}.evt_pl_analy_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_pl_analy_flow.exp_yld_rat is '到期收益率';
comment on column ${iml_schema}.evt_pl_analy_flow.pend_ped is '待偿期';
comment on column ${iml_schema}.evt_pl_analy_flow.int_income is '利息收入';
comment on column ${iml_schema}.evt_pl_analy_flow.pda is '折溢摊';
comment on column ${iml_schema}.evt_pl_analy_flow.bs_spd is '买卖价差';
comment on column ${iml_schema}.evt_pl_analy_flow.float_prft_loss is '浮动盈亏';
comment on column ${iml_schema}.evt_pl_analy_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_pl_analy_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_pl_analy_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_pl_analy_flow.etl_timestamp is 'ETL处理时间戳';
