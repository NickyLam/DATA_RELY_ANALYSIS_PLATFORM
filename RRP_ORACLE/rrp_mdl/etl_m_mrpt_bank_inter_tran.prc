CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_BANK_INTER_TRAN(I_P_DATE IN INTEGER,
                                                       O_ERRCODE  OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_MRPT_BANK_INTER_TRAN
  *  功能描述：企业电子银行互动类交易明细表
  *  描述信息： 企业网银非金融交易类数据、企业手机银行非金融交易类的交易
  *  创建日期：20221208
  *  开发人员：YANGJUAN
  *  来源表：  O_IOL_TBMS_T_YQT_OPERATION_LOG
  *            O_ICL_CMM_CONL_BK_SIGN_INFO
  *          	 M_PUM_ORG_INFO
 	*            O_IOL_TBMS_T_CORP_INFO
	*            O_ICL_CMM_CORP_CUST_BASIC_INFO
	*            O_ICL_CMM_DEP_ACCT_INFO
	*            O_ICL_CMM_DEP_CUST_ACCT_INFO
	*            O_ICL_CMM_ELEC_CHN_TRAN_DTL
  *  目标表：  RRP_MDL.M_MRPT_BANK_INTER_TRAN_D  --企业电子银行互动类交易明细表
  *
  *  修改情况：
  *
  ***************************************************************************/
 AS
  -- 定义变量 --
  --XZY 这里要注意，不用他们的规则，用我们自己的规则，变量前一个字母是字段类型的首字母，方便看类型，比如INTEGER类型就用I_开头，VARCHAR2就用V_开头
  --XZY 这部分基本照抄，开发完成后再把不需要的去掉
  I_STEP     INTEGER := 0; -- 处理步骤
  I_SQLCOUNT INTEGER := 0; -- 更新或删除影响的记录数

  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME   DATE; -- 处理结束时间

  V_STEP_DESC VARCHAR2(100); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_MRPT_BANK_INTER_TRAN'; -- 程序名称 --XZY 新建一个的时候，批量替换成新的名字就行
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  D_P_DATE    DATE; -- ETL数据日期
  D_MON_DATE  DATE;  --当月第一天
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态SQL
  V_FREQ_FLAG     VARCHAR2(10);    --跑批频度标识

BEGIN

  O_ERRCODE := '0';  
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  D_P_DATE := TO_DATE(V_P_DATE,'YYYY-MM-DD');
  D_MON_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
  IF V_FREQ_FLAG = '1' THEN

  -- 支持重跑 --
  I_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  DELETE FROM M_MRPT_BANK_INTER_TRAN_D T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_MRPT_BANK_INTER_TRAN_D'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --清空临时表
  --XZY 临时表使用前都需要清空，临时表命名规则 TMP_开头，其他随意，建议简单易懂容易分辨,快速建表用CREATE TABLE TMP_XXX AS语句
  I_STEP      :=2; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '-- 清空临时表 --';
  D_STARTTIME := SYSDATE;

  V_SQL := 'TRUNCATE TABLE TMP_MRPT_BANK_INTER_TRAN_01'; --TRUNCATE表通过动态SQL实现
  EXECUTE IMMEDIATE V_SQL;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 3; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入TMP_MRPT_BANK_INTER_TRAN_01临时表，企业网银非金融交易类数据';
  D_STARTTIME := SYSDATE;

  INSERT INTO TMP_MRPT_BANK_INTER_TRAN_01
    (
     SIGN_BRCH_ORG_ID,
     SIGN_NETW_ORG_ID,
     SIGN_NETW_ORG_NAME,
     CUST_ID,
     CUST_NAME,
     CONL_BK_INTER_TRAN_CNT,
     MOBILE_ONL_BK_INTER_TRAN_CNT
     )
    SELECT T6.ORG_ID, --分行编号          ,
           T3.OPEN_ACCT_BRAC_ID, --签约机构编号          ,
           T6.ORG_NM, --签约机构名称          ,
           T3.CUST_ID, --客户编号          ,
           T3.CUST_CN_NAME, --客户名称          ,
           COUNT(1), --企业网网银互动类交易次数          ,
           0 --手机网银互动类交易次数
      FROM ICL.V_CMM_ELEC_CHN_TRAN_DTL T1 --电子渠道交易明细
 INNER JOIN IML.V_REF_TRAN_BANK_CODE_PARA T2  --交易银行交易码参数
         ON T1.TRAN_TYPE_CODE=T2.TRAN_CODE  
        AND T2.FIN_TRAN_FLG ='0'   --金融交易标志(0:非金融；1:金融交易)
 LEFT JOIN ICL.V_CMM_CONL_BK_SIGN_INFO T3 --企业网银签约信息
        ON T1.CUST_ID = T3.CUST_ID --客户编号 = 客户编号
       AND T3.ETL_DT = D_P_DATE
INNER JOIN (     SELECT A.CUST_ID,
                        A.CUST_CN_NAME,
                        A.OPEN_ACCT_BRAC_ID,
                        ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY A.OPEN_ACCT_TM DESC) RN
                   FROM ICL.V_CMM_CONL_BK_SIGN_INFO A --企业网银签约信息
                   LEFT JOIN ICL.V_CMM_DEP_ACCT_INFO B -- 存款分户信息
                     ON A.CUST_ID = B.CUST_ID
                    AND B.ETL_DT = D_P_DATE
                  WHERE A.ETL_DT = D_P_DATE
                    AND A.CUST_CN_NAME NOT LIKE '%银行%'
                    AND A.ONL_BANK_CUST_TYPE_CD IN ('1', '2', '3', '5') --1：交易银行客户2：网银客户3：交易银行+网银客户  4：佳佳购车客户 5 : OA企业 7：银企直连（默认为:1）
                    AND A.ONL_BANK_CUST_STATUS_CD IN ('0', '4') ----账户状态0正常，4销户
                    -- AND SUBSTR(B.SUBJ_ID, 1, 4) IN ('2002', '2005', '2010', '2011') --企业客户统计范围为在2002 、2005 、2010 、2011 科目核算
                    AND  ( SUBSTR(B.SUBJ_ID,1,4) IN ('2005','2010') OR  B.SUBJ_ID IN ('20020101','20020102','20110101','20110102','20110103','20110104','20110105') 
                            OR (B.SUBJ_ID='20150102' AND B.STD_PROD_ID IN ('103010400001','103020800001')) )
                 ) T5 --存款账户信息表
        ON T1.CUST_ID = T5.CUST_ID --客户编号 = 客户编号
       AND T5.RN = 1
 LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T6 --机构信息表
        ON T3.OPEN_ACCT_BRAC_ID = T6.ORG_ID
       AND T6.DATA_DT = V_P_DATE
     WHERE T1.ETL_DT BETWEEN D_MON_DATE AND D_P_DATE
       AND T1.OLBK_TRAN_SRC_CD = '04' --企业网银
       -- AND NVL(T1.TRAN_AMT, 0) = 0
       AND T1.TRAN_STATUS_CD IN ('00','01','05')    --交易状态代码
       AND T1.CHN_CD='301003' --渠道代码
    --0505:统计企业网银、手机银行互动类交易，客户只限于我行签约客户。对于只开通OA办公等商务功能客户，现统计说法为“注册”客户，此类客户不在电子银行互动类统计范围--OA客户？
     GROUP BY T6.ORG_ID,
              T3.OPEN_ACCT_BRAC_ID,
              T6.ORG_NM,
              T3.CUST_ID,
              T3.CUST_CN_NAME;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 4; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入TMP_MRPT_BANK_INTER_TRAN_01临时表，企业手机银行非金融交易类的交易';
  D_STARTTIME := SYSDATE;

  INSERT INTO TMP_MRPT_BANK_INTER_TRAN_01
    (
     SIGN_BRCH_ORG_ID,
     SIGN_NETW_ORG_ID,
     SIGN_NETW_ORG_NAME,
     CUST_ID,
     CUST_NAME,
     CONL_BK_INTER_TRAN_CNT,
     MOBILE_ONL_BK_INTER_TRAN_CNT
     )
    SELECT T5.ORG_ID, --分行编号          ,
           T4.OPEN_ACCT_BRAC_ID, --签约机构编号          ,
           T5.ORG_NM, --签约机构名称          ,
           T1.COMPANYNO, --客户编号          ,
           T4.CUST_CN_NAME, --客户名称          ,
           0, --企业网银互动类交易次数          ,
           COUNT(T3.ID) ---企业手机银行互动类交易次数
      FROM IOL.V_TBMS_T_CORP_INFO T1 --企业信息表
