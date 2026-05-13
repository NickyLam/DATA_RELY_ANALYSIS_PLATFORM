CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CPTL_CD_INVEST_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CPTL_CD_INVEST_INFO
  *  功能描述：存单投资信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_CD_INVEST_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CPTL_CD_INVEST_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CPTL_CD_INVEST_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底

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
  V_STEP_DESC := '插入存单投资信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_CD_INVEST_INFO
  (
        DATA_DT  --1  数据日期
      ,LGL_REP_ID  --2  法人编号
      ,CUST_ID  --3  客户编号
      ,ORG_ID  --4  机构编号
      ,ACC_ID  --5  账户编号
      ,CD_NO  --6  存单号
      ,ACC_TYP  --7  账户类型
      ,PROD_CL  --8  产品分类
      ,CUR  --9  币种
      ,BOOK_BAL  --10  账面余额
      ,RECV_INT  --11  应收利息
      ,ISU_DT  --12  发行日期
      ,VAL_DT  --13  起息日期
      ,EXP_DT  --14  到期日期
      ,MKT_VAL  --15  市场价值
      ,SUBJ_ID  --16  科目编号
      ,LVL5_CL  --17  五级分类
      ,CD_TRF_MODE  --18  存单转让方式
      ,PRO_IMPT  --19  减值准备
      ,DEP_INS_AMT  --20  被存款保险制度覆盖的金额
      ,DUR  --21  久期
      ,MOD_DUR  --22  修正久期
      ,STATS_SUBJ_ID  --23  统计科目编号
      ,RATE  --24  利率
      ,GL_CL  --25  会计分类
      ,CRDT_LMT_ID  --26  授信额度编号
      ,DEP_RSV_MODE  --27  缴存准备金方式
      ,DEPT_LINE  --28  部门条线
      ,DATA_SRC  --29  数据来源
      ,ACRU_INT --30 应计利息
      ,FIN_AST_CL --31  金融资产分类
      )

    SELECT
        TO_CHAR(A.ETL_DT,'YYYYMMDD')   --1  数据日期
      ,A.LP_ID   --2  法人编号
      ,A.ISSUER_CUST_ID   --3  客户编号
      ,A.ENTRY_ORG_ID   --4  机构编号
      ,A.BOND_ID    --5  账户编号
      ,A.BOND_ID|| '_' || A.TRAN_ACCT_B_ID   --6  存单号
      ,A.ACCT_ATTR_CD   --7  账户类型
      ,'1'   --8  产品分类
      ,A.CURR_CD   --9  币种
      ,A.BOOK_BAL   --10  账面余额
      ,A.INT_RECVBL   --11  应收利息
      ,TO_CHAR(A.OPEN_DT,'YYYYMMDD')   --12  发行日期
      ,TO_CHAR((SELECT MAX(STL_DT) FROM O_ICL_CMM_CAP_SEC_TRAN A1 WHERE A1.BOND_ID||'_'||A1.TRAN_ACCT_B_ID = A.BOND_ID||'_'||A.TRAN_ACCT_B_ID
                                                                    AND A1.TRAN_DIR_CD='01' AND TO_CHAR(A1.ETL_DT,'YYYYMMDD') =V_P_DATE)--20221008 xuxiaobin modify
         ,'YYYYMMDD')   --13  起息日期
      ,TO_CHAR(C.EXP_DT	,'YYYYMMDD')   --14  到期日期 --20221008 xuxiaobin modify
      ,A.BP_VAL   --15  市场价值
      ,A.SUBJ_ID   --16  科目编号
      ,NULL   --17  五级分类
      ,NULL   --18  存单转让方式
      ,NULL   --19  减值准备
      ,NULL   --20  被存款保险制度覆盖的金额
      ,NULL   --21  久期
      ,A.ESTIM_CORET_DURAN   --22  修正久期
      ,NULL   --23  统计科目编号
      ,C.ISSUE_INT_RAT   --24  利率
      ,NULL   --25  会计分类
      ,NULL   --26  授信额度编号
      ,CASE WHEN (/*A.SUBJ_ID LIKE '201202%' OR A.SUBJ_ID LIKE '20150102%' OR A.SUBJ_ID LIKE '20150103%' OR A.SUBJ_ID LIKE '201502%' OR
                          A.SUBJ_ID LIKE '20160102%' OR A.SUBJ_ID LIKE '20160103%' OR A.SUBJ_ID LIKE '201701%' OR A.SUBJ_ID LIKE '201702%'*/
                    A.SUBJ_ID LIKE '2015%'      )
                    THEN 'DR03'
                    ELSE 'DR01' END   --27  缴存准备金方式 --20221008 xuxiaobin modify
      ,NULL                           --28  部门条线
      ,'存单投资'                      --29  数据来源
      ,A.ACRU_INT  AS ACRU_INT   --30 应计利息
      ,TC.TAR_VALUE_CODE AS FIN_AST_CL --31 金融资产分类
      FROM O_ICL_CMM_CAP_BOND_INVEST A --资金债券投资
      LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO C  --债券基本信息 --20221008 xuxiaobin add
      ON A.BOND_ID = C.BOND_ID
      AND A.BOND_TYPE_CD = A.BOND_TYPE_CD
      AND C.DATA_SRC_SYS_IDF = 'CTMS' --资金
      AND A.ETL_DT = C.ETL_DT
      LEFT JOIN CODE_MAP TC --金融资产类型转码
        ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
       AND TC.SRC_CLASS_CODE = 'CD2060'
       AND TC.TAR_CLASS_CODE = 'D0048'
       AND TC.MOD_FLG = 'MDM'
     WHERE A.BOND_TYPE_CD = 'W' --W 为同业存单
  --   AND A.ISSUER_CUST_ID IS NOT NULL
       AND TO_CHAR(A.ETL_DT,'YYYYMMDD') =V_P_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

      -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CD_NO,COUNT(1)
      FROM M_CPTL_CD_INVEST_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CD_NO
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

  END ETL_INIT_M_CPTL_CD_INVEST_INFO;
/

