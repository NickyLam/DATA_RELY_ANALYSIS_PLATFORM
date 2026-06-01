/*
Purpose:    将每日账户指标事实表数据落地到账户类数据报表
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_acct_class_stat_rept
Createdate: 20210831
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
--truncate table ${idl_schema}.mcyy_acct_class_stat_rept;



whenever sqlerror exit sql.sqlcode; 

--1.2 创建指定月分区

set serveroutput on 
DECLARE
   
    exists_flag NUMBER(10) := 0; -- 判断标志
    v_sql       VARCHAR2(4000);
    v_partition VARCHAR2(200);

BEGIN

    
        v_partition :=substr('${batch_date}',1,6);
    
        SELECT COUNT(1)
        INTO   exists_flag
        FROM   user_tab_partitions
        WHERE  table_name =UPPER('mcyy_acct_class_stat_rept')
        AND    partition_name = 'P_' || v_partition;
    
        IF exists_flag = 0
        THEN
            --分区不存在则直接创建
            --动态拼接创建分区sql
                       v_sql := 'alter table mcyy_acct_class_stat_rept add partition p_' ||
                     v_partition;
            v_sql := v_sql || ' values (to_date('''||v_partition||''',''yyyymm'')) ';
        
            EXECUTE IMMEDIATE v_sql;
        /*ELSE
            --分区存在则清空分区数据
            v_sql := 'alter table mcyy_acct_class_stat_rept truncate partition p_' ||
                     v_partition;
            EXECUTE IMMEDIATE v_sql;*/
        END IF;
    

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('创建指定月分区出错' || SQLERRM);
    
END;


/

--清除当天数据
delete mcyy_acct_class_stat_rept
where etl_dt=to_date('${batch_date}','yyyymmdd');
commit;


-- 2.1 insert data to tables
whenever sqlerror exit sql.sqlcode; 

