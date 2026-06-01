/*
Purpose:    全员营销看板T+1:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_cust_mgr_camp
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_cust_mgr_camp
-- 以下为依赖了上游的表 (OGG实时表):
msl_hgls_loan_borrow_info
msl_hgls_loan_req
msl_hgls_operate_channel_type
msl_hgls_loan_branch_website

-- 20260325
1、新增展示“经办人（即借据经办人名称）” 2、修改“姓名”名称为“来源渠道” 3、修改“岗位”名称为“渠道类别”


*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_cust_mgr_camp_tmp_01 purge ;
drop table ${idl_schema}.mckb_cust_mgr_camp_tmp_02 purge ;

alter table ${idl_schema}.mckb_cust_mgr_camp add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_cust_mgr_camp_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_camp
where 1=2 ;
create table  ${idl_schema}.mckb_cust_mgr_camp_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_camp
where 1=2 ;

-- 2.1 insert into table
INSERT /*+ append */INTO ${idl_schema}.MCKB_CUST_MGR_CAMP_TMP_01
               (ETL_DT      -- 数据日期
               ,PED_NO      -- 周期编号
               ,PED_NAME    -- 周期名称
               ,ORG_NO      -- 机构编号
               ,MGR_NO      -- 客户经理编号
               ,PS_NAME     -- 经办人 
               ,MGR_NAME    -- 客户经理名称
               ,JOBS_ID     -- 岗位编号
               ,CREATE_DATE -- 登记时间
               ,DISTR_AMT   -- 放款金额
               ,LP_CLS_ID   -- 法人分类编号
               ,LP_CLS_NAME -- 法人分类名称
               ,LP_CLS_PROD -- 产品分类
              
                )
        -- IPC 
     --累计
        SELECT 
               TO_DATE('${batch_date}', 'yyyymmdd') AS ETL_DT
               ,'099'                               AS PED_NO
               ,'累计'                              AS PED_NAME
               ,T4.ORG_NUM                          AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)          AS MGR_NO
               ,T5.NAME                             AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                     AS MGR_NAME
               ,T3.CHANNEL_TYPE                     AS JOBS_ID
               ,TRUNC(T5.CREATE_DATE)               AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                  AS DISTR_AMT
               ,'2'                                 AS LP_CLS_ID
               ,'个人'                              AS LP_CLS_NAME
               -- 20260206 新增 
               ,'1'                                 AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
        -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        AND   TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        UNION ALL
        --日
        SELECT 
               TO_DATE('${batch_date}', 'yyyymmdd') AS ETL_DT
               ,'001'                               AS PED_NO
               ,'当日'                              AS PED_NAME
               ,T4.ORG_NUM                          AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)          AS MGR_NO
			   ,T5.NAME                             AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                     AS MGR_NAME
               ,T3.CHANNEL_TYPE                     AS JOBS_ID
               ,TRUNC(T5.CREATE_DATE)               AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                  AS DISTR_AMT
               ,'2'                                 AS LP_CLS_ID
               ,'个人'                              AS LP_CLS_NAME  
               ,'1'                                 AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
        -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        AND TRUNC(T1.MAKE_LOAN_DATE)= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
         --月
        SELECT 
               TO_DATE('${batch_date}', 'yyyymmdd') AS ETL_DT
               ,'002'                               AS PED_NO
               ,'当月'                              AS PED_NAME
               ,T4.ORG_NUM                          AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)          AS MGR_NO
			   ,T5.NAME                             AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                     AS MGR_NAME
               ,T3.CHANNEL_TYPE                     AS JOBS_ID            
               ,TRUNC(T5.CREATE_DATE)               AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                  AS DISTR_AMT
               ,'2'                                 AS LP_CLS_ID
               ,'个人'                              AS LP_CLS_NAME  
               ,'1'                                 AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM   MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON     T1.REQ_CODE=T2.CODE
        AND    T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON     T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON     T4.CODE=T2.HOME_BRANCH
        AND    T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        AND   TRUNC(T1.MAKE_LOAN_DATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND   TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
         --年
        SELECT 
               TO_DATE('${batch_date}', 'yyyymmdd') AS ETL_DT
               ,'004'                               AS PED_NO
               ,'当年'                              AS PED_NAME
               ,T4.ORG_NUM                          AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)          AS MGR_NO
			   ,T5.NAME                             AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                     AS MGR_NAME
               ,T3.CHANNEL_TYPE                     AS JOBS_ID             
               ,TRUNC(T5.CREATE_DATE)               AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                  AS DISTR_AMT
               ,'2'                                 AS LP_CLS_ID
               ,'个人'                              AS LP_CLS_NAME  
               ,'1'                                 AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        AND   TRUNC(T1.MAKE_LOAN_DATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND   TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
         --周
        SELECT 
               TO_DATE('${batch_date}', 'yyyymmdd') AS ETL_DT
               ,'005'                               AS PED_NO
               ,'当周'                              AS PED_NAME
               ,T4.ORG_NUM                          AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)          AS MGR_NO
			   ,T5.NAME                             AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                     AS MGR_NAME
               ,T3.CHANNEL_TYPE                     AS JOBS_ID             
               ,TRUNC(T5.CREATE_DATE)               AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                  AS DISTR_AMT
               ,'2'                                 AS LP_CLS_ID
               ,'个人'                              AS LP_CLS_NAME  
               ,'1'                                 AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        AND   TRUNC(T1.MAKE_LOAN_DATE)>= TO_DATE('${week_start}','yyyymmdd')
        AND   TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
        --累计
        SELECT 
               TO_DATE('${batch_date}', 'yyyymmdd') AS ETL_DT
               ,'099'                               AS PED_NO
               ,'累计'                              AS PED_NAME
               ,T4.ORG_NUM                          AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)          AS MGR_NO
			   ,T5.NAME                             AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                     AS MGR_NAME
               ,T3.CHANNEL_TYPE                     AS JOBS_ID             
               ,TRUNC(T5.CREATE_DATE)               AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                  AS DISTR_AMT
               ,'1'                                 AS LP_CLS_ID
               ,'企业'                              AS LP_CLS_NAME  
               ,'1'                                 AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE='22'
        AND TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
         --日
        SELECT 
               TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
               ,'001'                              AS PED_NO
               ,'当日'                             AS PED_NAME
               ,T4.ORG_NUM                         AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)         AS MGR_NO
			   ,T5.NAME                            AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                    AS MGR_NAME
               ,T3.CHANNEL_TYPE                    AS JOBS_ID             
               ,TRUNC(T5.CREATE_DATE)              AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                 AS DISTR_AMT
               ,'1'                                AS LP_CLS_ID
               ,'企业'                             AS LP_CLS_NAME  
               ,'1'                                AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE='22'
        AND   TRUNC(T1.MAKE_LOAN_DATE)= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
         --月
        SELECT 
              TO_DATE('${batch_date}', 'yyyymmdd') AS ETL_DT
              ,'002'                               AS PED_NO
              ,'当月'                              AS PED_NAME
              ,T4.ORG_NUM                          AS ORG_NO
              ,TO_CHAR(T2.SURVEY_USER_ID)          AS MGR_NO
			  ,T5.NAME                             AS PS_NAME   -- 经办人名称 
              ,T3.CHANNEL_NAME                     AS MGR_NAME
              ,T3.CHANNEL_TYPE                     AS JOBS_ID             
              ,TRUNC(T5.CREATE_DATE)               AS CREATE_DATE -- 登记时间 -- 20260206 新增
              ,SUM(T1.LEND_MONEY)                  AS DISTR_AMT
              ,'1'                                 AS LP_CLS_ID
              ,'企业'                              AS LP_CLS_NAME  
              ,'1'                                 AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
            
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE='22'
        AND   TRUNC(T1.MAKE_LOAN_DATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND   TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
         --年
        SELECT 
               TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
               ,'004'                              AS PED_NO
               ,'当年'                             AS PED_NAME
               ,T4.ORG_NUM                         AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)         AS MGR_NO
			   ,T5.NAME                            AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                    AS MGR_NAME
               ,T3.CHANNEL_TYPE                    AS JOBS_ID             
               ,TRUNC(T5.CREATE_DATE)              AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                 AS DISTR_AMT
               ,'1'                                AS LP_CLS_ID
               ,'企业'                             AS LP_CLS_NAME  
               ,'1'                                AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM   MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON     T1.REQ_CODE=T2.CODE
        AND    T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON     T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON     T4.CODE=T2.HOME_BRANCH
        AND    T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON     T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE  T1.PRD_TYPE='22'
        AND    TRUNC(T1.MAKE_LOAN_DATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND    TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        UNION ALL
         --周
        SELECT 
               TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
               ,'005'                              AS PED_NO
               ,'当周'                             AS PED_NAME
               ,T4.ORG_NUM                         AS ORG_NO
               ,TO_CHAR(T2.SURVEY_USER_ID)         AS MGR_NO
			   ,T5.NAME                            AS PS_NAME   -- 经办人名称 
               ,T3.CHANNEL_NAME                    AS MGR_NAME
               ,T3.CHANNEL_TYPE                    AS JOBS_ID             
               ,TRUNC(T5.CREATE_DATE)              AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,SUM(T1.LEND_MONEY)                 AS DISTR_AMT
               ,'1'                                AS LP_CLS_ID
               ,'企业'                             AS LP_CLS_NAME  
               ,'1'                                AS LP_CLS_PROD -- 产品分类 1 是IPC/2 是数据贷
        FROM  MSL_HGLS_LOAN_BORROW_INFO T1
        LEFT JOIN MSL_HGLS_LOAN_REQ T2
        ON    T1.REQ_CODE=T2.CODE
        AND   T2.ISDEL = 0
        INNER JOIN MSL_HGLS_OPERATE_CHANNEL_TYPE T3
        ON    T3.ID=T2.CHANNEL
        LEFT JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T4
        ON    T4.CODE=T2.HOME_BRANCH
        AND   T4.ISDEL=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON    T5.CLIENT_ID = T2.SURVEY_USER_ID 
        WHERE T1.PRD_TYPE='22'
        AND TRUNC(T1.MAKE_LOAN_DATE)>= TO_DATE('${week_start}','yyyymmdd')
        AND TRUNC(T1.MAKE_LOAN_DATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T3.CHANNEL_NAME
                ,T4.ORG_NUM
                ,T3.CHANNEL_TYPE
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
				,T5.NAME
        -- 好企贷 数据贷 
         -- 20260206 新增 数据贷 
        -- 累计
        UNION ALL 
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                     AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(WL.BUSINESSSUM)                AS DISTR_AMT    -- 放款金额 
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL  
        LEFT JOIN MSL_ICMS_USER_INFO UI
        ON      UI.USERID = WL.INPUTUSERID
        -- LEFT JOIN ITL_EDW_CMM_TELLER_INFO TI
        -- ON      UI.USERID = TI.TELLER_ID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
         --日
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
				,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                        AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')       AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT        
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
        -- 月
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
				,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                     AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
        -- 年
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
				,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                     AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL 
        -- 周 
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'005'                              AS PED_NO
                ,'当周'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
				,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                     AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${week_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
        --累计
        SELECT  TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
				,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                     AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
        --日
        SELECT  TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
				,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
         --月
        SELECT  TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
				,'/'                                AS PS_NAME
                ,CLI.CLERK_NAME                    AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')    AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
         --年
        SELECT   TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'004'                               AS PED_NO
                ,'当年'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,UI.USERID                           AS MGR_NO       -- 推荐人用户编号
				,'/'                                 AS PS_NAME
                ,CLI.CLERK_NAME                     AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')      AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')     AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS ACVMNT_DATA_AMT           -- 业绩数据金额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
        UNION ALL
         --周 
        SELECT   TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'005'                               AS PED_NO
                ,'当周'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,UI.USERID                           AS MGR_NO       -- 推荐人用户编号
                ,'/'                                 AS PS_NAME
                ,CLI.CLERK_NAME                     AS MGR_NAME     -- 推荐人用户编号
                ,NVL(CLI.JOBS_DESCB,'客户经理')      AS JOBS_ID
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')     AS CREATE_DATE  -- 创建日期
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS ACVMNT_DATA_AMT           -- 业绩数据金额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${week_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
                 ,UI.USERID
                 ,CLI.CLERK_NAME
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
                 ,NVL(CLI.JOBS_DESCB,'客户经理')
                ;
      COMMIT;

-- 20260206 新增 产品合计  
 INSERT /*+ append */INTO ${idl_schema}.mckb_cust_mgr_camp_tmp_01
               (ETL_DT       -- 数据日期
               ,PED_NO       -- 周期编号
               ,PED_NAME     -- 周期名称
               --,GROUPING   -- 分组
               ,ORG_NO       -- 机构编号
               ,MGR_NO       -- 客户经理编号
               ,PS_NAME      -- 经办人 
               ,MGR_NAME     -- 客户经理名称
               ,JOBS_ID      -- 岗位编号
               ,CREATE_DATE  -- 登记时间
               --,ORG_NAME   -- 机构名称
               ,DISTR_AMT    -- 放款金额
               --,ACVMNT_DATA_TARGET --业绩数据目标
               --,ACVMNT_DATA_ARRIVE_RAT --业绩数据达成率
               ,LP_CLS_ID       -- 法人分类编号
               ,LP_CLS_NAME     -- 法人分类名称
               --,ETL_TIMESTAMP -- ETL处理时间戳
               ,LP_CLS_PROD
              )
        SELECT 
                 T1.ETL_DT          AS ETL_DT
                 ,T1.PED_NO         AS PED_NO
                 ,T1.PED_NAME       AS PED_NAME
                 ,T1.ORG_NO         AS ORG_NO
                 ,T1.MGR_NO         AS MGR_NO
                 ,T1.PS_NAME        AS PS_NAME
                 ,T1.MGR_NAME       AS MGR_NAME
                 ,T1.JOBS_ID        AS JOBS_ID
                 ,T1.CREATE_DATE    AS CREATE_DATE -- 登记时间
                 ,SUM(T1.DISTR_AMT) AS DISTR_AMT
                 ,T1.LP_CLS_ID      AS LP_CLS_ID
                 ,T1.LP_CLS_NAME    AS LP_CLS_NAME
                 ,'0'               AS LP_CLS_PROD
        FROM    MCKB_CUST_MGR_CAMP_TMP_01 T1
        GROUP BY T1.PED_NO
                ,T1.PED_NAME
                ,T1.ETL_DT
                ,T1.ORG_NO
                ,T1.MGR_NO 
                ,T1.MGR_NAME
                ,T1.JOBS_ID
                ,T1.CREATE_DATE
                ,T1.LP_CLS_ID  
                ,T1.LP_CLS_NAME
                ,T1.PS_NAME 
                ;
     COMMIT;

-- 汇总合计 
        INSERT /*+ append */INTO ${idl_schema}.mckb_cust_mgr_camp_tmp_01
               (ETL_DT       -- 数据日期
               ,PED_NO       -- 周期编号
               ,PED_NAME     -- 周期名称
               --,GROUPING   -- 分组
               ,ORG_NO       -- 机构编号
               ,MGR_NO       -- 客户经理编号
               ,PS_NAME      -- 经办人名称 
               ,MGR_NAME     -- 客户经理名称
               ,JOBS_ID      -- 岗位编号
               ,CREATE_DATE  -- 登记时间
               --,ORG_NAME   -- 机构名称
               ,DISTR_AMT    -- 放款金额
               --,ACVMNT_DATA_TARGET --业绩数据目标
               --,ACVMNT_DATA_ARRIVE_RAT --业绩数据达成率
               ,LP_CLS_ID       -- 法人分类编号
               ,LP_CLS_NAME     -- 法人分类名称
               --,ETL_TIMESTAMP -- ETL处理时间戳
               ,LP_CLS_PROD
              )
        SELECT 
                 T1.ETL_DT          AS ETL_DT
                 ,T1.PED_NO         AS PED_NO
                 ,T1.PED_NAME       AS PED_NAME
                 ,T1.ORG_NO         AS ORG_NO
                 ,T1.MGR_NO         AS MGR_NO
                 ,T1.PS_NAME        AS PS_NAME
                 ,T1.MGR_NAME       AS MGR_NAME
                 ,T1.JOBS_ID        AS JOBS_ID
                 ,T1.CREATE_DATE    AS CREATE_DATE -- 登记时间
                 ,SUM(T1.DISTR_AMT) AS DISTR_AMT
                 ,'0'               AS LP_CLS_ID
                 ,'合计'            AS LP_CLS_NAME
                 ,T1.LP_CLS_PROD    AS LP_CLS_PROD
        FROM    MCKB_CUST_MGR_CAMP_TMP_01 T1
        GROUP BY T1.PED_NO
                ,T1.PED_NAME
                ,T1.ETL_DT
                ,T1.ORG_NO
                ,T1.MGR_NAME
                ,T1.JOBS_ID
                ,T1.CREATE_DATE
                ,T1.MGR_NO 
                ,T1.LP_CLS_PROD
                ,T1.PS_NAME
                ;
     COMMIT;


        INSERT /*+ append */ INTO ${idl_schema}.mckb_cust_mgr_camp_tmp_02
                (ETL_DT        -- 数据日期
                ,PED_NO        -- 周期编号
                ,PED_NAME      -- 周期名称
                ,RANK          -- 排名
                ,ORG_NO        -- 机构编号
                ,ORG_NAME      -- 机构名称
                ,MGR_NO        -- 客户经理编号
                ,PS_NAME       -- 经办人  
                ,MGR_NAME      -- 客户经理名称
                ,JOBS_ID       -- 岗位编号
                ,JOBS_NAME     -- 岗位名称
                ,DISTR_AMT     -- 放款金额
                ,CREATE_DATE   -- 登记时间 
                ,LP_CLS_ID     -- 法人分类编号
                ,LP_CLS_NAME   -- 法人分类名称
                ,LP_CLS_PROD   -- 产品分类 
                ,ETL_TIMESTAMP -- ETL处理时间戳
                 ) 
        SELECT  TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT        -- 数据日期
                ,T1.PED_NO                          AS PED_NO        -- 周期编号
                ,T1.PED_NAME                        AS PED_NAME      -- 周期名称
                ,ROW_NUMBER() OVER(PARTITION BY T1.PED_NO,T1.LP_CLS_ID,T1.LP_CLS_PROD ORDER BY T1.DISTR_AMT DESC) AS RANK --排名
                ,T1.ORG_NO                          AS ORG_NO        -- 机构编号
                ,T2.ORG_NAME                        AS ORG_NAME      -- 机构名称
                ,T1.MGR_NO                          AS MGR_NO        -- 客户经理编号
                ,T1.PS_NAME                         AS PS_NAME       -- 经办人名称 
                ,T1.MGR_NAME                        AS MGR_NAME      -- 客户经理名称
                ,T1.JOBS_ID                         AS JOBS_ID       -- 渠道编号
                -- 20260310 注释 
                -- ,DECODE(T1.JOBS_ID,'13','客户经理','15','推荐员','5','业务岗员工','6','线上推广','7','线下推广','-') AS JOBS_NAME -- 渠道名称           
                 ,DECODE(T1.JOBS_ID,'13','客户经理','15','推荐员','5','业务岗员工','6','线上推广','7','线下推广',T1.JOBS_ID) AS JOBS_NAME -- 渠道名称           
                ,NVL(T1.DISTR_AMT,0)                AS DISTR_AMT     -- 放款金额
                ,T1.CREATE_DATE                     AS CREATE_DATE   -- 登记时间 
                ,T1.LP_CLS_ID                       AS LP_CLS_ID     -- 法人分类编号
                ,T1.LP_CLS_NAME                     AS LP_CLS_NAME   -- 法人分类名称
                ,T1.LP_CLS_PROD                     AS LP_CLS_PROD   -- 产品分类 
                ,SYSDATE                            AS ETL_TIMESTAMP -- ETL处理时间戳
        FROM  MCKB_CUST_MGR_CAMP_TMP_01 T1
        LEFT JOIN MC_ORGA_PARA T2
        ON    T2.ORG_NO=T1.ORG_NO
        -- LEFT JOIN MSL_HGLS_USER_CLIENT T3
        -- ON T3.CLIENT_ID=T1.MGR_NO 
        ;
COMMIT;

-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.mckb_cust_mgr_camp truncate partition p_${batch_date} reuse storage;

-- 3.3 exchage tm table and target table
alter table ${idl_schema}.mckb_cust_mgr_camp exchange partition p_${batch_date} with table mckb_cust_mgr_camp_tmp_02;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.mckb_cust_mgr_camp to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.mckb_cust_mgr_camp_tmp_01 purge ;
drop table ${idl_schema}.mckb_cust_mgr_camp_tmp_02 purge ;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mckb_cust_mgr_camp', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

           
            
