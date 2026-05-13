CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_TRA_INVEST_DTL(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_TRA_INVEST_DTL
  *  功能描述：监管集市银行所有对外投资业务信息
  *  创建日期：20220616
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CAP_SEC_TRAN     --资金现券交易表
  *            ICL.CMM_CAP_BOND_INVEST  --资金债券投资表
  *            ICL.CMM_BOND_BASIC_INFO  --债券基本信息表
  *            ICL.CMM_BOND_RATING_INFO --债券评级信息
  *  目标表：  M_TRA_INVEST_DTL --投资业务交易流水
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221122  hulj     增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_TRA_INVEST_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_BEG_THIS_MON DATE;
  V_TAB_NAME VARCHAR2(100) := 'M_TRA_INVEST_DTL'; --表名
  V_PART_NAME VARCHAR2(100);
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;
  V_BEG_THIS_MON := TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'MM');
  V_TAB_NAME := 'M_TRA_INVEST_DTL'; --表名
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


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入投资业务交易流水-资金系统(债券投资交易明细)数据信息';
  V_STARTTIME := SYSDATE;
  /*********************** 资金系统(债券投资交易明细) **************************/
  INSERT INTO RRP_MDL.M_TRA_INVEST_DTL
  (
  DATA_DT          --数据日期
  ,LGL_REP_ID      --法人编号
  ,ORG_ID          --机构编号
  ,ACC_ID          --账户编号
  ,SEQ_NO          --流水号
  ,ULYG_PROD_ID    --标的产品编号
  ,CUR             --币种
  ,BUY_SELL_FLG    --买入卖出标志
  ,TRA_AMT         --交易金额
  ,TRA_TM          --交易时间
  ,DEPT_LINE       --部门条线
  ,DATA_SRC        --数据来源
  )
  SELECT DISTINCT
   TO_CHAR(A1.STL_DT, 'YYYYMMDD')                                                           --数据日期
   ,S.LP_ID                                                                                 --法人编号
   ,T3.DEPARTMENTID                                                                          --机构编号
   ,A1.BOND_ID                                                                         --账户编号
   ,A1.TRAN_ID                                                                              --流水号
   ,/*NVL(TRIM(S.CUSTM_BOND_ID),NVL(SUBSTR(A.BOND_ID,1,INSTR(A.BOND_ID,'.')-1),A.BOND_ID))*/
   A1.BOND_ID    --标的产品编号 --20220909 xuxiaobin modify
   ,NVL(A1.CURR_CD,S.CURR_CD)                                                                               --币种
   ,DECODE(A1.TRAN_DIR_CD, '01', '1', '02', '0')                                            --买入卖出标志
   ,A1.BOND_FAC_VAL                                                                         --交易金额
   ,A1.STL_DT                                                                              --交易时间
   ,'00001' --营运管理部                                                                    --部门条线
   ,'资金债券投资'                                                                  --数据来源
   FROM O_ICL_CMM_CAP_SEC_TRAN A1  --资金现券交易表
    LEFT JOIN O_ICL_CMM_CAP_BOND_INVEST S  --资金债券投资表
      ON A1.BOND_ID = S.BOND_ID
     AND A1.TRAN_ACCT_B_ID = S.TRAN_ACCT_B_ID
     AND A1.ETL_DT = S.ETL_DT
    LEFT JOIN O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING T3 -- 账户部门编号映射表
      ON A1.TRAN_ACCT_B_ID = T3.KEEPFOLDER_ID
     AND (T3.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD') AND T3.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD'))
    LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO A --债券基本信息表
            ON A1.BOND_ID = A.BOND_ID
           AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN (SELECT ETL_DT, BOND_ID, RATING_REST_CD
               FROM (SELECT ETL_DT,
                            BOND_ID,
                            RATING_REST_CD,
                            ROW_NUMBER() OVER(PARTITION BY BOND_ID ORDER BY RATING_DT DESC) AS RN
                       FROM O_ICL_CMM_BOND_RATING_INFO
                      WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD'))
              WHERE RN = 1
             -- BY CHENRUIQIANG 2020-08-12 主键冲突
             ) B --债券评级信息表
    ON A.BOND_ID = B.BOND_ID
   AND A.ETL_DT = B.ETL_DT
   WHERE  A1.BOND_TYPE_CD <> 'W' --20221013 许晓滨ADD
   AND A1.TRAN_SRC_CD NOT IN('13','02') --根据旧监管修改
   AND A1.BUS_ID NOT IN (
   SELECT BUS_ID FROM O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL T WHERE BUS_CATE_NAME = '债券负债' AND  TRIM(BUS_TAB_NAME) = 'BONDSDEALS'
    )--根据提数脚本修改
   AND A1.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   AND TRUNC(A1.STL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'MM')--20221013 与安哥讨论，每天都拿，后面在讨论下
   ;
   --20221014 XUXIAOBIN ADD
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入投资业务交易流水-同业系统(债券投资交易明细)数据信息';
  V_STARTTIME := SYSDATE;
  /*********************** 同业系统(债券投资交易明细) **************************/
  INSERT INTO RRP_MDL.M_TRA_INVEST_DTL
  (
   DATA_DT         --数据日期
  ,LGL_REP_ID      --法人编号
  ,ORG_ID          --机构编号
  ,ACC_ID          --账户编号
  ,SEQ_NO          --流水号
  ,ULYG_PROD_ID    --标的产品编号
  ,CUR             --币种
  ,BUY_SELL_FLG    --买入卖出标志
  ,TRA_AMT         --交易金额
  ,TRA_TM          --交易时间
  ,DEPT_LINE       --部门条线
  ,DATA_SRC        --数据来源
  )
  SELECT DISTINCT
    TO_CHAR(A.CHG_DT,'YYYYMMDD')                                                          --数据日期
   ,E.LP_ID                                                                                 --法人编号
   ,INST.ORG_ID                                                                         --机构编号
   ,A.FIN_INSTM_ID || '.' || A.ASSET_TYPE_ID || '.' || A.MARKET_TYPE_ID                     --账户编号
   ,A.CHG_ID                                                                              --流水号
   ,A.FIN_INSTM_ID    --标的产品编号 --20220909 xuxiaobin modify
   ,D.CURR_CD                                                                               --币种
   ,CASE WHEN C.TRAN_TYPE_CD IN (/*'0000201',*/'0000000','0202100','0201100') THEN '1' --去掉0000201 MDF BY HAP 20211203,
                ELSE '0'
                END                                           --买入卖出标志
   ,ABS(CASE WHEN C.TRAN_TYPE_CD IN ('0000000','0202100','0201100') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT+A.INT_ADJ_AMT   --净价成本+应收未收净价成本+应计利息+应收未收应计利息+利息调整金额
                    WHEN C.TRAN_TYPE_CD IN ('0000001','0202101') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT+A.INT_ADJ_AMT-A.BS_PL    --净价成本+应收未收净价成本+应计利息+应收未收应计利息+利息调整金额-买卖损益
                    WHEN C.TRAN_TYPE_CD IN ('0000201','0000301') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.RECVBL_UNCOL_TURN_ACTL_RECV                                   --净价成本+应收未收净价成本+应收未收转实收
                    END)                                           --交易金额
   ,A.CHG_DT                                                                              --交易时间
   ,'00001' --营运管理部                                                                    --部门条线
   ,'债券投资同业'                                                                  --数据来源
   FROM O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H A  --证券账户核算余额变动历史
   LEFT JOIN O_IOL_IBMS_TTRD_ACC_SECU ACC
    ON A.INTNAL_VCH_ACCT_ID = ACC.ACCID
    AND (ACC.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD') AND ACC.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD'))
   LEFT JOIN O_IOL_IBMS_TTRD_INSTITUTION INST ON ACC.I_ID = INST.I_ID
   AND (INST.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD') AND INST.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD'))
   LEFT JOIN O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL B  --同业券指令明细
       ON A.INSTR_ID = B.SECU_INSTR_SEQ_NUM
     LEFT JOIN O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL C  --同业主指令明细
       ON C.MAIN_INSTR_SEQ_NUM = B.MAIN_INSTR_SEQ_NUM
     LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO D --债券基本信息表
      ON A.FIN_INSTM_ID = D.BOND_ID
      AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
      AND A.MARKET_TYPE_ID = D.BOND_MARKET_TYPE_CD
      AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN O_ICL_CMM_IBANK_BOND_INVEST E  --同业债券投资
      ON A.FIN_INSTM_ID = E.FIN_INSTM_ID
      AND A.EXT_VCH_ACCT_ID = E.EXT_SECU_ACCT_ID
      AND A.INTNAL_VCH_ACCT_ID = E.INTNAL_SECU_ACCT_ID
      AND E.ETL_DT  =TO_DATE(V_P_DATE, 'YYYYMMDD')
    WHERE C.TRAN_TYPE_CD IN ('0000301','0000000','0000001','0202100','0202101','0201100','0000201')
      AND A.REVO_RELA_CHG_ID = -1
      AND A.ACCTI_TYPE_CD = 'R'
      AND A.EXTRA_DIMEN_CD = 'L'
      AND D.BOND_CLS_NAME <> '同业存单'
      AND A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST <> 0
      AND TRUNC(A.CHG_DT,'MM') = TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'MM')--20221013 与安哥讨论，每天都拿，后面在讨论下
   ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  /*********************** 资金系统（债券投资现券收付息）**************************/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入投资业务交易流水-资金系统(债券投资现券收付息)数据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_TRA_INVEST_DTL
  (
  DATA_DT          --数据日期
  ,LGL_REP_ID      --法人编号
  ,ORG_ID          --机构编号
  ,ACC_ID          --账户编号
  ,SEQ_NO          --流水号
  ,ULYG_PROD_ID    --标的产品编号
  ,CUR             --币种
  ,BUY_SELL_FLG    --买入卖出标志
  ,TRA_AMT         --交易金额
  ,TRA_TM          --交易时间
  ,DEPT_LINE       --部门条线
  ,DATA_SRC        --数据来源
  )
  SELECT DISTINCT
   TO_CHAR(A.ACTL_PAY_DT,'YYYYMMDD')                                                         --数据日期
   ,S.LP_ID                                                                                 --法人编号
   ,S.ENTRY_ORG_ID                                                                          --机构编号
   ,A.BOND_CD                                                                               --账户编号
   ,A.QUOTE_TABLE_NAME || '_' || A.SRC_EVT_ID                                               --流水号
   ,/*NVL(TRIM(S.CUSTM_BOND_ID),NVL(SUBSTR(C.BOND_ID,1,INSTR(C.BOND_ID,'.')-1),C.BOND_ID))*/
     A.BOND_CD --标的产品编号
   ,S.CURR_CD                                                                               --币种
   ,'0'                                                                                     --买入卖出标志
   ,DECODE(S.DISCNT_DEBT_FLG,'1',A.RPP_AMT + A.PAY_INT_AMT,A.RPP_AMT)                       --交易金额
   ,A.ACTL_PAY_DT
   ,'00001' --营运管理部                                                                    --部门条线
   ,'债券投资-现券收付息(收回)'                                                                  --数据来源
   FROM O_IML_EVT_SEC_ACPT_PAY_INT A--现券收付息
      LEFT JOIN O_ICL_CMM_CAP_BOND_INVEST S --资金债券投资
        ON A.ACCT_ID = S.TRAN_ACCT_B_ID
       AND A.BOND_CD = S.BOND_ID
