/*
Purpose:    全员营销看板准实时:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔15分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_cust_mgr_camp_realtime
-- 以下为依赖了上游的表 (OGG实时表):
msl_hgls_loan_borrow_info
msl_hgls_loan_req
msl_hgls_operate_channel_type
msl_hgls_loan_branch_website

-- 20260324 增加 经办人名称 PS_NAME

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_cust_mgr_camp_realtime_tmp_01 purge ;
drop table ${idl_schema}.mckb_cust_mgr_camp_realtime_tmp_02 purge ;

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_cust_mgr_camp_realtime_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_camp_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_cust_mgr_camp_realtime_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_camp_realtime
where 1=2 ;

set serveroutput on 
DECLARE 
    CURSOR  CUR_RUN_LOGS IS 
    SELECT log_id
      ,index_no
      ,sum_start_time
      ,sum_end_time
      ,(CASE
           WHEN run_sts = '1' THEN
            '补跑'
           ELSE
            '正常'
       END) AS run_flag --批次类型判断
FROM   mcyy_realtime_run_log
WHERE  etl_dt = to_date('${batch_date}' ,'yyyymmdd')
AND    ((run_sts = 0) --正常批次                     
      OR run_sts = 1 AND to_char(SYSDATE,'HH24MI') -
      to_char(start_time,'HH24MI') >= 15) --补跑批次
AND    to_date(sum_end_time,'yyyy-mm-dd hh24:mi:ss') <= SYSDATE
AND    index_no ='MCKB_CUST_MGR_CAMP_REALTIME'
ORDER  BY sum_end_time,index_no;

BEGIN
       FOR REC_RUN_LOGS IN CUR_RUN_LOGS LOOP

-- 1.1 update log table
UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1:运行中
SET    run_sts = 1, start_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND    index_no ='MCKB_CUST_MGR_CAMP_REALTIME';
 
COMMIT;
delete mckb_cust_mgr_camp_realtime_tmp_01;
commit;
-- 2.1 insert into realtime table
INSERT /*+ append */
INTO ${idl_schema}.mckb_cust_mgr_camp_realtime_tmp_01
    (etl_dt      -- 数据日期
    ,ped_no      -- 周期编号
    ,ped_name    -- 周期名称
    ,org_no      -- 机构编号
    ,mgr_no      -- 客户经理编号
    ,PS_NAME     -- 经办人名称 
    ,mgr_name    -- 来源渠道
    ,jobs_id     -- 渠道类别 
    ,CREATE_DATE -- 登记日期 
    ,distr_amt   -- 放款金额
    ,lp_cls_id   -- 法人分类编号
    ,lp_cls_name -- 法人分类名称
    ,LP_CLS_PROD -- 产品分类 
     )
     --累计
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'099'                    as ped_no
               ,'累计'                   as ped_name
               ,t4.org_num               as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID)  AS mgr_no 
               ,T5.NAME                     AS PS_NAME   -- 经办人名称 
               ,t3.channel_name             as mgr_name  -- 来源渠道
               ,t3.channel_type             as jobs_id   -- 渠道类别
               ,TRUNC(T5.CREATE_DATE)       AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,sum(t1.lend_money)          as distr_amt
               ,'2'                         as lp_cls_id
               ,'个人'                      as lp_cls_name  
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on      t1.req_code=t2.code
        and     t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on       t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on       t4.code=t2.home_branch
        and      t4.isdel=0
        -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5  
        ON      T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where t1.prd_type in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
         --日
        select 
               rec_run_logs.sum_end_time   as etl_dt
               ,'001'                      as ped_no
               ,'当日'                     as ped_name
               ,t4.org_num                 as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID) AS mgr_no
               ,T5.NAME                    AS PS_NAME   -- 经办人名称 
               ,t3.channel_name            as mgr_name
               ,t3.channel_type            as jobs_id
               ,TRUNC(T5.CREATE_DATE)      AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,sum(t1.lend_money)         as distr_amt
               ,'2'                        as lp_cls_id
               ,'个人'                     as lp_cls_name  
               ,'1'                        AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on      t1.req_code=t2.code
        and     t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on      t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on      t4.code=t2.home_branch
        and     t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where   t1.prd_type in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        and    trunc(t1.make_loan_date)= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
         --月
        select 
              rec_run_logs.sum_end_time as etl_dt
              ,'002'                    as ped_no
              ,'当月'                   as ped_name
              ,t4.org_num               as org_no
              ,TO_CHAR(T2.SURVEY_USER_ID)        AS mgr_no
              ,T5.NAME                    AS PS_NAME   -- 经办人名称 
              ,t3.channel_name          as mgr_name
              ,t3.channel_type          as jobs_id
              ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
              ,sum(t1.lend_money)       as distr_amt
              ,'2'                      as lp_cls_id
              ,'个人'                   as lp_cls_name  
              ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from     msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on       t1.req_code=t2.code
        and      t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on       t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on       t4.code=t2.home_branch
        and      t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where    t1.prd_type in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        and      trunc(t1.make_loan_date)>= to_date('${month_start}','yyyymmdd')
        and      trunc(t1.make_loan_date)<= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
         --年
        select 
               rec_run_logs.sum_end_time as etl_dt
               ,'004'                    as ped_no
               ,'当年'                   as ped_name
               ,t4.org_num               as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID)        AS mgr_no
               ,T5.NAME                  AS PS_NAME   -- 经办人名称 
               ,t3.channel_name          as mgr_name
               ,t3.channel_type          as jobs_id
               ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
              ,sum(t1.lend_money)        as distr_amt
               ,'2'                      as lp_cls_id
               ,'个人'                   as lp_cls_name  
               ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from      msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on        t1.req_code=t2.code
        and       t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on        t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on        t4.code=t2.home_branch
        and       t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where     t1.prd_type in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        and       trunc(t1.make_loan_date)>= to_date('${year_start}','yyyymmdd')
        and       trunc(t1.make_loan_date)<= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        UNION ALL
         --周
        select 
               rec_run_logs.sum_end_time as etl_dt
               ,'005'                    as ped_no
               ,'当周'                   as ped_name
               ,t4.org_num               as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID)       AS mgr_no
               ,T5.NAME                    AS PS_NAME   -- 经办人名称 
               ,t3.channel_name          as mgr_name
               ,t3.channel_type          as jobs_id
               ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,sum(t1.lend_money)       as distr_amt
               ,'2'                      as lp_cls_id
               ,'个人'                   as lp_cls_name  
               ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from      msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on        t1.req_code=t2.code
        and       t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on         t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on        t4.code=t2.home_branch
        and       t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where     t1.prd_type in ('18','32','201') --18个人标准产品,32个人特色产品,201基线 / 22企业
        and       trunc(t1.make_loan_date)>= to_date('${week_start}','yyyymmdd')
        and       trunc(t1.make_loan_date)<= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
        --累计
        select 
               rec_run_logs.sum_end_time as etl_dt
               ,'099'                    as ped_no
               ,'累计'                   as ped_name
               ,t4.org_num               as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID)       AS mgr_no
               ,T5.NAME                  AS PS_NAME   -- 经办人名称 
               ,t3.channel_name          as mgr_name
               ,t3.channel_type          as jobs_id
               ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,sum(t1.lend_money)       as distr_amt
               ,'1'                      as lp_cls_id
               ,'企业'                   as lp_cls_name  
               ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from     msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on       t1.req_code=t2.code
        and      t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on       t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on        t4.code=t2.home_branch
        and       t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where    t1.prd_type='22'
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
         --日
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'001'                    as ped_no
               ,'当日'                   as ped_name
               ,t4.org_num               as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID) AS mgr_no
               ,T5.NAME                    AS PS_NAME   -- 经办人名称 
               ,t3.channel_name          as mgr_name
               ,t3.channel_type          as jobs_id
               ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,sum(t1.lend_money)       as distr_amt
               ,'1'                      as lp_cls_id
               ,'企业'                   as lp_cls_name  
               ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on      t1.req_code=t2.code
        and     t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on      t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on      t4.code=t2.home_branch
        and     t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where   t1.prd_type='22'
        and     trunc(t1.make_loan_date)= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
         --月
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'002'                    as ped_no
               ,'当月'                   as ped_name
               ,t4.org_num               as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID)        AS mgr_no
               ,T5.NAME                  AS PS_NAME   -- 经办人名称 
               ,t3.channel_name          as mgr_name
               ,t3.channel_type          as jobs_id
               ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,sum(t1.lend_money)       as distr_amt
               ,'1'                      as lp_cls_id
               ,'企业'                   as lp_cls_name  
               ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from   msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on     t1.req_code=t2.code
        and    t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on     t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on     t4.code=t2.home_branch
        and    t4.isdel=0
        -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON      T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where   t1.prd_type='22'
        and    trunc(t1.make_loan_date)>= to_date('${month_start}','yyyymmdd')
        and    trunc(t1.make_loan_date)<= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
         --年
        select 
               rec_run_logs.sum_end_time as etl_dt
               ,'004'                    as ped_no
               ,'当年'                   as ped_name
               ,t4.org_num               as org_no
               ,TO_CHAR(T2.SURVEY_USER_ID)        AS mgr_no
               ,T5.NAME                    AS PS_NAME   -- 经办人名称 
               ,t3.channel_name          as mgr_name
               ,t3.channel_type          as jobs_id
               ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
               ,sum(t1.lend_money)       as distr_amt
               ,'1'                      as lp_cls_id
               ,'企业'                   as lp_cls_name  
               ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on      t1.req_code=t2.code
        and     t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on      t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on      t4.code=t2.home_branch
        and     t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where   t1.prd_type='22'
        and     trunc(t1.make_loan_date)>= to_date('${year_start}','yyyymmdd')
        and     trunc(t1.make_loan_date)<= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        union all
         --周
        select 
              rec_run_logs.sum_end_time as etl_dt
              ,'005'                    as ped_no
              ,'当周'                   as ped_name
              ,t4.org_num               as org_no
              ,TO_CHAR(T2.SURVEY_USER_ID)     AS mgr_no
              ,T5.NAME                  AS PS_NAME   -- 经办人名称 
              ,t3.channel_name          as mgr_name
              ,t3.channel_type          as jobs_id
              ,TRUNC(T5.CREATE_DATE)    AS CREATE_DATE -- 登记时间 -- 20260206 新增
              ,sum(t1.lend_money)       as distr_amt
              ,'1'                      as lp_cls_id
              ,'企业'                   as lp_cls_name  
              ,'1'                      AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from   msl_hgls_loan_borrow_info t1
        left join msl_hgls_loan_req t2
        on    t1.req_code=t2.code
        and   t2.isdel = 0
        inner join msl_hgls_operate_channel_type t3
        on    t3.id=t2.channel
        left join msl_hgls_loan_branch_website t4
        on    t4.code=t2.home_branch
        and   t4.isdel=0
         -- 20260206 把 登记日期移动到临时表 
        LEFT JOIN MSL_HGLS_USER_CLIENT T5
        ON   T5.CLIENT_ID = T2.SURVEY_USER_ID 
        where t1.prd_type='22'
        and   trunc(t1.make_loan_date)>= to_date('${week_start}','yyyymmdd')
        and   trunc(t1.make_loan_date)<= to_date('${batch_date}','yyyymmdd')
        group by t3.channel_name
                ,t4.org_num
                ,t3.channel_type
                ,TO_CHAR(T2.SURVEY_USER_ID)
                ,TRUNC(T5.CREATE_DATE)
                ,T5.NAME
        -- 20260206 新增 
        -- 好企贷 数据贷 
        -- 20260206 新增 数据贷 
        -- 累计
        UNION ALL 
        SELECT 
                rec_run_logs.sum_end_time           AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO      -- 推荐人用户编号
                ,'/'                                AS PS_NAME     -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME    -- 来源渠道/推荐人 
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID     -- 渠道类别/岗位名称 
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 创建日期
                ,SUM(WL.BUSINESSSUM)                AS DISTR_AMT    -- 放款金额 
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL  
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        LEFT JOIN ITL_EDW_CMM_CLERK_INFO CLI 
        ON   CLI.CLERK_ID = WL.INPUTUSERID
        AND  CLI.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
        -- 源系统口径 
        -- LEFT JOIN ( 
        --            SELECT 
        --             USERID
        --            ,ROLEID
        --            ,ROW_NUMBER () OVER (PARTITION BY USERID ORDER BY BEGINTIME DESC) AS RN 
        --             FROM MSL_ICMS_USER_ROLE
        --             -- WHERE  USERID = '00051259'
        --             -- AND BEGINTIME IS NOT NULL 
        --             )UR  
        -- ON      UR.USERID = UI.USERID  
        -- AND     UR.RN = 1
        -- LEFT JOIN MSL_ICMS_AWE_ROLE_INFO RI  -- 400880
        -- ON      RI.ROLEID = UR.ROLEID 
        -- AND     RI.STATIONFLAG = '1'
        -- AND     UR.RN = 1
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
                rec_run_logs.sum_end_time           AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       
                ,'/'                                AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME     
                ,NVL(CLI.JOBS_DESCB,'客户经理')     AS JOBS_ID
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
                rec_run_logs.sum_end_time           AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       
                ,'/'                                AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME     
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
                rec_run_logs.sum_end_time           AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       
                ,'/'                                AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME     
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
                rec_run_logs.sum_end_time           AS ETL_DT
                ,'005'                              AS PED_NO
                ,'当周'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       
                ,'/'                                AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME     
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
        SELECT  rec_run_logs.sum_end_time           AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       
                ,'/'                                AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME     
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
        SELECT  rec_run_logs.sum_end_time           AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       
                ,'/'                                AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME     
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
        SELECT  rec_run_logs.sum_end_time           AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       
                ,'/'                                AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                     AS MGR_NAME     
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
        SELECT   rec_run_logs.sum_end_time           AS ETL_DT
                ,'004'                               AS PED_NO
                ,'当年'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,UI.USERID                           AS MGR_NO       
                ,'/'                                 AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                      AS MGR_NAME     
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
        SELECT   rec_run_logs.sum_end_time           AS ETL_DT
                ,'005'                               AS PED_NO
                ,'当周'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,UI.USERID                           AS MGR_NO       
                ,'/'                                 AS PS_NAME      -- 经办人名称 
                ,CLI.CLERK_NAME                      AS MGR_NAME     
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
      commit;
      
      
