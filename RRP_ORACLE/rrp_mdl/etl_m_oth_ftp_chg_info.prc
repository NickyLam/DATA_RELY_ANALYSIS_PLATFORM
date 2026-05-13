CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_OTH_FTP_CHG_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_OTH_FTP_CHG_INFO
  *  功能描述：监管集市银行机构内设立的所有岗位的相关信息，包括核心系统中的所有岗位信息。
  *  创建日期：20220519
  *  开发人员：hulijuan
  *  来源表：  IOL.FTPS_RPT_RST_FTP261_INFO  --FTP账户明细结果集
  *
  *  目标表：  M_OTH_FTP_CHG_INFO  --FTP定价变动明细信息表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   EAST5校验规则调整，同步进行程序修改。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;              --处理步骤
  V_STEP_DESC VARCHAR2(100);             --处理步骤描述
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLCOUNT  INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);             --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_OTH_FTP_CHG_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_OTH_FTP_CHG_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'FTP定价变动明细信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_OTH_FTP_CHG_INFO
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,FTP_BIZ_TYP  --FTP业务类型
    ,TERM_TYP     --期限类型
    ,CHG_DT       --变动日期
    ,FTP_PRC      --FTP价格
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    )
  SELECT V_P_DATE                               AS DATA_DT         --数据日期
        ,'9999'                                 AS LGL_REP_ID      --法人编号
        ,'000000'                               AS ORG_ID          --机构编号
        ,A.FTP_BUS_TYPE                         AS FTP_BIZ_TYP     --FTP业务类型
        ,A.TERM_TYPE_CD                         AS TERM_TYP        --期限类型
        ,TO_CHAR(A.CHA_DATE,'YYYYMMDD')         AS CHG_DT          --变动日期
        ,A.FTP_RATE                             AS FTP_PRC         --FTP价格
        ,NULL                                   AS DEPT_LINE       --部门条线
        ,'FTPS'                                 AS DATA_SRC        --数据来源
    FROM RRP_MDL.O_IOL_FTPS_RPT_RST_FTP261_INFO A  --FTP账户明细结果集
   WHERE A.DATA_DATE = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
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

END ETL_M_OTH_FTP_CHG_INFO;
/

