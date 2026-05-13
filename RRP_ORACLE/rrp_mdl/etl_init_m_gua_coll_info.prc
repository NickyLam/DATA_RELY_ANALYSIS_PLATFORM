CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_GUA_COLL_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_GUA_COLL_INFO
  *  功能描述：抵质押物详细信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_GUA_COLL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  *             3    20221118  xucx      增加字段取押品入库状态
  *             4    20221118  xucx      修改数据范围 修改筛选条件和inner join
  *             5    20221118  xucx      增加字段取数仓押品类型代码
  *             6    20221125  xucx      增加字段取存单凭证编号
  *             7    20230210  hulj      增加字段首次评估日期(客户风险)
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_GUA_COLL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
 -- V_LAST_DAT  VARCHAR2(8); -- 当月月末
 -- V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_GUA_COLL_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

   V_MONTH_START_DATE:= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

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

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入抵质押物详细信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_COLL_INFO
  (
       DATA_DT     					--01数据日期
      ,LGL_REP_ID  					--02法人编号
      ,COLL_ID     					--03押品编号
      ,CUST_ID     					--04客户编号
      ,ORG_ID      					--05机构编号
      ,COLL_TYP    					--06押品类型
      ,COLL_NM     					--07押品名称
      ,CUR         					--08币种
      ,COLL_ORIG_VAL  		  --09押品原始价值
      ,INIT_VALT      		  --10起始估值
      ,BANK_IDNT_PRC_VAL    --11银行认定价值
      ,ALDY_MTG_VAL         --12已抵押价值
      ,ASES_VAL             --13评估价值
      ,ASES_DT              --14评估日期
      ,ASES_ORG_NM          --15评估机构名称
      ,FIRST_VALT_DT        --16首次估值日期
      ,VALT_EXP_DT          --17估值到期日期
      ,REGD_ORG_ID          --18登记机构
      ,OPR_ORG_ID           --19操作机构编号
      ,COLL_EFF_DT          --20押品生效日期
      ,COLL_EXP_DT          --21押品到期日期
      ,PLG_TKT_ACC          --22质押票证账号
      ,PLG_TKT_TYP          --23质押票证类型
      ,PLG_TKT_NO           --24质押票证号码
      ,PLG_TKT_AMT          --25质押票证金额
      ,PLG_TKT_ISU_ORG_ID   --26质押票证签发机构
      ,PLG_TKT_ESTM_DT      --27质押票证开立日期
      ,WRNT_REGD_NO         --28权证登记号码
      ,WRNT_NM              --29权证名称
      ,WRNT_VALID_EXP_DT    --30权证有效到期日期
      ,REGD_VALID_END_DT    --31登记有效终止日期
      ,COLL_CUST_RSK_RTG_CL --32担保品客户风险评级分类
      ,DIR_ACQ_FLG          --33定向收购标志
      ,QUAL_MTGN_FLG        --34合格缓释品标志
      ,RE_MTG_PLG_FIN_COLL_FLG  --35可再抵质押融资押品标志
      ,REGD_DT              --36登记日期
      ,MTRL_OBJ_COLL_DT     --37实物收取日期
      ,ASES_MODE            --38评估方式
      ,ASES_METHOD          --39评估方法
      ,VALT_CYC             --40估值周期
      ,WRNT_REGD_AREA       --41权证登记面积
      ,COLL_OWNER_NM        --42押品所有人名称
      ,COLL_OWNER_CRDL_TYP  --43押品所有人证件类别
      ,COLL_OWNER_CRDL_NO   --44押品所有人证件号码
      ,TRD_COLL_OWNER_FLG   --45第三方押品权属人标志
      ,COLL_STAT            --46押品状态
      ,DEPT_LINE            --47部门条线
      ,DATA_SRC             --48数据来源
      ,INSTO_STATUS_CD      --49押品入库状态 add by 20221118 xcx
      ,COL_TYPE_ID          --50数仓押品类型代码 add by 20221118 xucx
      ,HIGT_MTG_RAT         --51最高抵质押率
      ,PLG_EQTY_NUM         --52质押股权数量
      ,DEP_RCPT_VOUCH_ID    --53存单凭证编号 add by 20221125 xucx
      ,BELONG_CERT_NO       --54权属证件号码
      ,MTG_RAT              --55抵质押率
      ,OBANK_SET_SEC_RIGHT_AMT
                            --56他行设定担保权金额
      ,ESTIM_DT             --57首次评估日期(客户风险)
      ,PRIOR_COMP_WEIGHT_QTTY
                            --58优先受偿权数额
      ,COL_EXP_DT           --59押品到期日期
      )
     WITH COL_GUAR_CONT_RELA AS
     (SELECT /*+USE_HASH(C,D)*/C.COL_ID,MAX(D.CUST_ID) AS CUST_ID
        FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA C  --押品与担保合同关系
       INNER JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT D
          ON D.GUAR_CONT_ID=C.GUAR_CONT_ID
         AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       GROUP BY C.COL_ID)
    ,COL_ALL_INFO_H AS
   /*对押品所有人去重*/
     (SELECT E.PROP_PS_ID
            ,E.PLEDGOR_CERT_NO
            ,E.PLEDGOR_CERT_TYPE_CD
            ,ROW_NUMBER() OVER(PARTITION BY E.PROP_PS_ID ORDER BY
                                            CASE WHEN E.PLEDGOR_CERT_TYPE_CD='2313'
                                                 THEN '1'
                                                 ELSE E.PLEDGOR_CERT_TYPE_CD END) AS RN
        FROM RRP_MDL.O_ICL_CMM_COL_INFO E --押品信息
       WHERE E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND NVL(E.PLEDGOR_CERT_NO,' ') <> ' ')

  SELECT DISTINCT
         V_P_DATE                AS DATA_DT --01数据日期
        ,A.LP_ID                 AS LGL_REP_ID --02法人编号
        ,A.COL_ID                AS COLL_ID --03押品编号
        ,C.CUST_ID               AS CUST_ID --04客户编号
        ,A.ORG_ID                AS ORG_ID --05机构编号
        ,D.TAR_VALUE_CODE        AS COLL_TYP --06押品类型
        ,CASE WHEN NVL(A.COL_NAME, ' ') = ' ' THEN D.TAR_VALUE_CODE
              ELSE A.COL_NAME
         END                     AS COLL_NMCOLL_NM --07押品名称
        ,DECODE(A.ESTIM_CURR_CD, '-', 'CNY', A.ESTIM_CURR_CD) AS CUR --08币种
        ,A.COL_VAL               AS COLL_ORIG_VAL --09押品原始价值
        ,A.HXB_PA_CFM_VAL        AS INIT_VALT --10起始估值
        ,A.HXB_CFM_VAL           AS BANK_IDNT_PRC_VAL --11银行认定价值
        ,NVL(A.MTGED_VAL, 0)     AS ALDY_MTG_VAL --12已抵押价值
        ,A.ESTIM_VAL             AS ASES_VAL --13评估价值
        ,TO_CHAR( /*A.ESTIM_DT*/
                 CASE WHEN A.ESTIM_IDTFY_DT = DATE '2099-12-31' THEN NULL
                      ELSE A.ESTIM_IDTFY_DT
                 END,'YYYYMMDD') AS ASES_DT --14评估日期20221028 XUXIAOBIN MODIFY
        ,A.ESTIM_ORG_NAME        AS ASES_ORG_NM --15评估机构名称
        ,F.FIRST_ESTIM_DT        AS FIRST_VALT_DT --16首次估值日期
        ,TO_CHAR(A.ESTIM_EXP_DT,'YYYYMMDD')
                                 AS VALT_EXP_DT --17估值到期日期
        ,A.RGST_ORG_NAME         AS REGD_ORG_ID --18登记机构
        ,A.OPER_ORG_ID           AS OPR_ORG_ID --19操作机构编号
        ,TO_CHAR(M.EFFECT_DT, 'YYYYMMDD')
                                 AS COLL_EFF_DT --20押品生效日期
        ,TO_CHAR(M.EXP_DT, 'YYYYMMDD')
                                 AS COLL_EXP_DT --21押品到期日期
        ,B.DRAWER_ACCT_NUM       AS PLG_TKT_ACC --22质押票证账号
        ,B.BILL_TYPE_CD          AS PLG_TKT_TYP --23质押票证类型
        ,CASE WHEN NVL(TRIM(A.DEP_RCPT_VOUCH_ID),' ') <> ' ' THEN A.DEP_RCPT_VOUCH_ID
              ELSE NVL(B.BILL_NUM, A.BELONG_CERT_NO)
         END                     AS PLG_TKT_NO --24质押票证号码
        ,B.FAC_VAL_AMT           AS PLG_TKT_AMT --25质押票证金额
        ,B.DRAWER_OPEN_BANK_NO   AS PLG_TKT_ISU_ORG_ID --26质押票证签发机构
        ,TO_CHAR(B.BILL_ISSUE_DT, 'YYYYMMDD')
                                 AS PLG_TKT_ESTM_DT --27质押票证开立日期
        ,A.WAT_RGST_NUM          AS WRNT_REGD_NO --28权证登记号码
        ,A.WAT_NAME              AS WRNT_NM --29权证名称
        ,TO_CHAR(A.RGST_EXP_DT, 'YYYYMMDD')
                                 AS WRNT_VALID_EXP_DT --30权证有效到期日期
        ,TO_CHAR(A.RGST_EXP_DT, 'YYYYMMDD')
                                 AS REGD_VALID_END_DT --31登记有效终止日期
        ,NULL                    AS COLL_CUST_RSK_RTG_CL --32担保品客户风险评级分类
        ,NULL                    AS DIR_ACQ_FLG --33定向收购标志
        ,NULL                    AS QUAL_MTGN_FLG --34合格缓释品标志
        ,NULL                    AS RE_MTG_PLG_FIN_COLL_FLG --35可再抵质押融资押品标志
        ,TO_CHAR(A.RIGHT_RGST_DT, 'YYYYMMDD')
                                 AS REGD_DT --36登记日期
        ,TO_CHAR(A.ENTY_COLL_DT, 'YYYYMMDD')
                                 AS MTRL_OBJ_COLL_DT --37实物收取日期
        ,A.ESTIM_WAY_CD          AS ASES_MODE --38评估方式
        ,CASE WHEN FF.EXT_ESTIM_METHOD_CD = '04' THEN '01'
              WHEN FF.EXT_ESTIM_METHOD_CD = '03' THEN '02'
              WHEN FF.EXT_ESTIM_METHOD_CD = '05' THEN '03'
              ELSE '09'
         END                     AS ASES_METHOD --39评估方法
        ,CASE WHEN M.REVAL_FREQ_CD = 'D' THEN '07'
              WHEN M.REVAL_FREQ_CD = 'W' THEN '06'
              WHEN M.REVAL_FREQ_CD = 'T' THEN '05'
              WHEN M.REVAL_FREQ_CD = 'M' THEN '04'
              WHEN M.REVAL_FREQ_CD = 'Q' THEN '03'
              WHEN M.REVAL_FREQ_CD = 'H' THEN '02'
              WHEN M.REVAL_FREQ_CD = 'Y' THEN '01'
              ELSE '99'
         END                     AS VALT_CYC --40估值周期
        ,A.ESTATE_ARCH_AREA      AS WRNT_REGD_AREA --41权证登记面积
        ,A.PROP_PS_NAME          AS COLL_OWNER_NM --42押品所有人名称
        ,A.PLEDGOR_CERT_TYPE_CD  AS COLL_OWNER_CRDL_TYP --43押品所有人证件类别
        ,A.PLEDGOR_CERT_NO       AS COLL_OWNER_CRDL_NO --44押品所有人证件号码
        ,/*CASE WHEN A.COL_BELONG_TYPE_CD = '3' THEN 'Y'
              ELSE 'N'
         END*/
         CASE WHEN T9.PMO_OBG_BRWER_RELA_CD IN ('02','03')
              THEN 'Y'
              ELSE 'N'
              END                     AS TRD_COLL_OWNER_FLG --45第三方押品权属人标志
        ,CASE WHEN A.ESPEC_STATUS_CD = '01' THEN '01'
              WHEN A.ESPEC_STATUS_CD = '02' THEN '02'
              WHEN A.ESPEC_STATUS_CD = '03' THEN '03'
              WHEN A.ESPEC_STATUS_CD = '04' THEN '04'
              ELSE '99'
         END                     AS COLL_STAT --46押品状态
        ,NULL                    AS DEPT_LINE --47部门条线
        ,SUBSTR(A.JOB_CD, 0, 4)  AS DATA_SRC --48数据来源
        ,A.INSTO_STATUS_CD       AS INSTO_STATUS_CD --49押品入库状态 ad by 20221118 xcx
        ,A.COL_TYPE_ID           AS COL_TYPE_ID --50数仓押品类型代码 ad by 20221118 xucx
        ,A.HIGT_MTG_RAT          AS HIGT_MTG_RAT --51最高抵押率
        ,F1.INPWN_STOCK_QTTY     AS PLG_EQTY_NUM --52质押股权数量
        ,NVL(TRIM(A.DEP_RCPT_VOUCH_ID),
             NVL(TRIM(B.BILL_NUM),
             TRIM(A.BELONG_CERT_NO)))
                                 AS DEP_RCPT_VOUCH_ID --53存单凭证编号 add by 20221125 xucx
        ,A.BELONG_CERT_NO        AS BELONG_CERT_NO --54权属证件号码
        ,A.PM_RAT                AS MTG_RAT --55抵质押率
        ,T10.OBANK_SET_SEC_RIGHT_AMT
                                 AS OBANK_SET_SEC_RIGHT_AMT --56他行设定担保权金额
         ,TO_CHAR(A.ESTIM_DT, 'YYYYMMDD')
                                 AS ESTIM_DT --57首次评估日期(客户风险)add by HULJ 20230210
        ,A.PRIOR_COMP_WEIGHT_QTTY
                                 AS PRIOR_COMP_WEIGHT_QTTY --58优先优先受偿权数额
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')
                                 AS COL_EXP_DT             --59押品到期日期
    FROM RRP_MDL.O_ICL_CMM_COL_INFO A
    LEFT JOIN COL_GUAR_CONT_RELA C --md by 20221118 xucx  修改关联方式 释放资产池和票据池中的子资产(A.COL_ID LIKE '%ZCC')
      ON A.COL_ID = C.COL_ID
    LEFT JOIN RRP_MDL.O_IML_AST_COL_ACCPT_BIL_INFO_H B --押品承兑汇票信息历史
      ON A.COL_ID = B.ASSET_ID
     AND B.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN (SELECT G.COL_ID,
                      MIN(H.EFFECT_DT) EFFECT_DT,
                      MAX(H.EXP_DT) EXP_DT
                 FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA G --押品与担保合同关系
                 LEFT JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT H --担保合同
                   ON H.GUAR_CONT_ID = G.GUAR_CONT_ID
                  AND H.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                WHERE G.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                GROUP BY COL_ID) M
      ON A.COL_ID = M.COL_ID
    LEFT JOIN COL_ALL_INFO_H E --押品所有人信息历史
      ON E.PROP_PS_ID = A.PROP_PS_ID
     AND E.RN = 1
    LEFT JOIN (SELECT SCCODE,
                      MIN(NVL(REPLACE(CONDATE, '-', ''), '99991231')) FIRST_ESTIM_DT
                 FROM RRP_MDL.O_IOL_MIMS_SI_VALUEINFOHIS
                GROUP BY SCCODE) F
      ON F.SCCODE = A.COL_ID
    LEFT JOIN O_IML_AST_COL_TYPE_DEF M
      ON A.COL_TYPE_ID = M.COL_TYPE_CD
     AND M.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP D --码值映射表(押品类型)
      ON D.SRC_VALUE_CODE = A.COL_TYPE_ID
     AND D.SRC_CLASS_CODE = 'CD1244'
     AND D.TAR_CLASS_CODE = 'T0008'
     AND D.MOD_FLG = 'MDM' --监管集市明细层
    LEFT JOIN O_IML_AST_COL_VAL_INFO_H FF --押品价值信息历史
      ON A.COL_ID = FF.ASSET_ID
     AND FF.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND FF.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN O_IML_AST_COL_LIST_STOCK_INPWN_INFO F1 --押品上市公司股权质押信息
      ON A.COL_ID = F1.ASSET_ID
     AND F1.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND F1.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN
    (SELECT T.ASSET_ID,T.PMO_OBG_BRWER_RELA_CD,T.COL_ALL_TYPE_CD,T.ALL_CUST_ID,ROW_NUMBER()OVER(PARTITION BY T.ASSET_ID ORDER BY SEQ_NUM) RN
     FROM O_IML_AST_COL_ALL_INFO_H  T  --押品所有人信息历史
     WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') )T9
         ON   T9.ASSET_ID = A.COL_ID
         AND T9.RN = 1
    LEFT JOIN
    (SELECT ASSET_ID,SUM(coalesce(OBANK_SET_SEC_RIGHT_AMT, 0)) OBANK_SET_SEC_RIGHT_AMT --他行设定担保权金额
       FROM O_IML_AST_COL_OBANK_GUAR
      WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       GROUP BY ASSET_ID)                            T10 --押品他行担保
      ON A.COL_ID = T10.ASSET_ID
   WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD'); --md by 20221118 xuchangxin
         /*(A.COL_TYPE_ID LIKE 'DY%' OR A.COL_TYPE_ID LIKE 'ZY%')
         AND A.INSTO_STATUS_CD <> '01' --剔除未入库的
         AND*/


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

         -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, COLL_ID,COUNT(1)
      FROM M_GUA_COLL_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, COLL_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;



  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_GUA_COLL_INFO;
/

