/*
Purpose:    将每日指标事实表数据固化到表供前端查询
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_bu_analysis_fe_diplay_day_init
Createdate: 20210624
Logs:

*/
set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

--初始化数据需要全量清空
truncate table ${idl_schema}.mcyy_bu_analysis_fe_diplay;

--1.2 循环创建指定分区
whenever sqlerror exit sql.sqlcode; 

set serveroutput on 
DECLARE
    --获取指标+维度、指标+维度+000（合计）的集合作为分区列表
    CURSOR cur_partition IS
        SELECT t1.index_no || t3.dim_class || t3.dim_no AS partition_name --含维度
        FROM   mcyy_index_define t1
        LEFT   JOIN mcyy_dim_index t2
        ON     t1.index_no = t2.index_no
        LEFT   JOIN mcyy_dim_define t3
        ON     t3.dim_class = t2.dim_class
        UNION ALL
        SELECT t2.index_no || t2.dim_class || '000' AS partition_name --维度000合计
        FROM   mcyy_dim_index t2
        UNION ALL
        SELECT t1.index_no AS partition_name FROM mcyy_index_define t1; --单指标，主要兼容测试环境

    exists_flag NUMBER(10) := 0; -- 判断标志
    v_sql       VARCHAR2(4000);
    v_partition VARCHAR2(200);

