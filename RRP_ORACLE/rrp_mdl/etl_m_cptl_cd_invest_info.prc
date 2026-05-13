CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_CD_INVEST_INFO(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2
                                                     )
  /**************************************************************************
  *  程序名称：ETL_M_CPTL_CD_INVEST_INFO
  *  功能描述：存单投资信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_CD_INVEST_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  mw      首次创建
  *             2    20221114  hulj    增加数据重复校验
  *             3    20230414  mw      优化同业现券交易逻辑
  *             4    20240326  HYF     新增账簿类型区分银行账簿和交易账簿
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                                  --跑批数据日期
  V_STARTTIME DATE;                                         --处理开始时间
  V_ENDTIME   DATE;                                         --处理结束时间
  V_SQLMSG    VARCHAR2(300);                                --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);                                --任务名称
  V_PART_NAME VARCHAR2(100);                                --分区名
  V_STEP      INTEGER := 0;                                 --处理步骤
  V_SQLCOUNT  INTEGER := 0;                                 --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_CD_INVEST_INFO';     --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CPTL_CD_INVEST_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送';                    --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM M_CPTL_CD_INVEST_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CPTL_CD_INVEST_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
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
  ETL_PARTITION_ADD(I_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存单投资信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_CD_INVEST_INFO
    (DATA_DT                    --1  数据日期
    ,LGL_REP_ID                 --2  法人编号
    ,CUST_ID                    --3  客户编号
    ,ORG_ID                     --4  机构编号
    ,ACC_ID                     --5  账户编号
    ,CD_NO                      --6  存单号
    ,ACC_TYP                    --7  账户类型
    ,PROD_CL                    --8  产品分类
    ,CUR                        --9  币种
    ,BOOK_BAL                   --10  账面余额
    ,RECV_INT                   --11  应收利息
    ,ISU_DT                     --12  发行日期
    ,VAL_DT                     --13  起息日期
    ,EXP_DT                     --14  到期日期
    ,MKT_VAL                    --15  市场价值
    ,SUBJ_ID                    --16  科目编号
    ,LVL5_CL                    --17  五级分类
    ,CD_TRF_MODE                --18  存单转让方式
    ,PRO_IMPT                   --19  减值准备
    ,DEP_INS_AMT                --20  被存款保险制度覆盖的金额
    ,DUR                        --21  久期
    ,MOD_DUR                    --22  修正久期
    ,STATS_SUBJ_ID              --23  统计科目编号
    ,RATE                       --24  利率
    ,GL_CL                      --25  会计分类
    ,CRDT_LMT_ID                --26  授信额度编号
    ,DEP_RSV_MODE               --27  缴存准备金方式
    ,DEPT_LINE                  --28  部门条线
    ,DATA_SRC                   --29  数据来源
    ,ACRU_INT                   --30  应计利息
    ,FIN_AST_CL                 --31  金融资产分类
    ,ACCT_B_CATE_CD             --32  账簿类型
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')            --1  数据日期
        ,A.LP_ID                                 --2  法人编号
        ,A.ISSUER_CUST_ID                        --3  客户编号
        ,A.ENTRY_ORG_ID                          --4  机构编号
        ,A.BOND_ID                               --5  账户编号
        ,A.BOND_ID|| '_' || A.TRAN_ACCT_B_ID     --6  存单号
        ,A.ACCT_ATTR_CD                          --7  账户类型
        ,'1'                                     --8  产品分类
        ,A.CURR_CD                               --9  币种
        ,A.BOOK_BAL                              --10  账面余额
        ,A.INT_RECVBL                            --11  应收利息
        ,TO_CHAR(A.OPEN_DT,'YYYYMMDD')           --12  发行日期
        ,TO_CHAR(D.STL_DT,'YYYYMMDD')            --13  起息日期
        ,TO_CHAR(C.EXP_DT	,'YYYYMMDD')           --14  到期日期 --20221008 xuxiaobin modify
        ,A.BP_VAL                                --15  市场价值
        ,A.SUBJ_ID                               --16  科目编号
        ,NULL                                    --17  五级分类
        ,NULL                                    --18  存单转让方式
        ,NULL                                    --19  减值准备
        ,NULL                                    --20  被存款保险制度覆盖的金额
        ,NULL                                    --21  久期
        ,A.ESTIM_CORET_DURAN                     --22  修正久期
        ,NULL                                    --23  统计科目编号
        ,C.ISSUE_INT_RAT                         --24  利率
        ,NULL                                    --25  会计分类
        ,NULL                                    --26  授信额度编号
        ,CASE WHEN A.SUBJ_ID LIKE '2015%'
              THEN 'DR03'
              ELSE 'DR01'
          END                                    --27  缴存准备金方式 --20221008 xuxiaobin modify
        ,NULL                                    --28  部门条线
        ,'存单投资'                              --29  数据来源
        ,A.ACRU_INT                AS ACRU_INT   --30  应计利息
        ,TC.TAR_VALUE_CODE         AS FIN_AST_CL --31  金融资产分类
        ,CASE WHEN A.ACCT_ATTR_CD = 'T' THEN 'T' 
              ELSE 'B'
          END                      AS ACCT_B_CATE_CD  --32  账簿类型 T-交易账簿 B-银行账簿
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A --资金债券投资
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO C  --债券基本信息 --20221008 xuxiaobin add
      ON C.BOND_ID = A.BOND_ID
     AND A.BOND_TYPE_CD = C.BOND_TYPE_CD
     AND C.DATA_SRC_SYS_IDF = 'CTMS' --资金
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TC --金融资产类型转码
      ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
     AND TC.SRC_CLASS_CODE = 'CD2060'
     AND TC.TAR_CLASS_CODE = 'D0048'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT MAX(STL_DT) STL_DT,BOND_ID,TRAN_ACCT_B_ID,TRAN_DIR_CD
                 FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN A1 --资金现券交易
                WHERE A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY BOND_ID,TRAN_ACCT_B_ID,TRAN_DIR_CD ) D
      ON D.BOND_ID||'_'||D.TRAN_ACCT_B_ID = A.BOND_ID||'_'||A.TRAN_ACCT_B_ID
     AND D.TRAN_DIR_CD = '01'
   WHERE A.BOND_TYPE_CD = 'W' --W 为同业存单
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CD_NO,COUNT(1)
      FROM RRP_MDL.M_CPTL_CD_INVEST_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CD_NO
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);--表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_CD_INVEST_INFO;
/

