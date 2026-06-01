/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_ref_exch_rat_h
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
alter table ${idl_schema}.aml_ref_exch_rat_h drop partition p_${last_date};
alter table ${idl_schema}.aml_ref_exch_rat_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_ref_exch_rat_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_ref_exch_rat_h partition for (to_date('${batch_date}','yyyymmdd')) (
    curr_cd  -- 币种代码
    ,effect_dt  -- 生效日期
    ,invalid_dt  -- 失效日期
    ,status_cd  -- 状态代码
    ,cn_name  -- 中文名称
    ,en_abbr  -- 英文简称
    ,convt_corp  -- 换算单位
    ,cash_buy_price  -- 钞买价
    ,cash_sell_price  -- 钞卖价
    ,exch_buy_price  -- 汇买价
    ,exch_sell_price  -- 汇卖价
    ,mdl_p  -- 中间价
    ,fori_exch_mdl_p  -- 外管中间价
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,src_table_name  -- 源表名称
    ,job_cd  -- 任务代码
    ,etl_dt  -- 数据日期
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.effect_dt  -- 生效日期
    ,t1.invalid_dt  -- 失效日期
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'')  -- 状态代码
    ,replace(replace(t1.cn_name,chr(13),''),chr(10),'')  -- 中文名称
    ,replace(replace(t1.en_abbr,chr(13),''),chr(10),'')  -- 英文简称
    ,t1.convt_corp  -- 换算单位
    ,t1.cash_buy_price  -- 钞买价
    ,t1.cash_sell_price  -- 钞卖价
    ,t1.exch_buy_price  -- 汇买价
    ,t1.exch_sell_price  -- 汇卖价
    ,t1.mdl_p  -- 中间价
    ,t1.fori_exch_mdl_p  -- 外管中间价
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.src_table_name,chr(13),''),chr(10),'')  -- 源表名称
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.etl_timestamp  -- 数据处理时间
from ${iml_schema}.ref_exch_rat_h t1    --汇率历史表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_ref_exch_rat_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);