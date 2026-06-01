/*
Purpose:    银联交易量/交易额D层-业务分析实时表(WD040501/WD040502):数据来源于中台
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_bu_analysis_unionpay_pay
Createdate: 20210601
Logs:

-- 生成的IDL层表 ：mcyy_bu_analysis
-- 以下为依赖了上游的表 :
-- itl_edw_evt_atmp_unionpay_tran_flow
-- 以下为依赖的参数表 :
-- mcyy_index_define           -- 指标表清单
-- mcyy_orga_para                   -- 总分支机构表
 							--1、89开头的虚拟机构，数据归纳到总行
              --2、800001营运管理部，数据归到总行
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition 
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_unionpay_pay;


-- 2.2 add today partition
whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_unionpay_pay values ('UNIONPAY_PAY')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_unionpay_pay values ('UNIONPAY_PAY')
;

-- 2.3 insert data target table

--第一组：银联交易量
whenever sqlerror exit sql.sqlcode;

INSERT /*+ append */
INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,rate_up_day -- 比上日
    ,rate_last_month -- 比上月
    ,rate_last_quater -- 比上季
    ,rate_last_year -- 比上年
    ,rate_last_period -- 同比
    ,rate_up_day_per -- 比上日百分比
    ,rate_last_month_per -- 比上月百分比
    ,rate_last_quater_per -- 比上季百分比
    ,rate_last_year_per -- 比上年百分比
    ,rate_last_period_per -- 同比百分比
    ,index_ranking -- 当前排名
    ,index_ranking_cha -- 排名变动
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
    ,bu_type
     ,day_ratio_index --日占比
    ,mon_ratio_index --月占比
    ,quar_ratio_index --季占比
    ,year_ratio_index --年占比
    )

    WITH tmp_unionpay_pay_vlm_bus AS
     (
      --银联非资金交易量
      SELECT '800' AS org_no
               ,COUNT(1) AS sum_count
               ,'YL_YWLX002' AS bu_type 
FROM   itl_edw_evt_atmp_unionpay_tran_flow t
WHERE  t.tran_status_cd = '1'
AND    t.tran_type_cd = '01'
AND    substr(t.tran_status_cd
             ,7
             ,1) <> 'C'
AND    t.tran_dt = to_date('${batch_date}'
                                 ,'yyyymmdd')
AND    nvl(t.tran_amt
          ,0) = 0
AND   T.ETL_DT  = to_date('${batch_date}'
                                 ,'yyyymmdd')     
      UNION ALL
      --银联资金交易量
           SELECT '800' AS org_no
               ,COUNT(1) AS sum_count
               ,'YL_YWLX001' AS bu_type 
FROM   itl_edw_evt_atmp_unionpay_tran_flow t
WHERE  t.tran_status_cd = '1'
AND    t.tran_type_cd = '01'
AND    substr(t.intnal_tran_cd
             ,7
             ,1) <> 'C'
AND    t.tran_dt = to_date('${batch_date}'
                                 ,'yyyymmdd')
AND    nvl(t.tran_amt
          ,0) > 0
AND   T.ETL_DT  = to_date('${batch_date}'
                                 ,'yyyymmdd')           
      ),
    
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no
            , --机构编码
             t1.org_name AS org_name
            , --机构名称
             t1.super_org_no AS super_org_no
            , --上级机构编码
             coalesce(t2.sum_count,0)
              AS accu_index_value_d
            , --当日累计
             rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY coalesce(t2.sum_count, 0) DESC) AS index_ranking
            , --当前排名
             t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
            ,t1.bu_type
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD040501') dim_tab) t1
      LEFT   JOIN (SELECT (CASE
                             WHEN substr(org_no
                                        ,1
                                        ,2) = '89'
                                  OR org_no = '800001' THEN
                              '-000000'
                             ELSE
                              org_no
                         END) AS org_no
                        ,bu_type
                        ,SUM(sum_count) sum_count
                  FROM   tmp_unionpay_pay_vlm_bus
                  GROUP  BY (CASE
                                WHEN substr(org_no
                                           ,1
                                           ,2) = '89'
                                     OR org_no = '800001' THEN
                                 '-000000'
                                ELSE
                                 org_no
                            END)
                           ,bu_type) t2
      ON     t1.org_no = t2.org_no
      AND    t1.bu_type = t2.bu_type
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'WD040501' = t4.index_no_mcs),
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
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             --当月初取当日数据作为当月累计，否则在上日的数据基础上累加
             CASE
                 WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                           ,'mm') = to_date('${batch_date}'
                                           ,'yyyymmdd') THEN
                  t1.accu_index_value_d
                 ELSE
                  coalesce(t1.accu_index_value_d
                          ,0) + coalesce(t2.accu_index_value_m
                                        ,0)
             END AS accu_index_value_m --当月累计
             --当季初取当日数据作为当季累计，否则在上日的数据基础上累加
            ,CASE
                 WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                           ,'Q') = to_date('${batch_date}'
                                          ,'yyyymmdd') THEN
                  t1.accu_index_value_d
                 ELSE
                  coalesce(t1.accu_index_value_d
                          ,0) + coalesce(t2.accu_index_value_q
                                        ,0)
             END AS accu_index_value_q --当季累计 
             --当年初取当日数据作为当年累计，否则在上日的数据基础上累加
            ,CASE
                 WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                           ,'yy') = to_date('${batch_date}'
                                           ,'yyyymmdd') THEN
                  t1.accu_index_value_d
                 ELSE
                  coalesce(t1.accu_index_value_d
                          ,0) + coalesce(t2.accu_index_value_y
                                        ,0)
             END AS accu_index_value_y --当年累计
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
            ,rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY t1.accu_index_value_d DESC) - t2.index_ranking AS index_ranking_cha --排名变动                                                  
            ,t1.bu_type
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
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_m
                     ,0) - coalesce(t2.accu_index_value_m
                                   ,0) AS rate_last_month --比上月  
            ,CASE
                 WHEN coalesce(t2.accu_index_value_m
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_m
                                 ,0) - coalesce(t2.accu_index_value_m
                                                ,0)) /
                        coalesce(t2.accu_index_value_m
                                ,0)
                       ,6)
             END AS rate_last_month_per --比上月百分比   
            ,t1.bu_type
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-1)
      AND    t1.bu_type = t2.bu_type),
    --取上季数据来做月比较类计算
    tmp_lq_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_q
                     ,0) - coalesce(t2.accu_index_value_q
                                   ,0) AS rate_last_quater --比上季 
            ,CASE
                 WHEN coalesce(t2.accu_index_value_q
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_q
                                 ,0) - coalesce(t2.accu_index_value_q
                                                ,0)) /
                        coalesce(t2.accu_index_value_q
                                ,0)
                       ,6)
             END AS rate_last_quater_per --比上季百分比   
            ,t1.bu_type
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-3)
      AND    t1.bu_type = t2.bu_type),
    
    tmp_ly_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_y
                     ,0) - coalesce(t2.accu_index_value_y
                                   ,0) AS rate_last_year --比上年
            ,CASE
                 WHEN coalesce(t2.accu_index_value_y
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_y
                                 ,0) - coalesce(t2.accu_index_value_y
                                                ,0)) /
                        coalesce(t2.accu_index_value_y
                                ,0)
                       ,6)
             END AS rate_last_year_per --比上年百分比   
            ,t1.bu_type
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-12)
      AND    t1.bu_type = t2.bu_type),
    tmp_yoy_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_d
                     ,0) - coalesce(t2.accu_index_value_d
                                   ,0) AS rate_last_period --同比
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
             END AS rate_last_period_per --同比百分比   
            ,t1.bu_type
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                           ,'yyyymmdd')
                                   ,-12)
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
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_bu_analysis_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_bu_analysis_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_bu_analysis_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_bu_analysis_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_bu_analysis_tmp.rate_last_period) -- 同比
,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_up_day) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_up_day_per) = 0 THEN
            							1
          						 ELSE
            						SUM(mcyy_bu_analysis_tmp.rate_up_day_per)
       									END) -- 比上日百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_month) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_month_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_month_per) 
          						 end)  -- 比上月百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_quater) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) 
          						 end)  -- 比上季百分比
          						 ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_year) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_year_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_year_per) 
          						 end)-- 比上年百分比
          ,SUM(mcyy_bu_analysis_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_bu_analysis_tmp.index_ranking -- 当前排名
          ,mcyy_bu_analysis_tmp.index_ranking_cha -- 排名变动
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'UNIONPAY_PAY' source_sys --来源系统
          ,mcyy_bu_analysis_tmp.bu_type
           ,ratio_to_report(sum(mcyy_bu_analysis_tmp.accu_index_value_d)) over(PARTITION BY mcyy_bu_analysis_tmp.index_no, mcyy_bu_analysis_tmp.org_no) day_ratio_index --日占比
         ,ratio_to_report(sum(mcyy_bu_analysis_tmp.accu_index_value_m)) over(PARTITION BY mcyy_bu_analysis_tmp.index_no, mcyy_bu_analysis_tmp.org_no) mon_ratio_index --月占比
         ,ratio_to_report(sum(mcyy_bu_analysis_tmp.accu_index_value_q)) over(PARTITION BY mcyy_bu_analysis_tmp.index_no, mcyy_bu_analysis_tmp.org_no) quar_ratio_index --季占比
         ,ratio_to_report(sum(mcyy_bu_analysis_tmp.accu_index_value_y)) over(PARTITION BY mcyy_bu_analysis_tmp.index_no, mcyy_bu_analysis_tmp.org_no) year_ratio_index --年占比
    
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,NULL               accu_index_value_m
                  ,NULL               accu_index_value_q
                  ,NULL               accu_index_value_y
                  ,NULL               rate_up_day
                  ,NULL               rate_last_month
                  ,NULL               rate_last_quater
                  ,NULL               rate_last_year
                  ,NULL               rate_last_period
                  ,NULL               rate_up_day_per
                  ,NULL               rate_last_month_per
                  ,NULL               rate_last_quater_per
                  ,NULL               rate_last_year_per
                  ,NULL               rate_last_period_per
                  ,index_ranking
                  ,0                  index_ranking_cha
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
                  ,NULL               accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,rate_up_day
                  ,NULL               rate_last_month
                  ,NULL               rate_last_quater
                  ,NULL               rate_last_year
                  ,NULL               rate_last_period
                  ,rate_up_day_per
                  ,NULL               rate_last_month_per
                  ,NULL               rate_last_quater_per
                  ,NULL               rate_last_year_per
                  ,NULL               rate_last_period_per
                  ,index_ranking
                  ,0                  index_ranking_cha
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
            ,NULL                accu_index_value_d
            ,NULL                accu_index_value_m
            ,NULL                accu_index_value_q
            ,NULL                accu_index_value_y
            ,NULL                rate_up_day
            ,rate_last_month
            ,NULL                rate_last_quater
            ,NULL                rate_last_year
            ,NULL                rate_last_period
            ,NULL                rate_up_day_per
            ,rate_last_month_per
            ,NULL                rate_last_quater_per
            ,NULL                rate_last_year_per
            ,NULL                rate_last_period_per
            ,index_ranking
            ,0                   index_ranking_cha
            ,
             
             unit
            ,frequency
            ,measure_no
            ,index_measure
            ,bu_type
            
            FROM   tmp_lm_data
            
            UNION ALL
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL                 accu_index_value_d
                  ,NULL                 accu_index_value_m
                  ,NULL                 accu_index_value_q
                  ,NULL                 accu_index_value_y
                  ,NULL                 rate_up_day
                  ,NULL                 rate_last_month
                  ,rate_last_quater
                  ,NULL                 rate_last_year
                  ,NULL                 rate_last_period
                  ,NULL                 rate_up_day_per
                  ,NULL                 rate_last_month_per
                  ,rate_last_quater_per
                  ,NULL                 rate_last_year_per
                  ,NULL                 rate_last_period_per
                  ,index_ranking
                  ,0                    index_ranking_cha
                  ,
                   
                   unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            
            FROM   tmp_lq_data
            UNION ALL
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL               accu_index_value_d
                  ,NULL               accu_index_value_m
                  ,NULL               accu_index_value_q
                  ,NULL               accu_index_value_y
                  ,NULL               rate_up_day
                  ,NULL               rate_last_month
                  ,NULL               rate_last_quater
                  ,rate_last_year
                  ,NULL               rate_last_period
                  ,NULL               rate_up_day_per
                  ,NULL               rate_last_month_per
                  ,NULL               rate_last_quater_per
                  ,rate_last_year_per
                  ,NULL               rate_last_period_per
                  ,index_ranking
                  ,0                  index_ranking_cha
                  ,
                   
                   unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            
            FROM   tmp_ly_data
            
            UNION ALL
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL                 accu_index_value_d
                  ,NULL                 accu_index_value_m
                  ,NULL                 accu_index_value_q
                  ,NULL                 accu_index_value_y
                  ,NULL                 rate_up_day
                  ,NULL                 rate_last_month
                  ,NULL                 rate_last_quater
                  ,NULL                 rate_last_year
                  ,rate_last_period
                  ,NULL                 rate_up_day_per
                  ,NULL                 rate_last_month_per
                  ,NULL                 rate_last_quater_per
                  ,NULL                 rate_last_year_per
                  ,rate_last_period_per
                  ,index_ranking
                  ,0                    index_ranking_cha
                  ,
                   
                   unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            
            FROM   tmp_yoy_data
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.index_ranking
             ,mcyy_bu_analysis_tmp.index_ranking_cha
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
             ,mcyy_bu_analysis_tmp.bu_type
    
    ;

COMMIT;


--第二组 银联交易额
whenever sqlerror exit sql.sqlcode;

INSERT /*+ append */
INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,rate_up_day -- 比上日
    ,rate_last_month -- 比上月
    ,rate_last_quater -- 比上季
    ,rate_last_year -- 比上年
    ,rate_last_period -- 同比
    ,rate_up_day_per -- 比上日百分比
    ,rate_last_month_per -- 比上月百分比
    ,rate_last_quater_per -- 比上季百分比
    ,rate_last_year_per -- 比上年百分比
    ,rate_last_period_per -- 同比百分比
    ,index_ranking -- 当前排名
    ,index_ranking_cha -- 排名变动
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
      ,day_ratio_index --日占比
    ,mon_ratio_index --月占比
    ,quar_ratio_index --季占比
    ,year_ratio_index --年占比
    ,bu_type)

    WITH tmp_unionpay_pay_bus_lmt AS
     (
            --银联资金交易额
           SELECT '800' AS org_no
               , SUM(t.tran_amt) AS sum_amount
               ,'YL_YWLX001' AS bu_type 
FROM   itl_edw_evt_atmp_unionpay_tran_flow t
WHERE  t.tran_status_cd = '1'
AND    t.tran_type_cd = '01'
AND    substr(t.intnal_tran_cd
             ,7
             ,1) <> 'C'
AND    t.tran_dt = to_date('${batch_date}'
                                 ,'yyyymmdd')
AND    nvl(t.tran_amt
          ,0) > 0
AND   T.ETL_DT  = to_date('${batch_date}'
                                 ,'yyyymmdd')    
      ),
    
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no
            , --机构编码
             t1.org_name AS org_name
            , --机构名称
             t1.super_org_no AS super_org_no
            , --上级机构编码
             coalesce(t2.sum_amount,0)
              AS accu_index_value_d
            , --当日累计
             rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY coalesce(t2.sum_amount, 0) DESC) AS index_ranking
            , --当前排名
             t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
            ,t1.bu_type
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD040502') dim_tab) t1
      LEFT   JOIN (SELECT (CASE
                             WHEN substr(org_no
                                        ,1
                                        ,2) = '89'
                                  OR org_no = '800001' THEN
                              '-000000'
                             ELSE
                              org_no
                         END) AS org_no
                        ,bu_type
                        ,SUM(sum_amount) sum_amount
                  FROM   tmp_unionpay_pay_bus_lmt
                  GROUP  BY (CASE
                                WHEN substr(org_no
                                           ,1
                                           ,2) = '89'
                                     OR org_no = '800001' THEN
                                 '-000000'
                                ELSE
                                 org_no
                            END)
                           ,bu_type) t2
      ON     t1.org_no = t2.org_no
      AND    t1.bu_type = t2.bu_type
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'WD040502' = t4.index_no_mcs),
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
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             --当月初取当日数据作为当月累计，否则在上日的数据基础上累加
             CASE
                 WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                           ,'mm') = to_date('${batch_date}'
                                           ,'yyyymmdd') THEN
                  t1.accu_index_value_d
                 ELSE
                  coalesce(t1.accu_index_value_d
                          ,0) + coalesce(t2.accu_index_value_m
                                        ,0)
             END AS accu_index_value_m --当月累计
             --当季初取当日数据作为当季累计，否则在上日的数据基础上累加
            ,CASE
                 WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                           ,'Q') = to_date('${batch_date}'
                                          ,'yyyymmdd') THEN
                  t1.accu_index_value_d
                 ELSE
                  coalesce(t1.accu_index_value_d
                          ,0) + coalesce(t2.accu_index_value_q
                                        ,0)
             END AS accu_index_value_q --当季累计 
             --当年初取当日数据作为当年累计，否则在上日的数据基础上累加
            ,CASE
                 WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                           ,'yy') = to_date('${batch_date}'
                                           ,'yyyymmdd') THEN
                  t1.accu_index_value_d
                 ELSE
                  coalesce(t1.accu_index_value_d
                          ,0) + coalesce(t2.accu_index_value_y
                                        ,0)
             END AS accu_index_value_y --当年累计
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
            ,rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY t1.accu_index_value_d DESC) - t2.index_ranking AS index_ranking_cha --排名变动                                                  
            ,t1.bu_type
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
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_m
                     ,0) - coalesce(t2.accu_index_value_m
                                   ,0) AS rate_last_month --比上月  
            ,CASE
                 WHEN coalesce(t2.accu_index_value_m
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_m
                                 ,0) - coalesce(t2.accu_index_value_m
                                                ,0)) /
                        coalesce(t2.accu_index_value_m
                                ,0)
                       ,6)
             END AS rate_last_month_per --比上月百分比   
            ,t1.bu_type
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-1)
      AND    t1.bu_type = t2.bu_type),
    --取上季数据来做月比较类计算
    tmp_lq_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_q
                     ,0) - coalesce(t2.accu_index_value_q
                                   ,0) AS rate_last_quater --比上季 
            ,CASE
                 WHEN coalesce(t2.accu_index_value_q
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_q
                                 ,0) - coalesce(t2.accu_index_value_q
                                                ,0)) /
                        coalesce(t2.accu_index_value_q
                                ,0)
                       ,6)
             END AS rate_last_quater_per --比上季百分比   
            ,t1.bu_type
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-3)
      AND    t1.bu_type = t2.bu_type),
    
    tmp_ly_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_y
                     ,0) - coalesce(t2.accu_index_value_y
                                   ,0) AS rate_last_year --比上年
            ,CASE
                 WHEN coalesce(t2.accu_index_value_y
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t1.accu_index_value_y
                                 ,0) - coalesce(t2.accu_index_value_y
                                                ,0)) /
                        coalesce(t2.accu_index_value_y
                                ,0)
                       ,6)
             END AS rate_last_year_per --比上年百分比   
            ,t1.bu_type
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-12)
      AND    t1.bu_type = t2.bu_type),
    tmp_yoy_data AS
     (SELECT t1.index_no
            , ---- 指标编码
             t1.index_name
            , -- 指标名称
             t1.org_no
            , -- 机构编码
             t1.org_name
            , -- 机构名称
             t1.super_org_no
            , -- 上级机构编码
             t1.index_ranking
            , -- 当前排名
             t1.unit
            , -- 单位
             t1.frequency
            , -- 频度
             t1.measure_no
            , -- 度量编号
             t1.index_measure
            , -- 度量名称
             coalesce(t1.accu_index_value_d
                     ,0) - coalesce(t2.accu_index_value_d
                                   ,0) AS rate_last_period --同比
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
             END AS rate_last_period_per --同比百分比   
            ,t1.bu_type
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                           ,'yyyymmdd')
                                   ,-12)
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
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_bu_analysis_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_bu_analysis_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_bu_analysis_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_bu_analysis_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_bu_analysis_tmp.rate_last_period) -- 同比
,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_up_day) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_up_day_per) = 0 THEN
            							1
          						 ELSE
            						SUM(mcyy_bu_analysis_tmp.rate_up_day_per)
       									END) -- 比上日百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_month) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_month_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_month_per) 
          						 end)  -- 比上月百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_quater) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) 
          						 end)  -- 比上季百分比
          						 ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_year) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_year_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_year_per) 
          						 end)-- 比上年百分比
          ,SUM(mcyy_bu_analysis_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_bu_analysis_tmp.index_ranking -- 当前排名
          ,mcyy_bu_analysis_tmp.index_ranking_cha -- 排名变动
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'UNIONPAY_PAY' source_sys --来源系统
   ,'1' as day_ratio_index --日占比
    ,'1' as mon_ratio_index --月占比
    ,'1' as quar_ratio_index --季占比
    ,'1' as year_ratio_index --年占比
          ,mcyy_bu_analysis_tmp.bu_type
    
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,NULL               accu_index_value_m
                  ,NULL               accu_index_value_q
                  ,NULL               accu_index_value_y
                  ,NULL               rate_up_day
                  ,NULL               rate_last_month
                  ,NULL               rate_last_quater
                  ,NULL               rate_last_year
                  ,NULL               rate_last_period
                  ,NULL               rate_up_day_per
                  ,NULL               rate_last_month_per
                  ,NULL               rate_last_quater_per
                  ,NULL               rate_last_year_per
                  ,NULL               rate_last_period_per
                  ,index_ranking
                  ,0                  index_ranking_cha
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
                  ,NULL               accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,rate_up_day
                  ,NULL               rate_last_month
                  ,NULL               rate_last_quater
                  ,NULL               rate_last_year
                  ,NULL               rate_last_period
                  ,rate_up_day_per
                  ,NULL               rate_last_month_per
                  ,NULL               rate_last_quater_per
                  ,NULL               rate_last_year_per
                  ,NULL               rate_last_period_per
                  ,index_ranking
                  ,0                  index_ranking_cha
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
            ,NULL                accu_index_value_d
            ,NULL                accu_index_value_m
            ,NULL                accu_index_value_q
            ,NULL                accu_index_value_y
            ,NULL                rate_up_day
            ,rate_last_month
            ,NULL                rate_last_quater
            ,NULL                rate_last_year
            ,NULL                rate_last_period
            ,NULL                rate_up_day_per
            ,rate_last_month_per
            ,NULL                rate_last_quater_per
            ,NULL                rate_last_year_per
            ,NULL                rate_last_period_per
            ,index_ranking
            ,0                   index_ranking_cha
            ,
             
             unit
            ,frequency
            ,measure_no
            ,index_measure
            ,bu_type
            
            FROM   tmp_lm_data
            
            UNION ALL
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL                 accu_index_value_d
                  ,NULL                 accu_index_value_m
                  ,NULL                 accu_index_value_q
                  ,NULL                 accu_index_value_y
                  ,NULL                 rate_up_day
                  ,NULL                 rate_last_month
                  ,rate_last_quater
                  ,NULL                 rate_last_year
                  ,NULL                 rate_last_period
                  ,NULL                 rate_up_day_per
                  ,NULL                 rate_last_month_per
                  ,rate_last_quater_per
                  ,NULL                 rate_last_year_per
                  ,NULL                 rate_last_period_per
                  ,index_ranking
                  ,0                    index_ranking_cha
                  ,
                   
                   unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            
            FROM   tmp_lq_data
            UNION ALL
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL               accu_index_value_d
                  ,NULL               accu_index_value_m
                  ,NULL               accu_index_value_q
                  ,NULL               accu_index_value_y
                  ,NULL               rate_up_day
                  ,NULL               rate_last_month
                  ,NULL               rate_last_quater
                  ,rate_last_year
                  ,NULL               rate_last_period
                  ,NULL               rate_up_day_per
                  ,NULL               rate_last_month_per
                  ,NULL               rate_last_quater_per
                  ,rate_last_year_per
                  ,NULL               rate_last_period_per
                  ,index_ranking
                  ,0                  index_ranking_cha
                  ,
                   
                   unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            
            FROM   tmp_ly_data
            
            UNION ALL
            SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,NULL                 accu_index_value_d
                  ,NULL                 accu_index_value_m
                  ,NULL                 accu_index_value_q
                  ,NULL                 accu_index_value_y
                  ,NULL                 rate_up_day
                  ,NULL                 rate_last_month
                  ,NULL                 rate_last_quater
                  ,NULL                 rate_last_year
                  ,rate_last_period
                  ,NULL                 rate_up_day_per
                  ,NULL                 rate_last_month_per
                  ,NULL                 rate_last_quater_per
                  ,NULL                 rate_last_year_per
                  ,rate_last_period_per
                  ,index_ranking
                  ,0                    index_ranking_cha
                  ,
                   
                   unit
                  ,frequency
                  ,measure_no
                  ,index_measure
                  ,bu_type
            
            FROM   tmp_yoy_data
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.index_ranking
             ,mcyy_bu_analysis_tmp.index_ranking_cha
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
             ,mcyy_bu_analysis_tmp.bu_type
    
    ;

COMMIT;


-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${idl_schema}.mcyy_bu_analysis to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);