INNER JOIN (SELECT DISTINCT T1.COMPANYID,
                            T2.CUST_ID
                   FROM IOL.V_TBMS_T_CORP_INFO T1  --企业信息表
              LEFT JOIN ICL.V_CMM_DEP_ACCT_INFO T2 --存款分户信息
                     ON T1.COMPANYNO = T2.CUST_ID
                    AND T2.ETL_DT = D_P_DATE
                  WHERE T1.SYS_VALID > 0
                   --  AND SUBSTR(T2.SUBJ_ID, 1, 4) IN ('2002', '2005', '2010', '2011')
                    AND (SUBSTR(T2.SUBJ_ID,1,4) IN ('2005','2010') OR  T2.SUBJ_ID IN ('20020101','20020102','20110101','20110102','20110103','20110104','20110105') 
                         OR (T2.SUBJ_ID='20150102' AND T2.STD_PROD_ID IN ('103010400001','103020800001')) )
                    AND T1.COMPANYNO NOT LIKE 'OA%'
                    AND T1.AUTHORGCODE IS NOT NULL
                    AND T1.AUTHORGCODE != '800001'
                    AND T1.AUTHORGCODE != '800'
                    AND T1.CNAME NOT LIKE '%银行%'
                    AND T1.CNAME NOT LIKE '%测试%'
                    AND T1.CNAME NOT LIKE '%TEST%'
                    AND T1.START_DT <=  D_P_DATE
                    AND T1.END_DT >  D_P_DATE
                 ) T2 --存款账户信息表
        ON T1.COMPANYID = T2.COMPANYID