-- 20260206 新增 产品合计  
 INSERT /*+ append */INTO ${idl_schema}.mckb_cust_mgr_camp_realtime_tmp_01
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
                 ,T1.LP_CLS_ID         AS LP_CLS_ID
                 ,T1.LP_CLS_NAME       AS LP_CLS_NAME
                 ,'0'               AS LP_CLS_PROD
        FROM    mckb_cust_mgr_camp_realtime_tmp_01 T1
        GROUP BY T1.PED_NO
                ,T1.PED_NAME
                ,T1.ETL_DT
                ,T1.ORG_NO
                ,T1.MGR_NAME
                ,T1.JOBS_ID
                ,T1.MGR_NO 
                ,T1.CREATE_DATE
                ,T1.LP_CLS_ID  
                ,T1.LP_CLS_NAME
                ,T1.PS_NAME
                ;
     COMMIT;
      
      
 INSERT /*+ append */INTO ${idl_schema}.mckb_cust_mgr_camp_realtime_tmp_01
    (etl_dt      -- 数据日期
    ,ped_no      -- 周期编号
    ,ped_name    -- 周期名称
    ,org_no      -- 机构编号
    ,mgr_no      -- 客户经理编号
    ,PS_NAME     -- 经办人 
    ,mgr_name    -- 客户经理名称
    ,jobs_id     -- 岗位编号
    ,CREATE_DATE -- 登记时间 
    ,distr_amt   -- 放款金额
    ,lp_cls_id   -- 法人分类编号
    ,lp_cls_name -- 法人分类名称
    ,LP_CLS_PROD -- 产品分类 
     )
      select 
                 t1.etl_dt          as etl_dt
                 ,t1.ped_no         as ped_no
                 ,t1.ped_name       as ped_name
                 ,t1.org_no         as org_no
                 ,T1.MGR_NO         AS MGR_NO
                 ,T1.PS_NAME        AS PS_NAME
                 ,t1.mgr_name       as mgr_name
                 ,t1.jobs_id        as jobs_id
                 ,T1.CREATE_DATE    AS CREATE_DATE -- 登记时间
                 ,sum(t1.distr_amt) as distr_amt
                 ,'0'               as lp_cls_id
                 ,'合计'            as lp_cls_name
                 ,T1.LP_CLS_PROD    AS LP_CLS_PROD  -- 产品分类  
           from mckb_cust_mgr_camp_realtime_tmp_01 t1
           group by t1.ped_no
                  ,t1.ped_name
                  ,t1.etl_dt
                  ,t1.org_no
                  ,t1.mgr_name
                  ,t1.jobs_id
                  ,t1.mgr_no 
                  ,T1.LP_CLS_PROD 
                  ,T1.CREATE_DATE
                  ,T1.PS_NAME
                  ;
     commit;
