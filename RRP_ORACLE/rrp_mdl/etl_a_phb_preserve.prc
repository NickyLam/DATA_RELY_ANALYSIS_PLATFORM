CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_PRESERVE
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_PRESERVE
  *  功能描述：普惠部特殊资产处置台账
  *  创建日期：20221107
  *  开发人员：孙满洋
  *  来源表：
  *  目标表：A_PHB_PRESERVE --特殊资产处置台账
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20230105   孙满洋      首次创建
  *   2    20230904   潘金成      根据测试数据调整过滤条件
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_PRESERVE';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME   VARCHAR2(100) ;   --表名
  V_PART_NAME  VARCHAR2(100);    --分区名

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_PHB_PRESERVE'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
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
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入资产保全台账信息';
  V_STARTTIME := SYSDATE;

  INSERT INTO A_PHB_PRESERVE (
           BGRQ                --报告日期
          ,ZWJGBH              --机构号
          ,ZWJGMC              --机构名称
          ,FHSYB               --分行/事业部
          ,KHJLMC              --客户经理名称
          ,HXKHH               --核心客户号
          ,CZLSH               --处置流水号
          ,JJH                 --借据号
          ,KHMC                --客户名称
          ,KHLX                --客户类型
          ,TXGMJJXYXLMC        --投向国民经济行业小类名称
          ,QYGM                --企业规模
          ,ZCLX                --资产类型
          ,NCTJYE              --年初授信余额折人民币
          ,NCFXFL              --年初风险分类
          ,DYCXTBLSJ           --第一次下调不良时间
          ,FXPCJG              --风险排查结果
          ,LRTQMDSJ            --列入铁骑名单时间
          ,CZSDFXFL            --处置时点风险分类
          ,CZFS                --处置方式
          ,ZCZRLX              --资产转让类型
          ,CZSJ                --处置时间
          ,CZJE                --处置金额
          ,HKLY                --还款来源
          ,CZQXJE              --处置欠息金额
          ,CZFAXJE             --处置罚息金额
          ,CZFUXJE             --处置复息金额
          ,CZDDFY              --处置代垫费用
          ,BDQWJFL             --变动前五级分类
          ,BDQYE               --变动前余额
          ,BDHWJFL             --变动后五级分类
          ,CZHSXRQ             --核销/抵债后收现日期
          ,CZHSHJE             --核销/抵债后收回金额（元）
          ,THZCHSHJE           --调回正常后收回金额
          ,BZ                  --备注
          ,START_DT            --开始时间
          ,END_DT              --结束时间
          ,ID_MARK             --增删标志
          ,ETL_TIMESTAMP       --etl处理时间戳
          ,BUSINESSTYPE        --授信品种
         )
    SELECT
           V_P_DATE                        AS BGRQ                --报告日期
          ,T1.INPUTORGID                   AS ZWJGBH              --机构号
          ,T2.ORG_NM                       AS ZWJGMC              --机构名称
          ,T1.BRANCHBUSINESSDIVISION       AS FHSYB               --分行/事业部
          ,T3.EMP_NM                       AS KHJLMC              --客户经理名称
          ,T1.CUSTOMERID                   AS HXKHH               --核心客户号
          ,T1.SERIALNO                     AS CZLSH               --处置流水号
          ,T1.DUEBILLID                    AS JJH                 --借据号
          ,T1.CUSTOMERNAME                 AS KHMC                --客户名称
          ,T1.CUSTOMERTYPE                 AS KHLX                --客户类型
          ,P1.CODENAME                     AS TXGMJJXYXLMC        --投向国民经济行业小类名称
          ,T1.ENTSCALE                     AS QYGM                --企业规模
          ,T1.ASSETTYPE                    AS ZCLX                --资产类型
          ,T1.BEGINCREDITBALANCE           AS NCTJYE              --年初授信余额折人民币
          ,T1.BEGINRISKCLASSIFY            AS NCFXFL              --年初风险分类
          ,TO_CHAR(T1.FIRSTTIMEDESC,'YYYYMMDD')
                                           AS DYCXTBLSJ           --第一次下调不良时间
          ,T1.RISKISOLATIONRESULTS         AS FXPCJG              --风险排查结果
          ,TO_CHAR(T1.IRONRIDETIME,'YYYYMMDD')
                                           AS LRTQMDSJ            --列入铁骑名单时间
          ,T1.HANDLERISKCLASSIFY           AS CZSDFXFL            --处置时点风险分类
          ,T1.HANDLETYPE                   AS CZFS                --处置方式
          ,T1.TYPEASSETTRANSFER            AS ZCZRLX              --资产转让类型
          ,TO_CHAR(T1.HANDLETIME,'YYYYMMDD')
                                           AS CZSJ                --处置时间
          ,T1.HANDLEBALANCE                AS CZJE                --处置金额
          ,T1.REPAYMENTRESOURCE            AS HKLY                --还款来源
          ,T1.HANDLEINTERESTBALANCE        AS CZQXJE              --处置欠息金额
          ,T1.HANDLECHARGEDBALANCE         AS CZFAXJE             --处置罚息金额
          ,T1.HANDLEREINTERESTEDBALANCE    AS CZFUXJE             --处置复息金额
          ,T1.HANDLESUBSTITUTECUSHION      AS CZDDFY              --处置代垫费用
          ,T1.BEFORECLASSIFYRESULT         AS BDQWJFL             --变动前五级分类
          ,T1.BEFOREBALANCE                AS BDQYE               --变动前余额
          ,T1.AFTERCLASSIFYRESULT          AS BDHWJFL             --变动后五级分类
          ,TO_CHAR(T1.CASHOFFDATE,'YYYYMMDD')
                                           AS CZHSXRQ             --核销/抵债后收现日期
          ,T1.RECOVEROFFBALANCE            AS CZHSHJE             --核销/抵债后收回金额（元）
          ,T1.NORMALRECOVERBALANCE         AS THZCHSHJE           --调回正常后收回金额
          ,T1.REMARK                       AS BZ                  --备注
          ,T1.START_DT                     AS START_DT            --开始时间
          ,T1.END_DT                       AS END_DT              --结束时间
          ,T1.ID_MARK                      AS ID_MARK             --增删标志
          ,T1.ETL_TIMESTAMP                AS ETL_TIMESTAMP       --etl处理时间戳
          ,T1.SXPZ                         AS BUSINESSTYPE        --授信品种
      FROM RRP_MDL.M_ASSET_PRESERVATION_LEDGET T1
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T2
        ON T2.ORG_ID = T1.INPUTORGID
       AND T2.DATA_DT = V_P_DATE
      LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.EMP_ID ORDER BY T.APP_DT DESC) RN
                  FROM RRP_MDL.M_PUM_EMP_INFO T --行员表
                 WHERE T.DATA_DT = V_P_DATE
                   AND T.EMP_ID IS NOT NULL
                ) T3
        ON T3.EMP_ID = T1.INPUTUSERID
       AND T3.RN = 1
      LEFT JOIN RRP_MDL.M_BASIC_CODETABLE P1 --行业类别-2017
        ON P1.CODE = T1.INDUSTRY
       AND P1.CODE_TABLE_CODE = 'C0107'
     WHERE T1.DATA_DT = V_P_DATE
       AND T1.CUSTOMERTYPE IN ('个人客户')
       AND T1.ASSETTYPE IN ('不良贷款','不良资产（非信贷）','不良资产(非信贷)')--码值待研究
       ;
    COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,CZLSH,COUNT(1)
      FROM RRP_MDL.A_PHB_PRESERVE T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,CZLSH
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

  END ETL_A_PHB_PRESERVE;
/

