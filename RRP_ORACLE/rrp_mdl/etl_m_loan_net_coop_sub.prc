CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_NET_COOP_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
 **存储过程详细说明：互联网贷款合作协议表
 **存储过程名称：ETL_M_LOAN_NET_COOP_SUB
 **存储过程创建日期：2022-04-02
 **存储过程创建人：LIP
 ** 修改日期    修改人   修改内容
 ** 20231018    LIP      因均衡助贷有多个协议，增加子合作协议编号
 ** 20250319    LINAL    一表通，增加增信模式标志的取值逻辑。
 ** 20251110    LIP      调整成从信贷系统出数
 ** 20251202    LIP      增加是否属于主协议标识
 ** 20260116    LIP      过滤停用的数据
 ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;          --处理步骤
  V_P_DATE    VARCHAR2(8);           --跑批数据日期
  V_STARTTIME DATE;                  --处理开始时间
  V_ENDTIME   DATE;                  --处理结束时间
  V_SQLCOUNT  INTEGER := 0;          --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);         --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);         --分区名
  V_STEP_DESC VARCHAR2(200);         --任务名称
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_NET_COOP_SUB'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_LOAN_NET_COOP_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_NET_COOP_SUB T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理

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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序处理过程
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入互联网贷款合作协议表';
  V_STARTTIME := SYSDATE;
  /*INSERT INTO RRP_MDL.M_LOAN_NET_COOP_SUB
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,ORG_ID             --机构编号
    ,COOP_AGRT_ID       --合作协议编号
    ,PNR_NM             --合作方名称
    ,PNR_CRDL_TYP       --合作方证件类别
    ,PNR_CRDL_NO        --合作方证件号码
    ,PNR_TYP            --合作方类型
    ,COOP_MODE          --合作方式
    ,PNR_FND_PCT        --合作方出资比例
    ,AGRT_START_DT      --协议起始日期
    ,AGRT_EXP_DT        --协议到期日期
    ,ACT_END_DT         --实际终止日期
    ,PNR_REGD_LAND_CD   --合作方注册地代码
    ,RST_FLG            --限制标志
    ,AGRT_STAT          --协议状态
    ,COOP_PROD          --合作产品
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    ,SUB_COOP_AGRT_ID   --合作协议编号 --ADD BY LIP 20231018
    ,INCRE_CRDT_MODE_CD --增信模式标志 --ADD 20250319 LINAILIAN
    )
  SELECT V_P_DATE                               AS DATA_DT            --数据日期
        ,'9999'                                 AS LGL_REP_ID         --法人编号
        ,NVL(T.ORG_ID1,TA.ORG_ID)               AS ORG_ID             --机构编号
        ,TA.COOP_AGRT_ID                        AS COOP_AGRT_ID       --合作协议编号
        ,TA.PNR_NM                              AS PNR_NM             --合作方名称
        ,TA.PNR_CRDL_TYP                        AS PNR_CRDL_TYP       --合作方证件类别
        ,TA.PNR_CRDL_NO                         AS PNR_CRDL_NO        --合作方证件号码
        ,TA.PNR_TYP                             AS PNR_TYP            --合作方类型
        ,TA.COOP_MODE                           AS COOP_MODE          --合作方式
        ,TA.PNR_FND_PCT                         AS PNR_FND_PCT        --合作方出资比例
        ,TA.AGRT_START_DT                       AS AGRT_START_DT      --协议起始日期
        ,TA.AGRT_EXP_DT                         AS AGRT_EXP_DT        --协议到期日期
        ,TA.ACT_END_DT                          AS ACT_END_DT         --实际终止日期
        ,TA.PNR_REGD_LAND_CD                    AS PNR_REGD_LAND_CD   --合作方注册地代码
        ,TA.RST_FLG                             AS RST_FLG            --限制标志
        ,CASE WHEN TA.ACT_END_DT <= V_P_DATE THEN '01'
              ELSE TA.AGRT_STAT
          END                                   AS AGRT_STAT          --协议状态
        ,TA.COOP_PROD                           AS COOP_PROD          --合作产品
        ,TA.DEPT_LINE                           AS DEPT_LINE          --部门条线
        ,TA.DATA_SRC                            AS DATA_SRC           --数据来源
        ,TA.SUB_COOP_AGRT_ID                    AS SUB_COOP_AGRT_ID   --合作协议编号 --ADD BY LIP 20231018
        ,NULL                                   AS INCRE_CRDT_MODE_CD --增信模式标志 --ADD 20250319 LINAILIAN 先置空，后续在O_ICL_CMM_RETL_LOAN_CONT_INFO取值
    FROM RRP_MDL.ADD_LOAN_NET_COOP_SUB TA --互联网贷款合作协议表配置表
    LEFT JOIN RRP_MDL.ORG_CONFIG T
      ON T.ORG_ID = TA.ORG_ID
   WHERE (TA.AGRT_START_DT <= V_P_DATE OR TA.AGRT_START_DT = '99991231');*/
  INSERT INTO RRP_MDL.M_LOAN_NET_COOP_SUB
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,ORG_ID             --机构编号
    ,COOP_AGRT_ID       --合作协议编号
    ,PNR_NM             --合作方名称
    ,PNR_CRDL_TYP       --合作方证件类别
    ,PNR_CRDL_NO        --合作方证件号码
    ,PNR_TYP            --合作方类型
    ,COOP_MODE          --合作方式
    ,PNR_FND_PCT        --对我行出资部分进行担保的比例
    ,AGRT_START_DT      --协议起始日期
    ,AGRT_EXP_DT        --协议到期日期
    ,ACT_END_DT         --实际终止日期
    ,PNR_REGD_LAND_CD   --合作方注册地代码
    ,RST_FLG            --限制标志
    ,AGRT_STAT          --协议状态
    ,COOP_PROD          --合作产品
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    ,COOP_PROD_NM       --合作产品名称
    ,NET_FLG            --重点互联网平台标志
    ,SUB_COOP_AGRT_ID   --合作协议编号 --ADD BY LIP 20231018
    ,INCRE_CRDT_MODE_CD --增信模式标志 --ADD 20250319 LINAILIAN
    ,ISMAINAGREEMENT    --是否属于主协议 --ADD BY LIP 20251202
    )
   WITH ORG_INFO AS (
  SELECT T.ORG_NAME,T.ORG_ID,ROW_NUMBER() OVER(PARTITION BY T.ORG_NAME ORDER BY T.ORG_ID) RN
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                              AS DATA_DT            --数据日期
        ,'9999'                                                                AS LGL_REP_ID         --法人编号
        ,T2.ORG_ID                                                             AS ORG_ID             --机构编号
        ,T1.MAINAGREEMENTNO                                                    AS COOP_AGRT_ID       --合作协议编号
        ,REGEXP_REPLACE(TRIM(T1.COOPERATENAME),'[[:space:]"]','')              AS PNR_NM             --合作方名称
        ,TRIM(T1.COOPERATECERTTYPE)                                            AS PNR_CRDL_TYP       --合作方证件类别
        ,REGEXP_REPLACE(TRIM(T1.COOPERATECERTID),'[[:space:]"]','')            AS PNR_CRDL_NO        --合作方证件号码
        ,T1.COOPERATETYPE                                                      AS PNR_TYP            --合作方类型
        ,REPLACE(T1.COOPERATEMETHOD,',',';')                                   AS COOP_MODE          --合作方式
        ,T1.INVESTMENTPROP                                                     AS PNR_FND_PCT        --对我行出资部分进行担保的比例
        ,TO_CHAR(TO_DATE(TRIM(T1.STARTDATE),'YYYY/MM/DD'),'YYYYMMDD')          AS AGRT_START_DT      --协议起始日期
        ,TO_CHAR(TO_DATE(TRIM(T1.MATURITYDATE),'YYYY/MM/DD'),'YYYYMMDD')       AS AGRT_EXP_DT        --协议到期日期
        ,TO_CHAR(TO_DATE(TRIM(T1.ACTUALMATURITYDATE),'YYYY/MM/DD'),'YYYYMMDD') AS ACT_END_DT         --实际终止日期
        ,REGEXP_REPLACE(T1.COOPERATEREGISTERADDRESS,'[[:space:]"]','')         AS PNR_REGD_LAND_CD   --合作方注册地代码
        ,T1.LIMITFLAG                                                          AS RST_FLG            --限制标志
        ,T1.COOPERATESTATUS                                                    AS AGRT_STAT          --协议状态
        ,TRIM(T1.PRODUCTID)                                                    AS COOP_PROD          --合作产品
        ,NULL                                                                  AS DEPT_LINE          --部门条线
        ,'ICMS'                                                                AS DATA_SRC           --数据来源
        ,TRIM(T1.PRODUCTNAME)                                                  AS COOP_PROD_NM       --合作产品名称
        ,NULL                                                                  AS NET_FLG            --重点互联网平台标志
        ,TRIM(T1.AGREEMENTNO)                                                  AS SUB_COOP_AGRT_ID   --合作协议编号
        ,TRIM(T1.PROVIDECREDITMODEL)                                           AS INCRE_CRDT_MODE_CD --增信模式标志
        ,TRIM(T1.ISMAINAGREEMENT)                                              AS ISMAINAGREEMENT    --是否属于主协议 --ADD BY LIP 20251202
    FROM RRP_MDL.O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO T1 --互联网贷款产品合作协议信息表
    LEFT JOIN ORG_INFO T2
      ON T2.ORG_NAME = REGEXP_REPLACE(T1.BELONGORGID,'[[:space:]]','')
     AND T2.RN = 1
   WHERE NVL(T1.DATASTATUS,'01') = '01' --01有效 02停用 --ADD BY LIP 20260116 过滤停用的数据
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,SUB_COOP_AGRT_ID,PNR_CRDL_TYP,PNR_CRDL_NO,COUNT(1)
    FROM RRP_MDL.M_LOAN_NET_COOP_SUB T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,SUB_COOP_AGRT_ID,PNR_CRDL_TYP,PNR_CRDL_NO
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_SQLMSG  := '数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;

  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
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

END ETL_M_LOAN_NET_COOP_SUB;
/

