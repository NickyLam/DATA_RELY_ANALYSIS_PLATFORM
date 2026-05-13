CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_TRANSFER
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_TRANSFER
  *  功能描述：本表主要反映我行对公各项贷款发生减少的各种方式，包括直接转让债权、信贷资产证券化、
               信贷资产收益权转让、其他方式等项目，但不含贷款回收等。本表收集本金，不含利息的数据。
  *  创建日期：20221031
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_PHB_TRANSFER --零售资产转让模型
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   liuyu      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_TRANSFER';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_PHB_TRANSFER'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入信贷资产转让信息';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_PHB_TRANSFER
  (BGRQ,      --1 报告日期
   JYWYM,     --2 交易唯一码
   KHWYM,     --3 客户唯一码
   ZWJGBH,    --4 机构编号
   ZWJGMC,    --5 机构名称
   CPLX,      --6 产品类型
   CPMC,      --7 产品名称
   ZQZRRQ,    --8 债权转让日期
   ZRFSLB,    --9 转让方式类别
   DYBJ,      --10 对应本金
   CZQWJFL,   --11 处置前五级分类
   SFZZG,     --12 是否债转股
   SSJE,      --13 损失金额（元）
   DZHHXJE,   --14 调整后核销金额（元）
   DZHZRHSXJ, --15 调整后转让回收现金（元）
   ZRSHQTDJ,  --16 转让收回其他对价
   ZCJE,      --17 自持金额（元）
   ZCZRJYPT,  --18 资产转让交易平台
   ZCZRDJPT,  --19 资产转让登记平台
   ZJJYDSLB,  --20 直接交易对手类别
   ZQZRYZ,    --21 债权转让原值（元）
   ZQZRXYJE,  --22 债权转让协议金额（元）
   JYDSLB_RH  --23 交易对手类别（人行）
   )
   SELECT
          T1.DATA_DATE                   AS BGRQ             --1 报告日期
         ,T1.JYWYM                       AS JYWYM            --2 交易唯一码
         ,T1.KHWYM                       AS KHWYM            --3 客户唯一码
         ,T1.ACCT_ORG_NUM                AS ZWJGDM           --4 机构编号
         ,T3.ORG_NM                      AS ZWJGMC           --5 机构名称
         ,T1.CPLX                        AS CPLX             --6 产品类型
         ,T1.CPMC                        AS CPMC             --7 产品名称
         ,T1.ZQZRRQ                      AS ZQZR             --8 债权转让日期
         ,CASE WHEN T1.ZRFSLB='01' THEN '直接转让债权不转股'
               WHEN T1.ZRFSLB='01' THEN '直接转让债权债转股'
               WHEN T1.ZRFSLB='01' THEN '信贷资产证券化'
               WHEN T1.ZRFSLB='01' THEN '信贷资产收益权转让'
               WHEN T1.ZRFSLB='01' THEN '通过其他方式转让'
              END                        AS ZRFSLB           --9 转让方式类别
         ,T1.DYBJ                        AS DYBJ             --10 对应本金
         ,T11.TAR_VALUE_NAME             AS CZQWJFL          --11 处置前五级分类
         ,DECODE(T1.SFZZG ,'Y','是','否')    AS SFZZG            --12 是否债转股
         ,SSJE                           AS SSJE             --13 损失金额（元）
         ,T1.DZHHXJE                     AS TZHHXJE          --14 调整后核销金额（元）
         ,T1.DZHZRHSXJ                   AS TZHZRHSXJ        --15 调整后转让回收现金（元）
          -- 转让回收现金模型记录在合同里面
         ,T1.ZRSHQTDJ                    AS ZRSHQTDJ         --16 转让收回其他对价
         ,T1.ZCJE                        AS ZCJE             --17 自持金额（元）
         ,CASE WHEN T1.ZCZRJYPT='A' THEN '银登中心'
               WHEN T1.ZCZRJYPT='B' THEN '证券交易所'
               WHEN T1.ZCZRJYPT='C' THEN '银行间市场'
               WHEN T1.ZCZRJYPT='Z' THEN '其他'
              END                            AS ZCZRJYPT          --18 资产转让交易平台
         ,CASE WHEN T1.ZCZRDJPT ='01' THEN '银登中心'
               WHEN T1.ZCZRDJPT ='02' THEN  '其他'
              END                        AS ZCZRDJPT          --19 资产转让登记平台
         ,CASE WHEN T1.ZJJYDSLB='A'   THEN '个人投资者'
               WHEN T1.ZJJYDSLB='B'   THEN '非金融企业'
               WHEN T1.ZJJYDSLB='C'   THEN '地方资产管理公司'
               WHEN T1.ZJJYDSLB='D'   THEN '全国性资产管理公司'
               WHEN T1.ZJJYDSLB='E'   THEN '证券业金融机构'
               WHEN T1.ZJJYDSLB='F'   THEN '保险业金融机构'
               WHEN T1.ZJJYDSLB='G'   THEN '其他机构'
               WHEN T1.ZJJYDSLB='H'   THEN '非银行业金融机构'
               WHEN T1.ZJJYDSLB='I'   THEN '特殊目的载体'
               WHEN T1.ZJJYDSLB='I01' THEN '理财产品'
               WHEN T1.ZJJYDSLB='I02' THEN '信托产品'
               WHEN T1.ZJJYDSLB='I03' THEN '资管计划'
               WHEN T1.ZJJYDSLB='I04' THEN '其他SPV'
               WHEN T1.ZJJYDSLB='I05' THEN '商业银行'
               WHEN T1.ZJJYDSLB='I06' THEN '其他银行业金融机构'
               WHEN T1.ZJJYDSLB='I07' THEN '信托公司'
               WHEN T1.ZJJYDSLB='I08' THEN '保险业机构资管产品'
               WHEN T1.ZJJYDSLB='Z'   THEN '无需区分'
              END                            AS ZJJYDSLB          --20 直接交易对手类别
         ,''                             AS ZQZRYZ            --21 债权转让原值（元）--G34没有用到
         ,''                             AS ZQZRXYJE          --22 债权转让协议金额（元）--G34没有用到
         ,JYDSLB                         AS JYDSLB_RH        --23 交易对手类别（人行）
     FROM (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
            FROM RRP_MDL.M_ADD_LS_013_ASSETS_CONVEY T
           WHERE T.DATA_DATE = V_P_DATE )T1 --零售资产转让补录表
     LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
       ON T1.ACCT_ORG_NUM = T3.ORG_ID
      AND T3.DATA_DT = V_P_DATE
     LEFT JOIN CODE_MAP T11
       ON '0'||T1.CZQWJFL = T11.SRC_VALUE_CODE
      AND T11.MOD_FLG='EAST'
      AND T11.SRC_CLASS_CODE='D0005'
    WHERE T1.DATA_DATE = V_P_DATE
      AND T1.RN = 1;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_PHB_TRANSFER T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_PHB_TRANSFER;
/

