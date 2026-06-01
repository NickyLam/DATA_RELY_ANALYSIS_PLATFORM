/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ph_soc_appl_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ph_soc_appl_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ph_soc_appl_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ph_soc_appl_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,input_dt date -- 录入日期
    ,tot_soc_amt number(30,2) -- 总理赔金额
    ,ovdue_tot_days number(10) -- 逾期总天数
    ,ovdue_tot_pric number(30,2) -- 逾期总本金
    ,ovdue_int number(30,2) -- 逾期利息
    ,ovdue_pnlt number(30,2) -- 逾期罚息
    ,not_calc_int number(30,2) -- 未计利息
    ,unexp_pric number(30,2) -- 未到期本金
    ,stud_loan_prod_id varchar2(100) -- 助贷产品编号
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
grant select on ${iml_schema}.evt_ph_soc_appl_evt to ${icl_schema};
grant select on ${iml_schema}.evt_ph_soc_appl_evt to ${idl_schema};
grant select on ${iml_schema}.evt_ph_soc_appl_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ph_soc_appl_evt is '平安普惠理赔申请事件';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.input_dt is '录入日期';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.tot_soc_amt is '总理赔金额';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.ovdue_tot_days is '逾期总天数';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.ovdue_tot_pric is '逾期总本金';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.ovdue_int is '逾期利息';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.ovdue_pnlt is '逾期罚息';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.not_calc_int is '未计利息';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.unexp_pric is '未到期本金';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.stud_loan_prod_id is '助贷产品编号';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.start_dt is '开始时间';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.end_dt is '结束时间';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.id_mark is '增删标志';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ph_soc_appl_evt.etl_timestamp is 'ETL处理时间戳';
