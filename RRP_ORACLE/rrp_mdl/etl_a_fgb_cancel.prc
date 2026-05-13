CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_CANCEL

(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_CANCEL
  *  功能描述：
  *  创建日期：20230306
  *  开发人员: 孙满洋
  *  来源表：
  *  目标表：A_FGB_CANCEL --核销台账
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20230306   孙满洋     首次创建
  *   2    20230508   liuyu      新增机构号字段
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_CANCEL';   -- 程序名称
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
  V_TAB_NAME := 'A_FGB_CANCEL'; --表名,写目标表表名
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

  ETL_PARTITION_ADD(V_P_DATE, 'A_FGB_CANCEL', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT INTO A_FGB_CANCEL
   (
    DATA_SRC               -- 1.数据来源
   ,BGRQ                   -- 2.数据日期
   ,HXXJLWYM               -- 3.核销现金流唯一码
   ,JYWYM                  -- 4.交易唯一码
   ,HXRQ                   -- 5.核销日期
   ,SFBNHX                 -- 6.是否本年核销
   ,BNYSHXJE               -- 7.本年原始核销金额（元）
   ,HXHSXRQ                -- 8.核销后收现日期
   ,HXDZHSHJE              -- 9.核销/抵债后收回金额（元）
   ,ZHWYM                  -- 10.账户唯一码
   ,KHWYM                  -- 11.客户编号
   ,KHMC                   -- 12.客户名称
   ,JGBH                   -- 13.机构编号
   )
    SELECT '资产保全台账'   AS DATA_SRC  -- 1.数据来源
          ,V_P_DATE         AS BGRQ      -- 2.数据日期
          ,A.SERIALNO/* || C.TRA_SEQ_NO*/
                            AS HXXJLWYM  -- 3.流水号
          ,A.DUEBILLID      AS JYWYM     -- 4.借据号
          ,TO_CHAR(A.HANDLETIME,'YYYYMMDD')
                            AS HXRQ      -- 5.处置（含重组）时间
          ,A.IS_THIS_YEAR   AS SFBNHX    -- 6.是否本年核销
          ,A.HANDLEBALANCE  AS BNYSHXJE  -- 7.本年原始核销金额（元）
          ,TO_CHAR(A.CASHOFFDATE,'YYYYMMDD')
                            AS HXHSXRQ   -- 8.核销后收现日期
          ,A.RECOVEROFFBALANCE
                            AS HXDZHSHJE -- 9.核销/抵债后收回金额（元）
          ,A.ACC_ID         AS ZHWYM     -- 10.账户唯一码
          ,A.CUSTOMERID     AS KHWYM     -- 11.客户编号
          ,A.CUSTOMERNAME   AS KHMC      -- 12.客户名称
          ,A.ORG_ID         AS JGBH      -- 13.机构编号
      FROM RRP_MDL.S_WRITE_OFF_LEDGER A -- 核销台账
      /*LEFT JOIN
           (SELECT DATA_DT,
                   RCPT_ID,
                   TRA_DT,
                   NORM_RETRV_AMT,
                   TRA_SEQ_NO
              FROM RRP_MDL.M_TRA_LOAN_DTL
             WHERE CALLBK_RS IN ('正常收回',
                           '提前还款（缩期）',
                           '提前还款（不缩期）',
                           '担保代偿',
                           '政策性还款',
                           '资产证券化转出',
                           '资产转让转出',
                           '借新还旧',
                           '诉讼追偿',
                           '破产清偿',
                           '委托处置',
                           '强制平仓',
                           '核销后收回',
                           '其他') -- 取荣炳华框定的回款方式
           )C --信贷账户交易流水
        ON C.RCPT_ID = A.DUEBILLID
       AND C.DATA_DT > TO_CHAR(A.HANDLETIME,'YYYYMMDD') --核销之后*/
     WHERE A.HANDLETYPE IN ('全额核销', '差额核销','呆账核销') -- mod by liuyu 旧生产有呆账核销码值，纳入取数
       AND A.DATA_DT = V_P_DATE
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
    SELECT BGRQ,HXXJLWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_CANCEL T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,HXXJLWYM
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

  END ETL_A_FGB_CANCEL;
/

