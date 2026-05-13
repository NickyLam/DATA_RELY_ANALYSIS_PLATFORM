CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_TOP_G24_DATA(I_P_DATE      IN INTEGER,
                                         O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_S_TOP_G24
  *  功能描述：1104 G24 最大百家客户脚本
  *  创建日期：20221110
  *  开发人员：黄一凡
  *  来源表： RRP_MDL.S_CPTL_PEERS  同业业务整合表
              RRP_MDL.S_CPTL_REPO  回购业务整合表
              RRP_MDL.S_CPTL_CD    存单业务整合表
  *  目标表：S_TOP_G24 G24最大百家金融机构同业融入情况表
  *
  *  配置表：无
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20221110  黄一凡      创建
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_TOP_G24_DATA'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_TAB_NAME  VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE   := I_P_DATE; -- 获取跑批日期
  V_SYSTEM   := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE, 'YYYY-MM-DD')),
                        'YYYYMMDD'); --当月月底
  V_TAB_NAME := 'S_TOP_G24_DATA'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --删除临时表数据
  EXECUTE IMMEDIATE 'TRUNCATE TABLE S_TOP_G24_DATA_TMP';
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE S_TOP_G24_CUST_TMP';
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE S_TOP_G24_DATA';


   -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'S_TOP_G24_DATA', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT    := SQL%ROWCOUNT;
  V_SQLMSG      := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := 'G24最大十家金融机构同业融入情况明细临时表取值';
  V_STARTTIME := SYSDATE;

--同业业务整合表
INSERT INTO RRP_MDL.S_TOP_G24_DATA_TMP
(
  DATA_DT,                   --数据日期
  ORG_NO,                    --机构编号
  CUST_NO,                   --法人客户编号
  CURR_CD,                   --币种编号
  ORG_TYPE,                  --机构类型
  SETL_PEERS_DEP_FLG,        --结算性存款标志
  PEERS_PAY_FLG,             --同业代付标志
  FIN_INST_CODE,             --金融机构代码
  FIN_INST_NAME,             --金融机构名称
  BIZ_TYP,                   --业务类型
  BALNCE,                    --余额
  DATA_SRC,                  --数据来源
  BIO_FLG                    --境内外标志
)
SELECT A.DATA_DT AS DATA_DT       --数据日期
      ,SUBSTR(A.ORG_NO,1,3)||'001'  AS ORG_NO        --机构编号
	  ,NVL(TRIM(C.LGL_REP_CUST_ID),A.CUST_ID) AS CUST_NO       --法人客户编号
	  ,A.CUR     AS CURR_CD       --币种编号
	  ,''        AS ORG_TYPE      --机构类型
	  ,DECODE(A.SETL_PEERS_DEP_FLG,'Y','Y','N') AS SETL_PEERS_DEP_FLG --结算性存款标志
	  ,DECODE(A.PEERS_PAY_FLG,'1','Y','N') AS PEERS_PAY_FLG --同业代付标志
	  ,A.FIN_ORG_TYP AS FIN_INST_CODE --金融机构代码
	  ,E.TAR_VALUE_NAME AS FIN_INST_NAME --金融机构名称
	  ,A.BIZ_TYP AS BIZ_TYP       --业务类型
	  ,NVL(A.BAL,0) * D.EXRT AS BALNCE --余额
	  ,'同业业务' AS DATA_SRC --数据来源
    ,A.BIO_FLG AS BIO_FLG   --境内外标志
FROM RRP_MDL.S_CPTL_PEERS A --同业业务整合表
LEFT JOIN RRP_MDL.M_CUST_CORP_LVL_SUB C --法人客户表
ON A.CUST_ID = C.CUST_ID
AND C.DATA_DT = V_P_DATE
LEFT JOIN
	( SELECT DISTINCT E.TAR_VALUE_CODE,E.TAR_VALUE_NAME FROM RRP_MDL.CODE_MAP E
      WHERE  E.SRC_CLASS_CODE = 'CD1389'
      AND E.TAR_CLASS_CODE = 'C0005'
      AND E.MOD_FLG = 'MDM'
	) E
