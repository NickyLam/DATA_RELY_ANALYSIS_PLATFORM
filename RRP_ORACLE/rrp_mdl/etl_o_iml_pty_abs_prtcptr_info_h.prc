CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PTY_ABS_PRTCPTR_INFO_H(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_IML_PTY_ABS_PRTCPTR_INFO_H
  *  功能描述：资产证券化参与方信息历史
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_IML_PTY_ABS_PRTCPTR_INFO_H
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_PTY_ABS_PRTCPTR_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_PTY_ABS_PRTCPTR_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_PTY_ABS_PRTCPTR_INFO_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PTY_ABS_PRTCPTR_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资产证券化参与方信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_PTY_ABS_PRTCPTR_INFO_H
    (  PARTY_ID			    --当事人编号
      ,LP_ID			      --法人编号
      ,PRTCPTR_ID			  --
      ,PRTCPTR_NAME			--
      ,PRTCPTR_TYPE_CD	--参与方类型代码
      ,ACCT_ID			    --账户编号
      ,ACCT_NAME			  --账户名称
      ,OPEN_BANK_NO			--开户行行号
      ,BIGAMT_BANK_NO		--
      ,BIGAMT_BANK_NAME	--
      ,RELA_PS_NAME			--关联人姓名
      ,TEL_NUM			    --电话号码
      ,RGST_EMPLY_ID		--
      ,RGST_ORG_ID			--登记机构编号
      ,RGST_DT			    --登记日期
      ,MODIF_EMPLY_ID		--修改员工编号
      ,MODIF_ORG_ID			--修改机构编号
      ,MODIF_DT			    --修改日期
      ,TS_FLG			      --暂存标志
      ,START_DT			    --起始日期
      ,END_DT			      --截止日期
      ,ID_MARK			    --增删标志
      ,SRC_TABLE_NAME		--源表名称
      ,JOB_CD			      --任务代码
    )
  SELECT 
       PARTY_ID			    --当事人编号
      ,LP_ID			      --法人编号
      ,PRTCPTR_ID			  --
      ,PRTCPTR_NAME			--
      ,PRTCPTR_TYPE_CD	--参与方类型代码
      ,ACCT_ID			    --账户编号
      ,ACCT_NAME			  --账户名称
      ,OPEN_BANK_NO			--开户行行号
      ,BIGAMT_BANK_NO		--
      ,BIGAMT_BANK_NAME	--
      ,RELA_PS_NAME			--关联人姓名
      ,TEL_NUM			    --电话号码
      ,RGST_EMPLY_ID		--
      ,RGST_ORG_ID			--登记机构编号
      ,RGST_DT			    --登记日期
      ,MODIF_EMPLY_ID		--修改员工编号
      ,MODIF_ORG_ID			--修改机构编号
      ,MODIF_DT			    --修改日期
      ,TS_FLG			      --暂存标志
      ,START_DT			    --起始日期
      ,END_DT			      --截止日期
      ,ID_MARK			    --增删标志
      ,SRC_TABLE_NAME		--源表名称
      ,JOB_CD			      --任务代码
    FROM IML.V_PTY_ABS_PRTCPTR_INFO_H  --资产证券化参与方信息历史
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_PTY_ABS_PRTCPTR_INFO_H;
/

