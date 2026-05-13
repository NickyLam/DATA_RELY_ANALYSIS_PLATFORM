create or replace procedure rrp_mdl.ETL_M_MRPT_TRAN_WYJYMX(I_P_DATE IN INTEGER, --xzy 不用管
                                                   O_ERRCODE  OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_MRPT_TRAN_WYJYMX
  *  功能描述：网银交易明细表
  *  创建日期：20221207
  *  开发人员：YANGJUAN
  *  来源表：
  *           M_PUM_ORG_INFO
  *           O_ICL_CMM_CONL_BK_SIGN_INFO
  *           O_ICL_CMM_DEP_ACCT_INFO
  *           O_ICL_CMM_DEP_ACCT_TRAN_DTL
  *           O_ICL_CMM_ELEC_CHN_TRAN_DTL
  *           O_ICL_CMM_EXCH_RAT_INFO
  *           O_IML_REF_PUB_CD
  *           O_IML_REF_TRAN_BANK_CODE_PARA
  *           O_ICL_CMM_INTNAL_ACCT
  *
  *  目标表：  RRP_MDL.M_MRPT_TRAN_WYJYMX  --网银交易明细表
  *
  *  修改情况：20231020 XMY  增加账户明细临时表，修改科目号，保持取数逻辑与《企业网银交易明细表》一致
  *
  ***************************************************************************/
 AS
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_TRAN_WYJYMX'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  D_P_DATE    DATE; -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME   DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  --V_SQL       VARCHAR2(2000); -- 动态sql
  I_STEP_DESC VARCHAR2(200); --任务名称
 -- V_PART_NAME VARCHAR2(100);  --分区名称
  --V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  D_P_DATE := TO_DATE(V_P_DATE,'YYYY-MM-DD'); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
 -- V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_TRAN_WYJYMX'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  DELETE FROM M_MRPT_TRAN_WYJYMX T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME;--分区表的重跑处理

  EXECUTE IMMEDIATE V_SQL;
  END IF ;*/
  I_STEP := 2;
  I_STEP_DESC := '分区处理';
  D_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE,V_TAB_NAME, '1', O_ERRCODE);

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_MRPT_TRAN_WYJYMX_TEMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.TEMP_ELEC_CHN_TRAN';
  EXECUTE IMMEDIATE  'TRUNCATE TABLE TEMP_DEP_ACCT';

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 3;
  I_STEP_DESC := '企业网银签约信息写入临时表';
  D_STARTTIME := SYSDATE;

  INSERT INTO M_MRPT_TRAN_WYJYMX_TEMP(CUST_ID,CUST_CN_NAME,OPEN_ACCT_BRAC_ID)
  SELECT CUST_ID,CUST_CN_NAME,OPEN_ACCT_BRAC_ID FROM (
  SELECT /*+ PARALLEL(4)*/ A.CUST_ID,
                   A.CUST_CN_NAME,
                   A.OPEN_ACCT_BRAC_ID,
                   ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY A.OPEN_ACCT_TM DESC) RN
          FROM ICL.V_CMM_CONL_BK_SIGN_INFO A -- 企业网银签约信息 F
          LEFT JOIN ICL.V_CMM_DEP_ACCT_INFO B --存款分户信息 F
            ON A.CUST_ID = B.CUST_ID
           AND B.ETL_DT = D_P_DATE
         WHERE A.ETL_DT = D_P_DATE
           AND A.CUST_CN_NAME NOT LIKE '%银行%' --剔除客户中文名称中含有“银行”字样的对公单位客户
           AND A.ONL_BANK_CUST_TYPE_CD IN ('1', '2', '3', '5') --1：交易银行客户2：网银客户3：交易银行+网银客户  4：佳佳购车客户 5 : OA企业 7：银企直连（默认为:1）
           AND A.ONL_BANK_CUST_STATUS_CD IN ('0', '4') ----账户状态0正常，4销户
          /* AND SUBSTR(B.SUBJ_ID, 1, 4) IN ('2002', '2005', '2010', '2011') --企业客户统计范围为在2002、2005、2010、2011科目核算*/
           AND (SUBSTR(SUBJ_ID,1,4) IN ('2005','2010') 
               OR  SUBJ_ID IN ('20020101','20020102','20110101','20110102','20110103','20110104','20110105') 
               OR (SUBJ_ID='20150102' AND STD_PROD_ID IN ('103010400001','103020800001')) )  --modify 20231018 xmy
  ) WHERE RN = 1;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 4; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '电子渠道交易明细表企业网银渠道交易数据临时表';
  D_STARTTIME := SYSDATE;

  INSERT INTO TEMP_ELEC_CHN_TRAN(
              TRAN_DT
             ,TRAN_ACCT_ID
             ,TRAN_STATUS_NAME
             ,CURR_CD
             ,TRAN_AMT
             ,CHN_CD
             ,CNTPTY_ACCT_ID
             ,CNTPTY_ACCT_NAME
             ,OVA_CHN_FLOW_NUM
             ,CORE_TRAN_FLOW_NUM
             ,CNTPTY_ACCT_OPEN_BANK_NAME
             ,TRAN_FLOW_NUM
             ,CUST_ID
             ,CORE_TRAN_DT
             ,TRAN_TYPE_CODE
  )
      SELECT TRAN_DT,
             TRAN_ACCT_ID,
             CASE WHEN TRAN_STATUS_CD = '00' THEN '交易成功'
                  WHEN TRAN_STATUS_CD = '01' THEN '交易失败'
                  WHEN TRAN_STATUS_CD = '05' THEN '交易待授权'
             ELSE ''
              END TRAN_STATUS_NAME,
             CURR_CD,
             TRAN_AMT,
             CHN_CD,
             CNTPTY_ACCT_ID,
             CNTPTY_ACCT_NAME,
             OVA_CHN_FLOW_NUM,
             CORE_TRAN_FLOW_NUM,
             CNTPTY_ACCT_OPEN_BANK_NAME,
             TRAN_FLOW_NUM,
             CUST_ID,
             TO_CHAR(CORE_TRAN_DT, 'YYYYMMDD')CORE_TRAN_DT,
             TRAN_TYPE_CODE
     	  FROM ICL.V_CMM_ELEC_CHN_TRAN_DTL  --电子渠道交易明细
       WHERE TRAN_STATUS_CD IN ('00', '01', '05') --交易状态代码
         AND OLBK_TRAN_SRC_CD = '04'-- 筛选企业网银渠道交易数据
         AND TRAN_DT =  D_P_DATE
         AND ETL_DT = D_P_DATE;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 5;
  I_STEP_DESC := '账户明细写入临时表';
  D_STARTTIME := SYSDATE;

 /* INSERT INTO TEMP_DEP_ACCT_TRAN (
              CUST_ACCT_ID
             ,OVA_FLOW_NUM
             ,TRAN_FLOW_NUM
             ,CNTPTY_ACCT_ID
             ,TRAN_AMT
             ,SUBJ_ID
             ,CUST_ACCT_SUB_ACCT_NUM
             ,ACCT_ATTR_CD
  )
       SELECT -- A.TRAN_DT, -- 交易日期
              A.CUST_ACCT_ID,
              A.OVA_FLOW_NUM,
              A.TRAN_FLOW_NUM,
              A.CNTPTY_ACCT_ID,
              A.TRAN_AMT,
              B.SUBJ_ID,
              B.CUST_ACCT_SUB_ACCT_NUM,
              B.ACCT_ATTR_CD
         FROM ICL.V_CMM_DEP_ACCT_TRAN_DTL A  --存款账户交易明细表
    LEFT JOIN (SELECT ACCT_ID,
                      SUBJ_ID,
                      CUST_ACCT_SUB_ACCT_NUM,
                      ACCT_ATTR_CD
                 FROM ICL.V_CMM_DEP_ACCT_INFO
                WHERE ETL_DT = D_P_DATE) B  --存款账户信息表
                   ON A.DEP_SUB_ACCT_ID = B.ACCT_ID
                WHERE A.ETL_DT = D_P_DATE;*/              
                
   INSERT INTO TEMP_DEP_ACCT (      
           CUST_ACCT_SUB_ACCT_NUM
          ,ACCT_ATTR_CD
          ,SUBJ_ID
          ,ACCT_ID
          ,STD_PROD_ID
          )
    SELECT T61.CUST_ACCT_SUB_ACCT_NUM,
           T61.ACCT_ATTR_CD,
           T61.SUBJ_ID,
           T61.ACCT_ID,
           T61.STD_PROD_ID
      FROM ICL.V_CMM_DEP_ACCT_INFO T61 --存款分户信息表 
     WHERE T61.ETL_DT = D_P_DATE