INSERT /*+ append */
INTO ${idl_schema}.mcyy_acct_class_stat_rept
    (etl_dt -- 数据日期
    ,rept_dt --报表周期(月)
    ,index_no -- 指标编码
    ,bu_type -- 业务品种
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,index_name -- 指标名称
    ,td_index_value_d -- 当日日累计
    ,td_index_value_m -- 当日月累计
    ,td_index_value_q -- 当日季累计
    ,td_index_value_y -- 当日年累计
    ,td_rate_up_day -- 当日比上日
    ,td_rate_last_month -- 当日比上月
    ,td_rate_last_quater -- 当日比上季
    ,td_rate_last_year -- 当日比上年
    ,td_rate_up_day_per -- 当日比上日百分比
    ,td_rate_last_month_per -- 当日比上月百分比
    ,td_rate_last_quater_per -- 当日比上季百分比
    ,td_rate_last_year_per -- 当日比上年百分比
    ,td_day_ratio_index -- 当日日占比
    ,td_mon_ratio_index -- 当日月占比
    ,td_quar_ratio_index -- 当日季占比
    ,td_year_ratio_index -- 当日年占比
    ,currt_index_value_d -- 当期日累计
    ,currt_index_value_m -- 当期月累计
    ,currt_index_value_q -- 当期季累计
    ,currt_index_value_y -- 当期年累计
    ,currt_rate_up_day -- 当期比上日
    ,currt_rate_last_month -- 当期比上月
    ,currt_rate_last_quater -- 当期比上季
    ,currt_rate_last_year -- 当期比上年
    ,currt_rate_up_day_per -- 当期比上日百分比
    ,currt_rate_last_month_per -- 当期比上月百分比
    ,currt_rate_last_quater_per -- 当期比上季百分比
    ,currt_rate_last_year_per -- 当期比上年百分比
    ,currt_day_ratio_index -- 当期日占比
    ,currt_mon_ratio_index -- 当期月占比
    ,currt_quar_ratio_index -- 当期季占比
    ,currt_year_ratio_index -- 当期年占比
    ,etl_timestamp -- ETL处理时间戳
     
     )
    WITH acct_open_tot1_index AS
     (SELECT mid.index_no
            ,mid.index_name_mcs
            ,(CASE
                 WHEN dim_no IS NULL THEN
                  mid.index_no
                 ELSE
                  mid.index_no || mdd.dim_class || mdd.dim_no
             END) AS query_index_no
            ,mdd.dim_name
      FROM   mcyy_index_define mid
      LEFT   JOIN mcyy_dim_index mdi
      ON     mid.index_no = mdi.index_no
      LEFT   JOIN mcyy_dim_define mdd
      ON     mdd.dim_class = mdi.dim_class
      WHERE  mid.index_no IN ('WD030117'
                             , --人民币对公账户开户数(含保证金)
                              'WD030118'
                             , --对公账户开户数(渠道)
                              'WD030213'
                             , --人民币个人账户开户数(含保证金)
                              'WD030216'
                             , --个人账户开户数(渠道)
                              'WD030309'
                             , --外汇账户对公开户数
                              'WD030310' --外汇账户个人开户数
                              )),
    
    acct_open_tot2_index AS
     (SELECT mid.index_no
            ,mid.index_name_mcs
            ,(CASE
                 WHEN dim_no IS NULL THEN
                  mid.index_no
                 ELSE
                  mid.index_no || mdd.dim_class || mdd.dim_no
             END) AS query_index_no
            ,mdd.dim_name
      FROM   mcyy_index_define mid
      LEFT   JOIN mcyy_dim_index mdi
      ON     mid.index_no = mdi.index_no
      LEFT   JOIN mcyy_dim_define mdd
      ON     mdd.dim_class = mdi.dim_class
      WHERE  mid.index_no IN ('WD030102'
                             , --人民币对公结算账户开户数
                              'WD030103'
                             , --人民币对公基本存款账户开户数
                              'WD030104'
                             , --人民币对公一般存款账户开户数
                              'WD030105'
                             , --人民币对公专用存款账户开户数
                              'WD030106'
                             , --人民币对公临时账户开户数存款
                              'WD030107'
                             , --人民币对公定期存款账户开户数
                              'WD030108'
                             , --人民币对公保证金存款账户开户数
                              'WD030202'
                             , --人民币个人结算账户开户数
                              'WD030203'
                             , --人民币个人结算Ⅰ类户开户数
                              'WD030204'
                             , --人民币个人结算Ⅱ类户开户数
                              'WD030205'
                             , --人民币个人结算Ⅲ类户开户数
                              'WD030206'
                             , --人民币个人定期存款账户开户数
                              'WD030214'
                             , --人民币个人保证金存款账户开户数
                              'WD030301'
                             , --外汇结算账户开户数
                              'WD030302'
                             , --外汇定期母户开户数
                              'WD030303'
                             , --外汇保证金母户开户数
                              'WD030307' --外汇账户开户数
                              )),
    acct_open_cls_index AS
     (SELECT mid.index_no
            ,mid.index_name_mcs
            ,(CASE
                 WHEN dim_no IS NULL THEN
                  mid.index_no
                 ELSE
                  mid.index_no || mdd.dim_class || mdd.dim_no
             END) AS query_index_no
            ,mdd.dim_name
      FROM   mcyy_index_define mid
      LEFT   JOIN mcyy_dim_index mdi
      ON     mid.index_no = mdi.index_no
      LEFT   JOIN mcyy_dim_define mdd
      ON     mdd.dim_class = mdi.dim_class
      WHERE  mid.index_no IN ('WD030117'
                             , --人民币对公账户开户数(含保证金)
                              'WD030213'
                             , --人民币个人账户开户数(含保证金)
                              'WD030309'
                             , --外汇账户对公开户数
                              'WD030216'
                             , --个人账户开户数(渠道)
                              'WD030118'
                             , --对公账户开户数(渠道)
                              'WD030310' --外汇账户个人开户数
                              )),
    acct_sum_index AS
     (SELECT mid.index_no
            ,mid.index_name_mcs
            ,(CASE
                 WHEN dim_no IS NULL THEN
                  mid.index_no
                 ELSE
                  mid.index_no || mdd.dim_class || mdd.dim_no
             END) AS query_index_no
            ,mdd.dim_name
      FROM   mcyy_index_define mid
      LEFT   JOIN mcyy_dim_index mdi
      ON     mid.index_no = mdi.index_no
      LEFT   JOIN mcyy_dim_define mdd
      ON     mdd.dim_class = mdi.dim_class
      WHERE  mid.index_no IN ('WD030215'
                             , --人民币个人保证金存款账户累计户数
                              'WD030306'
                             , --外汇保证金母户累计户数
                              'WD030308'
                             , --外汇账户累计户数
                              'WD030305'
                             , --外汇定期母户累计户数
                              'WD030304'
                             , --外汇结算账户累计户数
                              'WD030212'
                             , --人民币个人定期存款账户累计户数
                              'WD030211'
                             , --人民币个人结算Ⅲ类户累计户数
                              'WD030111'
                             , --人民币对公基本存款账户累计户数
                              'WD030210'
                             , --人民币个人结算Ⅱ类户累计户数
                              'WD030209'
                             , --人民币个人结算Ⅰ类户累计户数
                              'WD030110'
                             , --人民币对公结算账户累计户数
                              'WD030109'
                             , --人民币对公账户累计户数(含保证金)
                              'WD030113'
                             , --人民币对公专用存款账户累计户数
                              'WD030114'
                             , --人民币对公临时账户累计户数存款
                              'WD030115'
                             , --人民币对公定期存款账户累计户数
                              'WD030112'
                             , --人民币对公一般存款账户累计户数
                              'WD030208'
                             , --人民币个人结算账户累计户数
                              'WD030207'
                             , --人民币个人账户累计户数(含保证金)
                              'WD030116' --人民币对公保证金存款账户累计户数
                              )),
    
    tab_acct_open_tot1 AS
     (SELECT f.etl_dt AS etl_dt
            ,f.org_name AS org_name
            ,f.org_no AS org_no
            ,f.super_org_no AS super_org_no
            ,substr(f.index_no
                   ,1
                   ,8) AS index_no
            ,d.index_name_mcs AS index_name
            ,'合计' AS bu_type
            ,SUM(f.accu_index_value_d) AS td_index_value_d
            ,SUM(f.rate_up_day) AS td_rate_up_day
            ,SUM(f.rate_up_day_per) AS td_rate_up_day_per
            ,SUM(f.day_ratio_index) AS td_day_ratio_index
             
            ,SUM(f.accu_index_value_m) AS td_index_value_m
            ,SUM(f.rate_last_month) AS td_rate_last_month
            ,SUM(f.rate_last_month_per) AS td_rate_last_month_per
            ,SUM(f.mon_ratio_index) AS td_mon_ratio_index
             
            ,SUM(f.accu_index_value_q) AS td_index_value_q
            ,SUM(f.rate_last_quater) AS td_rate_last_quater
            ,SUM(f.rate_last_quater_per) AS td_rate_last_quater_per
            ,SUM(f.quar_ratio_index) AS td_quar_ratio_index
             
            ,SUM(f.accu_index_value_y) AS td_index_value_y
            ,SUM(f.rate_last_year) AS td_rate_last_year
            ,SUM(f.rate_last_year_per) AS td_rate_last_year_per
            ,SUM(f.year_ratio_index) AS td_year_ratio_index
            ,substr(f.index_no
                   ,1
                   ,8) || rpad(f.org_no
                              ,6
                              ,'0') || 2 AS nums
      FROM   mcyy_bu_analysis_fe_diplay f
      LEFT   JOIN acct_open_tot1_index d
      ON     d.query_index_no = f.index_no
      WHERE  d.query_index_no IS NOT NULL
      GROUP  BY f.etl_dt
               ,f.org_name
               ,f.org_no
               ,f.super_org_no
               ,substr(f.index_no
                      ,1
                      ,8)
               ,d.index_name_mcs),
    
    tab_acct_open_tot2 AS
     (SELECT f.etl_dt AS etl_dt
            ,f.org_name AS org_name
            ,f.org_no AS org_no
            ,f.super_org_no AS super_org_no
            ,f.index_no AS index_no
            ,d.index_name_mcs AS index_name
            ,'不分渠道' AS bu_type
            ,f.accu_index_value_d AS td_index_value_d
            ,f.rate_up_day AS td_rate_up_day
            ,f.rate_up_day_per AS td_rate_up_day_per
            ,f.day_ratio_index AS td_day_ratio_index
             
            ,f.accu_index_value_m  AS td_index_value_m
            ,f.rate_last_month     AS td_rate_last_month
            ,f.rate_last_month_per AS td_rate_last_month_per
            ,f.mon_ratio_index     AS td_mon_ratio_index
             
            ,f.accu_index_value_q   AS td_index_value_q
            ,f.rate_last_quater     AS td_rate_last_quater
            ,f.rate_last_quater_per AS td_rate_last_quater_per
            ,f.quar_ratio_index     AS td_quar_ratio_index
             
            ,f.accu_index_value_y AS td_index_value_y
            ,f.rate_last_year     AS td_rate_last_year
            ,f.rate_last_year_per AS td_rate_last_year_per
            ,f.year_ratio_index   AS td_year_ratio_index
            ,NULL                 AS nums
      FROM   mcyy_bu_analysis_fe_diplay f
      LEFT   JOIN acct_open_tot2_index d
      ON     d.query_index_no = f.index_no
      WHERE  d.query_index_no IS NOT NULL),
    
    tab_acct_open_cls AS
     (SELECT f.etl_dt AS etl_dt
            ,f.org_name AS org_name
            ,f.org_no AS org_no
            ,f.super_org_no AS super_org_no
            ,f.index_no AS index_no
            ,d.index_name_mcs AS index_name
            ,fun_decode_report(f.bu_type) AS bu_type
            ,f.accu_index_value_d AS td_index_value_d
            ,f.rate_up_day AS td_rate_up_day
            ,f.rate_up_day_per AS td_rate_up_day_per
            ,f.day_ratio_index AS td_day_ratio_index
             
            ,f.accu_index_value_m  AS td_index_value_m
            ,f.rate_last_month     AS td_rate_last_month
            ,f.rate_last_month_per AS td_rate_last_month_per
            ,f.mon_ratio_index     AS td_mon_ratio_index
             
            ,f.accu_index_value_q   AS td_index_value_q
            ,f.rate_last_quater     AS td_rate_last_quater
            ,f.rate_last_quater_per AS td_rate_last_quater_per
            ,f.quar_ratio_index     AS td_quar_ratio_index
             
            ,f.accu_index_value_y AS td_index_value_y
            ,f.rate_last_year AS td_rate_last_year
            ,f.rate_last_year_per AS td_rate_last_year_per
            ,f.year_ratio_index AS td_year_ratio_index
            ,f.index_no || rpad(f.org_no
                               ,6
                               ,'0') || 1 AS nums
      FROM   mcyy_bu_analysis_fe_diplay f
      LEFT   JOIN acct_open_cls_index d
      ON     d.query_index_no = f.index_no
      WHERE  d.query_index_no IS NOT NULL),
    
    tab_acct_sum AS
     (SELECT f.etl_dt       AS etl_dt
            ,f.org_name     AS org_name
            ,f.org_no       AS org_no
            ,f.super_org_no AS super_org_no
            ,f.index_no     AS index_no
             
            ,d.index_name_mcs AS index_name --可不显示
            ,'不分渠道' AS bu_type
            ,f.index_value AS currt_index_value_d
            ,f.rate_up_day AS currt_rate_up_day
            ,f.rate_up_day_per AS currt_rate_up_day_per
            ,f.day_ratio_index AS currt_day_ratio_index
             
            ,f.rate_last_month     AS currt_rate_last_month
            ,f.rate_last_month_per AS currt_rate_last_month_per
            ,f.mon_ratio_index     AS currt_mon_ratio_index
             
            ,f.rate_last_quater     AS currt_rate_last_quater
            ,f.rate_last_quater_per AS currt_rate_last_quater_per
            ,f.quar_ratio_index     AS currt_quar_ratio_index
             
            ,f.rate_last_year     AS currt_rate_last_year
            ,f.rate_last_year_per AS currt_rate_last_year_per
            ,f.year_ratio_index   AS currt_year_ratio_index
      FROM   mcyy_bu_analysis_fe_diplay f
      LEFT   JOIN acct_sum_index d
      ON     d.query_index_no = f.index_no
      WHERE  d.query_index_no IS NOT NULL)
    
    SELECT o.etl_dt AS etl_dt
          ,to_date(substr('${batch_date}',1,6)
                  ,'yyyymm') AS rept_dt
          ,o.index_no
          ,o.bu_type AS bu_type
          ,o.ORG_NO AS org_no
          ,decode(o.org_name
                 ,'全行'
                 ,'分行合计'
                 ,org_tab.org_name) AS org_name
          ,o.super_org_no AS super_org_no
          ,o.index_name AS index_name
          ,nvl(o.td_index_value_d
              ,0) AS td_index_value_d
          ,nvl(o.td_index_value_m
              ,0) AS td_index_value_m
          ,nvl(o.td_index_value_q
              ,0) AS td_index_value_q
          ,nvl(o.td_index_value_y
              ,0) AS td_index_value_y
           
          ,nvl(o.td_rate_up_day
              ,0) AS td_rate_up_day
          ,nvl(o.td_rate_last_month
              ,0) AS td_rate_last_month
          ,nvl(o.td_rate_last_quater
              ,0) AS td_rate_last_quater
          ,nvl(o.td_rate_last_year
              ,0) AS td_rate_last_year
           
          ,nvl(round(o.td_rate_up_day_per * 100
                    ,2)
              ,0) AS td_rate_up_day_per
          ,nvl(round(o.td_rate_last_month_per * 100
                    ,2)
              ,0) AS td_rate_last_month_per
           
          ,nvl(round(o.td_rate_last_quater_per * 100
                    ,2)
              ,0) AS td_rate_last_quater_per
          ,nvl(round(o.td_rate_last_year_per * 100
                    ,2)
              ,0) AS td_rate_last_year_per
           
          ,nvl(round(o.td_day_ratio_index * 100
                    ,2)
              ,0) AS td_day_ratio_index
           
          ,nvl(round(o.td_mon_ratio_index * 100
                    ,2)
              ,0) AS td_mon_ratio_index
          ,nvl(round(o.td_quar_ratio_index * 100
                    ,2)
              ,0) AS td_quar_ratio_index
          ,nvl(round(o.td_year_ratio_index * 100
                    ,2)
              ,0) AS td_year_ratio_index
          ,nvl(s.currt_index_value_d
              ,0) AS currt_index_value_d
          ,NULL AS currt_index_value_m
          ,NULL AS currt_index_value_q
          ,NULL AS currt_index_value_y
           
          ,nvl(s.currt_rate_up_day
              ,0) AS currt_rate_up_day
          ,nvl(s.currt_rate_last_month
              ,0) AS currt_rate_last_month
          ,nvl(s.currt_rate_last_quater
              ,0) AS currt_rate_last_quater
          ,nvl(s.currt_rate_last_year
              ,0) AS currt_rate_last_year
           
          ,nvl(round(s.currt_rate_up_day_per * 100
                    ,2)
              ,0) AS currt_rate_up_day_per
          ,nvl(round(s.currt_rate_last_month_per * 100
                    ,2)
              ,0) AS currt_rate_last_month_per
          ,nvl(round(s.currt_rate_last_quater_per * 100
                    ,2)
              ,0) AS currt_rate_last_quater_per
          ,nvl(round(s.currt_rate_last_year_per * 100
                    ,2)
              ,0) AS currt_rate_last_year_per
           
          ,nvl(round(s.currt_day_ratio_index * 100
                    ,2)
              ,0) AS currt_day_ratio_index
           
          ,nvl(round(s.currt_mon_ratio_index * 100
                    ,2)
              ,0) AS currt_mon_ratio_index
           
          ,nvl(round(s.currt_quar_ratio_index * 100
                    ,2)
              ,0) AS currt_quar_ratio_index
           
          ,nvl(round(s.currt_year_ratio_index * 100
                    ,2)
              ,0) AS currt_year_ratio_index
           
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT *
            FROM   tab_acct_open_cls
            UNION ALL
            SELECT *
            FROM   tab_acct_open_tot1
            UNION ALL
            SELECT * FROM tab_acct_open_tot2) o
    LEFT   JOIN tab_acct_sum s
    ON     o.etl_dt = s.etl_dt
    AND    o.org_no = s.org_no
    AND    REPLACE(o.index_name
                  ,'开户数'
                  ,'') = REPLACE(s.index_name
                                 ,'累计户数'
                                 ,'')
    AND    o.bu_type = s.bu_type
    LEFT   JOIN mcyy_orga_para org_tab
    ON     o.org_no = org_tab.org_no
    WHERE  o.etl_dt = to_date('${batch_date}'
                             ,'yyyymmdd');

COMMIT;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${idl_schema}.mcyy_acct_class_stat_rept to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mcyy_acct_class_stat_rept', degree => 8, cascade => true);
