CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_TRD_FNC_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_TRD_FNC_SUB
  *  功能描述：贸易融资贷款子表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_TRD_FNC_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_TRD_FNC_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
   V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
   V_TAB_NAME := 'M_LOAN_TRD_FNC_SUB'; --表名
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
  V_STEP_DESC := '插入贸易融资贷款子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRD_FNC_SUB
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,CONT_ID  --合同编号
      ,RCPT_ID  --借据编号
      ,CUST_ID  --客户编号
      ,TRA_FNC_VRTY  --贸易融资品种
      ,CUR  --币种
      ,COMM_AMT  --手续费金额
      ,ISU_BANK_NM  --开证行名称
      ,COMM_CUR  --手续费币种
      ,TRA_CONTENT  --贸易交易内容
      ,BUY_SIDE_NM  --购货方名称
      ,SELL_SIDE_NM  --销货方名称
      ,PAY_OBJ_NM  --支付对象名称
      ,REPY_OBJ_NM  --还款对象名称
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
      )
      SELECT
      V_P_DATE                DATA_DT     --数据日期
      ,A.LP_ID                 DATA_DT      --法人编号
      ,B.CONT_ID               CONT_ID      --合同编号
      ,A.DUBIL_ID             RCPT_ID      --借据编号
      ,A.CUST_ID                   CUST_ID      --客户编号
      ,CASE WHEN A.STD_PROD_ID = '203030300001'  THEN   '01'
            WHEN A.STD_PROD_ID = '203030300002'  THEN  '02'
            WHEN A.STD_PROD_ID IN(/* '2030208','2030302',*/'203020800001','203030200001')   THEN   '03'
            WHEN A.STD_PROD_ID = '203020200001'  THEN '04'
            WHEN A.STD_PROD_ID = '203020100001'   THEN  '05'
            WHEN A.STD_PROD_ID = '203020100005'   THEN  '06'
            WHEN A.STD_PROD_ID = '203020100002'   THEN   '07'
            WHEN A.STD_PROD_ID = '203020100006'   THEN  '08'
            WHEN A.STD_PROD_ID = '203020700001'    THEN  '09'
            WHEN A.STD_PROD_ID = '203020700002' THEN '10'
            WHEN A.STD_PROD_ID IN(/*'2030306',*/'203030600001','203030600001')   THEN  '11'
            WHEN A.STD_PROD_ID IN (/*'2030203',*/'203020300001')   THEN   '12'
            WHEN A.STD_PROD_ID = '203030600002'   THEN   '13'
            WHEN A.STD_PROD_ID IN( '203020700001','203020700001') THEN '23'
            WHEN A.STD_PROD_ID IN('203030500014','203030500015','203010100004') THEN '17'    --modify by xieyugeng 20221010 更新标准产品编号 国内保理  --modify by tangan at 20221201 新增产品203010100004
            WHEN A.STD_PROD_ID IN ('203020100004') THEN '14'
            WHEN A.STD_PROD_ID IN ('203020100003') THEN '15'
            WHEN A.STD_PROD_ID IN ('203020400001') THEN '21'
            WHEN A.STD_PROD_ID IN ('203020500001') THEN '22'
            ELSE '99'
         END                                              TRA_FNC_VRTY  --贸易融资品种  PROD_NAME内容需要与模型码值T0006对应，属于码值映射问题
       ,A.CURR_CD                                         CUR            --币种
       ,0                                                 COMM_AMT      --手续费金额
       ,C.ISSUE_BANK_NAME                                 ISU_BANK_NM    --开证行名称
       ,A.CURR_CD                                          COMM_CUR      --手续费币种
       ,E.TRADE_TRAN_CONTENT                               TRA_CONTENT    --贸易交易内容
       ,E.BUYER_NAME                                       BUY_SIDE_NM    --购货方名称
       ,E.SELLER_NAME                                     SELL_SIDE_NM  --销货方名称
       --,SUBSTR(G.ZFDX,1,450)                              PAY_OBJ_NM    --支付对象名称
       ,NVL(F.CUST_NAME,I.CUST_NAME)                       PAY_OBJ_NM  --支付对象名称
       ,CASE WHEN A.STD_PROD_ID IN ('203010100004', '203030500015','203030500014','203020100001','203020100003') THEN J.CUST_NAME   --国内保理,进口T/T项下押汇,出口T/T项下押汇,货到付款押汇
             WHEN A.STD_PROD_ID IN ('203030600001','203030600001','203020300001','203030600002') THEN K.ISSUE_BANK_CN_NAME --福费廷
             ELSE E.SELLER_NAME  END                   AS REPY_OBJ_NM    --还款对象名称  --20230112 LHQ 参考就east5.0 逻辑调整
       ,NULL                                           AS DEPT_LINE      --部门条线
       ,'贸易融资'                                     AS DATA_SRC      --数据来源
      FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
        ON B.DUBIL_NUM = A.DUBIL_ID
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN  RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F  --对公客户基本信息
           ON A.CUST_ID = F.CUST_ID
           AND F.ETL_DT =TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO C  --信用证账户信息
        ON C.LC_ID = A.BILL_NUM
       AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      /*LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO D --标准产品信息
        ON A.STD_PROD_ID = D.PROD_ID
       AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
      INNER JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)  --modify by tangan at 20221201
         ON A.STD_PROD_ID = TTA.SRC_VALUE_CODE
        AND TTA.SRC_CLASS_CODE = 'STD0002'
        AND TTA.TAR_CLASS_CODE = 'T0001'
        AND TTA.MOD_FLG = 'MDM'    --监管集市明细层
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO E  --对公贷款业务合同补充信息
        ON A.CONT_ID = E.CONT_ID
        and E.etl_dt = TO_DATE(V_P_DATE,'YYYYMMDD')
      /*LEFT JOIN (SELECT PUTOUTSERIALNO,
                        LISTAGG(DISTINCT A.PAYEENAME, ',') WITHIN GROUP(ORDER BY PUTOUTSERIALNO) ZFDX --支付对象
                   FROM RRP_MDL.O_IOL_ICMS_PAYMENT_INFO A --支付清单表
                  GROUP BY PUTOUTSERIALNO) G
        ON G.PUTOUTSERIALNO = A.OUT_ACCT_FLOW_NUM
       AND (B.MONEY_USE_TYPE IN ('1', '2') OR A.MONEY_USE_TYPE_CD = '2')  */
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H H  --公司贷款出账申请
           ON H.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
           AND H.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND H.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO I --对公客户基本信息
           ON I.CUST_ID = H.CUST_ID
          AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO J --对公客户基本信息
           ON J.CUST_ID = B.CUST_ID
          AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT LC_ACCT_ID,
                      MX_LC_FLG,
                      ISSUE_BANK_CN_NAME,
                      MIN(ACPT_DT) AS ACPT_DT,
                      MAX(PAY_DT) AS PAY_DT
                 FROM RRP_MDL.O_ICL_CMM_LC_DOC_INFO
                WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                GROUP BY LC_ACCT_ID, MX_LC_FLG, ISSUE_BANK_CN_NAME) K --信用证单据信息
           ON K.LC_ACCT_ID = C.ACCT_ID
          AND K.MX_LC_FLG = C.MX_LC_FLG
     WHERE A.ETL_DT =TO_DATE(V_P_DATE,'YYYYMMDD')
       --and D.LEVEL3_PROD_NAME LIKE '%贸易融资%'
       AND ( TTA.TAR_VALUE_CODE LIKE '0204%' OR TTA.TAR_VALUE_CODE ='0399') --贸易融资  --modify by tangan at 20221201
       ;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM M_LOAN_TRD_FNC_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

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

  END ETL_INIT_M_LOAN_TRD_FNC_SUB;
/