ON A.FIN_ORG_TYP = E.TAR_VALUE_CODE
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D --汇率表
ON A.CUR = D.BASE_CUR
AND D.CNV_CUR='CNY'
AND D.DATA_DT = V_P_DATE
WHERE A.DATA_DT = V_P_DATE
AND SUBSTR(A.FIN_ORG_TYP,1,1) <> 'F' --剔除保险公司
AND A.BAL > 0
;
COMMIT;
--回购业务整合表
INSERT INTO RRP_MDL.S_TOP_G24_DATA_TMP
(
  DATA_DT,                   --数据日期
  ORG_NO,                    --机构编号
  CUST_NO,                   --法人客户编号
  CURR_CD,                   --币种编号
  ORG_TYPE,                  --机构类型
  SETL_PEERS_DEP_FLG,        --结算性存款标志
  PEERS_PAY_FLG,             --同业代付标志
  FIN_INST_CODE,             --金融机构代码
  FIN_INST_NAME,             --金融机构名称
  BIZ_TYP,                   --业务类型
  BALNCE,                    --余额
  DATA_SRC,                  --数据来源
  BIO_FLG                    --境内外标志
)
SELECT A.DATA_DT AS DATA_DT       --数据日期
      ,SUBSTR(A.ORG_NO,1,3)||'001'  AS ORG_NO        --机构编号
	  ,NVL(TRIM(C.LGL_REP_CUST_ID),A.CUST_ID) AS CUST_NO       --法人客户编号
	  ,A.CUR     AS CURR_CD       --币种编号
	  ,''        AS ORG_TYPE      --机构类型
	  ,'N' AS SETL_PEERS_DEP_FLG --结算性存款标志
	  ,'N' AS PEERS_PAY_FLG --同业代付标志
	  ,A.FIN_ORG_TYP AS FIN_INST_CODE --金融机构代码
	  ,E.TAR_VALUE_NAME AS FIN_INST_NAME --金融机构名称
	  ,A.REPO_BIZ_TYP AS BIZ_TYP       --业务类型
	  ,NVL(A.BAL,0) * D.EXRT AS BALNCE --余额
	  ,'回购业务' AS DATA_SRC --数据来源
    ,A.BIO_FLG AS BIO_FLG   --境内外标志
FROM RRP_MDL.S_CPTL_REPO A --回购业务整合表
LEFT JOIN RRP_MDL.M_CUST_CORP_LVL_SUB C --法人客户表
ON A.CUST_ID = C.CUST_ID
AND C.DATA_DT = V_P_DATE
LEFT JOIN
	( SELECT DISTINCT E.TAR_VALUE_CODE,E.TAR_VALUE_NAME FROM RRP_MDL.CODE_MAP E
      WHERE  E.SRC_CLASS_CODE = 'CD1389'
      AND E.TAR_CLASS_CODE = 'C0005'
      AND E.MOD_FLG = 'MDM'
	) E
ON A.FIN_ORG_TYP = E.TAR_VALUE_CODE
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D --汇率表
ON A.CUR = D.BASE_CUR
AND D.CNV_CUR='CNY'
AND D.DATA_DT = V_P_DATE
WHERE A.DATA_DT = V_P_DATE
AND A.BAL > 0
;
COMMIT;
--存单业务整合表
INSERT INTO RRP_MDL.S_TOP_G24_DATA_TMP
(
  DATA_DT,                   --数据日期
  ORG_NO,                    --机构编号
  CUST_NO,                   --法人客户编号
  CURR_CD,                   --币种编号
  ORG_TYPE,                  --机构类型
  SETL_PEERS_DEP_FLG,        --结算性存款标志
  PEERS_PAY_FLG,             --同业代付标志
  FIN_INST_CODE,             --金融机构代码
  FIN_INST_NAME,             --金融机构名称
  BIZ_TYP,                   --业务类型
  BALNCE,                    --余额
  DATA_SRC,                  --数据来源
  BIO_FLG                    --境内外标志
)
SELECT A.DATA_DT AS DATA_DT       --数据日期
      ,SUBSTR(A.ORG_ID,1,3)||'001' AS ORG_NO        --机构编号
	  ,NVL(TRIM(C.LGL_REP_CUST_ID),A.CUST_ID) AS CUST_NO       --法人客户编号
	  ,A.CUR     AS CURR_CD       --币种编号
	  ,''        AS ORG_TYPE      --机构类型
	  ,'N' AS SETL_PEERS_DEP_FLG --结算性存款标志
	  ,'N' AS PEERS_PAY_FLG --同业代付标志
	  ,A.FIN_ORG_TYP AS FIN_INST_CODE --金融机构代码
	  ,E.TAR_VALUE_NAME AS FIN_INST_NAME --金融机构名称
	  ,'' AS BIZ_TYP       --业务类型
	  ,NVL(A.BOOK_BAL,0) * D.EXRT AS BALNCE --余额
	  ,'大额存单' AS DATA_SRC --数据来源
    ,A.BIO_FLG AS BIO_FLG   --境内外标志
