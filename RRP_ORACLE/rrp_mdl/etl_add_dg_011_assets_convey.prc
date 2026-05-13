CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_011_ASSETS_CONVEY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_DG_011_ASSETS_CONVEY
  *  功能描述：补录表-对公-资产转让模型。
  *  创建日期：20221219
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_ASSET_SECU_TRAN_CONT_INFO   --资产证券化转让合同信息表
  *            IML.AGT_ASSET_POOL_BASE_RELA_H      --资产池与基础资产关系历史表
  *            IML.AGT_SECU_BASE_ASSET_H           --证券基础资产历史
  *            ICL.CMM_CORP_CUST_BASIC_INFO        --对公客户基本信息表
  *            ICL.CMM_INTNAL_ORG_INFO             --内部机构信息表
  *  目标表：  ADD_DG_011_ASSETS_CONVEY  --资产转让模型
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221119  hulj     首次创建。
  *             2    20230530  liuyu    调整继承上天数据逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                                -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                      -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_ADD_DG_011_ASSETS_CONVEY';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_DG_011_ASSETS_CONVEY';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                      -- 分区名称
  V_P_DATE      VARCHAR2(8);                                        -- 跑批数据日期
  V_STARTTIME   DATE;                                               -- 处理开始时间
  V_ENDTIME     DATE;                                               -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                                -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                      -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                       -- 来源系统

BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '备份当期数据-从ETL表继承';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_011_ASSETS_CONVEY
    (
     DATA_DATE      --01 数据日期
    ,ACCT_ORG_NUM   --02 账务机构编号
    ,JYWYM          --03 交易唯一码
    ,ZWJGMC         --04 账务机构名称
    ,KHWYM          --05 客户唯一码
    ,KHMC           --06 客户名称
    ,CPLX           --07 产品类型
    ,CPMC           --08 产品名称
    ,ZQZRRQ         --09 债权转让日期
    ,ZRFSLB         --10 转让方式类别
    ,ZRFS           --11 转让方式
    ,DYBJ           --12 对应本金
    --,CZQWJFL        --13 处置前五级分类
    --,SFZZG          --14 是否债转股
    --,SSJE           --15 损失金额（元）
    --,DZHHXJE        --16 调整后核销金额（元）
    --,DHZCHSHJE      --17 调回正常后收回金额
    ,DZHZRHSXJ      --18 调整后转让回收现金（元）
    ,ZRSHQTDJ       --19 转让收回其他对价（元）
    ,ZCJE           --20 自持金额（元）
    ,ZCZRJYPT       --21 资产转让交易平台
    ,ZCZRDJPT       --22 资产转让登记平台
    ,ZJJYDSLB       --23 直接交易对手类别
    ,JYDSMC         --24 交易对手名称
    ,ZQZRYZ         --25 债权转让原值（元）
    ,ZQZRXYJE       --26 债权转让协议金额（元）
    ,DJPTDJJE       --27 登记平台登记金额
    ,SYS_SOURCE     --28 来源系统
    ,SFSC           --29 是否删除
    ,RMYHJYDSLB     --30 人民银行交易对手类别
    )
    SELECT /*+ PARALLEL(A,4) */
           V_P_DATE       --01 数据日期
          ,ACCT_ORG_NUM   --02 账务机构编号
          ,JYWYM          --03 交易唯一码
          ,ZWJGMC         --04 账务机构名称
          ,KHWYM          --05 客户唯一码
          ,KHMC           --06 客户名称
          ,CPLX           --07 产品类型
          ,CPMC           --08 产品名称
          ,ZQZRRQ         --09 债权转让日期
          ,ZRFSLB         --10 转让方式类别
          ,ZRFS           --11 转让方式
          ,DYBJ           --12 对应本金
          --,CZQWJFL        --13 处置前五级分类
          --,SFZZG          --14 是否债转股
          --,SSJE           --15 损失金额（元）
          --,DZHHXJE        --16 调整后核销金额（元）
          --,DHZCHSHJE      --17 调回正常后收回金额
          ,DZHZRHSXJ      --18 调整后转让回收现金（元）
          ,ZRSHQTDJ       --19 转让收回其他对价（元）
          ,ZCJE           --20 自持金额（元）
          ,ZCZRJYPT       --21 资产转让交易平台
          ,ZCZRDJPT       --22 资产转让登记平台
          ,ZJJYDSLB       --23 直接交易对手类别
          ,JYDSMC         --24 交易对手名称
          ,ZQZRYZ         --25 债权转让原值（元）
          ,ZQZRXYJE       --26 债权转让协议金额（元）
          ,DJPTDJJE       --27 登记平台登记金额
          ,SYS_SOURCE     --28 来源系统
          ,SFSC           --29 是否删除
          ,RMYHJYDSLB     --30 人民银行交易对手类别
    FROM (
    SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_011_ASSETS_CONVEY_ETL A
     WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_DG_011_ASSETS_CONVEY_ETL)
       ) T
    WHERE T.RN = 1
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 3;
   V_STEP_DESC := '备份当期数据-从ADD表继承';
   V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_011_ASSETS_CONVEY
    (
     DATA_DATE      --01 数据日期
    ,ACCT_ORG_NUM   --02 账务机构编号
    ,JYWYM          --03 交易唯一码
    ,ZWJGMC         --04 账务机构名称
    ,KHWYM          --05 客户唯一码
    ,KHMC           --06 客户名称
    ,CPLX           --07 产品类型
    ,CPMC           --08 产品名称
    ,ZQZRRQ         --09 债权转让日期
    ,ZRFSLB         --10 转让方式类别
    ,ZRFS           --11 转让方式
    ,DYBJ           --12 对应本金
    --,CZQWJFL        --13 处置前五级分类
    --,SFZZG          --14 是否债转股
    --,SSJE           --15 损失金额（元）
    --,DZHHXJE        --16 调整后核销金额（元）
    --,DHZCHSHJE      --17 调回正常后收回金额
    ,DZHZRHSXJ      --18 调整后转让回收现金（元）
    ,ZRSHQTDJ       --19 转让收回其他对价（元）
    ,ZCJE           --20 自持金额（元）
    ,ZCZRJYPT       --21 资产转让交易平台
    ,ZCZRDJPT       --22 资产转让登记平台
    ,ZJJYDSLB       --23 直接交易对手类别
    ,JYDSMC         --24 交易对手名称
    ,ZQZRYZ         --25 债权转让原值（元）
    ,ZQZRXYJE       --26 债权转让协议金额（元）
    ,DJPTDJJE       --27 登记平台登记金额
    ,SYS_SOURCE     --28 来源系统
    ,SFSC           --29 是否删除
    ,RMYHJYDSLB     --30 人民银行交易对手类别
    )
    SELECT /*+ PARALLEL(A,4) */
           V_P_DATE       --01 数据日期
          ,ACCT_ORG_NUM   --02 账务机构编号
          ,JYWYM          --03 交易唯一码
          ,ZWJGMC         --04 账务机构名称
          ,KHWYM          --05 客户唯一码
          ,KHMC           --06 客户名称
          ,CPLX           --07 产品类型
          ,CPMC           --08 产品名称
          ,ZQZRRQ         --09 债权转让日期
          ,ZRFSLB         --10 转让方式类别
          ,ZRFS           --11 转让方式
          ,DYBJ           --12 对应本金
          --,CZQWJFL        --13 处置前五级分类
          --,SFZZG          --14 是否债转股
          --,SSJE           --15 损失金额（元）
          --,DZHHXJE        --16 调整后核销金额（元）
          --,DHZCHSHJE      --17 调回正常后收回金额
          ,DZHZRHSXJ      --18 调整后转让回收现金（元）
          ,ZRSHQTDJ       --19 转让收回其他对价（元）
          ,ZCJE           --20 自持金额（元）
          ,ZCZRJYPT       --21 资产转让交易平台
          ,ZCZRDJPT       --22 资产转让登记平台
          ,ZJJYDSLB       --23 直接交易对手类别
          ,JYDSMC         --24 交易对手名称
          ,ZQZRYZ         --25 债权转让原值（元）
          ,ZQZRXYJE       --26 债权转让协议金额（元）
          ,DJPTDJJE       --27 登记平台登记金额
          ,SYS_SOURCE     --28 来源系统
          ,SFSC           --29 是否删除
          ,RMYHJYDSLB     --30 人民银行交易对手类别
      FROM RRP_MDL.ADD_DG_011_ASSETS_CONVEY T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_DG_011_ASSETS_CONVEY T2
                        WHERE T1.JYWYM = T2.JYWYM
                          AND T2.DATA_DATE = V_P_DATE)
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP      := 4;
   V_STEP_DESC := '增加表分析及跑批过程完成表';
   V_STARTTIME := SYSDATE;

     --表分析
     ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PART_NAME, O_ERRCODE);
     --插入过程跑批完成记录表
     INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
     VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.ADD_DG_011_ASSETS_CONVEY T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 程序跑批结束记录 --
   V_STEP      := 5;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_ADD_DG_011_ASSETS_CONVEY;
/

