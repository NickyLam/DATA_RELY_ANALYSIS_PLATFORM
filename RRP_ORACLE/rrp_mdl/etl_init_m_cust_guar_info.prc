CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_GUAR_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_GUAR_INFO
  *  功能描述：监管集市信贷业务担保人信息，包括保证人、抵押人、出质人
  *  创建日期：20220609
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_GUAR_CONT A  --担保合同
  *            ICL.CMM_COL_GUARTOR_RATING_INFO  --押品保证人评级信息
  *
  *  目标表：  M_CUST_GUAR_INFO  --担保人信息
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221108  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20220901  MW      增加码值表模块判定
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_GUAR_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
 V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_GUAR_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 将参数转化为日期格式，判读输入参数是否符合日期要求 --
  V_DATE    := TO_DATE(SUBSTR(I_P_DATE, 1, 4) || '-' ||
                       SUBSTR(I_P_DATE, 5, 2) || '-' ||
                       SUBSTR(I_P_DATE, 7, 2),
                       'YYYY-MM-DD');

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
  V_STEP_DESC := '插入担保人信息表数据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CUST_GUAR_INFO
  (
   DATA_DT              --数据日期
  ,LGL_REP_ID           --法人编号
  ,GUAR_ID              --担保人编号
  ,GUAR_NM              --担保人名称
  ,GUAR_TYP             --担保人类型
  ,GUAR_PRIM_CRDL_TYP   --担保人主证件类型
  ,GUAR_PRIM_CRDL_NO    --担保人主证件号码
  ,PBC_NO               --人行支付行号
  ,FIN_PERMIT_NO        --金融许可证号
  ,GUAR_NET_AST         --保证人净资产
  ,GUAR_NET_AST_CUR     --担保人净资产币种
  ,GUAR_LMT_AMT         --保证人保证能力上限金额
  ,CORP_INDV_FLG        --公私标志
  ,DEPT_LINE            --部门条线
  ,DATA_SRC             --数据来源
  ,GUAR_IDY_TYP         --担保人行业类型
  ,GUAR_RGN             --担保人地区
  ,GUAR_ECON_DEPT       --担保人国民经济部门类型
  ,GUAR_ENT_SCALE       --担保人企业规模
    )
  WITH TMP AS
 /* (SELECT A.LP_ID
          ,A.GUARTOR_ID
          ,A.GUARTOR_NAME
          ,A.JOB_CD
          ,CASE WHEN SUBSTR(A.GUARTOR_CERT_TYPE_CD,1,1) = '1' THEN '01'
                WHEN SUBSTR(A.GUARTOR_CERT_TYPE_CD,1,1) = '2' THEN '02' END AS GUARTOR_TYPE_CD
          ,A.GUARTOR_CERT_TYPE_CD
          ,A.GUARTOR_CERT_NO
         , A.GUARTOR_INDUS_TYPE_CD
         ,A.GUARTOR_DIST_CD
         ,A.GUARTOR_NATNAL_ECON_DEPT_TYPE_CD
         ,A.GUARTOR_CORP_SIZE_CD
          ,ROW_NUMBER()OVER (PARTITION BY A.GUARTOR_ID ORDER BY A.GUARTOR_NAME,A.GUARTOR_CERT_TYPE_CD,A.GUARTOR_CERT_NO) AS RN
     FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A
     WHERE A.ETL_DT = V_DATE
     AND NVL(A.GUARTOR_ID,' ') <> ' '*/
     (SELECT T2.LP_ID,T2.GUARTOR_ID,T2.GUARTOR_NAME,T2.JOB_CD,T2.GUAR_WAY_CD,T2.GUAR_CONT_ID,T2.GUARTOR_TYPE_CD
     ,T2.GUARTOR_CERT_TYPE_CD,T2.GUARTOR_CERT_NO,T2.GUARTOR_INDUS_TYPE_CD,T2.GUARTOR_DIST_CD,T2.GUARTOR_NATNAL_ECON_DEPT_TYPE_CD
     ,T2.GUARTOR_CORP_SIZE_CD,T2.RN,T2.GUAR_ID  FROM  (

        SELECT T1.LP_ID
          ,T1.GUARTOR_ID
          ,T1.GUARTOR_NAME
          ,T1.JOB_CD
          ,T1.GUAR_WAY_CD
          ,T1.GUAR_CONT_ID
          ,CASE WHEN SUBSTR(T1.GUARTOR_CERT_TYPE_CD,1,1) = '1' THEN '01'
                WHEN SUBSTR(T1.GUARTOR_CERT_TYPE_CD,1,1) = '2' THEN '02' END AS GUARTOR_TYPE_CD
          ,T1.GUARTOR_CERT_TYPE_CD
          ,T1.GUARTOR_CERT_NO
         , T1.GUARTOR_INDUS_TYPE_CD
         ,T1.GUARTOR_DIST_CD
         ,T1.GUARTOR_NATNAL_ECON_DEPT_TYPE_CD
         ,T1.GUARTOR_CORP_SIZE_CD
         ,B.GUAR_ID GUAR_ID
          ,ROW_NUMBER()OVER (PARTITION BY T1.GUARTOR_ID ORDER BY T1.GUARTOR_NAME,T1.GUARTOR_CERT_TYPE_CD,T1.GUARTOR_CERT_NO DESC ) AS RN
          FROM RRP_MDL.O_ICL_CMM_GUAR_CONT T1
         INNER JOIN O_IML_AGT_GUAR_CONT_GUAR_RELA_H B
     ON  T1.GUAR_CONT_ID = B.GUAR_CONT_ID
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.OBJ_TYPE_NAME = 'BusinessContract'
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') )T2
 WHERE  T2.RN = 1
 AND T2.GUAR_WAY_CD = 'C' ),
   /*目前存在一个客户同一个证件号有两个客户名称，按照客户名，证件类型，证件号码排序取第一条*/
  COL_GUARTOR_RATING_INFO AS (SELECT B.GUARTOR_ID  GUARTOR_ID,
                          MAX(B.GUARTOR_NET_ASSET_AMT) GUARTOR_NET_ASSET_AMT, --保证人净资产
                          MIN(TRIM(B.CURR_CD))    CURR_CD  --担保人净资产币种
                     FROM RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO B
                    WHERE B.ETL_DT = V_DATE
                    GROUP BY B.GUARTOR_ID)
  SELECT   V_P_DATE                   AS DATA_DT              --数据日期
           ,A.LP_ID                   AS LGL_REP_ID           --法人编号
           ,A.GUARTOR_ID              AS GUAR_ID              --担保人编号
           ,A.GUARTOR_NAME            AS GUAR_NM              --担保人名称
           ,A.GUARTOR_TYPE_CD         AS GUAR_TYP             --担保人类型  取担保合同公私标志
           ,A.GUARTOR_CERT_TYPE_CD    AS GUAR_PRIM_CRDL_TYP   --担保人主证件类型
           ,A.GUARTOR_CERT_NO         AS GUAR_PRIM_CRDL_NO    --担保人主证件号码
           ,NULL                      AS PBC_NO               --人行支付行号
           ,NULL                      AS FIN_PERMIT_NO        --金融许可证号
           ,/*CASE WHEN NVL(D.GUARTOR_NET_ASSET_AMT,0) = 0 THEN NVL(B.GUARTOR_NET_ASSET_AMT,0)
                ELSE D.GUARTOR_NET_ASSET_AMT
                END*/
            D.GUARTOR_NET_ASSET_AMT
                                       AS GUAR_NET_AST         --保证人净资产
           ,/*CASE WHEN LENGTH(B.CURR_CD)>3 THEN SUBSTR(B.CURR_CD,2,3)
                 ELSE B.CURR_CD
             END*/
            D.CURR_CD                  AS GUAR_NET_AST_CUR     --担保人净资产币种
           ,NULL                      AS GUAR_LMT_AMT         --保证人保证能力上限金额
           ,CASE WHEN A.GUARTOR_TYPE_CD = '01' THEN '1'
            WHEN A.GUARTOR_TYPE_CD = '02' THEN '2'  END  AS CORP_INDV_FLG        --公私标志
           ,'800919'                  AS DEPT_LINE            --部门条线
           ,'担保人信息'               AS DATA_SRC             --数据来源
           ,A.GUARTOR_INDUS_TYPE_CD   AS GUAR_IDY_TYP         --担保人行业类型
           ,A.GUARTOR_DIST_CD         AS GUAR_RGN             --担保人地区
           ,A.GUARTOR_NATNAL_ECON_DEPT_TYPE_CD AS GUAR_ECON_DEPT--担保人国民经济部门类型
         ,CASE WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='1' THEN 'CS01'
                WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='2' THEN 'CS02'
                WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='3' THEN 'CS03'
                WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='4' THEN 'CS04'
                WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='9' THEN 'CS05'
                ELSE NULL
           END      AS GUAR_ENT_SCALE       --担保人企业规模
   FROM  TMP A  --担保人信息
     /*LEFT JOIN RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO B   --押品保证人评级信息
       ON A.GUARTOR_ID = B.GUARTOR_ID
      AND B.ETL_DT = V_DATE*/
   LEFT JOIN COL_GUARTOR_RATING_INFO B   --押品保证人评级信息
        ON B.GUARTOR_ID = A.GUARTOR_ID
   LEFT JOIN RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO D
       ON D.COL_ID = A.GUAR_ID
/*       AND D.GUARTOR_ID IS NOT NULL
       AND A.GUARTOR_NAME = D.GUARTOR_NAME*/
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.CODE_MAP C     --码值映射表
        ON C.SRC_VALUE_CODE = A.GUARTOR_CERT_TYPE_CD
        AND C.SRC_CLASS_CODE = 'CD1014'
        AND C.MOD_FLG = 'MDM'
   WHERE A.RN = 1 ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, GUAR_ID,COUNT(1)
      FROM M_CUST_GUAR_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT,GUAR_ID
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

  END ETL_INIT_M_CUST_GUAR_INFO;
/