UNION ALL
    SELECT T62.SUB_ACCT_NUM,
           T62.ACCT_ATTR_CD,
           T62.SUBJ_ID,
           T62.ACCT_ID,
           T62.STD_PROD_ID
      FROM ICL.V_CMM_INTNAL_ACCT T62 --内部账户表 
     WHERE T62.ETL_DT = D_P_DATE
     ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 --XZY 多段逻辑插入同一个表，适用于多个union all 的情况，如果是union则要分析情况，因为union过滤重复数据。
  I_STEP      := 6; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '网银交易明细数据插入目标表';
  D_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_MRPT_TRAN_WYJYMX
    (     DATA_DT, --数据日期
          CUST_ID, --客户编号
          CUST_NAME, --客户名称
          ACCT_ID, --账户编号
         -- SUB_ACCT_ID, --子账户编号
         -- CN_ACCT_CD, --账户属性代码` 1
       --   CN_ACCT_TYPE, --账户属性类型
          TRAN_DT, --交易日期
          TRAN_TYPE_NAME, --交易名称
          TRAN_STATUS_NAME, --交易状态代码
          TRAN_CURR_CD, --币种代码
          OC_TRAN_AMT, --交易金额
          TRAN_AMT_CONVT_CNY_AMT, --折人民币金额
          TRAN_CHN_CD, --渠道代码
          TRAN_CHN_NAME, --渠道名称
          CNTPTY_ACCT_ID, --交易对手账户编号
          CNTPTY_ACCT_NAME, --交易对手账户名称
          CNTPTY_BELONG_BANK, --交易对手账户开户行名
        --  ACCTI_SUBJ_ID, --科目编号
          TRAN_FLOW_NUM --交易流水号
     )
    SELECT
           V_P_DATE
          ,T2.CUST_ID --客户编号
          ,T2.CUST_CN_NAME  --客户中文名称
          ,T1.TRAN_ACCT_ID  --交易账户编号
        --  ,T4.CUST_ACCT_SUB_ACCT_NUM  --子账户编号    默认空值
        --  ,T4.ACCT_ATTR_CD  --账户属性代码
        --  ,T9.CD_DESCB  --账户属性类型
          ,T1.TRAN_DT  --交易日期
          ,T11.TRAN_NAME  --交易名称
          ,T1.TRAN_STATUS_NAME --交易状态代码
          ,T1.CURR_CD  --币种代码
          ,T1.TRAN_AMT  --交易金额
          ,NVL(T5.CNY_EXCH_RAT,1) * T1.TRAN_AMT  --折人民币金额
          ,T1.CHN_CD  --渠道代码
          ,T10.CD_DESCB  --渠道名称
          ,CASE WHEN LENGTH(TRIM(T1.CNTPTY_ACCT_ID))>0 THEN T1.CNTPTY_ACCT_ID ELSE T4.CNTPTY_ACCT_ID END AS CNTPTY_ACCT_ID                         --交易对手账户编号
          ,CASE WHEN LENGTH(TRIM(T1.CNTPTY_ACCT_NAME))>0 THEN T1.CNTPTY_ACCT_NAME ELSE T4.CNTPTY_ACCT_NAME END AS CNTPTY_ACCT_NAME                     --交易对手账户名称
          ,CASE WHEN LENGTH(TRIM(T1.CNTPTY_ACCT_OPEN_BANK_NAME))>0 THEN T1.CNTPTY_ACCT_OPEN_BANK_NAME ELSE T4.CNTPTY_OPEN_BANK_NAME END AS CNTPTY_BELONG_BANK  --交易对手账户开户行名
          --,T4.SUBJ_ID  --科目编号
          ,T1.TRAN_FLOW_NUM  --交易流水号
      FROM TEMP_ELEC_CHN_TRAN T1 --电子渠道交易明细
INNER JOIN M_MRPT_TRAN_WYJYMX_TEMP T2 --企业网银签约信息临时表
        ON T1.CUST_ID = T2.CUST_ID
 /*LEFT JOIN TEMP_DEP_ACCT_TRAN T4 --存款账户交易明细临时表
        ON T1.TRAN_ACCT_ID = T4.CUST_ACCT_ID
       AND T1.OVA_CHN_FLOW_NUM = T4.OVA_FLOW_NUM
       AND (T1.CORE_TRAN_DT || T1.CORE_TRAN_FLOW_NUM =T4.TRAN_FLOW_NUM OR T1.CORE_TRAN_FLOW_NUM = T4.TRAN_FLOW_NUM)
       AND T1.CNTPTY_ACCT_ID = T4.CNTPTY_ACCT_ID
       AND T1.TRAN_AMT = T4.TRAN_AMT*/
 LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构信息表
        ON T2.OPEN_ACCT_BRAC_ID = T3.ORG_ID
       AND T3.DATA_DT = V_P_DATE
 INNER JOIN ICL.V_CMM_DEP_ACCT_TRAN_DTL  T4 --存款账户交易明细 
         ON T1.TRAN_ACCT_ID = T4.CUST_ACCT_ID 
        AND T1.OVA_CHN_FLOW_NUM=T4.OVA_FLOW_NUM
        AND T1.TRAN_AMT=T4.TRAN_AMT
        AND T4.ETL_DT = D_P_DATE
 LEFT JOIN RRP_MDL.O_ICL_CMM_EXCH_RAT_INFO T5 --汇率信息表
        ON T1.CURR_CD = T5.CURR_CD --币种代码=币种代码
       AND T5.ETL_DT = D_P_DATE
 /*LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T9 --数据仓库公共代码表
        ON T4.ACCT_ATTR_CD = T9.CD_VAL --账户属性代码 = 代码值
       AND T9.CD_ID = 'CD1924' --代码编号
     --  AND T9.ETL_DT = D_P_DATE*/
 LEFT JOIN TEMP_DEP_ACCT T6  --账户明细临时表
        ON T4.DEP_SUB_ACCT_ID=T6.ACCT_ID
 LEFT JOIN IML.V_REF_PUB_CD T10 --数据仓库公共代码表
        ON T1.CHN_CD = T10.CD_VAL --   代码值
       AND T10.CD_ID = 'CD1751' -- 代码编号:渠道代码
     --  AND T10.ETL_DT = D_P_DATE
 LEFT JOIN IML.V_REF_TRAN_BANK_CODE_PARA T11 --TBPS的交易码表
        ON T1.TRAN_TYPE_CODE = T11.TRAN_CODE
       --AND T11.ETL_DT = D_P_DATE
     WHERE T11.FIN_TRAN_FLG ='1'--金融类交易(0:非金融；1:金融交易)
    AND (SUBSTR(T6.SUBJ_ID,1,4) IN ('2005','2010') OR  T6.SUBJ_ID IN ('20020101','20020102','20110101','20110102','20110103','20110104','20110105') 
 OR (T6.SUBJ_ID='20150102' AND T6.STD_PROD_ID IN ('103010400001','103020800001')) )
    ;
    
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  --程序结束标记
  I_STEP      := 7; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '-- 程序跑批结束 --';
  D_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    D_ENDTIME   := SYSDATE;
   /* I_STEP      := I_STEP + 1;
    I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

end ETL_M_MRPT_TRAN_WYJYMX;
/