/*      LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO C    --债券基本信息
        ON A.BOND_CD = C.BOND_ID
       AND A.JOB_CD = C.JOB_CD
  LEFT JOIN (SELECT ETL_DT, BOND_ID, RATING_REST_CD
               FROM (SELECT ETL_DT,
                            BOND_ID,
                            RATING_REST_CD,
                            ROW_NUMBER() OVER(PARTITION BY BOND_ID ORDER BY RATING_DT DESC) AS RN
                       FROM O_ICL_CMM_BOND_RATING_INFO
                      WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD'))
              WHERE RN = 1
             ) B --债券评级信息表
    ON C.BOND_ID = B.BOND_ID
   AND C.ETL_DT = B.ETL_DT*/
   WHERE S.BOND_TYPE_CD <> 'W'
       AND A.RPP_AMT > 0 --只取还本金额大于0的
       AND S.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.ASSET_CATE_NAME in ('交易性金融资产','可供出售金融资产','持有至到期投资')
       AND TRUNC(A.ACTL_PAY_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入投资业务交易流水-同业非标投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_TRA_INVEST_DTL
  (
  DATA_DT          --数据日期
  ,LGL_REP_ID      --法人编号
  ,ORG_ID          --机构编号
  ,ACC_ID          --账户编号
  ,SEQ_NO          --流水号
  ,ULYG_PROD_ID    --标的产品编号
  ,CUR             --币种
  ,BUY_SELL_FLG    --买入卖出标志
  ,TRA_AMT         --交易金额
  ,TRA_TM
  ,FIN_INSTM_ID    --金融工具编号
  ,BUS_ID          --业务编号
  ,ASSET_THD_CLS_CD  --资产三分类代码
  ,DEPT_LINE       --部门条线
  ,DATA_SRC        --数据来源
  )
  SELECT
  TO_CHAR(A.CHG_DT,'YYYYMMDD')         --数据日期
  ,MIN(A.LP_ID)         --法人编号
  ,MIN(NVL(ACC.BELONG_ORG_ID,TI.BELONG_ORG_ID)) --机构编号
  ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID        --账户编号
  ,MIN(A.INSTR_ID) --流水号
  ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID  --标的产品编号
  ,TI.CURR_CD       --币种
  ,MIN(CASE WHEN V.TRAN_TYPE_CD IN ('0170001','0170301','0702111','0702111_F','0702111_L','0700101','0700101_L','0170531','0706071',
   '0700111','0700111_F','0700111_L','0100531') OR V.TRAN_TYPE_CD LIKE '%001' THEN 0 ELSE 1 END)
  ,SUM(ABS(CASE WHEN TI.PROD_TYPE_CD IN ('0170') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.RECVBL_UNCOL_TURN_ACTL_RECV +ABS(A.FEE)
                        WHEN TI.PROD_TYPE_CD IN ('0706') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT+A.RECVBL_UNCOL_TURN_ACTL_RECV
                        WHEN TI.PROD_TYPE_CD IN ('0700') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST-A.BS_PL
                        WHEN TI.PROD_TYPE_CD IN ('0703') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST-A.NON_AMORT_BS_PL
                        ELSE A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.RECVBL_UNCOL_TURN_ACTL_RECV +ABS(A.FEE)+A.EVHA_VAL_CHAG
                        END))      --交易金额
  ,A.CHG_DT  --交易时间
  ,NULL  --金融工具编号
  ,NULL          --业务编号
  ,NULL   --资产三分类代码
  ,'00001'--营运管理部
  ,'特定目的载体交易明细'
  FROM O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H A --证券账户核算余额变动历史
     LEFT JOIN(SELECT ROW_NUMBER()OVER(PARTITION BY T.BELONG_ORG_ID,T.FIN_INSTM_ID,T.ASSET_TYPE_ID,T.MARKET_TYPE_ID ORDER BY T.BELONG_ORG_ID) RN
                   ,T.* FROM O_ICL_CMM_IBANK_SECU_POST T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))ACC
      ON A.FIN_INSTM_ID = ACC.FIN_INSTM_ID
     AND A.ASSET_TYPE_ID = ACC.ASSET_TYPE_ID
     AND A.MARKET_TYPE_ID = ACC.MARKET_TYPE_ID
     AND A.EXT_VCH_ACCT_ID = ACC.EXT_SECU_ACCT_ID
     AND A.INTNAL_VCH_ACCT_ID = ACC.INTNAL_SECU_ACCT_ID
     AND ACC.RN = 1
    LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM TI --同业金融工具
      ON A.FIN_INSTM_ID = TI.FIN_INSTM_ID
     AND A.ASSET_TYPE_ID = TI.ASSET_TYPE_ID
     AND A.MARKET_TYPE_ID = TI.MARKET_TYPE_ID
     AND TI.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL SE --同业券指令明细
      ON A.INSTR_ID = SE.SECU_INSTR_SEQ_NUM
    LEFT JOIN O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL V --同业主指令明细
      ON V.MAIN_INSTR_SEQ_NUM = SE.MAIN_INSTR_SEQ_NUM

    WHERE TI.PROD_TYPE_CD IN ('0170','0700','0702','0703','0704','0705','0706','0713')
    AND A.REVO_RELA_CHG_ID = -1  --撤销关联变动编号
    AND V.TRAN_TYPE_CD NOT IN ('0702381','0700381','0702241','0170201')

    /*AND (CASE WHEN TI.PROD_TYPE_CD NOT IN (\*'0700',*\'0170') AND V.TRAN_TYPE_CD LIKE '%001'
    THEN ABS(A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT+A.INT_ADJ_AMT+A.EVHA_VAL_CHAG)
              ELSE ABS(A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.RECVBL_UNCOL_TURN_ACTL_RECV )
              END) <> 0*/
    AND TRUNC(A.CHG_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
    AND V.CNTPTY_ID <> 0

      AND (A.FIN_INSTM_ID,A.CHG_DT,
      CASE WHEN V.TRAN_TYPE_CD IN ('0170001','0170301','0702111','0702111_F','0702111_L','0700101','0700101_L','0170531','0706071',
   '0700111','0700111_F','0700111_L','0100531') OR V.TRAN_TYPE_CD LIKE '%001' THEN 0 ELSE 1 END)
   NOT IN
   (SELECT A.FIN_INSTM_ID,A.CHG_DT,
      CASE WHEN V.TRAN_TYPE_CD IN ('0170001','0170301','0702111','0702111_F','0702111_L','0700101','0700101_L','0170531','0706071',
   '0700111','0700111_F','0700111_L','0100531') OR V.TRAN_TYPE_CD LIKE '%001' THEN 0 ELSE 1 END
                                FROM O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H A
                                LEFT JOIN O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL SE --同业券指令明细
      ON A.INSTR_ID = SE.SECU_INSTR_SEQ_NUM
    LEFT JOIN O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL V --同业主指令明细
      ON V.MAIN_INSTR_SEQ_NUM = SE.MAIN_INSTR_SEQ_NUM
                                LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM TI --同业金融工具
      ON A.FIN_INSTM_ID = TI.FIN_INSTM_ID
     AND A.ASSET_TYPE_ID = TI.ASSET_TYPE_ID
     AND A.MARKET_TYPE_ID = TI.MARKET_TYPE_ID
     AND TI.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
                               WHERE TRUNC(A.CHG_DT, 'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                               GROUP BY A.FIN_INSTM_ID,A.CHG_DT,
                               CASE WHEN V.TRAN_TYPE_CD IN ('0170001','0170301','0702111','0702111_F','0702111_L','0700101','0700101_L','0170531','0706071',
   '0700111','0700111_F','0700111_L','0100531') OR V.TRAN_TYPE_CD LIKE '%001' THEN 0 ELSE 1 END
    HAVING SUM(ABS(CASE WHEN TI.PROD_TYPE_CD IN ('0170') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST  +ABS(A.FEE)
                        WHEN TI.PROD_TYPE_CD IN ('0706') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT
                        WHEN TI.PROD_TYPE_CD IN ('0700') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST-A.BS_PL
                        WHEN TI.PROD_TYPE_CD IN ('0703') THEN A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST-A.NON_AMORT_BS_PL
                        ELSE A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST  +ABS(A.FEE)+A.EVHA_VAL_CHAG
                        END))=0
                               )--剔除当月本金发生额为0的特定目的载体


    GROUP BY TI.CURR_CD,A.CHG_DT,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID/*,V.MAIN_INSTR_SEQ_NUM*/,TI.FAC_VAL_INT_RAT

    ;

       V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
  /*V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入投资业务交易流水-同业非标投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_TRA_INVEST_DTL
  (
  DATA_DT          --数据日期
  ,LGL_REP_ID      --法人编号
  ,ORG_ID          --机构编号
  ,ACC_ID          --账户编号
  ,SEQ_NO          --流水号
  ,ULYG_PROD_ID    --标的产品编号
  ,CUR             --币种
  ,BUY_SELL_FLG    --买入卖出标志
  ,TRA_AMT         --交易金额
  ,TRA_TM
  ,FIN_INSTM_ID    --金融工具编号
  ,BUS_ID          --业务编号
  ,ASSET_THD_CLS_CD  --资产三分类代码
  ,DEPT_LINE       --部门条线
  ,DATA_SRC        --数据来源
  )
  SELECT
  V_P_DATE         --数据日期
  ,A.LP_ID         --法人编号
  ,A.BELONG_ORG_ID --机构编号
  ,A.OBJ_ID        --账户编号
  ,A.COMB_TRAN_NUM --流水号
  ,A.FIN_INSTM_ID  --标的产品编号
  ,A.CURR_CD       --币种
  ,'1'
  ,A.TRAN_AMT      --交易金额
  ,A.LAST_UPDATE_DT  --交易时间
  ,A.FIN_INSTM_ID  --金融工具编号
  ,A.BUS_ID          --业务编号
  ,A.ASSET_THD_CLS_CD   --资产三分类代码
  ,'00001'--营运管理部
  ,SUBSTR(A.JOB_CD,0,4)
  FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A  --同业非标投资表
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME NOT LIKE '%货币基金%'
    AND TRIM(A.SUBJ_ID) IS NOT NULL
    AND A.LAST_UPDATE_DT >= V_BEG_THIS_MON
    AND A.LAST_UPDATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD');

       V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入投资业务交易流水-同业净值型产品投资';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_TRA_INVEST_DTL
  (
  DATA_DT          --数据日期
  ,LGL_REP_ID      --法人编号
  ,ORG_ID          --机构编号
  ,ACC_ID          --账户编号
  ,SEQ_NO          --流水号
  ,ULYG_PROD_ID    --标的产品编号
  ,CUR             --币种
  ,BUY_SELL_FLG    --买入卖出标志
  ,TRA_AMT         --交易金额
  ,TRA_TM
  ,FIN_INSTM_ID    --金融工具编号
  ,BUS_ID          --业务编号
  ,ASSET_THD_CLS_CD  --资产三分类代码
  ,DEPT_LINE       --部门条线
  ,DATA_SRC        --数据来源
  )
  SELECT
    V_P_DATE         --数据日期
  ,A.LP_ID         --法人编号
  ,A.BELONG_ORG_ID --机构编号
  ,A.OBJ_ID        --账户编号
  ,A.COMB_TRAN_NUM --流水号
  ,A.FIN_INSTM_ID  --标的产品编号
  ,A.CURR_CD       --币种
  ,'1'
  ,A.BOOK_BAL      --交易金额
  ,A.LAST_UPDATE_DT --交易时间
  ,A.FIN_INSTM_ID  --金融工具编号
  ,A.BUS_ID          --业务编号
  ,A.ASSET_THD_CLS_CD   --资产三分类代码
  ,'00001'--营运管理部
  ,SUBSTR(A.JOB_CD,0,4)
  FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A  --同业净值型产品投资
  \*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*\
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM B --同业金融工具
    ON A.FIN_INSTM_ID = B.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = B.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = B.MARKET_TYPE_ID
   AND A.ETL_DT = B.ETL_DT
  LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO C --债券基本信息
    ON C.BOND_ID = A.FIN_INSTM_ID
   AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
   AND CASE WHEN C.DATA_SRC_SYS_IDF='CTMS' THEN 'X_CNBD' ELSE C.BOND_MARKET_TYPE_CD END = A.MARKET_TYPE_ID
   AND C.ETL_DT = A.ETL_DT
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_DATEID,1,6))
    AND A.LAST_UPDATE_DT >= V_BEG_THIS_MON
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;*/

    -- 增加数据重复校验 --
       WITH TMP1 AS (
  SELECT DATA_DT,SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_INVEST_DTL T
   WHERE SUBSTR(DATA_DT,1,6) = SUBSTR(V_P_DATE,1,6)
   GROUP BY DATA_DT,SEQ_NO,ACC_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_TRA_INVEST_DTL;
/

