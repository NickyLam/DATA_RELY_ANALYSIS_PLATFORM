/*
Purpose:    全流程看板准实时:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔15分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20250213
Logs:

-- 生成的IDL层表 ：mckb_all_flow_realtime
-- 以下为依赖了上游的表 (OGG实时表):
msl_icms_business_duebill
msl_icms_hqd_ipc_legalperson_app
msl_icms_business_approve
msl_icms_business_contract

-- 20260112 新增 上游的表
WYD_RISK_JUDGE       -- 微业贷风险判别表
USER_INFO            -- 用户基本信息
WYD_LMT_RESU_RECEIVE -- 微业贷额度结果接收表
FLOW_TASK            -- 流程任务
WYD_LOAN             -- 贷款主文件
LOAN_BRANCH_WEBSITE 增加 IS_SHOW 映射关系 msl_hgls_loan_branch_website
-- 20260303 修改 数据贷 审批金额及审批户数 口径 
-- 模块 
--第1组：业绩数据
--第2组：进件/审批通过数据
--第3组：进件通过数
--第4组：进件拒绝数
--第5组：系统审批金额
-- 新增 
--第6组：调查 待电调/待实调
--第7组：调查通过
--第8组：调查拒绝
--第9组：质检通过 
--第10组：质检流程中 
--第11组：签约数量
--第12组：签约金额 

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_01 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_02 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_03 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_04 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_05 purge ;
-- 20260112新增
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_06 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_07 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_08 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_09 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_10 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_11 purge ;
drop table ${idl_schema}.mckb_all_flow_realtime_tmp_12 purge ;

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_all_flow_realtime_tmp_01 compress
AS 
select etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    ,org_no --机构编号
    ,acvmnt_data_acct_cnt 
    ,acvmnt_data_amt
    ,acvmnt_data_net_incremt
    ,lp_cls_id
    ,lp_cls_name --法人分类名称
     ,LP_CLS_PROD    --产品分类 
 from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_all_flow_realtime_tmp_02 compress
AS 
select etl_dt         -- 数据日期
    ,ped_no           -- 周期编号
    ,ped_name         -- 周期名称
    ,org_no           -- 机构编号
    ,enter_cnt        -- 进件
    ,sys_apv_acct_cnt --审批通过数据 
    ,lp_cls_id
    ,lp_cls_name     -- 法人分类名称
     ,LP_CLS_PROD    -- 产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_all_flow_realtime_tmp_03 compress
AS 
select etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    ,org_no --机构编号
    ,enter_pass_cnt 
    ,lp_cls_id
    ,lp_cls_name --法人分类名称
     ,LP_CLS_PROD    --产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_all_flow_realtime_tmp_04 compress
AS 
select etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    ,org_no --机构编号
    ,enter_refuse_cnt 
    ,lp_cls_id
    ,lp_cls_name --法人分类名称
     ,LP_CLS_PROD    --产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_all_flow_realtime_tmp_05 compress
AS 
select etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    ,org_no --机构编号
    ,sys_apv_amt 
    ,lp_cls_id
    ,lp_cls_name --法人分类名称
     ,LP_CLS_PROD    --产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;

-- 20260112 
create table  ${idl_schema}.mckb_all_flow_realtime_tmp_06 compress
AS 
select etl_dt      -- 数据日期
    ,ped_no        -- 周期编号
    ,ped_name      -- 周期名称
    ,org_no        -- 机构编号
    ,PREP_TEL_CNT  -- 待电调
    ,PREP_ACTL_CNT -- 待实调
    ,lp_cls_id
    ,lp_cls_name    --法人分类名称
    ,LP_CLS_PROD    --产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;

create table  ${idl_schema}.mckb_all_flow_realtime_tmp_07 compress
AS 
select etl_dt          -- 数据日期
    ,ped_no            -- 周期编号
    ,ped_name          -- 周期名称
    ,org_no            -- 机构编号
    ,INVSTG_PASS_CNT   -- 调查通过
    ,lp_cls_id
    ,lp_cls_name        -- 法人分类名称
    ,LP_CLS_PROD        -- 产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;

create table  ${idl_schema}.mckb_all_flow_realtime_tmp_08 compress
AS 
select etl_dt          --数据日期
    ,ped_no            --周期编号
    ,ped_name          --周期名称
    ,org_no            --机构编号
    ,INVSTG_REFUSE_CNT --调查拒绝
    ,lp_cls_id
    ,lp_cls_name        --法人分类名称
    ,LP_CLS_PROD        -- 产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;

create table  ${idl_schema}.mckb_all_flow_realtime_tmp_09 compress
AS 
select etl_dt        -- 数据日期
    ,ped_no          -- 周期编号
    ,ped_name        -- 周期名称
    ,org_no          -- 机构编号
    ,QLTY_CHECK_CNT  -- 质检通过
    ,lp_cls_id
    ,lp_cls_name --法人分类名称
    ,LP_CLS_PROD
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;

create table  ${idl_schema}.mckb_all_flow_realtime_tmp_10 compress
AS 
select etl_dt             --数据日期
    ,ped_no               --周期编号
    ,ped_name             --周期名称
    ,org_no               --机构编号
    ,QLTY_CHECK_FLOW_CNT  --质检流程中
    ,lp_cls_id
    ,lp_cls_name --法人分类名称
    ,LP_CLS_PROD --产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;

create table  ${idl_schema}.mckb_all_flow_realtime_tmp_11 compress
AS 
select etl_dt       -- 数据日期
    ,ped_no         -- 周期编号
    ,ped_name       -- 周期名称
    ,org_no         -- 机构编号
    ,SIGN_CUST_CNT  -- 签约客户数
    ,lp_cls_id
    ,lp_cls_name    -- 法人分类名称
    ,LP_CLS_PROD    -- 产品分类 
    from ${idl_schema}.mckb_all_flow_realtime
where 1=2 ;

create table  ${idl_schema}.mckb_all_flow_realtime_tmp_12 compress
AS 
select etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    ,org_no --机构编号
    ,SIGN_AMT       --签约金额
    ,lp_cls_id
    ,lp_cls_name --法人分类名称
    ,LP_CLS_PROD  -- 1 是IPC/2 是数据贷
    from ${idl_schema}.mckb_all_flow_realtime
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
AND    index_no ='MCKB_ALL_FLOW_REALTIME'
ORDER  BY sum_end_time,index_no;

BEGIN
       FOR REC_RUN_LOGS IN CUR_RUN_LOGS LOOP

-- 1.1 update log table
UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1:运行中
SET    run_sts = 1, start_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND    index_no ='MCKB_ALL_FLOW_REALTIME';
 
COMMIT;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_01  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_02  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_03  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_04  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_05  ; commit;
-- 20260112 新增 
delete ${idl_schema}.mckb_all_flow_realtime_tmp_06  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_07  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_08  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_09  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_10  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_11  ; commit;
delete ${idl_schema}.mckb_all_flow_realtime_tmp_12  ; commit;

--第1组：业绩数据
insert into ${idl_schema}.mckb_all_flow_realtime_tmp_01 

        --累计
        select 
               rec_run_logs.sum_end_time as etl_dt
               ,'099' as ped_no
               ,'累计' as ped_name
               ,substr(bd.inputorgid, 0, 3)   as org_no
               ,count(distinct bd.customerid) as acvmnt_data_acct_cnt   -- 业绩数据户数
               ,sum(bd.businesssum)           as acvmnt_data_amt        --业绩数据金额
               ,sum(bd.balance)               as acvmnt_data_net_incremt  --累计净增就是当前的余额
               ,case when productid='201020100054' then '2' else '1' end as lp_cls_id    -- 2 是个人/1是企业 
               ,case when productid='201020100054' then '个人' else '企业' end as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
          from msl_icms_business_duebill bd
         where inputorgid is not null
         and productid in ('201020100054','203010100012')
         and trunc(putoutdate) <= to_date('${batch_date}','yyyymmdd')
         group by substr(bd.inputorgid, 0, 3)
		 		 ,case when productid='201020100054' then '2' else '1' end
				 ,case when productid='201020100054' then '个人' else '企业' end
         union all
         --日
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'001' as ped_no
               ,'当日' as ped_name
               ,substr(bd.inputorgid, 0, 3) as org_no
               ,count(distinct bd.customerid) as acvmnt_data_acct_cnt
               ,sum(bd.businesssum) as acvmnt_data_amt
               ,sum(bd.balance)as acvmnt_data_net_incremt
               ,case when productid='201020100054' then '2' else '1' end as lp_cls_id    -- 2 是个人/1是企业 
               ,case when productid='201020100054' then '个人' else '企业' end as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
          from msl_icms_business_duebill bd
         where inputorgid is not null
         and productid in ('201020100054','203010100012')
               and trunc(putoutdate)= to_date('${batch_date}','yyyymmdd')
         group by substr(bd.inputorgid, 0, 3)
		 		 ,case when productid='201020100054' then '2' else '1' end
				 ,case when productid='201020100054' then '个人' else '企业' end		 
          union all
         --月
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'002' as ped_no
               ,'当月' as ped_name
               ,substr(bd.inputorgid, 0, 3) as org_no
               ,count(distinct bd.customerid) as acvmnt_data_acct_cnt
               ,sum(bd.businesssum) as acvmnt_data_amt
               ,sum(bd.balance) as acvmnt_data_net_incremt
               ,case when productid='201020100054' then '2' else '1' end as lp_cls_id    -- 2 是个人/1是企业 
               ,case when productid='201020100054' then '个人' else '企业' end as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
          from msl_icms_business_duebill bd
         where inputorgid is not null
         and productid in ('201020100054','203010100012')
               and trunc(putoutdate)>= to_date('${month_start}','yyyymmdd')
               and trunc(putoutdate)<= to_date('${batch_date}','yyyymmdd')
         group by substr(bd.inputorgid, 0, 3)
		 		 ,case when productid='201020100054' then '2' else '1' end
				 ,case when productid='201020100054' then '个人' else '企业' end		 
          union all
         --年
         select 
               rec_run_logs.sum_end_time as etl_dt
               ,'004' as ped_no
               ,'当年' as ped_name
               ,substr(bd.inputorgid, 0, 3) as org_no
               ,count(distinct bd.customerid) as acvmnt_data_acct_cnt
               ,sum(bd.businesssum) as acvmnt_data_amt
               ,sum(bd.balance) as acvmnt_data_net_incremt
               ,case when productid='201020100054' then '2' else '1' end as lp_cls_id    -- 2 是个人/1是企业 
               ,case when productid='201020100054' then '个人' else '企业' end as lp_cls_name
               ,'1'    AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
          from msl_icms_business_duebill bd
         where inputorgid is not null
         and productid in ('201020100054','203010100012')
               and trunc(putoutdate)>= to_date('${year_start}','yyyymmdd')
               and trunc(putoutdate)<= to_date('${batch_date}','yyyymmdd')
         group by substr(bd.inputorgid, 0, 3)
		 		 ,case when productid='201020100054' then '2' else '1' end
				 ,case when productid='201020100054' then '个人' else '企业' end		 
              UNION ALL 
        -- 20260112 好企贷_数据贷逻辑
        --累计
        SELECT 
                rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)      AS ACVMNT_DATA_ACCT_CNT    -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))             AS ACVMNT_DATA_NET_INCREMT -- 累计净增就是当前的余额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE    WL.INPUTORGID IS NOT NULL
        AND      WL.PRODUCTID = '201020100063' -- 个人 201020100063
        AND      TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
         --日
        SELECT 
               rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)      AS ACVMNT_DATA_ACCT_CNT    -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))             AS ACVMNT_DATA_NET_INCREMT -- 累计净增就是当前的余额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063
        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd'))= TO_DATE('${batch_date}','yyyymmdd')
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        
        UNION ALL
        -- 月
        SELECT 
                rec_run_logs.sum_end_time           AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)      AS ACVMNT_DATA_ACCT_CNT    -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))             AS ACVMNT_DATA_NET_INCREMT -- 累计净增就是当前的余额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063
        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
        -- 年
        SELECT 
                rec_run_logs.sum_end_time           AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)      AS ACVMNT_DATA_ACCT_CNT    -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))             AS ACVMNT_DATA_NET_INCREMT -- 累计净增就是当前的余额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063
        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        
        UNION ALL
        --累计
        SELECT  rec_run_logs.sum_end_time           AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)      AS ACVMNT_DATA_ACCT_CNT     -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))             AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))             AS ACVMNT_DATA_NET_INCREMT  -- 累计净增就是当前的余额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)      AS ACVMNT_DATA_ACCT_CNT     -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))             AS ACVMNT_DATA_NET_INCREMT  -- 累计净增就是当前的余额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
         --月
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)      AS ACVMNT_DATA_ACCT_CNT     -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))             AS ACVMNT_DATA_NET_INCREMT  -- 累计净增就是当前的余额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
         --年
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                               AS PED_NO
                ,'当年'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,COUNT(DISTINCT WL.CUSTOMERID)       AS ACVMNT_DATA_ACCT_CNT      -- 业绩数据户数
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS ACVMNT_DATA_AMT           -- 业绩数据金额
                ,SUM(NVL(WL.BALANCE,0))              AS ACVMNT_DATA_NET_INCREMT   -- 累计净增就是当前的余额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        -- AND      NVL(WL.BALANCE,0) > 0
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
        ;
commit;
--全行汇总          
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_01
     select 
                 etl_dt                        as etl_dt
                 ,ped_no                       as ped_no
                 ,ped_name                     as ped_name
                 ,'000000'                     as org_no
                 ,sum(acvmnt_data_acct_cnt)    as acvmnt_data_acct_cnt
                 ,sum(acvmnt_data_amt)         as acvmnt_data_amt
                 ,sum(acvmnt_data_net_incremt) as acvmnt_data_net_incremt
                 ,lp_cls_id                    as lp_cls_id
                 ,lp_cls_name                  as lp_cls_name
                 ,LP_CLS_PROD
           from mckb_all_flow_realtime_tmp_01 
           group by ped_no
                   ,ped_name
                   ,lp_cls_id
                   ,lp_cls_name
                   ,etl_dt
                   ,LP_CLS_PROD;
     commit;
     
-- 20260112 新增  
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_01
            SELECT 
                    ETL_DT                        AS ETL_DT
                    ,PED_NO                       AS PED_NO
                    ,PED_NAME                     AS PED_NAME
                    ,ORG_NO                       AS ORG_NO
                    ,SUM(ACVMNT_DATA_ACCT_CNT)    AS ACVMNT_DATA_ACCT_CNT      -- 业绩数据户数
                    ,SUM(ACVMNT_DATA_AMT)         AS ACVMNT_DATA_AMT           -- 业绩数据金额
                    ,SUM(ACVMNT_DATA_NET_INCREMT) AS ACVMNT_DATA_NET_INCREMT   -- 累计净增就是当前的余额
                    ,LP_CLS_ID                    AS LP_CLS_ID    -- 2 是个人/1是企业
                    ,LP_CLS_NAME                  AS LP_CLS_NAME
                    ,'0'                          AS LP_CLS_PROD -- 合计 
            FROM    mckb_all_flow_realtime_tmp_01 
            GROUP BY PED_NO
                    ,PED_NAME
                    ,LP_CLS_ID
                    ,LP_CLS_NAME
                    ,ETL_DT
                    ,ORG_NO
                    ;
     commit;

--合计汇总   
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_01
    select 
                 t1.etl_dt as etl_dt
                 ,t1.ped_no as ped_no
                 ,t1.ped_name as ped_name
                 ,t1.org_no as org_no
                 ,sum(t1.acvmnt_data_acct_cnt) as acvmnt_data_acct_cnt
                 ,sum(t1.acvmnt_data_amt) as acvmnt_data_amt
                 ,sum(t1.acvmnt_data_net_incremt) as acvmnt_data_net_incremt
                 ,'0' as lp_cls_id
                 ,'合计' as lp_cls_name
                 ,LP_CLS_PROD AS LP_CLS_PROD
           from mckb_all_flow_realtime_tmp_01 t1
           group by t1.ped_no
                   ,t1.ped_name
                   ,t1.etl_dt
                   ,t1.org_no
                   ,LP_CLS_PROD;
     commit;
--第2组：进件/审批通过数据
insert into ${idl_schema}.mckb_all_flow_realtime_tmp_02 

        SELECT  rec_run_logs.sum_end_time AS etl_dt
                ,T3.PED_NO                AS PED_NO  
                ,T3.PED_NAME              AS PED_NAME
                ,T3.ORG_NO                AS ORG_NO
                ,SUM(T3.ENTER_CNT)        AS ENTER_CNT
                ,SUM(T3.SYS_APV_ACCT_CNT) AS SYS_APV_ACCT_CNT
                ,T3.LP_CLS_ID             AS LP_CLS_ID
                ,T3.LP_CLS_NAME           AS LP_CLS_NAME
                ,T3.LP_CLS_PROD           AS LP_CLS_PROD

        FROM (
                 --累计
                 Select      
                       rec_run_logs.sum_end_time   as etl_dt
                       ,'099'  as ped_no
                       ,'累计' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('18','32') --18：个人标准产品,22：企业,32：个人特色产品/201 基线
                   and trunc(t1.req_date)<=to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
                 UNION ALL 
                 select      
                       rec_run_logs.sum_end_time   as etl_dt
                       ,'099' as ped_no
                       ,'累计' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (112) then t1.req_id else null end) as sys_apv_acct_cnt -- 信息补录完成
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('201') --18：个人标准产品,22：企业,32：个人特色产品/201 基线
                   and trunc(t1.req_date)<=to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
                 
                 union all
                 --日
                 select      
                       rec_run_logs.sum_end_time as etl_dt
                       ,'001' as ped_no
                       ,'当日' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('18','32') --18：个人标准产品,22：企业,32：个人特色产品
                   and trunc(t1.req_date)=to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
                 union all
                 --日
                 select      
                       rec_run_logs.sum_end_time as etl_dt
                       ,'001' as ped_no
                       ,'当日' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (112) then t1.req_id else null end) as sys_apv_acct_cnt -- 112 信息补录完成 
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('201') --18：个人标准产品,22：企业,32：个人特色产品
                   and trunc(t1.req_date)=to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
                  union all
                 --月
                 select      
                       rec_run_logs.sum_end_time as etl_dt
                       ,'002' as ped_no
                       ,'当月' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt             
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('18','32') --18：个人标准产品,22：企业,32：个人特色产品
                   and trunc(t1.req_date)>= to_date('${month_start}','yyyymmdd')
                   and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
                 union all
                 --月
                 select      
                       rec_run_logs.sum_end_time as etl_dt
                       ,'002' as ped_no
                       ,'当月' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (112) then t1.req_id else null end) as sys_apv_acct_cnt             
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('201') --18：个人标准产品,22：企业,32：个人特色产品
                   and trunc(t1.req_date)>= to_date('${month_start}','yyyymmdd')
                   and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
                  union all
                 --年
                 select      
                       rec_run_logs.sum_end_time as etl_dt
                       ,'004' as ped_no
                       ,'当年' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('18','32') --18：个人标准产品,22：企业,32：个人特色产品
                   and trunc(t1.req_date)>= to_date('${year_start}','yyyymmdd')
                   and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
                  union all
                 --年
                 select      
                       rec_run_logs.sum_end_time as etl_dt
                       ,'004' as ped_no
                       ,'当年' as ped_name
                       ,t2.org_num as org_no
                       ,count(distinct t1.req_id) as enter_cnt
                       ,count(case when t1.audit_status IN (112) then t1.req_id else null end) as sys_apv_acct_cnt
                       ,'2' as lp_cls_id
                       ,'个人' as lp_cls_name
                       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                 from msl_hgls_loan_req t1
                 inner join msl_hgls_loan_branch_website t2
                   on t1.home_branch=t2.code
                   and t2. ISDEL = 0
                 where t1.isdel = 0
                   and t1.PRD_TYPE in ('201') --18：个人标准产品,22：企业,32：个人特色产品
                   and trunc(t1.req_date)>= to_date('${year_start}','yyyymmdd')
                   and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
                 group by t2.org_num
        
         union all
         --累计
        select      
               rec_run_logs.sum_end_time as etl_dt
               ,'099' as ped_no
               ,'累计' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt             
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18：个人标准产品,22：企业,32：个人特色产品
           and trunc(t1.req_date)<=to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         union all
         --日
         select      
               rec_run_logs.sum_end_time as etl_dt
               ,'001' as ped_no
               ,'当日' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt             
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18：个人标准产品,22：企业,32：个人特色产品
           and trunc(t1.req_date)=to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
          union all
         --月
         select      
               rec_run_logs.sum_end_time as etl_dt
               ,'002' as ped_no
               ,'当月' as ped_name
               ,t2.org_num as org_no
               ,count(distinct t1.req_id) as enter_cnt
               ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt             
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18：个人标准产品,22：企业,32：个人特色产品
           and trunc(t1.req_date)>= to_date('${month_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         union all
         --年
         select      
               rec_run_logs.sum_end_time as etl_dt
               ,'004' as ped_no
               ,'当年' as ped_name
               ,t2.org_num as org_no   -- 805 展示样式
               ,count(distinct t1.req_id) as enter_cnt
               ,count(case when t1.audit_status IN (4,6) then t1.req_id else null end) as sys_apv_acct_cnt             
               ,'1' as lp_cls_id
               ,'企业' as lp_cls_name
               ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
         from msl_hgls_loan_req t1
         inner join msl_hgls_loan_branch_website t2
           on t1.home_branch=t2.code
           and t2. ISDEL = 0
         where t1.isdel = 0
           and t1.PRD_TYPE ='22' --18：个人标准产品,22：企业,32：个人特色产品
           and trunc(t1.req_date)>= to_date('${year_start}','yyyymmdd')
           and trunc(t1.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by t2.org_num
         )T3 
        GROUP BY  T3.PED_NO               
                  ,T3.PED_NAME             
                  ,T3.ORG_NO               
                  ,T3.LP_CLS_ID            
                  ,T3.LP_CLS_NAME          
                  ,T3.LP_CLS_PROD          
                 
                 
           -- 20260112 数据贷_好企贷逻辑
        UNION ALL 
        SELECT 
                 REC_RUN_LOGS.SUM_END_TIME          AS ETL_DT
                ,T3.PED_NO                          AS PED_NO
                ,T3.PED_NAME                        AS PED_NAME
                ,T3.ORG_NO                          AS ORG_NO
                ,SUM(T3.ENTER_CNT)                  AS ENTER_CNT        -- 进件数
                ,SUM(T3.SYS_APV_ACCT_CNT)           AS SYS_APV_ACCT_CNT -- 系统审批户数
                ,T3.LP_CLS_ID
                ,T3.LP_CLS_NAME
                ,T3.LP_CLS_PROD
        FROM    (
                     SELECT      
                            REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                            ,'099'                              AS PED_NO
                            ,'累计'                             AS PED_NAME
                            ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO
                            ,COUNT(T1.SERIALNO)                 AS ENTER_CNT        -- 进件数/流水号
                            ,0                                  AS SYS_APV_ACCT_CNT -- 系统审批户数
                            ,'2'                                AS LP_CLS_ID        -- 2 是个人/1是企业
                            ,'个人'                             AS LP_CLS_NAME
                            ,'2'                                AS LP_CLS_PROD      -- 1 是IPC/2 是数据贷
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
                             REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                             ,'001'                              AS PED_NO
                             ,'当日'                             AS PED_NAME
                             ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO
                             ,COUNT(T1.SERIALNO)                 AS ENTER_CNT        -- 进件数/微众客户ID
                             ,0                                  AS SYS_APV_ACCT_CNT -- 系统审批户数
                             ,'2'                                AS LP_CLS_ID        -- 2 是个人/1是企业
                             ,'个人'                             AS LP_CLS_NAME
                             ,'2'                                AS LP_CLS_PROD      -- 1 是IPC/2 是数据贷
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
                             REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                             ,'002'                              AS PED_NO
                             ,'当月'                             AS PED_NAME
                             ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO
                             ,COUNT(T1.SERIALNO)                 AS ENTER_CNT        -- 进件数/微众客户ID
                             ,0                                  AS SYS_APV_ACCT_CNT -- 系统审批户数       
                             ,'2'                                AS LP_CLS_ID        -- 2 是个人/1是企业
                             ,'个人'                             AS LP_CLS_NAME
                             ,'2'                                AS LP_CLS_PROD      -- 1 是IPC/2 是数据贷
                     FROM    MSL_ICMS_WYD_RISK_JUDGE T1  -- 微业贷风险判别表
                     INNER JOIN MSL_ICMS_USER_INFO T2    -- 用户基本信息
                     ON     T2.USERID = T1.RECOMMENDER
                     AND    T2.BELONGORG IS NOT NULL  -- 归属机构 
                     WHERE  TRUNC(T1.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
                     AND    TRUNC(T1.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
                     AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                     GROUP BY SUBSTR(T2.BELONGORG,0,3)
                     UNION ALL
                      --年
                     SELECT      
                             REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                             ,'004'                              AS PED_NO
                             ,'当年'                             AS PED_NAME
                             ,SUBSTR(T2.BELONGORG,0,3)           AS ORG_NO           -- 归属机构
                             ,COUNT(T1.SERIALNO)                 AS ENTER_CNT        -- 进件数/微众客户ID
                             ,0                                  AS SYS_APV_ACCT_CNT -- 系统审批户数     
                             ,'2'                                AS LP_CLS_ID        -- 2 是个人/1是企业
                             ,'个人'                             AS LP_CLS_NAME
                             ,'2'                                AS LP_CLS_PROD      -- 1 是IPC/2 是数据贷
                     FROM    MSL_ICMS_WYD_RISK_JUDGE T1  -- 微业贷风险判别表
                     INNER JOIN MSL_ICMS_USER_INFO T2    -- 用户基本信息
                     ON     T2.USERID = T1.RECOMMENDER
                     AND    T2.BELONGORG IS NOT NULL  -- 归属机构    
                     WHERE  TRUNC(T1.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
                     AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
                     AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                     GROUP BY SUBSTR(T2.BELONGORG,0,3)
                     UNION ALL 
                     -- 数据贷 系统审批户数  
                     -- 累计 
                     SELECT      
                            REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                            ,'099'                              AS PED_NO
                            ,'累计'                             AS PED_NAME
                            ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO
                            ,0                                  AS ENTER_CNT        -- 进件数
                           ,COUNT(DISTINCT T3.CUSTOMERID)       AS SYS_APV_ACCT_CNT -- 系统审批户数
                            ,'2'                                AS LP_CLS_ID        -- 2 是个人/1是企业
                            ,'个人'                             AS LP_CLS_NAME
                            ,'2'                                AS LP_CLS_PROD       -- 1 是IPC/2 是数据贷
                    FROM ( 
                               SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3) AS INPUTORGID
                                      ,T1.CUSTOMERID            AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                               FROM  MSL_ICMS_FLOW_TASK FT 
                                               WHERE FT.OBJECTNO = T1.SERIALNO 
                                               AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                               AND   FT.PHASENO ='1000' 
                                               AND   FT.PHASENAME='批准' 
                                               AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd') 
                                         )
                                UNION  
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)   AS INPUTORGID
                                      ,T1.CUSTOMERID              AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')-- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                   FROM  MSL_ICMS_FLOW_TASK FT 
                                                   WHERE FT.OBJECTNO = T1.SERIALNO 
                                                   AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                    )
                            )T3
                     GROUP BY SUBSTR(T3.INPUTORGID,0,3)

                     UNION ALL
                      --日
                    SELECT      
                             REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                             ,'001'                              AS PED_NO
                             ,'当日'                             AS PED_NAME
                             ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO
                             ,0                                  AS ENTER_CNT        -- 进件数
                             ,COUNT(DISTINCT T3.CUSTOMERID)      AS SYS_APV_ACCT_CNT -- 系统审批户数
                             ,'2'                                AS LP_CLS_ID        -- 2 是个人/1是企业
                             ,'个人'                             AS LP_CLS_NAME
                             ,'2'                                AS LP_CLS_PROD      -- 1 是IPC/2 是数据贷
                    FROM ( 
                               SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3) AS INPUTORGID
                                      ,T1.CUSTOMERID            AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                               FROM  MSL_ICMS_FLOW_TASK FT 
                                               WHERE FT.OBJECTNO = T1.SERIALNO 
                                               AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                               AND   FT.PHASENO ='1000' 
                                               AND   FT.PHASENAME='批准' 
                                               AND   TRUNC(FT.ENDTIME) = TO_DATE('${batch_date}','yyyymmdd') 
                                         )
                                UNION  
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)   AS INPUTORGID
                                      ,T1.CUSTOMERID              AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')-- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                   FROM  MSL_ICMS_FLOW_TASK FT 
                                                   WHERE FT.OBJECTNO = T1.SERIALNO 
                                                   AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                    )
                            )T3
                     GROUP BY SUBSTR(T3.INPUTORGID,0,3)

                     UNION ALL
                      --月
                     SELECT      
                             REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                             ,'002'                              AS PED_NO
                             ,'当月'                             AS PED_NAME
                             ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO
                             ,0                                  AS ENTER_CNT        -- 进件数
                            ,COUNT(DISTINCT T3.CUSTOMERID)       AS SYS_APV_ACCT_CNT -- 系统审批户数      
                             ,'2'                                AS LP_CLS_ID        -- 2 是个人/1是企业
                             ,'个人'                             AS LP_CLS_NAME
                             ,'2'                                AS LP_CLS_PROD      -- 1 是IPC/2 是数据贷
                     FROM ( 
                               SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3) AS INPUTORGID
                                      ,T1.CUSTOMERID            AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                               FROM  MSL_ICMS_FLOW_TASK FT 
                                               WHERE FT.OBJECTNO = T1.SERIALNO 
                                               AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                               AND   FT.PHASENO ='1000' 
                                               AND   FT.PHASENAME='批准' 
                                               AND   TRUNC(FT.ENDTIME) >= TO_DATE('${month_start}','yyyymmdd') 
                                               AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd')
                                         )
                                UNION  
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)   AS INPUTORGID
                                      ,T1.CUSTOMERID              AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')-- 登记日期
                                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                   FROM  MSL_ICMS_FLOW_TASK FT 
                                                   WHERE FT.OBJECTNO = T1.SERIALNO 
                                                   AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                    )
                            )T3
                     GROUP BY SUBSTR(T3.INPUTORGID,0,3)

                     UNION ALL
                      --年
                     SELECT      
                             REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                             ,'004'                              AS PED_NO
                             ,'当年'                             AS PED_NAME
                             ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO            -- 归属机构
                             ,0                                  AS ENTER_CNT         -- 进件数
                            ,COUNT(DISTINCT T3.CUSTOMERID)       AS SYS_APV_ACCT_CNT  -- 系统审批户数      
                             ,'2'                                AS LP_CLS_ID
                             ,'个人'                             AS LP_CLS_NAME
                             ,'2'                                AS LP_CLS_PROD       -- 1 是IPC/2 是数据贷
                     FROM ( 
                               SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3) AS INPUTORGID
                                      ,T1.CUSTOMERID            AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                               FROM  MSL_ICMS_FLOW_TASK FT 
                                               WHERE FT.OBJECTNO = T1.SERIALNO 
                                               AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                               AND   FT.PHASENO ='1000' 
                                               AND   FT.PHASENAME='批准' 
                                               AND   TRUNC(FT.ENDTIME) >= TO_DATE('${year_start}','yyyymmdd') 
                                               AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd')
                                         )
                                UNION  
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)   AS INPUTORGID
                                      ,T1.CUSTOMERID              AS CUSTOMERID
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd') -- 登记日期
                                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                   FROM  MSL_ICMS_FLOW_TASK FT 
                                                   WHERE FT.OBJECTNO = T1.SERIALNO 
                                                   AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                    )
                            )T3
                     GROUP BY SUBSTR(T3.INPUTORGID,0,3)
                     UNION ALL 
                     -- 累计 数据贷企业部分固定 4 笔 叶鑫 
                    SELECT  REC_RUN_LOGS.SUM_END_TIME            AS ETL_DT
                            ,'099'                               AS PED_NO
                            ,'累计'                              AS PED_NAME
                            ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                            ,0                                   AS ENTER_CNT 
                            ,COUNT(DISTINCT WL.CUSTOMERID)       AS SYS_APV_ACCT_CNT     -- 系统审批户数
                            ,'1'                                 AS LP_CLS_ID            -- 2 是个人/1是企业
                            ,'企业'                              AS LP_CLS_NAME          
                            ,'2'                                 AS LP_CLS_PROD          -- 1 是IPC/2 是数据贷
                    FROM    MSL_ICMS_WYD_LOAN WL
                    WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}', 'yyyymmdd')
                    AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                    GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                    UNION ALL 
                    -- 日 
                    SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                            ,'001'                              AS PED_NO
                            ,'当日'                             AS PED_NAME
                            ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                            ,0                                  AS ENTER_CNT 
                            ,COUNT(DISTINCT WL.CUSTOMERID)      AS SYS_APV_ACCT_CNT     -- 系统审批户数
                            ,'1'                                AS LP_CLS_ID
                            ,'企业'                             AS LP_CLS_NAME
                            ,'2'                                AS LP_CLS_PROD          -- 1 是IPC/2 是数据贷
                    FROM    MSL_ICMS_WYD_LOAN WL
                    WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) = TO_DATE('${batch_date}', 'yyyymmdd')
                    AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                    GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                    UNION ALL 
                    -- 月 
                    SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                            ,'002'                              AS PED_NO
                            ,'当月'                             AS PED_NAME
                            ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                            ,0                                  AS ENTER_CNT 
                            ,COUNT(DISTINCT WL.CUSTOMERID)      AS SYS_APV_ACCT_CNT     -- 系统审批户数
                            ,'1'                                AS LP_CLS_ID 
                            ,'企业'                             AS LP_CLS_NAME
                            ,'2'                                AS LP_CLS_PROD          -- 1 是IPC/2 是数据贷
                    FROM    MSL_ICMS_WYD_LOAN WL
                    WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${month_start}', 'yyyymmdd')
                    AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}', 'yyyymmdd')
                    AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                    GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                    UNION ALL 
                    -- 年 
                    SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                            ,'003'                              AS PED_NO
                            ,'当年'                             AS PED_NAME
                            ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                            ,0                                  AS ENTER_CNT 
                            ,COUNT(DISTINCT WL.CUSTOMERID)      AS SYS_APV_ACCT_CNT     -- 系统审批户数
                            ,'1'                                AS LP_CLS_ID
                            ,'企业'                             AS LP_CLS_NAME
                            ,'2'                                AS LP_CLS_PROD          -- 1 是IPC/2 是数据贷
                    FROM    MSL_ICMS_WYD_LOAN WL
                    WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${year_start}','yyyymmdd')
                    AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}', 'yyyymmdd')
                    AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                    GROUP BY SUBSTR(WL.INPUTORGID,0,3)
         )T3
         GROUP BY      T3.PED_NO                     
                      ,T3.PED_NAME                   
                      ,T3.ORG_NO                     
                      ,T3.LP_CLS_ID
                      ,T3.LP_CLS_NAME
                      ,T3.LP_CLS_PROD
                      ;
commit;
--全行汇总          
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_02
     select 
                 etl_dt as etl_dt
                 ,ped_no as ped_no
                 ,ped_name as ped_name
                 ,'000000' as org_no
                 ,sum(enter_cnt) as enter_cnt
                 ,sum(sys_apv_acct_cnt) as sys_apv_acct_cnt
                 ,lp_cls_id as lp_cls_id
                 ,lp_cls_name as lp_cls_name
                 ,LP_CLS_PROD
           from mckb_all_flow_realtime_tmp_02 
           group by ped_no
                   ,ped_name
                   ,lp_cls_id
                   ,lp_cls_name
                   ,etl_dt
                   ,LP_CLS_PROD;
     commit;
     
-- 产品汇总 
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_02
            SELECT 
                   ETL_DT                 AS ETL_DT
                   ,PED_NO                AS PED_NO
                   ,PED_NAME              AS PED_NAME
                   ,ORG_NO                AS ORG_NO
                   ,SUM(ENTER_CNT)        AS ENTER_CNT
                   ,SUM(SYS_APV_ACCT_CNT) AS SYS_APV_ACCT_CNT
                   ,LP_CLS_ID             AS LP_CLS_ID
                   ,LP_CLS_NAME           AS LP_CLS_NAME
                   ,'0'                   AS LP_CLS_PROD -- 产品分类编号
           FROM    mckb_all_flow_realtime_tmp_02 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,ORG_NO
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ;
     commit;
--合计汇总   
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_02
    select 
                 t1.etl_dt as etl_dt
                 ,t1.ped_no as ped_no
                 ,t1.ped_name as ped_name
                 ,t1.org_no as org_no
                 ,sum(enter_cnt) as enter_cnt
                 ,sum(sys_apv_acct_cnt) as sys_apv_acct_cnt
                 ,'0' as lp_cls_id
                 ,'合计' as lp_cls_name
                 ,LP_CLS_PROD
           from mckb_all_flow_realtime_tmp_02 t1
           group by t1.ped_no
                   ,t1.ped_name
                   ,t1.etl_dt
                   ,t1.org_no
                   ,LP_CLS_PROD;
     commit;
--第3组：进件通过数
insert into ${idl_schema}.mckb_all_flow_realtime_tmp_03  
--累计
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'099' as ped_no
       ,'累计' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
          and trunc(lr.req_date)<=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
 union all
 --日
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'001' as ped_no
       ,'当日' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
          and trunc(lr.req_date)=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18,32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
 union all
 --月
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'002' as ped_no
       ,'当月' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
          and trunc(lr.req_date)>= to_date('${month_start}','yyyymmdd')
          and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18,32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
 union all
 --年
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'004' as ped_no
       ,'当年' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
          and trunc(lr.req_date)>= to_date('${year_start}','yyyymmdd')
          and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18,32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
union all
--累计
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'099' as ped_no
       ,'累计' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type =22
          and trunc(lr.req_date)<=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
 union all
 --日
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'001' as ped_no
       ,'当日' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type =22
          and trunc(lr.req_date)=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
 union all
 --月
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'002' as ped_no
       ,'当月' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type =22
          and trunc(lr.req_date)>= to_date('${month_start}','yyyymmdd')
          and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')         
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
 union all
 --年
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'004' as ped_no
       ,'当年' as ped_name
       ,lbw.org_num as org_no
       ,count(distinct t.req_id) as enter_pass_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,','||listagg(lra.audit_status,',')||',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0 
          and lr.prd_type =22
          and trunc(lr.req_date)>= to_date('${year_start}','yyyymmdd')
          and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and ( t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' ) or
       (t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,63,%' )) or
       (t.prd_type = 22 and
       ((t.p_audit_status like '%,1,%'  and t.p_audit_status like '%,2,%'  and t.p_audit_status like '%,16,%' ) or (t.p_audit_status like '%,63,%' ))))
 group by lbw.org_num
        UNION ALL 
        -- 20260112 数据贷_好企贷逻辑
        SELECT 
                 rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,SUBSTR(T2.BELONGORG,0,3)            AS ORG_NO         -- 归属机构 
                ,COUNT(DISTINCT T1.SERIALNO)         AS ENTER_PASS_CNT -- 风险判别通过
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN  MSL_ICMS_USER_INFO T2 
        ON       T2.USERID = T1.RECOMMENDER  
        AND      SUBSTR(T2.BELONGORG,0,3) IS NOT NULL 
        WHERE    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND      T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND      T1.RISKRESULT IN ('Accept')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)
        UNION ALL
        --日
        SELECT 
                rec_run_logs.sum_end_time AS etl_dt
              ,'001'                                AS PED_NO
              ,'当日'                               AS PED_NAME
              ,SUBSTR(T2.BELONGORG,0,3)             AS ORG_NO
              ,COUNT(DISTINCT T1.SERIALNO)          AS ENTER_PASS_CNT
              ,'2'                                  AS LP_CLS_ID
              ,'个人'                               AS LP_CLS_NAME
              ,'2'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN  MSL_ICMS_USER_INFO T2 
        ON       T2.USERID = T1.RECOMMENDER  
        AND      SUBSTR(T2.BELONGORG,0,3) IS NOT NULL 
        WHERE    TRUNC(T1.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND      T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND      T1.RISKRESULT IN ('Accept')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)
        UNION ALL
        --月
        Select 
                rec_run_logs.sum_end_time AS ETL_DT
              ,'002'                                AS PED_NO
              ,'当月'                               AS PED_NAME
              ,SUBSTR(T2.BELONGORG,0,3)             AS ORG_NO
              ,COUNT(DISTINCT T1.SERIALNO)          AS ENTER_PASS_CNT
              ,'2'                                  AS LP_CLS_ID
              ,'个人'                               AS LP_CLS_NAME
              ,'2'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN  MSL_ICMS_USER_INFO T2 
        ON       T2.USERID = T1.RECOMMENDER  
        AND      SUBSTR(T2.BELONGORG,0,3) IS NOT NULL 
        WHERE    TRUNC(T1.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND      T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND      T1.RISKRESULT IN ('Accept')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)
        UNION ALL
        --年
        Select 
                rec_run_logs.sum_end_time AS ETL_DT
              ,'004'                                AS PED_NO
              ,'当年'                               AS PED_NAME
              ,SUBSTR(T2.BELONGORG,0,3)             AS ORG_NO
              ,COUNT(DISTINCT T1.SERIALNO)          AS ENTER_PASS_CNT
              ,'2'                                  AS LP_CLS_ID
              ,'个人'                               AS LP_CLS_NAME
              ,'2'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN  MSL_ICMS_USER_INFO T2 
        ON       T2.USERID = T1.RECOMMENDER  
        AND      SUBSTR(T2.BELONGORG,0,3) IS NOT NULL 
        WHERE    TRUNC(T1.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND      TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND      T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND      T1.RISKRESULT IN ('Accept')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)
        ;
commit;
--全行汇总          
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_03
        SELECT 
                 ETL_DT               AS ETL_DT
                 ,PED_NO              AS PED_NO
                 ,PED_NAME            AS PED_NAME
                 ,'000000'            AS ORG_NO
                 ,SUM(ENTER_PASS_CNT) AS ENTER_PASS_CNT
                 ,LP_CLS_ID           AS LP_CLS_ID
                 ,LP_CLS_NAME         AS LP_CLS_NAME
                 ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_03 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD
                   ;
     commit;

-- 产品汇总 
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_03
     SELECT 
                 ETL_DT               AS ETL_DT
                 ,PED_NO              AS PED_NO
                 ,PED_NAME            AS PED_NAME
                 ,ORG_NO              AS ORG_NO
                 ,SUM(ENTER_PASS_CNT) AS ENTER_PASS_CNT
                 ,LP_CLS_ID           AS LP_CLS_ID
                 ,LP_CLS_NAME         AS LP_CLS_NAME
                 ,'0'                 AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_03 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;

--合计汇总   
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_03
           SELECT 
                  T1.ETL_DT           AS ETL_DT
                 ,T1.PED_NO           AS PED_NO
                 ,T1.PED_NAME         AS PED_NAME
                 ,T1.ORG_NO           AS ORG_NO
                 ,SUM(ENTER_PASS_CNT) AS ENTER_PASS_CNT
                 ,'0'                 AS LP_CLS_ID
                 ,'合计'              AS LP_CLS_NAME
                 ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_03 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;

--第4组：进件拒绝数
insert into ${idl_schema}.mckb_all_flow_realtime_tmp_04 
--累计
select 
       rec_run_logs.sum_end_time as etl_dt
       ,'099' as ped_no
       ,'累计' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type in (18, 32,201)
               and trunc(req_date)<=to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
               and trunc(lr.req_date)<=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
 union all
 --日
select 
      rec_run_logs.sum_end_time as etl_dt
       ,'001' as ped_no
       ,'当日' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
               and trunc(req_date)=to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type in (18,32,201)
               and trunc(lr.req_date)=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
 union all
 --月
select 
         rec_run_logs.sum_end_time as etl_dt
       ,'002' as ped_no
       ,'当月' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
               and trunc(req_date)>= to_date('${month_start}','yyyymmdd')
               and trunc(req_date)<= to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
               and trunc(lr.req_date)>= to_date('${month_start}','yyyymmdd')
               and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
 union all
 --年
select 
       rec_run_logs.sum_end_time as etl_dt
       ,'004' as ped_no
       ,'当年' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
               and trunc(req_date)>= to_date('${year_start}','yyyymmdd')
               and trunc(req_date)<= to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'2' as lp_cls_id
       ,'个人' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type in (18,32,201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
               and trunc(lr.req_date)>= to_date('${year_start}','yyyymmdd')
               and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
 union all
 --累计
select 
       rec_run_logs.sum_end_time as etl_dt
       ,'099' as ped_no
       ,'累计' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type =22
               and trunc(req_date)<=to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type =22
               and trunc(lr.req_date)<=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
 union all
  --日
select 
      rec_run_logs.sum_end_time as etl_dt
       ,'001' as ped_no
       ,'当日' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type =22
               and trunc(req_date)=to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type =22
               and trunc(lr.req_date)=to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
 union all
 --月
select 
        rec_run_logs.sum_end_time as etl_dt
       ,'002' as ped_no
       ,'当月' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type =22
               and trunc(req_date)>= to_date('${month_start}','yyyymmdd')
               and trunc(req_date)<= to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type =22
               and trunc(lr.req_date)>= to_date('${month_start}','yyyymmdd')
               and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
 union all
 --年
select 
       rec_run_logs.sum_end_time as etl_dt
       ,'004' as ped_no
       ,'当年' as ped_name
       ,lbw.org_num as org_no
       ,(select count(1)
          from msl_hgls_loan_req
         where home_branch = lbw.code
               and isdel = 0
               and prd_type =22
               and trunc(req_date)>= to_date('${year_start}','yyyymmdd')
               and trunc(req_date)<= to_date('${batch_date}','yyyymmdd')
               ) - count(t.req_id) as enter_refuse_cnt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                  AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from (select lr.req_id
              ,lr.prd_type
              ,lr.home_branch
              ,',' || listagg(lra.audit_status, ',') || ',' p_audit_status
          from msl_hgls_loan_req lr
          left join msl_hgls_loan_req_audit lra on lr.req_id = lra.loan_id
         where lr.isdel = 0
               and lr.prd_type =22
               and trunc(lr.req_date)>= to_date('${year_start}','yyyymmdd')
               and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
         group by lr.req_id
                 ,lr.prd_type
                 ,lr.home_branch) t
 inner join msl_hgls_loan_branch_website lbw on t.home_branch = lbw.code
 where ((t.prd_type in (18, 32,201) and (t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%') or
       (t.p_audit_status like '%,2,%' and t.p_audit_status like '%,63,%')) or
       (t.prd_type = 22 and ((t.p_audit_status like '%,1,%' and t.p_audit_status like '%,2,%' and t.p_audit_status like '%,16,%') or (t.p_audit_status like '%,63,%'))))
 group by lbw.code
         ,lbw.org_num
          UNION ALL 
        -- 20260112 数据贷_好企贷逻辑
        --累计
        SELECT 
                rec_run_logs.sum_end_time AS ETL_DT
               ,'099'                               AS PED_NO
               ,'累计'                              AS PED_NAME
               ,SUBSTR(T2.BELONGORG,0,3)            AS ORG_NO
               ,COUNT(DISTINCT T1.SERIALNO )        AS ENTER_REFUSE_CNT -- 拒绝 = 标识+拒绝
               ,'2'                                 AS LP_CLS_ID
               ,'个人'                              AS LP_CLS_NAME
               ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM   MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN MSL_ICMS_USER_INFO T2  -- 用户基本信息
        ON     T2.USERID = T1.RECOMMENDER
        AND    T2.BELONGORG IS NOT NULL  -- 归属机构 
        WHERE  TRUNC(T1.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
        AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND    T1.RISKRESULT IN ('Warn','Reject')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)
        UNION ALL
         --日
        SELECT 
                 rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,SUBSTR(T2.BELONGORG,0,3)            AS ORG_NO
                ,COUNT(DISTINCT T1.SERIALNO )          AS ENTER_REFUSE_CNT -- 拒绝 = 标识+拒绝
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN MSL_ICMS_USER_INFO T2  -- 用户基本信息
        ON     T2.USERID = T1.RECOMMENDER
        AND    T2.BELONGORG IS NOT NULL  -- 归属机构 
        WHERE  TRUNC(T1.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
        AND    T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND    T1.RISKRESULT IN ('Warn','Reject')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)
        UNION ALL
         --月
        SELECT 
                 rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                               AS PED_NO
                ,'当月'                              AS PED_NAME
                ,SUBSTR(T2.BELONGORG,0,3)            AS ORG_NO
                ,COUNT(DISTINCT T1.SERIALNO )          AS ENTER_REFUSE_CNT -- 拒绝 = 标识+拒绝
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN MSL_ICMS_USER_INFO T2  -- 用户基本信息
        ON      T2.USERID = T1.RECOMMENDER
        AND     T2.BELONGORG IS NOT NULL  -- 归属机构 
        WHERE   TRUNC(T1.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd') -- 登记日期
        AND     TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND     T1.RISKRESULT IN ('Warn','Reject')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)
        UNION ALL
         --年
        SELECT 
                 rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                               AS PED_NO
                ,'当年'                              AS PED_NAME
                ,SUBSTR(T2.BELONGORG,0,3)            AS ORG_NO
                ,COUNT(DISTINCT T1.SERIALNO )          AS ENTER_REFUSE_CNT -- 拒绝 = 标识+拒绝
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_RISK_JUDGE T1 -- 微业贷风险判别表
        INNER JOIN MSL_ICMS_USER_INFO T2  -- 用户基本信息
        ON      T2.USERID = T1.RECOMMENDER
        AND     T2.BELONGORG IS NOT NULL  -- 归属机构 
        WHERE   TRUNC(T1.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd') -- 登记日期
        AND     TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
        AND     T1.RISKRESULT IN ('Warn','Reject')
        GROUP BY SUBSTR(T2.BELONGORG,0,3)    
        ;
commit;
--全行汇总          
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_04
     SELECT 
                 ETL_DT                 AS ETL_DT
                 ,PED_NO                AS PED_NO
                 ,PED_NAME              AS PED_NAME
                 ,'000000'              AS ORG_NO
                 ,SUM(ENTER_REFUSE_CNT) AS ENTER_REFUSE_CNT
                 ,LP_CLS_ID             AS LP_CLS_ID
                 ,LP_CLS_NAME           AS LP_CLS_NAME
                 ,LP_CLS_PROD           AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_04 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     COMMIT;
--产品汇总          
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_04
           SELECT 
                 ETL_DT                 AS ETL_DT
                 ,PED_NO                AS PED_NO
                 ,PED_NAME              AS PED_NAME
                 ,ORG_NO                AS ORG_NO
                 ,SUM(ENTER_REFUSE_CNT) AS ENTER_REFUSE_CNT
                 ,LP_CLS_ID             AS LP_CLS_ID
                 ,LP_CLS_NAME           AS LP_CLS_NAME
                 ,'0'                   AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_04 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     COMMIT;
--合计汇总   
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_04
            SELECT 
                 T1.ETL_DT               AS ETL_DT
                 ,T1.PED_NO              AS PED_NO
                 ,T1.PED_NAME            AS PED_NAME
                 ,T1.ORG_NO              AS ORG_NO
                 ,SUM(ENTER_REFUSE_CNT)  AS ENTER_REFUSE_CNT
                 ,'0'                    AS LP_CLS_ID
                 ,'合计'                 AS LP_CLS_NAME
                 ,LP_CLS_PROD           AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_04 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD;
     COMMIT;
--第5组：系统审批金额
insert into ${idl_schema}.mckb_all_flow_realtime_tmp_05

SELECT 
        rec_run_logs.sum_end_time as etl_dt
        ,T3.ped_no           AS ped_no
        ,T3.ped_name         AS ped_name
        ,T3.org_no           AS org_no
        ,SUM(T3.sys_apv_amt) AS sys_apv_amt
        ,T3.lp_cls_id        AS lp_cls_id
        ,T3.lp_cls_name      AS lp_cls_name
        ,T3.LP_CLS_PROD      AS LP_CLS_PROD

FROM  (
         --累计
         select rec_run_logs.sum_end_time as etl_dt
                ,'099' as ped_no
                ,'累计' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (18,32)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (4, 6)
                and trunc(lr.req_date)<=to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num
          UNION ALL 
          select rec_run_logs.sum_end_time as etl_dt
                ,'099' as ped_no
                ,'累计' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (112)
                and trunc(lr.req_date)<=to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num
          union all
          --日
          select rec_run_logs.sum_end_time as etl_dt
                ,'001' as ped_no
                ,'当日' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (18,32)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (4, 6)
                and trunc(lr.req_date)=to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num
          union all
          --日
          select rec_run_logs.sum_end_time as etl_dt
                ,'001' as ped_no
                ,'当日' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (112)
                and trunc(lr.req_date)=to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num
         union all
          --月
          select rec_run_logs.sum_end_time as etl_dt
                ,'002' as ped_no
                ,'当月' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (18,32)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (4, 6)
                and trunc(lr.req_date)>= to_date('${month_start}','yyyymmdd')
                and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num
          union all
          --月
          select rec_run_logs.sum_end_time as etl_dt
                ,'002' as ped_no
                ,'当月' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (112)
                and trunc(lr.req_date)>= to_date('${month_start}','yyyymmdd')
                and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num
          union all
          --年
          select rec_run_logs.sum_end_time as etl_dt
                ,'004' as ped_no
                ,'当年' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (18,32)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (4, 6)
                and trunc(lr.req_date)>= to_date('${year_start}','yyyymmdd')
                and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num
          union all
          --年
          select rec_run_logs.sum_end_time as etl_dt
                ,'004' as ped_no
                ,'当年' as ped_name
                ,lbw.org_num as org_no
                ,sum(lra.auth_money) as sys_apv_amt
                ,'2' as lp_cls_id
                ,'个人' as lp_cls_name
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
           from msl_hgls_loan_req lr
           left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
           left join (select lra.loan_id
                            ,lra.auth_money
                        from msl_hgls_loan_req_audit lra
                       inner join (select loan_id
                                        ,max(audit_date) audit_date
                                    from msl_hgls_loan_req_audit lra2
                                   where lra2.audit_status = '5'
                                   group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                                  and lra.loan_id = lra.loan_id
                                                                  and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
          where lr.isdel = 0
                and lr.prd_type in (201)  -- 18个人标准产品,32个人特色产品/201 基线 /22企业
                and lr.audit_status in (112)
                and trunc(lr.req_date)>= to_date('${year_start}','yyyymmdd')
                and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
          group by lbw.org_num

 union all
 --累计
select rec_run_logs.sum_end_time as etl_dt
       ,'099' as ped_no
       ,'累计' as ped_name
       ,lbw.org_num as org_no
       ,sum(lra.auth_money) as sys_apv_amt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from msl_hgls_loan_req lr
  left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
  left join (select lra.loan_id
                   ,lra.auth_money
               from msl_hgls_loan_req_audit lra
              inner join (select loan_id
                               ,max(audit_date) audit_date
                           from msl_hgls_loan_req_audit lra2
                          where lra2.audit_status = '5'
                          group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                         and lra.loan_id = lra.loan_id
                                                         and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
 where lr.isdel = 0
       and lr.prd_type =22
       and lr.audit_status in (4, 6)
       and trunc(lr.req_date)<=to_date('${batch_date}','yyyymmdd')
 group by lbw.org_num
 union all
 --日
 select rec_run_logs.sum_end_time as etl_dt
       ,'001' as ped_no
       ,'当日' as ped_name
       ,lbw.org_num as org_no
       ,sum(lra.auth_money) as sys_apv_amt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from msl_hgls_loan_req lr
  left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
  left join (select lra.loan_id
                   ,lra.auth_money
               from msl_hgls_loan_req_audit lra
              inner join (select loan_id
                               ,max(audit_date) audit_date
                           from msl_hgls_loan_req_audit lra2
                          where lra2.audit_status = '5'
                          group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                         and lra.loan_id = lra.loan_id
                                                         and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
 where lr.isdel = 0
       and lr.prd_type =22
       and lr.audit_status in (4, 6)
       and trunc(lr.req_date)=to_date('${batch_date}','yyyymmdd')
 group by lbw.org_num
union all
 --月
 select rec_run_logs.sum_end_time as etl_dt
       ,'002' as ped_no
       ,'当月' as ped_name
       ,lbw.org_num as org_no
       ,sum(lra.auth_money) as sys_apv_amt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from msl_hgls_loan_req lr
  left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
  left join (select lra.loan_id
                   ,lra.auth_money
               from msl_hgls_loan_req_audit lra
              inner join (select loan_id
                               ,max(audit_date) audit_date
                           from msl_hgls_loan_req_audit lra2
                          where lra2.audit_status = '5'
                          group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                         and lra.loan_id = lra.loan_id
                                                         and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
 where lr.isdel = 0
       and lr.prd_type =22
       and lr.audit_status in (4, 6)
       and trunc(lr.req_date)>= to_date('${month_start}','yyyymmdd')
       and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
 group by lbw.org_num
 union all
 --年
 select rec_run_logs.sum_end_time as etl_dt
       ,'004' as ped_no
       ,'当年' as ped_name
       ,lbw.org_num as org_no
       ,sum(lra.auth_money) as sys_apv_amt
       ,'1' as lp_cls_id
       ,'企业' as lp_cls_name
       ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
  from msl_hgls_loan_req lr
  left join msl_hgls_loan_branch_website lbw on lr.home_branch = lbw.code
  left join (select lra.loan_id
                   ,lra.auth_money
               from msl_hgls_loan_req_audit lra
              inner join (select loan_id
                               ,max(audit_date) audit_date
                           from msl_hgls_loan_req_audit lra2
                          where lra2.audit_status = '5'
                          group by lra2.loan_id) lra2 on lra.audit_status = '5'
                                                         and lra.loan_id = lra.loan_id
                                                         and lra.audit_date = lra2.audit_date) lra on lr.req_id = lra.loan_id
 where lr.isdel = 0
       and lr.prd_type =22
       and lr.audit_status in (4, 6)
       and trunc(lr.req_date)>= to_date('${year_start}','yyyymmdd')
       and trunc(lr.req_date)<= to_date('${batch_date}','yyyymmdd')
 group by lbw.org_num
         )T3
        GROUP BY  T3.ped_no          
                 ,T3.ped_name        
                 ,T3.org_no          
                 ,T3.lp_cls_id       
                 ,T3.lp_cls_name     
                 ,T3.LP_CLS_PROD     
       UNION ALL 
        -- 20260112 数据贷_好企贷逻辑
        --累计
        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,SUBSTR(T3.INPUTORGID,0,3)           AS ORG_NO
                ,SUM(NVL(T3.SYS_APV_AMT,0))          AS SYS_APV_AMT --系统审批金额
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM ( 
                SELECT 
                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                      ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    EXISTS (SELECT 1 
                                FROM  MSL_ICMS_FLOW_TASK FT 
                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                AND   FT.PHASENO ='1000' 
                                AND   FT.PHASENAME='批准' 
                                AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd') 
                          )
                UNION ALL 
                SELECT 
                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                      ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)       AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')-- 登记日期
                AND    NOT EXISTS (SELECT 1 
                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                     )
                )T3
        GROUP BY SUBSTR(T3.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,SUBSTR(T3.INPUTORGID,0,3)           AS ORG_NO
                ,SUM(NVL(T3.SYS_APV_AMT,0))          AS SYS_APV_AMT --系统审批金额
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM ( 
                SELECT 
                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                      ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    EXISTS (SELECT 1 
                                FROM  MSL_ICMS_FLOW_TASK FT 
                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                AND   FT.PHASENO ='1000' 
                                AND   FT.PHASENAME='批准' 
                                AND   TRUNC(FT.ENDTIME) = TO_DATE('${batch_date}','yyyymmdd') 
                          )
                UNION ALL 
                SELECT 
                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                     ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    TRUNC(T1.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')-- 登记日期
                AND    NOT EXISTS (SELECT 1 
                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                     )
                )T3
        GROUP BY SUBSTR(T3.INPUTORGID,0,3)
        UNION ALL
        --月
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO
                ,SUM(NVL(T3.SYS_APV_AMT,0))         AS SYS_APV_AMT --系统审批金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM ( 
                SELECT 
                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                       ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)       AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    EXISTS (SELECT 1 
                                FROM  MSL_ICMS_FLOW_TASK FT 
                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                AND   FT.PHASENO ='1000' 
                                AND   FT.PHASENAME='批准' 
                                AND   TRUNC(FT.ENDTIME) >= TO_DATE('${month_start}','yyyymmdd') 
                                AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd') 
                          )
                UNION ALL 
                SELECT 
                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                     ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    TRUNC(T1.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')-- 登记日期
                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                AND    NOT EXISTS (SELECT 1 
                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                     )
                )T3
        GROUP BY SUBSTR(T3.INPUTORGID,0,3)
        UNION ALL
        --年
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO
                ,SUM(NVL(T3.SYS_APV_AMT,0))         AS SYS_APV_AMT
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM ( 
                SELECT 
                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                      ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    EXISTS (SELECT 1 
                                FROM  MSL_ICMS_FLOW_TASK FT 
                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                AND   FT.PHASENO ='1000' 
                                AND   FT.PHASENAME='批准' 
                                AND   TRUNC(FT.ENDTIME) >= TO_DATE('${year_start}','yyyymmdd') 
                                AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd') 
                          )
                UNION ALL 
                SELECT 
                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                     ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                WHERE  T1.PRODUCTID = '201020100063' -- 个人数据 201020100063
                AND    T1.RISKRESULT = 'Accept' 
                AND    TRUNC(T1.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')-- 登记日期
                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                AND    NOT EXISTS (SELECT 1 
                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                     )
                )T3
        GROUP BY SUBSTR(T3.INPUTORGID,0,3)

        UNION ALL 
        SELECT   T4.ETL_DT           AS ETL_DT
                ,T4.PED_NO           AS PED_NO
                ,T4.PED_NAME         AS PED_NAME
                ,T4.ORG_NO           AS ORG_NO
                ,SUM(T4.SYS_APV_AMT) AS SYS_APV_AMT
                ,T4.LP_CLS_ID        AS LP_CLS_ID 
                ,T4.LP_CLS_NAME      AS LP_CLS_NAME
                ,T4.LP_CLS_PROD      AS LP_CLS_PROD -- 1 是IPC/2 是数据贷
        FROM (
                         --累计
                        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'099'                               AS PED_NO
                                ,'累计'                              AS PED_NAME
                                ,SUBSTR(T3.INPUTORGID,0,3)           AS ORG_NO
                                ,SUM(NVL(T3.SYS_APV_AMT,0))          AS SYS_APV_AMT --系统审批金额
                                ,'1'                                 AS LP_CLS_ID
                                ,'企业'                              AS LP_CLS_NAME
                                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM ( 
                                SELECT 
                                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                      ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                                FROM  MSL_ICMS_FLOW_TASK FT 
                                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                AND   FT.PHASENO ='1000' 
                                                AND   FT.PHASENAME='批准' 
                                                AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd') 
                                          )
                                UNION ALL 
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                     ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                     )
                                )T3
                        GROUP BY SUBSTR(T3.INPUTORGID,0,3)

                        UNION ALL
                        --日
                        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'001'                               AS PED_NO
                                ,'当日'                              AS PED_NAME
                                ,SUBSTR(T3.INPUTORGID,0,3)           AS ORG_NO
                                ,SUM(T3.SYS_APV_AMT)                 AS SYS_APV_AMT --系统审批金额
                                ,'1'                                 AS LP_CLS_ID
                                ,'企业'                              AS LP_CLS_NAME
                                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM ( 
                                SELECT 
                                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                       ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)       AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                                FROM  MSL_ICMS_FLOW_TASK FT 
                                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                AND   FT.PHASENO ='1000' 
                                                AND   FT.PHASENAME='批准' 
                                                AND   TRUNC(FT.ENDTIME) = TO_DATE('${batch_date}','yyyymmdd') 
                                          )
                                UNION ALL 
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                     ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                     )
                                )T3
                        GROUP BY SUBSTR(T3.INPUTORGID,0,3)

                        UNION ALL
                        --月
                        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'002'                              AS PED_NO
                                ,'当月'                             AS PED_NAME
                                ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO
                                ,SUM(T3.SYS_APV_AMT)                AS SYS_APV_AMT --系统审批金额
                                ,'1'                                AS LP_CLS_ID
                                ,'企业'                             AS LP_CLS_NAME
                                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM ( 
                                SELECT 
                                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                       ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)       AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                                FROM  MSL_ICMS_FLOW_TASK FT 
                                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                AND   FT.PHASENO ='1000' 
                                                AND   FT.PHASENAME='批准' 
                                                AND   TRUNC(FT.ENDTIME) >= TO_DATE('${month_start}','yyyymmdd') 
                                                AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd') 
                                          )
                                UNION ALL 
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                      ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)       AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd') -- 登记日期
                                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                     )
                                )T3
                        GROUP BY SUBSTR(T3.INPUTORGID,0,3)
                        UNION ALL
                        --年
                        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'004'                              AS PED_NO
                                ,'当年'                             AS PED_NAME
                                ,SUBSTR(T3.INPUTORGID,0,3)          AS ORG_NO
                                ,SUM(T3.SYS_APV_AMT)                AS SYS_APV_AMT
                                ,'1'                                AS LP_CLS_ID
                                ,'企业'                             AS LP_CLS_NAME
                                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM ( 
                                SELECT 
                                       SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                      ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    EXISTS (SELECT 1 
                                                FROM  MSL_ICMS_FLOW_TASK FT 
                                                WHERE FT.OBJECTNO = T1.SERIALNO 
                                                AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                AND   FT.PHASENO ='1000' 
                                                AND   FT.PHASENAME='批准' 
                                                AND   TRUNC(FT.ENDTIME) >= TO_DATE('${year_start}','yyyymmdd') 
                                                AND   TRUNC(FT.ENDTIME) <= TO_DATE('${batch_date}','yyyymmdd') 
                                          )
                                UNION ALL 
                                SELECT 
                                      SUBSTR(T1.INPUTORGID,0,3)                       AS INPUTORGID
                                     ,NVL(T1.UPDATEAMOUNT,T1.FINALAPPLYAMOUNT)        AS SYS_APV_AMT
                                FROM   MSL_ICMS_WYD_LMT_RESU_RECEIVE T1 -- 微业贷额度结果接收表
                                WHERE  T1.PRODUCTID = '203050100001' -- 个人数据 201020100063/企业 203050100001
                                AND    T1.RISKRESULT = 'Accept' 
                                AND    TRUNC(T1.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd') -- 登记日期
                                AND    TRUNC(T1.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd') -- 登记日期
                                AND    NOT EXISTS (SELECT 1 
                                                    FROM  MSL_ICMS_FLOW_TASK FT 
                                                    WHERE FT.OBJECTNO = T1.SERIALNO 
                                                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply' 
                                                     )
                                )T3
                        GROUP BY SUBSTR(T3.INPUTORGID,0,3)

                        UNION ALL
                        -- 由于微业贷上线的时候有4笔数据没有录入，所以使用 贷款主文件 取出这4笔数据进行
                        -- 累计 数据贷企业部分固定 4 笔 叶鑫 
                        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'099'                              AS PED_NO
                                ,'累计'                             AS PED_NAME
                                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                                ,SUM(NVL(WL.BUSINESSSUM,0))         AS SYS_APV_AMT          -- 系统审批金额
                                ,'1'                                AS LP_CLS_ID
                                ,'企业'                             AS LP_CLS_NAME
                                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
                        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
                        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                        -- AND      NVL(WL.BALANCE,0) > 0
                        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                        UNION ALL 
                        -- 日
                        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'001'                              AS PED_NO
                                ,'当日'                             AS PED_NAME
                                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                                ,SUM(NVL(WL.BUSINESSSUM,0))         AS SYS_APV_AMT          -- 系统审批金额
                                ,'1'                                AS LP_CLS_ID
                                ,'企业'                             AS LP_CLS_NAME
                                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM    MSL_ICMS_WYD_LOAN WL
                        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) = TO_DATE('${batch_date}','yyyymmdd')
                        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                        UNION ALL 
                        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'002'                              AS PED_NO
                                ,'当月'                             AS PED_NAME
                                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                                ,SUM(NVL(WL.BUSINESSSUM,0))         AS SYS_APV_AMT          -- 系统审批金额
                                ,'1'                                AS LP_CLS_ID
                                ,'企业'                             AS LP_CLS_NAME
                                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM    MSL_ICMS_WYD_LOAN WL
                        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${month_start}','yyyymmdd')
                        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
                        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                        -- AND      NVL(WL.BALANCE,0) > 0
                        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                        UNION ALL 
                        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                                ,'004'                              AS PED_NO
                                ,'当年'                             AS PED_NAME
                                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                                ,SUM(NVL(WL.BUSINESSSUM,0))         AS SYS_APV_AMT          -- 系统审批金额
                                ,'1'                                AS LP_CLS_ID
                                ,'企业'                             AS LP_CLS_NAME
                                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
                        FROM    MSL_ICMS_WYD_LOAN WL
                        WHERE   TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) >= TO_DATE('${year_start}','yyyymmdd')
                        AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd')) <= TO_DATE('${batch_date}','yyyymmdd')
                        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
                        -- AND      NVL(WL.BALANCE,0) > 0
                        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        )T4
        GROUP BY   T4.ETL_DT
                  ,T4.PED_NO
                  ,T4.PED_NAME
                  ,T4.ORG_NO
                  ,T4.LP_CLS_ID
                  ,T4.LP_CLS_NAME
                  ,T4.LP_CLS_PROD 
                  ;
commit;
--全行汇总          
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_05
     SELECT 
                 ETL_DT            AS ETL_DT
                 ,PED_NO           AS PED_NO
                 ,PED_NAME         AS PED_NAME
                 ,'000000'         AS ORG_NO
                 ,SUM(SYS_APV_AMT) AS SYS_APV_AMT
                 ,LP_CLS_ID        AS LP_CLS_ID
                 ,LP_CLS_NAME      AS LP_CLS_NAME
                 ,LP_CLS_PROD      AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_05 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     commit;

--产品汇总          
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_05
           SELECT 
                 ETL_DT            AS ETL_DT
                 ,PED_NO           AS PED_NO
                 ,PED_NAME         AS PED_NAME
                 ,ORG_NO           AS ORG_NO
                 ,SUM(SYS_APV_AMT) AS SYS_APV_AMT
                 ,LP_CLS_ID        AS LP_CLS_ID
                 ,LP_CLS_NAME      AS LP_CLS_NAME
                 ,'0'              AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_05 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;

--合计汇总   
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_05
           SELECT 
                 T1.ETL_DT         AS ETL_DT
                 ,T1.PED_NO        AS PED_NO
                 ,T1.PED_NAME      AS PED_NAME
                 ,T1.ORG_NO        AS ORG_NO
                 ,SUM(SYS_APV_AMT) AS SYS_APV_AMT
                 ,'0'              AS LP_CLS_ID
                 ,'合计'           AS LP_CLS_NAME
                 ,LP_CLS_PROD      AS LP_CLS_PROD
           FROM mckb_all_flow_realtime_tmp_05 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;


-- 20260112新增 
--第6组：调查 待电调/待实调
insert into ${idl_schema}.mckb_all_flow_realtime_tmp_06 
         -- 累计 IPC 
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        -- AND      T2.IS_SHOW = 1
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE)<=TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
        UNION ALL 
        -- 当日
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE) = TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
        UNION ALL 
        -- 当月
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        -- AND      T2.IS_SHOW = 1
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(T1.REQ_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
         UNION ALL 
        -- 当年
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        -- AND      T2.IS_SHOW = 1
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('18','32','201') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND      TRUNC(T1.REQ_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
        UNION ALL 
        -- 累计
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        -- AND      T2.IS_SHOW = 1
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('22') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE)<=TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
        UNION ALL 
        -- 当日
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        -- AND      T2.IS_SHOW = 1
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('22') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE) = TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
        UNION ALL 
        -- 当月
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        -- AND      T2.IS_SHOW = 1
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('22') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(T1.REQ_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
         UNION ALL 
        -- 当年
        SELECT      
                rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,T2.ORG_NUM                         AS ORG_NO
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (2) THEN T1.REQ_ID ELSE NULL END) AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN T1.AUDIT_STATUS IN (3) THEN T1.REQ_ID ELSE NULL END) AS PREP_ACTL_CNT --待实调
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'1'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_HGLS_LOAN_REQ T1
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE T2
        ON       T1.HOME_BRANCH=T2.CODE
        AND      LENGTH(T2.ORG_NUM)= 3 -- 800 总行/11个分行
        WHERE    T1.ISDEL = 0
        AND      T1.PRD_TYPE IN ('22') --18个人标准产品,32个人特色产品/201基线 ,22企业 
        AND      TRUNC(T1.REQ_DATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND      TRUNC(T1.REQ_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY T2.ORG_NUM
        UNION ALL 
        --累计 数据贷 
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Accept','Review')THEN WLRR.SERIALNO ELSE NULL END )      AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN WLRR.RISKRESULT NOT IN ('Accept','Reject')THEN WLRR.SERIALNO ELSE NULL END )  AS PREP_ACTL_CNT --待实调
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Accept','Review')THEN WLRR.SERIALNO ELSE NULL END )      AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN WLRR.RISKRESULT NOT IN ('Accept','Reject')THEN WLRR.SERIALNO ELSE NULL END )  AS PREP_ACTL_CNT --待实调
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --月
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Accept','Review')THEN WLRR.SERIALNO ELSE NULL END )      AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN WLRR.RISKRESULT NOT IN ('Accept','Reject')THEN WLRR.SERIALNO ELSE NULL END )  AS PREP_ACTL_CNT --待实调
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE    TRUNC(WLRR.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --年
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Accept','Review')THEN WLRR.SERIALNO ELSE NULL END )      AS PREP_TEL_CNT  --待电调
                ,COUNT(CASE WHEN WLRR.RISKRESULT NOT IN ('Accept','Reject')THEN WLRR.SERIALNO ELSE NULL END )  AS PREP_ACTL_CNT --待实调
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
;
 commit;
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_06
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,'000000'           AS ORG_NO
                   ,SUM(PREP_TEL_CNT)  AS PREP_TEL_CNT  --待电调
                   ,SUM(PREP_ACTL_CNT) AS PREP_TEL_CNT  --待实调
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,LP_CLS_PROD        AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_06 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     commit;

--产品汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_06
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,ORG_NO             AS ORG_NO
                   ,SUM(PREP_TEL_CNT)  AS PREP_TEL_CNT  --待电调
                   ,SUM(PREP_ACTL_CNT) AS PREP_TEL_CNT  --待实调
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,'0'                AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_06 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;

--合计汇总   
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_06
           SELECT 
                     T1.ETL_DT           AS ETL_DT
                    ,T1.PED_NO           AS PED_NO
                    ,T1.PED_NAME         AS PED_NAME
                    ,T1.ORG_NO           AS ORG_NO
                    ,SUM(PREP_TEL_CNT)   AS PREP_TEL_CNT  --待电调
                    ,SUM(PREP_ACTL_CNT)  AS PREP_TEL_CNT  --待实调
                    ,'0'                 AS LP_CLS_ID
                    ,'合计'              AS LP_CLS_NAME
                    ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM     mckb_all_flow_realtime_tmp_06 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;

--第7组：调查通过
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_07 
         --累计 IPC
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,LBW.ORG_NUM                         AS ORG_NO
                ,COUNT(DISTINCT LR.REQ_ID)           AS INVSTG_PASS_CNT  --调查通过
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                      WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                      ELSE NULL END                  AS LP_CLS_ID
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                      WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                      ELSE NULL END                  AS LP_CLS_NAME
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM)= 3 -- 800 总行/11个分行
        INNER JOIN ( SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                             ,LOAN_ID
                        FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                        WHERE AUDIT_STATUS = 12
                        AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                        GROUP BY LOAN_ID
                   ) LRA
        ON         LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    AND  (AUDIT_STATUS BETWEEN 31 AND 33)  
                    GROUP BY LOAN_ID
                   )LRADH
        ON        LR.REQ_ID = LRADH.LOAN_ID
        WHERE     LR.ISDEL = 0 
        AND       LR.PRD_TYPE IN (18,32,22,201) --18个人标准产品,32个人特色产品,22企业,201 基线
        AND       (TRUNC(LRADH.DHDATE) IS NULL OR LRA.ZHSXDATE > LRADH.DHDATE)
        GROUP BY  LBW.ORG_NUM
                 ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                       WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                       ELSE NULL END                 
                 ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                       WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                       ELSE NULL END  

        UNION ALL 
        --当日
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,LBW.ORG_NUM                         AS ORG_NO
                ,COUNT(DISTINCT LR.REQ_ID)           AS INVSTG_PASS_CNT  --调查通过
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                      WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                      ELSE NULL END                  AS LP_CLS_ID
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                      WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                      ELSE NULL END                  AS LP_CLS_NAME
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        INNER JOIN ( SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                             ,LOAN_ID
                        FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                        WHERE AUDIT_STATUS = 12
                        AND   TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                        GROUP BY LOAN_ID
                   ) LRA
        ON         LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                    AND  (AUDIT_STATUS BETWEEN 31 AND 33)  
                    GROUP BY LOAN_ID
                   )LRADH
        ON        LR.REQ_ID = LRADH.LOAN_ID
        WHERE     LR.ISDEL = 0 
        AND       PRD_TYPE IN (18,32,22,201) --18：个人标准产品,32：个人特色产品 ,22：企业
        AND       (TRUNC(LRADH.DHDATE) IS NULL OR LRA.ZHSXDATE > LRADH.DHDATE)
        GROUP BY  LBW.ORG_NUM
                 ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                       WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                       ELSE NULL END                 
                 ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                       WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                       ELSE NULL END                 
        UNION ALL 
        --当月
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                               AS PED_NO
                ,'当月'                              AS PED_NAME
                ,LBW.ORG_NUM                         AS ORG_NO
                ,COUNT(DISTINCT LR.REQ_ID)           AS INVSTG_PASS_CNT  --调查通过
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                      WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                      ELSE NULL END                  AS LP_CLS_ID
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                      WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                      ELSE NULL END                  AS LP_CLS_NAME
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        INNER JOIN ( SELECT   MAX(AUDIT_DATE) AS ZHSXDATE
                             ,LOAN_ID
                        FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                        WHERE AUDIT_STATUS = 12
                        AND   TRUNC(AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
                        AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                        GROUP BY LOAN_ID
                   ) LRA
        ON         LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
                    AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    AND  (AUDIT_STATUS BETWEEN 31 AND 33)  
                    GROUP BY LOAN_ID
                   )LRADH
        ON        LR.REQ_ID = LRADH.LOAN_ID
        WHERE     LR.ISDEL = 0 
        AND       PRD_TYPE IN (18,32,22,201) --18：个人标准产品,32：个人特色产品 ,22：企业
        AND       (TRUNC(LRADH.DHDATE) IS NULL OR LRA.ZHSXDATE > LRADH.DHDATE)
        GROUP BY  LBW.ORG_NUM
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                        WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                        ELSE NULL END                  
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                        WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                        ELSE NULL END                 
        UNION ALL 
        --当年
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                               AS PED_NO
                ,'当年'                              AS PED_NAME
                ,LBW.ORG_NUM                         AS ORG_NO
                ,COUNT(DISTINCT LR.REQ_ID)           AS INVSTG_PASS_CNT  --调查通过
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                      WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                      ELSE NULL END                  AS LP_CLS_ID
                ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                      WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                      ELSE NULL END                  AS LP_CLS_NAME
                ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        INNER JOIN ( SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                             ,LOAN_ID
                        FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                        WHERE AUDIT_STATUS = 12
                        AND   TRUNC(AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
                        AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                        GROUP BY LOAN_ID
                   ) LRA
        ON         LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
                    AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    AND  (AUDIT_STATUS BETWEEN 31 AND 33)  
                    GROUP BY LOAN_ID
                   )LRADH
        ON        LR.REQ_ID = LRADH.LOAN_ID
        WHERE     LR.ISDEL = 0 
        AND       PRD_TYPE IN (18,32,22,201) --18：个人标准产品,32：个人特色产品 ,22：企业
        AND       (TRUNC(LRADH.DHDATE) IS NULL OR LRA.ZHSXDATE > LRADH.DHDATE)
        GROUP BY  LBW.ORG_NUM
                 ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                       WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                       ELSE NULL END                  
                 ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                       WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                       ELSE NULL END                 
         UNION ALL 
        --累计 -- 数据贷
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Review','Accept')THEN WLRR.SERIALNO ELSE NULL END ) AS INVSTG_PASS_CNT  --调查通过
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='提交下一岗位' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Review','Accept')THEN WLRR.SERIALNO ELSE NULL END ) AS INVSTG_PASS_CNT  --调查通过
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='提交下一岗位' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --月
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Review','Accept')THEN WLRR.SERIALNO ELSE NULL END ) AS INVSTG_PASS_CNT  --调查通过
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE    TRUNC(WLRR.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND      WLRR.PRODUCTID = '201020100063'
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='提交下一岗位' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --年
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(CASE WHEN WLRR.RISKRESULT IN ('Review','Accept')THEN WLRR.SERIALNO ELSE NULL END ) AS INVSTG_PASS_CNT  --调查通过
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND      WLRR.PRODUCTID = '201020100063'
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='提交下一岗位' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
;
commit;
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_07
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,'000000'           AS ORG_NO
                   ,SUM(INVSTG_PASS_CNT)  AS INVSTG_PASS_CNT  --调查通过
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,LP_CLS_PROD        AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_07 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     commit;
     
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_07
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,ORG_NO             AS ORG_NO
                   ,SUM(INVSTG_PASS_CNT)  AS INVSTG_PASS_CNT  --调查通过
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,'0'                AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_07 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;
--合计汇总   
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_07
           SELECT 
                     T1.ETL_DT           AS ETL_DT
                    ,T1.PED_NO           AS PED_NO
                    ,T1.PED_NAME         AS PED_NAME
                    ,T1.ORG_NO           AS ORG_NO
                    ,SUM(INVSTG_PASS_CNT)  AS INVSTG_PASS_CNT  --调查通过
                    ,'0'                 AS LP_CLS_ID
                    ,'合计'              AS LP_CLS_NAME
                    ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM     mckb_all_flow_realtime_tmp_07 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;
     
--第8组：调查拒绝
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_08 
         -- 累计 IPC
        -- 1.准入和初审在查询时间区间内通过
        -- 2.进件当前状态为拒绝
        -- 3.没有调查通过记录或已被打回
        -- 只适用于 标准/特色/小微产品 prd_type in (18,32,22)
        SELECT      rec_run_logs.sum_end_time  AS ETL_DT
                    ,'099'                               AS PED_NO
                    ,'累计'                              AS PED_NAME
                    ,T.ORG_NUM                           AS ORG_NO
                    ,COUNT(*)                            AS INVSTG_REFUSE_CNT  --调查拒绝
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
       
        FROM (
                    SELECT     LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                              -- ,GROUP_CONCAT(LRA.AUDIT_STATUS) AS GROUPSTATUS
                              ,','||LISTAGG(LRA.AUDIT_STATUS,',')||',' AS GROUPSTATUS
                    FROM       MSL_HGLS_LOAN_REQ LR
                    INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
                    ON         LR.HOME_BRANCH = LBW.CODE 
                    AND        LENGTH(LBW.ORG_NUM) = 3 
                    INNER JOIN MSL_HGLS_LOAN_REQ_AUDIT LRA 
                    ON         LR.REQ_ID = LRA.LOAN_ID 
                    AND        TRUNC(LRA.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    WHERE      LR.ISDEL = 0 
                    AND        LR.PRD_TYPE IN (18,22,32,201)
                    AND        LR.AUDIT_STATUS > 90 
                    GROUP BY   LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                ) T
        LEFT JOIN  (
                    SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                           ,LOAN_ID 
                    FROM   MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE  AUDIT_STATUS = 12
                    AND    TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    )MAXDCTG
        ON      T.REQ_ID = MAXDCTG.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE (AUDIT_STATUS BETWEEN 31 AND 33) 
                    AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    ) LRADH
                ON T.REQ_ID = LRADH.LOAN_ID
        WHERE (MAXDCTG.ZHSXDATE IS NULL OR MAXDCTG.ZHSXDATE <= LRADH.DHDATE)
       --AND   ((T.PRD_TYPE = 22 AND ( (FIND_IN_SET('1',GROUPSTATUS) AND FIND_IN_SET('2',GROUPSTATUS) AND FIND_IN_SET('16',GROUPSTATUS)) OR FIND_IN_SET('63',GROUPSTATUS)))
       --        OR (T.PRD_TYPE IN (18, 32) AND (FIND_IN_SET('2', GROUPSTATUS) AND
       --                                        (FIND_IN_SET('1', GROUPSTATUS) OR (FIND_IN_SET('63', GROUPSTATUS))))
       --             ))
       AND   ((T.PRD_TYPE = 22 AND ( (T.GROUPSTATUS LIKE  '%,1,%' AND T.GROUPSTATUS LIKE  '%,2,%' AND T.GROUPSTATUS LIKE '%,16,%') OR T.GROUPSTATUS LIKE  '%,63,%'))
                OR (T.PRD_TYPE IN (18,32,201) AND (T.GROUPSTATUS LIKE  '%,2,%' AND
                                                (T.GROUPSTATUS LIKE  '%,1,%' OR (T.GROUPSTATUS LIKE  '%,63,%')))
                     ))

        GROUP BY     T.ORG_NUM                       
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END          
        UNION ALL
        -- 当日
        SELECT      rec_run_logs.sum_end_time  AS ETL_DT
                    ,'001'                               AS PED_NO
                    ,'当日'                              AS PED_NAME
                    ,T.ORG_NUM                           AS ORG_NO
                    ,COUNT(*)                            AS INVSTG_REFUSE_CNT  --调查拒绝
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
       
        FROM (
                    SELECT     LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                              ,','||LISTAGG(LRA.AUDIT_STATUS,',')||',' AS GROUPSTATUS
                    FROM       MSL_HGLS_LOAN_REQ LR
                    INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
                    ON         LR.HOME_BRANCH = LBW.CODE 
                    AND        LENGTH(LBW.ORG_NUM) = 3 
                    INNER JOIN MSL_HGLS_LOAN_REQ_AUDIT LRA 
                    ON         LR.REQ_ID = LRA.LOAN_ID 
                    AND        TRUNC(LRA.AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                    WHERE      LR.ISDEL = 0 
                    AND        LR.PRD_TYPE IN (18,22,32,201)
                    AND        LR.AUDIT_STATUS > 90 
                    GROUP BY   LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                ) T
        LEFT JOIN  (
                    SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                           ,LOAN_ID 
                    FROM   MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE  AUDIT_STATUS = 12
                    AND    TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    )MAXDCTG
        ON      T.REQ_ID = MAXDCTG.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE (AUDIT_STATUS BETWEEN 31 AND 33) 
                    AND   TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    ) LRADH
                ON T.REQ_ID = LRADH.LOAN_ID
        WHERE (MAXDCTG.ZHSXDATE IS NULL OR MAXDCTG.ZHSXDATE <= LRADH.DHDATE)
        AND   ((T.PRD_TYPE = 22 AND ( (T.GROUPSTATUS LIKE  '%,1,%' AND T.GROUPSTATUS LIKE  '%,2,%' AND T.GROUPSTATUS LIKE '%,16,%') OR T.GROUPSTATUS LIKE  '%,63,%'))
                OR (T.PRD_TYPE IN (18, 32,201) AND (T.GROUPSTATUS LIKE  '%,2,%' AND
                                                (T.GROUPSTATUS LIKE  '%,1,%' OR (T.GROUPSTATUS LIKE  '%,63,%')))
                     ))
        GROUP BY     T.ORG_NUM                       
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END               
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END          
        UNION ALL
        -- 当月
        SELECT      rec_run_logs.sum_end_time  AS ETL_DT
                    ,'002'                               AS PED_NO
                    ,'当月'                              AS PED_NAME
                    ,T.ORG_NUM                           AS ORG_NO
                    ,COUNT(*)                            AS INVSTG_REFUSE_CNT  --调查拒绝
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
       
        FROM (
                    SELECT     LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                               ,','||LISTAGG(LRA.AUDIT_STATUS,',')||',' AS GROUPSTATUS
                    FROM       MSL_HGLS_LOAN_REQ LR
                    INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
                    ON         LR.HOME_BRANCH = LBW.CODE 
                    AND        LENGTH(LBW.ORG_NUM) = 3 
                    INNER JOIN MSL_HGLS_LOAN_REQ_AUDIT LRA 
                    ON         LR.REQ_ID = LRA.LOAN_ID 
                    AND        TRUNC(LRA.AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
                    AND        TRUNC(LRA.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    WHERE      LR.ISDEL = 0 
                    AND        LR.PRD_TYPE IN (18,22,32,201)
                    AND        LR.AUDIT_STATUS > 90 
                    GROUP BY   LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                ) T
        LEFT JOIN  (
                    SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                           ,LOAN_ID 
                    FROM   MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE  AUDIT_STATUS = 12
                    AND    TRUNC(AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
                    AND    TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    )MAXDCTG
        ON      T.REQ_ID = MAXDCTG.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE (AUDIT_STATUS BETWEEN 31 AND 33) 
                    AND   TRUNC(AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
                    AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    ) LRADH
                ON T.REQ_ID = LRADH.LOAN_ID
        WHERE (MAXDCTG.ZHSXDATE IS NULL OR MAXDCTG.ZHSXDATE <= LRADH.DHDATE)
        AND   ((T.PRD_TYPE = 22 AND ( (T.GROUPSTATUS LIKE  '%,1,%' AND T.GROUPSTATUS LIKE  '%,2,%' AND T.GROUPSTATUS LIKE '%,16,%') OR T.GROUPSTATUS LIKE  '%,63,%'))
                OR (T.PRD_TYPE IN (18,32,201) AND (T.GROUPSTATUS LIKE  '%,2,%' AND
                                                (T.GROUPSTATUS LIKE  '%,1,%' OR (T.GROUPSTATUS LIKE  '%,63,%')))
                     ))
        GROUP BY     T.ORG_NUM                       
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                 
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END          
        UNION ALL
        -- 当年 
        SELECT      rec_run_logs.sum_end_time  AS ETL_DT
                    ,'004'                               AS PED_NO
                    ,'当年'                              AS PED_NAME
                    ,T.ORG_NUM                           AS ORG_NO
                    ,COUNT(*)                            AS INVSTG_REFUSE_CNT  --调查拒绝
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
       
        FROM (
                    SELECT     LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                              -- ,GROUP_CONCAT(LRA.AUDIT_STATUS) AS GROUPSTATUS
                               ,','||LISTAGG(LRA.AUDIT_STATUS,',')||',' AS GROUPSTATUS
                    FROM       MSL_HGLS_LOAN_REQ LR
                    INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
                    ON         LR.HOME_BRANCH = LBW.CODE 
                    AND        LENGTH(LBW.ORG_NUM) = 3 
                    INNER JOIN MSL_HGLS_LOAN_REQ_AUDIT LRA 
                    ON         LR.REQ_ID = LRA.LOAN_ID 
                    AND        TRUNC(LRA.AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
                    AND        TRUNC(LRA.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    WHERE      LR.ISDEL = 0 
                    AND        LR.PRD_TYPE IN (18,22,32,201)
                    AND        LR.AUDIT_STATUS > 90 
                    GROUP BY   LR.REQ_ID
                              ,LR.AUDIT_STATUS
                              ,LR.PRD_TYPE
                              ,LBW.ORG_NUM
                ) T
        LEFT JOIN  (
                    SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                           ,LOAN_ID 
                    FROM   MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE  AUDIT_STATUS = 12
                    AND    TRUNC(AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
                    AND    TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    )MAXDCTG
        ON      T.REQ_ID = MAXDCTG.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                          ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE (AUDIT_STATUS BETWEEN 31 AND 33) 
                    AND   TRUNC(AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
                    AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    GROUP BY LOAN_ID
                    ) LRADH
                ON T.REQ_ID = LRADH.LOAN_ID
        WHERE (MAXDCTG.ZHSXDATE IS NULL OR MAXDCTG.ZHSXDATE <= LRADH.DHDATE)
        AND   ((T.PRD_TYPE = 22 AND ( (T.GROUPSTATUS LIKE  '%,1,%' AND T.GROUPSTATUS LIKE  '%,2,%' AND T.GROUPSTATUS LIKE '%,16,%') OR T.GROUPSTATUS LIKE  '%,63,%'))
                OR (T.PRD_TYPE IN (18,32,201) AND (T.GROUPSTATUS LIKE  '%,2,%' AND
                                                (T.GROUPSTATUS LIKE  '%,1,%' OR (T.GROUPSTATUS LIKE  '%,63,%')))
                     ))
        GROUP BY     T.ORG_NUM                       
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN T.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                 
                    ,CASE WHEN T.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN T.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END          

        UNION ALL 
        -- 累计 数据贷
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(WLRR.SERIALNO)                AS INVSTG_REFUSE_CNT  --调查拒绝
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT IN ('Review','Reject')  -- Review人工审核/Reject 标识
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='否决' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(WLRR.SERIALNO)                AS INVSTG_REFUSE_CNT  --调查拒绝
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT IN ('Review','Reject')  -- Review人工审核/Reject 标识
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='否决' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --月
        SELECT  rec_run_logs.sum_end_time           AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(WLRR.SERIALNO)               AS INVSTG_REFUSE_CNT  --调查拒绝
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE    TRUNC(WLRR.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND      WLRR.PRODUCTID = '201020100063' -- Review人工审核
        AND      WLRR.RISKRESULT IN ('Review','Reject')  -- Review人工审核/Reject 标识
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='否决' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)

        UNION ALL
        --年
        SELECT  rec_run_logs.sum_end_time           AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(WLRR.SERIALNO)               AS INVSTG_REFUSE_CNT  --调查拒绝
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT IN ('Review','Reject')  -- Review人工审核/Reject 标识
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0010'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='否决' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)

;
 commit;
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_08
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,'000000'           AS ORG_NO
                   ,SUM(INVSTG_REFUSE_CNT)  AS INVSTG_REFUSE_CNT  --调查拒绝
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,LP_CLS_PROD        AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_08 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD
                   ;
     commit;

--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_08
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,ORG_NO             AS ORG_NO
                   ,SUM(INVSTG_REFUSE_CNT)  AS INVSTG_REFUSE_CNT  --调查拒绝
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,'0'                AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_08 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;

--合计汇总   
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_08
           SELECT 
                     T1.ETL_DT           AS ETL_DT
                    ,T1.PED_NO           AS PED_NO
                    ,T1.PED_NAME         AS PED_NAME
                    ,T1.ORG_NO           AS ORG_NO
                    ,SUM(INVSTG_REFUSE_CNT)  AS INVSTG_REFUSE_CNT  --调查拒绝
                    ,'0'                 AS LP_CLS_ID
                    ,'合计'              AS LP_CLS_NAME
                    ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM     mckb_all_flow_realtime_tmp_08 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;
     
--第9组：质检通过 
INSERT INTO  ${idl_schema}.mckb_all_flow_realtime_tmp_09 
        -- 累计 IPC
        SELECT    
                      rec_run_logs.sum_end_time AS ETL_DT
                     ,'099'                               AS PED_NO
                     ,'累计'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,COUNT(*)                            AS QLTY_CHECK_CNT  --质检通过
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                  AS LP_CLS_ID
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                           WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                           ELSE NULL END                  AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON        LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        INNER JOIN (  SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                              ,LOAN_ID 
                      FROM    MSL_HGLS_LOAN_REQ_AUDIT 
                      WHERE   AUDIT_STATUS IN (5,95)
                      AND     TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                      GROUP BY LOAN_ID
                    )LRA
        ON       LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                           ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    AND ((AUDIT_STATUS BETWEEN 31 AND 39 ) OR AUDIT_STATUS IN (15,74,75,76))  
                    GROUP BY LOAN_ID
                ) LRADH
        ON      LR.REQ_ID = LRADH.LOAN_ID
        WHERE   LR.ISDEL = 0 
        AND     LR.PRD_TYPE IN (18,22,32,201)
        AND CASE WHEN TRUNC(LRADH.DHDATE) IS NULL THEN 1 
                 WHEN LRA.ZHSXDATE > LRADH.DHDATE THEN 1 
                 ELSE 0 END = 1
        GROUP BY    LBW.ORG_NUM                          
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END  
        UNION ALL 
        -- 当日 
        SELECT    
                      rec_run_logs.sum_end_time AS ETL_DT
                     ,'001'                               AS PED_NO
                     ,'当日'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,COUNT(*)                            AS QLTY_CHECK_CNT  --质检通过
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                  AS LP_CLS_ID
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                           WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                           ELSE NULL END                  AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON        LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        INNER JOIN (  SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                              ,LOAN_ID 
                      FROM    MSL_HGLS_LOAN_REQ_AUDIT 
                      WHERE   AUDIT_STATUS IN (5,95)
                      AND     TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                      GROUP BY LOAN_ID
                    )LRA
        ON       LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                           ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
                    AND ((AUDIT_STATUS BETWEEN 31 AND 39 ) OR AUDIT_STATUS IN (15,74,75,76))  
                    GROUP BY LOAN_ID
                ) LRADH
        ON      LR.REQ_ID = LRADH.LOAN_ID
        WHERE   LR.ISDEL = 0 
        AND     LR.PRD_TYPE IN (18,22,32,201)
        AND CASE WHEN TRUNC(LRADH.DHDATE) IS NULL THEN 1 
                 WHEN LRA.ZHSXDATE > LRADH.DHDATE THEN 1 
                 ELSE 0 END = 1
        GROUP BY    LBW.ORG_NUM                          
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END  
        UNION ALL 
        -- 当月 
        SELECT    
                      rec_run_logs.sum_end_time AS ETL_DT
                     ,'002'                               AS PED_NO
                     ,'当月'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,COUNT(*)                            AS QLTY_CHECK_CNT  --质检通过
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                  AS LP_CLS_ID
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                           WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                           ELSE NULL END                  AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON          LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        INNER JOIN (  SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                              ,LOAN_ID 
                      FROM    MSL_HGLS_LOAN_REQ_AUDIT 
                      WHERE   AUDIT_STATUS IN (5,95)
                      AND     TRUNC(AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
                      AND     TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                      GROUP BY LOAN_ID
                    )LRA
        ON       LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                           ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
                    AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    AND ((AUDIT_STATUS BETWEEN 31 AND 39 ) OR AUDIT_STATUS IN (15,74,75,76))  
                    GROUP BY LOAN_ID
                ) LRADH
        ON      LR.REQ_ID = LRADH.LOAN_ID
        WHERE   LR.ISDEL = 0 
        AND     LR.PRD_TYPE IN (18,22,32,201)
        AND CASE WHEN TRUNC(LRADH.DHDATE) IS NULL THEN 1 
                 WHEN LRA.ZHSXDATE > LRADH.DHDATE THEN 1 
                 ELSE 0 END = 1
        GROUP BY    LBW.ORG_NUM                          
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END  
        UNION ALL 
        -- 当年 
        SELECT    
                     rec_run_logs.sum_end_time AS ETL_DT
                    ,'004'                               AS PED_NO
                    ,'当年'                              AS PED_NAME
                    ,LBW.ORG_NUM                         AS ORG_NO
                    ,COUNT(*)                            AS QLTY_CHECK_CNT  --质检通过
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM       MSL_HGLS_LOAN_REQ LR
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
        ON        LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        INNER JOIN (  SELECT MAX(AUDIT_DATE) AS ZHSXDATE
                              ,LOAN_ID 
                      FROM    MSL_HGLS_LOAN_REQ_AUDIT 
                      WHERE   AUDIT_STATUS IN (5,95)
                      AND     TRUNC(AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
                      AND     TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                      GROUP BY LOAN_ID
                    )LRA
        ON       LR.REQ_ID = LRA.LOAN_ID
        LEFT JOIN ( SELECT MAX(AUDIT_DATE) AS DHDATE
                           ,LOAN_ID 
                    FROM  MSL_HGLS_LOAN_REQ_AUDIT 
                    WHERE TRUNC(AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
                    AND   TRUNC(AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
                    AND ((AUDIT_STATUS BETWEEN 31 AND 39 ) OR AUDIT_STATUS IN (15,74,75,76))  
                    GROUP BY LOAN_ID
                ) LRADH
        ON      LR.REQ_ID = LRADH.LOAN_ID
        WHERE   LR.ISDEL = 0 
        AND     LR.PRD_TYPE IN (18,22,32,201)
        AND CASE WHEN TRUNC(LRADH.DHDATE) IS NULL THEN 1 
                 WHEN LRA.ZHSXDATE > LRADH.DHDATE THEN 1 
                 ELSE 0 END = 1
        GROUP BY    LBW.ORG_NUM                          
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END  
        UNION ALL 
        --累计 数据贷
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(WLRR.SERIALNO)                AS QLTY_CHECK_CNT  --质检通过 
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT = 'Accept' -- 通过
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型 
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='批准' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(WLRR.SERIALNO)                AS QLTY_CHECK_CNT  --质检通过 
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT = 'Accept' 
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='批准' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --月
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(WLRR.SERIALNO)               AS QLTY_CHECK_CNT  --质检通过 
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE    TRUNC(WLRR.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND      WLRR.PRODUCTID = '201020100063' 
        AND      WLRR.RISKRESULT = 'Accept'
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='批准' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --年
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(WLRR.SERIALNO)               AS QLTY_CHECK_CNT  --质检通过 
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT = 'Accept' 
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    AND   FT.PHASEOPINION1 ='批准' -- 节点意见1
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
;
commit;
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_09
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,'000000'           AS ORG_NO
                   ,SUM(QLTY_CHECK_CNT)  AS QLTY_CHECK_CNT  --质检通过 
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,LP_CLS_PROD        AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_09 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     commit;

-- 产品汇总 
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_09
            SELECT 
                    ETL_DT             AS ETL_DT
                   ,PED_NO             AS PED_NO
                   ,PED_NAME           AS PED_NAME
                   ,ORG_NO             AS ORG_NO
                   ,SUM(QLTY_CHECK_CNT)  AS QLTY_CHECK_CNT  --质检通过 
                   ,LP_CLS_ID          AS LP_CLS_ID
                   ,LP_CLS_NAME        AS LP_CLS_NAME
                   ,'0'                AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_09 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;
--合计汇总   
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_09
           SELECT 
                     T1.ETL_DT           AS ETL_DT
                    ,T1.PED_NO           AS PED_NO
                    ,T1.PED_NAME         AS PED_NAME
                    ,T1.ORG_NO           AS ORG_NO
                    ,SUM(QLTY_CHECK_CNT)  AS QLTY_CHECK_CNT  --质检通过 
                    ,'0'                 AS LP_CLS_ID
                    ,'合计'              AS LP_CLS_NAME
                    ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM     mckb_all_flow_realtime_tmp_09 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;
   
--第10组：质检流程中 
INSERT INTO  ${idl_schema}.mckb_all_flow_realtime_tmp_10 
        -- 累计 IPC 
        SELECT    
                     rec_run_logs.sum_end_time AS ETL_DT
                    ,'099'                               AS PED_NO
                    ,'累计'                              AS PED_NAME
                    ,LBW.ORG_NUM                         AS ORG_NO
                    ,COUNT(*)                            AS QLTY_CHECK_FLOW_CNT  --质检流程中
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_HGLS_LOAN_REQ LR 
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW  -- 支行网点信息
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        WHERE     TRUNC(LR.REQ_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND       LR.ISDEL = 0 
        AND       LR.PRD_TYPE IN (18,22,32,201) --18个人标准产品,32个人特色产品,22企业
        AND       LR.AUDIT_STATUS IN (12, -7)  -- 取信息复核通过+待审查的进件笔数
        GROUP BY  LBW.ORG_NUM
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                        WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                        ELSE NULL END                
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                        WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                        ELSE NULL END    
        UNION ALL 
        -- 当日 
        SELECT    
                     rec_run_logs.sum_end_time AS ETL_DT
                    ,'001'                               AS PED_NO
                    ,'当日'                              AS PED_NAME
                    ,LBW.ORG_NUM                         AS ORG_NO
                    ,COUNT(*)                            AS QLTY_CHECK_FLOW_CNT  --质检流程中
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_HGLS_LOAN_REQ LR 
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW  -- 支行网点信息
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        WHERE     TRUNC(LR.REQ_DATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND       LR.ISDEL = 0 
        AND       LR.PRD_TYPE IN (18,22,32,201) --18个人标准产品,32个人特色产品,22企业
        AND       LR.AUDIT_STATUS IN (12, -7)  -- 取信息复核通过+待审查的进件笔数
        GROUP BY  LBW.ORG_NUM
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                        WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                        ELSE NULL END                
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                        WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                        ELSE NULL END    
        UNION ALL 
        -- 当月 
        SELECT    
                     rec_run_logs.sum_end_time AS ETL_DT
                    ,'002'                               AS PED_NO
                    ,'当月'                              AS PED_NAME
                    ,LBW.ORG_NUM                         AS ORG_NO
                    ,COUNT(*)                            AS QLTY_CHECK_FLOW_CNT  --质检流程中
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_HGLS_LOAN_REQ LR 
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW  -- 支行网点信息
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        WHERE     TRUNC(LR.REQ_DATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND       TRUNC(LR.REQ_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND       LR.ISDEL = 0 
        AND       LR.PRD_TYPE IN (18,22,32,201) --18个人标准产品,32个人特色产品,22企业
        AND       LR.AUDIT_STATUS IN (12, -7)  -- 取信息复核通过+待审查的进件笔数
        GROUP BY  LBW.ORG_NUM
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                        WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                        ELSE NULL END                
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                        WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                        ELSE NULL END    
        UNION ALL 
        -- 当年
        SELECT    
                     rec_run_logs.sum_end_time AS ETL_DT
                    ,'004'                               AS PED_NO
                    ,'当年'                              AS PED_NAME
                    ,LBW.ORG_NUM                         AS ORG_NO
                    ,COUNT(*)                            AS QLTY_CHECK_FLOW_CNT  --质检流程中
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                          WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                          ELSE NULL END                  AS LP_CLS_ID
                    ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                          WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                          ELSE NULL END                  AS LP_CLS_NAME
                    ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_HGLS_LOAN_REQ LR 
        INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW  -- 支行网点信息
        ON         LR.HOME_BRANCH = LBW.CODE 
        AND        LENGTH(LBW.ORG_NUM) = 3 
        WHERE     TRUNC(LR.REQ_DATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND       TRUNC(LR.REQ_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND       LR.ISDEL = 0 
        AND       LR.PRD_TYPE IN (18,22,32,201) --18个人标准产品,32个人特色产品,22企业
        AND       LR.AUDIT_STATUS IN (12, -7)  -- 取信息复核通过+待审查的进件笔数
        GROUP BY  LBW.ORG_NUM
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                        WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                        ELSE NULL END                
                  ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                        WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                        ELSE NULL END    
        UNION ALL 
        -- 数据贷
        --累计
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'099'                               AS PED_NO
                ,'累计'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(WLRR.SERIALNO)                AS QLTY_CHECK_FLOW_CNT  --质检流程中
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表 
        WHERE   TRUNC(WLRR.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT = 'Review' -- 通过
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型 
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT   rec_run_logs.sum_end_time AS ETL_DT
                ,'001'                               AS PED_NO
                ,'当日'                              AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)         AS ORG_NO
                ,COUNT(WLRR.SERIALNO)                AS QLTY_CHECK_FLOW_CNT  --质检流程中
                ,'2'                                 AS LP_CLS_ID
                ,'个人'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        from    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT = 'Review' 
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --月
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(WLRR.SERIALNO)               AS QLTY_CHECK_FLOW_CNT  --质检流程中
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE    TRUNC(WLRR.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND      TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND      WLRR.PRODUCTID = '201020100063' 
        AND      WLRR.RISKRESULT = 'Review'
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
        UNION ALL
        --年
        SELECT  rec_run_logs.sum_end_time AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WLRR.INPUTORGID,0,3)        AS ORG_NO
                ,COUNT(WLRR.SERIALNO)               AS QLTY_CHECK_FLOW_CNT  --质检流程中
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LMT_RESU_RECEIVE WLRR -- 微业贷额度结果接收表
        WHERE   TRUNC(WLRR.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WLRR.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND     WLRR.PRODUCTID = '201020100063'
        AND     WLRR.RISKRESULT = 'Review' 
        AND EXISTS (SELECT 1 
                    FROM  MSL_ICMS_FLOW_TASK FT -- 流程任务
                    WHERE FT.OBJECTNO = WLRR.SERIALNO  -- 流程对象编号/流程节点编号
                    AND   FT.OBJECTTYPE ='WYD3ConfirmCreditApply'  -- 流程对象任务类型
                    AND   FT.PHASENO ='0030'  -- 当前阶段编号
                    )
        GROUP BY SUBSTR(WLRR.INPUTORGID,0,3)
;
 commit;
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_10
            SELECT 
                    ETL_DT              AS ETL_DT
                   ,PED_NO              AS PED_NO
                   ,PED_NAME            AS PED_NAME
                   ,'000000'            AS ORG_NO
                   ,SUM(QLTY_CHECK_FLOW_CNT)  AS QLTY_CHECK_FLOW_CNT  --质检流程中
                   ,LP_CLS_ID           AS LP_CLS_ID
                   ,LP_CLS_NAME         AS LP_CLS_NAME
                   ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_10 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     commit;

--产品汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_10
            SELECT 
                    ETL_DT              AS ETL_DT
                   ,PED_NO              AS PED_NO
                   ,PED_NAME            AS PED_NAME
                   ,ORG_NO              AS ORG_NO
                   ,SUM(QLTY_CHECK_FLOW_CNT)  AS QLTY_CHECK_FLOW_CNT  --质检流程中
                   ,LP_CLS_ID           AS LP_CLS_ID
                   ,LP_CLS_NAME         AS LP_CLS_NAME
                   ,'0'                 AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_10 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;

--合计汇总   
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_10
           SELECT 
                     T1.ETL_DT           AS ETL_DT
                    ,T1.PED_NO           AS PED_NO
                    ,T1.PED_NAME         AS PED_NAME
                    ,T1.ORG_NO           AS ORG_NO
                    ,SUM(QLTY_CHECK_FLOW_CNT)  AS QLTY_CHECK_FLOW_CNT  --质检流程中
                    ,'0'                 AS LP_CLS_ID
                    ,'合计'              AS LP_CLS_NAME
                    ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM     mckb_all_flow_realtime_tmp_10 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;

--第11组：签约客户数
INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_11 

        SELECT 
              rec_run_logs.sum_end_time  AS ETL_DT
              ,T4.PED_NO
              ,T4.PED_NAME
              ,T4.ORG_NO
              ,SUM(T4.SIGN_CUST_CNT) AS SIGN_CUST_CNT
              ,T4.LP_CLS_ID
              ,T4.LP_CLS_NAME
              ,T4.LP_CLS_PROD
        FROM (
              -- 累计 IPC
              SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'099'                               AS PED_NO
                      ,'累计'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (18,22,32)
              AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
              -- AND       ( FIND_IN_SET('41',LR.LABEL_STATUS) OR FIND_IN_SET('48',LR.LABEL_STATUS))
              AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              UNION ALL 
              SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'099'                               AS PED_NO
                      ,'累计'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (201)
              AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
              AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
              -- AND       ( FIND_IN_SET('41',LR.LABEL_STATUS) OR FIND_IN_SET('48',LR.LABEL_STATUS))
              AND       (LR.LABEL_STATUS LIKE '%41%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              UNION ALL 
              -- 当日 
               SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'001'                               AS PED_NO
                      ,'当日'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (18,22,32)
              AND       TRUNC(LR.AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
              AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              UNION ALL 
              -- 当日 
              SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'001'                               AS PED_NO
                      ,'当日'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (201)
              AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
              AND       TRUNC(LR.AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
              AND       (LR.LABEL_STATUS LIKE '%41%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              UNION ALL 
              -- 当月 
               SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'002'                               AS PED_NO
                      ,'当月'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (18,22,32)
              AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
              AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
              AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              UNION ALL 
              -- 当月 
               SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'002'                               AS PED_NO
                      ,'当月'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (201)
              AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
              AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
              AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
              AND       (LR.LABEL_STATUS LIKE '%41%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              UNION ALL 
              -- 当年 
               SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'004'                               AS PED_NO
                      ,'当年'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (18,22,32)
              AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
              AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
              AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              UNION ALL 
              -- 当年 
               SELECT 
                      rec_run_logs.sum_end_time  AS ETL_DT
                      ,'004'                               AS PED_NO
                      ,'当年'                              AS PED_NAME
                      ,LBW.ORG_NUM                         AS ORG_NO
                      ,COUNT(DISTINCT LR.REQ_ID)           AS SIGN_CUST_CNT  -- 签约客户数
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                             WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                             ELSE NULL END                  AS LP_CLS_ID
                       ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END      AS LP_CLS_NAME
                      ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_HGLS_LOAN_REQ LR
              INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
              ON        LR.HOME_BRANCH = LBW.CODE 
              AND        LENGTH(LBW.ORG_NUM) = 3 
              WHERE     LR.ISDEL = 0 
              AND       LR.PRD_TYPE IN (201)
              AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
              AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
              AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
              AND       (LR.LABEL_STATUS LIKE '%41%')
              GROUP BY LBW.ORG_NUM 
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                             WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                             ELSE NULL END  
              
              UNION ALL 
              -- 数据贷  --累计
              SELECT   rec_run_logs.sum_end_time AS ETL_DT
                      ,'099'                               AS PED_NO
                      ,'累计'                              AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)       AS SIGN_CUST_CNT  -- 签约客户数
                      ,'2'                                 AS LP_CLS_ID
                      ,'个人'                              AS LP_CLS_NAME
                      ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE   TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
              AND     WL.PRODUCTID = '201020100063'
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
              UNION ALL
              --日
              SELECT   rec_run_logs.sum_end_time AS ETL_DT
                      ,'001'                               AS PED_NO
                      ,'当日'                              AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)       AS SIGN_CUST_CNT  -- 签约客户数
                      ,'2'                                 AS LP_CLS_ID
                      ,'个人'                              AS LP_CLS_NAME
                      ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              from    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE   TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
              AND     WL.PRODUCTID = '201020100063'
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
              UNION ALL
              --月
              SELECT  rec_run_logs.sum_end_time AS ETL_DT
                      ,'002'                              AS PED_NO
                      ,'当月'                             AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)      AS SIGN_CUST_CNT  -- 签约客户数
                      ,'2'                                AS LP_CLS_ID
                      ,'个人'                             AS LP_CLS_NAME
                      ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE    TRUNC(WL.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
              AND      TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
              AND      WL.PRODUCTID = '201020100063' 
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
              
              UNION ALL
              --年
              SELECT  rec_run_logs.sum_end_time AS ETL_DT
                      ,'004'                              AS PED_NO
                      ,'当年'                             AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)      AS SIGN_CUST_CNT  -- 签约客户数
                      ,'2'                                AS LP_CLS_ID
                      ,'个人'                             AS LP_CLS_NAME
                      ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE   TRUNC(WL.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
              AND     TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
              AND     WL.PRODUCTID = '201020100063'
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
              UNION ALL 
              --累计
              SELECT   rec_run_logs.sum_end_time AS ETL_DT
                      ,'099'                               AS PED_NO
                      ,'累计'                              AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)       AS SIGN_CUST_CNT  -- 签约客户数
                      ,'1'                                 AS LP_CLS_ID
                      ,'企业'                              AS LP_CLS_NAME
                      ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE   TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
              AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
              UNION ALL
              --日
              SELECT   rec_run_logs.sum_end_time AS ETL_DT
                      ,'001'                               AS PED_NO
                      ,'当日'                              AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)       AS SIGN_CUST_CNT  -- 签约客户数
                      ,'1'                                 AS LP_CLS_ID
                      ,'企业'                              AS LP_CLS_NAME
                      ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              from    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE   TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
              AND     WL.PRODUCTID = '203050100001'
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
              UNION ALL
              --月
              SELECT  rec_run_logs.sum_end_time AS ETL_DT
                      ,'002'                              AS PED_NO
                      ,'当月'                             AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)      AS SIGN_CUST_CNT  -- 签约客户数
                      ,'1'                                AS LP_CLS_ID
                      ,'企业'                             AS LP_CLS_NAME
                      ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM     MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE    TRUNC(WL.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
              AND      TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
              AND      WL.PRODUCTID = '203050100001' 
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
              
              UNION ALL
              --年
              SELECT  rec_run_logs.sum_end_time AS ETL_DT
                      ,'004'                              AS PED_NO
                      ,'当年'                             AS PED_NAME
                      ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                      ,COUNT(DISTINCT WL.CUSTOMERID)      AS SIGN_CUST_CNT  -- 签约客户数
                      ,'1'                                AS LP_CLS_ID
                      ,'企业'                             AS LP_CLS_NAME
                      ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
              FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
              WHERE   TRUNC(WL.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
              AND     TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
              AND     WL.PRODUCTID = '203050100001'
              GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        )T4 
        GROUP BY  T4.PED_NO
                 ,T4.PED_NAME
                 ,T4.ORG_NO
                 ,T4.LP_CLS_ID
                 ,T4.LP_CLS_NAME
                 ,T4.LP_CLS_PROD
;

 commit;
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_11
            SELECT 
                    ETL_DT              AS ETL_DT
                   ,PED_NO              AS PED_NO
                   ,PED_NAME            AS PED_NAME
                   ,'000000'            AS ORG_NO
                   ,SUM(SIGN_CUST_CNT)  AS SIGN_CUST_CNT  --签约客户数
                   ,LP_CLS_ID           AS LP_CLS_ID
                   ,LP_CLS_NAME         AS LP_CLS_NAME
                   ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_11 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     commit;

--产品汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_11
            SELECT 
                    ETL_DT              AS ETL_DT
                   ,PED_NO              AS PED_NO
                   ,PED_NAME            AS PED_NAME
                   ,ORG_NO              AS ORG_NO
                   ,SUM(SIGN_CUST_CNT)  AS SIGN_CUST_CNT  --签约客户数
                   ,LP_CLS_ID           AS LP_CLS_ID
                   ,LP_CLS_NAME         AS LP_CLS_NAME
                   ,'0'                 AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_11 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;
--合计汇总   
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_11
           SELECT 
                     T1.ETL_DT           AS ETL_DT
                    ,T1.PED_NO           AS PED_NO
                    ,T1.PED_NAME         AS PED_NAME
                    ,T1.ORG_NO           AS ORG_NO
                    ,SUM(SIGN_CUST_CNT)  AS SIGN_CUST_CNT  --签约客户数
                    ,'0'                 AS LP_CLS_ID
                    ,'合计'              AS LP_CLS_NAME
                    ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM     mckb_all_flow_realtime_tmp_11 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;


--第12组：签约金额 

INSERT INTO  ${idl_schema}.mckb_all_flow_realtime_tmp_12 
        SELECT 
              rec_run_logs.sum_end_time  AS ETL_DT
              ,T4.PED_NO
              ,T4.PED_NAME
              ,T4.ORG_NO
              ,SUM(T4.SIGN_AMT) AS SIGN_AMT
              ,T4.LP_CLS_ID
              ,T4.LP_CLS_NAME
              ,T4.LP_CLS_PROD
        FROM (
             -- 累计 IPC
             SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'099'                               AS PED_NO
                     ,'累计'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (18,22,32)
             AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
             -- AND       ( FIND_IN_SET('41',LR.LABEL_STATUS) OR FIND_IN_SET('48',LR.LABEL_STATUS))
             AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
             UNION ALL
             SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'099'                               AS PED_NO
                     ,'累计'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (201)
             AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
             AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
             AND       (LR.LABEL_STATUS LIKE '%41%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
                            
             UNION ALL 
             -- 当日 
              SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'001'                               AS PED_NO
                     ,'当日'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (18,22,32)
             AND       TRUNC(LR.AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
             AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
              UNION ALL 
             -- 当日 
              SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'001'                               AS PED_NO
                     ,'当日'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (201)
             AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
             AND       TRUNC(LR.AUDIT_DATE) = TO_DATE('${batch_date}','yyyymmdd')
             AND       (LR.LABEL_STATUS LIKE '%41%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
             UNION ALL 
             -- 当月 
              SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'002'                               AS PED_NO
                     ,'当月'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (18,22,32)
             AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
             AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
             AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
             UNION ALL 
             -- 当月 
              SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'002'                               AS PED_NO
                     ,'当月'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (201)
             AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
             AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${month_start}','yyyymmdd')
             AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
             AND       (LR.LABEL_STATUS LIKE '%41%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
             UNION ALL 
             -- 当年 
              SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'004'                               AS PED_NO
                     ,'当年'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (18,22,32)
             AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
             AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
             AND       (LR.LABEL_STATUS LIKE '%41%' OR LR.LABEL_STATUS LIKE '%48%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
             UNION ALL 
             -- 当年 
              SELECT 
                     rec_run_logs.sum_end_time  AS ETL_DT
                     ,'004'                               AS PED_NO
                     ,'当年'                              AS PED_NAME
                     ,LBW.ORG_NUM                         AS ORG_NO
                     ,SUM(NVL(LR.AUTH_MONEY,0))           AS SIGN_AMT       -- 签约金额  
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                            WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                            ELSE NULL END                  AS LP_CLS_ID
                      ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END      AS LP_CLS_NAME
                     ,'1'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_HGLS_LOAN_REQ LR
             INNER JOIN MSL_HGLS_LOAN_BRANCH_WEBSITE LBW 
             ON        LR.HOME_BRANCH = LBW.CODE 
             AND        LENGTH(LBW.ORG_NUM) = 3 
             WHERE     LR.ISDEL = 0 
             AND       LR.PRD_TYPE IN (201)
             AND       LR.AUDIT_STATUS = 112 -- 信息补录完成
             AND       TRUNC(LR.AUDIT_DATE) >= TO_DATE('${year_start}','yyyymmdd')
             AND       TRUNC(LR.AUDIT_DATE) <= TO_DATE('${batch_date}','yyyymmdd')
             AND       (LR.LABEL_STATUS LIKE '%41%')
             GROUP BY LBW.ORG_NUM 
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '2' -- 个人
                           WHEN LR.PRD_TYPE IN (22) THEN '1'    -- 企业
                           ELSE NULL END                
                     ,CASE WHEN LR.PRD_TYPE IN (18,32,201) THEN '个人'
                            WHEN LR.PRD_TYPE IN (22) THEN '企业'   
                            ELSE NULL END  
             UNION ALL 
             -- 数据贷  --累计
             SELECT   rec_run_logs.sum_end_time AS ETL_DT
                     ,'099'                               AS PED_NO
                     ,'累计'                              AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))          AS SIGN_AMT       -- 签约金额  
                     ,'2'                                 AS LP_CLS_ID
                     ,'个人'                              AS LP_CLS_NAME
                     ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE   TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
             AND     WL.PRODUCTID = '201020100063'
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
             UNION ALL
             --日
             SELECT   rec_run_logs.sum_end_time AS ETL_DT
                     ,'001'                               AS PED_NO
                     ,'当日'                              AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))          AS SIGN_AMT       -- 签约金额  
                     ,'2'                                 AS LP_CLS_ID
                     ,'个人'                              AS LP_CLS_NAME
                     ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             from    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE   TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
             AND     WL.PRODUCTID = '201020100063'
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
             UNION ALL
             --月
             SELECT  rec_run_logs.sum_end_time AS ETL_DT
                     ,'002'                              AS PED_NO
                     ,'当月'                             AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))         AS SIGN_AMT       -- 签约金额  
                     ,'2'                                AS LP_CLS_ID
                     ,'个人'                             AS LP_CLS_NAME
                     ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE    TRUNC(WL.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
             AND      TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
             AND      WL.PRODUCTID = '201020100063' 
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
            
             UNION ALL
             --年
             SELECT  rec_run_logs.sum_end_time AS ETL_DT
                     ,'004'                              AS PED_NO
                     ,'当年'                             AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))         AS SIGN_AMT       -- 签约金额  
                     ,'2'                                AS LP_CLS_ID
                     ,'个人'                             AS LP_CLS_NAME
                     ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE   TRUNC(WL.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
             AND     TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
             AND     WL.PRODUCTID = '201020100063'
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
             UNION ALL 
             --累计
             SELECT   rec_run_logs.sum_end_time AS ETL_DT
                     ,'099'                               AS PED_NO
                     ,'累计'                              AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))          AS SIGN_AMT       -- 签约金额  
                     ,'1'                                 AS LP_CLS_ID
                     ,'企业'                              AS LP_CLS_NAME
                     ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE   TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
             AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
             UNION ALL
             --日
             SELECT   rec_run_logs.sum_end_time AS ETL_DT
                     ,'001'                               AS PED_NO
                     ,'当日'                              AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)           AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))          AS SIGN_AMT       -- 签约金额  
                     ,'1'                                 AS LP_CLS_ID
                     ,'企业'                              AS LP_CLS_NAME
                     ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             from    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE   TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
             AND     WL.PRODUCTID = '203050100001'
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
             UNION ALL
             --月
             SELECT  rec_run_logs.sum_end_time AS ETL_DT
                     ,'002'                              AS PED_NO
                     ,'当月'                             AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))         AS SIGN_AMT       -- 签约金额  
                     ,'1'                                AS LP_CLS_ID
                     ,'企业'                             AS LP_CLS_NAME
                     ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM     MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE    TRUNC(WL.INPUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
             AND      TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
             AND      WL.PRODUCTID = '203050100001' 
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
            
             UNION ALL
             --年
             SELECT  rec_run_logs.sum_end_time AS ETL_DT
                     ,'004'                              AS PED_NO
                     ,'当年'                             AS PED_NAME
                     ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                     ,SUM(NVL(WL.BUSINESSSUM,0))         AS SIGN_AMT       -- 签约金额  
                     ,'1'                                AS LP_CLS_ID
                     ,'企业'                             AS LP_CLS_NAME
                     ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
             FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
             WHERE   TRUNC(WL.INPUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
             AND     TRUNC(WL.INPUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
             AND     WL.PRODUCTID = '203050100001'
             GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        )T4 
        GROUP BY  T4.PED_NO
              ,T4.PED_NAME
              ,T4.ORG_NO
              ,T4.LP_CLS_ID
              ,T4.LP_CLS_NAME
              ,T4.LP_CLS_PROD
;

 commit;
--全行汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_12
            SELECT 
                    ETL_DT              AS ETL_DT
                   ,PED_NO              AS PED_NO
                   ,PED_NAME            AS PED_NAME
                   ,'000000'            AS ORG_NO
                   ,SUM(SIGN_AMT)       AS SIGN_AMT       --签约金额
                   ,LP_CLS_ID           AS LP_CLS_ID
                   ,LP_CLS_NAME         AS LP_CLS_NAME
                   ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_12 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD;
     commit;

--产品汇总          
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_12
            SELECT 
                    ETL_DT              AS ETL_DT
                   ,PED_NO              AS PED_NO
                   ,PED_NAME            AS PED_NAME
                   ,ORG_NO              AS ORG_NO
                   ,SUM(SIGN_AMT)       AS SIGN_AMT       --签约金额
                   ,LP_CLS_ID           AS LP_CLS_ID
                   ,LP_CLS_NAME         AS LP_CLS_NAME
                   ,'0'                 AS LP_CLS_PROD
           FROM    mckb_all_flow_realtime_tmp_12 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,ORG_NO;
     commit;
--合计汇总   
        INSERT INTO ${idl_schema}.mckb_all_flow_realtime_tmp_12
           SELECT 
                     T1.ETL_DT           AS ETL_DT
                    ,T1.PED_NO           AS PED_NO
                    ,T1.PED_NAME         AS PED_NAME
                    ,T1.ORG_NO           AS ORG_NO
                    ,SUM(SIGN_AMT)       AS SIGN_AMT       --签约金额
                    ,'0'                 AS LP_CLS_ID
                    ,'合计'              AS LP_CLS_NAME
                    ,LP_CLS_PROD         AS LP_CLS_PROD
           FROM     mckb_all_flow_realtime_tmp_12 T1
           GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;


delete mckb_all_flow_realtime;
commit;  
     INSERT /*+ append */