BEGIN

    FOR rec_partition IN cur_partition
    LOOP
    
        v_partition := rec_partition.partition_name;
    
        SELECT COUNT(1)
        INTO   exists_flag
        FROM   user_tab_partitions
        WHERE  table_name = 'MCYY_BU_ANALYSIS_FE_DIPLAY'
        AND    partition_name = 'P_' || v_partition;
    
        IF exists_flag = 0
        THEN
            --分区不存在则直接创建
            --动态拼接创建分区sql
            v_sql := 'alter table mcyy_bu_analysis_fe_diplay add partition p_' ||
                     v_partition || ' values ';
            v_sql := v_sql || '(''' || v_partition || ''')';
        
            EXECUTE IMMEDIATE v_sql;
        ELSE
            --分区存在则清空分区数据
            v_sql := 'alter table mcyy_bu_analysis_fe_diplay truncate partition p_' ||
                     v_partition;
            EXECUTE IMMEDIATE v_sql;
        END IF;
    
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环创建指定分区出错' || SQLERRM);
    
END;


/

-- 2.1 insert data to tables
whenever sqlerror exit sql.sqlcode; 

INSERT /*+ append */
INTO ${idl_schema}.mcyy_bu_analysis_fe_diplay
    (etl_dt
    , --数据日期 
     index_no
    , --指标编码 
     index_name
    , --指标名称 
     org_no
    , --机构编码 
     org_name
    , --机构名称 
     super_org_no
    , --上级机构编码 
     org_sort
    , --机构分类 
     employee
    , --员工     
     bu_type
    , --业务品种 
     oper_step
    , --操作阶段 
     index_value
    , --指标值   
     accu_index_value_d
    , --当日累计 
     accu_index_value_m
    , --当月累计 
     accu_index_value_q
    , --当季累计 
     accu_index_value_y
    , --当年累计 
     rate_up_day
    , --比上日   
     rate_last_month
    , --比上月   
     rate_last_quater
    , --比上季   
     rate_last_year
    , --比上年   
     rate_last_period
    , --同比     
     rate_up_day_per
    , --比上日百分比 
     rate_last_month_per
    , --比上月百分比 
     rate_last_quater_per
    , --比上季百分比 
     rate_last_year_per
    , --比上年百分比 
     rate_last_period_per
    , --同比百分比 
     index_ranking
    , --当前排名 
     index_ranking_cha
    , --排名变动 
     index_value_avg
    , --均值     
     index_value_limit
    , --阀值     
     day_ratio_index
    , --日占比   
     mon_ratio_index
    , --月占比   
     quar_ratio_index
    , --季占比   
     year_ratio_index
    , --年占比   
     ratio_org
    , --分行贡献度 
     unit
    , --单位     
     frequency
    , --频度     
     measure_no
    , --度量编号 
     index_measure
    , --度量名称 
     source_sys
    , --来源系统 
     etl_timestamp --ETL处理时间戳
     )
    SELECT t1.etl_dt
          ,(CASE
               WHEN t2.dim_name IS NULL THEN
                index_no
               ELSE
                index_no || bu_type
           END) AS index_no --将指标维度品种与指标编号拼接供前端组合查询
          ,(CASE
               WHEN t2.dim_name IS NULL THEN
                index_name
               ELSE
                index_name || '(' || t2.dim_name || ')'
           END) AS index_name --将指标维度品种名称与指标名称拼接供前端组合查询
          ,t1.org_no
          ,nvl(t3.short_name
              ,t1.org_name) AS org_name
          ,t1.super_org_no
          ,org_sort
          ,employee
          ,bu_type
          ,oper_step
          ,index_value
          ,accu_index_value_d
          ,accu_index_value_m
          ,accu_index_value_q
          ,accu_index_value_y
          ,rate_up_day
          ,rate_last_month
          ,rate_last_quater
          ,rate_last_year
          ,rate_last_period
          ,rate_up_day_per
          ,rate_last_month_per
          ,rate_last_quater_per
          ,rate_last_year_per
          ,rate_last_period_per
          ,index_ranking
          ,index_ranking_cha
          ,index_value_avg
          ,index_value_limit
          ,day_ratio_index
          ,mon_ratio_index
          ,quar_ratio_index
          ,year_ratio_index
          ,ratio_org
          ,unit
          ,frequency
          ,measure_no
          ,index_measure
          ,source_sys
          ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp
    FROM   mcyy_bu_analysis t1
    LEFT   JOIN mcyy_dim_define t2
    ON     t1.bu_type = t2.dim_class || t2.dim_no
    AND    t2.dim_state = '1'
    LEFT   JOIN mcyy_orga_para t3
    ON     t3.org_no = t1.org_no
    WHERE  t1.etl_dt <= to_date('${batch_date}'
                              ,'yyyymmdd')
    UNION ALL
    SELECT t1.etl_dt
          ,t1.index_no || t2.dim_class || '000' index_no
          ,t1.index_name || '(' || t2.dim_class_name || '合计)' index_name
          ,t1.org_no
          ,nvl(t3.short_name
              ,t1.org_name) AS org_name
          ,t1.super_org_no
          ,NULL org_sort
          ,NULL employee
          ,t2.dim_class || '000' bu_type
          ,NULL oper_step
          ,NULL index_value
          ,SUM(t1.accu_index_value_d) accu_index_value_d
          ,SUM(t1.accu_index_value_m) accu_index_value_m
          ,SUM(t1.accu_index_value_q) accu_index_value_q
          ,SUM(t1.accu_index_value_y) accu_index_value_y
          ,SUM(t1.rate_up_day) rate_up_day
          ,SUM(t1.rate_last_month) rate_last_month
          ,SUM(t1.rate_last_quater) rate_last_quater
          ,SUM(t1.rate_last_year) rate_last_year
          ,NULL rate_last_period
        	, (case when coalesce(SUM(t4.accu_index_value_d),0)=0 then 1 else SUM(t1.rate_up_day)/SUM(t4.accu_index_value_d)end ) rate_up_day_per
          ,(case when coalesce(SUM(t4.accu_index_value_M),0)=0 then 1 else SUM(t1.rate_last_month_per)/SUM(t4.accu_index_value_M) end )rate_last_month_per
          ,(case when coalesce(SUM(t4.accu_index_value_Q),0)=0 then 1 else  SUM(t1.rate_last_quater_per)/SUM(t4.accu_index_value_Q)end )rate_last_quater_per
          ,(case when coalesce(SUM(t4.accu_index_value_Y),0)=0 then 1 else  SUM(t1.rate_last_year_per)/SUM(t4.accu_index_value_Y)end ) rate_last_year_per
          ,NULL rate_last_period_per
          ,NULL index_ranking
          ,NULL index_ranking_cha
          ,NULL index_value_avg
          ,NULL index_value_limit
          ,NULL day_ratio_index
          ,NULL mon_ratio_index
          ,NULL quar_ratio_index
          ,NULL year_ratio_index
          ,NULL ratio_org
          ,t1.unit
          ,t1.frequency
          ,t1.measure_no
          ,t1.index_measure
          ,NULL source_sys
          ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as  etl_timestamp
    FROM   mcyy_bu_analysis t1
    LEFT   JOIN mcyy_dim_define t2
    ON     t1.bu_type = t2.dim_class || t2.dim_no
    AND    t2.dim_state = '1'
    LEFT   JOIN mcyy_orga_para t3
    ON     t3.org_no = t1.org_no
    LEFT   JOIN mcyy_bu_analysis T4 --上日
    ON 		T4.INDEX_NO=T1.INDEX_NO
    AND   T4.ETL_DT=(T1.ETL_DT-1)
    AND   T4.ORG_NO= T1.ORG_NO
    AND   NVL(T4.BU_TYPE,'NULL')=NVL(T1.BU_TYPE,'NULL')
     LEFT   JOIN mcyy_bu_analysis T5 --上月
    ON 		T5.INDEX_NO=T1.INDEX_NO
    AND   T5.ETL_DT=add_months(T1.ETL_DT
                 ,-1)
    AND   T5.ORG_NO= T1.ORG_NO
    AND   NVL(T5.BU_TYPE,'NULL')=NVL(T1.BU_TYPE,'NULL')
    LEFT   JOIN mcyy_bu_analysis T6 --上季
    ON 		T6.INDEX_NO=T1.INDEX_NO
    AND   T6.ETL_DT=add_months(T1.ETL_DT
                 ,-3)
    AND   T6.ORG_NO= T1.ORG_NO
    AND   NVL(T6.BU_TYPE,'NULL')=NVL(T1.BU_TYPE,'NULL')
     LEFT   JOIN mcyy_bu_analysis T7 --上年
    ON 		T7.INDEX_NO=T1.INDEX_NO
    AND   T7.ETL_DT=add_months(T1.ETL_DT
                 ,-12)
    AND   T7.ORG_NO= T1.ORG_NO
    AND   NVL(T7.BU_TYPE,'NULL')=NVL(T1.BU_TYPE,'NULL')
    WHERE  t1.bu_type IS NOT NULL
    AND    t1.etl_dt <= to_date('${batch_date}'
                              ,'yyyymmdd')
    GROUP  BY t2.dim_class
             ,t1.etl_dt
             ,t1.index_no
             ,t1.index_name
             ,t1.org_no
             ,nvl(t3.short_name
                 ,t1.org_name)
             ,t1.super_org_no
             ,t2.dim_class_name
             ,t1.unit
             ,t1.frequency
             ,t1.measure_no
             ,t1.index_measure;
COMMIT;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${idl_schema}.mcyy_bu_analysis_fe_diplay to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mcyy_bu_analysis_fe_diplay', degree => 8, cascade => true);