FROM RRP_MDL.S_CPTL_CD A --存单业务整合表
LEFT JOIN RRP_MDL.M_CUST_CORP_LVL_SUB C --法人客户表
ON A.CUST_ID = C.CUST_ID
AND C.DATA_DT = V_P_DATE
LEFT JOIN
	( SELECT DISTINCT E.TAR_VALUE_CODE,E.TAR_VALUE_NAME FROM RRP_MDL.CODE_MAP E
      WHERE  E.SRC_CLASS_CODE = 'CD1389'
      AND E.TAR_CLASS_CODE = 'C0005'
      AND E.MOD_FLG = 'MDM'
	) E
ON A.FIN_ORG_TYP = E.TAR_VALUE_CODE
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D --汇率表
ON A.CUR = D.BASE_CUR
AND D.CNV_CUR='CNY'
AND D.DATA_DT = V_P_DATE
WHERE A.DATA_DT = V_P_DATE
AND A.DATA_SRC = '同业证券持仓'
AND A.BOOK_BAL > 0
;
COMMIT;


  V_SQLCOUNT    := SQL%ROWCOUNT;
  V_SQLMSG      := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                V_SQLMSG);

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := 'G24最大十家金融机构同业融入情况目标表取值';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_TOP_G24_DATA
(
  DATA_DT,                   --数据日期
  ORG_NO,                    --机构编号
  CUST_NO,                   --法人客户编号
  CURR_CD,                   --币种编号
  ORG_TYPE,                  --机构类型
  SETL_PEERS_DEP_FLG,        --结算性存款标志
  PEERS_PAY_FLG,             --同业代付标志
  FIN_INST_CODE,             --金融机构代码
  FIN_INST_NAME,             --金融机构名称
  BIZ_TYP,                   --业务类型
  BALNCE,                    --余额
  DATA_SRC,                  --数据来源
  BIO_FLG                    --境内外标志
)
SELECT
       A.DATA_DT   AS   DATA_DT   --数据日期
	  ,A.ORG_NO    AS   ORG_NO    --机构编号
	  ,C.FIN_ORG_ID   AS   CUST_NO   --法人客户编号
	  ,'BWB'       AS   CURR_CD   --币种编号
	  ,E.TAR_VALUE_NAME  AS ORG_TYPE --机构类型
	  ,A.SETL_PEERS_DEP_FLG AS SETL_PEERS_DEP_FLG   --结算性存款标志
      ,A.PEERS_PAY_FLG  AS PEERS_PAY_FLG --同业代付标志
	  ,C.FIN_ORG_TYP AS FIN_INST_CODE --金融机构代码
	  ,C.CUST_NM  AS FIN_INST_NAME --金融机构名称
	  ,A.BIZ_TYP   AS   BIZ_TYP   --业务类型
	  ,SUM(BALNCE) AS   BALNCE    --余额
	  ,A.DATA_SRC  AS   DATA_SRC  --数据来源
    ,A.BIO_FLG AS BIO_FLG   --境内外标志
FROM RRP_MDL.S_TOP_G24_DATA_TMP A --G24最大百家金融机构同业融入情况明细临时表
LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C
ON A.CUST_NO = C.CUST_ID
AND C.DATA_DT = V_P_DATE
LEFT JOIN
	( SELECT DISTINCT E.TAR_VALUE_CODE,E.TAR_VALUE_NAME FROM RRP_MDL.CODE_MAP E
      WHERE  E.SRC_CLASS_CODE = 'CD1389'
      AND E.TAR_CLASS_CODE = 'C0005'
      AND E.MOD_FLG = 'MDM'
	) E
ON C.FIN_ORG_TYP = E.TAR_VALUE_CODE
WHERE A.DATA_DT = V_P_DATE
GROUP BY      A.DATA_DT
	           ,A.ORG_NO
	           ,C.FIN_ORG_ID
	           ,'BWB'
	           ,E.TAR_VALUE_NAME
	           ,A.SETL_PEERS_DEP_FLG
             ,A.PEERS_PAY_FLG
	           ,C.FIN_ORG_TYP
	           ,C.CUST_NM
	           ,A.BIZ_TYP
	           ,A.DATA_SRC
             ,A.BIO_FLG
;

  V_SQLCOUNT    := SQL%ROWCOUNT;
  V_SQLMSG      := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                V_SQLMSG);


      -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GREEN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;


   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');


  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME     := SYSDATE;
    V_STEP        := V_STEP + 1;
    V_STEP_DESC   := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,
                  V_SYSTEM,
                  V_PROC_NAME,
                  V_STARTTIME,
                  V_ENDTIME,
                  V_STEP,
                  V_STEP_DESC,
                  V_SQLCOUNT,
                  O_ERRCODE,
                  V_SQLMSG);

END ETL_S_TOP_G24_DATA;
/

