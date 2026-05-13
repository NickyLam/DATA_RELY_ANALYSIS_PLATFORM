CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_G13_BASE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_G13_BASE
  *  功能描述：买入反售业务表（G13报表使用）
  *  创建日期：20230130
  *  开发人员：卢伟博
  *  来源表：
  *
  *  目标表：  S_G13_BASE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230130  卢伟博    新建
  *             2    20230209  卢伟博    新增G13基表担保方式，表内外标识，五级分类，数据来源等字段
                3    20230220  卢伟博    调整‘我行确认价值-他行设定担保权金额’<0的逻辑判断
                4    20240423  卢伟博    调整分配初评我行押品价值及分配押品价值字段的逻辑
			        	5    20251013  YJY       押品重构需求，调整数据取数来源
  *********************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_G13_BASE'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'S_G13_BASE'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_G13_BASE T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_G13_BASE'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


   /*  分配比例说明：计算方式：
      ((我行确认价值*汇率 - 他行设定担保权金额） *(借款余额*汇率)/对应借据余额) --》 我行确认价值
      ((初评我行确认价值 * 汇率 - 他行设定担保权金额）*(借款余额*汇率)/对应借据余额） --》 初评我行确认价值
      (借据余额 * 汇率) * ((((我行确认价值*汇率 - coalesce(押品-他行设定担保权汇总金额,0))*(借据余额*汇率)/押品对应借据余额))/对应押品价值余额)  --> 分配价值*/
  -- 程序业务逻辑处理主体部分 --
  /*V_STEP := 3;
  V_STEP_DESC := '加工分配价值';
  V_STARTTIME := SYSDATE;
  INSERT  INTO S_G13_BASE NOLOGGING
  (   DATA_DT,--数据日期
      SCCODE,--押品编号
      CREDNO,--借据号
      GUARTYPE,--押品类型
      G13_GUR_NAME,--押品类型名称
      LOAN_BAL,--借据余额
      ESTIM_VAL,--我行确认价值
      HXB_PA_CFM_VAL,--初评我行确认价值
      LOAN_NET_VAL,--贷款净值
      OBANK_SET_SEC_RIGHT_AMT,--他行设定担保权金额
      DISTVALUE_YP,--贷款分配价值（押品系统）
      CONFMAMT_YP,--分配我行确认价值(押品系统)
      FIRSTCONFMAMT_YP,--分配初评我行确认价值(押品系统)
      DISTVALUE,--贷款分配价值
      CONFMAMT,--分配我行确认价值
      FIRSTCONFMAMT,--分配初评我行确认价值
      GUA_TYPE,--担保方式
      BALANCE_TYPE,--表内外标识
      LVL5_CL,--五级分类
      DATA_SRC,--数据来源
      GUARTYPE_NAME--押品类型名称
  )
  WITH TMP AS (SELECT
           a.SCCODE,  --押品编号,
           A.CREDNO,   --  借据号 ,
           A.GUARTYPE,--押品类型
           G.NAME,--G13押品类型名称
           NVL(D.LOAN_BAL*E.EXRT,A.BAL) AS BAL, --借据余额,
           A.DISTVALUE, --贷款分配价值,
           A.CONFMAMT, --分配我行确认价值,
           A.FIRSTCONFMAMT, --分配初评我行确认价值,
           b.ASES_VAL*F.EXRT AS ESTIM_VAL , --我行确认价值,
           CASE WHEN (A.SCCODE LIKE '%ZCC%' OR
                               A.SCCODE LIKE '%-BZJYP%') THEN
                           B.INIT_VALT*F.EXRT
                          ELSE
                           I.CONFMAMT * NVL(J.EXRT,F.EXRT)--YP_SECURITYINFOVLAUECOUNT表会存在币种为空情况，目前已通知押品系统修复
                        END AS HXB_PA_CFM_VAL,--初评我行确认价值
           NVL(B.OBANK_SET_SEC_RIGHT_AMT,0) AS OBANK_SET_SEC_RIGHT_AMT, --他行设定担保权金额,
           NVL(D.LOAN_NET_VAL*E.EXRT,A.BAL) AS LOAN_NET_VAL,--贷款净值
           SUM(NVL(D.LOAN_NET_VAL*E.EXRT,A.BAL))OVER(PARTITION BY A.SCCODE ORDER BY A.SCCODE ) AS LOAN_SUM_BAL,--贷款总额,
           SUM(B.ASES_VAL*F.EXRT-NVL(B.OBANK_SET_SEC_RIGHT_AMT,0)) OVER(PARTITION BY A.CREDNO ORDER BY A.CREDNO ) AS COL_SUM_BAL,--押品总额
                 DECODE(D.TJDBFS,'DZY','抵质押','BZ','保证','XY','信用')   AS GUA_TYPE,
           CASE WHEN  D.RCPT_ID IS NOT NULL THEN '表内'
                       ELSE '表外' END AS BALANCE_TYPE,--表内外标识
             D.LVL5_CL, --五级分类
             D.DATA_SRC, --数据来源
             H.SRC_VALUE_NAME--押品类型名称
 FROM RRP_MDL.S_MIMS_YP_GUARDSITRIBUTEFORJOUR  A--G13缓释表
 LEFT join rrp_mdl.M_GUA_COLL_INFO B--押品价值表
  on a.SCCODE=b.COLL_ID
  and b.DATA_DT=V_P_DATE
  LEFT JOIN RRP_MDL.S_LOAN D--监管报送贷款基表（表内借据）
    ON A.CREDNO=D.RCPT_ID
   AND D.DATA_DT=V_P_DATE
   LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO E
   ON E.BASE_CUR=D.CUR
   AND E.CNV_CUR='CNY'
   AND E.DATA_DT=V_P_DATE
   LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO F
   ON F.BASE_CUR=B.CUR
   AND F.CNV_CUR='CNY'
   AND F.DATA_DT=V_P_DATE
   LEFT JOIN RRP_MDL.O_IOL_MIMS_YP_G13RELATION G--G13关系映射表
    ON A.GUARTYPE=G.GUARTYPE
   AND G.GUARTYPE<>'ZY0304001'
   AND G.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP H
    ON H.SRC_CLASS_CODE='CD1244'
   AND H.MOD_FLG='MDM'
   AND H.TAR_CLASS_CODE = 'T0008'
   AND H.SRC_VALUE_CODE=A.GUARTYPE
    LEFT JOIN (SELECT SCCODE, CONFMAMT, CONFMCURRENCY
                      FROM (SELECT SCCODE,
                                   CONFMAMT,
                                   CONFMCURRENCY,
                                   ROW_NUMBER() OVER(PARTITION BY SV.SCCODE ORDER BY SV.BUSOVETIME ASC) NUMM
                              FROM RRP_MDL.S_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT SV--全量表
                             WHERE SV.STATE = '02'
                                 AND SV.DATA_DT=V_P_DATE)
                     WHERE NUMM = 1)I
      ON I.SCCODE=A.SCCODE
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J
      ON J.BASE_CUR=I.CONFMCURRENCY
     AND J.CNV_CUR='CNY'
     AND J.DATA_DT=V_P_DATE
WHERE  A.DATA_DT=V_P_DATE
        AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        AND SUBSTR(A.DATECODE,1,6)=SUBSTR(V_P_DATE,1,6)
  )
  SELECT V_P_DATE AS DATA_DT,
         SCCODE  AS SCCODE,--押品编号,
         CREDNO  AS CREDNO,--借据号,
         GUARTYPE AS GUARTYPE,--押品类型,
         NAME  AS G13_GUR_NAME,--押品类型名称,
         BAL   AS LOAN_BAL,--借据余额,
         ESTIM_VAL AS ESTIM_VAL,--我行确认价值,
         HXB_PA_CFM_VAL AS HXB_PA_CFM_VAL,--初评我行确认价值,
         LOAN_NET_VAL AS LOAN_NET_VAL,--贷款净值,
         OBANK_SET_SEC_RIGHT_AMT AS OBANK_SET_SEC_RIGHT_AMT,--他行设定担保权金额,
         DISTVALUE AS DISTVALUE_YP,--"贷款分配价值(押品系统)",
         CONFMAMT AS CONFMAMT_YP,--"分配我行确认价值(押品系统)",
         FIRSTCONFMAMT AS FIRSTCONFMAMT_YP,--"分配初评我行确认价值(押品系统)",
         CASE WHEN COL_SUM_BAL=0 THEN 0 ELSE LOAN_NET_VAL*(CONFMAMT_JGBS/COL_SUM_BAL) END AS DISTVALUE,--"贷款分配价值(监管报送)",
         CONFMAMT_JGBS AS CONFMAMT,--"分配我行确认价值(监管报送)",
         FIRSTCONFMAMT_JGBS AS FIRSTCONFMAMT,--"分配初评我行确认价值(监管报送)",
         GUA_TYPE AS GUA_TYPE,--担保方式,
         BALANCE_TYPE AS BALANCE_TYPE,--表内外标识,
         LVL5_CL AS LVL5_CL,--五级分类,
         DATA_SRC AS DATA_SRC,--数据来源
         SRC_VALUE_NAME AS GUARTYPE_NAME--押品类型名称
  FROM
  (SELECT SCCODE  ,  --AS 押品编号,
         CREDNO  ,  --AS 借据号,
         GUARTYPE ,  --AS 押品类型,
         NAME  ,  --AS 押品类型名称,
         BAL   ,  --AS 借据余额,
         ESTIM_VAL ,  --AS 我行确认价值,
         HXB_PA_CFM_VAL ,  --AS 初评我行确认价值,
         LOAN_NET_VAL ,  --AS 贷款净值,
         OBANK_SET_SEC_RIGHT_AMT ,  --AS 他行设定担保权金额,
         DISTVALUE ,  --AS "贷款分配价值(押品系统)",
         CONFMAMT ,  --AS "分配我行确认价值(押品系统)",
         FIRSTCONFMAMT ,  --AS "分配初评我行确认价值(押品系统)",
         SUM(CONFMAMT)OVER(PARTITION BY CREDNO ORDER BY CREDNO) AS COL_SUM_BAL,--AS "贷款分配价值(监管报送新)",
          CONFMAMT   AS CONFMAMT_JGBS,  --AS"分配我行确认价值(监管报送)", modify by lwb 分配我行确认价值直取缓释表
           FIRSTCONFMAMT  AS FIRSTCONFMAMT_JGBS,  --AS "分配初评我行确认价值(监管报送)",
        GUA_TYPE ,  --AS 担保方式,
        BALANCE_TYPE ,  --AS 表内外标识,
        LVL5_CL ,  --AS 五级分类,
        DATA_SRC,   --AS 数据来源
        SRC_VALUE_NAME--押品类型名称
         FROM TMP
         WHERE LOAN_SUM_BAL<>0)
         ; */
         
         
