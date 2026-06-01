/*
Purpose:    进店客户数-D层人员及风险分析表:数据来源于智能网点
Author:     Sunline/谢婉宜
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_human_risk_ncts_wd020101
Createdate: 20210426
Logs:
--1、89开头的虚拟机构，数据归纳到总行
--2、800001营运管理部，数据归到总行
--3、xx分行营运管理部，数据归到分行
-- 生成的IDL层表 ：mcyy_human_risk
-- 以下为依赖了上游的表 :
-- msl_nibs_cq_qm_queueserial_log
-- 以下为依赖的参数表 :
-- mcyy_index_define           -- 指标表清单
-- mcyy_orga_para              -- 总分支机构表

*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.mcyy_human_risk truncate subpartition p_${batch_date}_cust_cnt;
commit;

-- 2.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.mcyy_human_risk add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_cust_cnt values ('CUST_CNT')
                                              )
;
alter table ${idl_schema}.mcyy_human_risk modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_cust_cnt values ('CUST_CNT')
;

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;

set serveroutput  on 

DECLARE
    CURSOR cur_index_no IS
        SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
        FROM   mcyy_index_define t1
        LEFT   JOIN mcyy_dim_index t2
        ON     t1.index_no = t2.index_no
        LEFT   JOIN mcyy_dim_define t3
        ON     t2.dim_class = t3.dim_class
        AND    t3.dim_class_name IS NOT NULL
        WHERE  t1.index_no in ('WD020101');
        
BEGIN 
 FOR rec_index_no IN cur_index_no
 LOOP
INSERT /*+ append */
INTO ${idl_schema}.mcyy_human_risk
    (etl_dt --数据日期  
    ,etl_timestamp -- ETL处理时间戳
    ,index_no --  指标编码
    ,index_name --  指标名称
    ,org_no --  机构编码
    ,org_name --  机构名称
    ,super_org_no --  上级机构编码
    ,bu_type --业务品种
    ,ques_level --  问题单等级
    ,accu_index_value_d --  当日累计
    ,accu_index_value_m --  当月累计
    ,accu_index_value_q --  当季累计
    ,accu_index_value_y --  当年累计
    ,rate_up_day --  比上日
    ,rate_last_month --  比上月
    ,rate_last_quater --  比上季
    ,rate_last_year --  比上年
    ,rate_last_period --  同比
    ,rate_up_day_per --  比上日百分比
    ,rate_last_month_per --  比上月百分比
    ,rate_last_quater_per --  比上季百分比
    ,rate_last_year_per --  比上年百分比
    ,rate_last_period_per --  同比百分比
    ,index_ranking --  当前排名
    ,index_ranking_cha --  排名变动
    ,unit --  单位
    ,frequency --  频度
    ,measure_no --  度量编号
    ,index_measure --  度量名称
    ,source_sys --来源系统
     
     )

    WITH tmp_td_initza AS
    --当日数据初始化
     (SELECT t3.index_no AS index_no --  指标编码
            ,t3.index_name_mcs AS index_name --  指标名称
            ,t1.org_no AS org_no --  机构编码
            ,t1.org_name AS org_name --  机构名称
            ,t1.super_org_no AS super_org_no --  上级机构编码
            ,rec_index_no.bu_type as bu_type --业务品种
            ,NULL AS ques_level --  问题单等级
            ,CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.tot_prob_qtty
                              ,0)) over(PARTITION BY t3.index_no)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.tot_prob_qtty
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3))
                 ELSE
                  coalesce(t2.tot_prob_qtty
                          ,0)
             END AS accu_index_value_d --当日累计
            ,rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY coalesce(t2.tot_prob_qtty, 0) DESC) AS index_ranking --当前排名
            ,t3.unit AS unit --  单位
            ,t3.frequency AS frequency --  频度
            ,'001' AS measure_no --  度量编号
            ,t3.index_measure AS index_measure --  度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN
      --新一代改造
      /*(SELECT (CASE
           WHEN substr(t.branch
                      ,1
                      ,2) = '89'
                OR t.branch = '800001' THEN
            '000000'
           WHEN t.branch LIKE '%001'
                                  AND substr(t.branch
                                            ,1
                                            ,2) != '89'
                                  AND t.branch != '800001' THEN
                              substr(t.branch
                                    ,1
                                    ,3)
                             ELSE
                              t.branch
       END) AS org_no
      ,fun_code_conv(t.custtype_i
                    ,'WD020101')  AS bu_type
      ,COUNT(1) AS tot_prob_qtty
FROM   ${itl_schema}.itl_edw_ncts_bt_qm_queue_his t --叫号机系统：排队系统流水信息表-历史
WHERE  substr(work_date
             ,1
             ,8) = '${batch_date}'
GROUP  BY (CASE
              WHEN substr(t.branch
                         ,1
                         ,2) = '89'
                   OR t.branch = '800001' THEN
               '000000'
              WHEN t.branch LIKE '%001'
                                  AND substr(t.branch
                                            ,1
                                            ,2) != '89'
                                  AND t.branch != '800001' THEN
                              substr(t.branch
                                    ,1
                                    ,3)
                             ELSE
                              t.branch
          END)
         ,t.custtype_i) t2 */
         (SELECT (CASE
           WHEN substr(t.BRNO
                      ,1
                      ,2) = '89'
                OR t.BRNO = '800001' THEN
            '000000'
           WHEN t.BRNO LIKE '%001'
                                  AND substr(t.BRNO
                                            ,1
                                            ,2) != '89'
                                  AND t.BRNO != '800001' THEN
                              substr(t.BRNO
                                    ,1
                                    ,3)
                             ELSE
                              t.BRNO
       END) AS org_no
      ,fun_code_conv(t.CUSTGRD
                    ,'WD020101')  AS bu_type
      ,COUNT(1) AS tot_prob_qtty
FROM   ${msl_schema}.msl_nibs_cq_qm_queueserial_log t  --智能网点系统：排队流水表
WHERE  substr(WORKDATE
             ,1
             ,8) = '${batch_date}'
GROUP  BY (CASE
              WHEN substr(t.BRNO
                         ,1
                         ,2) = '89'
                   OR t.BRNO = '800001' THEN
               '000000'
              WHEN t.BRNO LIKE '%001'
                                  AND substr(t.BRNO
                                            ,1
                                            ,2) != '89'
                                  AND t.BRNO != '800001' THEN
                              substr(t.BRNO
                                    ,1
                                    ,3)
                             ELSE
                              t.BRNO
          END)
         ,t.CUSTGRD) t2
        
                  ON t2.org_no = t1.org_no
                  and  rec_index_no.bu_type = t2.bu_type 
                  INNER JOIN ${idl_schema}.mcyy_index_define t3 
                  ON t3.index_no_mcs ='WD020101'
                  AND rec_index_no.index_no = t3.index_no_mcs),
    
    --取上日数据来做日比较类计算
     tmp_ld_data AS (SELECT t1.index_no
                           , ---- 指标编码
                            t1.index_name
                           , -- 指标名称
                            t1.org_no
                           , -- 机构编码
                            t1.org_name
                           , -- 机构名称
                            t1.super_org_no
                           , -- 上级机构编码
                           t1.bu_type
                           , -- 业务品种
                            t1.ques_level
                           , --问题单等级
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
                                          ,'mm') =
                                     to_date('${batch_date}'
                                            ,'yyyymmdd') THEN
                                 t1.accu_index_value_d
                                ELSE
                                 coalesce(t1.accu_index_value_d
                                         ,0) +
                                 coalesce(t2.accu_index_value_m
                                         ,0)
                            END AS accu_index_value_m --当月累计
                            --当季初取当日数据作为当季累计，否则在上日的数据基础上累加
                           ,CASE
                                WHEN trunc(to_date('${batch_date}'
                                                  ,'yyyymmdd')
                                          ,'Q') =
                                     to_date('${batch_date}'
                                            ,'yyyymmdd') THEN
                                 t1.accu_index_value_d
                                ELSE
                                 coalesce(t1.accu_index_value_d
                                         ,0) +
                                 coalesce(t2.accu_index_value_q
                                         ,0)
                            END AS accu_index_value_q --当季累计 
                            --当年初取当日数据作为当年累计，否则在上日的数据基础上累加
                           ,CASE
                                WHEN trunc(to_date('${batch_date}'
                                                  ,'yyyymmdd')
                                          ,'yy') =
                                     to_date('${batch_date}'
                                            ,'yyyymmdd') THEN
                                 t1.accu_index_value_d
                                ELSE
                                 coalesce(t1.accu_index_value_d
                                         ,0) +
                                 coalesce(t2.accu_index_value_y
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
                                                ,0) -
                                       coalesce(t2.accu_index_value_d
                                                ,0)) /
                                       coalesce(t2.accu_index_value_d
                                               ,0)
                                      ,6)
                            END AS rate_up_day_per --比上日百分比 
                           ,rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY t1.accu_index_value_d DESC) - t2.index_ranking AS index_ranking_cha --排名变动                                                  
                     FROM   tmp_td_initza t1 -- 当日数据
                     LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上日数据
                     ON     t1.index_no = t2.index_no
                     AND    t1.org_no = t2.org_no
                     AND    t1.bu_type = t2.bu_type
                     AND    t2.etl_dt =
                            to_date('${batch_date}'
                                    ,'yyyymmdd') - 1),
    
    --取上月数据来做月比较类计算
     tmp_lm_data AS (SELECT t1.index_no
                           , ---- 指标编码
                            t1.index_name
                           , -- 指标名称
                            t1.org_no
                           , -- 机构编码
                            t1.org_name
                           , -- 机构名称
                            t1.super_org_no
                           , -- 上级机构编码
                           t1.bu_type
                           , -- 业务品种
                            t1.ques_level
                           , --问题单等级
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
                                                  ,0) AS rate_last_month --比上月  
                           ,CASE
                                WHEN coalesce(t2.accu_index_value_d
                                             ,0) = 0 THEN
                                 0
                                ELSE
                                 round((coalesce(t2.accu_index_value_d
                                                ,0) -
                                       coalesce(t2.accu_index_value_d
                                                ,0)) /
                                       coalesce(t2.accu_index_value_d
                                               ,0)
                                      ,6)
                            END AS rate_last_month_per --比上月百分比     
                     FROM   tmp_td_initza t1 -- 当日数据
                     LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上月末数据
                     ON     t1.index_no = t2.index_no
                     AND    t1.org_no = t2.org_no
                     AND    t1.bu_type = t2.bu_type
                     AND    t2.etl_dt = trunc(to_date('${batch_date}'
                                                     ,'yyyymmdd')
                                             ,'mm') - 1),
    
    --取上季数据来做季比较类计算
     tmp_lq_data AS (SELECT t1.index_no
                           , ---- 指标编码
                            t1.index_name
                           , -- 指标名称
                            t1.org_no
                           , -- 机构编码
                            t1.org_name
                           , -- 机构名称
                            t1.super_org_no
                           , -- 上级机构编码
                           t1.bu_type
                           , -- 业务品种
                            t1.ques_level
                           , --问题单等级
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
                                                  ,0) AS rate_last_quater --比上季 
                           ,CASE
                                WHEN coalesce(t2.accu_index_value_d
                                             ,0) = 0 THEN
                                 0
                                ELSE
                                 round((coalesce(t2.accu_index_value_d
                                                ,0) -
                                       coalesce(t2.accu_index_value_d
                                                ,0)) /
                                       coalesce(t2.accu_index_value_d
                                               ,0)
                                      ,6)
                            END AS rate_last_quater_per --比上季百分比   
                     FROM   tmp_td_initza t1 -- 当日数据
                     LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上季末数据
                     ON     t1.index_no = t2.index_no
                     AND    t1.org_no = t2.org_no
                     AND    t1.bu_type = t2.bu_type
                     AND    t2.etl_dt = trunc(to_date('${batch_date}'
                                                     ,'yyyymmdd')
                                             ,'Q') - 1),
    
    --取上年数据来做年比较类计算
     tmp_ly_data AS (SELECT t1.index_no
                           , ---- 指标编码
                            t1.index_name
                           , -- 指标名称
                            t1.org_no
                           , -- 机构编码
                            t1.org_name
                           , -- 机构名称
                            t1.super_org_no
                           , -- 上级机构编码
                           t1.bu_type
                           , -- 业务品种
                            t1.ques_level
                           , --问题单等级
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
                                                  ,0) AS rate_last_year --比上年
                           ,CASE
                                WHEN coalesce(t2.accu_index_value_d
                                             ,0) = 0 THEN
                                 0
                                ELSE
                                 round((coalesce(t2.accu_index_value_d
                                                ,0) -
                                       coalesce(t2.accu_index_value_d
                                                ,0)) /
                                       coalesce(t2.accu_index_value_d
                                               ,0)
                                      ,6)
                            END AS rate_last_year_per --比上年百分比   
                     FROM   tmp_td_initza t1 -- 当日数据
                     LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年末数据
                     ON     t1.index_no = t2.index_no
                     AND    t1.org_no = t2.org_no
                     AND    t1.bu_type = t2.bu_type
                     AND    t2.etl_dt = trunc(to_date('${batch_date}'
                                                     ,'yyyymmdd')
                                             ,'yy') - 1),
    
    --取上年同期数据来做同期比较类计算 
     tmp_yoy_data AS (SELECT t1.index_no
                            , ---- 指标编码
                             t1.index_name
                            , -- 指标名称
                             t1.org_no
                            , -- 机构编码
                             t1.org_name
                            , -- 机构名称
                             t1.super_org_no
                            , -- 上级机构编码
                            t1.bu_type
                           , -- 业务品种
                             t1.ques_level
                            , --问题单等级
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
                                  round((coalesce(t2.accu_index_value_d
                                                 ,0) -
                                        coalesce(t2.accu_index_value_d
                                                 ,0)) /
                                        coalesce(t2.accu_index_value_d
                                                ,0)
                                       ,6)
                             END AS rate_last_period_per --同比百分比   
                      FROM   tmp_td_initza t1 -- 当日数据
                      LEFT   JOIN ${idl_schema}.mcyy_human_risk t2 --上年同期数据
                      ON     t1.index_no = t2.index_no
                      AND    t1.org_no = t2.org_no
                      AND    t1.bu_type = t2.bu_type
                      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                                           ,'yyyymmdd')
                                                   ,-12))
    
        SELECT to_date('${batch_date}'
                ,'yyyymmdd') etl_dt -- 数据日期
        ,to_timestamp('${batch_timestamp}'
                     ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
        ,mcyy_human_risk_tmp.index_no --  指标编码
        ,mcyy_human_risk_tmp.index_name --  指标名称
        ,mcyy_human_risk_tmp.org_no --  机构编码
        ,mcyy_human_risk_tmp.org_name --  机构名称
        ,mcyy_human_risk_tmp.super_org_no --  上级机构编码
        ,mcyy_human_risk_tmp.bu_type --业务品种
        ,mcyy_human_risk_tmp.ques_level --  问题单等级
        ,SUM(mcyy_human_risk_tmp.accu_index_value_d) --  当日累计
        ,SUM(mcyy_human_risk_tmp.accu_index_value_m) --  当月累计
        ,SUM(mcyy_human_risk_tmp.accu_index_value_q) --  当季累计
        ,SUM(mcyy_human_risk_tmp.accu_index_value_y) --  当年累计
        ,SUM(mcyy_human_risk_tmp.rate_up_day) --  比上日
        ,SUM(mcyy_human_risk_tmp.rate_last_month) --  比上月
        ,SUM(mcyy_human_risk_tmp.rate_last_quater) --  比上季
        ,SUM(mcyy_human_risk_tmp.rate_last_year) --  比上年
        ,SUM(mcyy_human_risk_tmp.rate_last_period) --  同比
        ,SUM(mcyy_human_risk_tmp.rate_up_day_per) --  比上日百分比
        ,SUM(mcyy_human_risk_tmp.rate_last_month_per) --  比上月百分比
        ,SUM(mcyy_human_risk_tmp.rate_last_quater_per) --  比上季百分比
        ,SUM(mcyy_human_risk_tmp.rate_last_year_per) --  比上年百分比
        ,SUM(mcyy_human_risk_tmp.rate_last_period_per) --  同比百分比
        ,mcyy_human_risk_tmp.index_ranking --  当前排名
        ,mcyy_human_risk_tmp.index_ranking_cha --  排名变动
        ,mcyy_human_risk_tmp.unit --  单位
        ,mcyy_human_risk_tmp.frequency --  频度
        ,mcyy_human_risk_tmp.measure_no --  度量编号
        ,mcyy_human_risk_tmp.index_measure --  度量名称
        ,'CUST_CNT' source_sys --来源系统
        FROM   (SELECT index_no
                ,index_name
                ,org_no
                ,org_name
                ,super_org_no
                ,bu_type
                ,ques_level
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
          FROM   tmp_td_initza
          
          UNION ALL
          
          SELECT index_no
                ,index_name
                ,org_no
                ,org_name
                ,super_org_no
                ,bu_type
                ,ques_level
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
          FROM   tmp_ld_data
          
          UNION ALL
          SELECT
          
           index_no
          ,index_name
          ,org_no
          ,org_name
          ,super_org_no
          ,bu_type
          ,ques_level
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
          FROM   tmp_lm_data
          
          UNION ALL
          SELECT index_no
                ,index_name
                ,org_no
                ,org_name
                ,super_org_no
                ,bu_type
                ,ques_level
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
          
          FROM   tmp_lq_data
          UNION ALL
          SELECT index_no
                ,index_name
                ,org_no
                ,org_name
                ,super_org_no
                ,bu_type
                ,ques_level
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
          FROM   tmp_ly_data
          
          UNION ALL
          SELECT index_no
                ,index_name
                ,org_no
                ,org_name
                ,super_org_no
                ,bu_type
                ,ques_level
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
          FROM   tmp_yoy_data
          
          ) mcyy_human_risk_tmp
        
        GROUP  BY mcyy_human_risk_tmp.index_no -- 指标编码
           ,mcyy_human_risk_tmp.index_name -- 指标名称
           ,mcyy_human_risk_tmp.org_no -- 机构编码
           ,mcyy_human_risk_tmp.org_name -- 机构名称
           ,mcyy_human_risk_tmp.super_org_no -- 上级机构编码
           ,mcyy_human_risk_tmp.bu_type -- 业务品种
           ,mcyy_human_risk_tmp.ques_level --  问题单等级
           ,mcyy_human_risk_tmp.index_ranking --当前排名
           ,mcyy_human_risk_tmp.index_ranking_cha --排名变动
           ,mcyy_human_risk_tmp.unit -- 单位
           ,mcyy_human_risk_tmp.frequency -- 频度
           ,mcyy_human_risk_tmp.measure_no --- 度量编号
           ,mcyy_human_risk_tmp.index_measure -- 度量名称
        ;


COMMIT;

END LOOP;


end;
/

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${idl_schema}.mcyy_human_risk to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_human_risk',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);