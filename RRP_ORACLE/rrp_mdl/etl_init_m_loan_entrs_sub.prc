CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_ENTRS_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_ENTRS_SUB
  *  功能描述：委托贷款子表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_ENTRS_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  *             3    20221123  hulj      新增合同编号、资金来源代码
  *             4    20221202  hulj      剔除多余存款产品
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_ENTRS_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_TAB_NAME := 'M_LOAN_ENTRS_SUB'; --表名
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
    V_STEP_DESC := '插入委托贷款子表--个人';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_LOAN_ENTRS_SUB
    (
         DATA_DT                                                  --1数据日期
        ,LGL_REP_ID                                               --2法人编号
        ,RCPT_ID                                                  --3借据编号
        ,CONSR_CUST_ID                                            --4委托人客户编号
        ,CONSR_TYP                                                --5委托人类型
        ,CONSR_OPEN_BANK_PBC_NO                                   --6委托人开户行行号
        ,CONSR_OPEN_BANK_NM                                       --7委托人开户行名称
        ,ENTRS_ACC                                                --8委托账号
        ,ENTRS_ACC_TYP                                            --9委托账号类型
        ,CUR                                                      --10币种
        ,ENTRS_AMT                                                --11委托金额
        ,ACT_ENTRS_LOAN_AMT                                       --12实际委托贷款金额
        ,ENTRS_LOAN_USEAGE                                        --13委托贷款用途
        ,INT_COLL_FLG                                             --14收息标志
        ,COMM_MODE                                                --15手续费方式
        ,COMM_CUR                                                 --16手续费币种
        ,COMM_AMT                                                 --17手续费金额
        ,AGRT_START_DT                                            --18协议起始日期
        ,AGRT_EXP_DT                                              --19协议到期日期
        ,HDLR_NM                                                  --20经办人姓名
        ,HDLR_NO                                                  --21经办人工号
        ,HDL_ORG_NM                                               --22经办机构名称
        ,AGRT_STAT                                                --23协议状态
        ,ENTRS_LOAN_DIR                                           --24委托贷款投向
        ,ENTRS_LOAN_SUM_CL                                        --25委托贷款细类
        ,DEPT_LINE                                                --26部门条线
        ,DATA_SRC                                                 --27数据来源
        ,CONT_ID                                                  --28合同编号
        ,CAP_SRC_CD                                               --29资金来源代码
        ,OUT_COMM_FEE                                             --30出账手续费
        ,CONSR_NM                                                 --31委托人名称
        )
      SELECT
            V_P_DATE    DATA_DT,                                  --1数据日期
             A.LP_ID        LGL_REP_ID,                           --2法人编号
             A.DUBIL_ID      RCPT_ID,                             --3借据编号
             B.CSNER_CUST_NO   CONSR_CUST_ID,                      --4委托人客户编号
             E.CSNER_TYPE_CD    CONSR_TYP,                                   --5委托人类型
             I.FIN_INST_CODE    CONSR_OPEN_BANK_PBC_NO,                      --6委托人开户行行号 --modify by tangan at 20221124
             I.ORG_NAME      CONSR_OPEN_BANK_NM,                        --7委托人开户行名称 --modify by tangan at 20221124
             E.ENTR_DEP_ACCT_ID     ENTRS_ACC,                                  --8委托账号 --modify by tangan at 20221124
             NULL    ENTRS_ACC_TYP,                               --9委托账号类型
             A.CURR_CD    CUR,                                    --10币种
             C.DUBIL_AMT    ENTRS_AMT,                            --11委托金额
             0    ACT_ENTRS_LOAN_AMT,                             --12实际委托贷款金额
             CASE WHEN  B.BORW_USAGE_TYPE_CD IN ('100000') THEN '个人贷款用途'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100100') THEN '个人消费类贷款用途'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100101') THEN '购个人用车'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100102') THEN '装修'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100103') THEN '婚庆'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100104') THEN '留学'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100105') THEN '进修'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100106') THEN '旅游'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100107') THEN '高尔夫会籍'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100108') THEN '整形美容'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100109') THEN '购车+车牌'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100110') THEN '购车牌'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100111') THEN '购车位'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100112') THEN '购买电子产品'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100113') THEN '子女教育'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100114') THEN '房产税费'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100115') THEN '支付个人租房费用'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100116') THEN '医疗支出'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100117') THEN '绿色消费'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100199') THEN '其他个人消费'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100200') THEN '个人经营类贷款用途'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100201') THEN '购商用车'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100202') THEN '支付租赁经营费用'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100203') THEN '绿色经营'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100299') THEN '其他个人经营'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100300') THEN '个人按揭类贷款用途'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100301') THEN '购买商用房'
               WHEN B.BORW_USAGE_TYPE_CD IN ('100302') THEN '购买住房'
               WHEN B.BORW_USAGE_TYPE_CD IN ('000000') THEN '未知'
               ELSE B.BORW_USAGE_TYPE_CD
           END     ENTRS_LOAN_USEAGE,                             --13委托贷款用途
             CASE
               WHEN C.INT_ACCR_FLG = '1' THEN
                'Y'
               WHEN C.INT_ACCR_FLG = '0' THEN
                'N'
             END    INT_COLL_FLG,                                 --14收息标志
             NULL    COMM_MODE,                                   --15手续费方式
             A.CURR_CD    COMM_CUR,                               --16手续费币种
             D.COMM_FEE_AMT    COMM_AMT,                          --17手续费金额  --modify by tangan at 20221123
             TO_CHAR(C.DISTR_DT, 'YYYYMMDD')    AGRT_START_DT,    --18协议起始日期
             TO_CHAR(A.DUBIL_EXP_DT, 'YYYYMMDD')    AGRT_EXP_DT,  --19协议到期日期
             F.CLERK_NAME    HDLR_NM,                             --20经办人姓名
             F.CLERK_ID    HDLR_NO,                               --21经办人工号
             H.ORG_NAME    HDL_ORG_NM,                            --22经办机构名称
             G.CD_DESCB    AGRT_STAT,                             --23协议状态
             CASE WHEN B.BORW_USAGE_TYPE_CD LIKE '1002%'
                  THEN 'B99'
                  WHEN B.BORW_USAGE_TYPE_CD IN ('100101','100109','100110','100111')
                  THEN 'A02' --汽车
                  WHEN B.BORW_USAGE_TYPE_CD IN ('100300','100301','100302')
                  THEN 'A03' --住房按揭贷款
                  ELSE  'A99'
                  END  ENTRS_LOAN_DIR,                            --24委托贷款投向
             '9012'    ENTRS_LOAN_SUB_CL,                         --25委托贷款细类
             NULL      DEPT_LINE,                               --26部门条线
             '个人贷款' AS DATA_SRC,                              --27数据来源
             B.CONT_ID  AS CONT_ID,                               --28合同编号 add by hulj 20221123
             E.CAP_SRC_CD       AS CAP_SRC_CD,                             --29资金来源代码 add by hulj 20221123
             D.COMM_FEE_AMT       AS OUT_COMM_FEE,                          --30出账手续费
             E.CSNER_NAME         AS CONSR_NM                               --31委托人名称
        FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A --零售贷款借据信息
       INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO B --零售贷款合同信息
          ON A.CONT_ID = B.CONT_ID
         AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO C --零售贷款账户信息
          ON A.DUBIL_ID = C.DUBIL_NUM
         AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO F --行员信息表
          ON F.CLERK_ID = TRIM(A.RGST_TELLER_ID)
         AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD G --公共代码表
          ON C.LOAN_ACCT_STATUS_CD = G.CD_VAL
         AND G.CD_ID = 'CD1248'
        LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO H
          ON F.BELONG_ORG_ID = H.ORG_ID
         AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H D --从出账表取手续费金额 modify by tangan at 20221123
          ON A.DUBIL_ID = D.DUBIL_ID
         AND D.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.O_IML_AGT_CSNER_OUT_ACCT_INFO_H E --委托人出账信息历史 取委托账号 modify by tangan at 20221124
          ON A.DUBIL_ID = E.DUBIL_ID
         AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND E.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN (  --取委托人委托人开户行行号和委托人开户行名称  modify by tangan at 20221124
           SELECT A.CUST_ACCT_ID,             --账户编号
                A.CUST_ACCT_NAME ,          --账户户名
                NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID)) ACCT_BELONG_ORG_ID,       --账户所属机构
                B.ORG_ID1,                  --账户所属机构映射报送机构
                B.FIN_INST_CODE,            --银行机构代码
                B.FIN_LICS_NUM,             --金融许可证号
                B.ORG_NAME,                 --银行机构名称
                COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) COUNTY_CD --机构地区
           FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
           LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
             ON B.ORG_ID = NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID))
           LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C--内部机构信息表
             ON C.ORG_ID = B.ORG_ID1
            AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         UNION ALL
         SELECT A.MAIN_ACCT_ID AS CUST_ACCT_ID,            --账户编号
                A.ACCT_NAME  AS CUST_ACCT_NAME,            --账户户名
                TRIM(A.BELONG_ORG_ID) ACCT_BELONG_ORG_ID,  --账户所属机构
                B.ORG_ID1,                                 --账户所属机构映射报送机构
                B.FIN_INST_CODE,                           --银行机构代码
                B.FIN_LICS_NUM,                            --金融许可证号
                B.ORG_NAME,                 --银行机构名称
                COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) COUNTY_CD --机构地区
           FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
           LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
             ON B.ORG_ID = TRIM(A.BELONG_ORG_ID)
           LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C--内部机构信息表
             ON C.ORG_ID = B.ORG_ID1
            AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        ) I ON E.ENTR_DEP_ACCT_ID = I.CUST_ACCT_ID
       WHERE  A.STD_PROD_ID ='602030100002'
       AND  A.DUBIL_ID IS NOT NULL
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');




     V_SQLCOUNT := SQL%ROWCOUNT;
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
     O_ERRCODE := '0';
     V_ENDTIME := SYSDATE;
     COMMIT;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

     V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
    V_STEP_DESC := '插入委托贷款子表--对公';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_LOAN_ENTRS_SUB
    (
          DATA_DT                                                --1数据日期
        ,LGL_REP_ID                                              --2法人编号
        ,RCPT_ID                                                 --3借据编号
        ,CONSR_CUST_ID                                           --4委托人客户编号
        ,CONSR_TYP                                               --5委托人类型
        ,CONSR_OPEN_BANK_PBC_NO                                  --6委托人开户行行号
        ,CONSR_OPEN_BANK_NM                                      --7委托人开户行名称
        ,ENTRS_ACC                                               --8委托账号
        ,ENTRS_ACC_TYP                                           --9委托账号类型
        ,CUR                                                     --10币种
        ,ENTRS_AMT                                               --11委托金额
        ,ACT_ENTRS_LOAN_AMT                                      --12实际委托贷款金额
        ,ENTRS_LOAN_USEAGE                                       --13委托贷款用途
        ,INT_COLL_FLG                                            --14收息标志
        ,COMM_MODE                                               --15手续费方式
        ,COMM_CUR                                                --16手续费币种
        ,COMM_AMT                                                --17手续费金额
        ,AGRT_START_DT                                           --18协议起始日期
        ,AGRT_EXP_DT                                             --19协议到期日期
        ,HDLR_NM                                                 --20经办人姓名
        ,HDLR_NO                                                 --21经办人工号
        ,HDL_ORG_NM                                              --22经办机构名称
        ,AGRT_STAT                                               --23协议状态
        ,ENTRS_LOAN_DIR                                          --24委托贷款投向
        ,ENTRS_LOAN_SUM_CL                                       --25委托贷款细类
        ,DEPT_LINE                                               --26部门条线
        ,DATA_SRC                                                --27数据来源
        ,CONT_ID                                                  --28合同编号
        ,CAP_SRC_CD                                               --29资金来源代码
        ,OUT_COMM_FEE                                             --30 出账手续费
        ,CONSR_NM                                                 --31 委托人名称
        )
      SELECT
            V_P_DATE AS DATA_DT, --数据日期
            A.LP_ID AS LGL_REP_ID, --法人编号
            A.DUBIL_ID AS RCPT_ID, --借据编号
            NVL(C.CUST_ID,C1.CUST_ID) AS CONSR_CUST_ID, --委托人客户编号
            J.CSNER_TYPE_CD AS CONSR_TYP, --委托人类型
            D.PBC_PAY_BANK_NO AS CONSR_OPEN_BANK_PBC_NO, --委托人开户行行号
            D.ORG_NAME AS CONSR_OPEN_BANK_NM, --委托人开户行名称
            B.CSNER_DEP_ACCT_NUM AS ENTRS_ACC, --委托账号
            NULL AS ENTRS_ACC_TYP, --委托账号类型
            A.CURR_CD              AS CUR, --币种
            B.DUBIL_AMT AS ENTRS_AMT, --委托金额
            B.DUBIL_AMT AS ACT_ENTRS_LOAN_AMT, --实际委托贷款金额
            B.LOAN_USAGE_DESCB AS ENTRS_LOAN_USEAGE, --委托贷款用途
            CASE
              WHEN B.INT_ACCR_FLG = '1' THEN
               'Y'
              WHEN B.INT_ACCR_FLG = '0' THEN
               'N'
            END AS INT_COLL_FLG, --收息标志
            G.CD_DESCB AS COMM_MODE, --手续费方式
            A.CURR_CD AS COMM_CUR, --手续费币种
            B.ENTR_LOAN_COMM_FEE AS COMM_AMT, --手续费金额
            TO_CHAR(A.DISTR_DT, 'YYYYMMDD') AS AGRT_START_DT, --协议起始日期
            CASE
              WHEN B.RENEW_FLG = '1' THEN
               TO_CHAR(A.EXEC_EXP_DT, 'YYYYMMDD')
              ELSE
               TO_CHAR(A.APOT_EXP_DT, 'YYYYMMDD')
            END AS AGRT_EXP_DT, --协议到期日期
            E.CLERK_NAME AS HDLR_NM, --经办人姓名
            A.OPER_TELLER_ID AS HDLR_NO, --经办人工号
            A.OPER_ORG_ID AS HDL_ORG_NM, --经办机构名称
            F.CD_DESCB AS AGRT_STAT, --协议状态
            CASE WHEN M.BILL_ID IS NULL
                 THEN 'B99'
                 ELSE 'B01'
                 END AS ENTRS_LOAN_DIR, --委托贷款投向
            /*CASE WHEN B.LOAN_USAGE_DESCB LIKE '%资金周转%'
                 THEN '9011'
                 ELSE '9012'
                 END  AS ENTRS_LOAN_SUB_CL, --委托贷款细类
             */
            '9012'   AS ENTRS_LOAN_SUB_CL,      --委托贷款细类
             NULL    AS DEPT_LINE, --部门条线
            '对公贷款' AS DATA_SRC --数据来源
            ,K.CONT_ID AS CONT_ID --合同编号
            ,J.CAP_SRC_CD AS CAP_SRC_CD --资金来源代码
            ,I.COMM_FEE   AS OUT_COMM_FEE
            ,J.CSNER_NAME AS CONSR_NM   --委托人名称
      FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
      INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
             ON B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             AND A.DUBIL_ID = B.DUBIL_NUM
      LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO M --票据转贴现信息
            ON A.BILL_ID = M.BILL_ID
            AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO K --对公贷款合同信息  add by hulj 20221123
           ON A.CONT_ID=K.CONT_ID
           AND K.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO C
        ON C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND B.CSNER_DEP_ACCT_NUM = C.CUST_ACCT_ID
      LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO C1   --modify 20230117 LHQ 优先从C表关联取数，再从C1表关联取数
        ON C1.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND B.CSNER_DEP_ACCT_NUM = C1.CUST_ACCT_CARD_NO
       AND C1.CUST_ACCT_CARD_NO IS NOT NULL
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO D
        ON D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND NVL(C.OPEN_ACCT_ORG_ID,C1.OPEN_ACCT_ORG_ID) = D.ORG_ID
      LEFT JOIN O_ICL_CMM_CLERK_INFO E --行员信息表
        ON A.OPER_TELLER_ID = E.TELLER_ID
        AND E.TELLER_ID <> ' '
       AND E.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_IML_AGT_CSNER_OUT_ACCT_INFO_H J  --委托人出账信息历史
        ON J.DUBIL_ID = A.DUBIL_ID
        AND J.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND J.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_IML_REF_PUB_CD F --公共代码表
        ON A.DUBIL_STATUS_CD = F.CD_VAL
       AND F.CD_ID = 'CD1258'
      LEFT JOIN O_IML_REF_PUB_CD G --公共代码表
        ON B.ENTR_LOAN_COMM_FEE_COLL_WAY = G.CD_VAL
       AND G.CD_ID = 'CD1095'
      LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO H
        ON E.BELONG_ORG_ID = H.ORG_ID
       AND H.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H I --贷款出账对公贷款附属信息历史
           ON I.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
           AND I.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND I.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND A.STD_PROD_ID ='602030100001';

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
      FROM M_LOAN_ENTRS_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID
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

  END ETL_INIT_M_LOAN_ENTRS_SUB;
/

