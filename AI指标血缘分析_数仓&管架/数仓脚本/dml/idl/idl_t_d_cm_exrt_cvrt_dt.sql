/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_t_d_cm_exrt_cvrt_dt
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
--alter table ${idl_schema}.t_d_cm_exrt_cvrt_dt drop partition p_${last_date};
alter table ${idl_schema}.t_d_cm_exrt_cvrt_dt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.t_d_cm_exrt_cvrt_dt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
--第一组
insert /*+ append */ into ${idl_schema}.t_d_cm_exrt_cvrt_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    date_id  -- 会计日期
    ,zb  -- 折币币种
    ,curr_code  -- 币种编码
    ,curr_name  -- 币种名称
    ,cny_exrt  -- 对人民币折算率
    ,usd_exrt  -- 对美元折算率
    ,usd_cvrt  -- 预留字段
    ,hl  -- 
    ,etl_dt  -- 数据日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.date_id,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace(t1.curr_code,chr(13),''),chr(10),'')  -- 折币币种
    ,replace(replace(t1.curr_code,chr(13),''),chr(10),'')  -- 币种编码
    ,replace(replace(t1.curr_name,chr(13),''),chr(10),'')  -- 币种名称
    ,t1.cny_exrt  -- 对人民币折算率
    ,t1.usd_exrt  -- 对美元折算率
    ,t1.usd_cvrt  -- 预留字段
    ,1  -- 
    ,to_date('${batch_date}','yyyymmdd')  -- 
    ,''  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
 from ${idl_schema}.a_d_cm_exrt_cvrt_dt t1 --汇率维表
where t1.etl_dt=to_date('${batch_date}','yyyymmdd') 
;
commit;
--第二组
insert /*+ append */ into ${idl_schema}.t_d_cm_exrt_cvrt_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    date_id  -- 会计日期
    ,zb  -- 折币币种
    ,curr_code  -- 币种编码
    ,curr_name  -- 币种名称
    ,cny_exrt  -- 对人民币折算率
    ,usd_exrt  -- 对美元折算率
    ,usd_cvrt  -- 预留字段
    ,hl  -- 
    ,etl_dt  -- 数据日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.date_id,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace('CN',chr(13),''),chr(10),'')  -- 折币币种
    ,replace(replace(t1.curr_code,chr(13),''),chr(10),'')  -- 币种编码
    ,replace(replace(t1.curr_name,chr(13),''),chr(10),'')  -- 币种名称
    ,t1.cny_exrt  -- 对人民币折算率
    ,t1.usd_exrt  -- 对美元折算率
    ,t1.usd_cvrt  -- 预留字段
    ,t1.cny_exrt  -- 
    ,to_date('${batch_date}','yyyymmdd')  -- 
    ,''  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
 from ${idl_schema}.a_d_cm_exrt_cvrt_dt t1 --汇率维表
where t1.etl_dt=to_date('${batch_date}','yyyymmdd') 
;
commit;
--第三组
insert /*+ append */ into ${idl_schema}.t_d_cm_exrt_cvrt_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    date_id  -- 会计日期
    ,zb  -- 折币币种
    ,curr_code  -- 币种编码
    ,curr_name  -- 币种名称
    ,cny_exrt  -- 对人民币折算率
    ,usd_exrt  -- 对美元折算率
    ,usd_cvrt  -- 预留字段
    ,hl  -- 
    ,etl_dt  -- 数据日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.date_id,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace('FC',chr(13),''),chr(10),'')  -- 折币币种
    ,replace(replace(t1.curr_code,chr(13),''),chr(10),'')  -- 币种编码
    ,replace(replace(t1.curr_name,chr(13),''),chr(10),'')  -- 币种名称
    ,t1.cny_exrt  -- 对人民币折算率
    ,t1.usd_exrt  -- 对美元折算率
    ,t1.usd_cvrt  -- 预留字段
    ,t1.cny_exrt  -- 
    ,to_date('${batch_date}','yyyymmdd')  -- 
    ,''  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
 from ${idl_schema}.a_d_cm_exrt_cvrt_dt t1 --汇率维表
where 
t1.curr_code<>'CNY' 
and
t1.etl_dt=to_date('${batch_date}','yyyymmdd') 
;
commit;
--第四组
insert /*+ append */ into ${idl_schema}.t_d_cm_exrt_cvrt_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    date_id  -- 会计日期
    ,zb  -- 折币币种
    ,curr_code  -- 币种编码
    ,curr_name  -- 币种名称
    ,cny_exrt  -- 对人民币折算率
    ,usd_exrt  -- 对美元折算率
    ,usd_cvrt  -- 预留字段
    ,hl  -- 
    ,etl_dt  -- 数据日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.date_id,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace('US',chr(13),''),chr(10),'')  -- 折币币种
    ,replace(replace(t1.curr_code,chr(13),''),chr(10),'')  -- 币种编码
    ,replace(replace(t1.curr_name,chr(13),''),chr(10),'')  -- 币种名称
    ,t1.cny_exrt  -- 对人民币折算率
    ,t1.usd_exrt  -- 对美元折算率
    ,t1.usd_cvrt  -- 预留字段
    ,t1.usd_exrt  -- 
    ,to_date('${batch_date}','yyyymmdd')  -- 
    ,''  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
 from ${idl_schema}.a_d_cm_exrt_cvrt_dt t1 --汇率维表
where 
t1.curr_code<>'CNY' 
and
t1.etl_dt=to_date('${batch_date}','yyyymmdd') 
;
commit;











-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 't_d_cm_exrt_cvrt_dt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);