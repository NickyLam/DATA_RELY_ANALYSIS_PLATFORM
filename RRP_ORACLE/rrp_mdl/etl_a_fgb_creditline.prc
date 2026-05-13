CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_CREDITLINE

(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_CREDITLINE
  *  功能描述：
  *  创建日期：20221104
  *  开发人员: liuyu
  *  来源表：
  *  目标表：A_FGB_CREDITLINE --对公_授信基表
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221104   liuyu      首次创建
  *   2    20220117   liuyu      重写逻辑，按照客户维度取数
  *   3    20230322   liuyu      授信基表逻辑注释，暂不上线
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_CREDITLINE';   -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  --V_LAST_DAT   VARCHAR2(8);      -- 当月月末
  --V_YESTADAY   VARCHAR2(8);      -- 上日
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  --V_MONTH_START_DATE DATE;       --系统时间对应月初日期
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY   := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT   := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'A_FGB_CREDITLINE'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期
  -- 支持重跑 --
  /*V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --DELETE FROM A_FGB_CREDITLINE T WHERE T.BGRQ = V_P_DATE;--普通表的重跑处理

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
  ETL_PARTITION_ADD(V_P_DATE, 'A_FGB_CREDITLINE', '1', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||'A_FGB_CREDITLINE'||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_FGB_CREDITLINE
  (
         BGRQ                    -- 1 报告日期
        ,ZHWYM                   -- 2 账户唯一码
        ,ZWJGBH                  -- 3 账务机构编号
        ,ZWJGMC                  -- 4 账务机构名称
        ,KHWYM                   -- 5 客户唯一码
        ,KHMC                    -- 6 客户名称
        ,SXZED                   -- 7 授信总额度（元）
        ,SXQSRQ                  -- 8 授信起始日期
        ,SXDQRQ                  -- 9 授信到期日期
        ,YXYE                    -- 10 用信余额（元）
        ,CNYE                    -- 11 承诺余额（元）
        ,EDHTJE                  -- 12 额度合同金额（元）
        ,EDHTYWPZ                -- 13 额度合同业务品种
        ,FSLX                    -- 14 发生类型
        ,YHTBH                   -- 15 原合同编号
        ,CNLB                    -- 16 承诺类别
        ,KHLX                    -- 17 客户类型
  )
   SELECT
         V_P_DATE                      AS BGRQ                    -- 1 报告日期
        ,T5.CRDT_CONT_ID               AS ZHWYM                   -- 2 账户唯一码
        ,COALESCE(T2.ORG_ID,T7.ORG_ID,T7.OPEN_ACCT_ORG_ID) -- modby liuyu 20230116 调整后数据
                                       AS ZWJGBH                  -- 3 账务机构编号
        ,T3.ORG_NM                     AS ZWJGMC                  -- 4 账务机构名称
        ,T1.CUST_ID                    AS KHWYM                   -- 5 客户唯一码
        ,T4.CUST_NM                    AS KHMC                    -- 6 客户名称
        ,T1.CRDT_TOTAL_LMT             AS SXZED                   -- 7 授信总额度（元）
        ,T5.CRDT_START_DT              AS SXQSRQ                  -- 8 授信起始日期
        ,T5.CRDT_EXP_DT                AS SXDQRQ                  -- 9 授信到期日期
        ,M.YYED                        AS YXYE                    -- 10 用信余额（元）
        ,M.CNYE                        AS CNYE                    -- 11 承诺余额（元）
        ,T5.CRDT_LMT*T6.EXRT           AS EDHTJE                  -- 12 额度合同金额（元）
        ,S.PROD_NAME                   AS EDHTYWPZ                -- 13 额度合同业务品种
        ,CASE WHEN T5.LOAN_HAPP_TYPE_CD = '0100' THEN '新增'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0101' THEN '授信条件变更'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0102' THEN '原额度续作'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0103' THEN '增额续作'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0104' THEN '减额续作'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0201' THEN '展期'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0202' THEN '借新还旧'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0204' THEN '债务重组'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0205' THEN '新借'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0206' THEN '复议'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0207' THEN '年审'
              WHEN T5.LOAN_HAPP_TYPE_CD = '0208' THEN '变更借款人'
         END                           AS FSLX                    -- 14 发生类型
        ,T5.RELA_CONT_ID               AS YHTBH                   -- 15 原合同编号
        ,'可随时无条件撤销的贷款承诺'  AS CNLB                    -- 16 承诺类别
        ,DECODE(T4.TYBZ,'Y','同业客户','N','对公客户')
                                       AS KHLX                    -- 17 客户类型
    FROM RRP_MDL.M_CRDT_LMT_SUB T5 -- 授信额度子表
   INNER JOIN RRP_MDL.M_CRDT_LMT_INFO T1 -- 授信额度主表
      ON T1.CUST_ID = T5.CUST_ID
     AND T1.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT LMT_CONT_ID
                     ,ORG_ID
                     ,COUNT(DISTINCT SUBSTR(ORG_ID, 1, 3)) OVER(PARTITION BY LMT_CONT_ID) AS CNT --授信合同下不同分行计数
                     ,ROW_NUMBER() OVER(PARTITION BY LMT_CONT_ID ORDER BY ORG_ID DESC) AS RN --授信合同下的机构排序
                 FROM (SELECT DISTINCT A.LMT_CONT_ID AS LMT_CONT_ID, A.ORG_ID
                         FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A
                        WHERE A.DATA_DT = V_P_DATE
                          AND A.DATA_SRC NOT IN ('零售贷款', '联合网贷')
                          AND TRIM(LMT_CONT_ID) IS NOT NULL
                       UNION
                       SELECT DISTINCT B.CRDT_LMT_ID AS LMT_CONT_ID, A.ORG_ID
                         FROM RRP_MDL.M_LOAN_BILL_INFO A -- 票据出票信息表
                         LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO B -- 合同表
                           ON A.LOAN_CONT_ID = B.CONT_ID
                          AND B.DATA_DT = V_P_DATE
                        WHERE A.DATA_DT = V_P_DATE
                          AND TRIM(B.CRDT_LMT_ID) IS NOT NULL
                       UNION
                       SELECT DISTINCT B.CRDT_LMT_ID AS LMT_CONT_ID, A.ORG_ID
                         FROM RRP_MDL.M_LOAN_LGLC_INFO A -- 保函与信用证信息表
                         LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO B -- 合同表
                           ON A.CONT_ID = B.CONT_ID
                          AND B.DATA_DT = V_P_DATE
                        WHERE A.DATA_DT = V_P_DATE
                          AND TRIM(B.CRDT_LMT_ID) IS NOT NULL) F) T2
      ON T5.CRDT_CONT_ID = T2.LMT_CONT_ID
     AND T2.CNT = 1 --同属一个分行
     AND T2.RN = 1 --取其中一个机构
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
      ON T3.ORG_ID = NVL(T2.ORG_ID,T5.ORG_ID_ORI)
     AND T3.DATA_DT = V_P_DATE
   INNER JOIN RRP_MDL.M_CUST_CORP_INFO T4 --对公客户信息
      ON T4.CUST_ID = T1.CUST_ID
     AND T4.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO T6 --汇率表
      ON T6.BASE_CUR = T5.CUR
     AND T6.CNV_CUR = 'CNY'
     AND T6.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T7 --客户表
      ON T5.CUST_ID = T7.CUST_ID
     AND T7.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT MAX(CNYE) AS CNYE
                     ,MAX(YYED) AS YYED
                     ,KHWYM
                 FROM M_ADD_DG_002_CREDIT
                WHERE DATA_DATE = V_P_DATE
                GROUP BY KHWYM) M --授信额度补录表
      ON M.KHWYM = T1.CUST_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_PROD_INFO S --标准产品信息
      ON S.PROD_ID = T5.CRDT_BIZ_TYP
     AND S.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   WHERE T5.DATA_DT = V_P_DATE
     AND T5.CRDT_STAT = 'Y';

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,ZHWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_CREDITLINE T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,ZHWYM
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
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/
   
   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
   
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_CREDITLINE;
/

