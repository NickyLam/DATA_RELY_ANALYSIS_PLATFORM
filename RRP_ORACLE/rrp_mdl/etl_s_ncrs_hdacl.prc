CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_NCRS_HDACL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_NCRS_HDACL
  *  功能描述：向二代征信提供金数关于对公贷款科技、乡村、普惠、绿色、养老等标识
  *  创建日期：20260319
  *  开发人员：YJY
  *  来源表：
  *  目标表：  S_NCRS_HDACL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20260319  YJY      首次创建
  ***********************************************************************************************************/
AS
  --定义变量
  V_STEP             INTEGER := 0;               --处理步骤
  V_P_DATE           VARCHAR2(8);                --跑批数据日期
  V_S_DATE           VARCHAR2(10);               --跑批数据日期 YYYY-MM-DD
  V_YEAR_START_DATE  VARCHAR2(8);                --系统时间对应年初日期  --ADD BY PSF 20250916
  V_STARTTIME        DATE;                       --处理开始时间
  V_ENDTIME          DATE;                       --处理结束时间
  V_SQLCOUNT         INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(200);              --任务名称
  V_PART_NAME        VARCHAR2(100);              --分区名
  V_TAB_NAME         VARCHAR2(100) := 'S_NCRS_HDACL'; --表名
  V_PROC_NAME        VARCHAR2(30) := 'ETL_S_NCRS_HDACL'; --程序名称
  V_SYSTEM           VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE    := I_P_DATE; --获取跑批日期
  V_S_DATE    := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD'); --获取跑批日期
  V_YEAR_START_DATE := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD'); --年初
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
 
  -- 程序业务逻辑处理主体部分 --
  V_STEP :=  V_STEP + 1; 
  V_STEP_DESC := '插入目标表';
  V_STARTTIME := SYSDATE;
   INSERT INTO S_NCRS_HDACL NOLOGGING
    (
           DATA_DT           --数据日期
          ,RCPT_ID           --借据编号 
          ,KJDK_FLG          --科技金融领域贷款标识 
          ,XCDK_FLG          --乡村振兴领域贷款标识        
          ,PHDK_FLG          --普惠金融领域贷款标识        
          ,LSDK_FLG          --绿色金融领域贷款标识        
          ,YLDK_FLG          --养老金融领域贷款标识        
          ,BH_FLAG           --白户标识        
    )
  SELECT  A.DATA_DT     --数据日期
         ,A.RCPT_ID     --借据编号 
         ,CASE WHEN B.LOAN_NO IS NOT NULL THEN '科技' ELSE '' END  AS  KJDK_FLG    --科技金融领域贷款标识    
         ,CASE WHEN C.LOAN_NO IS NOT NULL THEN '乡村' ELSE '' END  AS  XCDK_FLG    --乡村振兴领域贷款标识      
         ,CASE WHEN D.LOAN_NO IS NOT NULL THEN '普惠' ELSE '' END  AS  PHDK_FLG    --普惠金融领域贷款标识  
         ,CASE WHEN E.LOAN_NO IS NOT NULL THEN '绿色' ELSE '' END  AS  LSDK_FLG    --绿色金融领域贷款标识   
         ,CASE WHEN F.LOAN_NO IS NOT NULL THEN '养老' ELSE '' END  AS  YLDK_FLG    --养老金融领域贷款标识 
         ,CASE WHEN A.FST_LOAN_FLG = 'Y' THEN '白户' ELSE '' END   AS  BH_FLAG     --白户标识  
  FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A 
  LEFT JOIN RRP_BFD.BFD_201_HDACLKJDK  B --科技金融领域贷款
    ON A.RCPT_ID = B.LOAN_NO 
   AND B.DATA_DT = V_S_DATE
  LEFT JOIN RRP_BFD.BFD_201_CLZXEP  C  --乡村振兴领域贷款
    ON A.RCPT_ID = C.LOAN_NO 
   AND C.DATA_DT = V_S_DATE
  LEFT JOIN RRP_BFD.BFD_201_HDACLPHDK  D  --普惠金融领域贷款
    ON A.RCPT_ID =D.LOAN_NO 
   AND D.DATA_DT = V_S_DATE
  LEFT JOIN RRP_BFD.BFD_201_HDACLLSDK  E  --绿色金融领域贷款
    ON A.RCPT_ID =E.LOAN_NO 
   AND E.DATA_DT = V_S_DATE
  LEFT JOIN RRP_BFD.BFD_201_HDACLYLDK  F  --养老金融领域贷款
    ON A.RCPT_ID =F.LOAN_NO 
   AND F.DATA_DT = V_S_DATE
 WHERE A.DATA_DT = V_P_DATE
   AND DATA_SRC IN ('对公联合网贷','票据贴现','对公信贷')
   AND DISTR_DT >= V_YEAR_START_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  --如需要分析表，请用如下代码 --
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
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

END ETL_S_NCRS_HDACL;
/

