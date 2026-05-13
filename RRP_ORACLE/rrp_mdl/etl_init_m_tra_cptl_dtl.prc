CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_TRA_CPTL_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_TRA_CPTL_DTL
  *  功能描述：监管集市银行机构存放或拆借及借款于境内、境外银行和非银行金融机构的款项交易流水。
     初始化一月数据
  *  创建日期：20230222
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            ICL.CMM_DEP_ACCT_TRAN_DTL   --存款账户交易明细表
  *            ICL.CMM_DEP_ACCT_INFO  --存款分户账
  *            IML.EVT_IFS_ACCT_TRAN_DTL   --联合存款账户交易明细
  *
  *  目标表：  M_TRA_CPTL_DTL  --资金业务交易流水
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220914  hulj     增加逻辑。
  *             2    20221122  hulj     增加数据重复校验。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_TRA_CPTL_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_TRA_CPTL_DTL'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 将参数转化为日期格式，判读输入参数是否符合日期要求 --
  V_DATE    := TO_DATE(SUBSTR(I_P_DATE, 1, 4) || '-' ||
                       SUBSTR(I_P_DATE, 5, 2) || '-' ||
                       SUBSTR(I_P_DATE, 7, 2),
                       'YYYY-MM-DD');

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
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户交易流水-存款分户流水';
  V_STARTTIME := SYSDATE;

  /***********************普通存款****************************/
  INSERT /*+ APPEND */INTO RRP_MDL.M_TRA_CPTL_DTL NOLOGGING
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
    ,SUB_ACC_ID_NEW                  --新一代子账户编号
  )
  SELECT
    V_P_DATE                                                                --数据日期
    ,A.LP_ID                                                                                     --法人编号
    ,A.TRAN_FLOW_NUM || A.ACCT_BILL_FLOW_NUM                                                     --交易流水号
    ,A.CUST_ACCT_ID                                                                              --账户编号
    ,/*JYLX.TAR_VALUE_CODE*/NULL                                                                              --交易类型
    ,A.ACCT_ORG_ID --20220916 XUXIAOBIN MODIFY                                                                --机构编号
    ,A.TRAN_ORG_ID                                                                               --经办机构编号
    ,ABS(A.TRAN_AMT)                                                                                  --交易金额
    ,/*DECODE(A.DEBIT_CRDT_DIR_CD,'D',C.CUST_ACCT_ID,DS.BANK_CAP_ACCT_ID)*/
    DS.BANK_CAP_ACCT_ID                              --对方账号
    ,A.CNTPTY_ACCT_NAME                                                                          --对方户名
    ,DECODE(A.DEBIT_CRDT_DIR_CD,'D','313581092013',TRIM(DS.BANK_CAP_ACCT_OPEN_BANK_NUM))           --对方行号
    ,A.CNTPTY_OPEN_BANK_NAME                                                                     --对方行名
    ,/*CASE WHEN A.CHN_CD IN ('1001','1002') THEN '01' --柜面                                      --交易渠道
                WHEN A.CHN_CD = '1003' THEN '02' --ATM
                WHEN A.CHN_CD = '1005' THEN '04' --POS
                WHEN A.CHN_CD IN ('1006', '1010', '1012','1033') THEN '05' --网银
                WHEN A.CHN_CD IN ('1007', '1008', '1011') THEN '06' --手机银行
                ELSE '09' END --其他*/
      CASE WHEN A.CHN_CD IN ('1001','1002','1013','1019') THEN '01' --01 柜面
                WHEN A.CHN_CD IN('1003','1039') THEN '04' --04 ATM
                WHEN A.CHN_CD IN ('1006','1010','1033','2202','EES','1018') THEN '02' --02 网银
                WHEN A.CHN_CD IN ('1022') THEN '06' --06 手机银行
                WHEN A.CHN_CD='1005' THEN '05' --05 POS
                WHEN A.CHN_CD IN ('2103','2306','CUP') THEN '99'
                WHEN A.CHN_CD IN ('1009','1014','1021') THEN '11' --11 其他自助终端
                WHEN A.CHN_CD IN ('1011','1016','1038','1042','1204','1205','1206','1211','1213','1214','1215','1216','1217','1220','2203','2204','9008','TFT') THEN '07'--07 第三方支付
                 ELSE '99'
       END   --20220916 XUXIAOBIN MODIFY
     ,NVL(TRIM(A.TRAN_CURR_CD),'CNY')                                                                              --币种
     ,DECODE(A.CASH_TRANS_FLG, '1','1','0','2')                                                   --现转标志
     ,NULL                                                                                        --提前支取标志
     ,A.AGENT_NAME                                                                                --代办人姓名
     ,F.TAR_VALUE_CODE                                                                            --代办人证件类型
     ,A.AGENT_CERT_NO                                                                             --代办人证件号码
     ,A.TRAN_TELLER_ID                                                                            --交易柜员号
     ,A.AUTH_TELLER_ID                                                                            --授权柜员号
     ,A.MEMO_CD_DESCB                                                                             --摘要
     ,CASE WHEN A.ERASE_ACCT_FLG = '1' THEN '4' --抹账
          WHEN A.REVS_FLG = '1' THEN '2' --冲账
        ELSE '1' END   --正常                                                                    --冲补抹标志
     ,CASE WHEN A.DEBIT_CRDT_DIR_CD IS NULL AND (A.ERASE_ACCT_FLG = '1' OR A.REVS_FLG =  '1')
      THEN 'D' ELSE A.DEBIT_CRDT_DIR_CD END                                                      --交易借贷标志
     ,A.TRAN_TIMESTAMP                                                                           --交易时间
     ,NULL                                                                                       --资产负债方标志
     ,C.SUBJ_ID                                                                                  --科目编号
     ,DECODE(A.DEBIT_CRDT_DIR_CD,'D','0','1')                         --20220928XUXIAOBIN ADD            --发生结清类型
     ,A.CLIENT_IP_ADDR                                                                           --IP地址
     ,A.CUST_TERMN_MAC_ADDR                                                                      --MAC地址
     ,NULL                                                                                       --业务发生时点实际利率
     ,NULL                                                                                       --业务发生金额
     ,'00001' --营运管理部                                                                       --部门条线
     ,'存款账户交易明细'                                                                     --数据来源
     ,/*NVL(C.OLD_CUST_ACCT_SUB_ACCT_NUM,D.OLD_SUB_ACCT_NUM)*/A.SUB_ACCT_ID                                                                              --子账户编号
     ,NULL                                                                                       --金融工具编号
     ,A.DEP_SUB_ACCT_ID                                                                                       --业务编号
     ,NULL                                                                                       --资产三分类代码
     ,A.SUB_ACCT_ID                                                                              --新一代子账户编号
  FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A  --存款账户交易明细表
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO C --存款分户信息
   /*ON A.CUST_ACCT_ID = C.CUST_ACCT_ID
   AND A.SUB_ACCT_ID = C.CUST_ACCT_SUB_ACCT_NUM*/
   ON A.DEP_SUB_ACCT_ID = C.ACCT_ID
   AND  C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN    (SELECT DISTINCT C.CUST_ACCT_ID
                                   ,T.BANK_CAP_ACCT_ID
                                   ,T.BANK_CAP_ACCT_OPEN_BANK_NUM
    FROM    O_IML_EVT_IBANK_TRAN_ACCT_INFO C --同业交易账户信息
       LEFT JOIN  O_IML_EVT_IBANK_TRAN T --同业交易表
       ON C.APV_ODD_NO = T.APV_ODD_NO
                  AND  T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE (TRIM(T.BANK_CAP_ACCT_ID) IS NOT NULL AND TRIM(T.BANK_CAP_ACCT_OPEN_BANK_NUM) IS NOT  NULL ) -- MDF BY
        ) DS
                ON A.CUST_ACCT_ID = DS.CUST_ACCT_ID

