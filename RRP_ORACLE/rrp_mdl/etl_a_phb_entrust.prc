CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_ENTRUST
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_ENTRUST
  *  功能描述：以借据为粒度，接入委托贷款有关信息。报送范围为个人及对公委托贷款业务，
              包括现金管理项下委托贷款、非现金管理项下委托贷款和公积金委托贷款。
  *  创建日期：20221104
  *  开发人员：徐菲
  *  来源表：S_LOAN_ENTRS --委托贷款业务整合表
  *  目标表：A_PHB_ENTRUST --委托贷款基表_零售
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221104   xufei      首次创建
  *   2    20230407   liuyu      调整过滤条件，取有余额的借据
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_ENTRUST';
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
  V_TAB_NAME   := 'A_PHB_ENTRUST'; --表名,写目标表表名
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

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;


   INSERT /*+APPEND*/ INTO A_PHB_ENTRUST NOLOGGING
      (
         BGRQ                --001 报告日期
        ,JYWYM               --002 交易唯一码
        ,KHWYM               --003 客户唯一码
        ,ZWJGBH              --004 账务机构编号
        ,ZWJGMC              --005 账务机构名称
        ,TXGMJJXYMLMC        --006 投向国民经济行业门类名称
        ,TXGMJJXYXLDM        --007 投向国民经济行业小类代码
        ,TJYE                --008 统计余额（元）
        ,WTRJJCF             --009 委托人经济成分
        ,WTRKHH              --010 委托人客户号
        ,WTRMC               --011 委托人名称
        ,GRDKYTLBMC          --012 个人贷款用途类别名称
        ,WTDKLBMC            --013 委托贷款类别名称
        ,ZHWYM               --014 账户唯一码
        ,CUST_NAM            --015 客户中文名称
       )

       SELECT  A.DATA_DT            AS BGRQ         --001 报告日期
              ,A.RCPT_ID            AS JYWYM        --002 交易唯一码
              ,A.CUST_ID            AS KHWYM        --003 客户唯一码
              ,A.ORG_ID              AS ZWJGBH       --004 账务机构编号
              ,E.ORG_NM              AS ZWJGMC       --005 账务机构名称
              ,G.SRC_VALUE_NAME     AS TXGMJJXYMLMC --006 投向国民经济行业门类名称
              ,J.SRC_VALUE_NAME     AS TXGMJJXYXLDM --007 投向国民经济行业小类代码
              ,A.LOAN_BAL *I.EXRT   AS TJYE         --008 统计余额（元）
              ,K.SRC_VALUE_NAME      AS WTRJJCF      --009 委托人经济成分
              ,A.CONSR_CUST_ID      AS WTRKHH       --010 委托人客户号
              ,D.CUST_NM            AS WTRMC        --011 委托人名称
              ,A.ENTRS_LOAN_USEAGE  AS GRDKYTLBMC   --012 个人贷款用途类别名称
              ,DECODE(A.ENTRS_LOAN_SPCL_DIR
                      ,'A01','信用卡'
                      ,'A02','汽车'
                      ,'A03','住房按揭贷款'
                      ,'A99','其他'
                      ,'B01','买断式转贴现'
                      ,'经营性委托贷款')
                                    AS WTDKLBMC     --013 委托贷款类别名称
              ,F.CONT_ID            AS ZHWYM        --014 账户唯一码
              ,C.CUST_NM            AS CUST_NAM     --015 客户中文名称
         FROM RRP_MDL.S_LOAN_ENTRS A --委托贷款业务整合表
         LEFT JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息
           ON C.CUST_ID = A.CUST_ID --借款人客户编号
          AND C.DATA_DT = A.DATA_DT
         LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
           ON D.CUST_ID = A.CONSR_CUST_ID --委托人客户编号
          AND D.DATA_DT = A.DATA_DT
         LEFT JOIN RRP_MDL.M_PUM_ORG_INFO E --机构表
           ON E.ORG_ID = A.ORG_ID
          AND E.DATA_DT = A.DATA_DT
         LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO F --表内借据信息
           ON F.RCPT_ID = A.RCPT_ID
          AND F.DATA_DT = A.DATA_DT
          AND F.LOAN_BIZ_TYP = '90' --委托贷款
          AND F.DATA_SRC IN ('零售贷款', '联合网贷')
         LEFT JOIN RRP_MDL.CODE_MAP G --码值映射表
           ON G.SRC_VALUE_CODE = SUBSTR(TRIM(A.LOAN_DIR_IDY), 1, 1)
          AND G.SRC_CLASS_CODE = 'P0003' --行业类别 门类
          AND G.TAR_CLASS_CODE = 'P0003' --行业类别
          AND G.MOD_FLG = 'EAST'
         LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO I --汇率表
           ON I.BASE_CUR = A.BIZ_CUR
          AND I.CNV_CUR = 'CNY'
          AND I.DATA_DT = A.DATA_DT
         LEFT JOIN RRP_MDL.CODE_MAP J --码值映射表
           ON J.SRC_VALUE_CODE = A.LOAN_DIR_IDY
          AND J.SRC_CLASS_CODE = 'P0003' --行业类别 小类
          AND J.TAR_CLASS_CODE = 'P0003' --行业类别
          AND J.MOD_FLG = 'EAST'
         LEFT JOIN RRP_MDL.CODE_MAP K --码值映射表
           ON K.SRC_VALUE_CODE = D.ENT_HLDG_TYP
          AND K.SRC_CLASS_CODE = 'C0004' --经济成分代码
          AND K.TAR_CLASS_CODE = 'C0004' --经济成分代码
        WHERE A.DATA_DT = V_P_DATE
          AND A.DATA_SRC = '个人贷款'
          AND EXISTS
              (SELECT 1
                 FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T
                WHERE T.DATA_DT = V_P_DATE
                  AND T.DATA_SRC IN ('零售贷款')
                  AND T.LOAN_BIZ_TYP = '90'
                  AND T.LOAN_BAL <> 0
                  AND T.RCPT_ID = F.RCPT_ID);
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
      FROM RRP_MDL.A_PHB_ENTRUST T
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
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_PHB_ENTRUST;
/

