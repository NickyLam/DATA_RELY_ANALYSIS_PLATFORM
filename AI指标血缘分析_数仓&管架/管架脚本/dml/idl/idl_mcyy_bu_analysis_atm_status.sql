/*
Purpose:    ATM运行情况统计分析-业务分析表:自助设备
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_bu_analysis_atm_status
Createdate: 20210428

-- 以下为依赖了上游的表 :
msl_atms_dev_status_table 
msl_atms_dev_base_info 
msl_atms_dev_catalog_table 
msl_atms_dev_responsor_table 
msl_atms_bank_manager_persion 
Logs:
            
*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;


alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_atm_status;


-- 1.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_atm_status values ('ATM_STATUS')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_atm_status values ('ATM_STATUS')
;


-- 2.1 基础指标数据处理

--2.1.1 第一组 ATM运行情况统计分析

--2.1.1.1 先将柜员数据插入到表
whenever sqlerror exit sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,rate_up_day -- 比上日
    ,rate_up_day_per -- 比上日百分比
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
    ,bu_type --业务品种
    ,employee --机具管理人员
     )
    WITH tmp_atm_status_data AS
     (SELECT (CASE
                 WHEN substr(t2.org_no
                            ,1
                            ,2) = '89'
                      OR t2.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t2.org_no
             END) AS super_org_no --机构号
            ,t1.dev_no AS org_no
            ,t5.name AS employee
            ,fun_code_conv(t1.dev_run_status
                          ,'WD041007') AS bu_type
            ,COUNT(DISTINCT t1.dev_no) AS index_value
      FROM   msl_atms_dev_status_table t1
      LEFT   JOIN msl_atms_dev_base_info t2
      ON     t2.no = t1.dev_no
      LEFT   JOIN msl_atms_dev_catalog_table t3
      ON     t2.dev_catalog = t3.no
      LEFT   JOIN (SELECT d.dev_no
                        ,listagg(o.name
                                ,',') AS NAME
                  FROM   msl_atms_dev_responsor_table d, msl_atms_bank_manager_persion o
                  WHERE  to_char(d.RESPONSER_NO) = o.no
                  AND    d.catalog = 1
                  AND    d.grade = 1
                  GROUP  BY d.dev_no) t5
      ON     t5.dev_no = t1.dev_no
      WHERE  t3.name IN ('ATM'
                        ,'CRS')
      AND    t2.operate_status != '3'
      AND    t2.status <> '0' --不含注销设备
      AND    substr(status_last_time
                   ,1
                   ,8) <= '${batch_date}'
      GROUP  BY t1.dev_no
               ,t5.name
               ,t1.dev_run_status
               ,(CASE
                    WHEN substr(t2.org_no
                               ,1
                               ,2) = '89'
                         OR t2.org_no = '800001' THEN
                     '000000'
                    ELSE
                     t2.org_no
                END)
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t2.org_no         AS org_no --柜员号
            ,t2.org_no         AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no   AS super_org_no
            , --柜员所属支行机构编码
             t2.index_value    AS accu_index_value_d --当日累计
            ,t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL              measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
            ,t2.bu_type        AS bu_type --业务品种
            ,t2.employee       AS employee
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_atm_status_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'WD041007' = t4.index_no_mcs
      WHERE  t2.bu_type IS NOT NULL
      AND    length(t1.super_org_no) = 3 --只关联支行
      ),
    --取上日数据来做日比较类计算
    tmp_ld_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no -- 上级机构编码
            ,t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
             -- 度量名称
            ,coalesce(t1.accu_index_value_d
                     ,0) - coalesce(t2.accu_index_value_d
                                   ,0) AS rate_up_day --比上日   
            ,(CASE
                 WHEN coalesce(t2.accu_index_value_d
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                                ,0)) /
                        coalesce(t2.accu_index_value_d
                                ,0)
                       ,6)
             END) AS rate_up_day_per --比上日百分比 
            ,t1.bu_type AS bu_type --业务品种  
            ,t1.employee AS employee
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上日数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd') - 1
      AND    t1.bu_type = t2.bu_type)
    
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计        
          ,SUM(mcyy_bu_analysis_tmp.rate_up_day) -- 比上日         
          ,SUM(mcyy_bu_analysis_tmp.rate_up_day_per) -- 比上日百分比
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'ATM_STATUS' source_sys --来源系统
          ,mcyy_bu_analysis_tmp.bu_type --业务品种
          ,mcyy_bu_analysis_tmp.employee
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,NULL               rate_up_day
                  ,NULL               rate_up_day_per
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
                  ,employee
            FROM   tmp_td_initza
            
            UNION ALL
            
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL accu_index_value_d
                  ,rate_up_day
                  ,rate_up_day_per
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
                  ,employee
            FROM   tmp_ld_data) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
             ,mcyy_bu_analysis_tmp.bu_type -- 业务品种
             ,mcyy_bu_analysis_tmp.employee -- 机具管理人员
    ;

COMMIT;

--2.1.1.2 将柜员数据汇总成总分支行数据

whenever sqlerror EXIT sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,rate_up_day -- 比上日
    ,rate_last_month -- 比上月
    ,rate_up_day_per -- 比上日百分比
    ,rate_last_month_per -- 比上月百分比   
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
    ,bu_type --业务品种
     )
    WITH tmp_atm_status_data_person AS
     ( --当日设备汇总数据
      SELECT SUM(t.accu_index_value_d) AS index_value
             ,t.super_org_no org_no
             ,t.bu_type
      FROM   mcyy_bu_analysis t --根据柜员粒度的事实数据基础，汇总成分行总行
      WHERE  t.etl_dt = to_date('${batch_date}'
                               ,'yyyyMMdd')
      AND    t.index_no = 'WD041007'
      GROUP  BY t.super_org_no, t.bu_type),
    
    tmp_atm_status_data_person_months AS
     ( --当月设备汇总数据
      SELECT COUNT(DISTINCT t.org_no) AS index_value
             ,t.super_org_no org_no
             ,t.bu_type
      FROM   mcyy_bu_analysis t --根据柜员粒度的事实数据基础，汇总成分行总行
      WHERE  t.etl_dt >= trunc(to_date('${batch_date}'
                                      ,'yyyyMMdd')
                              ,'MM')
      AND    t.etl_dt <= to_date('${batch_date}'
                                ,'yyyyMMdd')
      AND    t.index_no = 'WD041007'
      AND    t.org_no = t.org_name --只查询设备数据
      GROUP  BY t.super_org_no, t.bu_type),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no --柜员号
            ,t1.org_name AS org_name
            , --柜员名称
             t1.super_org_no AS super_org_no
            , --柜员所属支行机构编码
             CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.index_value
                              ,0)) over(PARTITION BY t4.index_no
                                       ,t1.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.index_value
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t1.bu_type)
                 ELSE
                  coalesce(t2.index_value
                          ,0)
             END AS accu_index_value_d --当日累计     
            ,CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t5.index_value
                              ,0)) over(PARTITION BY t4.index_no
                                       ,t1.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t5.index_value
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t1.bu_type)
                 ELSE
                  coalesce(t5.index_value
                          ,0)
             END AS accu_index_value_m --当月累计           
            ,t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
            ,t1.bu_type AS bu_type --业务品种   --汇总部分必须用外表的bu_type避免内表无数据
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD041007') dim_tab) t1 --可以考虑放到with子句
      LEFT   JOIN tmp_atm_status_data_person t2
      ON     t1.org_no = t2.org_no
      AND    t2.bu_type = t1.bu_type --前端需要不发生数据也生成分总行，所以这里写在ON里不用where过滤
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'WD041007' = t4.index_no_mcs
      LEFT   JOIN tmp_atm_status_data_person_months t5
      ON     t1.org_no = t5.org_no
      AND    t1.bu_type = t5.bu_type),
    --取上日数据来做日比较类计算
    tmp_ld_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no -- 上级机构编码          
            ,t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             NULL accu_index_value_m --当月累计          
            ,coalesce(t1.accu_index_value_d
                     ,0) - coalesce(t2.accu_index_value_d
                                   ,0) AS rate_up_day --比上日   
            ,CASE
                 WHEN coalesce(t2.accu_index_value_d
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                                ,0)) /
                        coalesce(t2.accu_index_value_d
                                ,0)
                       ,6)
             END AS rate_up_day_per --比上日百分比 
            ,t1.bu_type AS bu_type --业务品种      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上日数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd') - 1
      AND    t1.bu_type = t2.bu_type),
    --取上月数据来做月比较类计算
    
    tmp_lm_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no -- 上级机构编码
             
            ,t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             NULL accu_index_value_m --当月累计    
            ,(CASE
                 WHEN to_date('${batch_date}'
                             ,'yyyymmdd') =
                      last_day(to_date('${batch_date}'
                                      ,'yyyyMMdd')) THEN
                  coalesce(t1.accu_index_value_m
                          ,0) - coalesce(t2.accu_index_value_m
                                        ,0)
             END) AS rate_last_month --比上月  
            ,(CASE
                 WHEN coalesce(t2.accu_index_value_m
                              ,0) = 0 THEN
                  0
                 WHEN to_date('${batch_date}'
                             ,'yyyymmdd') =
                      last_day(to_date('${batch_date}'
                                      ,'yyyyMMdd')) THEN
                  round(coalesce(t1.accu_index_value_m
                                ,0) -
                        coalesce(t2.accu_index_value_m
                                ,0) / coalesce(t2.accu_index_value_m
                                              ,0)
                       ,6)
             END) AS rate_last_month_per --比上月百分比     
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = trunc(to_date('${batch_date}'
                                      ,'yyyymmdd')
                              ,'mm') - 1
      AND    t1.bu_type = t2.bu_type
      LEFT   JOIN tmp_atm_status_data_person_months t3
      ON     t1.org_no = t3.org_no
      AND    t1.bu_type = t3.bu_type)
    
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_bu_analysis_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_bu_analysis_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_bu_analysis_tmp.rate_last_month_per) -- 比上月百分比
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'ATM_STATUS' source_sys --来源系统
          ,mcyy_bu_analysis_tmp.bu_type --业务品种
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,accu_index_value_m
                  ,NULL               rate_up_day
                  ,NULL               rate_last_month
                  ,NULL               rate_up_day_per
                  ,NULL               rate_last_month_per
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            FROM   tmp_td_initza
            
            UNION ALL
            
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL            accu_index_value_d
                  ,NULL            accu_index_value_m
                  ,rate_up_day
                  ,NULL            rate_last_month
                  ,rate_up_day_per
                  ,NULL            rate_last_month_per
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            
            FROM   tmp_ld_data
            
            UNION ALL
            SELECT
            
             index_no
            ,index_name
            ,org_no
            ,org_name
            ,super_org_no
            ,NULL         accu_index_value_d
            ,NULL         accu_index_value_m
             
            ,NULL            rate_up_day
            ,rate_last_month
             
            ,NULL                rate_up_day_per
            ,rate_last_month_per
             
            ,unit
            ,frequency
            ,measure_no
            ,index_measure
            ,bu_type
            
            FROM   tmp_lm_data
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
             ,mcyy_bu_analysis_tmp.bu_type -- 业务品种
    
    ;

COMMIT;


-- 3.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