INTO ${idl_schema}.mckb_all_flow_realtime
    (ETL_DT                  -- 数据日期
    ,PED_NO                  -- 周期编号
    ,PED_NAME                -- 周期名称
    ,GROUPING                -- 分组
    ,ORG_NO                  -- 机构编号
    ,ORG_NAME                -- 机构名称
    -- 20260112新增 
    ,LP_CLS_PROD             -- 产品分类 
    ,ACVMNT_DATA_ACCT_CNT    -- 业绩数据户数
    ,ACVMNT_DATA_AMT         -- 业绩数据金额
    ,ACVMNT_DATA_NET_INCREMT -- 业绩数据净增
    ,ACVMNT_DATA_TARGET      -- 业绩数据目标
    ,ACVMNT_DATA_ARRIVE_RAT  -- 业绩数据达成率
    ,LP_CLS_ID               -- 法人分类编号
    ,LP_CLS_NAME             -- 法人分类名称
    ,ENTER_CNT               -- 进件数
    ,ENTER_PASS_CNT          -- 进件通过数
    ,ENTER_REFUSE_CNT        -- 进件拒绝数
    ,SYS_APV_ACCT_CNT        -- 系统审批户数
    ,SYS_APV_AMT             -- 系统审批金额
    
    -- 20260112 新增
    ,PREP_TEL_CNT            -- 调查_待电调 
    ,PREP_ACTL_CNT           -- 调查_待实调 
    ,INVSTG_PASS_CNT         -- 调查_通过 
    ,INVSTG_REFUSE_CNT       -- 调查_拒绝  
    ,QLTY_CHECK_CNT          -- 质检通过
    ,QLTY_CHECK_FLOW_CNT     -- 质检流程中 
    ,SIGN_CUST_CNT           -- 签约客户数 
    ,SIGN_AMT                -- 签约金额  
    ,ETL_TIMESTAMP           -- ETL处理时间戳
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

     SELECT rec_run_logs.sum_end_time etl_dt --数据日期
            ,t1.ped_no --周期编号
            ,t1.ped_name --周期名称
            ,(case  when t1.org_no in ('801','805') then '第一组'
                    when t1.org_no in ('806','803','802') then '第二组'
                    when t1.org_no in ('807','809') then '第三组'
                    when t1.org_no in ('808','810') then '第四组'
                    when t1.org_no in ('811','812') then '第五组'
                    when t1.org_no in ('000000') then '全行'
            end) as grouping -- 分组
            ,T1.ORG_NO       -- 机构编号
            ,T1.ORG_NAME     -- 机构名称
            ,T1.LP_CLS_PROD  -- 产品分类 
            ,NVL(T2.ACVMNT_DATA_ACCT_CNT,0) -- 业绩数据户数
            ,NVL(T2.ACVMNT_DATA_AMT,0)      -- 业绩数据金额
            ,CASE WHEN T1.PED_NO='099' THEN NVL(T2.ACVMNT_DATA_NET_INCREMT,0)
                  ELSE NVL(T9.ACVMNT_DATA_NET_INCREMT,0)-NVL(T8.ACVMNT_DATA_NET_INCREMT,0) END  --业绩数据净增
            -- 业务取消 
            --,case when t1.lp_cls_id='0' and t1.ped_no='004' then t7.TARGET_VAL*10000 end                        acvmnt_data_target --业绩数据目标
            --,case when t1.lp_cls_id='0' and t1.ped_no='004' then (t2.acvmnt_data_amt/(t7.TARGET_VAL*10000)) end acvmnt_data_arrive_rat --业绩数据达成率
            ,0 AS ACVMNT_DATA_TARGET     -- 业绩数据目标
            ,0 AS ACVMNT_DATA_ARRIVE_RAT -- 业绩数据达成率
            ,T1.LP_CLS_ID                -- 法人分类编号
            ,T1.LP_CLS_NAME              -- 法人分类名称
            ,NVL(T3.ENTER_CNT,0)             AS ENTER_CNT           -- 进件数
            ,NVL(T4.ENTER_PASS_CNT,0)        AS ENTER_PASS_CNT      -- 进件通过数
            ,NVL(T5.ENTER_REFUSE_CNT,0)      AS ENTER_REFUSE_CNT    -- 进件拒绝数
            ,NVL(T3.SYS_APV_ACCT_CNT,0)      AS SYS_APV_ACCT_CNT    -- 系统审批户数
            ,NVL(T6.SYS_APV_AMT,0)           AS SYS_APV_AMT         -- 系统审批金额
            -- 20260112增加字段 
            ,NVL(T6_1.PREP_TEL_CNT,0)        AS PREP_TEL_CNT        -- 调查_待电调   
            ,NVL(T6_1.PREP_ACTL_CNT,0)       AS PREP_ACTL_CNT       -- 调查_待实调 
            ,NVL(T6_2.INVSTG_PASS_CNT,0)     AS INVSTG_PASS_CNT     -- 调查_通过 
            ,NVL(T6_3.INVSTG_REFUSE_CNT,0)   AS INVSTG_REFUSE_CNT   -- 调查_拒绝  
            ,NVL(T6_4.QLTY_CHECK_CNT,0)      AS QLTY_CHECK_CNT      -- 质检通过
            ,NVL(T6_5.QLTY_CHECK_FLOW_CNT,0) AS QLTY_CHECK_FLOW_CNT -- 质检流程中 
            ,NVL(T6_6.SIGN_CUST_CNT,0)       AS SIGN_CUST_CNT       -- 签约客户数 
            ,NVL(T6_7.SIGN_AMT,0)            AS SIGN_AMT           -- 签约金额  
            ,sysdate --etl处理时间戳
        FROM  (SELECT * FROM MC_ORGA_PARA,TMP_PED,TMP_LP_CLS,TMP_PRO_CLS) T1 -- 机构树表
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_01 T2
        ON     T1.ORG_NO = T2.ORG_NO
        AND    T1.PED_NO=T2.PED_NO 
        AND    T1.LP_CLS_ID=T2.LP_CLS_ID
        AND    T1.LP_CLS_PROD = T2.LP_CLS_PROD 
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_02 T3
        ON     T1.ORG_NO = T3.ORG_NO
        AND    T1.PED_NO=T3.PED_NO 
        AND    T1.LP_CLS_ID=T3.LP_CLS_ID
        AND    T1.LP_CLS_PROD = T3.LP_CLS_PROD
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_03 T4
        ON     T1.ORG_NO = T4.ORG_NO
        AND    T1.PED_NO=T4.PED_NO 
        AND    T1.LP_CLS_ID=T4.LP_CLS_ID
        AND    T1.LP_CLS_PROD = T4.LP_CLS_PROD
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_04 T5
        ON     T1.ORG_NO = T5.ORG_NO
        AND    T1.PED_NO=T5.PED_NO 
        AND    T1.LP_CLS_ID=T5.LP_CLS_ID
        AND    T1.LP_CLS_PROD = T5.LP_CLS_PROD
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_05 T6
        ON     T1.ORG_NO = T6.ORG_NO
        AND    T1.PED_NO=T6.PED_NO 
        AND    T1.LP_CLS_ID=T6.LP_CLS_ID
        AND    T1.LP_CLS_PROD = T6.LP_CLS_PROD
         -- 20260112 新增 
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_06 T6_1 -- 调查 待电调/待实调
        ON       T1.ORG_NO = T6_1.ORG_NO
        AND      T1.PED_NO = T6_1.PED_NO 
        AND      T1.LP_CLS_ID = T6_1.LP_CLS_ID
        AND      T1.LP_CLS_PROD = T6_1.LP_CLS_PROD
        
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_07 T6_2  -- 调查通过
        ON       T1.ORG_NO = T6_2.ORG_NO
        AND      T1.PED_NO = T6_2.PED_NO 
        AND      T1.LP_CLS_ID = T6_2.LP_CLS_ID
        AND      T1.LP_CLS_PROD = T6_2.LP_CLS_PROD
        
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_08 T6_3 -- 调查拒绝
        ON       T1.ORG_NO = T6_3.ORG_NO
        AND      T1.PED_NO = T6_3.PED_NO 
        AND      T1.LP_CLS_ID = T6_3.LP_CLS_ID
        AND      T1.LP_CLS_PROD = T6_3.LP_CLS_PROD
        
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_09 T6_4 -- 质检通过
        ON       T1.ORG_NO = T6_4.ORG_NO
        AND      T1.PED_NO = T6_4.PED_NO 
        AND      T1.LP_CLS_ID = T6_4.LP_CLS_ID
        AND      T1.LP_CLS_PROD = T6_4.LP_CLS_PROD
        
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_10 T6_5 -- 质检流程中
        ON       T1.ORG_NO = T6_5.ORG_NO
        AND      T1.PED_NO = T6_5.PED_NO 
        AND      T1.LP_CLS_ID = T6_5.LP_CLS_ID
        AND      T1.LP_CLS_PROD = T6_5.LP_CLS_PROD
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_11 T6_6 --第11组：签约客户数
        ON       T1.ORG_NO = T6_6.ORG_NO
        AND      T1.PED_NO = T6_6.PED_NO 
        AND      T1.LP_CLS_ID = T6_6.LP_CLS_ID
        AND      T1.LP_CLS_PROD = T6_6.LP_CLS_PROD
        LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_12 T6_7 --第11组：签约金额
        ON       T1.ORG_NO = T6_7.ORG_NO
        AND      T1.PED_NO = T6_7.PED_NO 
        AND      T1.LP_CLS_ID = T6_7.LP_CLS_ID
        AND      T1.LP_CLS_PROD = T6_7.LP_CLS_PROD
      -- LEFT JOIN mckb_target_val_cfg t7
      -- ON     t7.org_no=t1.org_no
      LEFT JOIN MCKB_ALL_FLOW T8 
      on       t8.etl_dt=(case t1.ped_no when '001' then to_date('${last_date}','yyyymmdd')
                                         when '002' then to_date('${last_month_end}','yyyymmdd')
                                         when '004' then to_date('${last_year_end}','yyyymmdd')
                   end)
      AND    T8.PED_NO='099'
      AND    T8.ORG_NO=T1.ORG_NO
      AND    T8.LP_CLS_ID=T1.LP_CLS_ID
      AND    T8.LP_CLS_PROD = T1.LP_CLS_PROD
      LEFT JOIN MCKB_ALL_FLOW_REALTIME_TMP_01 t9
      ON     T1.ORG_NO = T9.ORG_NO
      AND    T9.PED_NO ='099'
      AND    T1.LP_CLS_ID=T9.LP_CLS_ID
      AND    T1.LP_CLS_PROD=T9.LP_CLS_PROD
      WHERE  t1.org_no in ('000000'
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
                            );
COMMIT;
-- 2.2 update log table 

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND   index_no ='MCKB_ALL_FLOW_REALTIME';
COMMIT;
END LOOP;   
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mckb_all_flow_realtime出错' || SQLERRM);
    
END;

/
           
            
