/*
Purpose:    进件看板T+1:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_enter
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_enter
-- 以下为依赖了上游的表 (OGG实时表):
msl_hgls_loan_req
msl_hgls_loan_branch_website

-- 20260206 新增
好贷增加201基线产品 
-- 以下为依赖了上游的表 (OGG实时表):
MSL_ICMS_WYD_RISK_JUDGE
MSL_ICMS_USER_INFO


*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_enter_tmp_01 purge ;
drop table ${idl_schema}.mckb_enter_tmp_02 purge ;

alter table ${idl_schema}.mckb_enter add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_enter_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_enter
where 1=2 ;
create table  ${idl_schema}.mckb_enter_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_enter
where 1=2 ;

-- 2.1 insert into table
INSERT /*+ append */
INTO ${idl_schema}.mckb_enter_tmp_01
    (etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    --,grouping --分组
    ,org_no --机构编号
    --,org_name --机构名称
    ,enter_cnt --进件数
    ,lp_cls_id --法人分类编号
    ,lp_cls_name --法人分类名称
    ,LP_CLS_PROD -- 产品分类 
    --,etl_timestamp --etl处理时间戳
     )
     --累计
        select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'099'  as ped_no
               ,'累计' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'2'    as lp_cls_id
               ,'个人' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         FROM  MSL_HGLS_LOAN_REQ T1
         INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
         ON    T1.HOME_BRANCH=T2.CODE
         AND   T2. ISDEL = 0
         WHERE T1.ISDEL = 0
         AND   T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
         and   trunc(t1.req_date)<=to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         union all
         --日
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'001' as ped_no
               ,'当日' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)=to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
          union all
         --月
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'002' as ped_no
               ,'当月' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${month_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
          union all
          --季
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'003' as ped_no
               ,'当季' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${quarter_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         union all
         --年
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'004' as ped_no
               ,'当年' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${year_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
          union all
         --周
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'005' as ped_no
               ,'当周' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'2' as lp_cls_id
               ,'个人' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${week_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         union all
         --累计
        select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'099' as ped_no
               ,'累计' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)<=to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         union all
         --日
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'001' as ped_no
               ,'当日' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)=to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
          union all
         --月
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'002' as ped_no
               ,'当月' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${month_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
          union all
          --季
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'003' as ped_no
               ,'当季' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${quarter_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         union all
         --年
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'004' as ped_no
               ,'当年' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${year_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
          union all
         --周
         select      
               to_date('${batch_date}','yyyymmdd') as etl_dt
               ,'005' as ped_no
               ,'当周' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18个人标准产品,32个人特色产品,201基线 / 22企业
           and trunc(t1.req_date)>= to_date('${week_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
        -- 20260206 新增 
        -- 好企贷 数据贷 
        UNION ALL 
        SELECT      
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO
                ,COUNT(T1.SERIALNO)                 AS ENTER_CNT --进件数/流水号
                ,'2'                                AS LP_CLS_ID -- 2 是个人/1是企业
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         FROM   MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
         INNER JOIN MSL_ICMS_USER_INFO T2  -- 用户基本信息
         ON     T2.USERID = T1.RECOMMENDER
         AND    T2.BELONGORG IS NOT NULL  -- 归属机构 
         WHERE  TRUNC(T1.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
         AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
         GROUP BY SUBSTR(T2.BELONGORG,0,3)
         UNION ALL
          --日
         SELECT      
                 TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                 ,'001'                              AS PED_NO
                 ,'当日'                             AS PED_NAME
                 ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO
                 ,COUNT(T1.SERIALNO)                 AS ENTER_CNT --进件数/微众客户ID
                 ,'2'                                AS LP_CLS_ID    -- 2 是个人/1是企业
                 ,'个人'                             AS LP_CLS_NAME
                 ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
         INNER JOIN MSL_ICMS_USER_INFO T2  -- 用户基本信息
         ON     T2.USERID = T1.RECOMMENDER
         AND    T2.BELONGORG IS NOT NULL  -- 归属机构 
         WHERE  TRUNC(T1.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')-- 登记日期
         AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
         GROUP BY SUBSTR(T2.BELONGORG,0,3)
         UNION ALL
          --月
         SELECT      
                 TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                 ,'002'                              AS PED_NO
                 ,'当月'                             AS PED_NAME
                 ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO
                 ,COUNT(T1.SERIALNO)                 AS ENTER_CNT --进件数/微众客户ID
                 ,'2'                                AS LP_CLS_ID    -- 2 是个人/1是企业
                 ,'个人'                             AS LP_CLS_NAME
                 ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         FROM    MSL_ICMS_WYD_RISK_JUDGE T1  -- 微业贷风险判别表
         INNER JOIN MSL_ICMS_USER_INFO T2    -- 用户基本信息
         ON     T2.USERID = T1.RECOMMENDER
         AND    T2.BELONGORG IS NOT NULL  -- 归属机构 
         WHERE  TRUNC(T1.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
         AND    TRUNC(T1.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
         AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
         GROUP BY SUBSTR(T2.BELONGORG,0,3)
         UNION ALL
         -- 季 
          SELECT      
                 TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                 ,'003'                              AS PED_NO
                 ,'当季'                             AS PED_NAME
                 ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO
                 ,COUNT(T1.SERIALNO)                 AS ENTER_CNT --进件数/微众客户ID
                 ,'2'                                AS LP_CLS_ID    -- 2 是个人/1是企业
                 ,'个人'                             AS LP_CLS_NAME
                 ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         FROM    MSL_ICMS_WYD_RISK_JUDGE T1  -- 微业贷风险判别表
         INNER JOIN MSL_ICMS_USER_INFO T2    -- 用户基本信息
         ON     T2.USERID = T1.RECOMMENDER
         AND    T2.BELONGORG IS NOT NULL  -- 归属机构 
         WHERE  TRUNC(T1.INPUTDATE)>= TO_DATE('${quarter_start}','yyyymmdd')
         AND    TRUNC(T1.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
         AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
         GROUP BY SUBSTR(T2.BELONGORG,0,3)

         UNION ALL 
          --年
         SELECT      
                 TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                 ,'004'                              AS PED_NO
                 ,'当年'                             AS PED_NAME
                 ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO    --归属机构
                 ,COUNT(T1.SERIALNO)                 AS ENTER_CNT --进件数/微众客户ID
                 ,'2'                                AS LP_CLS_ID    -- 2 是个人/1是企业
                 ,'个人'                             AS LP_CLS_NAME
                 ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         FROM    MSL_ICMS_WYD_RISK_JUDGE T1  -- 微业贷风险判别表
         INNER JOIN MSL_ICMS_USER_INFO T2    -- 用户基本信息
         ON     T2.USERID = T1.RECOMMENDER
         AND    T2.BELONGORG IS NOT NULL  -- 归属机构    
         WHERE  TRUNC(T1.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
         AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
         AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
         GROUP BY SUBSTR(T2.BELONGORG,0,3)
         UNION ALL 
          --年
         SELECT      
                 TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                 ,'005'                              AS PED_NO
                 ,'当周'                             AS PED_NAME
                 ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO    --归属机构
                 ,COUNT(T1.SERIALNO)                 AS ENTER_CNT --进件数/微众客户ID
                 ,'2'                                AS LP_CLS_ID    -- 2 是个人/1是企业
                 ,'个人'                             AS LP_CLS_NAME
                 ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         FROM    MSL_ICMS_WYD_RISK_JUDGE T1  -- 微业贷风险判别表
         INNER JOIN MSL_ICMS_USER_INFO T2    -- 用户基本信息
         ON     T2.USERID = T1.RECOMMENDER
         AND    T2.BELONGORG IS NOT NULL  -- 归属机构    
         WHERE  TRUNC(T1.INPUTDATE) >= TO_DATE('${week_start}','yyyymmdd')
         AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
         AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
         GROUP BY SUBSTR(T2.BELONGORG,0,3)
                ;
      commit;

INSERT /*+ append */INTO ${idl_schema}.mckb_enter_tmp_01
    (etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    --,grouping --分组
    ,org_no --机构编号
    --,org_name --机构名称
    ,enter_cnt --进件数
    ,lp_cls_id --法人分类编号
    ,lp_cls_name --法人分类名称
    --,etl_timestamp --etl处理时间戳
    ,LP_CLS_PROD --产品分类 
     )
     --全行汇总
     SELECT 
                 ETL_DT          AS ETL_DT
                 ,PED_NO         AS PED_NO
                 ,PED_NAME       AS PED_NAME
                 ,'000000'       AS ORG_NO
                 ,SUM(ENTER_CNT) AS ENTER_CNT
                 ,LP_CLS_ID      AS LP_CLS_ID
                 ,LP_CLS_NAME    AS LP_CLS_NAME
                 ,LP_CLS_PROD    AS LP_CLS_PROD
           FROM MCKB_ENTER_TMP_01 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD
                   ;
     commit;

-- 产品汇总 20260206 新增 
    INSERT /*+ append */ INTO ${idl_schema}.mckb_enter_tmp_01
           (ETL_DT --数据日期
           ,PED_NO --周期编号
           ,PED_NAME --周期名称
           ,ORG_NO --机构编号
           ,ENTER_CNT --进件数
           ,LP_CLS_ID --法人分类编号
           ,LP_CLS_NAME --法人分类名称
           ,LP_CLS_PROD
            )
    SELECT 
          ETL_DT          AS ETL_DT
          ,PED_NO         AS PED_NO
          ,PED_NAME       AS PED_NAME
          ,ORG_NO         AS ORG_NO
          ,SUM(ENTER_CNT) AS ENTER_CNT
          ,LP_CLS_ID      AS LP_CLS_ID
          ,LP_CLS_NAME    AS LP_CLS_NAME
          ,'0'            AS LP_CLS_PROD --合计 
    FROM MCKB_ENTER_TMP_01 
    GROUP BY PED_NO
            ,PED_NAME
            ,LP_CLS_ID
            ,LP_CLS_NAME
            ,ETL_DT
            ,ORG_NO
                  ;
    commit;

-- 合计汇总 
INSERT /*+ append */INTO ${idl_schema}.mckb_enter_tmp_01
    (etl_dt      -- 数据日期
    ,ped_no      -- 周期编号
    ,ped_name    -- 周期名称
    ,org_no      -- 机构编号
    ,enter_cnt   -- 进件数
    ,lp_cls_id   -- 法人分类编号
    ,lp_cls_name -- 法人分类名称
    ,LP_CLS_PROD -- 产品分类 
     )
      SELECT 
           T1.ETL_DT    AS ETL_DT
           ,T1.PED_NO   AS PED_NO
           ,T1.PED_NAME AS PED_NAME
           ,T1.ORG_NO   AS ORG_NO
           ,SUM(T1.ENTER_CNT) AS ENTER_CNT
           ,'0'         AS LP_CLS_ID
           ,'合计'      AS LP_CLS_NAME
           ,LP_CLS_PROD AS LP_CLS_PROD
     FROM MCKB_ENTER_TMP_01 T1
     GROUP BY T1.PED_NO
             ,T1.PED_NAME
             ,T1.ETL_DT
             ,T1.ORG_NO
             ,T1.LP_CLS_PROD
             ;
     commit;
     
     
INSERT /*+ append */INTO ${idl_schema}.mckb_enter_tmp_02
    (etl_dt  -- ETL处理日期
    ,ped_no -- 周期编号(099累计 001当日 002当月 003当季 004当年 005当周）
    ,ped_name -- 周期名称
    ,grouping -- 分组
    ,org_no -- 机构编号
    ,org_name  -- 机构名称
    ,enter_cnt -- 进件数
    ,lp_cls_id  -- 法人分类编号（1企业 2个人 0合计）
    ,lp_cls_name  -- 法人分类名称
    -- 20260206 新增 
    ,LP_CLS_PROD -- 产品分类 (1 IPC/2数据贷)
    ,etl_timestamp  -- ETL处理时间戳
     ) 
     with tmp_ped as
       (select '099' as ped_no
              ,'累计' as ped_name
          from dual
        union all
        select '001' as ped_no
              ,'当日' as ped_name
          from dual
        union all
        select '002' as ped_no
              ,'当月' as ped_name
          from dual
        union all
        select '004' as ped_no
              ,'当年' as ped_name
          from dual
         union all
        select '003' as ped_no
              ,'当季' as ped_name
          from dual
          union all
        select '005' as ped_no
              ,'当周' as ped_name
          from dual),
       tmp_lp_cls as
       (select '0' as lp_cls_id
              ,'合计' as lp_cls_name
          from dual
        union all
        select '1' as lp_cls_id
              ,'企业' as lp_cls_name
          from dual
        union all
        select '2' as lp_cls_id
              ,'个人' as lp_cls_name
          from dual),
        TMP_PRO_CLS AS (
                         SELECT '1' AS LP_CLS_PROD -- 数据贷_IPC
                         FROM DUAL
                         UNION ALL
                         SELECT '2' AS LP_CLS_PROD -- 数据贷_数据贷
                         FROM DUAL
                         UNION ALL
                         SELECT '0' AS LP_CLS_PROD -- 好企贷_合计 
                         FROM DUAL
                       )
      SELECT to_date('${batch_date}', 'yyyymmdd') etl_dt --数据日期
            ,T1.PED_NO --周期编号
            ,T1.PED_NAME --周期名称
            ,(CASE  WHEN T1.ORG_NO IN ('801','805') THEN '1'
                   WHEN T1.ORG_NO IN ('806','803','802') THEN '2'
                   WHEN T1.ORG_NO IN ('807','809') THEN '3'
                   WHEN T1.ORG_NO IN ('808','810') THEN '4'
                   WHEN T1.ORG_NO IN ('811','812') THEN '5'
                   WHEN T1.ORG_NO IN ('000000') THEN '0'
            END) AS grouping --排名
            ,T1.ORG_NO --机构编号
            ,T1.ORG_NAME --机构名称
            ,NVL(T2.ENTER_CNT,0) --进件数量 
            ,T1.LP_CLS_ID   -- 法人分类编号
            ,T1.LP_CLS_NAME -- 法人分类名称
            ,T1.LP_CLS_PROD -- 产品分类 
            ,SYSDATE --ETL处理 时间戳
      FROM  (SELECT * FROM MC_ORGA_PARA,TMP_PED,TMP_LP_CLS,TMP_PRO_CLS) T1 -- 机构树表
      LEFT JOIN MCKB_ENTER_TMP_01 T2
      ON     T1.ORG_NO = T2.ORG_NO
      AND    T1.PED_NO=T2.PED_NO 
      AND    T1.LP_CLS_ID=T2.LP_CLS_ID
      AND    T1.LP_CLS_PROD = T2.LP_CLS_PROD
      WHERE  T1.ORG_NO IN ('000000'
                             ,'801'
                             ,'802'
                             ,'803'
                             ,'805'
                             ,'806'
                             ,'807'
                             ,'808'
                             ,'809'
                             ,'810'
                             ,'811'
                             ,'812'
                             )
                             ;
COMMIT;

--只展示前十名
--delete mckb_enter_tmp_02 where rank>10;
--COMMIT;

-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.mckb_enter truncate partition p_${batch_date} reuse storage;

-- 3.3 exchage tm table and target table
alter table ${idl_schema}.mckb_enter exchange partition p_${batch_date} with table mckb_enter_tmp_02;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.mckb_enter to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.mckb_enter_tmp_01 purge ;
drop table ${idl_schema}.mckb_enter_tmp_02 purge ;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mckb_enter', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

           
            
