CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_SPL_CHAIN_DTL(I_P_DATE IN INTEGER,
                                                     O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_SPL_CHAIN_DTL
  *  功能描述：供应链业务明细表--手工报表专用
  *  创建日期：20221227
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO  对公贷款合同信息
             RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO 对公贷款借据信息
             RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO 对公客户基本信息表
             RRP_MDL.O_ICL_CMM_STD_PROD_INFO  标准产品信息
             RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO  对公贷款申请信息
             RRP_MDL.M_PUM_ORG_INFO 机构表
  *  目标表：RRP_MDL.M_MRPT_SPL_CHAIN_DTL 供应链业务明细表
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221227  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_SPL_CHAIN_DTL'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_MRPT_SPL_CHAIN_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入供应链业务明细表-手工报表专用';
  D_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_MRPT_SPL_CHAIN_DTL
  (
    DATA_DT,            --数据日期
    CUST_ID,            --客户号
    CUST_NAME,          --客户名称
    CONT_ID,            --业务合同号
    DUBIL_ID,           --借据号
    ORG_FH,             --业务归属分行
    ORG_ZH,             --业务支行
    SPL_CHAIN_PROD,     --供应链金融业务产品
    BUS_BREED_NAME,     --业务品种
    CORP_SIZE,          --企业规模
    DUBIL_AMT,          --出账金额
    DISTR_DT,           --业务起始日
    APOT_EXP_DT,        --业务终止日
    DUBIL_BAL,          --合同余额
    MARGIN_RATIO,       --初始保证金比例
    MARGIN_AMT,         --保证金余额
    BASE_RAT,           --基准利率
    EXEC_INT_RAT,       --实际利率
    COMM_FEE_RAT,       --保理业务手续费率
    O_USE_LMT_ALL_ID    --他用额度所有人编号
  )
  SELECT /*+USE_HASH(A B) LEADING(A)*/
        V_P_DATE DATE_ID    --数据日期
       ,B.CUST_ID             --客户号
       ,B.CUST_NAME            --客户名称
       ,B.CONT_ID             --业务合同号
       ,B.DUBIL_ID            --借据号
       ,B.SSFH ORG_FH         --业务归属分行
       ,B.SSZH ORG_ZH         --业务支行
       ,A.SPL_CHAIN_PROD      --供应链金融业务产品
       ,B.BUS_BREED_NAME      --业务品种
       ,B.CORP_SIZE           --企业规模,
       ,B.DUBIL_AMT  --出账金额
       ,TO_CHAR(B.DISTR_DT,'YYYYMMDD') DISTR_DT       --业务起始日
       ,TO_CHAR(B.APOT_EXP_DT,'YYYYMMDD') APOT_EXP_DT       --业务终止日
       ,B.DUBIL_BAL  --合同余额
       ,A.MARGIN_RATIO  --初始保证金比例
       ,A.MARGIN_AMT     --保证金余额
       ,B.BASE_RAT  --基准利率
       ,B.EXEC_INT_RAT  --实际利率
       ,A.COMM_FEE_RAT  --保理业务手续费率
       ,C.O_USE_LMT_ALL_ID  --他用额度所有人编号
  FROM  (SELECT CONT_ID,       --业务合同号
                CUST_ID,       --客户号
                CASE WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='00' THEN '未知'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='01' THEN '国内保理'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='02' THEN '保兑仓'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='03' THEN '反向保理'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='04' THEN '融资租赁保理'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='05' THEN '再保理'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='06' THEN '商业承兑汇票保贴'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='07' THEN '货押融资'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='08' THEN '订单融资'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='09' THEN '套保贷'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='10' THEN '其他类供应链金融产品'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='11' THEN '预付款融资（非保兑仓模式）'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='12' THEN '应收账款质押融资'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='13' THEN '兴付贷'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='14' THEN '兴链贷'
                     WHEN SUP_CHAIN_FIN_BUS_PROD_CLS_CD ='15' THEN '企业法人汽车按揭贷款'
                     END  SPL_CHAIN_PROD ,--供应链金融业务产品分类代码
                MARGIN_RATIO,   --保证金比例
                MARGIN_AMT,   --保证金金额
                COMM_FEE_RAT   --手续费费率
               FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO  --对公贷款合同信息
              WHERE TO_CHAR(ETL_DT,'YYYYMMDD') =V_P_DATE
               AND SUP_CHAIN_FIN_BUS_FLG ='1'
               AND SUP_CHAIN_FIN_BUS_PROD_CLS_CD<>'00'
               AND CONT_ID<>'20220512102717')A  --客户经理前端操作错误，特殊剔除
     LEFT JOIN
       (SELECT TO_CHAR(T1.ETL_DT,'YYYYMMDD') DATA_DATE,  --数据日期
               T1.CONT_ID , --合同号
               T1.DUBIL_ID,--借据号
               T1.CUST_ID, --客户号
               T2.CUST_NAME,--客户名称
               T4.ORG_NM   SSFH, --所属分行
               T3.ORG_NM  SSZH, --所属支行
               T5.PROD_NAME BUS_BREED_NAME, --业务品种
               CASE WHEN T2.CORP_SIZE_CD='1' THEN '大型企业'
                    WHEN T2.CORP_SIZE_CD='2' THEN '中型企业'
                    WHEN T2.CORP_SIZE_CD='3' THEN '小型企业'
                    WHEN T2.CORP_SIZE_CD='4' THEN '微型企业'
                    END  CORP_SIZE,  --企业规模
               T1.DUBIL_AMT ,  --放款金额
               T1.DISTR_DT ,--放款时间
               T1.APOT_EXP_DT ,--原始到期时间
               T1.DUBIL_BAL ,--贷款余额
               T1.BASE_RAT  ,  --基准利率
               T1.EXEC_INT_RAT  --实际利率
          FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T1   --对公贷款借据信息
          LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T2 --对公客户基本信息表
          ON T1.CUST_ID=T2.CUST_ID
          AND TO_CHAR(T2.ETL_DT,'YYYYMMDD')=V_P_DATE
          AND T2.CORP_SIZE_CD IN ('1','2','3','4')
          LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3  --机构表
          ON T1.ORG_ID=T3.ORG_ID
          AND T3.DATA_DT=V_P_DATE
          LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T4  --机构表
          ON SUBSTR(T1.ORG_ID,1,3)=T4.ORG_ID
          AND T4.DATA_DT=V_P_DATE
          LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T5    --标准产品信息
          ON T1.BUS_BREED_ID=T5.PROD_ID
          AND TO_CHAR(T5.ETL_DT,'YYYYMMDD') = V_P_DATE
         WHERE LENGTH(T1.CONT_ID)>1
         AND TO_CHAR(T1.ETL_DT,'YYYYMMDD')=V_P_DATE
         ) B
         ON A.CONT_ID = B.CONT_ID
         AND A.CUST_ID = B.CUST_ID
    LEFT JOIN (SELECT ETL_DT,
                      CUST_ID,
                      O_USE_LMT_ALL_ID
               FROM (SELECT  ETL_DT,
                             CUST_ID,
                             O_USE_LMT_ALL_ID,
                             ROW_NUMBER() OVER (PARTITION BY CUST_ID ORDER BY O_USE_LMT_ALL_ID ) RN
                       FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO  --对公贷款申请信息
                       WHERE LENGTH(O_USE_LMT_ALL_ID)>1
                       AND TO_CHAR(ETL_DT,'YYYYMMDD')=V_P_DATE)
                WHERE RN=1)  C
          ON A.CUST_ID=C.CUST_ID;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    D_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_SPL_CHAIN_DTL;
/

