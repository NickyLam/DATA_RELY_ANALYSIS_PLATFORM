CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_FIN_PRODUCT(I_P_DATE IN INTEGER, --跑批日期
                                              O_ERRCODE  OUT VARCHAR2 --错误代码
                                              )
/***********************************************************************
  **  存储过程详细说明：理财产品信息及资金投向
  **  存储过程名称:  ETL_M_FIN_PRODUCT
  **  存储过程创建日期:2022-06-08
  **  存储过程创建人：徐畅欣
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER;
         O_ERRCODE  CHAR(5);
       BEGIN
         I_P_DATE := '20220307';
         ETL_M_FIN_PRODUCT(I_P_DATE, O_ERRCODE);
       END;
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期        修改时间        修改人        修改原因
  **     1            20260408        LTJ         调整产品净值字段取值
***********************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_FIN_PRODUCT'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_FIN_PRODUCT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_FIN_PRODUCT T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_FIN_PRODUCT'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入理财产品数据信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.M_FIN_PRODUCT NOLOGGING
   (DATA_DT     --数据日期
    ,CODE       --产品编码
    ,NAME       --产品名称
    ,TYPE       --产品类型
    ,ORG_ID     --机构编号
    ,PRO_AMT    --产品金额
    ,PRO_NW_AMT --产品净值
    ,ASS_TYPE   --资产类别
    ,ASS_NAME   --资产名称
    ,ASS_NO     --资产编码（或合同号）
    ,ASS_Y_AMT  --资产原值
    ,ASS_J_AMT  --资产净值（或资产估值）
    ,CS_TYPE    --抵质押物类型
    ,CS_NO      --抵质押物账号（抵质押合同号）
    ,CS_AMT     --抵质押物金额（估值）
    ,CUR        --币种
    ,DATA_SRC   --数据来源
    ,DEPT_LINE  --部门条线
    )
  WITH B_FIN_PRODUCT_TM AS(
  SELECT  V_P_DATE                       AS DATA_DT    --数据日期
         ,B.FIN_PROD_ID                  AS CODE       --产品编码
         ,B.PROD_FNAME                   AS NAME       --产品名称
         ,B.INVEST_CHAR_CD               AS TYPE       --产品类型  --01 固定收益类02 权益类03 商品及金融衍生品类04 混合类
         ,NVL(ORG.ORG_ID1,B.SELL_ORG_ID) AS ORG_ID     --机构编号
         ,B.CURR_PRIC_BAL                AS PRO_AMT    --产品金额
         ,BF.NETTOTAL                    AS PRO_NW_AMT --产品净值 
         --,B.PROD_CURRT_NV                AS PRO_NW_AMT --产品净值
         ,DECODE(PCI.ACCT_TYPE,'A07','1101','A01','1101',NVL(NVL(RA.REP_ASSET_TYPE,FTP.REP_ASSET_TYPE),'')) 
                                         AS ASS_TYPE   --资产类别
         ,DECODE(PCI.ACCT_TYPE,'A07','券商保证金','A01','活期存款',NVL(C.PROD_FNAME,FTP.TERM_TYPE)) 
                                         AS ASS_NAME   --资产名称
         ,NVL(TRIM(C.FIN_PROD_ID),TRIM(A.FIN_PROD_CD_DESCB))||DECODE(A.INVEST_AIM_CD,NULL,NULL,'-',NULL,'_'||A.INVEST_AIM_CD) 
                                         AS ASS_NO     --资产编码（或合同号）避免重复 拼字段投资目的
         ,NVL(A.AMORT_TOT_COST,0)        AS ASS_Y_AMT  --资产原值
         ,NVL(A.AMORT_TOT_COST,0) + NVL(A.EVHA_VAL_CHAG,0)+NVL(A.TD_ACRU_INT,0) 
                                         AS ASS_J_AMT  --资产净值（或资产估值） --modify 20231012 根据余耀明老师的意见，取数逻辑需调整为 账面价值 (面值+公允价值变动+应计利息)
         ,D.PMO_TYPE_DESCB               AS CS_TYPE    --抵质押物类型
         ,SUBSTR(NVL(D.PMO_ACCT_NUM,D.FIN_PROD_ID),1,200) AS CS_NO      --抵质押物账号（抵质押合同号）
         ,D.PMO_EVLTION_AMT              AS CS_AMT     --抵质押物金额（估值）
         ,A.CURR_CD                      AS CUR        --币种
         ,SUBSTR(A.JOB_CD,0,4)           AS DATA_SRC   --数据来源
         ,''                             AS DEPT_LINE  --部门条线
         --MD BY 20221101 XUCX 本身是0余额的押品（信用保证押品）不参与押品价值拆分
         ,CASE WHEN D.PMO_EVLTION_AMT = 0 THEN NULL
               ELSE ROW_NUMBER() OVER(PARTITION BY NVL(C.FIN_PROD_ID, A.FIN_PROD_CD_DESCB),D.PMO_ACCT_NUM,
                                     CASE WHEN D.PMO_EVLTION_AMT = 0 THEN 'A' ELSE 'B' END
                                     ORDER BY NVL(A.AMORT_TOT_COST,0),B.FIN_PROD_ID DESC)
           END                           AS RM          --分组排序，最大资产原值排1
    FROM RRP_MDL.O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H  A --理财与资金产品估值信息历史
    LEFT JOIN (SELECT PROD_ID
                     ,FIN_PROD_ID
                     ,PROD_FNAME
                     ,INVEST_CHAR_CD
                     ,PROD_CURRT_NV
                     ,SELL_ORG_ID
                     ,SUM(NVL(CURR_PRIC_BAL,0)) AS CURR_PRIC_BAL
                 FROM RRP_MDL.O_ICL_CMM_FINC_PROD_BASIC_INFO B  --理财产品基本信息
                WHERE B.PROD_CATE_CD='F16'
                  AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY 20221212
                GROUP BY PROD_ID,FIN_PROD_ID,PROD_FNAME,INVEST_CHAR_CD,PROD_CURRT_NV,SELL_ORG_ID) B
      ON B.FIN_PROD_ID = A.COMB_PROD_CD_DESCB
    LEFT JOIN RRP_MDL.O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO C --资管投资标的产品信息
      ON C.PROD_ID = A.FIN_PROD_CD_DESCB
     AND C.VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --起息日期
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY 20221212
    LEFT JOIN (SELECT D.FIN_PROD_ID,D.PMO_TYPE_DESCB,D.PMO_ACCT_NUM,D.PMO_EVLTION_AMT,
                      ROW_NUMBER() OVER(PARTITION BY D.PMO_ACCT_NUM,D.FIN_PROD_ID ORDER BY D.EVLTION_DT DESC) AS RM--根据储明星意见 同一个质押品取估值日期最近的
                 FROM RRP_MDL.O_IML_PRD_INPWN_PROD_MGMT_INFO_H D  --质押品管理信息历史
                WHERE D.EVLTION_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --估值日期
                  AND D.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY 20221212
                  AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) D
      ON D.FIN_PROD_ID = A.FIN_PROD_CD_DESCB /*抵押品要素（此处需要修改按FIN_PRODUCT_PLEDGE按产品资产持有持仓比例取值）*/
     AND D.RM = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_AM_INVEST_UNDERLY_PROD_INFO DA --资管投资标的产品信息
      ON DA.PROD_ID = D.FIN_PROD_ID
     AND DA.VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --起息日期
     AND DA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY 20221212
    LEFT JOIN (SELECT REP_FINPROD_ID,REP_ASSET_TYPE,
                      ROW_NUMBER() OVER(PARTITION BY REP_FINPROD_ID ORDER BY CREATE_TIME DESC) AS RM
                 FROM RRP_MDL.O_IOL_FAMS_REP_ASSET_DEPT --资产报送
                 WHERE TRUNC(CREATE_TIME,'DD') <= TO_DATE(V_P_DATE,'YYYYMMDD')) RA
      ON RA.REP_FINPROD_ID = A.FIN_PROD_CD_DESCB
     AND RA.RM = 1
    LEFT JOIN (SELECT PORTFOLIO_ID,ACCT_NO,ACCT_TYPE,
                      ROW_NUMBER() OVER(PARTITION BY PORTFOLIO_ID,ACCT_NO ORDER BY UPDATE_TIME DESC) AS RM --ADD BY 20221212
                 FROM RRP_MDL.O_IOL_FAMS_PTL_CAPACCT_INFO  --资金账户  --ADD BY 20221212
                WHERE TRUNC(UPDATE_TIME) <= TO_DATE(V_P_DATE,'YYYYMMDD')) PCI
      ON PCI.PORTFOLIO_ID = A.COMB_PROD_CD_DESCB
     AND PCI.ACCT_NO = A.FIN_PROD_CD_DESCB
     AND PCI.RM = 1
    LEFT JOIN (SELECT FIN_PROD_ID AS FINPROD_ID,--金融产品代码
                      DECODE(PROD_CATE_CD,--金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
                             'F02','1902','F04','1902','F03','1108','F05','1108','F08','1901','1107') AS REP_ASSET_TYPE,
                      TENOR_BREED_CD AS TERM_TYPE,
                      ROW_NUMBER() OVER(PARTITION BY FIN_PROD_ID ORDER BY UPDATE_TM DESC) AS RM --ADD BY 20221212
				       FROM RRP_MDL.O_IML_PRD_AM_TRAN_CLASS_FIN_PROD  --交易类金融产品
              WHERE PROD_CATE_CD IN ('F02', 'F03', 'F04', 'F05', 'F08', 'F09')
                AND TRUNC(UPDATE_TM) <= TO_DATE(V_P_DATE,'YYYYMMDD')) FTP
      ON FTP.FINPROD_ID = A.FIN_PROD_CD_DESCB
     AND FTP.RM = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG ORG   --机构配置表
      ON ORG.ORG_ID = B.SELL_ORG_ID
    
    LEFT JOIN (SELECT BVTD.BOOKSET_ID,
                      FP.FIN_PROD_ID PORTFOLIO_ID,
                      SUM(DECODE(BVTD.DETAIL_DIST, '05', BVTD.MARKET_VALUE, -1 * BVTD.MARKET_VALUE)) NETTOTAL --根据资产-负债计算资产净值
		      	     FROM RRP_MDL.O_IOL_FAMS_BOK_VAL_TABLE_DATA BVTD  --估值表数据 
				         LEFT JOIN RRP_MDL.O_ICL_CMM_FINC_PROD_BASIC_INFO FP  --根据储明星口径
				           ON DECODE(FP.PRFT_MODE_CD, '02', FP.FIN_PROD_ID, FP.PROD_ID) = BVTD.BOOKSET_ID
                  AND FP.PROD_CATE_CD = 'F16'
				        WHERE BVTD.DETAIL_DIST IN ('05', '06') --资产类合计、负债类合计
				          AND BVTD.VAL_DATE = TO_DATE(V_P_DATE,'YYYYMMDD')
	                AND BVTD.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BVTD.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
	            GROUP BY BVTD.BOOKSET_ID,FP.FIN_PROD_ID ) BF
	    ON BF.PORTFOLIO_ID = A.COMB_PROD_CD_DESCB  --MOD BY LTJ 20260408
   WHERE A.BATCH_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.COMB_PROD_CD_DESCB != 'YSHJZXNZH' --过滤虚拟组合产品
     AND A.AMORT_TOT_COST > 0 --过滤资产原值为0的
     AND (NVL(RA.REP_ASSET_TYPE,FTP.REP_ASSET_TYPE) NOT IN ('1902','1901','2000')--1902同业拆入 1901卖出回购 2000其他负债 --根据余耀明老师的意见，剔除负债类资产
         OR NVL(RA.REP_ASSET_TYPE,FTP.REP_ASSET_TYPE) IS NULL)) --MD BY 20221101 XUCX
  SELECT  A.DATA_DT    --数据日期
         ,A.CODE       --产品编码
         ,A.NAME       --产品名称
         ,A.TYPE       --产品类型
         ,A.ORG_ID     --机构编号
         ,A.PRO_AMT    --产品金额
         ,A.PRO_NW_AMT --产品净值
         ,A.ASS_TYPE   --资产类别
         ,A.ASS_NAME   --资产名称
         ,A.ASS_NO     --资产编码（或合同号）
         ,A.ASS_Y_AMT  --资产原值
         ,A.ASS_J_AMT  --资产净值（或资产估值）
         ,A.CS_TYPE    --抵质押物类型
         ,A.CS_NO      --抵质押物账号（抵质押合同号）
         ,CASE WHEN A.CS_AMT = 0 THEN A.CS_AMT --质押品金额为0的不参与价值拆分
               WHEN A.CS_AMT <> 0 AND A.RM <> 1 THEN A.CS_AMT * A.ASS_Y_AMT / B.ASS_Y_AMT_SUM
              --拆分押品价值=押品价值*产品持有资产价值比例=押品价值*(当前产品当前资产的资产原值/当前资产在所有产品的资产原值合计)
               ELSE A.CS_AMT- (SUM(CASE WHEN A.RM = 1 THEN 0 ELSE A.CS_AMT * A.ASS_Y_AMT / B.ASS_Y_AMT_SUM END)
                                  OVER(PARTITION BY A.ASS_NO,A.CS_NO)) --最大占比的按照倒减算法
           END CS_AMT  --抵质押物金额（估值）
         ,CUR          --币种
         ,DATA_SRC     --数据来源
         ,DEPT_LINE    --部门条线
    FROM B_FIN_PRODUCT_TM A
    LEFT JOIN (SELECT ASS_NO,ASS_NAME,SUM(ASS_Y_AMT) AS ASS_Y_AMT_SUM
                 FROM B_FIN_PRODUCT_TM  --取资产总价值
                GROUP BY ASS_NO,ASS_NAME) B
      ON B.ASS_NO = A.ASS_NO
     AND B.ASS_NAME = A.ASS_NAME;

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
    SELECT DATA_DT, CODE,ASS_NO,CS_NO,COUNT(1)
      FROM RRP_MDL.M_FIN_PRODUCT T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, CODE,ASS_NO,CS_NO
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

END ETL_M_FIN_PRODUCT;
/

