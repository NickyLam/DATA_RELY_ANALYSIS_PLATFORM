CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_ONL_BANK_TRAN_DTL(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_ONL_BANK_TRAN_DTL
  *  功能描述：网上银行转账与交易明细
  *  创建日期：20221207
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_IML_EVT_ONL_BANK_TRAN_DTL 网上银行转账明细
             RRP_MDL.O_IML_EVT_ONL_BANK_TRAN_FLOW  网上银行交易流水
  *  目标表：RRP_MDL.M_MRPT_ONL_BANK_TRAN_DTL  网上银行转账与交易明细表
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221207  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_ONL_BANK_TRAN_DTL'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_SQL         VARCHAR2(2000); -- 动态sql
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_MRPT_ONL_BANK_TRAN_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_SQL :='TRUNCATE TABLE RRP_MDL.TMP_ONL_BANK_TRAN_FLOW';
  EXECUTE IMMEDIATE V_SQL;

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入网上银行交易正常流水临时表';
  D_STARTTIME := SYSDATE;

   INSERT INTO RRP_MDL.TMP_ONL_BANK_TRAN_FLOW  --网上银行交易正常流水临时表
     SELECT FLOW_NUM
       FROM RRP_MDL.O_IML_EVT_ONL_BANK_TRAN_FLOW
      WHERE ONL_BANK_TRAN_STATUS_CD = '90'
        AND ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      GROUP BY FLOW_NUM;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入网上银行交易正常流水临时表';
  D_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_MRPT_ONL_BANK_TRAN_DTL
  (
		DATA_DT, 					--数据日期
		FLOW_NUM,                   --流水号
		TRAN_MOBILE_NO,             --转账手机号码
		TRAN_DT,                    --交易日期
		TRAN_AMT                    --交易金额
  )
  SELECT /*+USE_HASH(A B) LEADING(A)*/
         V_P_DATE,
         A.ONL_BANK_TRAN_FLOW_NUM,
         A.TRAN_MOBILE_NO,
         A.TRAN_DT,
         A.TRAN_AMT
  FROM RRP_MDL.O_IML_EVT_ONL_BANK_TRAN_DTL A
  INNER JOIN RRP_MDL.TMP_ONL_BANK_TRAN_FLOW B
  ON A.ONL_BANK_TRAN_FLOW_NUM = B.FLOW
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND TRIM(A.TRAN_MOBILE_NO) IS NOT NULL;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    D_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_ONL_BANK_TRAN_DTL;
/