--MODB BY YJY 20251013
/*  分配比例说明：计算方式：
      ((我行确认价值*汇率 - 他行设定担保权金额） *(借款余额*汇率)/对应借据余额) --》 我行确认价值
      ((初评我行确认价值 * 汇率 - 他行设定担保权金额）*(借款余额*汇率)/对应借据余额） --》 初评我行确认价值
      (借据余额 * 汇率) * ((((我行确认价值*汇率 - coalesce(押品-他行设定担保权汇总金额,0))*(借据余额*汇率)/押品对应借据余额))/对应押品价值余额)  --> 分配价值*/
  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '加工分配价值';
  V_STARTTIME := SYSDATE;  
  INSERT /*+APPEND*/ INTO S_G13_BASE NOLOGGING
  (    DATA_DT                   --数据日期
      ,SCCODE                    --押品编号
      ,CREDNO                    --借据号
      ,GUARTYPE                  --押品类型
      ,G13_GUR_NAME              --押品类型名称
      ,LOAN_BAL                  --借据余额
      ,ESTIM_VAL                 --我行确认价值
      ,HXB_PA_CFM_VAL            --初评我行确认价值
      ,LOAN_NET_VAL              --贷款净值
      ,OBANK_SET_SEC_RIGHT_AMT   --他行设定担保权金额
      ,DISTVALUE_YP              --贷款分配价值（押品系统）
      ,CONFMAMT_YP               --分配我行确认价值(押品系统)
      ,FIRSTCONFMAMT_YP          --分配初评我行确认价值(押品系统)
      ,DISTVALUE                 --贷款分配价值
      ,CONFMAMT                  --分配我行确认价值
      ,FIRSTCONFMAMT             --分配初评我行确认价值
      ,GUA_TYPE                  --担保方式
      ,BALANCE_TYPE              --表内外标识
      ,LVL5_CL                   --五级分类
      ,DATA_SRC                  --数据来源
      ,GUARTYPE_NAME             --押品类型名称
  )
  WITH TMP AS (
       SELECT
            A.ASSET_ID                            AS SCCODE           --押品编号 
           ,A.DUBIL_ID                            AS CREDNO           --借据号    
           ,B.COL_TYPE_ID                         AS GUARTYPE         --押品类型       暂定
           ,G.NAME                                AS NAME             --G13押品类型名称 暂定
           ,NVL(D.LOAN_BAL * E.EXRT,A.DUBIL_BAL)  AS BAL              --借据余额
           ,A.LOAN_ASSIGN_BAL                     AS DISTVALUE        --贷款分配价值
           ,A.SPLT_COL_LATEST_VAL/*A1.HXB_CFM_VAL */                       AS CONFMAMT         --分配我行确认价值 
           ,A.SPLT_COL_INSTO_VAL/*A1.HXB_PA_CFM_VAL*/                     AS FIRSTCONFMAMT    --分配初评我行确认价值
           ,B.ASES_VAL * F.EXRT                   AS ESTIM_VAL        --我行确认价值
           ,CASE WHEN A.ASSET_ID LIKE '%ZCC%' OR A.ASSET_ID LIKE '%-BZJYP%'  
                 THEN B.INIT_VALT * F.EXRT
                 ELSE I.CONFMAMT * NVL(J.EXRT,F.EXRT) --YP_SECURITYINFOVLAUECOUNT表会存在币种为空情况，目前已通知押品系统修复
             END                                  AS HXB_PA_CFM_VAL   --初评我行确认价值
           ,NVL(B.OBANK_SET_SEC_RIGHT_AMT,0)      AS OBANK_SET_SEC_RIGHT_AMT  --他行设定担保权金额
           ,NVL(D.LOAN_NET_VAL * E.EXRT,A.DUBIL_BAL) AS LOAN_NET_VAL  --贷款净值 
           ,SUM(NVL(D.LOAN_NET_VAL * E.EXRT,A.DUBIL_BAL))OVER(PARTITION BY A.ASSET_ID ORDER BY A.ASSET_ID ) 
                                                  AS LOAN_SUM_BAL     --贷款总额 
           ,SUM(B.ASES_VAL * F.EXRT - NVL(B.OBANK_SET_SEC_RIGHT_AMT,0)) OVER(PARTITION BY A.DUBIL_ID ORDER BY A.DUBIL_ID ) 
                                                  AS COL_SUM_BAL      --押品总额 
           ,DECODE(D.TJDBFS,'DZY','抵质押'
                           ,'BZ','保证'
                           ,'XY','信用')          AS GUA_TYPE         --担保方式
           ,CASE WHEN D.RCPT_ID IS NOT NULL 
                 THEN '表内'
                 ELSE '表外' 
             END                                  AS BALANCE_TYPE     --表内外标识
           ,D.LVL5_CL                             AS LVL5_CL          --五级分类
           ,D.DATA_SRC                            AS DATA_SRC         --数据来源
           ,H.SRC_VALUE_NAME                      AS SRC_VALUE_NAME   --押品类型名称   暂定
 --MOD BY YJY 20251013 G13缓释表下线，替换为’资产借据分配历史‘关联’押品价值信息历史‘取值
 FROM RRP_MDL.O_IML_AST_DUBIL_ASSIGN_H A  --资产借据分配历史
 LEFT JOIN RRP_MDL.O_IML_AST_COL_VAL_INFO_H A1   --押品价值信息历史
   ON A1.ASSET_ID = A.ASSET_ID
  AND A1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
 LEFT JOIN RRP_MDL.M_GUA_COLL_INFO B   --押品价值表
   ON A.ASSET_ID = B.COLL_ID
  AND B.DATA_DT = V_P_DATE
 LEFT JOIN RRP_MDL.S_LOAN D  --监管报送贷款基表（表内借据）
   ON A.DUBIL_ID = D.RCPT_ID
  AND D.DATA_DT = V_P_DATE
 LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO E
   ON E.BASE_CUR = D.CUR
  AND E.CNV_CUR = 'CNY'
  AND E.DATA_DT = V_P_DATE
 LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO F
   ON F.BASE_CUR = B.CUR
  AND F.CNV_CUR = 'CNY'
  AND F.DATA_DT = V_P_DATE
 LEFT JOIN RRP_MDL.O_IOL_MIMS_YP_G13RELATION G--G13关系映射表  
   ON B.COL_TYPE_ID = G.GUARTYPE
 -- AND G.GUARTYPE <> 'ZY0304001'
  AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  
 LEFT JOIN RRP_MDL.CODE_MAP H
   ON H.SRC_VALUE_CODE = B.COL_TYPE_ID 
  AND H.TAR_CLASS_CODE = 'T0008'
  AND H.SRC_CLASS_CODE = 'CD1244'
  AND H.MOD_FLG = 'MDM'
 LEFT JOIN (SELECT SCCODE, CONFMAMT, CONFMCURRENCY
              FROM (SELECT COL_ID AS SCCODE
                          ,HXB_CFM_VAL AS CONFMAMT
                          ,CURR_CD AS CONFMCURRENCY
                          ,ROW_NUMBER() OVER(PARTITION BY COL_ID ORDER BY OUT_IN_WHS_DT ASC) NUMM
                     FROM RRP_MDL.O_IML_EVT_COL_OUT_IN_WHS_FLOW  --押品出入库登记流水
                    WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                      AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') 
                      AND OUT_IN_WHS_STATUS_CD = '02') 
              WHERE NUMM = 1 )I  --MOD BY YJY 20251013
   ON I.SCCODE = A.ASSET_ID
 LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J
   ON J.BASE_CUR = I.CONFMCURRENCY
  AND J.CNV_CUR = 'CNY'
  AND J.DATA_DT = V_P_DATE
WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  )
  SELECT V_P_DATE            AS DATA_DT
         ,SCCODE             AS SCCODE                         --押品编号
         ,CREDNO             AS CREDNO                         --借据号
         ,GUARTYPE           AS GUARTYPE                       --押品类型
         ,NAME               AS G13_GUR_NAME                   --押品类型名称
         ,BAL                AS LOAN_BAL                       --借据余额
         ,ESTIM_VAL          AS ESTIM_VAL                      --我行确认价值
         ,HXB_PA_CFM_VAL     AS HXB_PA_CFM_VAL                 --初评我行确认价值
         ,LOAN_NET_VAL       AS LOAN_NET_VAL                   --贷款净值
         ,OBANK_SET_SEC_RIGHT_AMT AS OBANK_SET_SEC_RIGHT_AMT   --他行设定担保权金额
         ,DISTVALUE          AS DISTVALUE_YP                   --"贷款分配价值(押品系统)"
         ,CONFMAMT           AS CONFMAMT_YP                    --"分配我行确认价值(押品系统)"
         ,FIRSTCONFMAMT      AS FIRSTCONFMAMT_YP               --"分配初评我行确认价值(押品系统)"
         ,CASE WHEN COL_SUM_BAL = 0 THEN 0 
               ELSE LOAN_NET_VAL * (CONFMAMT_JGBS/COL_SUM_BAL) 
           END               AS DISTVALUE                      --"贷款分配价值(监管报送)"
         ,CONFMAMT_JGBS      AS CONFMAMT                       --"分配我行确认价值(监管报送)"
         ,FIRSTCONFMAMT_JGBS AS FIRSTCONFMAMT                  --"分配初评我行确认价值(监管报送)"
         ,GUA_TYPE           AS GUA_TYPE                       --担保方式
         ,BALANCE_TYPE       AS BALANCE_TYPE                   --表内外标识
         ,LVL5_CL            AS LVL5_CL                        --五级分类
         ,DATA_SRC           AS DATA_SRC                       --数据来源
         ,SRC_VALUE_NAME     AS GUARTYPE_NAME                  --押品类型名称
  FROM
  (SELECT SCCODE                  --AS 押品编号
         ,CREDNO                  --AS 借据号
         ,GUARTYPE                --AS 押品类型
         ,NAME                    --AS 押品类型名称
         ,BAL                     --AS 借据余额
         ,ESTIM_VAL               --AS 我行确认价值
         ,HXB_PA_CFM_VAL          --AS 初评我行确认价值
         ,LOAN_NET_VAL            --AS 贷款净值
         ,OBANK_SET_SEC_RIGHT_AMT --AS 他行设定担保权金额
         ,DISTVALUE               --AS "贷款分配价值(押品系统)"
         ,CONFMAMT                --AS "分配我行确认价值(押品系统)"
         ,FIRSTCONFMAMT           --AS "分配初评我行确认价值(押品系统)"
         ,SUM(CONFMAMT)OVER(PARTITION BY CREDNO ORDER BY CREDNO) AS COL_SUM_BAL   --AS "贷款分配价值(监管报送新)"
         ,CONFMAMT  AS CONFMAMT_JGBS  --AS"分配我行确认价值(监管报送)"  modify by lwb 分配我行确认价值直取缓释表
         ,FIRSTCONFMAMT  AS FIRSTCONFMAMT_JGBS  --AS "分配初评我行确认价值(监管报送)"
         ,GUA_TYPE                --AS 担保方式,
         ,BALANCE_TYPE            --AS 表内外标识
         ,LVL5_CL                 --AS 五级分类
         ,DATA_SRC                --AS 数据来源
         ,SRC_VALUE_NAME          --押品类型名称
    FROM TMP
   WHERE LOAN_SUM_BAL <> 0 ) ;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   -- 程序跑批结束记录 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     --V_STEP := V_STEP + 1;
     --V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_G13_BASE;
/

