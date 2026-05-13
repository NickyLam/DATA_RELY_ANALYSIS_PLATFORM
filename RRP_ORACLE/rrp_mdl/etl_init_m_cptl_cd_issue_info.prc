CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CPTL_CD_ISSUE_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CPTL_CD_ISSUE_INFO
  *  功能描述：存单发行信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_CD_ISSUE_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  梅炜     首次创建
  *             2    20220822  hulj     调整取数逻辑，修改同业资金客户号取值
  *             3    20220901  hulj     新增字段科目号
  *             4    20221114  hulj     增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CPTL_CD_ISSUE_INFO'; -- 程序名称
  V_DATE   DATE; --数据日期(判断输入参数日期格式是否准确)
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
  V_TAB_NAME := 'M_CPTL_CD_ISSUE_INFO'; --表名
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
  V_STEP_DESC := '插入存单发行信息--大额存单';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_CD_ISSUE_INFO
 (
      DATA_DT  --1  数据日期
      ,LGL_REP_ID  --2  法人编号
      ,CUST_ID  --3  客户编号
      ,ORG_ID  --4  机构编号
      ,ACC_ID  --5  账户编号
      ,CNTPR_ID  --6  交易对手编号
      ,CD_NO  --7  存单号
      ,PBC_ACC_TYP  --8  人行账户类型
      ,ACC_TYP  --9  账户类型
      ,PROD_CL  --10  产品分类
      ,CUR  --11  币种
      ,BOOK_BAL  --12  账面余额
      ,PBL_INT  --13  应付利息
      ,ISU_DT  --14  发行日期
      ,VAL_DT  --15  起息日期
      ,EXP_DT  --16  到期日期
      ,MKT_VAL  --17  市场价值
      ,DEP_INS_AMT  --18  被存款保险制度覆盖的金额
      ,DUR  --19  久期
      ,MOD_DUR  --20  修正久期
      ,OPEN_ACC_TLR_NO  --21  开户柜员号
      ,CNL_ACC_DT  --22  销户日期
      ,ACC_STAT  --23  账户状态
      ,LAST_ACC_CHG_DT  --24  上次动户日期
      ,OPEN_ACC_AMT  --25  开户金额
      ,DEP_STABLE_CL  --26  存款稳定性分类
      ,RATE  --27  利率
      ,GL_CL  --28  会计分类
      ,BIO_FLG  --29  境内外标志
      ,DEP_RSV_MODE  --30  缴存准备金方式
      ,DEPT_LINE  --31  部门条线
      ,DATA_SRC  --32  数据来源
      ,SUB_ACC_ID  --33 子账户编号
      ,SUBJ_ID    --34 科目编号
      ,C_DEPOSIT_TYPE  --35单位存款类型
      ,SRC_CUST_ID --穿透前客户号
      ,FROZ_FLG --冻结标志
      ,STOP_PAY_STATUS_CD --止付状态代码
      ,LG_FROZ_FLG --司法冻结标志
      )
      SELECT
      TO_CHAR(A.ETL_DT, 'YYYYMMDD')  --1  数据日期
      ,A.LP_ID  --2  法人编号
      ,A.CUST_ID  --3  客户编号
      ,A.BELONG_ORG_ID  --4  机构编号
      ,A.CUST_ACCT_ID  --5  账户编号
      ,A.CUST_ID  --6  交易对手编号
      ,NULL  --7  存单号
      ,A.ACCT_CLS_CD  --8  人行账户类型
      ,A.ACCT_TYPE_CD  --9  账户类型
      ,'2'  --10  产品分类  储种代码
      ,A.CURR_CD  --11  币种
      ,A.CURRT_BAL  --12  账面余额
      ,A.CURRT_ACRU_INT  --13  应付利息
      ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')  --14  发行日期
      ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')  --15  起息日期
      ,TO_CHAR(A.EXP_DT,'YYYYMMDD')  --16  到期日期
      ,NULL  --17  市场价值
      ,NULL  --18  被存款保险制度覆盖的金额
      ,NULL  --19  久期
      ,NULL  --20  修正久期
      ,A.OPEN_ACCT_TELLER_ID  --21  开户柜员号
      ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')  --22  销户日期
      ,/*CASE WHEN A.DEP_ACCT_STATUS_CD IN ('01', '06') THEN '02'   --01表示关闭,06表示结清
               WHEN A.DEP_ACCT_STATUS_CD = '02' THEN '01'            --02表示正常
               WHEN A.DEP_ACCT_STATUS_CD = '03' THEN '04' --03,04分别表示部分冻结，全额冻结
               WHEN A.DEP_ACCT_STATUS_CD = '04' THEN '05'
               WHEN A.DEP_ACCT_STATUS_CD = '05' THEN '09'            --05表示不进不出-未使用.
               WHEN A.DEP_ACCT_STATUS_CD = '07' THEN '9901'          --07预开户                              \*新增码值 20220602 XUCX*\
          ELSE '99' END */
       A.DEP_ACCT_STATUS_CD                                                                                      --存款账户状态
      ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT,'YYYYMMDD')  --24  上次动户日期
      ,A.OPEN_ACCT_AMT                            --25  开户金额
      ,NULL  --26  存款稳定性分类
      ,A.EXEC_INT_RAT  --27  利率
      ,NULL  --28  会计分类
      ,'Y'  --29  境内外标志
      ,NULL  --30  缴存准备金方式
      ,NULL  --31  部门条线
      ,'大额存单_存款分户'  --32  数据来源
      ,A.CUST_ACCT_SUB_ACCT_NUM --33 子账户编号
      ,A.SUBJ_ID --34 科目编号
      ,CASE WHEN E.DEPOSITR_CATE_CD = '101'   --企业法人
            THEN 'A'
            WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN ('CZCK','-')  --103 机关
            THEN 'B'
            WHEN A.DEP_CHAR_CD IN ('1','JJSB')   --'JJSB' 基金社保
            THEN 'C'
            WHEN E.DEPOSITR_CATE_CD IN ('106', '107')
            THEN 'D'
            WHEN A.DEP_CHAR_CD IN( '2','GJJ')
            THEN 'E'   --MDF BY WZJ 20211228 区分社保基金跟机关团体存款
            WHEN E.CUST_ID IS NOT NULL THEN 'A'
          END
      ,A.CUST_ID  AS SRC_CUST_ID
      ,A.FROZ_FLG AS FROZ_FLG --冻结标志
      ,A.STOP_PAY_STATUS_CD AS STOP_PAY_STATUS_CD --止付状态代码
      ,CASE WHEN DJ.DEP_SUB_ACCT_ID IS NOT NULL THEN '1' ELSE '0' END  AS LG_FROZ_FLG --司法冻结标志
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A  --存款分户信息
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E   --对公客户信息表 区分社保或财政性 add by20220707  xucx
      ON A.CUST_ID = E.CUST_ID
      AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN (
        SELECT DISTINCT DEP_SUB_ACCT_ID
        FROM RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL --存款账户冻结止付明细
        WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD') AND FROZ_STOP_PAY_BUS_WAY_CD IN ('004','005') --司法冻结
        AND FROZ_STOP_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --冻结开始日期
        AND FROZ_END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')--冻结截止日期
      ) DJ
      ON A.ACCT_ID = DJ.DEP_SUB_ACCT_ID
      WHERE  A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.SUBJ_ID IN ('20110103','20110203')
      ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金系统-同业存单';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_CD_ISSUE_INFO
          (
      DATA_DT  --1  数据日期
      ,LGL_REP_ID  --2  法人编号
      ,CUST_ID  --3  客户编号
      ,ORG_ID  --4  机构编号
      ,ACC_ID  --5  账户编号
      ,CNTPR_ID  --6  交易对手编号
      ,CD_NO  --7  存单号
      ,PBC_ACC_TYP  --8  人行账户类型
      ,ACC_TYP  --9  账户类型
      ,PROD_CL  --10  产品分类
      ,CUR  --11  币种
      ,BOOK_BAL  --12  账面余额
      ,PBL_INT  --13  应付利息
      ,ISU_DT  --14  发行日期
      ,VAL_DT  --15  起息日期
      ,EXP_DT  --16  到期日期
      ,MKT_VAL  --17  市场价值
      ,DEP_INS_AMT  --18  被存款保险制度覆盖的金额
      ,DUR  --19  久期
      ,MOD_DUR  --20  修正久期
      ,OPEN_ACC_TLR_NO  --21  开户柜员号
      ,CNL_ACC_DT  --22  销户日期
      ,ACC_STAT  --23  账户状态
      ,LAST_ACC_CHG_DT  --24  上次动户日期
      ,OPEN_ACC_AMT  --25  开户金额
      ,DEP_STABLE_CL  --26  存款稳定性分类
      ,RATE  --27  利率
      ,GL_CL  --28  会计分类
      ,BIO_FLG  --29  境内外标志
      ,DEP_RSV_MODE  --30  缴存准备金方式
      ,DEPT_LINE  --31  部门条线
      ,DATA_SRC  --32  数据来源
      ,SUB_ACC_ID  --33 子账户编号
      ,SUBJ_ID    --34 科目编号
      ,CNTPTY_NAME --35交易对手名称
      ,SRC_CUST_ID --穿透前客户号
      ,SPV_ID      --SPV编号
      ,C_DEPOSIT_TYPE  --单位存款类型
      ,FROZ_FLG --冻结标志
      ,STOP_PAY_STATUS_CD --止付状态代码
      ,LG_FROZ_FLG --司法冻结标志
      )
      SELECT
       TO_CHAR(T.ETL_DT, 'YYYYMMDD'), --1  数据日期
       T.LP_ID, --2  法人编号
       T.CNTPTY_ID,  --3  客户编号
       A.ENTRY_ORG_ID, --4  机构编号
       T.TRAN_ACCT_ID, --5  账户编号
       T.CNTPTY_ID, --6  交易对手编号
       T.BOND_ID||'_'||T.TRAN_ACCT_B_ID, --7  存单号
       NULL, --8  人行账户类型
       NULL, --8  账户类型
       '1' AS PROD_CL, --10  产品分类  同业存单
       A.CURR_CD, --11  币种
       T.BOND_FAC_VAL, --12  账面余额    债券面值
       T.ACRU_INT, --13  应付利息    应计利息
       B.ISSUE_DT, --14  发行日期
       TO_CHAR(B.VALUE_DT, 'YYYYMMDD'), --15  起息日期
       TO_CHAR(B.EXP_DT, 'YYYYMMDD'), --16  到期日期
       NULL, --17  市场价值
       NULL, --18  被存款保险制度覆盖的金额
       NULL, --19  久期
       NULL, --20  修正久期
       NULL, --21  开户柜员号
       NULL, --22  销户日期
       '01', --23  账户状态   0新建，1正常，3停用，null未知
       NULL, --24  上次动户日期
       NULL, --25  开户金额
       NULL, --26  存款稳定性分类
       B.ISSUE_INT_RAT, --27  利率
       NULL, --28  会计分类
       NULL, --29  境内外标志
       NULL, --30  缴存准备金方式
       'Y', --31  部门条线
       '资金现券交易'  , --32数据来源
       NULL, --33子账户编号
       A.SUBJ_ID, --34 科目编号
       T.CNTPTY_NAME,  --35交易对手名称
       NULL,           --穿透前客户号
       NULL,           --SPV编号
       NULL            --单位存款类型
      ,NULL FROZ_FLG --冻结标志
      ,NULL STOP_PAY_STATUS_CD --止付状态代码
      ,NULL LG_FROZ_FLG --司法冻结标志
 FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN T --资金现券交易
  INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
     ON T.BOND_ID = A.BOND_ID
    AND T.ETL_DT = A.ETL_DT
  INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
     ON A.BOND_ID = B.BOND_ID
    AND A.ETL_DT = B.ETL_DT
  /*LEFT JOIN O_IML_PTY_CAP_CNTPTY_INFO C --资金交易对手信息   --资金现卷交易表的交易对手编号和客户号都是空值，如何处理？
  ON    T.CNTPTY_ID=C.CNTPTY_ID
  T.ETL_DT=C.ETL_DT*/
  WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND A.ASSET_TYPE_NAME = '债券发行'
    AND T.BOND_TYPE_CD = 'W'   --同业存单发行
    AND B.BOND_TYPE_CD IN ('7','71','X','Y')
    AND T.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(A.SUBJ_ID) IS NOT NULL
    AND T.TRAN_DIR_CD='02'--交易方向01买入02卖出
  --20221008 XUXIAOBIN ADD
    UNION ALL

    SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD'), --1  数据日期
       A.LP_ID, --2  法人编号
       COALESCE(TRIM(D.PARTY_ID),TRIM(B.CUST_ID),/*TRIM(CM.CUST_ID),*/TRIM(B.PARTY_ID),TRIM(B.SRC_PARTY_ID),TRIM(A.OBJ_ID)),--NVL(TRIM(H.CUST_ID), NVL(TRIM(H.SRC_PARTY_ID), '-')),  --3  客户编号
       A.BELONG_ORG_ID, --4  机构编号
       A.FIN_INSTM_ID, --5  账户编号
       C.CNTPTY_ID, --6  交易对手编号
       A.FIN_INSTM_ID || '.' || A.BUS_ID, --7  存单号
       '',  -- 8 人行账户类型
       'T',   -- 9 账户类型
       '1' AS PROD_CL, --10  产品分类  同业存单
       A.CURR_CD, --11  币种
       /*ABS(A.CURRT_BAL)*/ABS(A.ACTL_BAL + A.INT_ADJ_AMT), --12  账面余额   --20221103 XUXIAOBIN与总账对平调整
       ABS(A.CURRT_ACRU_INT), --13  应付利息
       NULL, --14  发行日期
       TO_CHAR(E.VALUE_DT, 'YYYYMMDD'), --15  起息日期
       TO_CHAR(NVL(T.CASH_DT,E.EXP_DT), 'YYYYMMDD'), --16  到期日期
       NULL, --17  市场价值
       NULL, --18  被存款保险制度覆盖的金额
       NULL, --19  久期
       NULL, --20  修正久期
       NULL, --21  开户柜员号
       NULL, --22  销户日期
       CASE WHEN A.INTNAL_SECU_ACCT_STATUS_CD IN ('0','1') THEN '01'  --23  账户状态   0新建，1正常，3停用，null未知
         ELSE '99'END,
       NULL, --24  上次动户日期
       NULL, --25  开户金额
       NULL, --26  存款稳定性分类
       A.ACTL_INT_RAT, --27  利率
       NULL, --28  会计分类
       'Y', --29  境内外标志
       CASE WHEN (/*A.SUBJ_ID LIKE '201202%' OR A.SUBJ_ID LIKE '20150102%' OR A.SUBJ_ID LIKE '20150103%' OR A.SUBJ_ID LIKE '201502%' OR
                          A.SUBJ_ID LIKE '20160102%' OR A.SUBJ_ID LIKE '20160103%' OR A.SUBJ_ID LIKE '201701%' OR A.SUBJ_ID LIKE '201702%'*/
                          A.SUBJ_ID LIKE '2015%' )
                    THEN 'DR03'
                    ELSE 'DR01' END, --30  缴存准备金方式
       NULL, --31  部门条线
       '同业证券持仓'  , --32数据来源
       A.OBJ_ID, --33子账户编号
       A.SUBJ_ID, --34 科目编号
       B.PARTY_NAME,
       COALESCE(TRIM(B.CUST_ID),TRIM(B.SRC_PARTY_ID),TRIM(A.OBJ_ID)),
       D.SPV_ID,
       NULL       --单位存款类型
      ,NULL FROZ_FLG --冻结标志
      ,NULL STOP_PAY_STATUS_CD --止付状态代码
      ,NULL LG_FROZ_FLG --司法冻结标志
  FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表 A
  /*LEFT JOIN (SELECT INTNAL_TRAN_NUM,
                    CNTPTY_ID,
                    QUOTE_TRAN_NUM,
                   ROW_NUMBER() OVER( PARTITION BY INTNAL_TRAN_NUM ORDER BY CFM_DT||ENTR_TM) AS RM
             FROM RRP_MDL.O_IML_EVT_IBANK_TRAN
        ) C --同业交易表
    ON A.TRAN_NUM = C.INTNAL_TRAN_NUM
    AND C.RM = 1*/
   LEFT JOIN O_IML_EVT_IBANK_TRAN C --同业交易表
      ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
     AND A.MARKET_TYPE_ID = C.TRAN_MARKET_ID
     AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
     AND A.EXT_SECU_ACCT_ID  = C.EXT_SECU_ACCT_ID
     AND A.INTNAL_SECU_ACCT_ID = C.INTNAL_SECU_ACCT_ID
     --AND A.BUS_ID = C.TRAN_NUM
     AND A.BUS_ID = C.INTNAL_TRAN_NUM
     AND A.ETL_DT = C.ETL_DT
   --AND A.ETL_DT <= C.ETL_DT
   LEFT JOIN O_IML_EVT_IBANK_TRAN C1 --同业交易表
      ON C.QUOTE_TRAN_NUM = C1.TRAN_NUM
      AND C1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN O_IML_AGT_IBANK_DEP_RCPT T  --同业存单表
      ON A.FIN_INSTM_ID = T.DEP_RCPT_CD
     AND A.ASSET_TYPE_ID  = T.ASSET_TYPE_CD
     AND A.MARKET_TYPE_ID  = T.MARKET_TYPE_CD
     AND '101007'||C1.INTNAL_TRAN_NUM = T.VOUCH_ID
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT SRC_PARTY_ID,
                      CUST_ID,
                      PARTY_ID,
                      PARTY_NAME,
                      ROW_NUMBER() OVER( PARTITION BY SRC_PARTY_ID ORDER BY 1) AS RM
              FROM  O_IML_PTY_IBANK_CNTPTY_INFO  --同业交易对手信息
              ) B
    ON B.SRC_PARTY_ID = C.CNTPTY_ID
    AND B.RM=1
  LEFT JOIN (
       SELECT ROW_NUMBER() OVER(PARTITION BY SPV_CUST_ID ORDER BY END_DT DESC) AS RM,
              SPV_CUST_ID,
              PARTY_ID,
              SPV_ID
       FROM RRP_MDL.O_IML_PTY_SPV_CUST_INFO
  )D    --SPV 客户号
  ON COALESCE(TRIM(B.CUST_ID),TRIM(B.SRC_PARTY_ID),TRIM(A.OBJ_ID))=D.SPV_CUST_ID
  AND D.RM=1  -- MD 20220820 XUCX
  --AND B.ETL_DT = A.ETL_DT

  /*LEFT JOIN PTY_IBANK_CNTPTY_INFO_CM CM --同业交易对手信息补充表（补录数据）
  ON C.CNTPTY_ID=CM.CNTPTY_ID
  AND CM.START_DT <=  V_DATEID
  AND CM.END_DT >= V_DATEID*/
   LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM E  --同业金融工具表
      ON A.FIN_INSTM_ID = E.FIN_INSTM_ID
     AND A.MARKET_TYPE_ID = E.MARKET_TYPE_ID
     AND A.ASSET_TYPE_ID = E.ASSET_TYPE_ID
     AND A.ETL_DT = E.ETL_DT
 WHERE
     A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   AND A.ASSET_TYPE_NAME LIKE '%同业存单%'
   --AND TRIM(A.SUBJ_ID) IS NOT NULL
   --AND ABS(A.CURRT_BAL)>0 20221031发生额不能剔除0余额
  ;
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
    SELECT DATA_DT, ACC_ID||SUB_ACC_ID,COUNT(1)
      FROM M_CPTL_CD_ISSUE_INFO T
     WHERE DATA_DT = V_P_DATE
     AND T.PROD_CL = '2'
    GROUP BY DATA_DT, ACC_ID||SUB_ACC_ID
    HAVING COUNT(1) > 1
    UNION ALL
    SELECT DATA_DT, CD_NO,COUNT(1)
      FROM M_CPTL_CD_ISSUE_INFO T
     WHERE DATA_DT = V_P_DATE
     AND T.PROD_CL = '1'
    GROUP BY DATA_DT, CD_NO
    HAVING COUNT(1) > 1
    )
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;


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

  END ETL_INIT_M_CPTL_CD_ISSUE_INFO
;
/