/*  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.TRAN_ORG_ID = B.ORG_ID
    AND B.ETL_DT = V_DATE*/
    LEFT JOIN O_ICL_CMM_INTNAL_ACCT D --内部账户
         ON A.CUST_ACCT_ID = D.MAIN_ACCT_ID
         AND A.SUB_ACCT_ID = D.SUB_ACCT_NUM
         AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  /*INNER JOIN RRP_MDL.M_CPTL_LBY_INFO E --关联同业，过滤出同业的数据
    ON A.DEP_SUB_ACCT_ID = E.ACC_ID
    AND E.DATA_DT = V_P_DATE*/
  LEFT JOIN RRP_MDL.CODE_MAP F --码值表
    ON A.AGENT_CERT_TYPE_CD = F.SRC_VALUE_CODE
   AND F.SRC_CLASS_CODE='CD1014'
   AND F.MOD_FLG = 'MDM'            --监管集市明细层
  LEFT JOIN RRP_MDL.CODE_MAP JYLX --交易类型
    ON A.TRAN_KIND_CD = JYLX.SRC_VALUE_CODE
   AND JYLX.SRC_CLASS_CODE='CD1311'
   AND JYLX.TAR_CLASS_CODE = 'D0121'
   AND JYLX.MOD_FLG = 'MDM'
  WHERE A.TRAN_AMT <> 0
    --AND A.ETL_DT = V_DATE
     AND TRUNC(A.TRAN_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ERASE_ACCT_FLG = '0'
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

 /*
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存放同业活期数据';
  V_STARTTIME := SYSDATE;

  \***********************存放同业活期****************************\
  INSERT \*+ APPEND *\INTO RRP_MDL.M_TRA_CPTL_DTL NOLOGGING
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
  )
    SELECT
    V_P_DATE                                                                --数据日期
    ,A.LP_ID                                                                                     --法人编号
    ,A.TRAN_FLOW_NUM                                                                             --交易流水号
    ,A.CUST_ACCT_NUM                                                                             --账户编号
    ,\*JYLX.TAR_VALUE_CODE*\NULL                                                                 --交易类型
    ,B.OPEN_ACCT_ORG_ID --20220916 XUXIAOBIN MODIFY                                              --机构编号
    ,B.OPEN_ACCT_ORG_ID                                                                          --经办机构编号
    ,ABS(A.TRAN_AMT)                                                                            --交易金额
    ,A.CNTPTY_CUST_ACCT_NUM                                                                      --对方账号
    ,A.CNTPTY_ACCT_NAME                                                                      --对方户名
    ,NULL                                                                      --对方行号
    ,NULL                                                                      --对方行名
    ,CASE WHEN A.CHN_ID IN ('1001','1002','1013','1019') THEN '01' --01 柜面
                WHEN A.CHN_ID IN('1003','1039') THEN '04' --04 ATM
                WHEN A.CHN_ID IN ('1006','1010','1033','2202','EES','1018') THEN '02' --02 网银
                WHEN A.CHN_ID IN ('1022') THEN '06' --06 手机银行
                WHEN A.CHN_ID='1005' THEN '05' --05 POS
                WHEN A.CHN_ID IN ('2103','2306','CUP') THEN '99'
                WHEN A.CHN_ID IN ('1009','1014','1021') THEN '11' --11 其他自助终端
                WHEN A.CHN_ID IN ('1011','1016','1038','1042','1204','1205','1206','1211','1213','1214','1215','1216','1217','1220','2203','2204','9008','TFT') THEN '07'--07 第三方支付
                 ELSE '99'
       END   --20220916 XUXIAOBIN MODIFY                                                         --交易渠道
     ,A.ACCT_CURR_CD                                                                                  --币种
     ,A.CASH_TRAN_FLG                                                                            --现转标志
     ,NULL                                                                                        --提前支取标志
     ,A.TRAN_PUBLIC_AGENT_NAME                                                                    --代办人姓名
     ,NULL                                                                                        --代办人证件类型
     ,NULL                                                                                        --代办人证件号码
     ,A.TRAN_TELLER_ID                                                                            --交易柜员号
     ,A.AUTH_TELLER_ID                                                                            --授权柜员号
     ,A.MEMO_CODE                                                                                 --摘要
     ,CASE WHEN A.REVS_FLG = '1' THEN '2' --冲账
        ELSE '1' END   --正常                                                                    --冲补抹标志
     ,NULL                                                                                       --交易借贷标志
     ,A.TRAN_TM                                                                                  --交易时间
     ,NULL                                                                                       --资产负债方标志
     ,B.SUBJ_ID                                                                                  --科目编号
     ,DECODE(A.DEBIT_CRDT_FLG,'D','1','0')                                                       --发生结清类型 DEBIT_CRDT_FLG D转入 C转出
     ,NULL                                                                                       --IP地址
     ,NULL                                                                                       --MAC地址
     ,NULL                                                                                       --业务发生时点实际利率
     ,NULL                                                                                       --业务发生金额
     ,'00001' --营运管理部                                                                       --部门条线
     ,'存放同业活期'                                                                             --数据来源
     ,C.OLD_SUB_ACCT_NUM                                                                             --子账户编号
     ,NULL                                                                                       --金融工具编号
     ,A.ACCT_ID                                                                                  --业务编号
     ,NULL                                                                                       --资产三分类代码
  FROM RRP_MDL.O_IML_EVT_DEP_FIN_TRAN_FLOW A --存款金融交易流水
  INNER JOIN RRP_MDL.O_ICL_CMM_NOSTRO_ACCT_INFO B --存放同业账户信息
    ON A.CUST_ACCT_NUM||A.SUB_ACCT_NUM = B.CUST_ACCT_ID||B.CUST_SUB_ACCT_ID
   AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT C
        ON B.CUST_ACCT_ID = C.MAIN_ACCT_ID
     AND B.CUST_SUB_ACCT_ID = C.SUB_ACCT_NUM
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE A.TRAN_AMT <> 0
     AND TRUNC(A.TRAN_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
    ;
  */

/*  SELECT
    V_P_DATE                                                                --数据日期
    ,A.LP_ID                                                                                     --法人编号
    ,A.TRAN_FLOW_NUM || A.ACCT_BILL_FLOW_NUM                                                     --交易流水号
    ,A.CUST_ACCT_ID                                                                              --账户编号
    ,\*JYLX.TAR_VALUE_CODE*\NULL                                                                              --交易类型
    ,A.ACCT_ORG_ID --20220916 XUXIAOBIN MODIFY                                                                --机构编号
    ,A.TRAN_ORG_ID                                                                               --经办机构编号
    ,A.TRAN_AMT                                                                                  --交易金额
    ,TRIM(A.CNTPTY_ACCT_ID)                                                                      --对方账号
    ,A.CNTPTY_ACCT_NAME                                                                          --对方户名
    ,A.CNTPTY_OPEN_BANK_ID                                                                       --对方行号
    ,A.CNTPTY_OPEN_BANK_NAME                                                                     --对方行名
    ,\*CASE WHEN A.CHN_CD IN ('1001','1002') THEN '01' --柜面                                      --交易渠道
                WHEN A.CHN_CD = '1003' THEN '02' --ATM
                WHEN A.CHN_CD = '1005' THEN '04' --POS
                WHEN A.CHN_CD IN ('1006', '1010', '1012','1033') THEN '05' --网银
                WHEN A.CHN_CD IN ('1007', '1008', '1011') THEN '06' --手机银行
                ELSE '09' END --其他*\
      CASE WHEN A.CHN_CD IN ('1001','1002','1013','1019') THEN '01' --01 柜面
                WHEN A.CHN_CD IN('1003','1039') THEN '04' --04 ATM
                WHEN A.CHN_CD IN ('1006','1010','1033','2202','EES','1018') THEN '02' --02 网银
                WHEN A.CHN_CD IN ('1022') THEN '06' --06 手机银行
                WHEN A.CHN_CD='1005' THEN '05' --05 POS
                WHEN A.CHN_CD IN ('2103','2306','CUP') THEN '99'
                WHEN A.CHN_CD IN ('1009','1014','1021') THEN '11' --11 其他自助终端
                WHEN A.CHN_CD IN ('1011','1016','1038','1042','1204','1205','1206','1211','1213','1214','1215','1216','1217','1220','2203','2204','9008','TFT') THEN '07'--07 第三方支付
                 ELSE '99'
       END   --20220916 XUXIAOBIN MODIFY
     ,A.TRAN_CURR_CD                                                                              --币种
     ,DECODE(A.CASH_TRANS_FLG, '1','1','0','2')                                                   --现转标志
     ,NULL                                                                                        --提前支取标志
     ,A.AGENT_NAME                                                                                --代办人姓名
     ,F.TAR_VALUE_CODE                                                                            --代办人证件类型
     ,A.AGENT_CERT_NO                                                                             --代办人证件号码
     ,A.TRAN_TELLER_ID                                                                            --交易柜员号
     ,A.AUTH_TELLER_ID                                                                            --授权柜员号
     ,A.MEMO_CD_DESCB                                                                             --摘要
     ,CASE WHEN A.ERASE_ACCT_FLG = '1' THEN '4' --抹账
          WHEN A.REVS_FLG = '1' THEN '2' --冲账
        ELSE '1' END   --正常                                                                    --冲补抹标志
     ,CASE WHEN A.DEBIT_CRDT_DIR_CD IS NULL AND (A.ERASE_ACCT_FLG = '1' OR A.REVS_FLG =  '1')
      THEN 'D' ELSE A.DEBIT_CRDT_DIR_CD END                                                      --交易借贷标志
     ,A.TRAN_TIMESTAMP                                                                           --交易时间
     ,NULL                                                                                       --资产负债方标志
     ,C.SUBJ_ID                                                                                  --科目编号
     ,DECODE(A.DEBIT_CRDT_DIR_CD,'D','0','1')                         --20220928XUXIAOBIN ADD            --发生结清类型
     ,A.CLIENT_IP_ADDR                                                                           --IP地址
     ,A.CUST_TERMN_MAC_ADDR                                                                      --MAC地址
     ,NULL                                                                                       --业务发生时点实际利率
     ,NULL                                                                                       --业务发生金额
     ,'00001' --营运管理部                                                                       --部门条线
     ,'存款账户交易明细'                                                                     --数据来源
     ,NVL(C.OLD_CUST_ACCT_SUB_ACCT_NUM,D.OLD_SUB_ACCT_NUM)                                                                              --子账户编号
     ,NULL                                                                                       --金融工具编号
     ,A.DEP_SUB_ACCT_ID                                                                                       --业务编号
     ,NULL                                                                                       --资产三分类代码
  FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A  --存款账户交易明细表
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO C --存款分户信息
   \*ON A.CUST_ACCT_ID = C.CUST_ACCT_ID
   AND A.SUB_ACCT_ID = C.CUST_ACCT_SUB_ACCT_NUM*\
   ON A.DEP_SUB_ACCT_ID = C.ACCT_ID
   AND  C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
\*  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.TRAN_ORG_ID = B.ORG_ID
    AND B.ETL_DT = V_DATE*\
    LEFT JOIN O_ICL_CMM_INTNAL_ACCT D --内部账户
         ON A.CUST_ACCT_ID = D.MAIN_ACCT_ID
         AND A.SUB_ACCT_ID = D.SUB_ACCT_NUM
         AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  \*INNER JOIN RRP_MDL.M_CPTL_LBY_INFO E --关联同业，过滤出同业的数据
    ON A.DEP_SUB_ACCT_ID = E.ACC_ID
    AND E.DATA_DT = V_P_DATE*\
  LEFT JOIN RRP_MDL.CODE_MAP F --码值表
    ON A.AGENT_CERT_TYPE_CD = F.SRC_VALUE_CODE
   AND F.SRC_CLASS_CODE='CD1014'
   AND F.MOD_FLG = 'MDM'            --监管集市明细层
  LEFT JOIN RRP_MDL.CODE_MAP JYLX --交易类型
    ON A.TRAN_KIND_CD = JYLX.SRC_VALUE_CODE
   AND JYLX.SRC_CLASS_CODE='CD1311'
   AND JYLX.TAR_CLASS_CODE = 'D0121'
   AND JYLX.MOD_FLG = 'MDM'
  WHERE A.TRAN_AMT <> 0
    --AND A.ETL_DT = V_DATE
     AND TRUNC(A.TRAN_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')*/

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存放同业活期定期';
  V_STARTTIME := SYSDATE;

  /***********************存放同业活期****************************/
  INSERT /*+ APPEND */INTO RRP_MDL.M_TRA_CPTL_DTL NOLOGGING
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
  )
    SELECT
    V_P_DATE                                                                --数据日期
    ,A.LP_ID                                                                                     --法人编号
    ,A.MAIN_INSTR_SEQ_NUM                                                                        --交易流水号
    ,D.FIN_INSTM_ID                                                                             --账户编号
    ,/*JYLX.TAR_VALUE_CODE*/NULL                                                                 --交易类型
    ,G.BELONG_ORG_ID --20220916 XUXIAOBIN MODIFY                                              --机构编号
    ,G.BELONG_ORG_ID                                                                          --经办机构编号
    ,ABS(F.ACTL_NET_PRICE_AMT)                                                                --交易金额
    ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
             THEN   b.CNTPTY_ACCT_NUM
              ELSE TT2.PAYER_ACCT_NUM END        OPP_ACC                                      --对方账号
    ,NULL                                                                      --对方户名
    ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
               THEN b.CNTPTY_OPEN_BANK_NUM
                 ELSE TT2.PAYER_OPEN_BANK_NO
        END       AS OPP_PBC_NO                                                                  --对方行号
    ,NULL                                                                                        --对方行名
    ,NULL                                                                                        --交易渠道
     ,D.CURR_CD                                                                                  --币种
     ,NULL                                                                                       --现转标志
     ,NULL                                                                                       --提前支取标志
     ,A.OPERR_NAME                                                                               --代办人姓名
     ,NULL                                                                                       --代办人证件类型
     ,NULL                                                                                       --代办人证件号码
     ,NULL                                                                                       --交易柜员号
     ,NULL                                                                                       --授权柜员号
     ,NULL                                                                                       --摘要
     ,NULL                                                                                       --冲补抹标志
     ,NULL                                                                                       --交易借贷标志
     ,TO_TIMESTAMP(A.TRAN_DT,'dd-MON-yyhh:mi:ss.ff AM')                                          --交易时间
     ,NULL                                                                                       --资产负债方标志
     ,G.SUBJ_ID                                                                                  --科目编号
     ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531') THEN '0'
                ELSE '1'  END                                                       --发生结清类型
     ,NULL                                                                                       --IP地址
     ,NULL                                                                                       --MAC地址
     ,NULL                                                                                       --业务发生时点实际利率
     ,NULL                                                                                       --业务发生金额
     ,'00001' --营运管理部                                                                       --部门条线
     ,'存放同业定期'                                                                             --数据来源
     ,NULL                                                                             --子账户编号
     ,NULL                                                                                       --金融工具编号
     ,D.FIN_INSTM_ID                                                                                  --业务编号
     ,NULL                                                                                       --资产三分类代码
     FROM RRP_MDL.O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL A --同业主指令明细
     LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN B --同业交易表
       ON A.INTNAL_TRAN_FLOW_NUM = B.INTNAL_TRAN_NUM
     LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN C --同业交易表
       ON B.QUOTE_TRAN_NUM = C.TRAN_NUM
     LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM D --同业金融工具表
       ON B.FIN_INSTM_ID = D.FIN_INSTM_ID
      AND B.ASSET_TYPE_ID = D.ASSET_TYPE_ID
      AND B.TRAN_MARKET_ID = D.MARKET_TYPE_ID
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_IML_AGT_IBANK_DEP_RCPT E  --同业存单表
       ON B.FIN_INSTM_ID = E.DEP_RCPT_CD
      AND B.ASSET_TYPE_ID = E.ASSET_TYPE_CD
      AND B.TRAN_MARKET_ID = E.MARKET_TYPE_CD
      AND '101007'||C.INTNAL_TRAN_NUM = E.VOUCH_ID
     LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL F --同业券指令明细
       ON F.MAIN_INSTR_SEQ_NUM = A.MAIN_INSTR_SEQ_NUM
     LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST G --同业证券持仓表
       ON G.BUS_ID=B.INTNAL_TRAN_NUM
      AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN  RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW  TT1 --ADD BY wyp 20220124 回收时付款人
       ON A.ACTL_STL_DT = TT1.TRAN_DT
      --AND ABS(F.ACTL_NET_PRICE_AMT) = TT1.TRAN_AMT  --金额不一致
      AND b.CNTPTY_NAME = TT1.PAYER_NAME
     LEFT JOIN RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW TT2 --ADD BY wyp 20220124  发放时取收款人
       ON A.ACTL_STL_DT = TT2.TRAN_DT
      AND ABS(F.ACTL_NET_PRICE_AMT) = TT2.TRAN_AMT
      AND b.CNTPTY_ACCT_NUM = TT2.RECVER_ACCT_NUM
    WHERE D.PROD_TYPE_CD ='0121'
      AND A.TRAN_TYPE_CD NOT LIKE D.PROD_TYPE_CD||'2%'
      --AND A.INSTR_STATUS_CD='02' --还需确认逻辑
      AND (A.PARENT_INSTR_ID IN (0,-1) OR A.PARENT_INSTR_ID = A.MAIN_INSTR_SEQ_NUM)
      AND F.ACTL_NET_PRICE_AMT+F.ACTL_ACRU_INT<>0
      AND A.ACTL_STL_DT >= D.VALUE_DT
      AND A.ACTL_STL_DT <= D.EXP_DT
      AND A.PARENT_INSTR_ID <> 0   --20220118 MDF BY WDC 避免出现重复的存放同业定期账号
      AND TRUNC(A.ACTL_STL_DT, 'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
/*
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户交易流水-大额存单数据信息';
  V_STARTTIME := SYSDATE;

  \****************大额存单**************\
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
  )
  SELECT
    TO_CHAR(T1.ETL_DT, 'YYYYMMDD')                                                                   --数据日期
    ,T1.LP_ID                                                                                        --法人编号
    ,T1.TRAN_FLOW_NUM                                                                                --交易流水号
    ,T4.CUST_ACCT_ID                                                                                 --账户编号
    ,T1.TRAN_KIND_CD                                                                                 --交易类型
    ,E.ORG_ID                                                                                        --机构编号
    ,T1.TRAN_ORG_ID                                                                                  --经办机构编号
    ,T1.TRAN_AMT                                                                                     --交易金额
    ,TRIM(T1.CNTPTY_ACCT_ID)                                                                              --对方账号
    ,T1.CNTPTY_ACCT_NAME                                                                             --对方户名
    ,T1.CNTPTY_OPEN_BANK_ID                                                                          --对方行号
    ,T1.CNTPTY_OPEN_BANK_NAME                                                                        --对方行名
    ,CASE WHEN T1.CHN_CD IN ('1001','1002','1013','1019') THEN '01' --01 柜面
                WHEN T1.CHN_CD IN('1003','1039') THEN '04' --04 ATM
                WHEN T1.CHN_CD IN ('1006','1010','1033','2202','EES','1018') THEN '02' --02 网银
                WHEN T1.CHN_CD IN ('1022') THEN '06' --06 手机银行
                WHEN T1.CHN_CD='1005' THEN '05' --05 POS
                WHEN T1.CHN_CD IN ('2103','2306','CUP') THEN '99'
                WHEN T1.CHN_CD IN ('1009','1014','1021') THEN '11' --11 其他自助终端
                WHEN T1.CHN_CD IN ('1011','1016','1038','1042','1204','1205','1206','1211','1213','1214','1215','1216','1217','1220','2203','2204','9008','TFT') THEN '07'--07 第三方支付
                 ELSE '99'
       END                                                                                           --交易渠道
    ,T1.TRAN_CURR_CD                                                                                 --币种
    ,CASE WHEN T1.CASH_TRANS_FLG = 'CS' THEN '1' ELSE '2' END                                        --现转标志
    ,NULL                                                                                            --提前支取标志
    ,NULL                                                                                            --代办人姓名
    ,NULL                                                                                            --代办人证件类型
    ,NULL                                                                                            --代办人证件号码
    ,T1.TRAN_TELLER_ID                                                                               --交易柜员号
    ,T1.AUTH_TELLER_ID                                                                               --授权柜员号
    ,T1.MEMO_CD_DESCB                                                                                --摘要
    ,CASE WHEN T1.REVS_FLG = '1' THEN '2' --冲账
      ELSE '1' END  --正常                                                                           --冲补抹标志
    ,DECODE(T1.DEBIT_CRDT_DIR_CD, '1','D','0','C')                                                   --交易借贷标志
    ,T1.TRAN_TIMESTAMP                                                                               --交易时间
    ,NULL                                                                                            --资产负债方标志
    ,T4.SUBJ_ID                                                                                       --科目编号
    ,NULL                                                                                            --发生结清类型
    ,NULL                                                                                            --IP地址
    ,NULL                                                                                            --MAC地址
    ,NULL                                                                                            --业务发生时点实际利率
    ,NULL                                                                                            --业务发生金额
    ,'00001' --营运管理部                                                                            --部门条线
    ,SUBSTR(T1.JOB_CD, 0, 4)                                                                         --数据来源
    ,T4.cust_acct_sub_acct_num                                                                       --子账户编号
    ,NULL                                                                                            --金融工具编号
    ,NULL                                                                                            --业务编号
    ,NULL                                                                                            --资产三分类代码
  FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL T1  --存款账户交易明细表 O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL T1 --储蓄产品户动账交易明细
  LEFT JOIN (
    SELECT ACCT_ID, CUST_ID, CUST_ACCT_ID, DEP_KIND_CD,cust_acct_sub_acct_num, CDS_LIAB_ACCT_NUM AS LIAB_ACCT_ID
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO  WHERE ETL_DT = V_DATE --存款分户账
 ) T4
    ON T4.ACCT_ID = T1.DEP_SUB_ACCT_ID
  \*INNER JOIN RRP_MDL.M_CPTL_LBY_INFO E
    ON T4.ACCT_ID = E.ACC_ID
    AND  E.DATA_DT = V_P_DATE*\
  WHERE
    T4.DEP_KIND_CD IN ('A18','S21')
    AND T1.ETL_DT = V_DATE
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
*/
 /* V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户交易流水-联合存款数据信息';
  V_STARTTIME := SYSDATE;

  \******************联合存款******************\
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
  )
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                                --数据日期
    ,A.LP_ID                                                                                     --法人编号
    ,A.TRAN_FLOW_ID                                                                              --交易流水号
    ,A.ACCT_ID                                                                                   --账户编号
    ,NULL                                                                                        --交易类型
    ,E.ORG_ID                                                                                    --开户机构
    ,A.TRAN_ORG_ID                                                                               --经办机构编号
    ,A.TRAN_AMT                                                                                  --交易金额
    ,TRIM(A.CNTPTY_ACCT_ID)                                                                            --对方账号
    ,A.CNTPTY_ACCT_NAME                                                                          --对方户名
    ,A.CNTPTY_ORG_ID                                                                             --对方行号
    ,NULL                                                                                        --对方行名
    ,CASE WHEN A.TRAN_CHN_CD IN ('1001','1002','1013','1019') THEN '01' --01 柜面
          WHEN A.TRAN_CHN_CD IN('1003','1039') THEN '02' --04 ATM
          WHEN A.TRAN_CHN_CD IN ('1006','1010','1033','2202','EES','1018') THEN '05' --02 网银
          WHEN A.TRAN_CHN_CD IN ('1022') THEN '06' --06 手机银行
          WHEN A.TRAN_CHN_CD='1005' THEN '04' --05 POS
          WHEN A.TRAN_CHN_CD IN ('1011','1016','1038','1042','1204','1205','1206','1211','1213','1214','1215','1216','1217','1220','2203','2204','9008','TFT') THEN '07'--07 第三方支付
     ELSE '09'
     END                                                                                         --交易渠道
    ,'CNY'                                                                                       --币种
    ,'2'                                                                                         --现转标志
    ,NULL                                                                                        --提前支取标志
    ,NULL                                                                                        --代办人姓名
    ,NULL                                                                                        --代办人证件类型
    ,NULL                                                                                        --代办人证件号码
    ,'999'                                                                                       --交易柜员号
    ,'999'                                                                                       --授权柜员号
    ,NULL                                                                                        --摘要
    ,'1'   --正常                                                                                --冲补抹标志
    ,SUBSTR(A.DEBIT_CRDT_DIR_CD,2,1)                                                             --交易借贷标志
    ,NULL                                                                                        --交易时间
    ,NULL                                                                                        --资产负债方标志
    ,E.SUBJ_ID                                                                                   --科目编号
    ,DECODE(A.DEBIT_CRDT_DIR_CD,'D','0','1')                               --20220928XUXIAOBINADD--发生结清类型
    ,NULL                                                                                        --IP地址
    ,NULL                                                                                        --MAC地址
    ,NULL                                                                                        --业务发生时点实际利率
    ,NULL                                                                                        --业务发生金额
    ,'00001' --营运管理部                                                                        --部门条线
    ,'联合存款'                                                                      --数据来源
    ,A.DEP_SUB_ACCT_ID                                                                           --子账户编号
    ,NULL                                                                                        --金融工具编号
    ,NULL                                                                                        --业务编号
    ,NULL                                                                                        --资产三分类代码
  FROM RRP_MDL.O_IML_EVT_IFS_ACCT_TRAN_DTL A  --联合存款账户交易明细
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.TRAN_ORG_ID = B.ORG_ID
    AND B.ETL_DT = V_DATE
  INNER JOIN RRP_MDL.M_CPTL_LBY_INFO E
    ON A.ACCT_ID||A.DEP_SUB_ACCT_ID = E.ACC_ID
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;*/

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-资金系统同业拆借数据--发生';
  V_STARTTIME := SYSDATE;

  /******************资金系统同业拆借******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
     V_P_DATE               AS DATA_DT                         --数据日期
    ,A.LP_ID                AS LGL_REP_ID                      --法人编号
    ,A.TRAN_ID||'_1'        AS SEQ_NO                          --流水号
    ,NVL(A.BAG_ID,'999')    AS ACC_ID                          --账户编号
    ,A.TRAN_CATE_CD         AS TRA_TYP                         --交易类型
    ,E.ORG_ID               AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.ENTRY_ORG_ID         AS HDL_ORG_ID                      --经办机构编号
    ,ABS(A.TRAN_AMT)             AS TRA_AMT                    --交易金额
    ,A.TRAN_CLEAR_ACCT_ID   AS OPP_ACC                         --对方账号
    ,A.CNTPTY_NAME          AS OPP_ACC_NM                      --对方户名
    ,A.TRAN_CLEAR_BANK_NO   AS OPP_PBC_NO                      --对方行号
    ,A.TRAN_CLEAR_BANK_NAME AS OPP_BANK_NM                     --对方行名
    ,NULL                   AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD              AS CUR                             --币种
    ,'2'                    AS CASH_TRF_FLG                    --现转标志
    ,NULL                   AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                   AS AGT_NM                          --代办人姓名
    ,NULL                   AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                   AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                  AS TRA_TLR_NO                      --交易柜员号
    ,'999'                  AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                   AS ABSTR                           --摘要
    ,'1'                    AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,CASE WHEN TRIM(A.TRAN_DIR_CD)IN('1','01') THEN 'C'
          WHEN TRIM(A.TRAN_DIR_CD)IN('2','02') THEN 'D'
          END               AS TRA_DR_CR_FLG                   --交易借贷标志
    ,/*A.TRAN_DT*/A.VALUE_DT              AS TRA_TM                          --交易时间
    ,NULL                   AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,A.SUBJ_ID              AS SUBJ_ID                         --科目编号
/*    ,CASE WHEN  TRUNC(A.VALUE_DT,'MM') = TRUNC(V_DATE,'MM') THEN '1'
     WHEN  TRUNC(A.EXP_DT,'MM') = TRUNC(V_DATE,'MM')  THEN '0' END
     AS OCCUR_SETL_TYP  --20220928 XUXIAOBIN ADD                --发生结清类型*/
    ,'1'                     AS OCCUR_SETL_TYP                   --发生结清类型
    ,NULL                   AS IP                              --IP地址
    ,NULL                   AS MAC                             --MAC地址
    ,A.EXEC_INT_RAT         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                   AS BIZ_AMT                         --业务发生金额
    ,'800976'               AS DEPT_LINE                       --部门条线 --资金交易部
    ,'资金同业拆借发生' AS DATA_SRC                                  --数据来源
    ,NULL                   AS SUB_ACC_ID                      --子账户编号
    ,NULL                   AS FIN_INSTM_ID                    --金融工具编号
    ,A.BUS_ID               AS BUS_ID                          --业务编号
    ,A.ASSET_THD_CLS_CD     AS ASSET_THD_CLS_CD                --资产三分类代码
   FROM O_ICL_CMM_CAP_IB_LEND A --资金同业拆借 A
   LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
       ON A.CNTPTY_ID = G.CUST_ID
       AND G.ETL_DT = A.ETL_DT
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO E  --内部机构信息表
      ON A.ENTRY_ORG_ID = E.ORG_ID
      AND E.ETL_DT = V_DATE
  WHERE A.TRAN_CATE_CD = '0'
   --AND A.SUBJ_ID LIKE '1302%' -- 拆放同业
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRUNC(A.VALUE_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;



    V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-资金系统同业拆借数据--结清';
  V_STARTTIME := SYSDATE;

  /******************资金系统同业拆借******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
     V_P_DATE               AS DATA_DT                         --数据日期
    ,A.LP_ID                AS LGL_REP_ID                      --法人编号
    ,A.TRAN_ID||'_0'        AS SEQ_NO                          --流水号
    ,NVL(A.BAG_ID,'999')    AS ACC_ID                          --账户编号
    ,A.TRAN_CATE_CD         AS TRA_TYP                         --交易类型
    ,E.ORG_ID               AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.ENTRY_ORG_ID         AS HDL_ORG_ID                      --经办机构编号
    ,ABS(A.TRAN_AMT)             AS TRA_AMT                         --交易金额
    ,A.TRAN_CLEAR_ACCT_ID   AS OPP_ACC                         --对方账号
    ,A.CNTPTY_NAME          AS OPP_ACC_NM                      --对方户名
    ,A.TRAN_CLEAR_BANK_NO   AS OPP_PBC_NO                      --对方行号
    ,A.TRAN_CLEAR_BANK_NAME AS OPP_BANK_NM                     --对方行名
    ,NULL                   AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD              AS CUR                             --币种
    ,'2'                    AS CASH_TRF_FLG                    --现转标志
    ,NULL                   AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                   AS AGT_NM                          --代办人姓名
    ,NULL                   AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                   AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                  AS TRA_TLR_NO                      --交易柜员号
    ,'999'                  AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                   AS ABSTR                           --摘要
    ,'1'                    AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,CASE WHEN TRIM(A.TRAN_DIR_CD)IN('1','01') THEN 'C'
          WHEN TRIM(A.TRAN_DIR_CD)IN('2','02') THEN 'D'
          END               AS TRA_DR_CR_FLG                   --交易借贷标志
    ,/*A.TRAN_DT*/A.EXP_DT              AS TRA_TM                          --交易时间
    ,NULL                   AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,A.SUBJ_ID              AS SUBJ_ID                         --科目编号
/*    ,CASE WHEN  TRUNC(A.VALUE_DT,'MM') = TRUNC(V_DATE,'MM') THEN '1'
     WHEN  TRUNC(A.EXP_DT,'MM') = TRUNC(V_DATE,'MM')  THEN '0' END
     AS OCCUR_SETL_TYP  --20220928 XUXIAOBIN ADD                --发生结清类型*/
    ,'0'                     AS OCCUR_SETL_TYP                   --发生结清类型
    ,NULL                   AS IP                              --IP地址
    ,NULL                   AS MAC                             --MAC地址
    ,A.EXEC_INT_RAT          AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                   AS BIZ_AMT                         --业务发生金额
    ,'800976'               AS DEPT_LINE                       --部门条线 --资金交易部
    ,'资金同业拆借结清' AS DATA_SRC                        --数据来源
    ,NULL                   AS SUB_ACC_ID                      --子账户编号
    ,NULL                   AS FIN_INSTM_ID                    --金融工具编号
    ,A.BUS_ID               AS BUS_ID                          --业务编号
    ,A.ASSET_THD_CLS_CD     AS ASSET_THD_CLS_CD                --资产三分类代码
   FROM O_ICL_CMM_CAP_IB_LEND A --资金同业拆借 A
   LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
       ON A.CNTPTY_ID = G.CUST_ID
       AND G.ETL_DT = A.ETL_DT
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO E  --内部机构信息表
      ON A.ENTRY_ORG_ID = E.ORG_ID
      AND E.ETL_DT = V_DATE
  WHERE A.TRAN_CATE_CD = '0'
   --AND A.SUBJ_ID LIKE '1302%' -- 拆放同业
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TRUNC(A.EXP_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-外汇系统-同业拆借、外币回购借数据信息--发生';
  V_STARTTIME := SYSDATE;

  /******************外汇系统-同业拆借、外币回购借******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
     V_P_DATE               AS DATA_DT                        --数据日期
    ,A.LP_ID                AS LGL_REP_ID                      --法人编号
    ,A.BUS_ID||'_1'        AS SEQ_NO                          --流水号
    ,/*COALESCE(A.BAG_ID,A.BOND_ID,'999')*/A.BAG_ID    AS ACC_ID                          --账户编号
    ,A.IB_LEND_TYPE_CD      AS TRA_TYP                         --交易类型
    ,E.ORG_ID               AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.ENTRY_ORG_ID         AS HDL_ORG_ID                      --经办机构编号
    ,ABS(A.TRAN_AMT)             AS TRA_AMT                         --交易金额
    ,NULL                   AS OPP_ACC                         --对方账号
    ,NULL                   AS OPP_ACC_NM                      --对方户名
    ,NULL                   AS OPP_PBC_NO                      --对方行号
    ,NULL                   AS OPP_BANK_NM                     --对方行名
    ,NULL                   AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD              AS CUR                             --币种
    ,'2'                    AS CASH_TRF_FLG                    --现转标志
    ,NULL                   AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                   AS AGT_NM                          --代办人姓名
    ,NULL                   AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                   AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                  AS TRA_TLR_NO                      --交易柜员号
    ,'999'                  AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                   AS ABSTR                           --摘要
    ,'1'                    AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,CASE WHEN TRIM(A.TRAN_DIR_CD)IN('1','01') THEN 'C'
          WHEN TRIM(A.TRAN_DIR_CD)IN('2','02') THEN 'D'
          END               AS TRA_DR_CR_FLG                   --交易借贷标志
    ,/*A.TRAN_DT*/A.VALUE_DT              AS TRA_TM                          --交易时间
    ,NULL                   AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,A.SUBJ_ID              AS SUBJ_ID                         --科目编号
    ,'1'                    AS OCCUR_SETL_TYP                  --发生结清类型
    ,NULL                   AS IP                              --IP地址
    ,NULL                   AS MAC                             --MAC地址
    ,A.EXEC_INT_RAT                   AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                   AS BIZ_AMT                         --业务发生金额
    ,'800976'               AS DEPT_LINE                       --部门条线 --资金交易部
    ,'外汇同业拆借发生' AS DATA_SRC                        --数据来源
    ,NULL                   AS SUB_ACC_ID                      --子账户编号
    ,NULL                   AS FIN_INSTM_ID                    --金融工具编号
    ,A.BUS_ID               AS BUS_ID                          --业务编号
    ,A.ASSET_THD_CLS_CD     AS ASSET_THD_CLS_CD                --资产三分类代码
   FROM O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表 A
    LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
      ON A.CNTPTY_ID = G.CUST_ID
     AND G.ETL_DT = A.ETL_DT
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO E  --内部机构信息表
      ON A.ENTRY_ORG_ID = E.ORG_ID
      AND E.ETL_DT = V_DATE
    WHERE A.SUBJ_ID IS NOT NULL
      AND A.ETL_DT = V_DATE--还需要看其他模块的是否是每天取数再增加条件限制20221018 XUXIAOBIN
      AND A.INV_PORT_STATUS_CD IN ('A', 'C')
      AND TRUNC(A.VALUE_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;



  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-外汇系统-同业拆借、外币回购借数据信息--结清';
  V_STARTTIME := SYSDATE;

  /******************外汇系统-同业拆借、外币回购借******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
     V_P_DATE               AS DATA_DT                        --数据日期
    ,A.LP_ID                AS LGL_REP_ID                      --法人编号
    ,A.BUS_ID||'_0'        AS SEQ_NO                          --流水号
    ,/*COALESCE(A.BAG_ID,A.BOND_ID,'999')*/A.BAG_ID    AS ACC_ID                          --账户编号
    ,A.IB_LEND_TYPE_CD      AS TRA_TYP                         --交易类型
    ,E.ORG_ID               AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.ENTRY_ORG_ID         AS HDL_ORG_ID                      --经办机构编号
    ,ABS(A.TRAN_AMT)             AS TRA_AMT                         --交易金额
    ,NULL                   AS OPP_ACC                         --对方账号
    ,NULL                   AS OPP_ACC_NM                      --对方户名
    ,NULL                   AS OPP_PBC_NO                      --对方行号
    ,NULL                   AS OPP_BANK_NM                     --对方行名
    ,NULL                   AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD              AS CUR                             --币种
    ,'2'                    AS CASH_TRF_FLG                    --现转标志
    ,NULL                   AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                   AS AGT_NM                          --代办人姓名
    ,NULL                   AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                   AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                  AS TRA_TLR_NO                      --交易柜员号
    ,'999'                  AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                   AS ABSTR                           --摘要
    ,'1'                    AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,CASE WHEN TRIM(A.TRAN_DIR_CD)IN('1','01') THEN 'C'
          WHEN TRIM(A.TRAN_DIR_CD)IN('2','02') THEN 'D'
          END               AS TRA_DR_CR_FLG                   --交易借贷标志
    ,/*A.TRAN_DT*/A.EXP_DT  AS TRA_TM                          --交易时间
    ,NULL                   AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,A.SUBJ_ID              AS SUBJ_ID                         --科目编号
    ,'0'                    AS OCCUR_SETL_TYP                  --发生结清类型
    ,NULL                   AS IP                              --IP地址
    ,NULL                   AS MAC                             --MAC地址
    ,A.EXEC_INT_RAT         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                   AS BIZ_AMT                         --业务发生金额
    ,'800976'               AS DEPT_LINE                       --部门条线 --资金交易部
    ,'外汇同业拆借结清' AS DATA_SRC                        --数据来源
    ,NULL                   AS SUB_ACC_ID                      --子账户编号
    ,NULL                   AS FIN_INSTM_ID                    --金融工具编号
    ,A.BUS_ID               AS BUS_ID                          --业务编号
    ,A.ASSET_THD_CLS_CD     AS ASSET_THD_CLS_CD                --资产三分类代码
   FROM O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表 A
    LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
      ON A.CNTPTY_ID = G.CUST_ID
     AND G.ETL_DT = A.ETL_DT
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO E  --内部机构信息表
      ON A.ENTRY_ORG_ID = E.ORG_ID
      AND E.ETL_DT = V_DATE
    WHERE A.SUBJ_ID IS NOT NULL
      AND A.ETL_DT = V_DATE--还需要看其他模块的是否是每天取数再增加条件限制20221018 XUXIAOBIN
      AND A.INV_PORT_STATUS_CD IN ('A', 'C')
      AND TRUNC(A.EXP_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-同业借贷-同业主指令明细';
  V_STARTTIME := SYSDATE;

  /******************同业借款、同业现金借贷质押式回购******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
     V_P_DATE                     AS DATA_DT                        --数据日期
    ,A.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,A.MAIN_INSTR_SEQ_NUM         AS SEQ_NO                          --流水号
    ,B.FIN_INSTM_ID               AS ACC_ID                          --账户编号
    ,E.TRAN_TYPE_CD               AS TRA_TYP                         --交易类型
    ,C.BELONG_ORG_ID              AS OPEN_ACC_ORG_ID          --开户机构
    ,E.BELONG_ORG_ID              AS HDL_ORG_ID                      --经办机构编号
    ,CASE WHEN C.PROD_TYPE_CD = '0220' THEN B.TRAN_AMT - B.INT_RECVBL
          when c.ASSET_TYPE_NAME='境内同业借款借入' THEN B.ACTL_PRIC
          ELSE B.TRAN_AMT END
                                 AS TRA_AMT                         --交易金额
    ,NVL(TRIM(T1.CUST_ID),A.CNTPTY_ID)
                                  AS OPP_ACC                         --对方账号
    ,B.CNTPTY_ACCT_NAME                 AS OPP_ACC_NM                      --对方户名
    ,B.CNTPTY_OPEN_BANK_NUM       AS OPP_PBC_NO                      --对方行号
    ,B.CNTPTY_OPEN_BANK_NAME      AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,C.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'C'                         AS TRA_DR_CR_FLG                   --交易借贷标志
    ,A.ACTL_STL_DT                   AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,E.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    /*,CASE WHEN  TRUNC(A.VALUE_DT,'MM') = TRUNC(V_DATE,'MM') THEN '1'
     WHEN  TRUNC(A.EXP_DT,'MM') = TRUNC(V_DATE,'MM')  THEN '0' END         */
    ,CASE WHEN A.TRAN_TYPE_CD LIKE C.PROD_TYPE_CD||'30_' THEN '0'
     when c.ASSET_TYPE_NAME='境内同业借款借入' THEN '0'
     ELSE '1' END                 AS OCCUR_SETL_TYP                  --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,C.FAC_VAL_INT_RAT                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                     AS DEPT_LINE                       --部门条线 --资金交易部
    ,'同业借款借出1'       AS DATA_SRC                        --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,NVL(B.FIN_INSTM_ID,'999')    AS FIN_INSTM_ID                    --金融工具编号
    ,E.BUS_ID                     AS BUS_ID                          --业务编号
    ,E.ASSET_THD_CLS_CD           AS ASSET_THD_CLS_CD                --资产三分类代码
    FROM O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL A --同业主指令明细
    LEFT JOIN O_IML_EVT_IBANK_TRAN B --同业交易表
      ON A.INTNAL_TRAN_FLOW_NUM = B.INTNAL_TRAN_NUM
     AND B.TRAN_STATUS_CD = '4'
    LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM C --金融工具表
      ON B.FIN_INSTM_ID = C.FIN_INSTM_ID
     AND B.ASSET_TYPE_ID = C.ASSET_TYPE_ID
     AND B.TRAN_MARKET_ID = C.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN O_IML_EVT_IBANK_CAP_STL_INSTR_DTL D --同业资金指令明细
      ON A.MAIN_INSTR_SEQ_NUM = D.MAIN_INSTR_SEQ_NUM*/
    LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO T1 --同业交易对手信息
       ON A.CNTPTY_ID = T1.SRC_PARTY_ID
      AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_ICL_CMM_IBANK_CASH_DEBIT_CRDT E
       ON B.FIN_INSTM_ID = E.FIN_INSTM_ID
       AND B.ASSET_TYPE_ID = E.ASSET_TYPE_ID
       AND B.TRAN_MARKET_ID = E.MARKET_TYPE_ID
       AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  --同业现金借贷
   WHERE C.PROD_TYPE_CD IN ('0122', '0123', '0220', '0221', '0125', '0158')
     AND A.TRAN_TYPE_CD NOT LIKE C.PROD_TYPE_CD || '2%'
     AND A.TRAN_TYPE_CD <> '0100531'
     AND A.INSTR_STATUS_CD IN ('02','04') ---类型可能还有漏的
     --AND D.CHG_QTTY <> 0
     AND (A.PARENT_INSTR_ID IN (0, -1) OR A.PARENT_INSTR_ID = A.MAIN_INSTR_SEQ_NUM)
     AND TRUNC(A.ACTL_STL_DT, 'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
   UNION ALL
     SELECT
     V_P_DATE                     AS DATA_DT                        --数据日期
    ,A.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,A.MAIN_INSTR_SEQ_NUM         AS SEQ_NO                          --流水号
    ,B.FIN_INSTM_ID               AS ACC_ID                          --账户编号
    ,E.TRAN_TYPE_CD               AS TRA_TYP                         --交易类型
    ,C.BELONG_ORG_ID              AS OPEN_ACC_ORG_ID          --开户机构
    ,E.BELONG_ORG_ID              AS HDL_ORG_ID                      --经办机构编号
    ,ABS(D.ACTL_NET_PRICE_AMT)    AS TRA_AMT                         --交易金额
    ,NVL(TRIM(T1.CUST_ID),A.CNTPTY_ID)
                                  AS OPP_ACC                         --对方账号
    ,B.CNTPTY_ACCT_NAME                 AS OPP_ACC_NM                      --对方户名
    ,B.CNTPTY_OPEN_BANK_NUM       AS OPP_PBC_NO                      --对方行号
    ,B.CNTPTY_OPEN_BANK_NAME      AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,C.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'C'                         AS TRA_DR_CR_FLG                   --交易借贷标志
    ,A.ACTL_STL_DT                   AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,E.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    /*,CASE WHEN  TRUNC(A.VALUE_DT,'MM') = TRUNC(V_DATE,'MM') THEN '1'
     WHEN  TRUNC(A.EXP_DT,'MM') = TRUNC(V_DATE,'MM')  THEN '0' END         */
    ,'0'                          AS OCCUR_SETL_TYP                  --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,C.FAC_VAL_INT_RAT                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                     AS DEPT_LINE                       --部门条线 --资金交易部
    ,'同业借款借出2'       AS DATA_SRC                        --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,NVL(B.FIN_INSTM_ID,'999')    AS FIN_INSTM_ID                    --金融工具编号
    ,E.BUS_ID                     AS BUS_ID                          --业务编号
    ,E.ASSET_THD_CLS_CD           AS ASSET_THD_CLS_CD                --资产三分类代码
    FROM O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL A --同业主指令明细
    LEFT JOIN O_IML_EVT_IBANK_TRAN B --同业交易表
      ON A.INTNAL_TRAN_FLOW_NUM = B.INTNAL_TRAN_NUM
     AND B.TRAN_STATUS_CD = '4'
    LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM C --金融工具表
      ON B.FIN_INSTM_ID = C.FIN_INSTM_ID
     AND B.ASSET_TYPE_ID = C.ASSET_TYPE_ID
     AND B.TRAN_MARKET_ID = C.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL D --同业券指令明细
     ON A.MAIN_INSTR_SEQ_NUM = D.MAIN_INSTR_SEQ_NUM
   LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO T1 --同业交易对手信息
      ON A.CNTPTY_ID = T1.SRC_PARTY_ID
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN O_ICL_CMM_IBANK_CASH_DEBIT_CRDT E
       ON B.FIN_INSTM_ID = E.FIN_INSTM_ID
       AND B.ASSET_TYPE_ID = E.ASSET_TYPE_ID
       AND B.TRAN_MARKET_ID = E.MARKET_TYPE_ID
       AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  --同业现金借贷
   WHERE C.PROD_TYPE_CD IN ('0122','0123','0220','0221','0125','0150','0158')
     AND A.TRAN_TYPE_CD NOT LIKE C.PROD_TYPE_CD || '2%'
     AND A.TRAN_TYPE_CD = '0100531'
     AND A.INSTR_STATUS_CD IN ('02','04')---类型可能还有漏的
     AND D.ACTL_NET_PRICE_AMT <> 0
     AND (A.PARENT_INSTR_ID IN (0, -1) OR A.PARENT_INSTR_ID = A.MAIN_INSTR_SEQ_NUM)
     AND TRUNC(A.ACTL_STL_DT, 'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')

   UNION ALL

    SELECT
     V_P_DATE                     AS DATA_DT                        --数据日期
    ,A.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,A.MAIN_INSTR_SEQ_NUM         AS SEQ_NO                          --流水号
    ,B.FIN_INSTM_ID              AS ACC_ID                          --账户编号
    ,E.TRAN_TYPE_CD               AS TRA_TYP                         --交易类型
    ,C.BELONG_ORG_ID              AS OPEN_ACC_ORG_ID          --开户机构
    ,E.BELONG_ORG_ID              AS HDL_ORG_ID                      --经办机构编号
    ,CASE WHEN C.PROD_TYPE_CD = '0220' THEN B.TRAN_AMT - B.INT_RECVBL
                ELSE B.TRAN_AMT END
                                  AS TRA_AMT                         --交易金额
    ,NVL(TRIM(T1.CUST_ID),A.CNTPTY_ID)
                                  AS OPP_ACC                         --对方账号
    ,B.CNTPTY_ACCT_NAME                 AS OPP_ACC_NM                      --对方户名
    ,B.CNTPTY_OPEN_BANK_NUM       AS OPP_PBC_NO                      --对方行号
    ,B.CNTPTY_OPEN_BANK_NAME      AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,C.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'C'                         AS TRA_DR_CR_FLG                   --交易借贷标志
    ,A.TRAN_DT                   AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,E.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    /*,CASE WHEN  TRUNC(A.VALUE_DT,'MM') = TRUNC(V_DATE,'MM') THEN '1'
     WHEN  TRUNC(A.EXP_DT,'MM') = TRUNC(V_DATE,'MM')  THEN '0' END         */
    ,CASE WHEN C.PROD_TYPE_CD = '0150' AND A.TRAN_TYPE_CD LIKE C.PROD_TYPE_CD||'30_\_L' ESCAPE '\' or A.TRAN_TYPE_CD LIKE C.PROD_TYPE_CD||'301_L'  THEN '0'
          ELSE '1'
          END                     AS OCCUR_SETL_TYP                  --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,C.FAC_VAL_INT_RAT                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                     AS DEPT_LINE                       --部门条线 --资金交易部
    ,'交易所质押式回购'       AS DATA_SRC                          --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,NVL(B.FIN_INSTM_ID,'999')    AS FIN_INSTM_ID                    --金融工具编号
    ,E.BUS_ID                     AS BUS_ID                          --业务编号
    ,E.ASSET_THD_CLS_CD           AS ASSET_THD_CLS_CD                --资产三分类代码
    FROM O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL A --同业主指令明细
      LEFT JOIN O_IML_EVT_IBANK_TRAN B --同业交易表
        ON A.INTNAL_TRAN_FLOW_NUM = B.INTNAL_TRAN_NUM
       AND B.TRAN_STATUS_CD = '4'
      LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM C --金融工具表
        ON B.FIN_INSTM_ID = C.FIN_INSTM_ID
       AND B.ASSET_TYPE_ID = C.ASSET_TYPE_ID
       AND B.TRAN_MARKET_ID = C.MARKET_TYPE_ID
       AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL D --同业券指令明细
        ON A.MAIN_INSTR_SEQ_NUM = D.MAIN_INSTR_SEQ_NUM
       LEFT JOIN O_ICL_CMM_IBANK_CASH_DEBIT_CRDT E
       ON B.FIN_INSTM_ID = C.FIN_INSTM_ID
       AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  --同业现金借贷
      LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO T1 --同业交易对手信息
        ON A.CNTPTY_ID = T1.SRC_PARTY_ID
       AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE C.PROD_TYPE_CD = '0150'
       AND A.TRAN_TYPE_CD NOT LIKE C.PROD_TYPE_CD || '2%'
       --AND A.TRAN_TYPE_CD NOT IN ('0150301','0150300','0100531')
       --add by wyp 20220216  取同业现金借贷质押式回购
       AND A.TRAN_TYPE_CD NOT IN('0150300','0100531')
       AND A.INSTR_STATUS_CD IN ('02','04') ---类型可能还有漏的
       AND (A.PARENT_INSTR_ID IN ('0', '-1') OR A.PARENT_INSTR_ID = A.MAIN_INSTR_SEQ_NUM)
       AND TRUNC(A.TRAN_DT, 'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     ;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-法透(发生)';
  V_STARTTIME := SYSDATE;

  /******************同业系统-法透(发生)******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
    V_P_DATE                     AS DATA_DT                          --数据日期
    ,B.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,B.DUBIL_NUM||'_1'              AS SEQ_NO                          --流水号
    ,B.DUBIL_NUM                    AS ACC_ID                          --账户编号
    ,'99'               AS TRA_TYP                         --交易类型
    ,B.OPEN_ACCT_ORG_ID                  AS OPEN_ACC_ORG_ID                 --开户机构
    ,B.ACCT_INSTIT_ID              AS HDL_ORG_ID                      --经办机构编号
    ,B.DUBIL_AMT                   AS TRA_AMT                         --交易金额
    ,NULL            AS OPP_ACC                         --对方账号
    ,NULL           AS OPP_ACC_NM                      --对方户名
    ,NULL       AS OPP_PBC_NO                      --对方行号
    ,NULL      AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,B.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'D'                          AS TRA_DR_CR_FLG                   --交易借贷标志
    ,B.VALUE_DT                   AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,B.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    , '1' AS  OCCUR_SETL_TYP  --20220928 XUXIAOBIN ADD                --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,B.EXEC_INT_RAT                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                     AS DEPT_LINE                       --部门条线 --资金交易部
    ,'法透(发生)'       AS DATA_SRC                        --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,NULL    AS FIN_INSTM_ID                    --金融工具编号
    ,NULL                     AS BUS_ID                          --业务编号
    ,NULL           AS ASSET_THD_CLS_CD                --资产三分类代码
  FROM O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
      LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
        ON B.CONT_ID = C.CONT_ID
       AND B.ETL_DT = C.ETL_DT
      LEFT JOIN O_ICL_CMM_LP_OD_SIGN_INFO D --法透签约信息表
        ON B.DUBIL_NUM = D.DUBIL_ID
       AND B.ETL_DT = D.ETL_DT
     WHERE D.LP_OD_TYPE_CD IN ('1', '2')--0 对公法透 1 同业日间法透 2 同业隔夜法透
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TRUNC(B.VALUE_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');


    /******************同业系统-法透(结清)******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
    V_P_DATE                     AS DATA_DT                          --数据日期
    ,B.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,B.DUBIL_NUM||'_0'              AS SEQ_NO                          --流水号
    ,B.DUBIL_NUM                    AS ACC_ID                          --账户编号
    ,'99'               AS TRA_TYP                         --交易类型
    ,B.OPEN_ACCT_ORG_ID                  AS OPEN_ACC_ORG_ID                 --开户机构
    ,B.ACCT_INSTIT_ID              AS HDL_ORG_ID                      --经办机构编号
    ,B.DUBIL_AMT                   AS TRA_AMT                         --交易金额
    ,NULL            AS OPP_ACC                         --对方账号
    ,NULL           AS OPP_ACC_NM                      --对方户名
    ,NULL       AS OPP_PBC_NO                      --对方行号
    ,NULL      AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,B.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'D'                          AS TRA_DR_CR_FLG                   --交易借贷标志
    ,B.EXP_DT                   AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,B.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    , '0' AS  OCCUR_SETL_TYP  --20220928 XUXIAOBIN ADD                --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,B.EXEC_INT_RAT                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                     AS DEPT_LINE                       --部门条线 --资金交易部
    ,'法透(结清)'       AS DATA_SRC                        --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,NULL    AS FIN_INSTM_ID                    --金融工具编号
    ,NULL                     AS BUS_ID                          --业务编号
    ,NULL           AS ASSET_THD_CLS_CD                --资产三分类代码
  FROM O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
      LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
        ON B.CONT_ID = C.CONT_ID
       AND B.ETL_DT = C.ETL_DT
      LEFT JOIN O_ICL_CMM_LP_OD_SIGN_INFO D --法透签约信息表
        ON B.DUBIL_NUM = D.DUBIL_ID
       AND B.ETL_DT = D.ETL_DT
     WHERE D.LP_OD_TYPE_CD IN ('1', '2')--0 对公法透 1 同业日间法透 2 同业隔夜法透
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TRUNC(B.EXP_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');


  /******************同业系统-同业代付(发生)******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
    V_P_DATE                     AS DATA_DT                          --数据日期
    ,A.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,A.CONT_ID||A.AGT_ID||'_1'              AS SEQ_NO                          --流水号
    ,A.CONT_ID                    AS ACC_ID                          --账户编号
    ,'99'               AS TRA_TYP                         --交易类型
    ,A.OUT_ACCT_ORG_ID                  AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.OPER_ORG_ID              AS HDL_ORG_ID                      --经办机构编号
    ,A.CONT_AMT                   AS TRA_AMT                         --交易金额
    ,NULL            AS OPP_ACC                         --对方账号
    ,NULL           AS OPP_ACC_NM                      --对方户名
    ,NULL       AS OPP_PBC_NO                      --对方行号
    ,NULL      AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'D'                          AS TRA_DR_CR_FLG                   --交易借贷标志
    ,A.DISTR_DT                   AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,A.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    , '1' AS  OCCUR_SETL_TYP  --20220928 XUXIAOBIN ADD                --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,B.IBANK_PAYFAN_PROVI_INT_RAT                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                     AS DEPT_LINE                       --部门条线 --资金交易部
    ,'同业代付(发生)'       AS DATA_SRC                        --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,NULL    AS FIN_INSTM_ID                    --金融工具编号
    ,NULL                     AS BUS_ID                          --业务编号
    ,NULL           AS ASSET_THD_CLS_CD                --资产三分类代码
  FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --业务出账申请 A
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H B --贷款出账对公贷款附属信息历史
    ON A.OUT_ACCT_FLOW_NUM = B.OUT_ACCT_FLOW_NUM
    AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CODE_MAP TA --利率浮动频率
         ON  TA.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CD
         AND TA.SRC_CLASS_CODE = 'CD2636'
         AND TA.TAR_CLASS_CODE = 'D0015'
         AND TA.MOD_FLG = 'MDM'
    LEFT JOIN CODE_MAP TB --定价基准类型
         ON  TA.SRC_VALUE_CODE = A.BASE_RAT_TYPE_CD
         AND TA.SRC_CLASS_CODE = 'CD1010'
         AND TA.TAR_CLASS_CODE = 'Z0015'
         AND TA.MOD_FLG = 'MDM'
    WHERE
       A.PROD_ID IN ('203020700001','203020700002')
       AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TRUNC(A.DISTR_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');


  /******************同业系统-同业代付(结清)******************/
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
    V_P_DATE                     AS DATA_DT                          --数据日期
    ,A.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,A.CONT_ID||A.AGT_ID||'_0'              AS SEQ_NO                          --流水号
    ,A.CONT_ID                    AS ACC_ID                          --账户编号
    ,'99'               AS TRA_TYP                         --交易类型
    ,A.OUT_ACCT_ORG_ID                  AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.OPER_ORG_ID              AS HDL_ORG_ID                      --经办机构编号
    ,A.CONT_AMT                   AS TRA_AMT                         --交易金额
    ,NULL            AS OPP_ACC                         --对方账号
    ,NULL           AS OPP_ACC_NM                      --对方户名
    ,NULL       AS OPP_PBC_NO                      --对方行号
    ,NULL      AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'D'                          AS TRA_DR_CR_FLG                   --交易借贷标志
    ,A.EXP_DT                   AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,A.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    , '0' AS  OCCUR_SETL_TYP                 --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,B.IBANK_PAYFAN_PROVI_INT_RAT                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                     AS DEPT_LINE                       --部门条线 --资金交易部
    ,'同业代付(结清)'       AS DATA_SRC                        --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,NULL    AS FIN_INSTM_ID                    --金融工具编号
    ,NULL                     AS BUS_ID                          --业务编号
    ,NULL           AS ASSET_THD_CLS_CD                --资产三分类代码
  FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --业务出账申请 A
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H B --贷款出账对公贷款附属信息历史
    ON A.OUT_ACCT_FLOW_NUM = B.OUT_ACCT_FLOW_NUM
    AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CODE_MAP TA --利率浮动频率
         ON  TA.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CD
         AND TA.SRC_CLASS_CODE = 'CD2636'
         AND TA.TAR_CLASS_CODE = 'D0015'
         AND TA.MOD_FLG = 'MDM'
    LEFT JOIN CODE_MAP TB --定价基准类型
         ON  TA.SRC_VALUE_CODE = A.BASE_RAT_TYPE_CD
         AND TA.SRC_CLASS_CODE = 'CD1010'
         AND TA.TAR_CLASS_CODE = 'Z0015'
         AND TA.MOD_FLG = 'MDM'
    WHERE
       A.PROD_ID IN ('203020700001','203020700002')
       AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TRUNC(A.EXP_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');
/*

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-同业系统-存放同业活期1数据信息';
  V_STARTTIME := SYSDATE;

  \******************同业系统-存放同业活期******************\
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
     V_P_DATE                     AS DATA_DT                        --数据日期
    ,A.LP_ID                      AS LGL_REP_ID                      --法人编号
    ,A.TRAN_NUM                   AS SEQ_NO                          --流水号
    ,NVL(A.OBJ_ID,'999')          AS ACC_ID                          --账户编号
    ,NULL                         AS TRA_TYP                         --交易类型
    ,E.ORG_ID                     AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.BELONG_ORG_ID              AS HDL_ORG_ID                      --经办机构编号
    ,A.TRAN_AMT                   AS TRA_AMT                         --交易金额
    ,A.CNTPTY_ACCT_ID             AS OPP_ACC                         --对方账号
    ,NULL                         AS OPP_ACC_NM                      --对方户名
    ,NULL                         AS OPP_PBC_NO                      --对方行号
    ,NULL                         AS OPP_BANK_NM                     --对方行名
    ,NULL                         AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD                    AS CUR                             --币种
    ,'2'                          AS CASH_TRF_FLG                    --现转标志
    ,NULL                         AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                         AS AGT_NM                          --代办人姓名
    ,NULL                         AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                         AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                        AS TRA_TLR_NO                      --交易柜员号
    ,'999'                        AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                         AS ABSTR                           --摘要
    ,'1'                          AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,'C'                         AS TRA_DR_CR_FLG                   --交易借贷标志
    ,A.TRAN_DT                    AS TRA_TM                          --交易时间
    ,NULL                         AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,A.SUBJ_ID                    AS SUBJ_ID                         --科目编号
    ,CASE WHEN  TRUNC(A.VALUE_DT,'MM') = TRUNC(V_DATE,'MM') THEN '1'
     WHEN  TRUNC(A.EXP_DT,'MM') = TRUNC(V_DATE,'MM')  THEN '0' END
     AS OCCUR_SETL_TYP  --20220928 XUXIAOBIN ADD                --发生结清类型
    ,NULL                         AS IP                              --IP地址
    ,NULL                         AS MAC                             --MAC地址
    ,NULL                         AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                         AS BIZ_AMT                         --业务发生金额
    ,'800976'                      AS DEPT_LINE                       --部门条线 --资金交易部
    ,'同业证券持仓'       AS DATA_SRC                        --数据来源
    ,NULL                         AS SUB_ACC_ID                      --子账户编号
    ,A.FIN_INSTM_ID               AS FIN_INSTM_ID                    --金融工具编号
    ,A.BUS_ID                     AS BUS_ID                          --业务编号
    ,A.ASSET_THD_CLS_CD           AS ASSET_THD_CLS_CD                --资产三分类代码
   FROM O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表 A
   LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM C1 --同业金融工具表
          ON A.FIN_INSTM_ID = C1.FIN_INSTM_ID
         AND C1.ETL_DT = A.ETL_DT
   LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
         ON A.ISSUER_ID = G.CUST_ID
         AND G.ETL_DT = A.ETL_DT
   LEFT JOIN O_ICL_CMM_CORP_CUST_RELA_PS_INFO D -- 对公客户关联人信息表
          ON A.ISSUER_ID = D.CUST_ID
          AND D.RELA_TYPE_CD = '30101'
   LEFT JOIN O_ICL_CMM_EXCH_RAT_INFO F        -- 汇率信息表
          ON A.CURR_CD = F.CURR_CD
   LEFT JOIN O_IML_PTY_IBANK_CUST_CHAT_INFO TI --同业客户特有信息
          ON G.CUST_ID = TI.PARTY_ID
         AND TI.FIN_INST_CATE_CD != '000000'
         AND TI.START_DT <= A.ETL_DT
         AND TI.END_DT > A.ETL_DT
   LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO E  --内部机构信息表
      ON A.BELONG_ORG_ID = E.ORG_ID
      AND E.ETL_DT = V_DATE
     WHERE
         --AND A.SUBJ_ID LIKE '1011%'
          A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   */

/*
    V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入法透交易信息';
  V_STARTTIME := SYSDATE;

  \******************外汇系统-同业拆借、外币回购借******************\
  INSERT INTO RRP_MDL.M_TRA_CPTL_DTL
  (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,SEQ_NO                          --流水号
    ,ACC_ID                          --账户编号
    ,TRA_TYP                         --交易类型
    ,OPEN_ACC_ORG_ID                 --开户机构
    ,HDL_ORG_ID                      --经办机构编号
    ,TRA_AMT                         --交易金额
    ,OPP_ACC                         --对方账号
    ,OPP_ACC_NM                      --对方户名
    ,OPP_PBC_NO                      --对方行号
    ,OPP_BANK_NM                     --对方行名
    ,TRA_CHAN                        --交易渠道
    ,CUR                             --币种
    ,CASH_TRF_FLG                    --现转标志
    ,ADV_DRAW_FLG                    --提前支取标志
    ,AGT_NM                          --代办人姓名
    ,AGT_CRDL_TYP                    --代办人证件类型
    ,AGT_CRDL_NO                     --代办人证件号码
    ,TRA_TLR_NO                      --交易柜员号
    ,GRANT_TLR_NO                    --授权柜员号
    ,ABSTR                           --摘要
    ,FLUSH_PATCH_FLG                 --冲补抹标志
    ,TRA_DR_CR_FLG                   --交易借贷标志
    ,TRA_TM                          --交易时间
    ,AST_LBY_SIDE_FLG                --资产负债方标志
    ,SUBJ_ID                         --科目编号
    ,OCCUR_SETL_TYP                  --发生结清类型
    ,IP                              --IP地址
    ,MAC                             --MAC地址
    ,BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,BIZ_AMT                         --业务发生金额
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,SUB_ACC_ID                      --子账户编号
    ,FIN_INSTM_ID                    --金融工具编号
    ,BUS_ID                          --业务编号
    ,ASSET_THD_CLS_CD                --资产三分类代码
   )
   SELECT DISTINCT
     V_P_DATE               AS DATA_DT                        --数据日期
    ,A.LP_ID                AS LGL_REP_ID                      --法人编号
    ,A.TRAN_ID||'_0'        AS SEQ_NO                          --流水号
    ,COALESCE(A.BAG_ID,A.BOND_ID,'999')    AS ACC_ID                          --账户编号
    ,A.IB_LEND_TYPE_CD      AS TRA_TYP                         --交易类型
    ,E.ORG_ID               AS OPEN_ACC_ORG_ID                 --开户机构
    ,A.ENTRY_ORG_ID         AS HDL_ORG_ID                      --经办机构编号
    ,ABS(A.TRAN_AMT)             AS TRA_AMT                         --交易金额
    ,NULL                   AS OPP_ACC                         --对方账号
    ,NULL                   AS OPP_ACC_NM                      --对方户名
    ,NULL                   AS OPP_PBC_NO                      --对方行号
    ,NULL                   AS OPP_BANK_NM                     --对方行名
    ,NULL                   AS TRA_CHAN                        --交易渠道
    ,A.CURR_CD              AS CUR                             --币种
    ,'2'                    AS CASH_TRF_FLG                    --现转标志
    ,NULL                   AS ADV_DRAW_FLG                    --提前支取标志
    ,NULL                   AS AGT_NM                          --代办人姓名
    ,NULL                   AS AGT_CRDL_TYP                    --代办人证件类型
    ,NULL                   AS AGT_CRDL_NO                     --代办人证件号码
    ,'999'                  AS TRA_TLR_NO                      --交易柜员号
    ,'999'                  AS GRANT_TLR_NO                    --授权柜员号
    ,NULL                   AS ABSTR                           --摘要
    ,'1'                    AS FLUSH_PATCH_FLG                 --冲补抹标志
    ,DECODE(C.DEBIT_CRDT_DIR_CD,'D', '1', '0')
                            AS TRADE_DIRECT                    --交易借贷标志
    ,\*A.TRAN_DT*\A.EXP_DT  AS TRA_TM                          --交易时间
    ,NULL                   AS AST_LBY_SIDE_FLG                --资产负债方标志
    ,B.SUBJ_ID              AS SUBJ_ID                         --科目编号
    ,DECODE(C.DEBIT_CRDT_DIR_CD,'D', '1', '0')
                            AS TRADE_DIRECT                    --发生结清类型
    ,NULL                   AS IP                              --IP地址
    ,NULL                   AS MAC                             --MAC地址
    ,NULL                   AS BIZ_OCCUR_TMPNT_ACT_RATE        --业务发生时点实际利率
    ,NULL                   AS BIZ_AMT                         --业务发生金额
    ,'800976'               AS DEPT_LINE                       --部门条线 --资金交易部
    ,'外汇同业拆借' AS DATA_SRC                        --数据来源
    ,NULL                   AS SUB_ACC_ID                      --子账户编号
    ,NULL                   AS FIN_INSTM_ID                    --金融工具编号
    ,NULL              AS BUS_ID                          --业务编号
    ,NULL     AS ASSET_THD_CLS_CD                --资产三分类代码
  FROM O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
    LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO A --对公贷款合同信息表
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = A.ETL_DT
    LEFT JOIN O_icl_cmm_lp_od_sign_info D --法透签约信息表
      ON NVL(A.LMT_CONT_ID,B.CONT_ID) = D.CONT_ID
     AND B.ETL_DT = D.ETL_DT
    \*LEFT JOIN O_IML_EVT_CORP_LOAN_TRAN_INSTR  C--对公贷款交易指令
      ON B.ACCT_ID = C.ACCT_ID*\
   WHERE D.LP_OD_TYPE_CD IN ('1', '2')
     --AND TRUNC(C.TRAN_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
     --AND C.BAL_COMPNT_TYPE_CD IN ('1','2','3','4','A','C','D','E','F','M','O','X') --只取本金的
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     ;*/

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 数据重复校验 --
        WITH TMP1 AS (
  SELECT DATA_DT,SEQ_NO,COUNT(1)
    FROM RRP_MDL.M_TRA_CPTL_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,SEQ_NO
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

  END ETL_INIT_M_TRA_CPTL_DTL;
/

