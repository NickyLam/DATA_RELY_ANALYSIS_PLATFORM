create or replace procedure rrp_mdl.ETL_M_MRPT_CONL_BK_CUST_DTL(I_P_DATE IN INTEGER,
                                                       O_ERRCODE  OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_MRPT_CONL_BK_CUST_DTL
  *  功能描述：企业网银客户明细表
  *  描述信息： 企业网银客户明细表
  *  创建日期：20221209
  *  开发人员：YANGJUAN
  *  来源表：
  *            M_MRPT_CONL_BK_CUST_DTL
  *            O_ICL_CMM_CONL_BK_SIGN_INFO
  *            O_ICL_CMM_CORP_CUST_BASIC_INFO
  *            O_ICL_CMM_DEP_ACCT_INFO
  *            O_ICL_CMM_DEP_CUST_ACCT_INFO
  *            O_ICL_CMM_INTNAL_ORG_INFO
  *            O_IML_REF_PUB_CD
  *  目标表：  RRP_MDL.M_MRPT_CONL_BK_CUST_DTL  --企业网银客户明细表
  *
  *  修改情况：20231013  xmy  修改临时表01取数逻辑，修改对公客户中存在有效账户的客户号逻辑
	*            20240407  xmy  与报表集市一致，调整【签约手机银行标志】：当无有效账户时，显示“签约-无账户”
  *
  ***************************************************************************/
 AS
  -- 定义变量 --
  --XZY 这里要注意，不用他们的规则，用我们自己的规则，变量前一个字母是字段类型的首字母，方便看类型，比如INTEGER类型就用I_开头，VARCHAR2 就用V_开头
  --XZY 这部分基本照抄，开发完成后再把不需要的去掉
  I_STEP     INTEGER := 0; -- 处理步骤
  I_SQLCOUNT INTEGER := 0; -- 更新或删除影响的记录数
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME   DATE; -- 处理结束时间
  V_STEP_DESC VARCHAR2(100); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_MRPT_CONL_BK_CUST_DTL'; -- 程序名称 --XZY 新建一个的时候，批量替换成新的名字就行
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  D_P_DATE    DATE; -- 跑批数据日期
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态SQL
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称
  V_FREQ_FLAG   VARCHAR2(10);    --跑批频度标识

BEGIN
  
  O_ERRCODE := '0';
 -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  D_P_DATE := TO_DATE(V_P_DATE,'YYYY-MM-DD');
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_CONL_BK_CUST_DTL'; --表名称
  
  V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
  IF V_FREQ_FLAG = '1' THEN

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_TRAN_WYJYMX T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_DROP(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --清空临时表
  I_STEP      :=2; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '-- 清空临时表 --';
  D_STARTTIME := SYSDATE;

  V_SQL := 'TRUNCATE TABLE TMP_M_MRPT_CONL_BK_CUST_DTL_01'; --TRUNCATE表通过动态SQL实现
  EXECUTE IMMEDIATE V_SQL;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  I_STEP      := 3; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '从企业网银签约信息中取符合条件的客户号存入临时表01';
  D_STARTTIME := SYSDATE;

  INSERT INTO TMP_M_MRPT_CONL_BK_CUST_DTL_01(
           CUST_ID,                             --客户编号
           OPEN_ACCT_BRAC_ID,                   --开户网点编号
           ONL_BANK_CUST_STATUS_CD,             --网银客户状态代码
           OPEN_ACCT_TM ,                       --开户时间
           FINAL_TRAN_TM ,                      --最后交易时间
           SIGN_YQT_FLG ,                       --签约银企通标志
           SIGN_YQT_TM  ,                       --签约银企通时间
           OA_WRTOFF_TM                         --OA注销时间
  )
  SELECT
           T1.CUST_ID  CUST_ID                                        --客户编号
          ,T1.OPEN_ACCT_BRAC_ID  OPEN_ACCT_BRAC_ID                   --开户网点编号
          ,T1.ONL_BANK_CUST_STATUS_CD  ONL_BANK_CUST_STATUS_CD       --网银客户状态代码
          ,T1.OPEN_ACCT_TM  OPEN_ACCT_TM                             --开户时间
          ,T1.FINAL_TRAN_TM  FINAL_TRAN_TM                           --最后交易时间
          ,T1.SIGN_YQT_FLG  SIGN_YQT_FLG                             --签约银企通标志
          ,T1.SIGN_YQT_TM  SIGN_YQT_TM                               --签约银企通时间
          ,T1.OA_WRTOFF_TM  OA_WRTOFF_TM                             --OA注销时间
      FROM ICL.V_CMM_CONL_BK_SIGN_INFO  T1    --企业网银签约信息                    --企业网银签约信息
INNER JOIN (
             SELECT CUST_ID
               FROM ICL.V_CMM_DEP_ACCT_INFO                                --存款分户信息表
              WHERE ETL_DT = D_P_DATE
                AND (SUBSTR(SUBJ_ID,1,4) IN ('2005','2010') 
                 OR  SUBJ_ID IN ('20020101','20020102','20110101','20110102','20110103','20110104','20110105') 
                 OR (SUBJ_ID='20150102' AND STD_PROD_ID IN ('103010400001','103020800001')) )  --modify 20231013 xmy
           GROUP BY CUST_ID
             )  T2
        ON T1.CUST_ID=T2.CUST_ID
     WHERE T1.ONL_BANK_CUST_TYPE_CD IN ('1','2','3','5')    --客户类型代码 CD1880：0-虚拟客户,1-交易银行客户,2-网银客户,3-交易银行+网银客户,4-佳佳购车客户,5-OA企业,7-银企直连
       AND T1.ONL_BANK_CUST_STATUS_CD IN ('0','4')    --账户状态代码 CD1873：0-正常,1-暂停,2-锁定(允许查询),3-冻结 (不允许查询),4-销户,5-欠款状态,6-活动,7-已故,9-未知
       AND T1.CUST_CN_NAME NOT LIKE '%银行%'
       AND T1.ETL_DT = D_P_DATE
     ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   --清空临时表
  I_STEP      := 4; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '-- 清空临时表 --';
  D_STARTTIME := SYSDATE;

  V_SQL := 'TRUNCATE TABLE TMP_M_MRPT_CONL_BK_CUST_DTL_02'; --TRUNCATE表通过动态SQL实现
  EXECUTE IMMEDIATE V_SQL;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 5; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '取对公客户中存在有效账户的客户号存入临时表02';
  D_STARTTIME := SYSDATE;

  INSERT INTO TMP_M_MRPT_CONL_BK_CUST_DTL_02
              (
                  CUST_ID, -- 客户号
                  VALID_ACCT_QTTY  --有效客户标志
               )
         SELECT
                   T1.CUST_ID  CUST_ID                                        --客户编号
                  ,SUM(CASE WHEN T3.DEP_ACCT_STATUS_CD  IN ('N','I','A','D') THEN 1
                            --WHEN T3.CLOS_ACCT_DT>D_P_DATE THEN 1
                          ELSE 0
                          END )  VALID_ACCT_QTTY --NONE
           FROM ICL.V_CMM_CORP_CUST_BASIC_INFO  T1 --对公客户信息表
      LEFT JOIN ICL.V_CMM_DEP_CUST_ACCT_INFO  T2 --存款主账户信息
             ON T1.CUST_ID=T2.CUST_ID
             -- AND T2.ACCT_ATTR_CD='C'
            AND T2.ETL_DT = D_P_DATE
      LEFT JOIN ICL.V_CMM_DEP_ACCT_INFO  T3 --存款分户信息表
             ON T1.CUST_ID=T3.CUST_ID
            AND T3.ETL_DT = D_P_DATE
          WHERE T1.ETL_DT = D_P_DATE
       GROUP BY T1.CUST_ID;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   --清空临时表
  I_STEP      := 6; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '-- 清空临时表 --';
  D_STARTTIME := SYSDATE;

  V_SQL := 'TRUNCATE TABLE TMP_M_MRPT_CONL_BK_CUST_DTL_03'; --TRUNCATE表通过动态SQL实现
  EXECUTE IMMEDIATE V_SQL;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 7;
  V_STEP_DESC := '插入企业网银注册用户到目标临时表';
  D_STARTTIME := SYSDATE;

  INSERT INTO TMP_M_MRPT_CONL_BK_CUST_DTL_03
      (
               CUST_ID,
               CUST_NAME,
               SIGN_BRCH_ORG_ID,
               SIGN_BRCH_NAME,
               SIGN_NETW_ID,
               SIGN_NETW_NAME,
               BELONG_INDUTY_CD,
               CONL_BK_STATUS_CD,
               CONL_BK_STATUS_NAME,
               CONL_BK_SIGN_DT,
               CONL_BK_WRTOFF_DT,
               SIGN_MBANK_FLG,
               MBANK_SIGN_DT,
               MBANK_WRTOFF_DT
       )
      SELECT
               T1.CUST_ID            CUST_ID                               --客户编号
              ,T2.CUST_NAME          CUST_NAME                             --客户名称
              ,T5.BRCH_ID            SIGN_BRCH_ORG_ID                      --分行编号
              ,T5.BRCH_NAME          SIGN_BRCH_NAME                        --分行名称
              ,T1.OPEN_ACCT_BRAC_ID  SIGN_NETW_ID                          --开户网点编号
              ,T5.ORG_NAME           SIGN_NETW_NAME                        --机构名称
              ,CASE WHEN T2.INDUS_TYPE_CD_CRDTC  <>'-' THEN T2.INDUS_TYPE_CD_CRDTC
                    WHEN T2.INDUS_TYPE_CD  <>'-'       THEN T2.INDUS_TYPE_CD
                      ELSE NULL
                      END             BELONG_INDUTY_CD                     --行业类型代码
             /* ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD='4' THEN '4'
                    WHEN T9.CUST_ID IS NULL             THEN '1'
                      ELSE '0'
                      END             CONL_BK_STATUS_CD                    --网银客户状态代码
                 ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD='4' THEN '销户'
                    WHEN T9.CUST_ID IS NULL             THEN '开通无账户'
                      ELSE '开通'
                      END             CONL_BK_STATUS_NAME                  --企业网银状态*/
               ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY>0 THEN '1'
                     WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY=0 THEN '0'
                     WHEN T1.ONL_BANK_CUST_STATUS_CD = '4'  THEN '4'
                      END    AS CONL_BK_STATUS_CD   --网银客户状态代码
              ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY>0 THEN '开通'
                    WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY=0 THEN '开通无账户'
                    WHEN T1.ONL_BANK_CUST_STATUS_CD = '4' THEN '注销'
                      END    AS CONL_BK_STATUS_NAME  --企业网银状态
              ,TO_CHAR(T1.OPEN_ACCT_TM,'YYYY-MM-DD')  CONL_BK_SIGN_DT      --开户时间
              ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD='4' THEN TO_CHAR(T1.FINAL_TRAN_TM,'YYYY-MM-DD') 
                      ELSE ''
                      END             CONL_BK_WRTOFF_DT                    --最后交易时间
   /* ,CASE WHEN T2.OPEN_MBANK_FLG='0' THEN '未签约'
          WHEN T2.OPEN_MBANK_FLG='1' AND T9.CUST_ID IS NULL THEN '签约无账户'
          WHEN T2.OPEN_MBANK_FLG='1' AND T9.CUST_ID IS NOT NULL THEN '签约'
     END  SIGN_MBANK_FLG --开通手机银行标志
     这个字段OPEN_MBANK_FLG是有加工的，逻辑：
     CASE WHEN  T4.SIGN_YQT_FLG='1' AND T4.ONL_BANK_CUST_STATUS_CD<>'4'  THEN '1' ELSE '0' END ，T4 是T_EDW_ICL_CMM_CONL_BK_SIGN_INFO表*/

     --SIGN_YQT_FLG 签约银企通标志 1:是 0:否 ，ONL_BANK_CUST_STATUS_CD  0 ：正常 1 ：锁定(允许查询) 2 ：冻结 (不允许查询) 3 ：销户（默认为0）
             /* ,CASE WHEN T3.SIGN_YQT_FLG<>'1' AND T3.ONL_BANK_CUST_STATUS_CD='4' THEN '未签约'
                    WHEN T3.SIGN_YQT_FLG='1' AND T3.ONL_BANK_CUST_STATUS_CD<>'4'   AND T9.CUST_ID IS NULL THEN '签约无账户'
                    WHEN T3.SIGN_YQT_FLG='1' AND T3.ONL_BANK_CUST_STATUS_CD<>'4'   AND T9.CUST_ID IS NOT NULL THEN '签约'
                   END              SIGN_MBANK_FLG                        --开通手机银行标志*/
               ,CASE WHEN ((T3.SIGN_YQT_FLG='1'AND T3.ONL_BANK_CUST_STATUS_CD='4') OR T3.SIGN_YQT_FLG<>'1' )THEN '未签约'
                     WHEN T3.SIGN_YQT_FLG='1' AND T3.ONL_BANK_CUST_STATUS_CD<>'4' AND (T9.CUST_ID IS NULL OR T9.VALID_ACCT_QTTY='0') THEN '签约无账户'   --modify 20240407
                     WHEN T3.SIGN_YQT_FLG='1' AND T3.ONL_BANK_CUST_STATUS_CD<>'4' AND T9.CUST_ID IS NOT NULL THEN '签约'
                    END     AS SIGN_MBANK_FLG     --开通手机银行标志
              ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <>'4' AND T1.SIGN_YQT_FLG='1' THEN TO_CHAR(T1.SIGN_YQT_TM,'YYYY-MM-DD')
                   END              MBANK_SIGN_DT                         --签约银企通时间
              ,TO_CHAR(T1.OA_WRTOFF_TM,'YYYY-MM-DD')   MBANK_WRTOFF_DT    --OA注销时间          
          FROM TMP_M_MRPT_CONL_BK_CUST_DTL_01  T1 --临时表01
    INNER JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO  T2 --对公客户信息表
            ON T1.CUST_ID = T2.CUST_ID    
           AND T2.ETL_DT = D_P_DATE
    INNER JOIN ICL.V_CMM_CONL_BK_SIGN_INFO T3  -- 企业网银签约信息
            ON T3.CUST_ID = T2.CUST_ID    
           AND T3.ETL_DT = D_P_DATE
     LEFT JOIN ICL.V_CMM_INTNAL_ORG_INFO   T5 --机构信息表
            ON T1.OPEN_ACCT_BRAC_ID = T5.ORG_ID    
           AND T5.ETL_DT = D_P_DATE
     LEFT JOIN IML.V_REF_PUB_CD  T8 --数据仓库公共代码表
            ON T2.CORP_SIZE_CD = T8.CD_VAL
           AND T8.CD_ID = 'CD1043'
     -- AND T8.VALID_FLG='Y'
           AND T8.ETL_DT = D_P_DATE
     LEFT JOIN RRP_MDL.TMP_M_MRPT_CONL_BK_CUST_DTL_02 T9  --临时表02 取对公客户中存在有效账户的客户号存入临时表
     ON T1.CUST_ID=T9.CUST_ID
   /*  LEFT JOIN (
              SELECT CUST_ID
                FROM TMP_M_MRPT_CONL_BK_CUST_DTL_02 
               WHERE VALID_ACCT_QTTY>=1
                )  T9 --临时表02 取对公客户中存在有效账户的客户号存入临时表
            ON T1.CUST_ID=T9.CUST_ID;*/
            ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 8; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '补充企业手机银行注册用户到目标临时表';
  D_STARTTIME := SYSDATE;

  INSERT INTO TMP_M_MRPT_CONL_BK_CUST_DTL_03
         (
                 CUST_ID,
                 CUST_NAME,
                 SIGN_BRCH_ORG_ID,
                 SIGN_BRCH_NAME,
                 SIGN_NETW_ID,
                 SIGN_NETW_NAME,
                 BELONG_INDUTY_CD,
                 CONL_BK_STATUS_CD,
                 CONL_BK_STATUS_NAME,
                 CONL_BK_SIGN_DT,
                 CONL_BK_WRTOFF_DT,
                 SIGN_MBANK_FLG,
                 MBANK_SIGN_DT,
                 MBANK_WRTOFF_DT
         )
         SELECT
                 T1.CUST_ID AS CUST_ID                                       --客户编号
                ,T1.CUST_CN_NAME AS CUST_NAME                                --客户中文名称
                ,'' AS SIGN_BRCH_ORG_ID                                      --分行编号
                ,'' AS SIGN_BRCH_NAME                                        --分行名称
                ,'000000' AS SIGN_NETW_ID                                    --开户网点编号
                ,'广东华兴银行' AS SIGN_NETW_NAME                            --机构名称
                ,'' AS BELONG_INDUTY_CD                                      --行业类型代码
                ,'' AS CONL_BK_STATUS_CD                                     --网银客户状态代码
                ,'' AS CONL_BK_STATUS_NAME                                   --企业网银状态
                ,NULL AS CONL_BK_SIGN_DT                                     --开户时间
                ,NULL AS CONL_BK_WRTOFF_DT                                   --最后交易时间
                ,'注册' AS SIGN_MBANK_FLG                                    --开通手机银行标志
                -- 20
                ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <>'4' AND T1.SIGN_YQT_FLG='1' THEN TO_CHAR(T1.SIGN_YQT_TM,'YYYY-MM-DD') 
                      END AS MBANK_SIGN_DT                                   --签约银企通时间
                ,TO_CHAR(T1.OA_WRTOFF_TM,'YYYY-MM-DD') AS MBANK_WRTOFF_DT    --OA注销时间
            FROM ICL.V_CMM_CONL_BK_SIGN_INFO T1
           WHERE T1.ETL_DT = D_P_DATE
             AND T1.CUST_ID LIKE 'OA%'
             AND T1.SIGN_YQT_FLG='1';

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 9; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '企业网银客户明细表 插入目标表';
  D_STARTTIME := SYSDATE;

  INSERT INTO M_MRPT_CONL_BK_CUST_DTL
         (
                DATA_DT                                                     --数据日期
               ,CUST_ID                                                     --客户编号
               ,SIGN_BRCH_ORG_ID                                            --签约分行编号
               ,SIGN_BRCH_NAME                                              --签约分行名称
               ,SIGN_NETW_ID                                                --签约网点编号
               ,SIGN_NETW_NAME                                              --签约网点名称
               ,CUST_NAME                                                   --客户名称
               ,BELONG_INDUTY_CD                                            --所属行业代码
               ,CONL_BK_STATUS_CD                                           --企业网银状态代码
               ,CONL_BK_STATUS_NAME                                         --企业网银状态
               ,CONL_BK_SIGN_DT                                             --企业网银签约日期
               ,CONL_BK_WRTOFF_DT                                           --企业网银注销日期
               ,SIGN_MBANK_FLG                                              --签约手机银行标志
               ,MBANK_SIGN_DT                                               --手机银行签约日期
               ,MBANK_WRTOFF_DT                                             --手机银行注销日期
         )
         SELECT
                V_P_DATE  DATA_DT                                            --数据日期
               ,T1.CUST_ID                                                   --客户编号
               ,T1.CUST_NAME                                                 --客户名称
               ,T1.SIGN_BRCH_ORG_ID                                          --签约分行编号
               ,T1.SIGN_BRCH_NAME                                            --签约分行名称
               ,T1.SIGN_NETW_ID                                              --开户网点编号
               ,T1.SIGN_NETW_NAME                                            --签约网点名称
               ,T1.BELONG_INDUTY_CD                                          --所属行业代码
               ,T1.CONL_BK_STATUS_CD                                         --企业网银状态代码
               ,T1.CONL_BK_STATUS_NAME                                       --企业网银状态
               ,T1.CONL_BK_SIGN_DT                                           --企业网银签约日期
               ,T1.CONL_BK_WRTOFF_DT                                         --企业网银注销日期
               ,T1.SIGN_MBANK_FLG                                            --签约手机银行标志
               ,T1.MBANK_SIGN_DT                                             --手机银行签约日期
               ,T1.MBANK_WRTOFF_DT                                           --手机银行注销日期
          FROM  TMP_M_MRPT_CONL_BK_CUST_DTL_03 T1
   ;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

    --程序结束标记
  I_STEP := 10; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '-- 程序跑批结束 --';
  O_ERRCODE  := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');
  END IF;
  
--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    D_ENDTIME := SYSDATE;
   /* I_STEP := I_STEP + 1;
    V_STEP_DESC := '-- 程序跑批异常 --';*/
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

end ETL_M_MRPT_CONL_BK_CUST_DTL;
/

