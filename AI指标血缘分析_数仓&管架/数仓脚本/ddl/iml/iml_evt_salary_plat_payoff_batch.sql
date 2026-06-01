/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_salary_plat_payoff_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_salary_plat_payoff_batch
whenever sqlerror continue none;
drop table ${iml_schema}.evt_salary_plat_payoff_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_salary_plat_payoff_batch(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_id varchar2(250) -- 批次编号
    ,batch_caption varchar2(2000) -- 批次标题
    ,batch_flow_cd varchar2(30) -- 批次流程代码
    ,batch_status_cd varchar2(30) -- 批次状态代码
    ,batch_dt date -- 批次日期
    ,batch_cmplt_dt date -- 批次完成日期
    ,corp_id varchar2(250) -- 企业编号
    ,corp_name varchar2(1000) -- 企业名称
    ,payoff_src_cd varchar2(30) -- 代发来源代码
    ,payoff_kind_cd varchar2(30) -- 代发种类代码
    ,payoff_year number(10) -- 代发年份
    ,payoff_mon number(10) -- 代发月份
    ,tot_number number(10) -- 总人数
    ,tot number(10) -- 总笔数
    ,tot_amt number(30,2) -- 总金额
    ,avg_amt number(30,2) -- 平均金额
    ,sucs_tot_amt number(30,2) -- 成功总金额
    ,fail_tot_amt number(30,2) -- 失败总金额
    ,sucs_cnt number(10) -- 成功笔数
    ,fail_cnt number(10) -- 失败笔数
    ,tran_status_union_qtty number(30) -- 交易状态未知数量
    ,apv_ser_num varchar2(250) -- 审批序列号
    ,salary_group_id varchar2(250) -- 薪酬组编号
    ,org_id varchar2(250) -- 机构编号
    ,diplay_payoff_dtl_flg varchar2(10) -- 展示代发明细标志
    ,lock_flg varchar2(10) -- 锁定标志
    ,batch_create_dt date -- 批次创建日期
    ,batch_update_dt date -- 批次更新日期
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
grant select on ${iml_schema}.evt_salary_plat_payoff_batch to ${icl_schema};
grant select on ${iml_schema}.evt_salary_plat_payoff_batch to ${idl_schema};
grant select on ${iml_schema}.evt_salary_plat_payoff_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_salary_plat_payoff_batch is '薪酬平台代发批次';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.evt_id is '事件编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.lp_id is '法人编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_id is '批次编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_caption is '批次标题';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_flow_cd is '批次流程代码';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_status_cd is '批次状态代码';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_dt is '批次日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_cmplt_dt is '批次完成日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.corp_id is '企业编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.corp_name is '企业名称';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.payoff_src_cd is '代发来源代码';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.payoff_kind_cd is '代发种类代码';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.payoff_year is '代发年份';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.payoff_mon is '代发月份';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.tot_number is '总人数';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.tot is '总笔数';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.tot_amt is '总金额';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.avg_amt is '平均金额';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.sucs_tot_amt is '成功总金额';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.fail_tot_amt is '失败总金额';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.sucs_cnt is '成功笔数';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.fail_cnt is '失败笔数';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.tran_status_union_qtty is '交易状态未知数量';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.apv_ser_num is '审批序列号';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.salary_group_id is '薪酬组编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.org_id is '机构编号';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.diplay_payoff_dtl_flg is '展示代发明细标志';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.lock_flg is '锁定标志';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_create_dt is '批次创建日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.batch_update_dt is '批次更新日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.job_cd is '任务编码';
comment on column ${iml_schema}.evt_salary_plat_payoff_batch.etl_timestamp is 'ETL处理时间戳';
