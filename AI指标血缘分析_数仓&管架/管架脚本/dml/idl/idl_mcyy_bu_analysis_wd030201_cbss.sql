/*
Purpose:    个人开户数D层-业务分析实时表(WD030201):数据来源于核心系统（CBSS）,包括电子账户（IATS）
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_bu_analysis_wd030201_cbss
Createdate: 20210112
Logs:

-- 生成的IDL层表 ：mcyy_bu_analysis
-- 以下为依赖了数仓的表 :
--ITL_EDW_AGT_CUST_ACCT_SUB_ACCT_RELA_H
--ITL_EDW_CMM_DEP_ACCT_INFO
--itl_edw_cmm_dep_cust_acct_info
--itl_edw_agt_acct_change_rgst_b
--itl_edw_cmm_dep_cust_acct_info

-- 以下为依赖的参数表 :
-- mcyy_index_define           -- 指标表清单
-- mcyy_orga_para                   -- 总分支机构表
--1、89开头的虚拟机构，数据归纳到总行
--2、800001营运管理部，数据归到总行
--3、xx分行营运管理部，数据归到分行   
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${idl_schema}.mcyy_bu_analysis drop partition p_${batch_date};
drop table ${idl_schema}.TAB_ALL_ACT purge;

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
--alter table ${idl_schema}.mcyy_bu_analysis add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;

/*CREATE TABLE ${idl_schema}.TAB_ALL_ACT compress AS 
  SELECT T1.ACCT_ID, T1.SEQ_NUM, T1.ACCT_SUB_ACCT_ID
    FROM ITL_EDW_AGT_CUST_ACCT_SUB_ACCT_RELA_H T1
   WHERE T1.STAND_B_TYPE_CD = '01'
     AND NOT EXISTS
   (SELECT 1
            FROM ITL_EDW_CMM_DEP_ACCT_INFO T2
           WHERE T2.ACCT_ID = T1.ACCT_SUB_ACCT_ID
             AND (T2.DEP_KIND_CD IN ('P01', 'A15', 'IC1', 'S09') OR
                 T2.ACCT_USAGE_CD LIKE '2002%'))
     AND T1.START_DT <= to_date('${batch_date}'
                  ,'yyyymmdd')
     AND T1.END_DT > to_date('${batch_date}'
                  ,'yyyymmdd')
     AND T1.JOB_CD = 'cbssf1'
     AND T1.AGT_RELA_TYPE_CD = '14';*/
     
