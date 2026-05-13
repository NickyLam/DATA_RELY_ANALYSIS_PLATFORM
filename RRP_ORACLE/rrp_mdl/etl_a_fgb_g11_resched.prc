CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_G11_RESCHED
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_G11_RESCHED
  *  功能描述：本表主要反应G1101报表报送的重组贷款口径：借款人财务状况困难，无法遵守借款合同规定的时间表还款，
               逾期超过信贷管理政策规定的一定时间，还款情况已不正常，填报机构不得不对合同规定的还款条件进行修订，
               对借款人作出减让安排的贷款。
               表现为：贷款展期、借新还旧、减免利息、减免部分本金、调整还款方式、改善抵押品、改变担保条件等形式，
               以及记录重组贷款借据的发生状态时点数据。
  *  创建日期：20221107
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_FGB_G11_RESCHED --对公-重组贷款小基表（G1101）
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   liuyu      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_G11_RESCHED';
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
  V_TAB_NAME := 'A_FGB_G11_RESCHED'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

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
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入G11重组信息';
  V_STARTTIME := SYSDATE;

  INSERT INTO A_FGB_G11_RESCHED
    (
       BGRQ          -- 报告日期
      ,JYWYM         -- 交易唯一码
      ,JGH           -- 机构号
      ,JGMC          -- 机构名称
      ,CZRQ          -- 重组日期
      ,SFBNCZ         -- 是否本年重组
      ,NCTJYE        -- 年初统计余额（元）
      ,NCWJFL        -- 年初五级分类
      ,NCCZDKTJYE    -- 年初重组贷款统计余额（元）
      ,BNCZSDWJFL    -- 本年重组时点五级分类
      ,BNCZSDTJYE    -- 本年重组时点统计余额（元）
      ,BNCZSDJE      -- 本年重组上调金额（元）
      ,CZDKJSJE      -- 重组贷款减少金额（元）
      ,QMCZDKTJYE    -- 期末重组贷款统计余额（元）
      ,WJFL          -- 五级分类
      ,ZZYQRQ        -- 最早逾期日期
      ,YQTSQJ        -- 逾期天数区间
      ,TJYE          -- 统计余额（元）
    )
    SELECT
         V_P_DATE                   AS BGRQ          -- 报告日期
        ,A.RCPT_ID                  AS JYWYM         -- 交易唯一码
        ,A.ORG_ID                   AS JGH           -- 机构号
        ,D.ORG_NM                   AS JGMC          -- 机构名称
        ,C.CONT_SIGN_DT             AS CZRQ          -- 重组日期
        ,CASE WHEN TRUNC(TO_DATE(C.CONT_SIGN_DT,'YYYYMMDD'),'Y')
		         = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')  THEN '是'
              ELSE '否' END         AS SFBNCZ        -- 是否本年重组
        ,B.LOAN_NET_VAL             AS NCTJYE        -- 年初统计余额（元）
        ,CASE
             WHEN B.LVL5_CL = '01' THEN '正常类'
             WHEN B.LVL5_CL = '02' THEN '关注类'
             WHEN B.LVL5_CL = '03' THEN '次级类'
             WHEN B.LVL5_CL = '04' THEN '可疑类'
             WHEN B.LVL5_CL = '05' THEN '损失类'
         END     			              AS NCWJFL        -- 年初五级分类
        ,B.LOAN_NET_VAL             AS NCCZDKTJYE    -- 年初重组贷款统计余额（元）
        ,CASE WHEN B1.LVL5_CL = '01' THEN '正常类'
              WHEN B1.LVL5_CL = '02' THEN '关注类'
              WHEN B1.LVL5_CL = '03' THEN '次级类'
              WHEN B1.LVL5_CL = '04' THEN '可疑类'
              WHEN B1.LVL5_CL = '05' THEN '损失类'
         END                        AS BNCZSDWJFL    -- 本年重组时点五级分类  --取数加工导致性能差,且L层没有存量数据取数
        ,B1.LOAN_NET_VAL            AS BNCZSDTJYE    -- 本年重组时点统计余额（元） --取数加工导致性能差,且L层没有存量数据取数
        ,''                         AS BNCZSDJE      -- 本年重组上调金额（元）--
        ,''                         AS CZDKJSJE      -- 重组贷款减少金额（元）
        ,A.LOAN_NET_VAL             AS QMCZDKTJYE    -- 期末重组贷款统计余额（元）
        ,CASE WHEN A.LVL5_CL= '01' THEN '正常类'
              WHEN A.LVL5_CL= '02' THEN '关注类'
              WHEN A.LVL5_CL= '03' THEN '次级类'
              WHEN A.LVL5_CL= '04' THEN '可疑类'
              WHEN A.LVL5_CL= '05' THEN '损失类'
         END                        AS WJFL          -- 五级分类
        ,TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - NVL(A.OVD_DAYS,0),'YYYYMMDD')
                                    AS ZZYQRQ        -- 最早逾期日期
        ,CASE WHEN A.OVD_DAYS < = 0 THEN '未逾期'
              WHEN A.OVD_DAYS > 0   AND A.OVD_DAYS < = 30  THEN '逾期30天以内'
              WHEN A.OVD_DAYS > 30  AND A.OVD_DAYS < = 60  THEN '逾期31天到60天'
              WHEN A.OVD_DAYS > 60  AND A.OVD_DAYS < = 90  THEN '逾期61天到90天'
              WHEN A.OVD_DAYS > 90  AND A.OVD_DAYS < = 180 THEN '逾期91天到180天'
              WHEN A.OVD_DAYS > 180 AND A.OVD_DAYS < = 270 THEN '逾期181天到270天'
              WHEN A.OVD_DAYS > 270 AND A.OVD_DAYS < = 360 THEN '逾期271天到360天'
              WHEN A.OVD_DAYS > 360 THEN '逾期361天以上'
         END                        AS YQTSQJ        -- 逾期天数区间
        ,A.LOAN_NET_VAL             AS TJYE          -- 统计余额（元）
    FROM S_LOAN A
    LEFT JOIN S_LOAN B
      ON B.RCPT_ID = A.RCPT_ID
     AND B.DATA_SRC IN ('对公信贷')
     AND B.DATA_DT =
         TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Y') - 1, 'YYYYMMDD') --取年初数据:这边年初就是取上年末
    LEFT JOIN M_LOAN_CONT_INFO C --贷款合同信息表
      ON C.CONT_ID = A.CONT_ID
     AND C.DATA_DT = V_P_DATE
    LEFT JOIN S_LOAN B1
      ON B1.RCPT_ID = A.RCPT_ID
     AND B1.DATA_SRC IN ('对公信贷')
     AND B1.DATA_DT = C.CONT_SIGN_DT --取重组时点五级分类
     AND TRUNC(TO_DATE(C.CONT_SIGN_DT, 'YYYYMMDD'), 'Y') =
         TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Y')
    LEFT JOIN M_PUM_ORG_INFO D --机构表
      ON D.ORG_ID = A.ORG_ID
     AND D.DATA_DT = V_P_DATE
  /*    --=====从补录表取重组标志 START =======
  INNER JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
                FROM M_ADD_DG_003_MONEY T
               WHERE DATA_DATE = V_P_DATE ) T -- 补录表
     ON T.JYWYM = A.RCPT_ID
    AND T.RN = 1
    AND T.DATA_DATE = V_P_DATE
   --=======从补录表取重组标志 END =======*/
   WHERE A.DATA_DT = V_P_DATE
     AND A.DATA_SRC IN ('对公信贷')
        --AND T.SFCZ = 'Y'-- 取补录表的重组的
     AND C.LOAN_HAPP_TYPE_CD IN ('0201', '0202', '0204')
        --0201：展期、0202：借新还旧、0204：债务重组
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
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_G11_RESCHED T
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

  END ETL_A_FGB_G11_RESCHED;
/