delete mckb_cust_mgr_camp_realtime;
commit;
 INSERT /*+ append */INTO ${idl_schema}.mckb_cust_mgr_camp_realtime
    (etl_dt        -- 数据日期
    ,ped_no        -- 周期编号
    ,ped_name      -- 周期名称
    ,rank          -- 排名
    ,org_no        -- 机构编号
    ,org_name      -- 机构名称
    ,mgr_no        -- 客户经理编号
    ,PS_NAME       -- 经办人 
    ,mgr_name      -- 客户经理名称
    ,jobs_id       -- 岗位编号
    ,jobs_name     -- 岗位名称
    ,distr_amt     -- 放款金额
    ,create_date   -- 登记时间 
    ,lp_cls_id     -- 法人分类编号
    ,lp_cls_name   -- 法人分类名称
    ,LP_CLS_PROD   --产品分类 
    ,etl_timestamp -- etl处理时间戳
    
     )
     SELECT rec_run_logs.sum_end_time AS etl_dt       -- 数据日期
            ,T1.PED_NO                AS PED_NO       -- 周期编号
            ,T1.PED_NAME              AS PED_NAME     -- 周期名称
            ,ROW_NUMBER() OVER(PARTITION BY T1.PED_NO,T1.LP_CLS_ID,T1.LP_CLS_PROD ORDER BY T1.DISTR_AMT DESC) AS RANK --排名
            ,T1.ORG_NO                AS ORG_NO       -- 机构编号
            ,T2.ORG_NAME              AS ORG_NAME     -- 机构名称
            ,T1.MGR_NO                AS MGR_NO       -- 客户经理编号
            ,T1.PS_NAME               AS PS_NAME      -- 经办人 
            ,T1.MGR_NAME              AS MGR_NAME     -- 客户经理名称
            ,T1.JOBS_ID               AS JOBS_ID      -- 岗位编号
            ,decode(t1.jobs_id,'13','客户经理','15','推荐员','5','业务岗员工','6','线上推广','7','线下推广',t1.jobs_id) AS JOBS_NAME -- 岗位名称           
            ,NVL(T1.DISTR_AMT,0)      AS DISTR_AMT    -- 放款金额
            ,T1.CREATE_DATE           AS CREATE_DATE  -- 登记时间 
            ,T1.LP_CLS_ID             AS LP_CLS_ID    -- 法人分类编号
            ,T1.LP_CLS_NAME           AS LP_CLS_NAME  -- 法人分类名称
            ,LP_CLS_PROD              AS LP_CLS_PROD  -- 产品分类 
            ,SYSDATE                  AS ETL_TIMESTAMP-- ETL处理时间戳 
            
      FROM  mckb_cust_mgr_camp_realtime_tmp_01 t1
      LEFT JOIN mc_orga_para t2
      ON  t2.org_no=t1.org_no
      -- LEFT JOIN msl_hgls_user_client t3
      -- on t3.client_id=t1.mgr_no 
      ;
COMMIT;


-- 2.2 update log table 

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND   index_no ='MCKB_CUST_MGR_CAMP_REALTIME';

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mckb_cust_mgr_camp_realtime出错' || SQLERRM);
    
END;

/
           
            