INNER JOIN IOL.V_TBMS_T_YQT_OPERATION_LOG T3 --企业手机银行（银企通）操作日志表
        ON T1.COMPANYID = T3.CPYID
       AND T3.SYS_VALID > 0
     --  AND SUBSTR(T3.SYS_CTIME,1,10) = D_P_DATE
     --  AND T3.ETL_DT = D_P_DATE
 LEFT JOIN  ICL.V_CMM_CONL_BK_SIGN_INFO T4 --企业网银签约信息
        ON T1.COMPANYNO = T4.CUST_ID
       AND T4.ETL_DT = D_P_DATE
 LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T5 --机构信息表
        ON T4.OPEN_ACCT_BRAC_ID = T5.ORG_ID
       AND T5.DATA_DT = V_P_DATE
INNER JOIN (SELECT DISTINCT CUST_ID
              FROM  ICL.V_CMM_ELEC_CHN_TRAN_DTL  T1   ---电子渠道交易明细    
        INNER JOIN IML.V_REF_TRAN_BANK_CODE_PARA T2 --交易银行交易码参数    
                ON T1.TRAN_TYPE_CODE=T2.TRAN_CODE  
               AND T2.FIN_TRAN_FLG ='0'   --金融交易标志：0:非金融；1:金融交易
             WHERE T1.OLBK_TRAN_SRC_CD='04'--企业网银交易
               AND T1.TRAN_STATUS_CD IN ('00','01','05')
               AND T1.ETL_DT BETWEEN D_MON_DATE AND D_P_DATE
               )T6  --交易银行交易码参数
           ON  T1.COMPANYNO=T6.CUST_ID
     WHERE T1.START_DT <=  D_P_DATE
       AND T1.END_DT >  D_P_DATE
       AND T3.SYS_CTIME >= D_MON_DATE 
       AND T3.SYS_CTIME< D_P_DATE+1
     GROUP BY T5.ORG_ID,
              T4.OPEN_ACCT_BRAC_ID,
              T5.ORG_NM,
              T1.COMPANYNO,
              T4.CUST_CN_NAME;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 5; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入M_MRPT_BANK_INTER_TRAN_D目标表，企业电子银行互动类交易明细表';
  D_STARTTIME := SYSDATE;

  INSERT INTO M_MRPT_BANK_INTER_TRAN_D
    (DATA_DT, --数据日期    ,
     SIGN_BRCH_ORG_ID, --签约分行机构编号    ,
     SIGN_NETW_ORG_ID, --签约网点机构编号    ,
     SIGN_NETW_ORG_NAME, --签约网点机构名称    ,
     CUST_ID, --客户编号    ,
     CUST_NAME, --客户名称    ,
     OPEN_CONL_BK_FLG, --是否开通企业网银    ,
     OPEN_MBANK_FLG, --是否开通手机银行    ,
     CONL_BK_INTER_TRAN_CNT, --企业网网银互动类交易次数    ,
     MOBILE_ONL_BK_INTER_TRAN_CNT --手机网银互动类交易次数
     )
    WITH WHOLE_CORP_DEP_ACCT_QUE_01 AS
     ( -- 统计未销户账号的客户号
      SELECT T1.CUST_ID CUST_ID --客户编号
        FROM ICL.V_CMM_CORP_CUST_BASIC_INFO T1 --对公客户基本信息
   LEFT JOIN ICL.V_CMM_DEP_ACCT_INFO T2 --存款分户信息
          ON T1.CUST_ID = T2.CUST_ID
         AND T2.ETL_DT = D_P_DATE
   LEFT JOIN ICL.V_CMM_DEP_CUST_ACCT_INFO T3 --存款主账户信息
          ON T1.CUST_ID = T3.CUST_ID
         AND T3.ETL_DT = D_P_DATE
       WHERE T1.ETL_DT = D_P_DATE
    GROUP BY T1.CUST_ID
      HAVING SUM(CASE WHEN T2.CLOS_ACCT_DT > D_P_DATE THEN  1
                      WHEN T3.CLOS_ACCT_DT > D_P_DATE THEN  1
                 ELSE      0
                  END
                 ) >= 1 --销户日期
      )
    SELECT  V_P_DATE DATE_DT,
            T1.SIGN_BRCH_ORG_ID SIGN_BRCH_ORG_ID, --签约分行机构编号          ,
            T1.SIGN_NETW_ORG_ID SIGN_NETW_ORG_ID, --签约网点机构编号          ,
            T1.SIGN_NETW_ORG_NAME SIGN_NETW_ORG_NAME, --签约网点机构名称          ,
            T1.CUST_ID CUST_ID, --客户编号          ,
            T1.CUST_NAME CUST_NAME, --客户名称          ,
           CASE WHEN T2.ONL_BANK_CUST_STATUS_CD = '0' AND T1.CUST_ID IS NOT NULL THEN '开通' -- 0 正常
                WHEN T2.ONL_BANK_CUST_STATUS_CD = '4' THEN '注销' -- 4 销户
                WHEN T2.ONL_BANK_CUST_STATUS_CD = '0' AND T1.CUST_ID IS NULL THEN '开通无账户'
           ELSE '未开通'
           END OPEN_CONL_BK_FLG, ---是否开通企业网银 网银客户状态代码
           CASE WHEN T2.SIGN_YQT_FLG = '1' AND T3.CUST_ID IS NOT NULL THEN '签约'
                WHEN T2.SIGN_YQT_FLG = '1' AND T3.CUST_ID IS NULL THEN '签约无账户'
           ELSE '未签约'
           END OPEN_MBANK_FLG, --是否开通手机银行          ,
           SUM(T1.CONL_BK_INTER_TRAN_CNT) CONL_BK_INTER_TRAN_CNT, --企业网网银互动类交易次数          ,
           SUM(T1.MOBILE_ONL_BK_INTER_TRAN_CNT) MOBILE_ONL_BK_INTER_TRAN_CNT --手机网银互动类交易次数
      FROM TMP_MRPT_BANK_INTER_TRAN_01 T1 --临时表01  -- 企业手机银行/企业网银非金融交易类数据
 LEFT JOIN ICL.V_CMM_CONL_BK_SIGN_INFO T2 --企业网银签约信息  ICL.CMM_CONL_BK_SIGN_INFO
        ON T1.CUST_ID = T2.CUST_ID
       AND T2.ETL_DT = D_P_DATE
 LEFT JOIN WHOLE_CORP_DEP_ACCT_QUE_01 T3 --临时表  统计未销户账号的客户号
        ON T1.CUST_ID = T3.CUST_ID --客户编号 = 客户编号
  GROUP BY    T1.SIGN_BRCH_ORG_ID,
              T1.SIGN_NETW_ORG_ID,
              T1.SIGN_NETW_ORG_NAME,
              T1.CUST_ID,
              T1.CUST_NAME,
           CASE WHEN T2.ONL_BANK_CUST_STATUS_CD = '0' AND T1.CUST_ID IS NOT NULL THEN '开通' -- 0 正常
                WHEN T2.ONL_BANK_CUST_STATUS_CD = '4' THEN '注销' -- 4 销户
                WHEN T2.ONL_BANK_CUST_STATUS_CD = '0' AND T1.CUST_ID IS NULL THEN '开通无账户'
           ELSE '未开通'
           END ,
           CASE WHEN T2.SIGN_YQT_FLG = '1' AND T3.CUST_ID IS NOT NULL THEN '签约'
                WHEN T2.SIGN_YQT_FLG = '1' AND T3.CUST_ID IS NULL THEN '签约无账户'
           ELSE '未签约'
           END;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := SQLCODE;
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  END IF ;
  
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
  -------以下代码直接复制---------

  --程序结束标记
  I_STEP      := 6; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '-- 程序跑批结束 --';
  O_ERRCODE  := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    D_ENDTIME   := SYSDATE;
  /*  I_STEP      := I_STEP + 1;
    V_STEP_DESC := '-- 程序跑批异常 --';*/
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_BANK_INTER_TRAN;
/

