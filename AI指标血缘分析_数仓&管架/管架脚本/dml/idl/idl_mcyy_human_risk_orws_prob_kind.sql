/*
Purpose:    高、中、低风险问题单种类占比-D层人员及风险分析表:数据来源于营运预警ORWS
Author:     Sunline/谢婉宜
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_human_risk_orws_prob_kind
Createdate: 20210426
Logs:
--1、89开头的虚拟机构，数据归纳到总行
--2、800001营运管理部，数据归到总行
--3、xx分行营运管理部，数据归到分行
-- 生成的IDL层表 ：mcyy_human_risk
-- 以下为依赖了上游的表 :
-- itl_orws_yygj
-- 以下为依赖的参数表 :
-- mcyy_index_define           -- 指标表清单
-- mcyy_orga_para              -- 总分支机构表

*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;


alter table ${idl_schema}.mcyy_human_risk truncate subpartition p_${batch_date}_prob_kind;

-- 1.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.mcyy_human_risk add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_prob_kind values ('PROB_KIND')
                                              )
;
alter table ${idl_schema}.mcyy_human_risk modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_prob_kind values ('PROB_KIND')
;


-- 2.1 基础指标数据处理

--2.1.1 第一组 高风险问题单种类笔数

--2.1.1.1 先将柜员数据插入到表
whenever sqlerror exit sql.sqlcode;
 INSERT INTO ${idl_schema}.mcyy_human_risk
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
    ,bu_type --业务品种
     )
    WITH tmp_vlm_bus_data AS
     (SELECT fun_code_conv(t1.type_name
                    ,'FX010101') AS bu_type --问题单种类代码
      ,SUM(t1.num) AS index_value --业务笔数
      ,CASE
           WHEN t1.problemer_no IS NULL THEN
            '其他'
           ELSE
            t1.problemer_no
       END AS org_no --柜员号 
      ,CASE
           WHEN t1.problemer_name IS NULL THEN
            '其他'
           ELSE
            t1.problemer_name
       END AS org_name --柜员名
      ,(CASE
           WHEN substr(t1.organnum
                      ,1
                      ,2) = '89'
                OR t1.organnum = '800001' THEN
            '800'
           WHEN t1.organnum LIKE '%001'
                AND substr(t1.organnum
                          ,1
                          ,2) != '89'
                AND t1.organnum != '800001' THEN
            substr(t1.organnum
                  ,1
                  ,3)
           ELSE
            t1.organnum
       END) AS super_org_no --机构号
FROM   ${itl_schema}.itl_orws_yygj t1 --营运预警直接生成结果表传输
WHERE  t1.task_date = to_date('${batch_date}'
                            ,'yyyymmdd')
AND    t1. risk_level = '3'
GROUP  BY t1.problemer_no, t1.organnum, t1.problemer_name,t1.type_name
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t2.org_no         AS org_no --柜员号
            ,nvl(t2.org_name,t2.org_no)     AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no   AS super_org_no
            , --柜员所属支行机构编码
             t2.index_value    AS accu_index_value_d
            , --当日累计
             NULL              AS index_ranking
            , --当前排名
             t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL              measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
            ,t2.bu_type        AS bu_type --业务品种
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_vlm_bus_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'FX010101' = t4.index_no_mcs
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
            ,t1.bu_type AS bu_type --业务品种      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上日数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd') - 1
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-1)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-3)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
    
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-12)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                           ,'yyyymmdd')
                                   ,-12)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no)
    
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_human_risk_tmp.index_no -- 指标编码
          ,mcyy_human_risk_tmp.index_name -- 指标名称
          ,mcyy_human_risk_tmp.org_no -- 机构编码
          ,mcyy_human_risk_tmp.org_name -- 机构名称
          ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_human_risk_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_human_risk_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_human_risk_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_human_risk_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_human_risk_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_human_risk_tmp.rate_last_period) -- 同比
          ,SUM(mcyy_human_risk_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_month_per) -- 比上月百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_quater_per) -- 比上季百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_year_per) -- 比上年百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_human_risk_tmp.index_ranking -- 当前排名
          ,mcyy_human_risk_tmp.index_ranking_cha -- 排名变动
          ,mcyy_human_risk_tmp.unit -- 单位
          ,mcyy_human_risk_tmp.frequency -- 频度
          ,mcyy_human_risk_tmp.measure_no --- 度量编号
          ,mcyy_human_risk_tmp.index_measure -- 度量名称
          ,'PROB_KIND' source_sys --来源系统
          ,mcyy_human_risk_tmp.bu_type --业务品种
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
            
            ) mcyy_human_risk_tmp
    
    GROUP  BY mcyy_human_risk_tmp.index_no -- 指标编码
             ,mcyy_human_risk_tmp.index_name -- 指标名称
             ,mcyy_human_risk_tmp.org_no -- 机构编码
             ,mcyy_human_risk_tmp.org_name -- 机构名称
             ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
             ,mcyy_human_risk_tmp.index_ranking
             ,mcyy_human_risk_tmp.index_ranking_cha
             ,mcyy_human_risk_tmp.unit -- 单位
             ,mcyy_human_risk_tmp.frequency -- 频度
             ,mcyy_human_risk_tmp.measure_no --- 度量编号
             ,mcyy_human_risk_tmp.index_measure -- 度量名称
             ,mcyy_human_risk_tmp.bu_type -- 业务品种
    
    ;

COMMIT;

--2.1.1.2 将柜员数据汇总成总分支行数据

whenever sqlerror EXIT sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_human_risk
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
    ,bu_type --业务品种
     )
    WITH tmp_vlm_bus_data_person AS
     ( --柜员汇总数据
      SELECT SUM(t.accu_index_value_d) AS index_value
             ,t.super_org_no org_no
             ,t.bu_type
      FROM   mcyy_human_risk t --根据柜员粒度的事实数据基础，汇总成分行总行
      WHERE  to_char(t.etl_dt
                    ,'yyyymmdd') = to_date('${batch_date}'
                                          ,'yyyyMMdd')
      AND    t.index_no = 'FX010101'
      GROUP  BY t.super_org_no, t.bu_type
      
      ),
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
             END AS accu_index_value_d
            , --当日累计
             NULL AS index_ranking
            , --当前排名
             t4.unit
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
                      AND    t3.dim_state = '1'
                      WHERE  t1.index_no = 'FX010101') dim_tab) t1 --可以考虑放到with子句
      LEFT   JOIN tmp_vlm_bus_data_person t2
      ON     t1.org_no = t2.org_no
      AND    t2.bu_type = t1.bu_type --前端需要不发生数据也生成分总行，所以这里写在ON里不用where过滤
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'FX010101' = t4.index_no_mcs),
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
            ,t1.bu_type AS bu_type --业务品种      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上日数据
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上月数据
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上季数据
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
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
          ,mcyy_human_risk_tmp.index_no -- 指标编码
          ,mcyy_human_risk_tmp.index_name -- 指标名称
          ,mcyy_human_risk_tmp.org_no -- 机构编码
          ,mcyy_human_risk_tmp.org_name -- 机构名称
          ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_human_risk_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_human_risk_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_human_risk_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_human_risk_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_human_risk_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_human_risk_tmp.rate_last_period) -- 同比
          ,SUM(mcyy_human_risk_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_month_per) -- 比上月百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_quater_per) -- 比上季百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_year_per) -- 比上年百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_human_risk_tmp.index_ranking -- 当前排名
          ,mcyy_human_risk_tmp.index_ranking_cha -- 排名变动
          ,mcyy_human_risk_tmp.unit -- 单位
          ,mcyy_human_risk_tmp.frequency -- 频度
          ,mcyy_human_risk_tmp.measure_no --- 度量编号
          ,mcyy_human_risk_tmp.index_measure -- 度量名称
          ,'PROB_KIND' source_sys --来源系统
          ,mcyy_human_risk_tmp.bu_type --业务品种
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
            
            ) mcyy_human_risk_tmp
    
    GROUP  BY mcyy_human_risk_tmp.index_no -- 指标编码
             ,mcyy_human_risk_tmp.index_name -- 指标名称
             ,mcyy_human_risk_tmp.org_no -- 机构编码
             ,mcyy_human_risk_tmp.org_name -- 机构名称
             ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
             ,mcyy_human_risk_tmp.index_ranking
             ,mcyy_human_risk_tmp.index_ranking_cha
             ,mcyy_human_risk_tmp.unit -- 单位
             ,mcyy_human_risk_tmp.frequency -- 频度
             ,mcyy_human_risk_tmp.measure_no --- 度量编号
             ,mcyy_human_risk_tmp.index_measure -- 度量名称
             ,mcyy_human_risk_tmp.bu_type -- 业务品种
    
    ;

COMMIT;


--2.1.1 第二组 中风险问题单种类笔数

--2.1.1.1 先将柜员数据插入到表
whenever sqlerror exit sql.sqlcode;
 INSERT INTO ${idl_schema}.mcyy_human_risk
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
    ,bu_type --业务品种
     )
    WITH tmp_vlm_bus_data AS
     (SELECT fun_code_conv(t1.type_name
                    ,'FX020101') AS bu_type --问题单种类代码
      ,SUM(t1.num) AS index_value --业务笔数
      ,CASE
           WHEN t1.problemer_no IS NULL THEN
            '其他'
           ELSE
            t1.problemer_no
       END AS org_no --柜员号 
      ,CASE
           WHEN t1.problemer_name IS NULL THEN
            '其他'
           ELSE
            t1.problemer_name
       END AS org_name --柜员名
      ,(CASE
           WHEN substr(t1.organnum
                      ,1
                      ,2) = '89'
                OR t1.organnum = '800001' THEN
            '800'
           WHEN t1.organnum LIKE '%001'
                AND substr(t1.organnum
                          ,1
                          ,2) != '89'
                AND t1.organnum != '800001' THEN
            substr(t1.organnum
                  ,1
                  ,3)
           ELSE
            t1.organnum
       END) AS super_org_no --机构号
FROM   ${itl_schema}.itl_orws_yygj t1 --营运预警直接生成结果表传输
WHERE  t1.task_date = to_date('${batch_date}'
                            ,'yyyymmdd')
AND    t1. risk_level = '2'
GROUP  BY t1.problemer_no, t1.organnum, t1.problemer_name,t1.type_name
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t2.org_no         AS org_no --柜员号
            ,nvl(t2.org_name,t2.org_no)     AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no   AS super_org_no
            , --柜员所属支行机构编码
             t2.index_value    AS accu_index_value_d
            , --当日累计
             NULL              AS index_ranking
            , --当前排名
             t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL              measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
            ,t2.bu_type        AS bu_type --业务品种
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_vlm_bus_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'FX020101' = t4.index_no_mcs
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
            ,t1.bu_type AS bu_type --业务品种      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上日数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd') - 1
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -1)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -3)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
    
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -12)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                           ,'yyyymmdd')
                                   ,-12)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no)
    
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_human_risk_tmp.index_no -- 指标编码
          ,mcyy_human_risk_tmp.index_name -- 指标名称
          ,mcyy_human_risk_tmp.org_no -- 机构编码
          ,mcyy_human_risk_tmp.org_name -- 机构名称
          ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_human_risk_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_human_risk_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_human_risk_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_human_risk_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_human_risk_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_human_risk_tmp.rate_last_period) -- 同比
          ,SUM(mcyy_human_risk_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_month_per) -- 比上月百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_quater_per) -- 比上季百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_year_per) -- 比上年百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_human_risk_tmp.index_ranking -- 当前排名
          ,mcyy_human_risk_tmp.index_ranking_cha -- 排名变动
          ,mcyy_human_risk_tmp.unit -- 单位
          ,mcyy_human_risk_tmp.frequency -- 频度
          ,mcyy_human_risk_tmp.measure_no --- 度量编号
          ,mcyy_human_risk_tmp.index_measure -- 度量名称
          ,'PROB_KIND' source_sys --来源系统
          ,mcyy_human_risk_tmp.bu_type --业务品种
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
            
            ) mcyy_human_risk_tmp
    
    GROUP  BY mcyy_human_risk_tmp.index_no -- 指标编码
             ,mcyy_human_risk_tmp.index_name -- 指标名称
             ,mcyy_human_risk_tmp.org_no -- 机构编码
             ,mcyy_human_risk_tmp.org_name -- 机构名称
             ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
             ,mcyy_human_risk_tmp.index_ranking
             ,mcyy_human_risk_tmp.index_ranking_cha
             ,mcyy_human_risk_tmp.unit -- 单位
             ,mcyy_human_risk_tmp.frequency -- 频度
             ,mcyy_human_risk_tmp.measure_no --- 度量编号
             ,mcyy_human_risk_tmp.index_measure -- 度量名称
             ,mcyy_human_risk_tmp.bu_type -- 业务品种
    
    ;

COMMIT;

--2.1.1.2 将柜员数据汇总成总分支行数据

whenever sqlerror EXIT sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_human_risk
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
    ,bu_type --业务品种
     )
    WITH tmp_vlm_bus_data_person AS
     ( --柜员汇总数据
      SELECT SUM(t.accu_index_value_d) AS index_value
             ,t.super_org_no org_no
             ,t.bu_type
      FROM   mcyy_human_risk t --根据柜员粒度的事实数据基础，汇总成分行总行
      WHERE  to_char(t.etl_dt
                    ,'yyyymmdd') = to_date('${batch_date}'
                                          ,'yyyyMMdd')
      AND    t.index_no = 'FX020101'
      GROUP  BY t.super_org_no, t.bu_type
      
      ),
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
             END AS accu_index_value_d
            , --当日累计
             NULL AS index_ranking
            , --当前排名
             t4.unit
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
                      AND    t3.dim_state = '1'
                      WHERE  t1.index_no = 'FX020101') dim_tab) t1 --可以考虑放到with子句
      LEFT   JOIN tmp_vlm_bus_data_person t2
      ON     t1.org_no = t2.org_no
      AND    t2.bu_type = t1.bu_type --前端需要不发生数据也生成分总行，所以这里写在ON里不用where过滤
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'FX020101' = t4.index_no_mcs),
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
            ,t1.bu_type AS bu_type --业务品种      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上日数据
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -1)
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -3)
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -12)
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
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
          ,mcyy_human_risk_tmp.index_no -- 指标编码
          ,mcyy_human_risk_tmp.index_name -- 指标名称
          ,mcyy_human_risk_tmp.org_no -- 机构编码
          ,mcyy_human_risk_tmp.org_name -- 机构名称
          ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_human_risk_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_human_risk_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_human_risk_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_human_risk_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_human_risk_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_human_risk_tmp.rate_last_period) -- 同比
          ,SUM(mcyy_human_risk_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_month_per) -- 比上月百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_quater_per) -- 比上季百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_year_per) -- 比上年百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_human_risk_tmp.index_ranking -- 当前排名
          ,mcyy_human_risk_tmp.index_ranking_cha -- 排名变动
          ,mcyy_human_risk_tmp.unit -- 单位
          ,mcyy_human_risk_tmp.frequency -- 频度
          ,mcyy_human_risk_tmp.measure_no --- 度量编号
          ,mcyy_human_risk_tmp.index_measure -- 度量名称
          ,'PROB_KIND' source_sys --来源系统
          ,mcyy_human_risk_tmp.bu_type --业务品种
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
            
            ) mcyy_human_risk_tmp
    
    GROUP  BY mcyy_human_risk_tmp.index_no -- 指标编码
             ,mcyy_human_risk_tmp.index_name -- 指标名称
             ,mcyy_human_risk_tmp.org_no -- 机构编码
             ,mcyy_human_risk_tmp.org_name -- 机构名称
             ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
             ,mcyy_human_risk_tmp.index_ranking
             ,mcyy_human_risk_tmp.index_ranking_cha
             ,mcyy_human_risk_tmp.unit -- 单位
             ,mcyy_human_risk_tmp.frequency -- 频度
             ,mcyy_human_risk_tmp.measure_no --- 度量编号
             ,mcyy_human_risk_tmp.index_measure -- 度量名称
             ,mcyy_human_risk_tmp.bu_type -- 业务品种
    
    ;

COMMIT;


--2.1.1 第三组 低风险问题单种类笔数

--2.1.1.1 先将柜员数据插入到表
whenever sqlerror exit sql.sqlcode;
 INSERT INTO ${idl_schema}.mcyy_human_risk
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
    ,bu_type --业务品种
     )
    WITH tmp_vlm_bus_data AS
     (SELECT fun_code_conv(t1.type_name
                    ,'FX030101') AS bu_type --问题单种类代码
      ,SUM(t1.num) AS index_value --业务笔数
      ,CASE
           WHEN t1.problemer_no IS NULL THEN
            '其他'
           ELSE
            t1.problemer_no
       END AS org_no --柜员号 
      ,CASE
           WHEN t1.problemer_name IS NULL THEN
            '其他'
           ELSE
            t1.problemer_name
       END AS org_name --柜员名
      ,(CASE
           WHEN substr(t1.organnum
                      ,1
                      ,2) = '89'
                OR t1.organnum = '800001' THEN
            '800'
           WHEN t1.organnum LIKE '%001'
                AND substr(t1.organnum
                          ,1
                          ,2) != '89'
                AND t1.organnum != '800001' THEN
            substr(t1.organnum
                  ,1
                  ,3)
           ELSE
            t1.organnum
       END) AS super_org_no --机构号
FROM   ${itl_schema}.itl_orws_yygj t1 --营运预警直接生成结果表传输
WHERE  t1.task_date = to_date('${batch_date}'
                            ,'yyyymmdd')
AND    t1. risk_level = '1'
GROUP  BY t1.problemer_no, t1.organnum, t1.problemer_name,t1.type_name
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t2.org_no         AS org_no --柜员号
            ,nvl(t2.org_name,t2.org_no)     AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no   AS super_org_no
            , --柜员所属支行机构编码
             t2.index_value    AS accu_index_value_d
            , --当日累计
             NULL              AS index_ranking
            , --当前排名
             t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL              measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
            ,t2.bu_type        AS bu_type --业务品种
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_vlm_bus_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'FX030101' = t4.index_no_mcs
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
            ,t1.bu_type AS bu_type --业务品种      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上日数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd') - 1
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -1)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -3)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
    
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -12)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no),
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                           ,'yyyymmdd')
                                   ,-12)
      AND    t1.bu_type = t2.bu_type
      AND    t1.super_org_no = t2.super_org_no)
    
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_human_risk_tmp.index_no -- 指标编码
          ,mcyy_human_risk_tmp.index_name -- 指标名称
          ,mcyy_human_risk_tmp.org_no -- 机构编码
          ,mcyy_human_risk_tmp.org_name -- 机构名称
          ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_human_risk_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_human_risk_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_human_risk_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_human_risk_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_human_risk_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_human_risk_tmp.rate_last_period) -- 同比
          ,SUM(mcyy_human_risk_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_month_per) -- 比上月百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_quater_per) -- 比上季百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_year_per) -- 比上年百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_human_risk_tmp.index_ranking -- 当前排名
          ,mcyy_human_risk_tmp.index_ranking_cha -- 排名变动
          ,mcyy_human_risk_tmp.unit -- 单位
          ,mcyy_human_risk_tmp.frequency -- 频度
          ,mcyy_human_risk_tmp.measure_no --- 度量编号
          ,mcyy_human_risk_tmp.index_measure -- 度量名称
          ,'PROB_KIND' source_sys --来源系统
          ,mcyy_human_risk_tmp.bu_type --业务品种
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
            
            ) mcyy_human_risk_tmp
    
    GROUP  BY mcyy_human_risk_tmp.index_no -- 指标编码
             ,mcyy_human_risk_tmp.index_name -- 指标名称
             ,mcyy_human_risk_tmp.org_no -- 机构编码
             ,mcyy_human_risk_tmp.org_name -- 机构名称
             ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
             ,mcyy_human_risk_tmp.index_ranking
             ,mcyy_human_risk_tmp.index_ranking_cha
             ,mcyy_human_risk_tmp.unit -- 单位
             ,mcyy_human_risk_tmp.frequency -- 频度
             ,mcyy_human_risk_tmp.measure_no --- 度量编号
             ,mcyy_human_risk_tmp.index_measure -- 度量名称
             ,mcyy_human_risk_tmp.bu_type -- 业务品种
    
    ;

COMMIT;

--2.1.1.2 将柜员数据汇总成总分支行数据

whenever sqlerror EXIT sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_human_risk
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
    ,bu_type --业务品种
     )
    WITH tmp_vlm_bus_data_person AS
     ( --柜员汇总数据
      SELECT SUM(t.accu_index_value_d) AS index_value
             ,t.super_org_no org_no
             ,t.bu_type
      FROM   mcyy_human_risk t --根据柜员粒度的事实数据基础，汇总成分行总行
      WHERE  to_char(t.etl_dt
                    ,'yyyymmdd') = to_date('${batch_date}'
                                          ,'yyyyMMdd')
      AND    t.index_no = 'FX030101'
      GROUP  BY t.super_org_no, t.bu_type
      
      ),
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
             END AS accu_index_value_d
            , --当日累计
             NULL AS index_ranking
            , --当前排名
             t4.unit
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
                      AND    t3.dim_state = '1'
                      WHERE  t1.index_no = 'FX030101') dim_tab) t1 --可以考虑放到with子句
      LEFT   JOIN tmp_vlm_bus_data_person t2
      ON     t1.org_no = t2.org_no
      AND    t2.bu_type = t1.bu_type --前端需要不发生数据也生成分总行，所以这里写在ON里不用where过滤
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'FX030101' = t4.index_no_mcs),
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
            ,t1.bu_type AS bu_type --业务品种      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上日数据
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -1)
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -3)
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_ld_data t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}', 'yyyymmdd'), -12)
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
            ,t1.bu_type AS bu_type --业务品种      
      
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年数据
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
          ,mcyy_human_risk_tmp.index_no -- 指标编码
          ,mcyy_human_risk_tmp.index_name -- 指标名称
          ,mcyy_human_risk_tmp.org_no -- 机构编码
          ,mcyy_human_risk_tmp.org_name -- 机构名称
          ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_human_risk_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_human_risk_tmp.accu_index_value_y) -- 当年累计
          ,SUM(mcyy_human_risk_tmp.rate_up_day) -- 比上日
          ,SUM(mcyy_human_risk_tmp.rate_last_month) -- 比上月
          ,SUM(mcyy_human_risk_tmp.rate_last_quater) -- 比上季
          ,SUM(mcyy_human_risk_tmp.rate_last_year) -- 比上年
          ,SUM(mcyy_human_risk_tmp.rate_last_period) -- 同比
          ,SUM(mcyy_human_risk_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_month_per) -- 比上月百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_quater_per) -- 比上季百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_year_per) -- 比上年百分比
          ,SUM(mcyy_human_risk_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_human_risk_tmp.index_ranking -- 当前排名
          ,mcyy_human_risk_tmp.index_ranking_cha -- 排名变动
          ,mcyy_human_risk_tmp.unit -- 单位
          ,mcyy_human_risk_tmp.frequency -- 频度
          ,mcyy_human_risk_tmp.measure_no --- 度量编号
          ,mcyy_human_risk_tmp.index_measure -- 度量名称
          ,'PROB_KIND' source_sys --来源系统
          ,mcyy_human_risk_tmp.bu_type --业务品种
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
            
            ) mcyy_human_risk_tmp
    
    GROUP  BY mcyy_human_risk_tmp.index_no -- 指标编码
             ,mcyy_human_risk_tmp.index_name -- 指标名称
             ,mcyy_human_risk_tmp.org_no -- 机构编码
             ,mcyy_human_risk_tmp.org_name -- 机构名称
             ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
             ,mcyy_human_risk_tmp.index_ranking
             ,mcyy_human_risk_tmp.index_ranking_cha
             ,mcyy_human_risk_tmp.unit -- 单位
             ,mcyy_human_risk_tmp.frequency -- 频度
             ,mcyy_human_risk_tmp.measure_no --- 度量编号
             ,mcyy_human_risk_tmp.index_measure -- 度量名称
             ,mcyy_human_risk_tmp.bu_type -- 业务品种
    
    ;

COMMIT;

-- 3.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_human_risk',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

