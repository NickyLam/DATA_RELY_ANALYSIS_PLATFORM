CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_POV_ALLE_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_POV_ALLE_SUB
  *  功能描述：精准扶贫贷款有关信息
  *  创建日期：20220615
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  ETL_INIT_M_LOAN_POV_ALLE_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_POV_ALLE_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_POV_ALLE_SUB'; --表名
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




     V_STEP   := 2;
    V_STEP_DESC := '精准扶贫临时表数据处理-1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP03');
  INSERT INTO M_LOAN_IN_DUBILL_INFO_TEMP03  --表内借据信息--精准扶贫按证件
    (
       CERT_NO      -- 01 证件号
      ,TPZT        -- 02 脱贫状态
      ,ACCT_DURAN  -- 03 扶贫名录期间
      ,QG_FLAG     -- 04 全国标志
    )
    SELECT
       CERT_NO      -- 01 证件号
      ,TPZT        -- 02 脱贫状态
      ,ACCT_DURAN  -- 03 扶贫名录期间
      ,QG_FLAG     -- 04 全国标志
    FROM (SELECT
                P1.PKHSFZH         AS CERT_NO     -- 01 证件号
               ,'已脱贫'           AS TPZT        -- 02 脱贫状态
               ,'2021-04'          AS ACCT_DURAN  -- 03扶贫名录期间
               ,'1'                AS QG_FLAG     -- 04 全国标志
           FROM ADD_JZFP_LIST_CN_202104 P1  -- 精准扶贫全国名录  --MODIFY BY LIUYU 20211210 发放日为20210401 之后按此名录为准
          WHERE P1.TPZT = '脱贫'
          GROUP BY P1.PKHSFZH   -- add by liuyu 20220110 202104名单全部是脱贫，默认已脱贫
         );

    V_SQLCOUNT := SQL%ROWCOUNT;
    COMMIT;

    EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP04');
     INSERT INTO M_LOAN_IN_DUBILL_INFO_TEMP04 --表内借据信息--精准扶贫按客户
    (
       CUST_ID      -- 01 客户号
      ,CERT_NO     -- 02 证件号
      ,TPZT        -- 03 脱贫状态
      ,ACCT_DURAN  -- 04 扶贫名录期间
    )
    SELECT
       P1.CUST_ID      -- 01 客户号
      ,P1.CERT_NO     -- 02 证件号
      ,P2.TPZT        -- 03 脱贫状态
      ,P2.ACCT_DURAN  -- 04 扶贫名录期间
    FROM O_ICL_CMM_INDV_CUST_BASIC_INFO P1   -- 个人客户基本信息表
    INNER JOIN M_LOAN_IN_DUBILL_INFO_TEMP03 P2
       ON P1.CERT_NO = P2.CERT_NO
    WHERE P1.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD');
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入精准扶贫贷款有关信息--零售部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_POV_ALLE_SUB
  (
 			DATA_DT  --数据日期
			,LGL_REP_ID  --法人编号
      ,CUST_ID     --客户编号
			,ORG_ID  --机构编号
			,RCPT_ID  --借据编号
			,POV_ALLE_LOAN_FLG  --精准扶贫贴息贷款标志
			,POV_ALLE_LOAN_BIZ_VRTY  --扶贫贷款业务品种
			,POV_ALLE_DRV_NUM  --扶贫带动人数
			,POV_ALLE_DRV_SHK_NUM  --扶贫带动已脱贫人数
			,POV_ALLE_SML_LOAN_FLG  --扶贫小额信贷标志
			,POV_ALLE_LOAN_IDNT_TYP  --扶贫贷款认定类型
			,SPCL_FIN_DEBT_LOAN_FLG  --专项金融债贷款标志
			,DEPT_LINE  --部门条线
			,DATA_SRC  --数据来源
      ,REC_POOR_PSN_LOAN_TYP   --建档立卡贫困户贷款类型
      ,REC_POOR_TYP            --建档立卡贫困户类型
      ,AMT                     --借款金额
    )
    SELECT
    	V_P_DATE   		DATA_DT  --数据日期
			,A.LP_ID             LGL_REP_ID  --法人编号
      ,A.CUST_ID           CUST_ID     --客户编号
			,B.ACCT_INSTIT_ID    ORG_ID  --机构编号
			,A.DUBIL_ID          RCPT_ID  --借据编号
			,'N'                 POV_ALLE_LOAN_FLG  --精准扶贫贴息贷款标志
			,/*CASE WHEN J1.CUST_ID IS NOT NULL
            THEN 'A01'
            ELSE 'A02'
            END*/
         'A01' AS            POV_ALLE_LOAN_BIZ_VRTY  --扶贫贷款业务品种
			,NULL                   POV_ALLE_DRV_NUM  --扶贫带动人数
			,NULL                   POV_ALLE_DRV_SHK_NUM  --扶贫带动已脱贫人数
			,NULL                  POV_ALLE_SML_LOAN_FLG  --扶贫小额信贷标志
			,/*CASE WHEN J1.CUST_ID IS NOT NULL
            THEN '01'
            ELSE '02'
            END */
       NULL                POV_ALLE_LOAN_IDNT_TYP  --扶贫贷款认定类型
			,NULL                SPCL_FIN_DEBT_LOAN_FLG  --专项金融债贷款标志
			,NULL                DEPT_LINE  --部门条线
			,'零售部分'    DATA_SRC  --数据来源
      ,CASE WHEN J.POVERTY_LOAN_FLG LIKE '%返贫%' OR J.POVERTY_LOAN_FLG LIKE '%未脱贫%'  THEN '101'
               WHEN J.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR J.POVERTY_LOAN_FLG = '脱贫' THEN '201'
               WHEN B.DISTR_DT > TO_DATE('20211231', 'YYYYMMDD') AND J1.CUST_ID IS NOT NULL THEN '201'
               ELSE ''
               END
      /*CASE WHEN (J.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR J.POVERTY_LOAN_FLG = '脱贫') THEN '201'
            WHEN (B.DISTR_DT > DATE'2021-12-31' AND J1.CUST_ID IS NOT NULL)
            THEN '201'--已脱贫
            ELSE '101'--未脱贫
            END  */        AS REC_POOR_PSN_LOAN_TYP  --建档立卡贫困户贷款类型
      ,CASE WHEN J.POVERTY_LOAN_FLG LIKE '%返贫%' OR J.POVERTY_LOAN_FLG LIKE '%未脱贫%'  THEN '101'
               WHEN J.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR J.POVERTY_LOAN_FLG = '脱贫' THEN '201'
               WHEN B.DISTR_DT > TO_DATE('20211231', 'YYYYMMDD') AND J1.CUST_ID IS NOT NULL THEN '201'
               ELSE ''
               END        AS REC_POOR_TYP            --建档立卡贫困户类型
      ,B.DUBIL_AMT       AS AMT                     --借款金额
   FROM O_ICL_CMM_RETL_LOAN_ACCT_INFO B    --零售贷款账户信息
    LEFT JOIN O_ICL_CMM_RETL_LOAN_DUBIL_INFO A  --零售贷款借据信息
      ON A.DUBIL_ID = B.DUBIL_NUM
     AND A.ETL_DT = B.ETL_DT
    LEFT JOIN ADD_POVERTY_RELIF J -- 改关联业务20211231报送表为基表取精准扶贫名单
      ON B.DUBIL_NUM = J.LOAN_NUM
    LEFT JOIN M_LOAN_IN_DUBILL_INFO_TEMP04 J1
      ON B.CUST_ID = J1.CUST_ID
     AND J1.ACCT_DURAN = '2021-04'
     WHERE (J.LOAN_NUM IS NOT NULL OR J1.CUST_ID IS NOT NULL)
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入精准扶贫贷款有关信息--联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_POV_ALLE_SUB
  (
 			DATA_DT  --数据日期
			,LGL_REP_ID  --法人编号
      ,CUST_ID     --客户编号
			,ORG_ID  --机构编号
			,RCPT_ID  --借据编号
			,POV_ALLE_LOAN_FLG  --精准扶贫贴息贷款标志
			,POV_ALLE_LOAN_BIZ_VRTY  --扶贫贷款业务品种
			,POV_ALLE_DRV_NUM  --扶贫带动人数
			,POV_ALLE_DRV_SHK_NUM  --扶贫带动已脱贫人数
			,POV_ALLE_SML_LOAN_FLG  --扶贫小额信贷标志
			,POV_ALLE_LOAN_IDNT_TYP  --扶贫贷款认定类型
			,SPCL_FIN_DEBT_LOAN_FLG  --专项金融债贷款标志
			,DEPT_LINE  --部门条线
			,DATA_SRC  --数据来源
      ,REC_POOR_PSN_LOAN_TYP   --建档立卡贫困户贷款类型
      ,REC_POOR_TYP            --建档立卡贫困户类型
      ,AMT                     --借款金额
    )
    SELECT
    	V_P_DATE   		DATA_DT  --数据日期
			,A.LP_ID             LGL_REP_ID  --法人编号
      ,A.CUST_ID           CUST_ID     --客户编号
			,A.ACCT_INSTIT_ID    ORG_ID  --机构编号
			,A.DUBIL_ID          RCPT_ID  --借据编号
			,'N'                 POV_ALLE_LOAN_FLG  --精准扶贫贴息贷款标志
			,/*CASE WHEN J1.CUST_ID IS NOT NULL OR J.LOAN_NUM IS NOT NULL
            THEN 'A01'
            ELSE 'A02'
            END*/
       'A01' AS                 POV_ALLE_LOAN_BIZ_VRTY  --扶贫贷款业务品种
			,NULL                POV_ALLE_DRV_NUM  --扶贫带动人数
			,NULL                POV_ALLE_DRV_SHK_NUM  --扶贫带动已脱贫人数
			,NULL                POV_ALLE_SML_LOAN_FLG  --扶贫小额信贷标志
			,/*CASE WHEN J1.CUST_ID IS NOT NULL OR J.LOAN_NUM IS NOT NULL
            THEN '01'
            ELSE '02'
            END  */
       NULL                POV_ALLE_LOAN_IDNT_TYP  --扶贫贷款认定类型
			,NULL                SPCL_FIN_DEBT_LOAN_FLG  --专项金融债贷款标志
			,NULL                DEPT_LINE  --部门条线
			,'联合网贷'    DATA_SRC  --数据来源
      ,CASE WHEN J.POVERTY_LOAN_FLG LIKE '%返贫%' OR J.POVERTY_LOAN_FLG LIKE '%未脱贫%'  THEN '101'
               WHEN J.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR J.POVERTY_LOAN_FLG = '脱贫' THEN '201'
               WHEN A.DISTR_DT >= DATE'2021-05-01' AND A.STD_PROD_ID = '202010100003' THEN ''
                  -- MODIFY BY LIUYU 20220415 根据李伟华脚本调整花呗202105后放款的都不算入扶贫名单贷款
               WHEN A.DISTR_DT > DATE'2021-12-31' AND J1.CUST_ID IS NOT NULL THEN '201'
                  -- MODIFY BY LIUYU 20220303 历史数据使用业务报送数据关联
               ELSE ''
               END
      /*,CASE WHEN ((J.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR J.POVERTY_LOAN_FLG = '脱贫') THEN '201'
            WHEN (A.DISTR_DT > DATE'2021-12-31' AND J1.CUST_ID IS NOT NULL)
            AND A.STD_PROD_ID <> '202010100003')--花呗
            THEN '201'
            ELSE '101'--未脱贫
            END    */      AS REC_POOR_PSN_LOAN_TYP  --建档立卡贫困户贷款类型
      ,CASE WHEN J.POVERTY_LOAN_FLG LIKE '%返贫%' OR J.POVERTY_LOAN_FLG LIKE '%未脱贫%'  THEN '101'
               WHEN J.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR J.POVERTY_LOAN_FLG = '脱贫' THEN '201'
               WHEN A.DISTR_DT >= DATE'2021-05-01' AND A.STD_PROD_ID = '202010100003' THEN ''
                  -- MODIFY BY LIUYU 20220415 根据李伟华脚本调整花呗202105后放款的都不算入扶贫名单贷款
               WHEN A.DISTR_DT > DATE'2021-12-31' AND J1.CUST_ID IS NOT NULL THEN '201'
                  -- MODIFY BY LIUYU 20220303 历史数据使用业务报送数据关联
               ELSE ''
               END          AS REC_POOR_TYP            --建档立卡贫困户类型
      ,CASE WHEN A.INTNAL_CARR_FLG = 1 AND A.ACCT_INSTIT_ID LIKE '897%'
            THEN 0
            ELSE
            A.DUBIL_AMT
            END          AS AMT                     --借款金额
      FROM O_ICL_CMM_UNITE_WL_DUBIL_INFO A  --联合网贷借据信息
      LEFT JOIN ADD_POVERTY_RELIF J -- 修改关联业务20211231报送表为基表取精准扶贫名单
        ON A.DUBIL_ID = J.LOAN_NUM
      LEFT JOIN M_LOAN_IN_DUBILL_INFO_TEMP04 J1
        ON A.CUST_ID = J1.CUST_ID
       AND J1.ACCT_DURAN = '2021-04'
      WHERE (J.LOAN_NUM IS NOT NULL OR J1.CUST_ID IS NOT NULL)
      AND ((A.DISTR_DT < DATE'2021-05-01')
       OR (A.DISTR_DT >= DATE'2021-05-01' AND A.STD_PROD_ID <> '202010100003'))
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM M_LOAN_POV_ALLE_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID
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

  END ETL_INIT_M_LOAN_POV_ALLE_SUB;
/

