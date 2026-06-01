/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_evt_fx_ib_lend_provi
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_evt_fx_ib_lend_provi drop partition p_${last_date};
alter table ${idl_schema}.icrm_evt_fx_ib_lend_provi drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_evt_fx_ib_lend_provi add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_evt_fx_ib_lend_provi partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_flow_num  -- 交易流水号
    ,dept_id  -- 部门编号
    ,org_id  -- 机构编号
    ,curr_cd  -- 币种代码
    ,tran_amt  -- 交易金额
    ,term_end_stl_amt  -- 期末结算金额
    ,ib_lend_int_rat  -- 拆借利率
    ,tran_dt  -- 交易日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,tran_aim_cd  -- 交易目的代码
    ,cntpty_id  -- 交易对手编号
    ,int_accr_base_cd  -- 计息基准代码
    ,portf_id  -- 投组编号
    ,provi_dt  -- 计提日期
    ,provi_amt  -- 计提金额
    ,tran_dir_cd  -- 交易方向代码
    ,ib_lend_type_cd  -- 拆借类型代码
    ,bag_id  -- 成交编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.tran_amt  -- 交易金额
    ,t1.term_end_stl_amt  -- 期末结算金额
    ,t1.ib_lend_int_rat  -- 拆借利率
    ,t1.tran_dt  -- 交易日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式代码
    ,replace(replace(t1.tran_aim_cd,chr(13),''),chr(10),'')  -- 交易目的代码
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'')  -- 计息基准代码
    ,replace(replace(t1.portf_id,chr(13),''),chr(10),'')  -- 投组编号
    ,t1.provi_dt  -- 计提日期
    ,t1.provi_amt  -- 计提金额
    ,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'')  -- 交易方向代码
    ,replace(replace(t1.ib_lend_type_cd,chr(13),''),chr(10),'')  -- 拆借类型代码
    ,replace(replace(t1.bag_id,chr(13),''),chr(10),'')  -- 成交编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.evt_fx_ib_lend_provi t1    --外汇同业拆借计提事件
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_evt_fx_ib_lend_provi',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);