CREATE TABLE ${idl_schema}.TAB_ALL_ACT compress AS     
SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
      FROM   ${msl_schema}.msl_cbss_kna_accs t1
      WHERE  t1.accstp = '0'
      AND    NOT EXISTS
       (SELECT 1
              FROM   ${msl_schema}.msl_cbss_kna_dpac t2
              WHERE  (t2.debttp IN ('P01'
                                   ,'A15'
                                   ,'IC1'
                                   ,'S09') OR t2.acustg LIKE '2002%')
              AND    t2.acctid = t1.acctid)
      UNION ALL
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
      FROM   ${msl_schema}.msl_cbss_kna_accs_dele t1
      WHERE  t1.accstp = '0'
      AND    NOT EXISTS
       (SELECT 1
              FROM   ${msl_schema}.msl_cbss_kna_dpac t2
              WHERE  (t2.debttp IN ('P01'
                                   ,'A15'
                                   ,'IC1'
                                   ,'S09') OR t2.acustg LIKE '2002%')
              AND    t2.acctid = t1.acctid);
     
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
     )
    WITH tmp_td_initza AS
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
             CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.index_value
                              ,0)) over(PARTITION BY t4.index_no)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.index_value
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3))
                 ELSE
                  coalesce(t2.index_value
                          ,0)
             END AS accu_index_value_d
            , --当日累计
             rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY coalesce(t2.index_value, 0) DESC) AS index_ranking
            , --当前排名
             t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN (SELECT SUM(index_value) AS index_value
                        ,(CASE
                             WHEN substr(t1.org_no
                                        ,1
                                        ,2) = '89'
                                  OR t1.org_no = '800001' THEN
                              '000000'
                             WHEN t1.org_no LIKE '%001'
                                  AND substr(t1.org_no
                                            ,1
                                            ,2) != '89'
                                  AND t1.org_no != '800001' THEN
                              substr(t1.org_no
                                    ,1
                                    ,3)
                             ELSE
                              t1.org_no
                         END) AS org_no
                  FROM   (
                          --核心
                          
                         /* SELECT t.open_acct_org_id AS org_no
                                 ,COUNT(1) AS index_value
                          FROM   ${itl_schema}.itl_edw_cmm_dep_cust_acct_info t
                          WHERE  t.open_acct_dt =
                                 to_date('${batch_date}'
                                         ,'yyyymmdd')
                          AND    t.cust_id LIKE '1%'
                          AND    t.job_cd = 'cbssf1'
                          AND    NOT EXISTS
                           (SELECT 1
                                  FROM   ${itl_schema}.itl_edw_agt_acct_change_rgst_b t4
                                  WHERE  t4.new_acct_id = t.cust_acct_id
                                  AND    t4.tran_dt <=
                                         to_date('${batch_date}'
                                                 ,'yyyymmdd')
                                  AND    t4.job_cd = 'cbssf1')
                          AND    EXISTS
                           (SELECT 1
                                  FROM   tab_all_act t2
                                  WHERE  t2.acct_id = t.cust_acct_id)
                          GROUP  BY t.open_acct_org_id
                          */
                          
                           SELECT /*+ use_hash(a,b,e,d)*/ a.brchno AS org_no
                         ,COUNT(DISTINCT a.acctno) AS index_value
                  FROM   ${msl_schema}.msl_cbss_kna_acct a
                  LEFT   JOIN ${msl_schema}.msl_cbss_knc_acid b
                  ON     a.acctno = b.datavl
                  LEFT   JOIN ${msl_schema}.msl_cbss_cifs_cfb_cust e
                  ON     E.CUSTNO=B.CUSTNO
                  LEFT   JOIN ${msl_schema}.TAB_ALL_ACT d
                  ON     a.acctno = d.acctno
                  WHERE  E.custtp  IN ('1','3','7') --个人标识
                  AND    a.opendt = '${batch_date}'
                  AND    a.accstp = '0'
                  AND    d.acctno is not null
                  and    a.acctno not like '24%' --剔除大额存单
                  AND    NOT EXISTS (SELECT 1
                          FROM   ${msl_schema}.msl_cbss_kna_acct_repl t
                          WHERE  t.nwacno = a.acctno)
                          GROUP BY a.brchno
                  UNION ALL
      --电子账户
      SELECT t1.account_branch_id AS org_no
            ,COUNT(DISTINCT t1.billing_account_id) AS index_value
      FROM   ${msl_schema}.msl_iats_billing_account t1 --账单账户表
      LEFT   JOIN ${msl_schema}.msl_iats_bill_card_acc_assoc t2 --账户与介质关联关系表
      ON     t2.account_no = t1.external_account_id
      WHERE  t1.status_id != '4'
      AND    t1.account_type IN
             (SELECT billing_account_type_id
               FROM   ${msl_schema}.msl_iats_billing_account_type --E账户账户类型信息表
               WHERE  parent_type_id = 'PRIVATE_E')
      AND    (t1.account_category_level = 'SECOND-ACCT' OR
            t1.account_category_level = 'THIRD-ACCT'
	    OR t1.account_category_level = 'FIXED-ACCT')
      AND    to_char(t1.from_date
                    ,'yyyymmdd') = '${batch_date}'
      GROUP  BY t1.account_branch_id                                      
                          ) t1
                  GROUP  BY (CASE
                                WHEN substr(t1.org_no
                                           ,1
                                           ,2) = '89'
                                     OR t1.org_no = '800001' THEN
                                 '000000'
                                WHEN t1.org_no LIKE '%001'
                                     AND substr(t1.org_no
                                               ,1
                                               ,2) != '89'
                                     AND t1.org_no != '800001' THEN
                                 substr(t1.org_no
                                       ,1
                                       ,3)
                                ELSE
                                 t1.org_no
                            END)) t2
      ON     t1.org_no = t2.org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     'WD030201' = t4.index_no_mcs),
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
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上日数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd') - 1),
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
             coalesce(t1.accu_index_value_d
                     ,0) - coalesce(t2.accu_index_value_d
                                   ,0) AS rate_last_month --比上月  
            ,CASE
                 WHEN coalesce(t2.accu_index_value_d
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t2.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                                ,0)) /
                        coalesce(t2.accu_index_value_d
                                ,0)
                       ,6)
             END AS rate_last_month_per --比上月百分比     
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上月数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = trunc(to_date('${batch_date}'
                                      ,'yyyymmdd')
                              ,'mm') - 1),
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
             coalesce(t1.accu_index_value_d
                     ,0) - coalesce(t2.accu_index_value_d
                                   ,0) AS rate_last_quater --比上季 
            ,CASE
                 WHEN coalesce(t2.accu_index_value_d
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t2.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                                ,0)) /
                        coalesce(t2.accu_index_value_d
                                ,0)
                       ,6)
             END AS rate_last_quater_per --比上季百分比   
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上季数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = trunc(to_date('${batch_date}'
                                      ,'yyyymmdd')
                              ,'Q') - 1),
    
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
             coalesce(t1.accu_index_value_d
                     ,0) - coalesce(t2.accu_index_value_d
                                   ,0) AS rate_last_year --比上年
            ,CASE
                 WHEN coalesce(t2.accu_index_value_d
                              ,0) = 0 THEN
                  0
                 ELSE
                  round((coalesce(t2.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                                ,0)) /
                        coalesce(t2.accu_index_value_d
                                ,0)
                       ,6)
             END AS rate_last_year_per --比上年百分比   
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = trunc(to_date('${batch_date}'
                                      ,'yyyymmdd')
                              ,'yy') - 1),
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
                  round((coalesce(t2.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                                ,0)) /
                        coalesce(t2.accu_index_value_d
                                ,0)
                       ,6)
             END AS rate_last_period_per --同比百分比   
      FROM   tmp_td_initza t1 -- 当日数据
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
      ON     t1.index_no = t2.index_no
      AND    t1.org_no = t2.org_no
      AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                           ,'yyyymmdd')
                                   ,-12))
    
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
          ,SUM(mcyy_bu_analysis_tmp.rate_up_day_per) -- 比上日百分比
          ,SUM(mcyy_bu_analysis_tmp.rate_last_month_per) -- 比上月百分比
          ,SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) -- 比上季百分比
          ,SUM(mcyy_bu_analysis_tmp.rate_last_year_per) -- 比上年百分比
          ,SUM(mcyy_bu_analysis_tmp.rate_last_period_per) -- 同比百分比
          ,mcyy_bu_analysis_tmp.index_ranking -- 当前排名
          ,mcyy_bu_analysis_tmp.index_ranking_cha -- 排名变动
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'CBSS' source_sys --来源系统
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
    ;

COMMIT;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${idl_schema}.mcyy_bu_analysis to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);