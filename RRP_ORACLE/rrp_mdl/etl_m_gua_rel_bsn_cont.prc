CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_GUA_REL_BSN_CONT(I_P_DATE IN INTEGER,
                                                   O_ERRCODE OUT VARCHAR2
                                                  )
  /**************************************************************************
  *  程序名称：ETL_M_GUA_REL_BSN_CONT
  *  功能描述：担保合同和业务合同对应关系表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_GUA_REL_BSN_CONT
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20221114  HULJ     增加数据重复校验
  *             3    20231012  HULJ     新增联合网贷担保关系逻辑
  *             4    20240704  LIP      调整被担保合同为业务合同，增加真实合同编号、被担保合同终止日期字段
  *             5    20240820  YJY      调整联合网贷部分的被担保合同终止日期，加工核销日期和京东业务部分
  *             6    20250217  YJY      新增对公联合网贷的判断
  *             7    20250604  YJY      微业贷产品取真实合同号，其他产品优先取借据号再取合同号
  *             8    20251120  YJY      新增203050100002-微众对公联合贷（微业贷4.0）产品
  *             9    20251225  YJY      一表通报送要求也要包含本年内失效的担保合同将前一天的担保合同与当前跑批日期的担保合同对比，
                                        没关联到的担保合同按照失效合同统计，其跑批日期定义为担保合同的失效日期
  ***********************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);             --任务名称
  V_PART_NAME VARCHAR2(100);             --分区名
  V_STEP      INTEGER := 0;              --处理步骤
  V_SQLCOUNT  INTEGER := 0; 	           --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100) := 'M_GUA_REL_BSN_CONT';     --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_GUA_REL_BSN_CONT'; --程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
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
  V_STEP := 2;
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
  V_STEP := 3;
  V_STEP_DESC := '插入担保合同与业务合同对应关系表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_REL_BSN_CONT
    (DATA_DT            --1数据日期
    ,LGL_REP_ID         --2法人编号
    ,BIZ_CONT_ID        --3业务合同号
    ,GUA_CONT_ID        --4担保合同号
    ,ORG_ID             --5机构编号
    ,GUA_STAT           --6担保状态
    ,GUA_REL_START_DT   --7担保关系开始日期
    ,GUA_REL_RLV_DT     --8担保关系解除日期
    ,DEPT_LINE          --9部门条线
    ,DATA_SRC           --10数据来源
    ,CONT_STAT          --11合同状态代码
    ,REAL_CONT_ID       --12真实合同编号 --ADD BY 20240705
    ,BIZ_ACT_END_DT     --13被担保合同终止日期 --ADD BY 20240709
    )
  WITH TMP1 AS (
  SELECT /*+ MATERIALIZE*/
         V_P_DATE                                  AS DATA_DT            --1数据日期
        ,T1.LP_ID                                  AS LGL_REP_ID         --2法人编号
        --,T1.LOAN_CONT_ID                           AS BIZ_CONT_ID        --3业务合同号
        ,COALESCE(T3.CONT_ID,T4.CONT_ID)           AS BIZ_CONT_ID        --3业务合同号 --MOD BY 20240705
        ,T1.GUAR_CONT_ID                           AS GUA_CONT_ID        --4担保合同号
        ,T2.DIRECTOR_ORG_ID                        AS ORG_ID             --5机构编号
        ,CASE WHEN T1.GUAR_CONT_STATUS_CD = '102' THEN '1'
              WHEN T1.GUAR_CONT_STATUS_CD = '103' THEN '2'
              ELSE '0'
          END                                      AS GUA_STAT           --6担保状态
        ,TO_CHAR(T1.GUAR_START_DT,'YYYYMMDD')      AS GUA_REL_START_DT   --7担保关系开始日期
        ,TO_CHAR(T1.GUAR_EXP_DT,'YYYYMMDD')        AS GUA_REL_RLV_DT     --8担保关系解除日期
        ,'800919'                                  AS DEPT_LINE          --9部门条线
        ,SUBSTR(T1.JOB_CD,0,4)                     AS DATA_SRC           --10数据来源
        ,COALESCE(COD1.TAR_VALUE_CODE,COD2.TAR_VALUE_CODE,'99') AS CONT_STAT --11合同状态代码
        ,T1.LOAN_CONT_ID                           AS REAL_CONT_ID       --12真实合同编号 --ADD BY 20240705
        ,CASE WHEN T3.CONT_ID IS NOT NULL AND T3.TERMNT_DT IN (TO_DATE('00010101','YYYYMMDD'),TO_DATE('20991231','YYYYMMDD'))
              THEN '99991231'
              WHEN T3.CONT_ID IS NOT NULL THEN TO_CHAR(T3.TERMNT_DT,'YYYYMMDD')
              WHEN T4.CONT_ID IS NOT NULL AND T4.TERMNT_DT IN (TO_DATE('00010101','YYYYMMDD'),TO_DATE('20991231','YYYYMMDD'))
              THEN '99991231'
              WHEN T4.CONT_ID IS NOT NULL THEN TO_CHAR(T4.TERMNT_DT,'YYYYMMDD')
          END                                      AS BIZ_ACT_END_DT     --13被担保合同终止日期
        ,ROW_NUMBER() OVER(PARTITION BY COALESCE(T3.CONT_ID,T4.CONT_ID),T1.GUAR_CONT_ID
                           ORDER BY T1.GUAR_CONT_STATUS_CD,T1.GUAR_START_DT,T1.GUAR_EXP_DT) RN
   FROM RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA T1 --贷款合同与担保合同关系
  INNER JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT T2 --担保合同
     ON T2.GUAR_CONT_ID = T1.GUAR_CONT_ID
    AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T5 --零售贷款业务合同
     ON T5.LMT_CONT_ID = T1.LOAN_CONT_ID
    AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款业务合同
     ON T4.CONT_ID = NVL(T5.CONT_ID,T1.LOAN_CONT_ID)
    AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T6 --对公贷款业务合同
     ON T6.LMT_CONT_ID = T1.LOAN_CONT_ID
    AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T3 --对公贷款业务合同
     ON T3.CONT_ID = NVL(T6.CONT_ID,T1.LOAN_CONT_ID)
    AND T3.CRDT_TYPE_CD = '02'
    AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.CODE_MAP COD1  --贷款合同状态转码 对公
     ON COD1.SRC_VALUE_CODE = T3.VALID_FLG_CD
    AND COD1.SRC_CLASS_CODE = 'CD2586'
    AND COD1.TAR_CLASS_CODE = 'D0117'
    AND COD1.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP COD2  --贷款合同状态转码 对公
     ON COD2.SRC_VALUE_CODE = T4.CONT_STATUS_CD
    AND COD2.SRC_CLASS_CODE = 'CD2586'
    AND COD2.TAR_CLASS_CODE = 'D0117'
    AND COD2.MOD_FLG = 'MDM'
  WHERE COALESCE(T3.CONT_ID,T4.CONT_ID) IS NOT NULL
    AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  --MOD BY 20240704 因需穿透到业务合同号，会有关系重复的数据，对重复数据去重
  SELECT DATA_DT            --1数据日期
        ,LGL_REP_ID         --2法人编号
        ,BIZ_CONT_ID        --3业务合同号
        ,GUA_CONT_ID        --4担保合同号
        ,ORG_ID             --5机构编号
        ,GUA_STAT           --6担保状态
        ,GUA_REL_START_DT   --7担保关系开始日期
        ,GUA_REL_RLV_DT     --8担保关系解除日期
        ,DEPT_LINE          --9部门条线
        ,DATA_SRC           --10数据来源
        ,CONT_STAT          --11合同状态代码
        ,REAL_CONT_ID       --12真实合同编号
        ,BIZ_ACT_END_DT     --13被担保合同终止日期 --ADD BY 20240709
    FROM TMP1
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 4;
  V_STEP_DESC := '插入担保合同与业务合同对应关系联合网贷部分数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_REL_BSN_CONT
    (DATA_DT            --1数据日期
    ,LGL_REP_ID         --2法人编号
    ,BIZ_CONT_ID        --3业务合同号
    ,GUA_CONT_ID        --4担保合同号
    ,ORG_ID             --5机构编号
    ,GUA_STAT           --6担保状态
    ,GUA_REL_START_DT   --7担保关系开始日期
    ,GUA_REL_RLV_DT     --8担保关系解除日期
    ,DEPT_LINE          --9部门条线
    ,DATA_SRC           --10数据来源
    ,CONT_STAT          --11合同状态代码
    ,REAL_CONT_ID       --12真实合同编号
    ,BIZ_ACT_END_DT     --13被担保合同终止日期 --ADD BY 20240709
    )
  SELECT V_P_DATE                                  AS DATA_DT            --1数据日期
        ,T1.LP_ID                                  AS LGL_REP_ID         --2法人编号
        /*,NVL(T41.DUBIL_ID,T4.CONT_ID)              AS BIZ_CONT_ID        --3业务合同号*/
        --MOD BY YJY 20250604 微业贷产品取真实合同号，其他产品优先取借据号再取合同号
        ,CASE WHEN T4.STD_PROD_ID IN ('203050100001','203050100002') --微业贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              THEN T4.CONT_ID
              ELSE NVL(T41.DUBIL_ID,T4.CONT_ID)
         END                                       AS BIZ_CONT_ID        --3业务合同号
        ,T1.GUAR_CONT_ID                           AS GUA_CONT_ID        --4担保合同号
        ,T2.RGST_ORG_ID                            AS ORG_ID             --5机构编号
        ,CASE WHEN T1.GUAR_CONT_STATUS_CD = '2' THEN '1'
              WHEN T1.GUAR_CONT_STATUS_CD = '1' THEN '2'
              ELSE '0'
          END                                      AS GUA_STAT           --6担保状态  与对公担保有出入
        ,TO_CHAR(T1.GUAR_EFFECT_DT,'YYYYMMDD')     AS GUA_REL_START_DT   --7担保关系开始日期
        ,TO_CHAR(T1.GUAR_EXP_DT,'YYYYMMDD')        AS GUA_REL_RLV_DT     --8担保关系解除日期
        ,'800919'                                  AS DEPT_LINE          --9部门条线
        ,CASE WHEN T4.STD_PROD_ID IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
		          THEN '对公联合网贷' --MOD BY YJY 20250217
			        ELSE '联合网贷' 
         END                                       AS DATA_SRC           --10数据来源
        ,NVL(T5.TAR_VALUE_CODE,'99')               AS CONT_STAT          --11合同状态代码
        ,T1.LOAN_CONT_ID                           AS REAL_CONT_ID       --12真实合同编号
        ,/*CASE WHEN T41.PAYOFF_DT IN (TO_DATE('00010101','YYYYMMDD'),TO_DATE('20991231','YYYYMMDD'))
              THEN '99991231'
              ELSE TO_CHAR(T41.PAYOFF_DT,'YYYYMMDD')
          END*/
		 --MOD BY YJY IN 20240820 参考表内借据对核销日期和京东的业务进行加工
         CASE WHEN TO_CHAR(HX.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101')
               AND HX.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TO_CHAR(HX.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
              WHEN TO_CHAR(T41.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               AND T41.STD_PROD_ID NOT IN ('202010100004') --京东
              THEN TO_CHAR(T41.PAYOFF_DT,'YYYYMMDD')
              WHEN NVL(T41.IN_BS_INT,0) + NVL(T41.CURRT_BAL,0) + NVL(T41.OFF_BS_INT,0) = 0 
         	   AND T41.LAST_REPAY_DT >= T41.DISTR_DT
               AND TO_CHAR(T41.LAST_REPAY_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               AND T41.STD_PROD_ID = '202010100004' --京东
              THEN TO_CHAR(T41.LAST_REPAY_DT,'YYYYMMDD')
              WHEN TO_CHAR(T41.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
              THEN TO_CHAR(T41.PAYOFF_DT,'YYYYMMDD')
              ELSE '99991231'
           END		  AS BIZ_ACT_END_DT     --13被担保合同终止日期
   FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA T1 --联合网贷贷款与担保合同关系
  INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO T2 --联合网贷担保合同信息
     ON T2.GUAR_CONT_ID = T1.GUAR_CONT_ID
    AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO T4 --联合网贷贷款合同信息
     ON T4.CONT_ID = T1.LOAN_CONT_ID
    AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  --MOD BY LIP 20231106 只取能关联到借据表的数据，张家伟确认：新一代前结清的可用排除
  INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T41 --联合网贷借据信息
     ON T41.CONT_ID = T4.CONT_ID
    AND T41.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO HX --联合网贷核销信息  --ADD BY YJY IN 20240820
     ON HX.DUBIL_ID = T41.DUBIL_ID
    AND HX.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.CODE_MAP T5  --贷款合同状态转码 联合网贷
     ON T5.SRC_VALUE_CODE = T4.CONT_STATUS_CD
    AND T5.SRC_CLASS_CODE = 'CD2586'
    AND T5.TAR_CLASS_CODE = 'D0117'
    AND T5.MOD_FLG = 'MDM'
  WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --IF V_P_DATE = TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD') THEN
    --ADD BY 20240229 插入当月内被删除的数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入前一天被删除的数据';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_GUA_REL_BSN_CONT
      (DATA_DT               --数据日期
      ,LGL_REP_ID            --法人编号
      ,BIZ_CONT_ID           --业务合同号
      ,GUA_CONT_ID           --担保合同号
      ,ORG_ID                --机构编号
      ,GUA_STAT              --担保状态
      ,GUA_REL_START_DT      --担保关系开始日期
      ,GUA_REL_RLV_DT        --担保关系解除日期
      ,DEPT_LINE             --部门条线
      ,DATA_SRC              --数据来源
      ,CONT_STAT             --业务合同状态
      ,REAL_CONT_ID          --真实合同编号
      ,BIZ_ACT_END_DT        --被担保合同终止日期
      ,GUA_REL_END_DT        --担保关系失效日期
      )
     WITH TMP1 AS (
     SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.BIZ_CONT_ID,T.GUA_CONT_ID ORDER BY T.DATA_DT DESC) RN
       FROM RRP_MDL.M_GUA_REL_BSN_CONT T
       LEFT JOIN RRP_MDL.M_GUA_REL_BSN_CONT TB
         ON TB.BIZ_CONT_ID = T.BIZ_CONT_ID
        AND TB.GUA_CONT_ID = T.GUA_CONT_ID
        AND TB.DATA_DT = V_P_DATE
      WHERE TB.BIZ_CONT_ID IS NULL
        AND (T.GUA_REL_END_DT IS NULL OR T.GUA_REL_END_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')) --上一天采集的有效数据或者当年内失效的数据
        AND T.DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD'))
    SELECT V_P_DATE                AS DATA_DT               --数据日期
          ,TA.LGL_REP_ID           AS LGL_REP_ID            --法人编号
          ,TA.BIZ_CONT_ID          AS BIZ_CONT_ID           --业务合同号
          ,TA.GUA_CONT_ID          AS GUA_CONT_ID           --担保合同号
          ,TA.ORG_ID               AS ORG_ID                --机构编号
          ,'2'                     AS GUA_STAT              --担保状态
          ,TA.GUA_REL_START_DT     AS GUA_REL_START_DT      --担保关系开始日期
          ,TA.DATA_DT              AS GUA_REL_RLV_DT        --担保关系解除日期
          ,TA.DEPT_LINE            AS DEPT_LINE             --部门条线
          ,TA.DATA_SRC             AS DATA_SRC              --数据来源
          ,TA.CONT_STAT            AS CONT_STAT             --业务合同状态
          ,TA.REAL_CONT_ID         AS REAL_CONT_ID          --真实合同编号
          ,TA.DATA_DT              AS BIZ_ACT_END_DT        --被担保合同终止日期 --ADD BY 20240709、
          ,CASE WHEN TA.GUA_REL_END_DT IS NOT NULL 
                THEN TA.GUA_REL_END_DT
                ELSE V_P_DATE
            END     			         AS GUA_CONT_END_DT      --担保关系失效日期  --ADD BY YJY 20251225
      FROM TMP1 TA
     WHERE TA.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 -- END IF;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
    SELECT DATA_DT,BIZ_CONT_ID,GUA_CONT_ID,COUNT(1)
      FROM RRP_MDL.M_GUA_REL_BSN_CONT T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,BIZ_CONT_ID,GUA_CONT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_GUA_REL_BSN_CONT;
/

