CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_105_JGGXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：机构关系表
  **  存储过程名称:  ETL_EAST5_105_JGGXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  调用方法:
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期    修改人     修改原因
  **  20220527    蔡正伟     修改全行000000机构上级机构代码取值逻辑
  **  20220628    LIP        修改日志记录格式，修改字段超长、字段换行问题
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := '1';   --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_105_JGGXB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_105_JGGXB'; --存储过程名称
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    /*增加分区*/
    V_STEP := 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入机构关系表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_105_JGGXB(
      RID,        --数据主键
      YHJGDM,     --银行机构代码
      JRXKZH,     --金融许可证号
      NBJGH,      --内部机构号
      YHJGMC,     --银行机构名称
      SJGLJGDM,   --上级管理机构代码
      SJGLNBJGH,  --上级管理内部机构号
      SJGLJGMC,   --上级管理机构名称
      BBZ,        --备注
      CJRQ,       --采集日期
      DEPT_NO,    --部门编号
      SRC_SYS_ID, --来源系统ID
      ISSUED_NO,  --填报机构
      ORG_NO,     --报送机构
      ADDRESS,    --归属地
      GSFZJG      --归属分支机构
      )
    SELECT SYS_GUID()                                                     AS RID,        --数据主键
           TRIM(A.PBC_NO)                                                 AS YHJGDM,     --银行机构代码
           TRIM(A.FIN_PERMIT_NO)                                          AS JRXKZH,     --金融许可证号
           A.ORG_ID                                                       AS NBJGH,      --内部机构号
           A.ORG_NM                                                       AS YHJGMC,     --银行机构名称
           /*--MODIFY BY CAIZHENGWEI 20220527 修改全行上级机构取值逻辑 BEGIN
           TRIM(DECODE(A.ORG_ID,'000000','0',B.PBC_NO))                   AS SJGLJGDM,   --上级管理机构代码
           DECODE(A.ORG_ID,'000000','0',B.ORG_ID)                         AS SJGLNBJGH,  --上级管理内部机构号
           DECODE(A.ORG_ID,'000000','广东华兴银行股份有限公司',B.ORG_NM)  AS SJGLJGMC,   --上级管理机构名称
           --MODIFY BY CAIZHENGWEI 20220527 修改全行上级机构取值逻辑 END*/
           --MODIFY BY TANGAN 20221222 处理上级机构为902结尾的机构 BEGIN
           /*CASE WHEN A.ORG_ID = '000000' THEN '0'
                WHEN A.UP_ORG_ID LIKE '%902' THEN C.PBC_NO
                ELSE B.PBC_NO
            END                                                           AS SJGLJGDM,   --上级管理机构代码
           CASE WHEN A.ORG_ID = '000000' THEN '0'
                WHEN A.UP_ORG_ID LIKE '%902' THEN C.ORG_ID
                ELSE B.ORG_ID
            END                                                           AS SJGLNBJGH,  --上级管理内部机构号
           CASE WHEN A.ORG_ID = '000000' THEN '广东华兴银行股份有限公司'
                WHEN A.UP_ORG_ID LIKE '%902' THEN C.ORG_NM
                ELSE B.ORG_NM
            END                                                           AS SJGLJGMC,   --上级管理机构名称*/
           CASE WHEN A.UP_ORG_ID = '0' OR A.ORG_ID = '000000' THEN '0'
                WHEN A.UP_ORG_ID LIKE '%902' THEN C.PBC_NO
                ELSE B.PBC_NO
            END                                                           AS SJGLJGDM,   --上级管理机构代码
           CASE WHEN A.UP_ORG_ID = '0' OR A.ORG_ID = '000000' THEN '0'
                WHEN A.UP_ORG_ID LIKE '%902' THEN C.ORG_ID
                ELSE A.UP_ORG_ID
            END                                                           AS SJGLNBJGH,  --上级管理内部机构号
           CASE WHEN A.UP_ORG_ID = '0' OR A.ORG_ID = '000000' THEN '广东华兴银行股份有限公司'
                WHEN A.UP_ORG_ID LIKE '%902' THEN C.ORG_NM
                ELSE B.ORG_NM
            END                                                           AS SJGLJGMC,   --上级管理机构名称
           ''                                                             AS BBZ,        --备注
           V_MONTH_END_DATEID                                             AS CJRQ,       --采集日期
           '000'                                                          AS DEPT_NO,    --部门编号
           '01'                                                           AS SRC_SYS_ID, --来源系统ID
           '000000'                                                       AS ISSUED_NO,  --填报机构
           ORG.ORG_ID_LEL_0                                               AS ORG_NO,     --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                           AS ADDRESS,    --归属地
           '9999'                                                         AS GSFZJG      --归属分支机构
      FROM RRP_MDL.M_PUM_ORG_INFO_EAST A --机构表
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = A.UP_ORG_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表 --处理上级机构为902结尾的机构 MODIFY BY TANGAN AT 20221222
        ON C.ORG_ID = B.UP_ORG_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.ORG_ID NOT LIKE '%902' --20221107 LHQ 过滤902结尾的机构号
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,NBJGH,COUNT(1)
      FROM RRP_EAST.EAST5_105_JGGXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,NBJGH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_ENDTIME := SYSDATE;
       V_SQLMSG  := 'EAST5_105_JGGXB(CJRQ,NBJGH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  V_STEP    := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_105_JGGXB;
/

