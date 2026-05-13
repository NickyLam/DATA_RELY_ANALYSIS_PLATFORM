CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CRDT_LMT_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CRDT_LMT_INFO
  *  功能描述：授信额度主表-授信额度子表
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LGLC_INFO  M_CRDT_LMT_SUB
  *  配置表：  CODE_MAP
  *  修改情况：
     序号   修改日期  修改人   修改原因
  *   01    20220524  梅炜     首次创建
      02    20220901  MW       增加码值表模块判定
      03    20221114  hulj     增加数据重复校验
      04    20221201  liuyu    重新开发
                               零售口径：额度合同有效的取额度合同金额，单笔单批取不到额度合同取业务合同金额。
                                         只有原额度续作、借新还旧、资产重组三种发生方式会产生新的合同，如果额度项下有借据置为有效，否则为失效。
                               零售系统: 曹志鹏以及禹晴确认合同有效未到期都纳入授信总额统计
                               网贷系统：周吉荣确认原新心金融逻辑需要继续保持，其他网贷逻辑以旧系统为准
     05    20221222  liuyu     转授信的已用额度改成业务合同金额取数
     06    20221222  liuyu     对公已用额度经过确认可以直取数仓合同表已用额度调整逻辑
     07    20221223  liuyu     联合网贷有特殊操作，上线后需要注释
     08    20221226  liuyu     M层授信主表和授信子表合并在一个过程出数
     09    20221227  liuyu     新增关联综合信贷产品表取额度品种划分经营消费额度，取额度合同贷款用途字段判断贷款类型
     10    20230103  liuyu     按照周吉荣口径调整新心金融小微贷授信统计逻辑
     11    20230114  liuyu     网商小贷非循环逻辑根据额度差异讨论会议本身要监管加工，
                               咨询了李龙龙后发现无法按照原有逻辑取数，信贷会改变迁移逻辑，监管逻辑不变
     12    20230523  WYZ       联合网贷部分产品映射增加兜底逻辑（有新增产品）
     13    20230908  HYF       网商贷部分限制最高额度为50W
     14    20231110  HYF       微粒贷部分只取审批通过
     15    20231226  HYF       按业务黄娅娅要求，判定对公业务授信状态十分有效，优先取信贷有效标志
                               ,授信额度取额度类型是公司自用额度和同业自用额度
           20231229  hulj      网商贷资本新规调整授信，改为单笔单批，授信额度、已用额度等于放款金额
     16    20240104  HYF       网商贷资本新规调整授信，改为单笔单批，授信额度、已用额度等于放款金额，循环标志为否
                               授信额度不需限制最高为50W
     17    20240313  HYF       按业务黄娅娅要求，对公信贷部分剔除100020100004-同业客户代销专项额度 100010100006-公司客户代销专项额度
     18    20240417  YJY       按业务要求，个人消费信用贷（新兴贷2.0）产品授信额度前期业务确认按照单笔单批报送，授信额度、已用额度等于放款金额
     19    20240520  YJY       调整联合网贷这部分改成取本月余额不为0 的借据，参考表内借据east口径标志这部分。
     20    20240704  LIP       调整联合网贷过滤条件
     21    20240722  YJY       对公-转授信部分新增‘授信合同-客户风险’字段，取客户的额度合同，授信额度子表同步新增‘授信合同-客户风险’
     22    20240802  YJY       优化脚本
     23    20241025  LIP       新增行内贷款相关合同的状态字段
     24    20241210  YJY       个体工商户兴付贷贸易融资纳入个人经营性贷款
     25    20250114  YJY       1)调整联合网贷-非网商贷部分逻辑，业务品种编号纳入字节小微贷产品
                               2)新增授信审批日期字段，对公零售都可从额度审批信息表中取审批通过日期，联合网贷部分暂时置空
     26    20250208  YJY       调整对公贷款部分中授信到期日期的逻辑判断，默认99991231
     27    20250219  YJY       新增微业贷产品的判断，数据来源定义为对公联合网贷
     28    20250220  YJY       1)调整买断式转贴现部分中客户号取交易对手编号
                               2)新增’对公系统内转贴现转授信‘逻辑，针对1104、金数报送需求对系统内转贴现部分进行单独处理，其他报送仍按照原转授信逻辑报送
                               3)新增客户号（系统内转贴现）、是否系统内转贴现客户标识、授信总额度（系统内转贴现）、已用额度（系统内转贴现）
     29    20250311  YJY       优化脚本
     30    20250402  LIP       调整零售单笔单批授信到期日期的取数口径，增加取数来源
     31    20250423  HYF       调整处理系统内转贴
     32    20250508  YJY       调整银承部分的客户号、借据号，取对公借据信息表
     33    20250508  YJY       加工银承部分的授信客户编号
     34    20250618  YJY       剔除发生类型为“展期”的额度合同
     35    20250619  YJY       处理转授信的已用额度逻辑，当放款金额大于授信金额时，取放款金额
  *  36    20250814  LIP       调整授信信息表100010100004的授信种类为“其他-交易类限额额度”
  *  37    20250908  YJY       新增零售360借条的授信加工，该产品同一个客户只有一笔有效的授信和批复，会有多笔业务合同和出账，故从零售授信额度审批信息取值
                               业务方芳确认，如果存在借据未结清但其授信编号或者批复编号失效的情况时，取其借据号为授信合同，其借据金额为授信额度（对此数据做兜底）
  *  38    20251104  YJY       联合网贷非网商贷部分，调整分期乐、好企贷-数据贷（微业贷3.0）产品放款日期的限制，授信状态字段逻辑处理以及针对核销日期的限制处理
  *  39    20251120  YJY       新增203050100002-微众对公联合贷（微业贷4.0）产品
  *  40    20251127  YJY       一表通要求扩大授信额度子表的取数范围：扩大为本年结清、转让或核销、以及未结清的借据对应的额度合同也要获取（当前生产是零售部分取当日余额不为零的借据对应的额度信息，
                               对公部分存在到期日期是往年但是借据是今年结清的数据导致卡到期日时数据被过滤掉），模型评估：新增两个字段，east月口径、一表通年口径
  *  41    20260310  LIP       调整对公信贷零售信贷的月报、年报标志判断逻辑，增加合同终止日期的判断
  *  42    20260413  YJY       一表通严希婧反馈：203050100002-微众对公联合贷的取联合贷额度信息表的LMT_RELA_APPL_ID--额度关联申请编号（行内授信编号），其他产品取LMT_CONT_ID--额度合同编号
  *********************************************************************/
AS
  --定义变量 --
  V_STEP             INTEGER := 0;        --处理步骤
  V_P_DATE           VARCHAR2(8);         --跑批数据日期
  V_STARTTIME        DATE;                --处理开始时间
  V_ENDTIME          DATE;                --处理结束时间
  V_SQLCOUNT         INTEGER := 0;        --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);       --SQL执行描述信息
  --V_MONTH_START_DATE DATE;                --系统时间对应月初日期
  V_STEP_DESC        VARCHAR2(200);       --任务名称
  V_PART_NAME        VARCHAR2(100);       --分区名
  V_TAB_NAME         VARCHAR2(100) := 'M_CRDT_LMT_INFO'; --表名
  V_TAB_NAME2        VARCHAR2(100) := 'M_CRDT_LMT_SUB'; --子表表名
  V_PROC_NAME        VARCHAR2(100) := 'ETL_M_CRDT_LMT_INFO'; --程序名称
  V_PROC_NAME2       VARCHAR2(100) := 'ETL_M_CRDT_LMT_SUB'; --程序名称 --MOD BY YJY 20240802
  V_SYSTEM           VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'MM');

  --支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '--程序跑批开始--';
  V_STARTTIME := SYSDATE;
  --用到的临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP01'; --对公已用额度临时表 01
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP02'; --授信额度明细主表 02
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP04'; --按照授信合同维度整合表 04
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP05'; --处理首次授信日期 05
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP06'; --整合借据余额 06
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP07'; --授信额度主表 07

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME2, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME2 ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; --2
  V_STEP_DESC := '整合各项贷款余额--对公贷款';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP06';
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文
    ,CUST_ID_ZT           --客户号（系统内转贴现）  ADD BY YJY 20250220
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    )
  WITH TMP AS(  --单独处理系统内转贴客户，系统内转贴客户借用核心客户做业务也标记出来
  SELECT DISTINCT
         CASE WHEN T4.CUST_ID IS NOT NULL AND A.SYS_IN_FLG = '0' --系统内
              THEN T4.CUST_ID --系统内转贴现客户取其直贴客户号
              ELSE NULL/*A.CNTPTY_ID*/ --20250311
          END   AS CUST_ID_ZT
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
    LEFT JOIN ( SELECT BILL_NUM,BILL_SUB_INTRV_ID,MIN(CUST_ID) AS CUST_ID,MIN(CUST_NAME) AS CUST_NAME --对客户号进行去重 20240111
                  FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
                 WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态 06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
                   AND A.ENTRY_STATUS_CD = '03'
                   AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 GROUP BY BILL_NUM,BILL_SUB_INTRV_ID ) T4
      ON T4.BILL_NUM = A.BILL_NUM
     AND T4.BILL_SUB_INTRV_ID = A.BILL_SUB_INTRV_ID
   WHERE A.TRAN_DIR_CD = '01' --买入
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03' --记账成功
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(B1,A,C,D,O)*/
          A.DUBIL_ID                        AS RCPT_ID              --借据号
         ,A.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(A.BILL_NUM)                  AS BILL_NO              --票据号
         ,TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,TRIM(B.CUST_ID)                   AS CUST_ID              --客户号
         ,TRIM(D.CUST_ID)                   AS LMT_CUST_ID          --授信客户号
         ,B.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,A.STD_PROD_ID                     AS LOAN_PROD_ID         --产品号
         ,NVL(B.CURR_CD,'CNY')              AS CUR                  --币种
         ,A.DUBIL_AMT                       AS LOAN_AMT             --放款金额
         ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
               WHEN B.WRT_OFF_FLG <> '1'
               THEN CASE WHEN B.SUBJ_ID LIKE '1313%'
                         THEN NVL(B.OVDUE_PRIC_BAL,0) + NVL(B.IDLE_PRIC,0) + NVL(B.BAD_DEBT_PRIC,0)
                         ELSE NVL(B.PRIC_BAL,0) - NVL(B.WRT_OFF_PRIC,0)
                     END
           END                              AS LOAN_BAL             --贷款余额
         ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
               WHEN B.WRT_OFF_FLG <> '1'
               THEN CASE WHEN B.SUBJ_ID LIKE '1313%' THEN 0
                         WHEN B.SUBJ_ID IN ('30070102') THEN 0
                         WHEN A.STD_PROD_ID IN ('203040600001') AND B.SUBJ_ID IN ('13050201%')
                         THEN NVL(B.IN_BS_INT,0)
                         WHEN A.STD_PROD_ID IN ('203020300002','203030600002','203020300001','203030600001') --福费廷
                         THEN NVL(B.IN_BS_INT,0)
                         ELSE 0
                     END
           END                              AS INT_ADJ              --利息调整
         ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
               WHEN B.WRT_OFF_FLG <> '1'
               THEN CASE WHEN B.SUBJ_ID LIKE '1313%' THEN 0
                         WHEN B.SUBJ_ID IN ('30070102') THEN 0
                         WHEN A.STD_PROD_ID IN ('203040600001') AND B.SUBJ_ID IN ('13050201%') THEN NVL(AA.N_PV_VARIATION,0)
                         WHEN A.STD_PROD_ID IN ('203030600002','203020300002','203020300001','203030600001') THEN NVL(AA.N_PV_VARIATION,0)
                         ELSE 0
                     END
           END                              AS FAIR_VAL_CHG         --公允价值变动
         ,''                                AS DATA_SRC             --数据来源
         ,'普通贷款'                        AS DATA_SRC_DESC        --数据来源中文
         ,CASE WHEN A.CUST_ID = E.CUST_ID_ZT AND E.CUST_ID_ZT IS NOT NULL THEN A.CUST_ID --系统内转贴现客户取其直贴客户号
               ELSE '' --20250311
           END                              AS CUST_ID_ZT           --客户号（系统内转贴现） ADD BY YJY 20250220
         --,A.PAYOFF_DT                       AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,B.CLOS_ACCT_DT                    AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
         ,B.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息表
      ON B.DUBIL_NUM = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息表 取额度合同
      ON D.CONT_ID = C.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE AA --估值报告表
      ON AA.V_TRADE_NO = A.DUBIL_ID
     AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TMP E
      ON E.CUST_ID_ZT = A.CUST_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 --ADD BY YJY 20251127 取核销日期
      ON F.DUBIL_ID = A.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (A.STD_PROD_ID LIKE '2%'
         OR A.STD_PROD_ID LIKE '6020%'
         OR A.STD_PROD_ID IS NULL
         OR A.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002')
         OR C.STD_PROD_ID LIKE '2%'
         OR C.STD_PROD_ID LIKE '6020%'
         OR C.STD_PROD_ID IS NULL
         OR C.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002'))
     AND A.DUBIL_ID IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合各项贷款余额--贴现部分'; --3
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    )
  SELECT /*+USE_HASH(B1,A,C,D,O)*/
          B.DUBIL_ID                        AS RCPT_ID             --借据号
         ,B.CONT_ID                         AS CONT_ID              --合同号
         ,A.BILL_ID                         AS BILL_NO              --票据号
         ,TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,TRIM(A.CUST_ID)                   AS CUST_ID              --客户号
         ,TRIM(D.CUST_ID)                   AS LMT_CUST_ID          --授信客户号
         ,A.ENTER_ACCT_ORG_ID               AS ORG_ID               --机构号
         ,A.STD_PROD_ID                     AS LOAN_PROD_ID         --产品号
         ,NVL(A.CURR_CD,'CNY')              AS CUR                  --币种
         ,A.FAC_VAL_AMT                     AS LOAN_AMT             --放款金额
         ,CASE WHEN B.PAYOFF_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN ROUND(NVL(A.CURRT_BAL,0),2)
               ELSE 0
           END                              AS LOAN_BAL             --贷款余额
         ,NVL(A.INT_ADJ_BAL,0)              AS INT_ADJ              --利息调整
         ,NVL(O.N_PV_VARIATION,0)           AS FAIR_VAL_CHG         --公允价值变动
         ,''                                AS DATA_SRC             --数据来源
         ,'贴现部分'                        AS DATA_SRC_DESC        --数据来源中文
         ,B.PAYOFF_DT                       AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
         ,E.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
     AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
      ON C.CONT_ID = B.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息表 取额度合同
      ON D.CONT_ID = C.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
      ON O.V_TRADE_NO = A.BILL_NUM
     AND O.V_BUSINESSTYPE = B.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY YJY 20251127 新增关联账户表、核销表，获取转让日期、核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO E --对公贷款账户信息表
      ON E.DUBIL_NUM = B.DUBIL_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 --ADD BY YJY 20251127 取核销日期
      ON F.DUBIL_ID = B.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DISCNT_STATUS_CD IN ('06')
     AND A.ENTRY_STATUS_CD = '03'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合各项贷款余额--买断式转贴现'; --4
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文
    ,CUST_ID_ZT           --客户号（系统内转贴现）  ADD BY YJY 20250220
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    ) 
  WITH TMP AS(--单独处理系统内转贴客户，既有系统内转贴又有系统外转贴的当做系统内贴处理
  SELECT DISTINCT
         CASE WHEN T4.CUST_ID IS NOT NULL AND A.SYS_IN_FLG = '0' --系统内
              THEN T4.CUST_ID --系统内转贴现客户取其直贴客户号
              ELSE NULL/*A.CNTPTY_ID*/ --20250311
          END AS CUST_ID_ZT
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
    LEFT JOIN (SELECT BILL_NUM,BILL_SUB_INTRV_ID,MIN(CUST_ID) AS CUST_ID,MIN(CUST_NAME) AS CUST_NAME --对客户号进行去重 20240111
                 FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
                WHERE A.ENTRY_STATUS_CD = '03'
                  --AND A.DISCNT_STATUS_CD NOT IN ('012','001')
                  AND A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态 06为记账完成
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY BILL_NUM,BILL_SUB_INTRV_ID) T4
      ON T4.BILL_NUM = A.BILL_NUM
     AND T4.BILL_SUB_INTRV_ID = A.BILL_SUB_INTRV_ID
   WHERE A.TRAN_DIR_CD = '01' --买入
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03' --记账成功
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(A,C,F2,D,DD,O)*/
          B.DUBIL_ID                       AS RCPT_ID              --借据号
         ,B.CONT_ID                        AS CONT_ID              --合同号
         ,TRIM(A.BILL_NUM)                 AS BILL_NO              --票据号
         ,TRIM(D.LMT_CONT_ID)              AS LMT_CONT_ID          --授信合同号
         --,B.CUST_ID                        AS CUST_ID              --客户号
         ,A.CNTPTY_ID                      AS CUST_ID              --客户号 --MOD BY YJY 20250220取交易对手的客户编号
         ,TRIM(E.CUST_ID)                  AS LMT_CUST_ID          --授信客户号
         ,A.ACCT_INSTIT_ID                 AS ORG_ID               --机构号
         ,B.BUS_BREED_ID                   AS LOAN_PROD_ID         --产品号
         ,NVL(A.CURR_CD,'CNY')             AS CUR                  --币种
         ,A.FAC_VAL_AMT                    AS LOAN_AMT             --放款金额
         ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                    AND J.PAYOFF_FLG = '0'
               THEN ROUND((NVL(A.CURRT_BAL,0)),2)
               WHEN NVL(A.CURRT_BAL,0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN ROUND((NVL(A.CURRT_BAL,0)),2)
               ELSE 0
           END                             AS LOAN_BAL             --贷款余额
         ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                    AND J.PAYOFF_FLG = '0'
               THEN NVL(A.INT_ADJ_BAL,0)
               WHEN NVL(A.CURRT_BAL,0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN NVL(A.INT_ADJ_BAL,0)
               ELSE 0
           END                             AS INT_ADJ              --利息调整
         ,CASE WHEN V_P_DATE <= '20210630' AND NVL(A.CURRT_BAL,0) = 0 AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN 0
               WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                    AND J.PAYOFF_FLG = 0
               THEN NVL(O.N_PV_VARIATION,0)
               WHEN NVL(A.CURRT_BAL,0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN NVL(O.N_PV_VARIATION,0)
               ELSE 0
            END                             AS FAIR_VAL_CHG         --公允价值变动
         ,'买断式转贴现部分'                AS DATA_SRC             --数据来源
         ,'买断式转贴现部分'                AS DATA_SRC_DESC        --数据来源中文
         /*,CASE WHEN A.SYS_IN_FLG = '0' --系统内
                AND T4.CUST_ID IS NOT NULL
               THEN T4.CUST_ID  --系统内转贴现客户取其直贴客户号
               ELSE NULL\*A.CNTPTY_ID*\ --20250311
           END                              AS CUST_ID_ZT           --客户号（系统内转贴现）  ADD BY YJY 20250220*/
         ,CASE WHEN T4.CUST_ID IS NOT NULL AND A.SYS_IN_FLG = '0' --系统内
               THEN T4.CUST_ID --系统内转贴现客户取其直贴客户号
               WHEN T4.CUST_ID IS NOT NULL AND A.SYS_IN_FLG = '1' --系统外
                    AND T4.CUST_ID = TMP.CUST_ID_ZT
               THEN T4.CUST_ID  --系统内转贴现客户取其直贴客户号
               ELSE NULL/*A.CNTPTY_ID*/ --20250311
           END                              AS CUST_ID_ZT           --客户号（系统内转贴现）  ADD BY YJY 20250220
         ,B.PAYOFF_DT                       AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
         ,G.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息表
      ON D.CONT_ID = B.CONT_ID
     AND NVL(TRIM(D.CRDT_TYPE_CD),'02') = '02'
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO J --票据中心信息
      ON J.BILL_ID = A.BILL_ID
     AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息表
      ON E.CONT_ID = D.LMT_CONT_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表 关联估值表取 转 公允价值变动
      ON O.V_TRADE_NO = B.BILL_NUM
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT BILL_NUM,BILL_SUB_INTRV_ID,MIN(CUST_ID) AS CUST_ID,MIN(CUST_NAME) AS CUST_NAME --对客户号进行去重 20240111
                 FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
                WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态 06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
                  AND A.ENTRY_STATUS_CD = '03'
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY BILL_NUM,BILL_SUB_INTRV_ID) T4
      ON T4.BILL_NUM = A.BILL_NUM
     AND T4.BILL_SUB_INTRV_ID = A.BILL_SUB_INTRV_ID
    LEFT JOIN TMP
      ON TMP.CUST_ID_ZT = T4.CUST_ID
    --ADD BY YJY 20251127 新增关联账户表、核销表，获取转让日期、核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO G --对公贷款账户信息表
      ON G.DUBIL_NUM = B.DUBIL_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 --ADD BY YJY 20251127 取核销日期
      ON F.DUBIL_ID = B.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_DIR_CD = '01' --买入
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03' --记账成功
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合表外业务余额--信用证'; --5
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.ACCT_ID||'_'||A.MX_LC_FLG       AS RCPT_ID              --借据号
         ,E.CONT_ID                         AS CONT_ID              --合同号
         ,''                                AS BILL_NO              --票据号
         ,TRIM(E.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,NULL                              AS LMT_CUST_ID          --授信客户号 表外的不用算转授信
         ,B.CUST_ID                         AS CUST_ID              --客户号
         ,A.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,''                                AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,A.ISSUE_AMT                       AS LOAN_AMT             --放款金额
         ,B.NOMAL_PRIC                      AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,''                                AS DATA_SRC             --数据来源
         ,'信用证部分'                      AS DATA_SRC_DESC        --数据来源中文
         ,B.PAYOFF_DT                       AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
         ,G.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.CONT_ID = E.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A --信用证账户信息
      ON A.LC_ID = B.BILL_NUM
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY YJY 20251127 新增关联账户表、核销表，获取转让日期、核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO G --对公贷款账户信息表
      ON G.DUBIL_NUM = B.DUBIL_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 -- ADD BY YJY 20251127 取核销日期
      ON F.DUBIL_ID = B.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.STD_PROD_ID IN ('601020100001','601020100002','603010100002','601020200001','601020200002','603010300002') --信用证
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合表外业务余额--保函'; --6
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
          A.ACCT_ID                         AS RCPT_ID              --借据号
         ,E.CONT_ID                         AS CONT_ID              --合同号
         ,''                                AS BILL_NO              --票据号
         ,TRIM(E.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,E.CUST_ID                         AS CUST_ID              --客户号
         ,NULL                              AS LMT_CUST_ID          --授信客户号 表外的不用算转授信
         ,A.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,''                                AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,A.LOG_AMT                         AS LOAN_AMT             --放款金额
         ,A.CURRT_BAL                       AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,''                                AS DATA_SRC             --数据来源
         ,'保函部分'                        AS DATA_SRC_DESC        --数据来源中文
         ,B.PAYOFF_DT                       AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
         ,G.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.CONT_ID = E.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO A --保函账户信息
      ON A.LOG_CONT_ID = B.DUBIL_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY YJY 20251127 新增关联账户表、核销表，获取转让日期、核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO G --对公贷款账户信息表
      ON G.DUBIL_NUM = B.DUBIL_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 --ADD BY YJY 20251127 取核销日期
      ON F.DUBIL_ID = B.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (B.STD_PROD_ID LIKE '60103010000%'
          OR B.STD_PROD_ID LIKE '60103020000%'
          OR B.STD_PROD_ID LIKE '60103040000%')
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合表外业务余额--银行承兑汇票';--7
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    )
    WITH DK_LOAN AS (--银承垫款借据 --ADD BY LIP 20251202
  SELECT TA.DUBIL_ID,TA.PAYOFF_DT,TB.FIR_WRT_OFF_DT,TC.ASSET_TRAN_DT
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TA
      ON TA.DUBIL_ID = TRIM(T.RELA_DUBIL_ID)
     AND TA.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO TB --贷款核销信息
      ON TB.DUBIL_ID = TA.DUBIL_ID
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO TC --对公贷款账户信息表
      ON TC.DUBIL_NUM = TA.DUBIL_ID
     AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.STD_PROD_ID = '203040100001'
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(A,B,C,D)*/
          --B.ACCT_ID                         AS RCPT_ID              --借据号
          A.DUBIL_ID                        AS RCPT_ID              --借据号  MOD BY YJY 20250508
         ,A.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(A.BILL_NUM)                  AS BILL_NO              --票据号
         ,TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         --,NVL(C.CUST_ID,A.CUST_ID)          AS CUST_ID              --客户号
         ,NVL(TRIM(A.CUST_ID),TRIM(C.CUST_ID))  AS CUST_ID          --客户号 MOD BY YJY 20250508
         ,TRIM(E.CUST_ID)                   AS LMT_CUST_ID          --授信客户号 MOD BY YJY 20250508
         ,B.ACPT_ORG_ID                     AS ORG_ID               --机构号
         ,A.STD_PROD_ID                     AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,NVL(B.FAC_VAL_AMT,A.DUBIL_AMT)    AS LOAN_AMT             --放款金额
         ,A.DUBIL_BAL                       AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,''                                AS DATA_SRC             --数据来源
         ,'银承部分'                        AS DATA_SRC_DESC        --数据来源中文
         --,A.PAYOFF_DT                       AS PAYOFF_DT            --结清日期 ADD BY YJY 20251127
         --,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期 ADD BY YJY 20251127
         --,G.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期 ADD BY YJY 20251127
         --MOD BY LIP 20251202 用垫款的结清日期当成承兑的到期日期
         ,CASE WHEN T1.DUBIL_ID IS NOT NULL THEN T1.PAYOFF_DT
               ELSE A.PAYOFF_DT
           END                              AS PAYOFF_DT            --结清日期 MOD BY LIP 20251202
         ,CASE WHEN T1.DUBIL_ID IS NOT NULL THEN T1.FIR_WRT_OFF_DT
               ELSE F.FIR_WRT_OFF_DT
           END                              AS FIR_WRT_OFF_DT       --核销日期 MOD BY LIP 20251202
         ,CASE WHEN T1.DUBIL_ID IS NOT NULL THEN T1.ASSET_TRAN_DT
               ELSE G.ASSET_TRAN_DT
           END                              AS ASSET_TRAN_DT        --转让日期 MOD BY LIP 20251202
     FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
    INNER JOIN RRP_MDL.O_ICL_CMM_BA_ACCT_INFO B --银承账户信息
       ON B.BILL_NUM = A.BILL_NUM
      AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO C --存款客户账户信息表
       ON C.CUST_ACCT_ID = A.STL_ACCT_NUM
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息表
       ON D.CONT_ID = A.CONT_ID
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     --ADD BY YJY 20250508 新增对公合同表关联，取额度合同客户号
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息表
       ON E.CONT_ID = D.LMT_CONT_ID
      AND E.CRDT_TYPE_CD = '01' --额度合同
      AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     --ADD BY YJY 20251127 新增关联账户表、核销表，获取转让日期、核销日期
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO G --对公贷款账户信息表
       ON G.DUBIL_NUM = A.DUBIL_ID
      AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 --ADD BY YJY 20251127 取核销日期
       ON F.DUBIL_ID = A.DUBIL_ID
      AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN DK_LOAN T1 --MOD BY LIP 20251202
       ON T1.DUBIL_ID = A.BILL_NUM
    WHERE TRIM(A.BILL_NUM) IS NOT NULL
      AND A.STD_PROD_ID IN ('601010100001') --601010100001 银承承兑 20221121 MW
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合对公当天失效部分';--9
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文  
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
          A.DUBIL_ID                        AS RCPT_ID              --借据号
         ,A.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(A.BILL_NUM)                  AS BILL_NO              --票据号
         ,TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,A.CUST_ID                         AS CUST_ID              --客户号
         ,NULL                              AS LMT_CUST_ID          --授信客户号
         ,''                                AS ORG_ID               --机构号
         ,''                                AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,A.DUBIL_AMT                       AS LOAN_AMT             --放款金额
         ,0                                 AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,''                                AS DATA_SRC             --数据来源
         ,'当天失效'                        AS DATA_SRC_DESC        --数据来源中文
         ,A.PAYOFF_DT                       AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
         ,G.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息表
      ON D.CONT_ID = A.CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY YJY 20251127 新增关联账户表、核销表，获取转让日期、核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO G --对公贷款账户信息表
      ON G.DUBIL_NUM = A.DUBIL_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 --ADD BY YJY 20251127 取核销日期
      ON F.DUBIL_ID = A.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(A.DISTR_DT,TO_DATE('00010101','YYYYMMDD')) = TO_DATE(V_P_DATE,'YYYYMMDD') --发放日=当天
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合各项贷款余额--零售贷款';--10
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP06
    (RCPT_ID              --借据号
    ,CONT_ID              --合同号
    ,BILL_NO              --票据号
    ,LMT_CONT_ID          --授信合同号
    ,CUST_ID              --客户号
    ,LMT_CUST_ID          --授信客户号
    ,ORG_ID               --机构号
    ,LOAN_PROD_ID         --产品号
    ,CUR                  --币种
    ,LOAN_AMT             --放款金额
    ,LOAN_BAL             --贷款余额
    ,INT_ADJ              --利息调整
    ,FAIR_VAL_CHG         --公允价值变动
    ,DATA_SRC             --数据来源
    ,DATA_SRC_DESC        --数据来源中文
    ,PAYOFF_DT            --结清日期   ADD BY YJY 20251127
    ,FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
    ,ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
          A.DUBIL_NUM                       AS RCPT_ID              --借据号
         ,A.CONT_ID                         AS CONT_ID              --合同号
         ,''                                AS BILL_NO              --票据号
         ,TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,A.CUST_ID                         AS CUST_ID              --客户号
         ,NULL                              AS LMT_CUST_ID          --授信客户号
         ,''                                AS ORG_ID               --机构号
         ,''                                AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,A.DUBIL_AMT                       AS LOAN_AMT             --放款金额
         ,A.CURRT_BAL                       AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,''                                AS DATA_SRC             --数据来源
         ,'零售'                            AS DATA_SRC_DESC        --数据来源中文
         --,B.PAYOFF_DT                       AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,A.CLOS_ACCT_DT                    AS PAYOFF_DT            --结清日期   ADD BY YJY 20251127
         ,F.FIR_WRT_OFF_DT                  AS FIR_WRT_OFF_DT       --核销日期   ADD BY YJY 20251127
         ,A.ASSET_TRAN_DT                   AS ASSET_TRAN_DT        --转让日期   ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
      ON A.DUBIL_NUM = B.DUBIL_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO C --零售合同表
      ON C.CONT_ID = B.CONT_ID
     AND C.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY YJY 20251127 新增关联账户表、核销表，获取转让日期、核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO F --贷款核销信息 --ADD BY YJY 20251127 取核销日期
      ON F.DUBIL_ID = B.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE /*A.CURRT_BAL > 0 --余额大于0
     AND A.WRT_OFF_FLG <> '1' --不含核销
     AND*/ --MOD BY YJY 20251127 放开取数范围，为了获取当年结清、转让、核销的借据
         A.SUBJ_ID NOT LIKE '3007%' --不含委托贷款
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '对公已用额度取额度项下借据余额之和';--11
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP01';
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP01
    (DATA_DT                     --数据日期
    ,CRDT_CONT_ID                --授信合同编号
    ,ALDY_USE_LMT                --已用额度
    )
  SELECT  V_P_DATE                        AS DATA_DT                    --数据日期
         ,T.LMT_CONT_ID                   AS CRDT_CONT_ID               --授信合同编号
         ,NVL(SUM(NVL(T.LOAN_BAL,0)),0)   AS ALDY_USE_LMT               --已用额度
    FROM (--MODIFY BY TANGAN AT 20230214 对公已用额度取借据余额之和
    SELECT  A.DUBIL_ID                        AS RCPT_ID              --借据号
           ,A.CONT_ID                         AS CONT_ID              --合同号
           ,TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
           ,A.STD_PROD_ID                     AS LOAN_PROD_ID         --产品号
           --MOD BY LIP 20231010 对借据金额进行汇率换算
           ,A.DUBIL_AMT * NVL(E.EXRT,1)       AS LOAN_AMT             --借据金额
           ,A.DUBIL_BAL * NVL(E.EXRT,1)       AS LOAN_BAL             --借据余额
      FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
        ON C.CONT_ID = A.CONT_ID
       AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      --MOD BY LIP 20231010 对借据金额进行汇率换算
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息表
        ON D.CONT_ID = TRIM(C.LMT_CONT_ID)
       AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO E
        ON E.BASE_CUR = A.CURR_CD
       AND E.CNV_CUR = D.CURR_CD
       AND E.DATA_DT = V_P_DATE
     WHERE TRIM(C.LMT_CONT_ID) IS NOT NULL
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T
     GROUP BY T.LMT_CONT_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入授信额度主表-对公信贷部分';--12
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP02';
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,GROUP_CRDT_FLG                  --36集团授信标志 --add by hulj 20220208
    ,STD_PROD_ID                     --37标准产品编号
    ,APPL_WAY_CD                     --38申请方式代码
    ,APPROVE_SERIAL_FLOW_NUM         --39被动转授信集团批复流水号
    ,APV_FLOW_NUM                    --40批复流水号
    ,LMT_UNDER_SELLBL_PROD_ID        --41可售产品
    ,APV_AMT                         --42批复金额
    ,STATUS_CD                       --43状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --44授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --45是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --46 EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --47 一表通年口径标识 --ADD BY YJY 20251127     
    )
   --MOD BY YJY 20251127 一表通要求：不能仅判断余额不为0的借据，还需判断当年结清、核销、转让的借据
    WITH LMT_INTO_TEMP06 AS (
  SELECT /*+MATERIALIZE*/T6.LMT_CONT_ID
         ,SUM(NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0)) AS ACCT_BAL --账户净值
         /*,MIN(CASE WHEN TO_CHAR(T6.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.ASSET_TRAN_DT)
                   WHEN TO_CHAR(T6.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.FIR_WRT_OFF_DT)
                   WHEN TO_CHAR(T6.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.PAYOFF_DT)
                   ELSE TO_DATE('99991231','YYYYMMDD')
               END) AS ACT_END_DT --实际终止日期*/
         --MOD BY LIP 20251202 取最晚结清的借据终结日期
         ,MAX(CASE WHEN TO_CHAR(T6.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.ASSET_TRAN_DT)
                   WHEN TO_CHAR(T6.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.FIR_WRT_OFF_DT)
                   WHEN TO_CHAR(T6.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.PAYOFF_DT)
                   ELSE TO_DATE('99991231','YYYYMMDD')
               END) AS ACT_END_DT --实际终止日期
     FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 T6
    GROUP BY T6.LMT_CONT_ID),
   LMT_INTO_TEMP07 AS (
    SELECT /*+MATERIALIZE*/T7.LMT_CONT_ID --物化视图
      FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 T7
     WHERE T7.DATA_SRC_DESC = '当天失效'
     GROUP BY T7.LMT_CONT_ID),
  --新增处理系统内转贴
  TMP_ZTX AS (
  SELECT /*+MATERIALIZE*/B.DUBIL_ID,A.BILL_NUM,A.BILL_SUB_INTRV_ID,A.CURRT_BAL
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002') --20220924 MW 修改'204010100001' 银行承兑汇票转贴现 ‘204010100002’ 商业承兑汇票转贴现
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_DIR_CD = '01' --MODIFY BY MW 20221207 上游码值变化
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
     AND A.SYS_IN_FLG = '0'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP2 AS (
  SELECT /*+MATERIALIZE*/C.DUBIL_ID ZTXJJ,B.DUBIL_ID TXJJ,A.BILL_NUM,A.BILL_SUB_INTRV_ID,B.CUST_ID,H.LMT_CONT_ID,C.CURRT_BAL
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
     AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN TMP_ZTX C
      ON C.BILL_NUM = A.BILL_NUM
     AND C.CURRT_BAL <> 0
     AND C.BILL_SUB_INTRV_ID = A.BILL_SUB_INTRV_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO H --对公贷款合同信息
      ON H.CONT_ID = B.CONT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO D --对公贷款账户信息
      ON D.DUBIL_NUM = B.DUBIL_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态 06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03' --03 记账完成
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  CONT_SXRQ AS (--ADD BY LIP 20260310 取合同的终止日期，判断授信是否仍需要报送，影响一表通的表间校验
  SELECT /*+MATERIALIZE*/TRIM(T1.LMT_CONT_ID) AS LMT_CONT_ID,
         MAX(CASE WHEN T1.VALID_FLG_CD = '4' AND T1.ACM_DISTR_AMT <> T1.ACM_CALLBK_AMT THEN TO_DATE('99991231','YYYYMMDD')
                  WHEN TO_CHAR(T1.TERMNT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231') THEN TO_DATE('99991231','YYYYMMDD')
                  ELSE T1.TERMNT_DT
              END) AS TERMNT_DT
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T1
   WHERE (T1.STD_PROD_ID LIKE '2%' OR T1.STD_PROD_ID IN ('602060100001','602060100002','602030100001','602030100001','602030100002'))
     AND T1.CRDT_TYPE_CD = '02' --业务合同
     AND TRIM(T1.LMT_CONT_ID) IS NOT NULL
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T1.LMT_CONT_ID)
  SELECT  /*+USE_HASH(A,C,D,E,F,TA,B)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,A.LP_ID                                         AS LGL_REP_ID                  --02法人编号
         ,NULL                                            AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.CONT_ID                                       AS CRDT_CONT_ID                --04授信合同编号
         /*,A.LMT_CONT_ID                                   AS CRDT_CONT_ID                --04授信合同编号*/
         ,NVL(TRIM(A.MANU_CONT_ID),A.CONT_ID)             AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                       AS CUST_ID                     --06客户编号
         ,NVL(TRIM(A.MGMT_ORG_ID),TRIM(A.RGST_ORG_ID))    AS ORG_ID                      --07机构编号
         ,A.CONT_AMT                                      AS CRDT_LMT                    --08授信额度
         ,NVL(F.ALDY_USE_LMT,0)                           AS ALDY_USE_LMT                --09已用额度
         ,NVL(A.CONT_AMT,0) - NVL(F.ALDY_USE_LMT,0)       AS SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                            AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                            AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                            AS EXP_SUR_LMT                 --13敞口剩余额度
         ,A.CURR_CD                                       AS CUR                         --14币种
         ,CASE WHEN C.CRDT_CUST_TYPE_CD = '3' THEN '05' --同业客户
               WHEN C.CRDT_CUST_TYPE_CD = '5' THEN '02' --集团客户
               WHEN C.CRDT_CUST_TYPE_CD = '2' OR C.CUST_TYPE_CD LIKE '2%' THEN '01' --对公客户
               ELSE '99' --其他
           END                                            AS CRDT_SUBJ_TYP               --15授信主体类型 mod by hulj 20230818
         ,CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         ,CASE WHEN A.VALID_FLG_CD = '2' THEN 'Y' --CD04022 合同状态代码 --MODIFY BY HYF 20231226
               --WHEN B.LMT_CONT_ID IS NOT NULL THEN 'Y' --表内外借据有余额的置为有效
               WHEN NVL(B.ACCT_BAL,0) <> 0 THEN 'Y' --表内外借据有余额的置为有效 --MOD BY YJY 20251127
               WHEN G.LMT_CONT_ID IS NOT NULL THEN 'Y' --当天发放当天结清的置为有效
               WHEN A.LOAN_HAPP_TYPE_CD = '0201' THEN 'N' --展期合同置为失效 CD04031 贷款发放类型代码
               WHEN A.STD_PROD_ID = '100030000002' THEN 'N' --gl开头的都是集团客户的管理额度，集团客户无法发生业务
               WHEN A.CONT_ID LIKE 'MIGT%' THEN 'N' --信贷回复MIGT开头的是新信贷迁移规则，根据批复生成的额度合同，黄娅娅回复剔除
               WHEN T2.LMT_CONT_ID IS NOT NULL THEN 'Z'
               ELSE 'N'
           END                                             AS CRDT_STAT                   --17授信状态 Z0002
         ,LEAST(CASE WHEN TO_CHAR(I.APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(I.APPL_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(A.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
                     ELSE '99991231' END) --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                          AS CRDT_APP_DT                 --18授信申请日期
         ,LEAST(CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(A.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
                     ELSE '99991231' END) --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                          AS CRDT_START_DT               --19授信开始日期
         /*,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                            AS CRDT_EXP_DT                 --20授信到期日期*/
          --MOD BY YJY 20250208 存在线上授信的合同其授信到期日期为20991231，剔除20991231为空的判断，00010101默认99991231
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
               ELSE '99991231'
           END                                            AS CRDT_EXP_DT                 --20授信到期日期
         ,A.STD_PROD_ID                                   AS CRDT_BIZ_TYP                --21授信业务类型
         --由于行内额度管理无法区分授信业务类型该字段取额度合同标准产品号
         ,CASE WHEN A.LMT_CIRCL_FLG = '0' THEN 'N'
               ELSE 'Y'
           END                                            AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN A.STD_PROD_ID IN ('100010100001','100020100001') THEN '01'--综合
               WHEN A.STD_PROD_ID IN ('100010100003') THEN '02' --低风险
               WHEN A.STD_PROD_ID IN ('100010100002','100020100002') THEN '05' --专项
               WHEN A.STD_PROD_ID IN ('100010100004') THEN '9902' --其他-交易类限额额度 --MOD BY LIP 20250814
               WHEN NVL(A.OPEN_BAL,0) = 0 OR A.CONT_TYPE_CD IN ('03') THEN '02' --低风险
               ELSE '9901' --其他-敞口授信
           END                                             AS CRDT_SUBJ_CL               --24授信主体种类 T0029
         ,NULL                                             AS BANK_TAX_COOP_LOAN_CRDT_FLG--25银税合作贷款授信标志
         ,NVL(SUBSTRB(D.CRDT_LMT_APV_OPINION,1,2000),'同意') AS DSN_SHT_OPN              --26决策单意见
         ,D.FINAL_APVER_ID                                 AS APRV_PSN_NO                --27审批人工号
         ,CASE WHEN A.MGMT_TELLER_ID = 'system' AND A.CONT_ID LIKE 'UPL%' THEN '03000063'
               ELSE E.CLERK_ID
           END                                             AS CRDT_EMP_NO                --28授信员工号
         ,'800919'                                         AS DEPT_LINE                  --29部门条线 /*风险管理部*/
         ,'对公信贷'                                       AS DATA_SRC                   --30数据来源
         ,A.BUS_BREED_ID                                   AS BUS_BREED_ID               --31业务品种编号  --ADD BY LIP 20220728
         ,'DG对公部分'                                     AS DATA_SRC_DESC              --32数据来源描述  --ADD BY LIP 20220728
         ,H.LMT_KIND_CD                                    AS LMT_TYPE_CD                --33额度种类代码
         ,A.LOAN_HAPP_TYPE_CD                              AS LOAN_HAPP_TYPE_CD          --34合同发生类型
         ,A.RELA_CONT_ID                                   AS RELA_CONT_ID               --35原合同编号
         ,D.GROUP_CRDT_FLG                                 AS GROUP_CRDT_FLG             --36集团授信标志
         ,A.STD_PROD_ID                                    AS STD_PROD_ID                --37标准产品编号
         ,I.APPL_WAY_CD                                    AS APPL_WAY_CD                --38申请方式代码
         ,K.APPROVE_SERIAL_FLOW_NUM                        AS APPROVE_SERIAL_FLOW_NUM    --39被动转授信集团批复流水号
         ,A.APV_FLOW_NUM                                   AS APV_FLOW_NUM               --40批复流水号
         ,I.LMT_UNDER_SELLBL_PROD_ID                       AS LMT_UNDER_SELLBL_PROD_ID   --41可售产品
         ,D.CRDT_APV_AMT                                   AS APV_AMT                    --42批复金额
         ,A.VALID_FLG_CD                                   AS STATUS_CD                  --43状态代码 --ADD BY LIP 20241025
         ,CASE WHEN TO_CHAR(D.APVED_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(D.APVED_DT,'YYYYMMDD')
           END                                             AS CRDT_APVED_DT              --44授信审批日期  --ADD BY YJY 20250114
         ,'Z'                                              AS CUST_ID_ZT_FLG             --45是否系统内转贴现客户标识 ADD BY YJY 20250220  
         ,CASE WHEN NVL(B.ACCT_BAL,0) <> 0 --余额未结清
                    OR B.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --当月终止
               THEN 'Y'
               WHEN T3.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
               THEN 'Y' --ADD BY LIP 20260310 如果业务合同还没有终止，授信仍需报送
               WHEN NVL(TRIM(A.VALID_FLG_CD),'2') NOT IN ('1','9') --1未生效9其他状态
                    AND (A.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                         OR TO_CHAR(A.TERMNT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231'))
               THEN 'Y'
               ELSE 'N'
           END                                             AS EAST_MON_FLG             --EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN NVL(B.ACCT_BAL,0) <> 0 --余额未结清
                 OR B.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') --当年终止
               THEN 'Y'
               WHEN T3.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
               THEN 'Y' --ADD BY LIP 20260310 如果业务合同还没有终止，授信仍需报送
               WHEN NVL(TRIM(A.VALID_FLG_CD),'2') NOT IN ('1','9') --1未生效9其他状态
                    AND (A.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
                         OR TO_CHAR(A.TERMNT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231'))
               THEN 'Y'
               ELSE 'N'
           END                                              AS YBT_YEAR_FLG             --一表通年口径标识 --ADD BY YJY 20251127          
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A --对公贷款合同信息
    LEFT JOIN LMT_INTO_TEMP06 B --额度项下借据有余额的
      ON B.LMT_CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO_TEMP01 F --对公信贷已用额度临时表
      ON F.CRDT_CONT_ID = A.CONT_ID
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
      /*迁移数据会有部分客户号不在ECIF系统中，直接剔除*/
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO D --对公授信额度合同审批信息
      ON D.CRDT_LMT_APV_FLOW_NUM = A.APV_FLOW_NUM
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO E --行员信息表
      ON E.TELLER_ID = TRIM(A.MGMT_TELLER_ID)
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN LMT_INTO_TEMP07 G --当天授信当天结清的
      ON G.LMT_CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO H --对公贷款额度合同补充信息
      ON H.CONT_ID = A.CONT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO I --对公贷款申请表
      ON I.LOAN_APPL_FLOW_NUM = D.RELA_CRDT_LMT_APV_FLOW_NUM
     AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_PASCT_TURN_CRDT_INFO_H K
      ON K.OBJ_ID = I.LOAN_APPL_FLOW_NUM
     AND K.OBJ_TYPE_NAME = 'CreditApply'
     AND K.ID_MARK <> 'D'
     AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DISTINCT LMT_CONT_ID FROM TMP2) T2
      ON T2.LMT_CONT_ID = A.CONT_ID
    LEFT JOIN CONT_SXRQ T3 --ADD BY LIP 20260310
      ON T3.LMT_CONT_ID = A.CONT_ID
   WHERE A.CRDT_TYPE_CD = '01' --额度合同
     AND SUBSTR(A.STD_PROD_ID,0,7) IN ('1000101','1000201') --1000101 公司自用额度 1000201 同业自用额度 ADD BY HYF 20231226
     AND A.STD_PROD_ID NOT IN ('100020100004','100010100006') --剔除100020100004-同业客户代销专项额度 100010100006-公司客户代销专项额度
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入授信额度主表-对公-转授信'; --13
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,GROUP_CRDT_FLG                  --36集团授信标志 --ADD BY HULJ 20220208
    ,STD_PROD_ID                     --37标准产品编号
    ,APPL_WAY_CD                     --38申请方式代码
    ,APPROVE_SERIAL_FLOW_NUM         --39被动转授信集团批复流水号
    ,APV_FLOW_NUM                    --40批复流水号
    ,LMT_UNDER_SELLBL_PROD_ID        --41可售产品
    ,APV_AMT                         --42批复金额
    ,CRDT_CONT_ID_KHFX               --43授信合同编号-客户风险  --ADD BY YJY 20240722
    ,STATUS_CD                       --44状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --45授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --46是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --47EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --48一表通年口径标识 --ADD BY YJY 20251127
    )
  SELECT  /*+USE_HASH(A,B,C,D,E,F,TA)*/
          V_P_DATE                                           AS DATA_DT                     --01数据日期
         ,B.LP_ID                                            AS LGL_REP_ID                  --02法人编号
         ,NULL                                               AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.CONT_ID                                          AS CRDT_CONT_ID                --04授信合同编号
         --,A.LMT_CONT_ID                                      AS CRDT_CONT_ID                --04授信合同编号 --MODIFY BY 20250421
         --1104转授信取业务合同为授信合同，授信金额取业务合同金额。 MOD BY LIUYU 20230314
         ,NVL(TRIM(B.MANU_CONT_ID),A.CONT_ID)                AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                          AS CUST_ID                     --06客户编号
         ,A.ORG_ID                                           AS ORG_ID                      --07机构编号
         /*,B.CONT_AMT                                         AS CRDT_LMT                    --08授信额度
         --MOD BY YJY 20250619 当放款金额大于合同金额时，取放款金额
         ,CASE WHEN NVL(A.LOAN_AMT,0) > NVL(B.CONT_AMT,0) THEN NVL(A.LOAN_AMT,0)
               ELSE NVL(B.CONT_AMT,0)
           END                                               AS ALDY_USE_LMT                --09已用额度 */
         ,CASE WHEN A.LOAN_BAL <> 0 THEN B.CONT_AMT 
               ELSE 0
           END                                               AS CRDT_LMT                    --08授信额度 --MOD BY YJY  20251127
         ,CASE WHEN A.LOAN_BAL <> 0 
               THEN CASE WHEN NVL(A.LOAN_AMT,0) > NVL(B.CONT_AMT,0) THEN NVL(A.LOAN_AMT,0)
                         ELSE NVL(B.CONT_AMT,0) END
               ELSE 0
           END                                               AS ALDY_USE_LMT                --09已用额度 --MOD BY YJY  20251127
         ,0                                                  AS SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                               AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                               AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                               AS EXP_SUR_LMT                 --13敞口剩余额度
         ,B.CURR_CD                                          AS CUR                         --14币种
         /*,CASE WHEN C.CRDT_CUST_TYPE_CD = '3' THEN '05' --同业客户
               WHEN C.CRDT_CUST_TYPE_CD = '5' THEN '02' --集团客户
               WHEN C.CRDT_CUST_TYPE_CD = '2' OR C.CUST_TYPE_CD LIKE '2%' THEN '01' --对公客户
               ELSE '99' --其他
           END                                               AS CRDT_SUBJ_TYP               --15授信主体类型 mod by hulj 20230818*/
         ,CASE WHEN C.CRDT_CUST_TYPE_CD = '3' OR C.CUST_TYPE_CD = '3' THEN '05' --同业客户 --MOD BY LIP 20260105
               WHEN C.CRDT_CUST_TYPE_CD = '5' THEN '02' --集团客户
               WHEN C.CRDT_CUST_TYPE_CD = '2' OR C.CUST_TYPE_CD LIKE '2%' THEN '01' --对公客户
               ELSE '99' --其他
           END                                               AS CRDT_SUBJ_TYP               --15授信主体类型 --MOD BY LIP 20260105
         ,CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(B.DISTR_DT,'YYYYMMDD')
           END                                               AS EFF_DT                      --16生效日期
         --,'Y'
         ,CASE WHEN A.LOAN_BAL <> 0 THEN 'Y'--业务仍有余额的 MOD BY YJY 20251127
               ELSE 'N'
           END                                               AS CRDT_STAT                   --17授信状态 Z0002
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END)  --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                             AS CRDT_APP_DT                 --18授信申请日期
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END) --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                             AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(B.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(B.EXP_DT,'YYYYMMDD')
           END                                               AS CRDT_EXP_DT                 --20授信到期日期
         ,B.STD_PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型
         --由于行内额度管理无法区分授信业务类型该字段取额度合同标准产品号
         ,'N'                                                AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                               AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN B.STD_PROD_ID IN ('100010100001','100020100001') THEN '01'--综合
               WHEN B.STD_PROD_ID IN ('100010100003') THEN '02'--低风险
               WHEN B.STD_PROD_ID IN ('100010100002','100020100002') THEN '05' --专项
               WHEN B.STD_PROD_ID IN ('100010100004') THEN '9902' --其他-交易类限额额度 --MOD BY LIP 20250814
               WHEN NVL(B.OPEN_BAL,0) = 0 OR B.CONT_TYPE_CD IN ('03') THEN '02'
               ELSE '9901' --其他-敞口授信
           END                                               AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,NULL                                               AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,'同意'                                             AS DSN_SHT_OPN                 --26决策单意见
         ,F.FINAL_APVER_ID                                   AS APRV_PSN_NO                 --27审批人工号
         ,CASE WHEN B.MGMT_TELLER_ID = 'system' AND B.CONT_ID LIKE 'UPL%' THEN '03000063'
               ELSE B.MGMT_TELLER_ID
           END                                               AS CRDT_EMP_NO                 --28授信员工号
         ,'800919'                                           AS DEPT_LINE                   --29部门条线 /*风险管理部*/
         ,'转授信'                                           AS DATA_SRC                    --30数据来源
         ,B.BUS_BREED_ID                                     AS BUS_BREED_ID                --31业务品种编号  --ADD BY LIP 20220728
         ,'DG对公表内转授信'                                 AS DATA_SRC_DESC               --32数据来源描述  --ADD BY LIP 20220728
         ,G.LMT_KIND_CD                                      AS LMT_KIND_CD                 --33额度种类代码
         ,B.LOAN_HAPP_TYPE_CD                                AS LOAN_HAPP_TYPE_CD           --34发生类型
         ,B.RELA_CONT_ID                                     AS RELA_CONT_ID                --35原合同编号
         ,NULL                                               AS GROUP_CRDT_FLG              --36集团授信标志
         ,B.STD_PROD_ID                                      AS STD_PROD_ID                 --37标准产品编号
         ,E.APPL_WAY_CD                                      AS APPL_WAY_CD                 --38申请方式代码
         ,K.APPROVE_SERIAL_FLOW_NUM                          AS APPROVE_SERIAL_FLOW_NUM     --39被动转授信集团批复流水号
         ,B.APV_FLOW_NUM                                     AS APV_FLOW_NUM                --40批复流水号
         ,E.LMT_UNDER_SELLBL_PROD_ID                         AS LMT_UNDER_SELLBL_PROD_ID    --41可售产品
         ,F.CRDT_APV_AMT                                     AS APV_AMT                     --42批复金额
         ,A.LMT_CONT_ID                                      AS CRDT_CONT_ID_KHFX           --43授信合同编号-客户风险  --ADD BY YJY 20240722
         ,B.VALID_FLG_CD                                     AS STATUS_CD                   --44状态代码 --ADD BY LIP 20241025
         ,CASE WHEN TO_CHAR(F.APVED_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(F.APVED_DT,'YYYYMMDD')
           END                                               AS CRDT_APVED_DT               --45授信审批日期  --ADD BY YJY 20250114
         --ADD BY YJY 20250220 系统内转贴现直贴客户不为空，1104需特殊处理该场景
         ,CASE WHEN A.DATA_SRC = '买断式转贴现部分' AND A.CUST_ID_ZT IS NOT NULL THEN 'N'
               ELSE 'Z'
           END                                                AS CUST_ID_ZT_FLG             --46是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE WHEN (NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0) <> 0 --余额未结清
                 OR (A.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')  
                     AND TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))  --当月转让  
                 OR (A.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                     AND TO_CHAR(A.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --当月核销                     
                 OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                     AND TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))) --当月结清                         
               THEN 'Y'  
               ELSE 'N'         
           END                                                AS EAST_MON_FLG             --EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN (NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0) <> 0 --余额未结清
                 OR (A.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')  
                     AND TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))  --本年转让
                 OR (A.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(A.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --本年核销                     
                 OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')      
                     AND TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))) --本年结清                           
               THEN 'Y'  
               ELSE 'N'         
           END                                                AS YBT_YEAR_FLG             --一表通年口径标识 --ADD BY YJY 20251127     
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 A
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
      ON C.CUST_ID = /*B.CUST_ID*/ A.CUST_ID --MOD BY YJY 20251209 一表通
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息
      ON D.CONT_ID = A.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO F --对公授信额度合同审批信息
      ON F.CRDT_LMT_APV_FLOW_NUM = D.APV_FLOW_NUM
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO G --对公贷款额度合同补充信息
      ON G.CONT_ID  = A.CONT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO E --对公贷款申请信息
      ON E.LOAN_APPL_FLOW_NUM = F.RELA_CRDT_LMT_APV_FLOW_NUM
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_PASCT_TURN_CRDT_INFO_H K
      ON K.OBJ_ID = E.LOAN_APPL_FLOW_NUM
     AND UPPER(K.OBJ_TYPE_NAME) = UPPER('CreditApply')
     AND K.ID_MARK <> 'D'
     AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE /*A.LOAN_BAL <> 0 --业务仍有余额的
     AND */ A.DATA_SRC_DESC NOT IN ('零售') --MOD BY YJY 20251127 扩大取数范围
     AND A.CUST_ID <> A.LMT_CUST_ID; --业务客户号和授信客户号不一致的表内部分（表外部分授信客户号赋空值）

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY YJY 20250220 由于1104、金数报送需求，需要针对系统内转贴现的客户取其直贴客户进行逻辑加工，其他报送如无要求仍取对公-转授信逻辑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入授信额度主表-对公-系统内转贴现转授信'; --14
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,GROUP_CRDT_FLG                  --36集团授信标志 --ADD BY HULJ 20220208
    ,STD_PROD_ID                     --37标准产品编号
    ,APPL_WAY_CD                     --38申请方式代码
    ,APPROVE_SERIAL_FLOW_NUM         --39被动转授信集团批复流水号
    ,APV_FLOW_NUM                    --40批复流水号
    ,LMT_UNDER_SELLBL_PROD_ID        --41可售产品
    ,APV_AMT                         --42批复金额
    ,CRDT_CONT_ID_KHFX               --43授信合同编号-客户风险  --ADD BY YJY 20240722
    ,STATUS_CD                       --44状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --45授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --46是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --47EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --48一表通年口径标识 --ADD BY YJY 20251127
    )
  SELECT  /*+USE_HASH(A,B,C,D,E,F,TA)*/
          V_P_DATE                                           AS DATA_DT                     --01数据日期
         ,B.LP_ID                                            AS LGL_REP_ID                  --02法人编号
         ,NULL                                               AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.LMT_CONT_ID                                      AS CRDT_CONT_ID                --04授信合同编号 --MODIFY BY 20250421
         ,NVL(TRIM(B.MANU_CONT_ID),A.CONT_ID)                AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID_ZT                                       AS CUST_ID                     --06客户编号 --MO DBY YJY 20250220 取直贴客户号
         ,A.ORG_ID                                           AS ORG_ID                      --07机构编号
         /*,B.CONT_AMT                                         AS CRDT_LMT                    --08授信额度
         --MOD BY YJY 20250619 当放款金额大于合同金额时，取放款金额
         ,CASE WHEN NVL(A.LOAN_AMT,0) > NVL(B.CONT_AMT,0) THEN NVL(A.LOAN_AMT,0)
               ELSE NVL(B.CONT_AMT,0)
           END                                               AS ALDY_USE_LMT                --09已用额度 */
         ,CASE WHEN A.LOAN_BAL <> 0 THEN B.CONT_AMT 
               ELSE 0
           END                                               AS CRDT_LMT                    --08授信额度 --MOD BY YJY  20251127
         ,CASE WHEN A.LOAN_BAL <> 0 
               THEN CASE WHEN NVL(A.LOAN_AMT,0) > NVL(B.CONT_AMT,0) THEN NVL(A.LOAN_AMT,0)
                         ELSE NVL(B.CONT_AMT,0) END
               ELSE 0
           END                                               AS ALDY_USE_LMT                --09已用额度 --MOD BY YJY  20251127
         ,0                                                  AS SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                               AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                               AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                               AS EXP_SUR_LMT                 --13敞口剩余额度
         ,B.CURR_CD                                          AS CUR                         --14币种
         /*,CASE WHEN C.CRDT_CUST_TYPE_CD = '3' THEN '05' --同业客户
               WHEN C.CRDT_CUST_TYPE_CD = '5' THEN '02' --集团客户
               WHEN C.CRDT_CUST_TYPE_CD = '2' OR C.CUST_TYPE_CD LIKE '2%' THEN '01' --对公客户
               ELSE '99' --其他
           END                                               AS CRDT_SUBJ_TYP               --15授信主体类型 mod by hulj 20230818*/
         ,CASE WHEN C.CRDT_CUST_TYPE_CD = '3' OR C.CUST_TYPE_CD = '3' THEN '05' --同业客户 --MOD BY LIP 20260105
               WHEN C.CRDT_CUST_TYPE_CD = '5' THEN '02' --集团客户
               WHEN C.CRDT_CUST_TYPE_CD = '2' OR C.CUST_TYPE_CD LIKE '2%' THEN '01' --对公客户
               ELSE '99' --其他
           END                                               AS CRDT_SUBJ_TYP               --15授信主体类型 --MOD BY LIP 20260105
         ,CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(B.DISTR_DT,'YYYYMMDD')
           END                                               AS EFF_DT                      --16生效日期
          --,'Y'
         ,CASE WHEN A.LOAN_BAL <> 0 THEN 'Y'--业务仍有余额的 MOD BY YJY 20251127
               ELSE 'N'
           END                                              AS CRDT_STAT                   --17授信状态 Z0002
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END) --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                             AS CRDT_APP_DT                 --18授信申请日期
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END) --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                             AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(B.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(B.EXP_DT,'YYYYMMDD')
           END                                               AS CRDT_EXP_DT                 --20授信到期日期
         ,B.STD_PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型
         --由于行内额度管理无法区分授信业务类型该字段取额度合同标准产品号
         ,'N'                                                AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                               AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN B.STD_PROD_ID IN ('100010100001','100020100001') THEN '01' --综合
               WHEN B.STD_PROD_ID IN ('100010100003') THEN '02' --低风险
               WHEN B.STD_PROD_ID IN ('100010100002','100020100002') THEN '05' --专项
               WHEN NVL(B.OPEN_BAL,0) = 0 OR B.CONT_TYPE_CD IN ('03') THEN '02'
               ELSE '9901' --其他-敞口授信
           END                                               AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,NULL                                               AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,'同意'                                             AS DSN_SHT_OPN                 --26决策单意见
         ,F.FINAL_APVER_ID                                   AS APRV_PSN_NO                 --27审批人工号
         ,CASE WHEN B.MGMT_TELLER_ID = 'system' AND B.CONT_ID LIKE 'UPL%' THEN '03000063'
               ELSE B.MGMT_TELLER_ID
           END                                               AS CRDT_EMP_NO                 --28授信员工号
         ,'800919'                                           AS DEPT_LINE                   --29部门条线 /*风险管理部*/
         ,'转授信'                                           AS DATA_SRC                    --30数据来源
         ,B.BUS_BREED_ID                                     AS BUS_BREED_ID                --31业务品种编号  --ADD BY LIP 20220728
         ,'DG对公系统内转贴现转授信'                         AS DATA_SRC_DESC               --32数据来源描述  --ADD BY LIP 20220728
         ,G.LMT_KIND_CD                                      AS LMT_KIND_CD                 --33额度种类代码
         ,B.LOAN_HAPP_TYPE_CD                                AS LOAN_HAPP_TYPE_CD           --34发生类型
         ,B.RELA_CONT_ID                                     AS RELA_CONT_ID                --35原合同编号
         ,NULL                                               AS GROUP_CRDT_FLG              --36集团授信标志
         ,B.STD_PROD_ID                                      AS STD_PROD_ID                 --37标准产品编号
         ,E.APPL_WAY_CD                                      AS APPL_WAY_CD                 --38申请方式代码
         ,K.APPROVE_SERIAL_FLOW_NUM                          AS APPROVE_SERIAL_FLOW_NUM     --39被动转授信集团批复流水号
         ,B.APV_FLOW_NUM                                     AS APV_FLOW_NUM                --40批复流水号
         ,E.LMT_UNDER_SELLBL_PROD_ID                         AS LMT_UNDER_SELLBL_PROD_ID    --41可售产品
         ,F.CRDT_APV_AMT                                     AS APV_AMT                     --42批复金额
         ,A.LMT_CONT_ID                                      AS CRDT_CONT_ID_KHFX           --43授信合同编号-客户风险  --ADD BY YJY 20240722
         ,B.VALID_FLG_CD                                     AS STATUS_CD                   --44状态代码 --ADD BY LIP 20241025
         ,CASE WHEN TO_CHAR(F.APVED_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(F.APVED_DT,'YYYYMMDD')
           END                                               AS CRDT_APVED_DT               --45授信审批日期  --ADD BY YJY 20250114
         --ADD BY YJY 20250220 判断买断式转贴现部分中交易对手编号和系统内转贴现客户号是否一致
         ,'Y'                                                AS CUST_ID_ZT_FLG             --46是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE WHEN (NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0) <> 0 --余额未结清
                 OR (A.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')  
                     AND TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))  --当月转让  
                 OR (A.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                     AND TO_CHAR(A.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --当月核销                     
                 OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')      
                     AND TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))) --当月结清                         
               THEN 'Y'  
               ELSE 'N'         
           END                                                AS EAST_MON_FLG             --EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN (NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0) <> 0 --余额未结清
                 OR (A.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')  
                     AND TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))  --本年转让
                 OR (A.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(A.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --本年核销                     
                 OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')      
                     AND TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))) --本年结清                           
               THEN 'Y'  
               ELSE 'N'         
           END                                                AS YBT_YEAR_FLG             --一表通年口径标识 --ADD BY YJY 20251127     
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 A
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
      ON C.CUST_ID = /*B.CUST_ID*/ A.CUST_ID_ZT --MOD BY YJY 20251209 一表通
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息
      ON D.CONT_ID = A.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO F --对公授信额度合同审批信息
      ON F.CRDT_LMT_APV_FLOW_NUM = D.APV_FLOW_NUM
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO G --对公贷款额度合同补充信息
      ON G.CONT_ID  = A.CONT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO E --对公贷款申请信息
      ON E.LOAN_APPL_FLOW_NUM = F.RELA_CRDT_LMT_APV_FLOW_NUM
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_PASCT_TURN_CRDT_INFO_H K
      ON K.OBJ_ID = E.LOAN_APPL_FLOW_NUM
     AND UPPER(K.OBJ_TYPE_NAME) = UPPER('CreditApply')
     AND K.ID_MARK <> 'D'
     AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE /*A.LOAN_BAL <> 0 --业务仍有余额的
     AND*/ A.DATA_SRC_DESC NOT IN ('零售') --MOD BY YJY 20251127 扩大取数范围
     AND A.CUST_ID_ZT <> A.LMT_CUST_ID --直贴客户号和授信客户号不一致的系统内转贴现部分 MOD BY YJY 20250311
     AND A.CUST_ID_ZT IS NOT NULL;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '零售逻辑-综合授信'; --14
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,STD_PROD_ID                     --36标准产品编号
    ,STATUS_CD                       --37状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --38授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --39是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --40EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --41一表通年口径标识 --ADD BY YJY 20251127
    )
    WITH LMT_INTO_TEMP06 AS (
  SELECT /*+MATERIALIZE*/
         T6.LMT_CONT_ID  --额度合同
        ,SUM(NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0)) AS USE_LMT  --MODIFY BY TANGAN AT 20230129
        /*,MIN(CASE WHEN TO_CHAR(T6.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.ASSET_TRAN_DT)
                  WHEN TO_CHAR(T6.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.FIR_WRT_OFF_DT)
                  WHEN TO_CHAR(T6.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.PAYOFF_DT)
                  ELSE TO_DATE('99991231','YYYYMMDD')
              END) AS ACT_END_DT --实际终止日期 --MOD BY YJY 20251128*/
         --MOD BY LIP 20251202 取最晚结清的借据终结日期
         ,MAX(CASE WHEN TO_CHAR(T6.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.ASSET_TRAN_DT)
                   WHEN TO_CHAR(T6.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.FIR_WRT_OFF_DT)
                   WHEN TO_CHAR(T6.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.PAYOFF_DT)
                   ELSE TO_DATE('99991231','YYYYMMDD')
               END) AS ACT_END_DT --实际终止日期
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 T6
    --WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0 --MOD BY YJY 20251127 扩大取数范围
   GROUP BY T6.LMT_CONT_ID),
  CONT_SXRQ AS ( --ADD BY LIP 20260310 取合同的终止日期，判断授信是否仍需要报送，影响一表通的表间校验
  SELECT /*+MATERIALIZE*/TRIM(T1.LMT_CONT_ID) AS LMT_CONT_ID,
         MAX(CASE WHEN TO_CHAR(T1.TERMNT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231') THEN TO_DATE('99991231','YYYYMMDD')
                  WHEN T1.PROD_ID IN ('201020100057') THEN T1.TERMNT_DT+1 --房抵贷的是T+2
                  ELSE T1.TERMNT_DT
              END) AS TERMNT_DT
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T1
   WHERE TRIM(T1.LMT_CONT_ID) IS NOT NULL
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T1.LMT_CONT_ID)
  SELECT  /*+USE_HASH(A B M C D)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,T1.LP_ID                                        AS LGL_REP_ID                  --02法人编号
         ,''                                              AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,T1.LMT_CONT_ID                                  AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(T1.LMT_CONT_CN_NAME),T1.LMT_CONT_ID)   AS CRDT_CONT_NM                --05授信合同名称
         ,T1.CUST_ID                                      AS CUST_ID                     --06客户编号
         ,NVL(T1.ACCT_INSTIT_ID,T1.BELONG_ORG_ID)         AS ORG_ID                      --07机构编号
         ,T1.CRDT_LMT                                     AS CRDT_LMT                    --08授信额度
         --已用额度字段待源系统改造完成后使用T1.OCCU_CRDT_LMT,现阶段使用余额兜底
         ,NVL(T4.USE_LMT,0)                               AS ALDY_USE_LMT                --09已用额度 --MODIFY BY TANGAN AT 20230129
         ,NVL(T1.CRDT_LMT,0) - NVL(T1.OCCU_CRDT_LMT,0)    AS SUR_CRDT_LMT                --10剩余授信额度
         ,T1.CRDT_OPEN_AMT                                AS EXP_CRDT_LMT                --11敞口授信额度
         ,''                                              AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,''                                              AS EXP_SUR_LMT                 --13敞口剩余额度
         ,T1.CURR_CD                                      AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         ,CASE WHEN T1.PROD_ID IN ('602030100002') THEN 'N' --剔除委托贷款
               WHEN /*T4.LMT_CONT_ID IS NOT NULL*/ T4.USE_LMT <> 0 THEN 'Y' --额度项下有余额的置为有效 --MOD BY YJY 20251127
               WHEN T1.LOAN_HAPP_TYPE_CD IN ('0102','0202','0204') THEN 'N' --CD04031 贷款发放类型代码
               --零售的 原额度续作/借新还旧/债务重组置为失效，如果项下有借据余额再置为有效
               WHEN T1.STATUS_CD = '2' AND NVL(T1.EXP_DT,TO_DATE('99991231','YYYYMMDD')) >= TO_DATE(V_P_DATE,'YYYYMMDD') --合同有效且未到期
               THEN 'Y'--有效 --CD04022 合同状态代码
               ELSE 'N'
           END                                            AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(T3.RGST_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T3.RGST_DT,'YYYYMMDD')
           END                                            AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD')
           END                                            AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(T1.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.EXP_DT,'YYYYMMDD')
           END                                            AS CRDT_EXP_DT                 --20授信到期日期
         ,T1.PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型 T0007
         ,CASE WHEN T1.CIRCL_FLG = '0' THEN 'N'
               ELSE 'Y'
           END                                            AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN NVL(T1.CRDT_OPEN_AMT,0) > 0 THEN '9901' --其他-敞口授信
               ELSE '02'
           END                                            AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,NULL                                            AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,NVL(SUBSTRB(TE.APV_OPINION,1,2000),'同意')      AS DSN_SHT_OPN                 --26决策单意见  --MODIFY BY TANGAN AT 20230129
         ,T3.OPERR_ID                                     AS APRV_PSN_NO                 --27审批人工号  --MODIFY BY TANGAN AT 20230130
         ,T3.OPERR_ID                                     AS CRDT_EMP_NO                 --28授信员工号  --MODIFY BY TANGAN AT 20230130
         ,'800924'                                        AS DEPT_LINE                   --29部门条线 /*零售信贷部(普惠金融部)*/
         ,'零售'                                          AS DATA_SRC                    --30数据来源
         ,T1.PROD_ID                                      AS BUS_BREED_ID                --31业务品种编号  --ADD BY LIP 20220728
         ,'零售额度合同'                                  AS DATA_SRC_DESC               --32数据来源描述  --ADD BY LIP 20220728
         ,''                                              AS LMT_TYPE_CD                 --33额度种类代码
         /*,''                                              AS LOAN_HAPP_TYPE_CD           --34合同发生类型*/
         ,T1.LOAN_HAPP_TYPE_CD                            AS LOAN_HAPP_TYPE_CD           --34合同发生类型  --MOD BY YJY 20250618 加工零售的贷款发生类型
         ,''                                              AS RELA_CONT_ID                --35原合同编号
         ,T1.PROD_ID                                      AS PROD_ID                     --36标准产品编号
         ,T1.STATUS_CD                                    AS STATUS_CD                   --37状态代码 --ADD BY LIP 20241025
         ,CASE WHEN TO_CHAR(T3.APVED_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T3.APVED_DT,'YYYYMMDD')
           END                                            AS CRDT_APVED_DT               --38授信审批日期 --ADD BY YJY 20250114
         ,'Z'                                             AS CUST_ID_ZT_FLG              --39是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE WHEN NVL(T4.USE_LMT,0) <> 0 --余额未结清
                 OR T4.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --当月终止
               THEN 'Y'
               WHEN NVL(TO_CHAR(T1.BEGIN_DT,'YYYYMMDD'),'29991231') IN ('00010101','20991231','29991231')
               THEN 'N' --MOD BY LIP 20260114 --因校验问题，与张家伟沟通后，将开始日期为空的无效数据过滤掉
               /*WHEN NVL(TRIM(T1.STATUS_CD),'2') NOT IN ('1','9') --1未生效9其他状态
                    AND (T1.EXP_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                         OR TO_CHAR(T1.EXP_DT,'YYYYMMDD') IN ('00010101','20991231','29991231'))
               THEN 'Y'*/
               WHEN NVL(TRIM(T1.STATUS_CD),'2') IN ('1','9') --1未生效9其他状态
               THEN 'N'
               WHEN T5.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
               THEN 'Y' --ADD BY LIP 20260310 如果合同的到期日是当月的，也默认为要报送
               WHEN T1.EXP_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
               THEN 'N' --ADD BY LIP 20260310 部分授信合同对应的业务合同都到期了，且超过了到期日，但是终止日期没有赋值
               WHEN NVL(TRIM(T1.STATUS_CD),'2') NOT IN ('1','9') --1未生效9其他状态
                    AND (T1.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                         OR TO_CHAR(T1.TERMNT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231'))
               THEN 'Y'
               ELSE 'N'
           END                                            AS EAST_MON_FLG             --40EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN NVL(T4.USE_LMT,0) <> 0 --余额未结清
                 OR T4.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')  --当年终止
               THEN 'Y'
               WHEN NVL(TO_CHAR(T1.BEGIN_DT,'YYYYMMDD'),'29991231') IN ('00010101','20991231','29991231')
               THEN 'N' --MOD BY LIP 20260114 --因校验问题，与张家伟沟通后，将开始日期为空的无效数据过滤掉
               /*WHEN NVL(TRIM(T1.STATUS_CD),'2') NOT IN ('1','9') --1未生效9其他状态
                    AND (T1.EXP_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
                         OR TO_CHAR(T1.EXP_DT,'YYYYMMDD') IN ('00010101','20991231','29991231'))
               THEN 'Y'*/
               WHEN NVL(TRIM(T1.STATUS_CD),'2') IN ('1','9') --1未生效9其他状态
               THEN 'N'
               WHEN T5.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
               THEN 'Y' --ADD BY LIP 20260310 如果合同的到期日是当年的，也默认为要报送
               WHEN T1.EXP_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
               THEN 'N' --ADD BY LIP 20260310 部分授信合同对应的业务合同都到期了，且超过了到期日，但是终止日期没有赋值
               WHEN NVL(TRIM(T1.STATUS_CD),'2') NOT IN ('1','9') --1未生效9其他状态
                    AND (T1.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
                         OR TO_CHAR(T1.TERMNT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231'))
               THEN 'Y' --MOD BY LIP 20260310 根据授信合同的实际终止日期判断是否需要当年报送
               ELSE 'N'
           END                                            AS YBT_YEAR_FLG             --41一表通年口径标识 --ADD BY YJY 20251127    
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO T1 --零售贷款授信额度信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_CRDT_LMT_APV_INFO T3 --零售授信额度审批信息
      ON T3.CRDT_LMT_APV_FLOW_NUM = T1.LMT_APPL_FLOW_NUM
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN LMT_INTO_TEMP06 T4 --余额大于0的借据
      ON T4.LMT_CONT_ID = T1.LMT_CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO TE --零售贷款申请信息 --MODIFY BY TANGAN AT 20230129
      ON TE.LOAN_APPL_FLOW_NUM = T1.LMT_APPL_FLOW_NUM
     AND TE.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CONT_SXRQ T5 --ADD BY LIP 20260310
      ON T5.LMT_CONT_ID = T1.LMT_CONT_ID
   WHERE T1.PROD_ID NOT IN ('202020200007','201010300005','202010200012')
         --剔除新心金融小微贷 --MODIFY BY YJY 20240417 剔除201010300005-新兴贷 --MOD BY YJY 20250908 剔除360借条202010200012
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '零售逻辑-单笔单批'; --15
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,STD_PROD_ID                     --36标准产品编号
    ,STATUS_CD                       --37状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --38授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --39是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --40EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --41一表通年口径标识 --ADD BY YJY 20251127
    )
  WITH LMT_INTO_TEMP06 AS (
  SELECT /*+MATERIALIZE*/ 
          T6.CONT_ID  --物化视图
         ,SUM (CASE WHEN NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0
                    THEN NVL(T6.LOAN_AMT,0)
                    ELSE 0 
                END )     AS USE_LMT  --已用额度 MOD BY YJY 20251127 
         ,SUM(NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0)) AS ACCT_BAL  --账户净值 ADD BY YJY 20251127
         /*,MIN(CASE WHEN TO_CHAR(T6.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.ASSET_TRAN_DT)
                   WHEN TO_CHAR(T6.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.FIR_WRT_OFF_DT)
                   WHEN TO_CHAR(T6.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.PAYOFF_DT)
                   ELSE TO_DATE('99991231','YYYYMMDD')
               END)      AS ACT_END_DT --实际终止日期   ADD BY YJY 20251127*/
         --MOD BY LIP 20251202 取最晚结清的借据终结日期
         ,MAX(CASE WHEN TO_CHAR(T6.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.ASSET_TRAN_DT)
                   WHEN TO_CHAR(T6.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.FIR_WRT_OFF_DT)
                   WHEN TO_CHAR(T6.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(T6.PAYOFF_DT)
                   ELSE TO_DATE('99991231','YYYYMMDD')
               END) AS ACT_END_DT --实际终止日期
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 T6
   --WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0 --MOD BY YJY 20251127 扩大取数范围
   GROUP BY T6.CONT_ID)
  SELECT  /*+USE_HASH(A B M C D)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,T1.LP_ID                                        AS LGL_REP_ID                  --02法人编号
         ,''                                              AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,T1.CONT_ID                                      AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(T1.CONT_NAME),T1.CONT_ID)              AS CRDT_CONT_NM                --05授信合同名称
         ,T1.CUST_ID                                      AS CUST_ID                     --06客户编号
         ,COALESCE(T1.ACCT_INSTIT_ID,T1.RGST_ORG_ID,T1.MGMT_ORG_ID) AS ORG_ID            --07机构编号
         ,T1.CONT_AMT                                     AS CRDT_LMT                    --08授信额度
         ,NVL(T2.USE_LMT,0)                               AS ALDY_USE_LMT                --09已用额度 --MODIFY BY TANGAN AT 20230129
         ,''                                              AS SUR_CRDT_LMT                --10剩余授信额度
         ,''                                              AS EXP_CRDT_LMT                --11敞口授信额度
         ,''                                              AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,''                                              AS EXP_SUR_LMT                 --13敞口剩余额度
         ,T1.CURR_CD                                      AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(T1.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.START_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         ,CASE WHEN T1.PROD_ID IN ('602030100002') THEN 'N' --不含委托贷款
               WHEN /*T2.CONT_ID IS NOT NULL */ T2.ACCT_BAL <> 0 THEN 'Y' --有余额的置为有效 --MOD BY YJY 20251127
               WHEN T1.LOAN_HAPP_TYPE_CD IN ('0102','0202','0204') THEN 'N' --CD04031 贷款发放类型代码
               --零售的 原额度续作/借新还旧/债务重组置为失效，如果项下有借据余额再置为有效
               WHEN T1.CONT_STATUS_CD = '2' AND NVL(T1.EXP_DT,TO_DATE('99991231','YYYYMMDD')) >= TO_DATE(V_P_DATE,'YYYYMMDD') --合同有效且未到期
               THEN 'Y' --有效 --CD04022 合同状态代码
               ELSE 'N'
           END                                            AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(T1.APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.APPL_DT,'YYYYMMDD')
           END                                            AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(T1.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.START_DT,'YYYYMMDD')
           END                                            AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(T1.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.EXP_DT,'YYYYMMDD')
               WHEN TO_CHAR(T3.B_RENEW_EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231') --MOD BY LIP 20250402
               THEN TO_CHAR(T3.B_RENEW_EXP_DT,'YYYYMMDD')
           END                                            AS CRDT_EXP_DT                 --20授信到期日期
         ,T1.PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型 T0007
         ,CASE WHEN T1.CONT_TYPE_CD = '04' THEN 'Y'
               ELSE 'N'
           END                                            AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN T1.PROD_ID IN ('201020100032','201020100033','201020100034','201020100035','202020200008','201020100036'
                                  ,'201020100037','202010200005','202020200002','201010300022','201010300023','201010300024'
                                  ,'201010300025','201010300026','202010200002','201010300027','201010300028','201010100002'
                                  ,'201010300012') THEN '9901' --其他-敞口授信  --助贷和微贷 MODIFY BY TANGAN AT 20230129
               ELSE '02'
           END                                            AS CRDT_SUBJ_CL                --授信主体种类 T0029 --MODIFY BY TANGAN AT 20230129
         ,NULL                                            AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,NVL(SUBSTRB(TE.APV_OPINION,1,2000),'同意')      AS DSN_SHT_OPN                 --26决策单意见 --MODIFY BY TANGAN AT 20230129
         ,T1.CUST_MGR_ID                                  AS APRV_PSN_NO                 --27审批人工号 --MODIFY BY TANGAN AT 20230130
         ,T1.CUST_MGR_ID                                  AS CRDT_EMP_NO                 --28授信员工号 --MODIFY BY TANGAN AT 20230130
         ,'800924'                                        AS DEPT_LINE                   --29部门条线 /*零售信贷部(普惠金融部)*/
         ,'零售'                                          AS DATA_SRC                    --30数据来源
         ,T1.PROD_ID                                      AS BUS_BREED_ID                --31业务品种编号 --ADD BY LIP 20220728
         ,'零售单笔单批'                                  AS DATA_SRC_DESC               --32数据来源描述 --ADD BY LIP 20220728
         ,''                                              AS LMT_TYPE_CD                 --33额度种类代码
         /*,''                                              AS LOAN_HAPP_TYPE_CD           --34合同发生类型*/
         ,T1.LOAN_HAPP_TYPE_CD                            AS LOAN_HAPP_TYPE_CD           --34合同发生类型 --MOD BY YJY 20250618 JIAGONG 加工贷款合同发生类型
         ,''                                              AS RELA_CONT_ID                --35原合同编号
         ,T1.PROD_ID                                      AS STD_PROD_ID                 --36标准产品编号
         ,T1.CONT_STATUS_CD                               AS STATUS_CD                   --37状态代码 --ADD BY LIP 20241025
         ,NULL                                            AS CRDT_APVED_DT               --38授信审批日期 --ADD BY YJY 20250114
         ,'Z'                                             AS CUST_ID_ZT_FLG              --39是否系统内转贴现客户标识 --ADD BY YJY 20250220
         ,CASE WHEN NVL(T2.ACCT_BAL,0) <> 0 --余额未结清
                 OR T2.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --当月终止
               THEN 'Y'
               WHEN NVL(TO_CHAR(T1.START_DT,'YYYYMMDD'),'29991231') IN ('00010101','20991231','29991231')
               THEN 'N' --MOD BY LIP 20260114 --因校验问题，与张家伟沟通后，将开始日期为空的无效数据过滤掉
               WHEN T1.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --当月终止
               THEN 'Y'
               ELSE 'N'
           END                                            AS EAST_MON_FLG             --EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN NVL(T2.ACCT_BAL,0) <> 0 --余额未结清
                 OR T2.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') --当年终止
               THEN 'Y'
               WHEN NVL(TO_CHAR(T1.START_DT,'YYYYMMDD'),'29991231') IN ('00010101','20991231','29991231')
               THEN 'N' --MOD BY LIP 20260114 --因校验问题，与张家伟沟通后，将开始日期为空的无效数据过滤掉
               WHEN T1.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') --当月终止
               THEN 'Y'
               ELSE 'N'
           END                                             AS YBT_YEAR_FLG             --一表通年口径标识 --ADD BY YJY 20251127     
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T1 --零售贷款合同信息
    LEFT JOIN LMT_INTO_TEMP06 T2 --有借据余额的合同
      ON T2.CONT_ID = T1.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO TE --零售贷款申请信息 --MODIFY BY TANGAN AT 20230129
      ON TE.LOAN_APPL_FLOW_NUM = T1.APV_FLOW_NUM
     AND TE.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_INFO_H T3 --贷款合同信息历史 --ADD BY LIP 20250402
      ON T3.CONT_ID = T1.CONT_ID
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(T1.LMT_CONT_ID) IS NULL --根据‘关联合同编号’为空区分单笔单批合同
     AND T1.PROD_ID NOT IN ('202020200007','201010300005','202010200012')
      --剔除新心金融小微贷 --MODIFY BY YJY 20240417 剔除201010300005-新兴贷 --MOD BY YJY 20250908 剔除360借条202010200012
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '零售逻辑-新心金融小微贷'; --16
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,STD_PROD_ID                     --36标准产品编号
    ,STATUS_CD                       --37状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --38授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --39是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --40EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --41一表通年口径标识 --ADD BY YJY 20251127
     )
  WITH LOAN_APPL AS (
  SELECT A.*,ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY A.APPL_AMT DESC,A.LOAN_APPL_FLOW_NUM DESC) AS RN --按大的一笔授信申请取数
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO A --零售贷款申请信息      
   WHERE A.PROD_ID = '202020200007'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP_DUBIL AS (
  SELECT A.CUST_ID
        ,SUM(CASE WHEN A.CURRT_BAL > 0 AND A.WRT_OFF_FLG <> '1'--余额大于0
                  THEN A.DUBIL_AMT
                  ELSE 0
              END) AS DUBIL_AMT --MOD BY YJY 20251127
        ,SUM(CASE WHEN A.CURRT_BAL > 0 AND A.WRT_OFF_FLG <> '1'--余额大于0
                  THEN A.CURRT_BAL
                  ELSE 0
              END) AS CURRT_BAL --MOD BY YJY 20251127
        ,MIN(A.DISTR_DT)      AS DISTR_DT
        ,MAX(A.EXP_DT)        AS EXP_DT
        ,MAX(B.CUST_MGR_ID)   AS CUST_MGR_ID  --MODIFY BY TANGAN AT 20230130
        ,MAX(CASE WHEN TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(A.ASSET_TRAN_DT)
                  WHEN TO_CHAR(C.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(C.FIR_WRT_OFF_DT)
                  WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TRUNC(B.PAYOFF_DT)
                  ELSE TO_DATE('99991231','YYYYMMDD')
              END)            AS ACT_END_DT --实际终止日期  ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
      ON A.DUBIL_NUM = B.DUBIL_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY YJY 20251127 关联核销表取核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO C--贷款核销信息
      ON C.DUBIL_ID = B.DUBIL_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.STD_PROD_ID = '202020200007' --新心金融 --MOD BY YJY 20251127 扩大取数范围
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.CUST_ID)
  SELECT  /*+USE_HASH(A B M C D)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,T1.LP_ID                                        AS LGL_REP_ID                  --02法人编号
         ,''                                              AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,T1.LOAN_APPL_FLOW_NUM                           AS CRDT_CONT_ID                --04授信合同编号
         ,T1.LOAN_APPL_FLOW_NUM                           AS CRDT_CONT_NM                --05授信合同名称
         ,T1.CUST_ID                                      AS CUST_ID                     --06客户编号
         ,COALESCE(T1.ACCT_INSTIT_ID,T1.BELONG_ORG_ID,T1.MGMT_ORG_ID) AS ORG_ID          --07机构编号
         ,T1.APPL_AMT                                     AS CRDT_LMT                    --08授信额度
         ,T2.CURRT_BAL                                    AS ALDY_USE_LMT                --09已用额度
         --新心金融已用额度用借据余额
         ,''                                              AS SUR_CRDT_LMT                --10剩余授信额度
         ,''                                              AS EXP_CRDT_LMT                --11敞口授信额度
         ,''                                              AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,''                                              AS EXP_SUR_LMT                 --13敞口剩余额度
         ,'CNY'                                           AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         --,'Y'                                            
         ,CASE WHEN T2.CURRT_BAL <> 0 THEN 'Y' --余额不为零的授信状态为有效
               ELSE 'N'
           END                                             AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(T1.FIRST_TRIAL_APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T1.FIRST_TRIAL_APPL_DT,'YYYYMMDD')
           END                                            AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD')
           END                                            AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(T2.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T2.EXP_DT,'YYYYMMDD')
           END                                            AS CRDT_EXP_DT                 --20授信到期日期
         ,T1.PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型 T0007
         ,'Y'                                             AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,'02'                                            AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,NULL                                            AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,'同意'                                          AS DSN_SHT_OPN                 --26决策单意见
         ,T2.CUST_MGR_ID                                  AS APRV_PSN_NO                 --27审批人工号
         ,T2.CUST_MGR_ID                                  AS CRDT_EMP_NO                 --28授信员工号 --MODIFY BY TANGAN AT 20230130
         ,'800924'                                        AS DEPT_LINE                   --29部门条线/*零售信贷部(普惠金融部)*/ --MODIFY BY TANGAN AT 20230130
         ,'零售'                                          AS DATA_SRC                    --30数据来源
         ,T1.PROD_ID                                      AS BUS_BREED_ID                --31业务品种编号 --ADD BY LIP 20220728
         ,'零售新心金融'                                  AS DATA_SRC_DESC               --32数据来源描述 --ADD BY LIP 20220728
         ,''                                              AS LMT_TYPE_CD                 --33额度种类代码
         /*,''                                              AS LOAN_HAPP_TYPE_CD           --34合同发生类型*/
         ,T3.LOAN_HAPP_TYPE_CD                            AS LOAN_HAPP_TYPE_CD           --34合同发生类型 --MOD BY YJY 20250618 加工贷款合同发生类型
         ,''                                              AS RELA_CONT_ID                --35原合同编号
         ,T1.PROD_ID                                      AS STD_PROD_ID                 --36标准产品编号
         ,T3.STATUS_CD                                    AS STATUS_CD                   --37状态代码 --ADD BY LIP 20241025
         ,CASE WHEN TO_CHAR(T4.APVED_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(T4.APVED_DT,'YYYYMMDD')
           END                                            AS CRDT_APVED_DT               --38授信审批日期 --ADD BY YJY 20250114
         ,'Z'                                             AS CUST_ID_ZT_FLG              --39是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE WHEN NVL(T2.CURRT_BAL,0) <> 0 --余额未结清
                 OR T2.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --当月终止
               THEN 'Y'
               ELSE 'N'
           END                                            AS EAST_MON_FLG             --EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN NVL(T2.CURRT_BAL,0) <> 0 --余额未结清
                 OR T2.ACT_END_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')  --当年终止
               THEN 'Y'
               ELSE 'N'
           END                                             AS YBT_YEAR_FLG             --一表通年口径标识 --ADD BY YJY 20251127    
    FROM LOAN_APPL T1 --零售贷款申请信息
   INNER JOIN TMP_DUBIL T2
      ON T2.CUST_ID = T1.CUST_ID --取客户项下申请金额最大的一个申请为授信额度
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO T3 --零售贷款授信额度信息 ADD BY LIP 20241025
      ON T3.LMT_CONT_ID = T1.LOAN_APPL_FLOW_NUM
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_CRDT_LMT_APV_INFO T4 --零售授信额度审批信息 ADD BY YJY 20250114
      ON T4.CRDT_LMT_APV_FLOW_NUM = T3.LMT_APPL_FLOW_NUM
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.RN = 1
     AND T1.PROD_ID = '202020200007'
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --零售新兴贷，调整为单笔单批 ADD BY YJY 20240417
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '零售新兴贷-单笔单批'; --17
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,STD_PROD_ID                     --36标准产品编号
    ,CRDT_APVED_DT                   --37授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --38是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --39EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --40一表通年口径标识 --ADD BY YJY 20251127
    )
  SELECT  V_P_DATE                               AS DATA_DT                      --01数据日期
         ,A.LP_ID                                AS LGL_REP_ID                   --02法人编号
         ,NULL                                   AS PRIM_CRDT_CONT_ID            --03主授信合同编号
         ,A.DUBIL_NUM                            AS CRDT_CONT_ID                 --04授信合同编号
         ,A.DUBIL_NUM                            AS CRDT_CONT_NM                 --05授信合同名称
         ,A.CUST_ID                              AS CUST_ID                      --06客户编号
         ,A.ACCT_INSTIT_ID                       AS ORG_ID                       --07机构编号
         /*,A.DUBIL_AMT                            AS CRDT_LMT                     --08授信额度
         ,A.DUBIL_AMT                            AS ALDY_USE_LMT                 --09已用额度*/
         --MOD BY YJY 20251127
         ,CASE WHEN A.CURRT_BAL > 0 AND A.WRT_OFF_FLG <> '1'--余额大于0
               THEN A.DUBIL_AMT
               ELSE 0
           END                                   AS CRDT_LMT                     --08授信额度
         ,CASE WHEN A.CURRT_BAL > 0 AND A.WRT_OFF_FLG <> '1'--余额大于0
               THEN A.DUBIL_AMT      
               ELSE 0
           END                                   AS ALDY_USE_LMT                 --09已用额度
         ,NULL                                   AS SUR_CRDT_LMT                 --10剩余授信额度
         ,NULL                                   AS EXP_CRDT_LMT                 --11敞口授信额度
         ,NULL                                   AS EXP_ALDY_USE_LMT             --12敞口已用额度
         ,NULL                                   AS EXP_SUR_LMT                  --13敞口剩余额度
         ,A.CURR_CD                              AS CUR                          --14币种
         ,'04'                                   AS CRDT_SUBJ_TYP                --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
           END                                   AS EFF_DT                       --16生效日期
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                    AND A.WRT_OFF_FLG <> '1'
          AND A.CURRT_BAL > 0 --ADD BY YJY 20251127
               THEN 'Y'
               ELSE 'N'
           END                                   AS CRDT_STAT                    --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
           END                                   AS CRDT_APP_DT                  --18授信申请日期
         ,CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
           END                                   AS CRDT_START_DT                --19授信开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                   AS CRDT_EXP_DT                 --20授信到期日期
         ,A.STD_PROD_ID                          AS CRDT_BIZ_TYP                --21授信业务类型
         ,'N'                                    AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                   AS TEMP_LMT_FLG                --23临时额度标志
         ,'02'                                   AS CRDT_SUBJ_CL                --24授信主体种类
         ,NULL                                   AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,B.CUST_MGR_ID                          AS APRV_PSN_NO                 --27审批人工号
         ,B.CUST_MGR_ID                          AS CRDT_EMP_NO                 --28授信员工号
         ,'800924'                               AS DEPT_LINE                   --29部门条线 /*零售信贷部(普惠金融部)*/
         ,'零售'                                 AS DATA_SRC                    --30数据来源
         , A.STD_PROD_ID                         AS BUS_BREED_ID                --31业务品种编号
         ,'零售单笔单批-新兴贷'                  AS DATA_SRC_DESC               --32数据来源描述
         ,''                                     AS LMT_TYPE_CD                 --33额度种类代码
         ,''                                     AS LOAN_HAPP_TYPE_CD           --34合同发生类型
         ,''                                     AS RELA_CONT_ID                --35原合同编号
         ,A.STD_PROD_ID                          AS STD_PROD_ID                 --36标准产品编号
         ,NULL                                   AS CRDT_APVED_DT               --37授信审批日期  --ADD BY YJY 20250114
         ,'Z'                                    AS CUST_ID_ZT_FLG              --38是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE WHEN ((A.CURRT_BAL > 0 AND A.WRT_OFF_FLG <> '1') --余额未结清
                 OR (A.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                     AND TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))  --当月转让  
                 OR (C.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                     AND TO_CHAR(C.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --当月核销
                 OR (B.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                     AND TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))) --当月结清         
               THEN 'Y'  
               ELSE 'N'         
           END                                    AS EAST_MON_FLG             --39EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN ((A.CURRT_BAL > 0 AND A.WRT_OFF_FLG <> '1') --余额未结清
                 OR (A.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))  --本年转让
                 OR (C.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(C.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --本年核销         
                 OR (B.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')))  --本年结清     
               THEN 'Y'  
               ELSE 'N'         
          END                                     AS YBT_YEAR_FLG             --40一表通年口径标识 --ADD BY YJY 20251127    
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
      ON A.DUBIL_NUM = B.DUBIL_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   --ADD BY YJY 20251127 关联核销表取核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO C--贷款核销信息
      ON C.DUBIL_ID = B.DUBIL_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.STD_PROD_ID IN ('201010300005') --个人消费信用贷（新兴贷2.0） --MOD BY YJY 20251127 扩大取数范围
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --零售360借条，同一个客户只有一笔有效的授信和批复，会有多笔业务合同和出账，除了额度项下的都算单笔单批 ADD BY YJY 20250908
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '零售逻辑-360借条'; --18
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
    ,STD_PROD_ID                     --36标准产品编号
    ,STATUS_CD                       --37状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --38授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --39是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --40EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --41一表通年口径标识 --ADD BY YJY 20251127
     )
 WITH TMP_CRDT_LMT AS (
  SELECT T1.CUST_ID                     --客户号
        ,T1.RELA_CRDT_LMT_APV_FLOW_NUM  --关联授信额度审批流水号
        ,T2.APPL_AMT                    --申请金额
        ,T1.APVED_DT                    --审批通过日期
        ,T1.CRDT_LMT_BEGIN_DT           --授信额度起始日期
        ,T1.CRDT_LMT_EXP_DT             --授信额度到期日期
        ,T1.HAPP_TYPE_CD                --发生类型代码
        ,T2.FIRST_TRIAL_APPL_DT         --初审申请日期
        ,T1.CRDT_LMT_APV_OPINION        --授信额度审批意见
        ,T1.FINAL_APVER_ID              --最终审批人编号
    FROM RRP_MDL.O_ICL_CMM_RETL_CRDT_LMT_APV_INFO T1 --零售授信额度审批信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO T2 --零售贷款申请信息
      ON T2.LOAN_APPL_FLOW_NUM = T1.RELA_CRDT_LMT_APV_FLOW_NUM --关联授信额度审批流水号
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.STD_PROD_ID = '202010200012' 
     AND T1.CRDT_LMT_EFFECT_FLG = '01' --授信额度生效标志：01有效
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(T1 T2 T3 T4)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,T1.LP_ID                                        AS LGL_REP_ID                  --02法人编号
         ,''                                              AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,NVL(T4.RELA_CRDT_LMT_APV_FLOW_NUM,T1.DUBIL_ID)  AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(T4.RELA_CRDT_LMT_APV_FLOW_NUM,T1.DUBIL_ID)  AS CRDT_CONT_NM                --05授信合同名称
         ,T1.CUST_ID                                      AS CUST_ID                     --06客户编号
         ,T1.ACCT_INSTIT_ID                               AS ORG_ID                      --07机构编号
         ,NVL(T4.APPL_AMT,T2.DUBIL_AMT)                   AS CRDT_LMT                    --08授信额度
         --,SUM(T2.CURRT_BAL)                               AS ALDY_USE_LMT                --09已用额度
         ,SUM(CASE WHEN T2.CURRT_BAL > 0 AND T2.WRT_OFF_FLG <> '1' --余额大于0
                   THEN T2.CURRT_BAL
                   ELSE 0
              END )                                       AS ALDY_USE_LMT                --09已用额度 --MOD BY YJY 20251127
         ,''                                              AS SUR_CRDT_LMT                --10剩余授信额度  暂定
         ,''                                              AS EXP_CRDT_LMT                --11敞口授信额度
         ,''                                              AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,''                                              AS EXP_SUR_LMT                 --13敞口剩余额度
         ,T2.CURR_CD                                      AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,MIN(CASE WHEN TO_CHAR(T4.APVED_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T4.APVED_DT,'YYYYMMDD')
                   WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD')
               END)                                       AS EFF_DT                      --16生效日期
         ,CASE WHEN T4.RELA_CRDT_LMT_APV_FLOW_NUM IS NOT NULL 
               THEN 'Y' 
               WHEN T2.CURRT_BAL > 0 AND T2.WRT_OFF_FLG <> '1' --不含核销
               THEN 'Y'
               ELSE 'N'
           END                                            AS CRDT_STAT                   --17授信状态 Z0002
         ,MIN(CASE WHEN TO_CHAR(T4.FIRST_TRIAL_APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T4.FIRST_TRIAL_APPL_DT,'YYYYMMDD')
                   WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') 
               END)                                       AS CRDT_APP_DT                 --18授信申请日期
         ,MIN(CASE WHEN TO_CHAR(T4.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T4.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                   WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') 
               END)                                       AS CRDT_START_DT               --19授信开始日期
         ,MAX(CASE WHEN TO_CHAR(T4.CRDT_LMT_EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T4.CRDT_LMT_EXP_DT,'YYYYMMDD')
                   WHEN TO_CHAR(T2.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T2.EXP_DT,'YYYYMMDD')
               END)                                       AS CRDT_EXP_DT                 --20授信到期日期
         ,T1.STD_PROD_ID                                  AS CRDT_BIZ_TYP                --21授信业务类型 T0007
         ,'N'                                             AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,'02'                                            AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,NULL                                            AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,NVL(T4.CRDT_LMT_APV_OPINION,'同意')             AS DSN_SHT_OPN                 --26决策单意见
         ,NVL(T4.FINAL_APVER_ID,T1.CUST_MGR_ID)           AS APRV_PSN_NO                 --27审批人工号
         ,MAX(T1.CUST_MGR_ID)                             AS CRDT_EMP_NO                 --28授信员工号
         ,'800924'                                        AS DEPT_LINE                   --29部门条线/*零售信贷部(普惠金融部)*/ --MODIFY BY TANGAN AT 20230130
         ,'零售'                                          AS DATA_SRC                    --30数据来源
         ,T1.STD_PROD_ID                                  AS BUS_BREED_ID                --31业务品种编号
         ,'零售360借条'                                   AS DATA_SRC_DESC               --32数据来源描述
         ,''                                              AS LMT_TYPE_CD                 --33额度种类代码
         ,MAX(T4.HAPP_TYPE_CD)                            AS LOAN_HAPP_TYPE_CD           --34合同发生类型 
         ,''                                              AS RELA_CONT_ID                --35原合同编号
         ,T1.STD_PROD_ID                                  AS STD_PROD_ID                 --36标准产品编号
         ,'01'                                            AS STATUS_CD                   --37状态代码  --01有效
         ,MIN(CASE WHEN TO_CHAR(T4.APVED_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T4.APVED_DT,'YYYYMMDD')
                   WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD')
              END)                                        AS CRDT_APVED_DT               --38授信审批日期 --ADD BY YJY 20250114
         ,'Z'                                             AS CUST_ID_ZT_FLG              --39是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE WHEN ((T2.CURRT_BAL > 0 AND T2.WRT_OFF_FLG <> '1') --余额未结清
                 OR (T2.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                     AND TO_CHAR(T2.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --当月转让
                 OR (T5.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                     AND TO_CHAR(T5.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --当月核销
                 OR (T1.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                     AND TO_CHAR(T1.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')))  --当月结清                       
               THEN 'Y'  
               ELSE 'N'         
           END                                             AS EAST_MON_FLG             --40EAST月口径标识 --ADD BY YJY 20251127
         ,CASE WHEN ((T2.CURRT_BAL > 0 AND T2.WRT_OFF_FLG <> '1') --余额未结清
                 OR (T2.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(T2.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))   --本年转让  
                 OR (T5.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(T5.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --本年核销         
                 OR (T1.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                     AND TO_CHAR(T1.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))) --本年结清          
               THEN 'Y'  
               ELSE 'N'         
          END                                             AS YBT_YEAR_FLG             --41一表通年口径标识 --ADD BY YJY 20251127    
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T1 --零售贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.DUBIL_NUM = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     /*AND T2.CURRT_BAL > 0 --余额大于0
     AND T2.WRT_OFF_FLG <> '1' --不含核销*/ --MOD BY YJY 扩大取数范围
     --ADD BY YJY 20251127 关联核销表取核销日期
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO T5 --贷款核销信息
      ON T5.DUBIL_ID = T1.DUBIL_ID
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T3 --零售贷款合同信息 
      ON T3.CONT_ID = T1.CONT_ID 
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.PROD_ID = '202010200012' --360借条
    LEFT JOIN TMP_CRDT_LMT T4  --零售贷款申请信息 --存在有借据无授信情况
      ON T4.RELA_CRDT_LMT_APV_FLOW_NUM = T3.APLV_FLOW_NUM --关联授信额度审批流水号
   WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.STD_PROD_ID = '202010200012' --360借条
   GROUP BY T1.LP_ID
           ,NVL(T4.RELA_CRDT_LMT_APV_FLOW_NUM,T1.DUBIL_ID)            --04授信合同编号
           ,NVL(T4.RELA_CRDT_LMT_APV_FLOW_NUM,T1.DUBIL_ID)            --05授信合同名称
           ,T1.CUST_ID                                                --06客户编号
           ,T1.ACCT_INSTIT_ID                                         --07机构编号
           ,NVL(T4.APPL_AMT,T2.DUBIL_AMT)                             --08授信额度
           ,T2.CURR_CD    
           ,CASE WHEN T4.RELA_CRDT_LMT_APV_FLOW_NUM IS NOT NULL 
                 THEN 'Y' 
                 WHEN T2.CURRT_BAL > 0 AND T2.WRT_OFF_FLG <> '1' --不含核销
                 THEN 'Y'
                 ELSE 'N'
             END
           ,NVL(T4.CRDT_LMT_APV_OPINION,'同意')
           ,NVL(T4.FINAL_APVER_ID,T1.CUST_MGR_ID)
           ,T1.STD_PROD_ID 
           ,CASE WHEN ((T2.CURRT_BAL > 0 AND T2.WRT_OFF_FLG <> '1') --余额未结清
                   OR (T2.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                       AND TO_CHAR(T2.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --当月转让
                   OR (T5.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                       AND TO_CHAR(T5.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --当月核销
                   OR (T1.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                       AND TO_CHAR(T1.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')))  --当月结清                       
                 THEN 'Y'  
                 ELSE 'N'         
             END             --40EAST月口径标识 --ADD BY YJY 20251127
           ,CASE WHEN ((T2.CURRT_BAL > 0 AND T2.WRT_OFF_FLG <> '1') --余额未结清
                   OR (T2.ASSET_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                       AND TO_CHAR(T2.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))   --本年转让  
                   OR (T5.FIR_WRT_OFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                       AND TO_CHAR(T5.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231')) --本年核销         
                   OR (T1.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
                       AND TO_CHAR(T1.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231'))) --本年结清          
                  THEN 'Y'  
                  ELSE 'N'         
                 END     --41一表通年口径标识 --ADD BY YJY 20251127    
           ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入授信额度主表-联合网贷-非网商贷'; --19
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,PRIM_CRDT_CONT_ID               --主授信合同编号
    ,CRDT_CONT_ID                    --授信合同编号
    ,CRDT_CONT_NM                    --授信合同名称
    ,RCPT_ID                         --借据号
    ,CUST_ID                         --客户编号
    ,ORG_ID                          --机构编号
    ,CRDT_LMT                        --授信额度
    ,ALDY_USE_LMT                    --已用额度
    ,SUR_CRDT_LMT                    --剩余授信额度
    ,EXP_CRDT_LMT                    --敞口授信额度
    ,EXP_ALDY_USE_LMT                --敞口已用额度
    ,EXP_SUR_LMT                     --敞口剩余额度
    ,CUR                             --币种
    ,CRDT_SUBJ_TYP                   --授信主体类型
    ,EFF_DT                          --生效日期
    ,CRDT_STAT                       --授信状态
    ,CRDT_APP_DT                     --授信申请日期
    ,CRDT_START_DT                   --授信开始日期
    ,CRDT_EXP_DT                     --授信到期日期
    ,CRDT_BIZ_TYP                    --授信业务类型
    ,CIR_LMT_FLG                     --循环额度标志
    ,TEMP_LMT_FLG                    --临时额度标志
    ,CRDT_SUBJ_CL                    --授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
    ,APRV_PSN_NO                     --审批人工号
    ,CRDT_EMP_NO                     --授信员工号
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,BUS_BREED_ID                    --业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --数据来源描述  --ADD BY LIP 20220728
    ,STD_PROD_ID                     --标准产品编号
    ,CRDT_APVED_DT                   --授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --一表通年口径标识 --ADD BY YJY 20251127
     )
  WITH CMM_UNITE_WL_LMT_INFO_QC AS (
  --由于数仓保留了BUS_BREED_ID在联合网贷额度表，但是没有标准产品号，现在把BUS_BREED_ID映射为标准产品号
  SELECT /*+MATERIALIZE*/
         T.CUST_ID                              AS CUST_ID      --客户号
        /*,T.LMT_CONT_ID                          AS LMT_CONT_ID  --额度合同编号*/
        --UPDATE BY YJY 20260413 203050100002-微众对公联合贷的取联合贷额度信息表的LMT_RELA_APPL_ID--额度关联申请编号，其他产品取LMT_CONT_ID--额度合同编号
        ,CASE WHEN T.BUS_BREED_ID = '203050100002' THEN T.LMT_RELA_APPL_ID
              ELSE T.LMT_CONT_ID
          END                                   AS LMT_CONT_ID  --额度合同编号
        ,T.CRDT_LMT                             AS CRDT_LMT     --授信额度
        ,T.STATUS_CD                            AS STATUS_CD    --状态代码
        ,T.LOW_RISK_BUS_FLG                     AS LOW_RISK_BUS_FLG  --低风险业务标志 --MODIFY BY TANGAN AT 20230129
        ,T.CRDT_OPEN_AMT                        AS CRDT_OPEN_AMT --合同敞口金额 --MODIFY BY TANGAN AT 20230129
        ,MIN(BEGIN_DT) OVER(PARTITION BY CUST_ID, --MODIFY BY TANGAN AT 20230129
              CASE WHEN T.BUS_BREED_ID IN ('202020100001','202020200004','02001006135011','02001006160048') THEN '202020100001' --网商贷
                   WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
                   WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                   WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                   WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
                   ELSE T.BUS_BREED_ID END)     AS BEGIN_DT      --授信起始日期
        ,CASE WHEN TO_CHAR(T.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
              THEN T.EXP_DT
          END                                   AS EXP_DT        --授信到期日期
        ,CASE WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
              WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
              WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
              WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
              ELSE T.BUS_BREED_ID --ADD BY WEIYONGZHAO 20230523 会有新增产品，加上兜底
          END                                   AS BUS_BREED_ID1 --统一后的授信品种
        ,ROW_NUMBER() OVER(PARTITION BY CUST_ID,
                          CASE WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
                               WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                               WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                               WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
                               ELSE T.BUS_BREED_ID --ADD BY WEIYONGZHAO 20230523 会有新增产品，加上兜底
                           END
                          ORDER BY BEGIN_DT DESC,T.LMT_CONT_ID DESC) AS RN          --去重
         --一个客户在一个业务品种中可能有多次审批记录，取当前最新的一个额度为准 --梁秋茹/杨光泽
         --标准产品号之后没有分借呗/借呗三期，网商贷/网商贷引流产品。但是数仓保留了旧的BUS_BREED_ID字段，赋了原来的业务品种值
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO T --联合网贷额度信息
   WHERE TRIM(T.CUST_ID) IS NOT NULL
     AND T.CRDT_LMT > 0
     AND ((T.BUS_BREED_ID IN ('202010100008','202020100003') AND T.STATUS_CD = '01')
         OR T.BUS_BREED_ID NOT IN ('202020100001','202020200004','02001006135011',
                                   '02001006160048','202010100008','202020100003')) --微粒贷只取审批通过 剔除网商贷 --20240105
     --MOD BY LIUYU 为了应对新一代测试环境有大于数据日期的业务数据，对发生日期限制
     AND ((NVL(T.BEGIN_DT,TO_DATE('00010101','YYYYMMDD')) <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1 
           AND T.BUS_BREED_ID NOT IN ('202010200011','202010200010','201020100063'))
          OR (NVL(T.BEGIN_DT,TO_DATE('00010101','YYYYMMDD')) <= TO_DATE(V_P_DATE,'YYYYMMDD')
              AND T.BUS_BREED_ID IN ('202010200011','202010200010','201020100063')) --MOD BY YJY 20251104 分期乐、好企贷-数据贷（微业贷3.0）的放款日期特殊处理
          OR T.BEGIN_DT = TO_DATE('20991231','YYYYMMDD')
          OR T.BEGIN_DT = TO_DATE('99991231','YYYYMMDD'))
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                               AS DATA_DT                      --数据日期
         ,A.LP_ID                                AS LGL_REP_ID                   --法人编号
         ,NULL                                   AS PRIM_CRDT_CONT_ID            --主授信合同编号
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)         AS CRDT_CONT_ID                 --授信合同编号
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)         AS CRDT_CONT_NM                 --授信合同名称
         ,''                                     AS RCPT_ID                      --借据号
         ,A.CUST_ID                              AS CUST_ID                      --客户编号
         ,A.ACCT_INSTIT_ID                       AS ORG_ID                       --机构编号
         ,NVL(TB.CRDT_LMT,A.DUBIL_AMT)           AS CRDT_LMT                     --授信额度
         ,SUM(NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0))
                                                 AS ALDY_USE_LMT                 --已用额度
         ,NULL                                   AS SUR_CRDT_LMT                 --剩余授信额度
         ,NULL                                   AS EXP_CRDT_LMT                 --敞口授信额度
         ,NULL                                   AS EXP_ALDY_USE_LMT             --敞口已用额度
         ,NULL                                   AS EXP_SUR_LMT                  --敞口剩余额度
         ,A.CURR_CD                              AS CUR                          --币种
         --,'04'                                   AS CRDT_SUBJ_TYP                --授信主体类型 04个人客户授信
         ,MIN(CASE WHEN NVL(TRIM(A.STD_PROD_ID),TB.BUS_BREED_ID1) IN ('203050100001','203050100002')
                   THEN '01' --MOD BY YJY 20251203 01	单一法人授信
                   ELSE '04' --04个人客户授信
               END)                              AS CRDT_SUBJ_TYP                --授信主体类型
         ,MIN(CASE WHEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               END)                              AS EFF_DT                       --生效日期
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                    AND A.WRT_OFF_FLG <> '1' 
               THEN 'Y'
               ELSE 'N'
           END                                   AS CRDT_STAT                    --授信状态 Z0002
         ,MIN(CASE WHEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               END)                              AS CRDT_APP_DT                  --授信申请日期
         ,MIN(CASE WHEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               END)                              AS CRDT_START_DT                --授信开始日期
         ,MAX(CASE WHEN TO_CHAR(TB.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(TB.EXP_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
               END)                              AS CRDT_EXP_DT                  --授信到期日期
         ,NVL(TB.BUS_BREED_ID1,A.STD_PROD_ID)    AS CRDT_BIZ_TYP                 --授信业务类型
         ,'Y'                                    AS CIR_LMT_FLG                  --循环额度标志
         ,NULL                                   AS TEMP_LMT_FLG                 --临时额度标志
         ,CASE WHEN TB.LOW_RISK_BUS_FLG = '1' THEN '02'
               WHEN NVL(TB.CRDT_OPEN_AMT,0) > 0 THEN '9901' --其他-敞口授信
               ELSE '02'
           END                                   AS CRDT_SUBJ_CL                --授信主体种类T0029 --MODIFY BY TANGAN AT 20230129
         ,NULL                                   AS BANK_TAX_COOP_LOAN_CRDT_FLG --银税合作贷款授信标志
         ,MAX(A.CUST_MGR_ID)                     AS APRV_PSN_NO                 --审批人工号 --MODIFY BY TANGAN AT 20230130
         ,MAX(A.CUST_MGR_ID)                     AS CRDT_EMP_NO                 --授信员工号 --MODIFY BY TANGAN AT 20230130
         ,'800924'                               AS DEPT_LINE                   --部门条线 /*零售信贷部(普惠金融部)*/
         ,CASE WHEN NVL(TRIM(A.STD_PROD_ID),TB.BUS_BREED_ID1) IN ('203050100001','203050100002') THEN '对公联合网贷' --MOD BY YJY 20250219 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
               ELSE '联合网贷'
           END                                   AS DATA_SRC                    --数据来源
         ,CASE WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004135021','202010100003') THEN '202010100003' --花呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
               ELSE NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1)
           END                                   AS BUS_BREED_ID                --业务品种编号  --ADD BY LIP 20220728
         ,CASE WHEN NVL(TRIM(A.STD_PROD_ID),TB.BUS_BREED_ID1) IN ('203050100001','203050100002') THEN 'DG'||'对公联合网贷-微业贷'  --MOD BY YJY 20250219 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
               ELSE 'LS'||'联合网贷-非网商贷'
           END                                   AS DATA_SRC_DESC               --数据来源描述  --ADD BY LIP 20220728
         ,A.STD_PROD_ID                          AS STD_PROD_ID                 --标准产品编号
         ,NULL                                   AS CRDT_APVED_DT               --授信审批日期  --ADD BY YJY 20250114
         ,'Z'                                    AS CUST_ID_ZT_FLG              --是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE --MOD BY YJY 20251104 对分期乐、好企贷-数据贷（微业贷3.0）产品特殊处理
                WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.WRT_OFF_FLG = '1'
                 AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                      OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'))
                THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）核销过且核销日期大于月初
                WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.WRT_OFF_FLG = '1'  
                THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）核销过的且核销日期小于月初的
                WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
                 AND (A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'))     
                THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）的结清日期为空，或者结清日期大于月初
                WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
                 AND A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
                THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）的结清日期小于月初  
                WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601'
                THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
                WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND B.DUBIL_ID IS NULL
                THEN 'N' --MOD BY 20240704 调整京东金条的月标识
                WHEN A.WRT_OFF_FLG = '1' AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                     OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
                THEN 'Y' --核销了且核销日期大于月初
                WHEN A.WRT_OFF_FLG = '1'
                THEN 'N' --核销了的且核销日期小于月初的
                WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
                     AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
                THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
                WHEN A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004')
                THEN 'N' --非京东的结清日期小于月初
                WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                THEN 'Y' --京东的有余额
                WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                     AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                          OR A.LAST_REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
                THEN 'Y'
                ELSE 'N' --MOD BY LIP 20240704
            END                                   AS  EAST_MON_FLG    --EAST月口径标识   --ADD BY YJY 20251127
          ,'Y'                                    AS  YBT_YEAR_FLG    --一表通年口径标识 --ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO B --联合网贷核销表
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CMM_UNITE_WL_LMT_INFO_QC TB --存在有借据无授信情况
      ON TB.CUST_ID = A.CUST_ID
     AND TB.BUS_BREED_ID1 = (CASE WHEN A.STD_PROD_ID IN ('202010100004','202010100005') THEN '202010100004' --京东白条
                                  WHEN A.STD_PROD_ID IN ('202010100002','202010100001') THEN '202010100001' --借呗
                                  ELSE A.STD_PROD_ID
                              END)
     AND TB.RN = 1
   WHERE 
    --MOD BY YJY 20251127 卡当年的取数范围
    CASE --MOD BY YJY 20251104 对分期乐、好企贷-数据贷（微业贷3.0）产品特殊处理
          WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.WRT_OFF_FLG = '1'
           AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'))
          THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）核销过且核销日期大于月初
          WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.WRT_OFF_FLG = '1'  
          THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）核销过的且核销日期小于月初的
          WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
           AND (A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'))     
          THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）的结清日期为空，或者结清日期大于月初
          WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
           AND A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') 
          THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）的结清日期小于月初  
          WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601'
          THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
          WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND B.DUBIL_ID IS NULL
          THEN 'N' --MOD BY 20240704 调整京东金条的月标识
          WHEN A.WRT_OFF_FLG = '1' AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
               OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1)
          THEN 'Y' --核销了且核销日期大于月初
          WHEN A.WRT_OFF_FLG = '1'
          THEN 'N' --核销了的且核销日期小于月初的
          WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
               AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
          THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
          WHEN A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1 AND A.STD_PROD_ID NOT IN ('202010100004')
          THEN 'N' --非京东的结清日期小于月初
          WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
          THEN 'Y' --京东的有余额
          WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
               AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                    OR A.LAST_REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1)
          THEN 'Y'
          ELSE 'N'
      END = 'Y' --MOD BY LIP 20240704  
     AND A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销 --ADD BY LIP 20220722过滤没发放成功的数据
     AND A.STD_PROD_ID NOT IN ('202020100001','202020200004','02001006135011','02001006160048') --剔除网商贷
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.LP_ID
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)
         ,A.CUST_ID
         ,A.ACCT_INSTIT_ID
         ,NVL(TB.CRDT_LMT,A.DUBIL_AMT)
         ,A.CURR_CD
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                AND A.WRT_OFF_FLG <> '1' 
               THEN 'Y'
               ELSE 'N'
           END
         ,NVL(TB.BUS_BREED_ID1,A.STD_PROD_ID)
         ,CASE WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004135021','202010100003') THEN '202010100003' --花呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
               ELSE NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1)
           END
         ,CASE WHEN TB.LOW_RISK_BUS_FLG = '1' THEN '02'
               WHEN NVL(TB.CRDT_OPEN_AMT,0) > 0 THEN '9901' --其他-敞口授信
               ELSE '02'
           END
         ,A.STD_PROD_ID
         ,CASE WHEN NVL(TRIM(A.STD_PROD_ID),TB.BUS_BREED_ID1) IN ('203050100001','203050100002') THEN '对公联合网贷' --MOD BY YJY 20250219 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
               ELSE '联合网贷'
           END
         ,CASE WHEN NVL(TRIM(A.STD_PROD_ID),TB.BUS_BREED_ID1) IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
               THEN 'DG'||'对公联合网贷-微业贷'  --MOD BY YJY 20250219
               ELSE 'LS'||'联合网贷-非网商贷'
           END
        ,CASE --MOD BY YJY 20251104 对分期乐、好企贷-数据贷（微业贷3.0）产品特殊处理
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.WRT_OFF_FLG = '1'
               AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'))
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）核销过且核销日期大于月初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.WRT_OFF_FLG = '1'  
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）核销过的且核销日期小于月初的
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND (A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'))     
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）的结清日期为空，或者结清日期大于月初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') 
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）的结清日期小于月初  
              WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601'
              THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
              WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND B.DUBIL_ID IS NULL
              THEN 'N' --MOD BY 20240704 调整京东金条的月标识
              WHEN A.WRT_OFF_FLG = '1' AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
              THEN 'Y' --核销了且核销日期大于月初
              WHEN A.WRT_OFF_FLG = '1'
              THEN 'N' --核销了的且核销日期小于月初的
              WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
                   AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
              THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
              WHEN A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004')
              THEN 'N' --非京东的结清日期小于月初
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
              THEN 'Y' --京东的有余额
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                   AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                        OR A.LAST_REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
              THEN 'Y'
              ELSE 'N' --MOD BY LIP 20240704
          END        --EAST月口径标识   --ADD BY YJY 20251127
      ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --网商贷根据资本新规，调整为单笔单批
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入授信额度主表-联合网贷-网商贷'; --20
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP02
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,PRIM_CRDT_CONT_ID               --主授信合同编号
    ,CRDT_CONT_ID                    --授信合同编号
    ,CRDT_CONT_NM                    --授信合同名称
    ,RCPT_ID                         --借据号
    ,CUST_ID                         --客户编号
    ,ORG_ID                          --机构编号
    ,CRDT_LMT                        --授信额度
    ,ALDY_USE_LMT                    --已用额度
    ,SUR_CRDT_LMT                    --剩余授信额度
    ,EXP_CRDT_LMT                    --敞口授信额度
    ,EXP_ALDY_USE_LMT                --敞口已用额度
    ,EXP_SUR_LMT                     --敞口剩余额度
    ,CUR                             --币种
    ,CRDT_SUBJ_TYP                   --授信主体类型
    ,EFF_DT                          --生效日期
    ,CRDT_STAT                       --授信状态
    ,CRDT_APP_DT                     --授信申请日期
    ,CRDT_START_DT                   --授信开始日期
    ,CRDT_EXP_DT                     --授信到期日期
    ,CRDT_BIZ_TYP                    --授信业务类型
    ,CIR_LMT_FLG                     --循环额度标志
    ,TEMP_LMT_FLG                    --临时额度标志
    ,CRDT_SUBJ_CL                    --授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
    ,APRV_PSN_NO                     --审批人工号
    ,CRDT_EMP_NO                     --授信员工号
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,BUS_BREED_ID                    --业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --数据来源描述  --ADD BY LIP 20220728
    ,STD_PROD_ID                     --标准产品编号
    ,CRDT_APVED_DT                   --授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --是否系统内转贴现客户标识 ADD BY YJY 20250220
    ,EAST_MON_FLG                    --EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --一表通年口径标识 --ADD BY YJY 20251127
    )
  SELECT  V_P_DATE                               AS DATA_DT                      --数据日期
         ,A.LP_ID                                AS LGL_REP_ID                   --法人编号
         ,NULL                                   AS PRIM_CRDT_CONT_ID            --主授信合同编号
         ,A.DUBIL_ID                             AS CRDT_CONT_ID                 --授信合同编号
         ,A.DUBIL_ID                             AS CRDT_CONT_NM                 --授信合同名称
         ,''                                     AS RCPT_ID                      --借据号
         ,A.CUST_ID                              AS CUST_ID                      --客户编号
         ,A.ACCT_INSTIT_ID                       AS ORG_ID                       --机构编号
         ,A.DISTR_AMT                            AS CRDT_LMT                     --授信额度
         ,A.DISTR_AMT                            AS ALDY_USE_LMT                 --已用额度
         ,NULL                                   AS SUR_CRDT_LMT                 --剩余授信额度
         ,NULL                                   AS EXP_CRDT_LMT                 --敞口授信额度
         ,NULL                                   AS EXP_ALDY_USE_LMT             --敞口已用额度
         ,NULL                                   AS EXP_SUR_LMT                  --敞口剩余额度
         ,A.CURR_CD                              AS CUR                          --币种
         ,'04'                                   AS CRDT_SUBJ_TYP                --授信主体类型 04个人客户授信
         ,MIN(CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               END)                              AS EFF_DT                       --生效日期
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                    AND A.WRT_OFF_FLG <> '1' THEN 'Y'
               ELSE 'N'
           END                                   AS CRDT_STAT                    --授信状态 Z0002
         ,MIN(CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               END)                              AS CRDT_APP_DT                  --授信申请日期
         ,MIN(CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               END)                              AS CRDT_START_DT                --授信开始日期
         ,MAX(CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
                   THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
               END)                              AS CRDT_EXP_DT                  --授信到期日期
         ,A.STD_PROD_ID                          AS CRDT_BIZ_TYP                 --授信业务类型
         ,'N'                                    AS CIR_LMT_FLG                  --循环额度标志
         ,NULL                                   AS TEMP_LMT_FLG                 --临时额度标志
         ,'02'                                   AS CRDT_SUBJ_CL                 --授信主体种类T0029
         ,NULL                                   AS BANK_TAX_COOP_LOAN_CRDT_FLG  --银税合作贷款授信标志
         ,MAX(A.CUST_MGR_ID)                     AS APRV_PSN_NO                  --审批人工号  --MODIFY BY TANGAN AT 20230130
         ,MAX(A.CUST_MGR_ID)                     AS CRDT_EMP_NO                  --授信员工号  --MODIFY BY TANGAN AT 20230130
         ,'800924'                               AS DEPT_LINE                    --部门条线 /*零售信贷部(普惠金融部)*/
         ,'联合网贷'                             AS DATA_SRC                     --数据来源
         ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004','02001006135011','02001006160048')
               THEN '202020100001' --网商贷
           END                                   AS BUS_BREED_ID                 --业务品种编号  --ADD BY LIP 20220728
         ,'LS'||'联合网贷-网商贷'                AS DATA_SRC_DESC                --数据来源描述  --ADD BY LIP 20220728
         ,A.STD_PROD_ID                          AS STD_PROD_ID                  --标准产品编号
         ,NULL                                   AS CRDT_APVED_DT                --授信审批日期  --ADD BY YJY 20250114
         ,'Z'                                    AS CUST_ID_ZT_FLG               --是否系统内转贴现客户标识 ADD BY YJY 20250220
         ,CASE WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601' THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
               WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND B.DUBIL_ID IS NULL THEN 'N' --MOD BY 20240704 调整京东金条的月标识
               WHEN A.WRT_OFF_FLG = '1' AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                    OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
               THEN 'Y' --核销了且核销日期大于月初
               WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销了的且核销日期小于月初的
               WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
               THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
               WHEN A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004') THEN 'N' --非京东的结清日期小于月初
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0 THEN 'Y' --京东的有余额
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                   AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                   OR A.LAST_REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
               THEN 'Y'
               ELSE 'N'
               END                                AS EAST_MON_FLG                 --EAST月口径标识   --ADD BY YJY 20251127 
         ,'Y'                                     AS YBT_YEAR_FLG                 --一表通年口径标识 --ADD BY YJY 20251127
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO B --联合网贷核销表
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE /*CASE WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601' THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
              WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND B.DUBIL_ID IS NULL THEN 'N' --MOD BY 20240704 调整京东金条的月标识
              WHEN A.WRT_OFF_FLG = '1' AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
              THEN 'Y' --核销了且核销日期大于月初
              WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销了的且核销日期小于月初的
              WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
              THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
              WHEN A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004') THEN 'N' --非京东的结清日期小于月初
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0 THEN 'Y' --京东的有余额
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                   AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                   OR A.LAST_REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
              THEN 'Y'
              ELSE 'N'
          END = 'Y' --MOD BY LIP 20240704 */
     --MOD BY YJY 20251127  卡当年的取数范围
       CASE WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601' THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
            WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND B.DUBIL_ID IS NULL THEN 'N' --MOD BY 20240704 调整京东金条的月标识
            WHEN A.WRT_OFF_FLG = '1' AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                 OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1)
            THEN 'Y' --核销了且核销日期大于月初
            WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销了的且核销日期小于月初的
            WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                 OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1 AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
            THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
            WHEN A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1 AND A.STD_PROD_ID NOT IN ('202010100004') THEN 'N' --非京东的结清日期小于月初
            WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0 THEN 'Y' --京东的有余额
            WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                 AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                 OR A.LAST_REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1)
            THEN 'Y'
            ELSE 'N'
        END = 'Y'    
     AND A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销 --ADD BY LIP 20220722过滤没发放成功的数据
     AND A.STD_PROD_ID IN ('202020100001','202020200004','02001006135011','02001006160048') --网商贷
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY
          A.LP_ID
         ,A.DUBIL_ID
         ,A.CUST_ID
         ,A.ACCT_INSTIT_ID
         ,A.DISTR_AMT
         ,A.CURR_CD
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                    AND A.WRT_OFF_FLG <> '1' THEN 'Y'
               ELSE 'N'
           END
         ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004','02001006135011','02001006160048')
               THEN '202020100001' --网商贷
           END
         ,A.STD_PROD_ID
         ,CASE WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601' THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
               WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND B.DUBIL_ID IS NULL THEN 'N' --MOD BY 20240704 调整京东金条的月标识
               WHEN A.WRT_OFF_FLG = '1' AND (B.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(B.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
               THEN 'Y' --核销了且核销日期大于月初
               WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销了的且核销日期小于月初的
               WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR (A.PAYOFF_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
               THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
               WHEN A.PAYOFF_DT < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1 AND A.STD_PROD_ID NOT IN ('202010100004') THEN 'N' --非京东的结清日期小于月初
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0 THEN 'Y' --京东的有余额
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                   AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                   OR A.LAST_REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
               THEN 'Y'
               ELSE 'N'
           END  --MOD BY YJY 20251128
       ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '按授信合同维度整合'; --21
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP04';
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP04
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,PRIM_CRDT_CONT_ID               --主授信合同编号
    ,CRDT_CONT_ID                    --授信合同编号
    ,CRDT_CONT_NM                    --授信合同名称
    ,CUST_ID                         --客户编号
    ,ORG_ID                          --机构编号
    ,CRDT_LMT                        --授信额度
    ,ALDY_USE_LMT                    --已用额度
    ,SUR_CRDT_LMT                    --剩余授信额度
    ,EXP_CRDT_LMT                    --敞口授信额度
    ,EXP_ALDY_USE_LMT                --敞口已用额度
    ,EXP_SUR_LMT                     --敞口剩余额度
    ,CUR                             --币种
    ,CRDT_SUBJ_TYP                   --授信主体类型
    ,EFF_DT                          --生效日期
    ,CRDT_STAT                       --授信状态
    ,CRDT_APP_DT                     --授信申请日期
    ,CRDT_START_DT                   --授信开始日期
    ,CRDT_EXP_DT                     --授信到期日期
    ,CRDT_BIZ_TYP                    --授信业务类型
    ,CIR_LMT_FLG                     --循环额度标志
    ,TEMP_LMT_FLG                    --临时额度标志
    ,CRDT_SUBJ_CL                    --授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
    ,DSN_SHT_OPN                     --决策单意见
    ,APRV_PSN_NO                     --审批人工号
    ,CRDT_EMP_NO                     --授信员工号
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,LMT_TYPE_CD                     --额度类型代码
    ,LOAN_HAPP_TYPE_CD               --合同发生类型
    ,RELA_CONT_ID                    --原合同编号
    ,BUS_BREED_ID                    --业务品种编号
    ,ORG_ID_ORI                      --合同原始机构编号
    ,GROUP_CRDT_FLG                  --集团授信标志
    ,STD_PROD_ID                     --标准产品编号
    ,APPL_WAY_CD                     --申请方式代码
    ,APPROVE_SERIAL_FLOW_NUM         --被动转授信集团批复流水号
    ,APV_FLOW_NUM                    --批复流水号
    ,LMT_UNDER_SELLBL_PROD_ID        --可售产品
    ,APV_AMT                         --批复金额
    ,CRDT_CONT_ID_KHFX               --授信合同编号-客户风险  --ADD BY YJY 20240722
    ,STATUS_CD                       --状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --是否系统内转贴现客户标识  ADD BY YJY 20250220
    ,EAST_MON_FLG                    --EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --一表通年口径标识 --ADD BY YJY 20251127
    )
  WITH TMP1 AS (
  SELECT T.DATA_DT                                AS DATA_DT           --数据日期
        ,T.LGL_REP_ID                             AS LGL_REP_ID        --法人编号
        ,T.PRIM_CRDT_CONT_ID                      AS PRIM_CRDT_CONT_ID --主授信合同编号
        ,T.CRDT_CONT_ID                           AS CRDT_CONT_ID      --授信合同编号
        ,NVL(TRIM(T.CRDT_CONT_NM),T.CRDT_CONT_ID) AS CRDT_CONT_NM      --授信合同名称
        ,T.CUST_ID                                AS CUST_ID           --客户编号
        ,NVL(T.ORG_ID,'800')                      AS ORG_ID            --机构编号
        ,T.CRDT_LMT                               AS CRDT_LMT          --授信额度
        ,SUM(T.ALDY_USE_LMT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID) AS ALDY_USE_LMT --已用额度--ADD BY YJY 20250220
        ,T.SUR_CRDT_LMT                           AS SUR_CRDT_LMT      --剩余授信额度
        ,T.EXP_CRDT_LMT                           AS EXP_CRDT_LMT      --敞口授信额度
        ,T.EXP_ALDY_USE_LMT                       AS EXP_ALDY_USE_LMT  --敞口已用额度
        ,T.EXP_SUR_LMT                            AS EXP_SUR_LMT       --敞口剩余额度
        ,T.CUR                                    AS CUR               --币种
        ,T.CRDT_SUBJ_TYP                          AS CRDT_SUBJ_TYP     --授信主体类型
        ,MIN(T.EFF_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.EFF_DT NULLS LAST) AS EFF_DT --生效日期
        --,T.CRDT_STAT                              AS CRDT_STAT         --授信状态
        ,CASE WHEN NVL(LOAN_HAPP_TYPE_CD,'0100') = '0201' THEN 'N' --展期的合同置为失效，不统计授信，避免重复统计
              ELSE T.CRDT_STAT
          END                                     AS CRDT_STAT         --授信状态 --MOD BY LIP 20251203 展期的授信不统计，默认为无效
        ,MIN(T.CRDT_APP_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.CRDT_APP_DT NULLS LAST) AS CRDT_APP_DT --授信申请日期
        ,MIN(T.CRDT_START_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.CRDT_START_DT NULLS LAST) AS CRDT_START_DT --授信开始日期
        ,MAX(T.CRDT_EXP_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.CRDT_EXP_DT NULLS LAST) AS CRDT_EXP_DT --授信到期日期
        ,T.CRDT_BIZ_TYP                           AS CRDT_BIZ_TYP      --授信业务类型
        ,T.CIR_LMT_FLG                            AS CIR_LMT_FLG       --循环额度标志
        ,T.TEMP_LMT_FLG                           AS TEMP_LMT_FLG      --临时额度标志
        ,T.CRDT_SUBJ_CL                           AS CRDT_SUBJ_CL      --授信主体种类
        ,T.BANK_TAX_COOP_LOAN_CRDT_FLG            AS BANK_TAX_COOP_LOAN_CRDT_FLG --银税合作贷款授信标志
        ,NVL(TRIM(T.DSN_SHT_OPN),'同意')          AS DSN_SHT_OPN       --决策单意见
        ,T.APRV_PSN_NO                            AS APRV_PSN_NO       --审批人工号
        ,T.CRDT_EMP_NO                            AS CRDT_EMP_NO       --授信员工号
        ,T.DEPT_LINE                              AS DEPT_LINE         --部门条线
        ,T.DATA_SRC                               AS DATA_SRC          --数据来源
        ,T.LMT_TYPE_CD                            AS LMT_TYPE_CD       --额度类型代码
        ,T.LOAN_HAPP_TYPE_CD                      AS LOAN_HAPP_TYPE_CD --合同发生类型
        ,T.RELA_CONT_ID                           AS RELA_CONT_ID      --原合同编号
        ,T.BUS_BREED_ID                           AS BUS_BREED_ID      --业务品种编号
        ,T.ORG_ID                                 AS ORG_ID_ORI        --合同原始机构编号
        ,T.GROUP_CRDT_FLG                         AS GROUP_CRDT_FLG    --集团授信标志
        ,T.STD_PROD_ID                            AS STD_PROD_ID       --标准产品编号
        ,T.APPL_WAY_CD                            AS APPL_WAY_CD       --申请方式代码
        ,T.APPROVE_SERIAL_FLOW_NUM                AS APPROVE_SERIAL_FLOW_NUM --被动转授信集团批复流水号
        ,T.APV_FLOW_NUM                           AS APV_FLOW_NUM      --批复流水号
        ,T.LMT_UNDER_SELLBL_PROD_ID               AS LMT_UNDER_SELLBL_PROD_ID --可售产品
        ,T.APV_AMT                                AS APV_AMT           --批复金额
        ,T.CRDT_CONT_ID_KHFX                      AS CRDT_CONT_ID_KHFX --授信合同编号-客户风险  --ADD BY YJY 20240722
        ,T.STATUS_CD                              AS STATUS_CD         --状态代码 --ADD BY LIP 20241025
        ,T.CRDT_APVED_DT                          AS CRDT_APVED_DT     --授信审批日期  --ADD BY YJY 20250114
        ,T.CUST_ID_ZT_FLG                         AS CUST_ID_ZT_FLG    --是否系统内转贴现客户标识  ADD BY YJY 20250220
        ,T.EAST_MON_FLG                           AS EAST_MON_FLG      --EAST月口径标识   --ADD BY YJY 20251127
        ,T.YBT_YEAR_FLG                           AS YBT_YEAR_FLG      --一表通年口径标识 --ADD BY YJY 20251127
        ,ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.CRDT_STAT DESC,T.CRDT_APP_DT DESC NULLS LAST) AS RN --联合网贷去重
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP02 T
   WHERE TRIM(T.CRDT_CONT_ID) IS NOT NULL
     --MOD BY LIP 20251203 因一表通的合同表需要报送对应的授信，放开该条件
     --AND NVL(LOAN_HAPP_TYPE_CD,'0100') <> '0201' --MOD BY YJY 20250618 剔除发生类型为0201-“展期”的额度合同
     )
  SELECT DATA_DT                         --数据日期
        ,LGL_REP_ID                      --法人编号
        ,PRIM_CRDT_CONT_ID               --主授信合同编号
        ,CRDT_CONT_ID                    --授信合同编号
        ,CRDT_CONT_NM                    --授信合同名称
        ,CUST_ID                         --客户编号
        ,ORG_ID                          --机构编号
        ,CASE WHEN NVL(CRDT_LMT,0) < NVL(ALDY_USE_LMT,0) THEN NVL(ALDY_USE_LMT,0)
              ELSE NVL(CRDT_LMT,0)
          END AS ALDY_USE_LMT            --授信额度
        ,ALDY_USE_LMT                    --已用额度
        ,SUR_CRDT_LMT                    --剩余授信额度
        ,EXP_CRDT_LMT                    --敞口授信额度
        ,EXP_ALDY_USE_LMT                --敞口已用额度
        ,EXP_SUR_LMT                     --敞口剩余额度
        ,CUR                             --币种
        ,CRDT_SUBJ_TYP                   --授信主体类型
        ,EFF_DT                          --生效日期
        ,CRDT_STAT                       --授信状态
        ,CASE WHEN CRDT_APP_DT >= CRDT_START_DT THEN CRDT_START_DT --MODIFY BY TANGAN AT 20230129 将<改为>=
              ELSE CRDT_APP_DT
          END AS CRDT_APP_DT             --授信申请日期
        ,CRDT_START_DT                   --授信开始日期
        ,CRDT_EXP_DT                     --授信到期日期
        ,CRDT_BIZ_TYP                    --授信业务类型
        ,CIR_LMT_FLG                     --循环额度标志
        ,TEMP_LMT_FLG                    --临时额度标志
        ,CRDT_SUBJ_CL                    --授信主体种类
        ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
        ,REPLACE(REPLACE(TRIM(DSN_SHT_OPN),CHR(10),''),CHR(13),'') AS DSN_SHT_OPN --决策单意见
        ,APRV_PSN_NO                     --审批人工号
        ,CRDT_EMP_NO                     --授信员工号
        ,DEPT_LINE                       --部门条线
        ,DATA_SRC                        --数据来源
        ,LMT_TYPE_CD                     --额度种类代码
        ,LOAN_HAPP_TYPE_CD               --合同发生类型
        ,RELA_CONT_ID                    --原合同编号
        ,BUS_BREED_ID                    --业务品种编号
        ,ORG_ID_ORI                      --原始机构编号
        ,GROUP_CRDT_FLG                  --集团授信标志
        ,STD_PROD_ID                     --标准产品编号
        ,APPL_WAY_CD                     --申请方式代码
        ,APPROVE_SERIAL_FLOW_NUM         --被动转授信集团批复流水号
        ,APV_FLOW_NUM                    --批复流水号
        ,LMT_UNDER_SELLBL_PROD_ID        --可售产品
        ,APV_AMT                         --批复金额
        ,CRDT_CONT_ID_KHFX               --授信合同编号-客户风险  --ADD BY YJY 20240722
        ,STATUS_CD                       --状态代码 --ADD BY LIP 20241025
        ,CRDT_APVED_DT                   --授信审批日期  --ADD BY YJY 20250114
        ,CUST_ID_ZT_FLG                  --是否系统内转贴现客户标识  ADD BY YJY 20250220
        ,EAST_MON_FLG                    --EAST月口径标识   --ADD BY YJY 20251127
        ,YBT_YEAR_FLG                    --一表通年口径标识 --ADD BY YJY 20251127
    FROM TMP1
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '处理首次授信日期'; --22
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_TEMP05';
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP05(CUST_ID,FIRST_CRDT_DT)
  WITH TMP1 AS (
     SELECT CUST_ID,TO_CHAR(START_DT,'YYYYMMDD') FIRST_CRDT_DT
       FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO  --对公贷款合同信息
      WHERE CUST_ID IS NOT NULL AND CRDT_TYPE_CD = '01'
        AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
     SELECT CUST_ID,TO_CHAR(BEGIN_DT,'YYYYMMDD') FIRST_CRDT_DT
       FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO --零售贷款授信额度信息
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
     SELECT CUST_ID,TO_CHAR(START_DT,'YYYYMMDD') FIRST_CRDT_DT
       FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO --零售贷款合同信息
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
     SELECT CUST_ID,TO_CHAR(DUBIL_OPEN_DT,'YYYYMMDD') FIRST_CRDT_DT
       FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
     SELECT CUST_ID,TO_CHAR(BEGIN_DT,'YYYYMMDD') FIRST_CRDT_DT
       FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO --联合网贷额度信息
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      UNION ALL
     SELECT /*+PARALLEL*/CUST_ID,TO_CHAR(OPEN_ACCT_DT,'YYYYMMDD') FIRST_CRDT_DT
       FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO --联合网贷借据信息
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT CUST_ID,MIN(FIRST_CRDT_DT) FROM TMP1 GROUP BY CUST_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '授信额度子表-整合'; --23
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_SUB
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,PRIM_CRDT_CONT_ID               --主授信合同编号
    ,CRDT_CONT_ID                    --授信合同编号
    ,CRDT_CONT_NM                    --授信合同名称
    ,CUST_ID                         --客户编号
    ,ORG_ID                          --机构编号
    ,CRDT_LMT                        --授信额度
    ,ALDY_USE_LMT                    --已用额度
    ,SUR_CRDT_LMT                    --剩余授信额度
    ,EXP_CRDT_LMT                    --敞口授信额度
    ,EXP_ALDY_USE_LMT                --敞口已用额度
    ,EXP_SUR_LMT                     --敞口剩余额度
    ,CUR                             --币种
    ,CRDT_SUBJ_TYP                   --授信主体类型
    ,EFF_DT                          --生效日期
    ,CRDT_STAT                       --授信状态
    ,CRDT_APP_DT                     --授信申请日期
    ,CRDT_START_DT                   --授信开始日期
    ,CRDT_EXP_DT                     --授信到期日期
    ,CRDT_BIZ_TYP                    --授信业务类型
    ,CIR_LMT_FLG                     --循环额度标志
    ,TEMP_LMT_FLG                    --临时额度标志
    ,CRDT_SUBJ_CL                    --授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
    ,DSN_SHT_OPN                     --决策单意见
    ,APRV_PSN_NO                     --审批人工号
    ,CRDT_EMP_NO                     --授信员工号
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,LMT_TYPE_CD                     --额度种类代码
    ,LOAN_HAPP_TYPE_CD               --合同发生类型
    ,RELA_CONT_ID                    --原合同编号
    ,ORG_ID_ORI                      --合同原始机构编号
    ,GROUP_CRDT_FLG                  --集团授信标志
    ,STD_PROD_ID                     --标准产品编号
    ,APPL_WAY_CD                     --申请方式代码
    ,APPROVE_SERIAL_FLOW_NUM         --被动转授信集团批复流水号
    ,APV_FLOW_NUM                    --批复流水号
    ,LMT_UNDER_SELLBL_PROD_ID        --可售产品
    ,APV_AMT                         --批复金额
    ,CRDT_CONT_ID_KHFX               --授信合同编号-客户风险  --ADD BY YJY 20240722
    ,STATUS_CD                       --状态代码 --ADD BY LIP 20241025
    ,CRDT_APVED_DT                   --授信审批日期  --ADD BY YJY 20250114
    ,CUST_ID_ZT_FLG                  --是否系统内转贴现客户标识  ADD BY YJY 20250220
    ,EAST_MON_FLG                    --EAST月口径标识   --ADD BY YJY 20251127
    ,YBT_YEAR_FLG                    --一表通年口径标识 --ADD BY YJY 20251127
    )
  WITH TMP1 AS (
  SELECT T.DATA_DT                         AS DATA_DT                 --数据日期
        ,T.LGL_REP_ID                      AS LGL_REP_ID              --法人编号
        ,T.PRIM_CRDT_CONT_ID               AS PRIM_CRDT_CONT_ID       --主授信合同编号
        ,T.CRDT_CONT_ID                    AS CRDT_CONT_ID            --授信合同编号
        ,NVL(TRIM(T.CRDT_CONT_NM),T.CRDT_CONT_ID) AS CRDT_CONT_NM     --授信合同名称
        ,T.CUST_ID                         AS CUST_ID                 --客户编号
        ,NVL(T.ORG_ID,'800')               AS ORG_ID                  --机构编号
        ,T.CRDT_LMT                        AS CRDT_LMT                --授信额度
        ,SUM(T.ALDY_USE_LMT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID) AS ALDY_USE_LMT --已用额度 --MOD BY YJY 20250220
        ,T.SUR_CRDT_LMT                    AS SUR_CRDT_LMT            --剩余授信额度
        ,T.EXP_CRDT_LMT                    AS EXP_CRDT_LMT            --敞口授信额度
        ,T.EXP_ALDY_USE_LMT                AS EXP_ALDY_USE_LMT        --敞口已用额度
        ,T.EXP_SUR_LMT                     AS EXP_SUR_LMT             --敞口剩余额度
        ,T.CUR                             AS CUR                     --币种
        ,T.CRDT_SUBJ_TYP                   AS CRDT_SUBJ_TYP           --授信主体类型
        ,MIN(T.EFF_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.EFF_DT NULLS LAST) AS EFF_DT --生效日期 --MOD BY YJY 20250220
        --,T.CRDT_STAT                       AS CRDT_STAT               --授信状态
        ,DECODE(T.CRDT_STAT,'Z','N',T.CRDT_STAT) AS CRDT_STAT               --授信状态 --MOD BY YJY 20251127
        ,MIN(T.CRDT_APP_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.CRDT_APP_DT NULLS LAST) AS CRDT_APP_DT --授信申请日期 --MOD BY YJY 20250220
        ,MIN(T.CRDT_START_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.CRDT_START_DT NULLS LAST) AS CRDT_START_DT --授信开始日期 --MOD BY YJY 20250220
        ,MAX(T.CRDT_EXP_DT) OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID ORDER BY T.CRDT_EXP_DT NULLS LAST) AS CRDT_EXP_DT --授信到期日期 --MOD BY YJY 20250220
        ,T.CRDT_BIZ_TYP                    AS CRDT_BIZ_TYP            --授信业务类型
        ,T.CIR_LMT_FLG                     AS CIR_LMT_FLG             --循环额度标志
        ,T.TEMP_LMT_FLG                    AS TEMP_LMT_FLG            --临时额度标志
        ,T.CRDT_SUBJ_CL                    AS CRDT_SUBJ_CL            --授信主体种类
        ,T.BANK_TAX_COOP_LOAN_CRDT_FLG     AS BANK_TAX_COOP_LOAN_CRDT_FLG --银税合作贷款授信标志
        ,NVL(TRIM(T.DSN_SHT_OPN),'同意')   AS DSN_SHT_OPN             --决策单意见
        ,T.APRV_PSN_NO                     AS APRV_PSN_NO             --审批人工号
        ,T.CRDT_EMP_NO                     AS CRDT_EMP_NO             --授信员工号
        ,T.DEPT_LINE                       AS DEPT_LINE               --部门条线
        ,T.DATA_SRC                        AS DATA_SRC                --数据来源
        ,T.LMT_TYPE_CD                     AS LMT_TYPE_CD             --额度类型代码
        ,T.LOAN_HAPP_TYPE_CD               AS LOAN_HAPP_TYPE_CD       --合同发生类型
        ,T.RELA_CONT_ID                    AS RELA_CONT_ID            --原合同编号
        ,T.ORG_ID_ORI                      AS ORG_ID_ORI              --合同原始机构编号
        ,T.GROUP_CRDT_FLG                  AS GROUP_CRDT_FLG          --集团授信标志  ADD BY HULJ20230208
        ,T.STD_PROD_ID                     AS STD_PROD_ID             --标准产品编号
        ,T.APPL_WAY_CD                     AS APPL_WAY_CD             --申请方式代码
        ,T.APPROVE_SERIAL_FLOW_NUM         AS APPROVE_SERIAL_FLOW_NUM --被动转授信集团批复流水号
        ,T.APV_FLOW_NUM                    AS APV_FLOW_NUM            --批复流水号
        ,T.LMT_UNDER_SELLBL_PROD_ID        AS LMT_UNDER_SELLBL_PROD_ID --可售产品
        ,T.APV_AMT                         AS APV_AMT                 --批复金额
        ,T.CRDT_CONT_ID_KHFX               AS CRDT_CONT_ID_KHFX       --授信合同编号-客户风险 --ADD BY YJY 20240722
        ,T.STATUS_CD                       AS STATUS_CD               --状态代码 --ADD BY LIP 20241025
        ,T.CRDT_APVED_DT                   AS CRDT_APVED_DT           --授信审批日期 --ADD BY YJY 20250114
        ,T.CUST_ID_ZT_FLG                  AS CUST_ID_ZT_FLG          --是否系统内转贴现客户标识  ADD BY YJY 20250220
        ,T.EAST_MON_FLG                    AS EAST_MON_FLG            --EAST月口径标识   --ADD BY YJY 20251127
        ,T.YBT_YEAR_FLG                    AS YBT_YEAR_FLG            --一表通年口径标识 --ADD BY YJY 20251127
        ,ROW_NUMBER()OVER(PARTITION BY T.CUST_ID,T.CRDT_CONT_ID,T.PRIM_CRDT_CONT_ID ORDER BY T.CRDT_STAT DESC,T.CRDT_APP_DT DESC NULLS LAST) RN --MOD BY YJY 20250220
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP04 T
   WHERE TRIM(T.CRDT_CONT_ID) IS NOT NULL
     --AND T.CRDT_STAT <> 'Z'
     --AND T.CUST_ID_ZT_FLG <> 'Y' --MOD BY YJY 20251127 --MOD BY LIP 20251203 子表中不过滤转授信的数据，在报表层自行过滤
     )
  SELECT DATA_DT                         --数据日期
        ,LGL_REP_ID                      --法人编号
        ,PRIM_CRDT_CONT_ID               --主授信合同编号
        ,CRDT_CONT_ID                    --授信合同编号
        ,CRDT_CONT_NM                    --授信合同名称
        ,CUST_ID                         --客户编号
        ,ORG_ID                          --机构编号
        ,CASE WHEN NVL(CRDT_LMT,0) < NVL(ALDY_USE_LMT,0) THEN NVL(ALDY_USE_LMT,0)
              ELSE NVL(CRDT_LMT,0)
          END AS ALDY_USE_LMT            --授信额度
        ,ALDY_USE_LMT                    --已用额度
        ,SUR_CRDT_LMT                    --剩余授信额度
        ,EXP_CRDT_LMT                    --敞口授信额度
        ,EXP_ALDY_USE_LMT                --敞口已用额度
        ,EXP_SUR_LMT                     --敞口剩余额度
        ,CUR                             --币种
        ,CRDT_SUBJ_TYP                   --授信主体类型
        ,EFF_DT                          --生效日期
        ,CRDT_STAT                       --授信状态
        ,CASE WHEN CRDT_APP_DT >= CRDT_START_DT THEN CRDT_START_DT --MODIFY BY TANGAN AT 20230129 将<改为>=
              ELSE CRDT_APP_DT
          END AS CRDT_APP_DT             --授信申请日期
        ,CRDT_START_DT                   --授信开始日期
        ,CRDT_EXP_DT                     --授信到期日期
        ,CRDT_BIZ_TYP                    --授信业务类型
        ,CIR_LMT_FLG                     --循环额度标志
        ,TEMP_LMT_FLG                    --临时额度标志
        ,CRDT_SUBJ_CL                    --授信主体种类
        ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
        ,REPLACE(REPLACE(TRIM(DSN_SHT_OPN),CHR(10),''),CHR(13),'') AS DSN_SHT_OPN --决策单意见
        ,APRV_PSN_NO                     --审批人工号
        ,CRDT_EMP_NO                     --授信员工号
        ,DEPT_LINE                       --部门条线
        ,DATA_SRC                        --数据来源
        ,LMT_TYPE_CD                     --额度种类代码
        ,LOAN_HAPP_TYPE_CD               --合同发生类型
        ,RELA_CONT_ID                    --原合同编号
        ,ORG_ID_ORI                      --合同原始机构编号
        ,GROUP_CRDT_FLG                  --集团授信标志
        ,STD_PROD_ID                     --标准产品编号
        ,APPL_WAY_CD                     --申请方式代码
        ,APPROVE_SERIAL_FLOW_NUM         --被动转授信集团批复流水号
        ,APV_FLOW_NUM                    --批复流水号
        ,LMT_UNDER_SELLBL_PROD_ID        --可售产品
        ,APV_AMT                         --批复金额
        ,CRDT_CONT_ID_KHFX               --授信合同编号-客户风险 --ADD BY YJY 20240722
        ,STATUS_CD                       --状态代码 --ADD BY LIP 20241025
        ,CRDT_APVED_DT                   --授信审批日期  --ADD BY YJY 20250114
        ,CUST_ID_ZT_FLG                  --是否系统内转贴现客户标识  ADD BY YJY 20250220
        ,EAST_MON_FLG                    --EAST月口径标识   --ADD BY YJY 20251127
        ,YBT_YEAR_FLG                    --一表通年口径标识 --ADD BY YJY 20251127
    FROM TMP1
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '授信额度主表--整合到客户临时表'; --24
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.M_CRDT_LMT_INFO_TEMP07
    (DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,PRIM_CRDT_CONT_ID                  --主授信合同编号
    ,PRIM_CRDT_CONT_NM                  --主授信合同名称
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,CUR                                --币种
    ,CRDT_TOTAL_LMT                     --授信总额度
    ,ALDY_USE_LMT                       --已用额度
    ,EXP_CRDT_LMT                       --敞口授信额度
    ,EXP_ALDY_USE_LMT                   --敞口已用额度
    ,OPR_CRDT_TOT_AMT                   --经营授信总额
    ,OPR_ALDY_USE_CRDT_TOT_AMT          --经营已用授信总额
    ,HSE_CRDT_LMT                       --住房授信额度
    ,HSE_ALDY_USE_CRDT_LMT              --住房已用授信额度
    ,CAR_LOAN_CRDT_LMT                  --车贷授信额度
    ,CAR_LOAN_ALDY_USE_CRDT_LMT         --车贷已用授信额度
    ,SL_CRDT_LMT                        --助学授信额度
    ,SL_ALDY_USE_CRDT_LMT               --助学已用授信额度
    ,OTH_CNSMP_CRDT_LMT                 --其他消费授信额度
    ,OTH_CNSMP_ALDY_USE_CRDT_LMT        --其他消费已用授信额度
    ,CRDT_STAT                          --授信状态
    ,FIRST_CRDT_DT                      --首次授信日期
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,CRDT_APP_DT                        --授信申请信息
    ,CRDT_START_DT                      --授信开始日期
    ,CRDT_EXP_DT                        --授信到期日期
    ,CRDT_APVED_DT                      --授信审批日期  --ADD BY YJY 20250114
    ,CRDT_TOTAL_LMT_ZT                  --授信总额度（系统内转贴现） --ADD BY YJY 20250220
    ,ALDY_USE_LMT_ZT                    --已用额度（系统内转贴现） --ADD BY YJY 20250220
    )
  WITH TMP AS (
  SELECT A.CRDT_CONT_ID AS CRDT_CONT_ID
        ,CASE WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100101' THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100102' THEN '010302' --房屋装修贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD IN ('100109') THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0102%' AND TA.BORW_USAGE_TYPE_CD IN ('100201') THEN '010202' --商用车贷款
              WHEN A.BUS_BREED_ID IN ('201030200001','201030200002','201030200003') THEN '010101' --个人住房按揭商业贷款
              WHEN A.BUS_BREED_ID IN ('201030200001','201030200002') AND TA.BORW_USAGE_TYPE_CD <> '100301' THEN '010101' --个人中长期住房贷款(个人住房按揭商业贷款)
              WHEN A.BUS_BREED_ID IN ('201030100001','201030100002') AND TA.BORW_USAGE_TYPE_CD = '100301' THEN '010201' --个人中长期住房贷款(商业用房贷款)
              WHEN B.CUST_ID IS NOT NULL AND A.STD_PROD_ID = '203030500015' THEN '010299' --个人经营性贷款（兴付贷贸易融资） ADD BY YJY 20241210
              ELSE NVL(TTA.TAR_VALUE_CODE,A.BUS_BREED_ID)
          END AS LOAN_BIZ_TYP --业务品种
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP04 A
    --ADD BY YJY 20241210 取对公里个体工商户部分数据
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B --对公客户基本信息
      ON B.CUST_ID = A.CUST_ID
     AND TRIM(B.SOCI_CRDT_CD) IS NOT NULL
     AND LENGTH(B.SOCI_CRDT_CD) = 18
     AND SUBSTR(B.SOCI_CRDT_CD,1,2) = '92'
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO TA --零售贷款合同信息表
      ON TA.CONT_ID = A.CRDT_CONT_ID
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO TB --零售贷款授信额度信息
      ON TB.LMT_CONT_ID = A.CRDT_CONT_ID
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTA --码值映射表(贷款类型)
      ON TTA.SRC_VALUE_CODE = A.BUS_BREED_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
   WHERE A.CUST_ID_ZT_FLG IN ('Z')) --MODIFY BY LWB 20250311
  SELECT  V_P_DATE                                       AS DATA_DT                            --数据日期
         ,MIN(A.LGL_REP_ID)                              AS LGL_REP_ID                         --法人编号
         --客户维度不需要这两个字段 ADD BY LIUYU
         ,''                                             AS PRIM_CRDT_CONT_ID                  --主授信合同编号
         ,''                                             AS PRIM_CRDT_CONT_NM                  --主授信合同名称
         ,A.CUST_ID                                      AS CUST_ID                            --客户编号
         ,MAX(A.ORG_ID)                                  AS ORG_ID                             --机构编号
         ,'CNY'                                          AS CUR                                --币种
         --MOD BY YJY 20250220 剔除系统内转贴现转授信
         ,CASE WHEN SUM(CASE WHEN A.CRDT_STAT = 'Z' THEN 0
                             WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                  < SUM(CASE WHEN A.CRDT_STAT = 'Z' THEN 0
                             WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN A.CRDT_STAT = 'Z' THEN 0
                             WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END )
               ELSE SUM(CASE WHEN A.CRDT_STAT = 'Z' THEN 0
                             WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END )
           END                                           AS CRDT_TOTAL_LMT                     --授信总额度
          --MOD BY YJY 20250220 剔除系统内转贴现转授信
         ,SUM(CASE WHEN A.CRDT_STAT = 'Z' THEN 0
                   WHEN A.CUST_ID_ZT_FLG IN ('Z','N')
                   THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1)
                   ELSE 0
               END)                                      AS ALDY_USE_LMT                       --已用额度
         ,NULL                                           AS EXP_CRDT_LMT                       --敞口授信额度
         ,NULL                                           AS EXP_ALDY_USE_LMT                   --敞口已用额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                  < SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
           END                                           AS OPR_CRDT_TOT_AMT                   --经营授信总额
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%'
                   THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1)
                   ELSE 0
               END)                                      AS OPR_ALDY_USE_CRDT_TOT_AMT          --经营已用授信总额
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                  < SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
           END                                           AS HSE_CRDT_LMT                       --住房授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%'
                   THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1)
                   ELSE 0
               END)                                      AS HSE_ALDY_USE_CRDT_LMT              --住房已用授信额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                  < SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
           END                                           AS CAR_LOAN_CRDT_LMT                  --车贷授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301'
                   THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1)
                   ELSE 0
               END)                                      AS CAR_LOAN_ALDY_USE_CRDT_LMT         --车贷已用授信额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                  < SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
           END                                           AS SL_CRDT_LMT                        --助学授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%'
                   THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1)
                   ELSE 0
               END)                                      AS SL_ALDY_USE_CRDT_LMT               --助学已用授信额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                  < SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
           END                                           AS OTH_CNSMP_CRDT_LMT                 --其他消费授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399'
                   THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1)
                   ELSE 0
               END)                                      AS OTH_CNSMP_ALDY_USE_CRDT_LMT        --其他消费已用授信额度
         ,'Y'                                            AS CRDT_STAT                          --授信状态
         ,MIN(B.FIRST_CRDT_DT)                           AS FIRST_CRDT_DT                      --首次授信日期
         ,MIN(A.DEPT_LINE)                               AS DEPT_LINE                          --部门条线
         ,MIN(A.DATA_SRC)                                AS DATA_SRC                           --数据来源
         ,MIN(A.EFF_DT)                                  AS CRDT_APP_DT                        --授信申请日期
         ,MIN(A.CRDT_START_DT)                           AS CRDT_START_DT                      --授信开始日期
         ,MAX(A.CRDT_EXP_DT)                             AS CRDT_EXP_DT                        --授信结束日期
         ,MAX(A.CRDT_APVED_DT)                           AS CRDT_APVED_DT                      --授信审批日期 --ADD BY YJY 20250114
         --以下两个字段系统内转贴现客户转直贴客户的授信
         ,CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG = 'Z' THEN 1 ELSE 0 END)>0
                --当客户存在非系统内转贴现业务时，优先取之前的逻辑
               THEN CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                            < SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
                         THEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END )
                         ELSE SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END )
                     END
               ELSE CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.CRDT_LMT,0) ELSE 0 END )
                            < SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0 ) ELSE 0 END)
                         THEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
                         ELSE SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
                     END
           END                                            AS CRDT_TOTAL_LMT_ZT                --授信总额度（系统内转贴现）ADD BY YJY 20250220
         ,CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG = 'Z' THEN 1 ELSE 0 END)>0
               --当客户存在非系统内转贴现业务时，优先取之前的逻辑
               THEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
               ELSE SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
           END                                            AS ALDY_USE_LMT_ZT                 --已用额度（系统内转贴现） ADD BY YJY 20250220
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP04 A --授信额度主表临时表含授信维度
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO_TEMP05 B --首次授信日期
      ON B.CUST_ID = A.CUST_ID
    LEFT JOIN TMP C --根据业务品种划分经营和消费
      ON C.CRDT_CONT_ID = A.CRDT_CONT_ID
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D --汇率表
      ON D.BASE_CUR = A.CUR
     AND D.CNV_CUR = 'CNY'
     AND D.DATA_DT = V_P_DATE
   WHERE A.DATA_DT = V_P_DATE
     AND A.CRDT_STAT IN ('Y','Z') --ADD BY LIUYU 取有效额度统计授信总额
   GROUP BY A.CUST_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '授信额度主表--整合到客户'; --25
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.M_CRDT_LMT_INFO
    (DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,PRIM_CRDT_CONT_ID                  --主授信合同编号
    ,PRIM_CRDT_CONT_NM                  --主授信合同名称
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,CUR                                --币种
    ,CRDT_TOTAL_LMT                     --授信总额度
    ,ALDY_USE_LMT                       --已用额度
    ,EXP_CRDT_LMT                       --敞口授信额度
    ,EXP_ALDY_USE_LMT                   --敞口已用额度
    ,OPR_CRDT_TOT_AMT                   --经营授信总额
    ,OPR_ALDY_USE_CRDT_TOT_AMT          --经营已用授信总额
    ,HSE_CRDT_LMT                       --住房授信额度
    ,HSE_ALDY_USE_CRDT_LMT              --住房已用授信额度
    ,CAR_LOAN_CRDT_LMT                  --车贷授信额度
    ,CAR_LOAN_ALDY_USE_CRDT_LMT         --车贷已用授信额度
    ,SL_CRDT_LMT                        --助学授信额度
    ,SL_ALDY_USE_CRDT_LMT               --助学已用授信额度
    ,OTH_CNSMP_CRDT_LMT                 --其他消费授信额度
    ,OTH_CNSMP_ALDY_USE_CRDT_LMT        --其他消费已用授信额度
    ,CRDT_STAT                          --授信状态
    ,FIRST_CRDT_DT                      --首次授信日期
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,CRDT_APP_DT                        --授信申请信息
    ,CRDT_START_DT                      --授信开始日期
    ,CRDT_EXP_DT                        --授信到期日期
    ,CRDT_APVED_DT                      --授信审批日期  --ADD BY YJY 20250114
    ,CRDT_TOTAL_LMT_ZT                  --授信总额度（系统内转贴现） --ADD BY YJY 20250220
    ,ALDY_USE_LMT_ZT                    --已用额度（系统内转贴现） --ADD BY YJY 20250220
    )
  WITH TMP AS (
  SELECT T6.CUST_ID_ZT AS CUST_ID,
         SUM(T6.LOAN_AMT) LOAN_AMT
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 T6
   WHERE T6.CUST_ID_ZT NOT LIKE '1%'
     AND NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0 --筛选有余额的直贴人的客户明细
   GROUP BY T6.CUST_ID_ZT),
  TMP2 AS (
  SELECT A.CUST_ID                 AS CUST_ID,               --客户编号
         CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.CRDT_LMT,0) ELSE 0 END )
                 < SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0 ) ELSE 0 END)
              THEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
              ELSE SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
          END                      AS CRDT_TOTAL_LMT_ZT_NEW, --统计所有授信额度的逻辑
         CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG = 'Z' THEN 1 ELSE 0 END) > 0
              --当客户存在非系统内转贴现业务时，优先取之前的逻辑
              THEN CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                           < SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
                        THEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END )
                        ELSE SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END )
                    END
              ELSE CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.CRDT_LMT,0) ELSE 0 END )
                           < SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0 ) ELSE 0 END)
                        THEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
                        ELSE SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.CRDT_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
                   END
          END                      AS CRDT_TOTAL_LMT_ZT,     --授信总额度（系统内转贴现） ADD BY YJY 20250220
         SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END) AS ALDY_USE_LMT_ZT_NEW,
         CASE WHEN SUM(CASE WHEN A.CUST_ID_ZT_FLG = 'Z' THEN 1 ELSE 0 END) > 0 --当客户存在非系统内转贴现业务时，优先取之前的逻辑
              THEN SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','N') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
              ELSE SUM(CASE WHEN A.CUST_ID_ZT_FLG IN ('Z','Y') THEN NVL(A.ALDY_USE_LMT,0) * NVL(D.EXRT,1) ELSE 0 END)
          END                      AS ALDY_USE_LMT_ZT        --已用额度（系统内转贴现） ADD BY YJY 20250220
           FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP04 A --授信额度主表临时表含授信维度
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D --汇率表
      ON D.BASE_CUR = A.CUR
     AND D.CNV_CUR = 'CNY'
     AND D.DATA_DT = V_P_DATE
   WHERE A.CRDT_STAT IN ('Y','Z') --ADD BY LIUYU 取有效额度统计授信总额
     AND A.CUST_ID NOT LIKE '1%'
     AND A.DATA_DT = V_P_DATE
   GROUP BY A.CUST_ID),
  TMP3 AS (
  SELECT T1.CUST_ID,
         CASE WHEN T1.CRDT_TOTAL_LMT_ZT < T2.LOAN_AMT THEN T1.CRDT_TOTAL_LMT_ZT_NEW
              ELSE T1.CRDT_TOTAL_LMT_ZT
          END AS CRDT_TOTAL_LMT_ZT,
         CASE WHEN T1.ALDY_USE_LMT_ZT < T2.LOAN_AMT THEN T1.ALDY_USE_LMT_ZT_NEW
              ELSE T1.ALDY_USE_LMT_ZT
          END AS ALDY_USE_LMT_ZT
    FROM TMP2 T1
   INNER JOIN TMP T2 ON T2.CUST_ID = T1.CUST_ID)
  SELECT  V_P_DATE                                     AS DATA_DT                     --数据日期
         ,A.LGL_REP_ID                                 AS LGL_REP_ID                  --法人编号
         ,A.PRIM_CRDT_CONT_ID                          AS PRIM_CRDT_CONT_ID           --主授信合同编号
         ,A.PRIM_CRDT_CONT_NM                          AS PRIM_CRDT_CONT_NM           --主授信合同名称
         ,A.CUST_ID                                    AS CUST_ID                     --客户编号
         ,A.ORG_ID                                     AS ORG_ID                      --机构编号
         ,A.CUR                                        AS CUR                         --币种
         ,A.CRDT_TOTAL_LMT                             AS CRDT_TOTAL_LMT              --授信总额度
         ,A.ALDY_USE_LMT                               AS ALDY_USE_LMT                --已用额度
         ,A.EXP_CRDT_LMT                               AS EXP_CRDT_LMT                --敞口授信额度
         ,A.EXP_ALDY_USE_LMT                           AS EXP_ALDY_USE_LMT            --敞口已用额度
         ,A.OPR_CRDT_TOT_AMT                           AS OPR_CRDT_TOT_AMT            --经营授信总额
         ,A.OPR_ALDY_USE_CRDT_TOT_AMT                  AS OPR_ALDY_USE_CRDT_TOT_AMT   --经营已用授信总额
         ,A.HSE_CRDT_LMT                               AS HSE_CRDT_LMT                --住房授信额度
         ,A.HSE_ALDY_USE_CRDT_LMT                      AS HSE_ALDY_USE_CRDT_LMT       --住房已用授信额度
         ,A.CAR_LOAN_CRDT_LMT                          AS CAR_LOAN_CRDT_LMT           --车贷授信额度
         ,A.CAR_LOAN_ALDY_USE_CRDT_LMT                 AS CAR_LOAN_ALDY_USE_CRDT_LMT  --车贷已用授信额度
         ,A.SL_CRDT_LMT                                AS SL_CRDT_LMT                 --助学授信额度
         ,A.SL_ALDY_USE_CRDT_LMT                       AS SL_ALDY_USE_CRDT_LMT        --助学已用授信额度
         ,A.OTH_CNSMP_CRDT_LMT                         AS OTH_CNSMP_CRDT_LMT          --其他消费授信额度
         ,A.OTH_CNSMP_ALDY_USE_CRDT_LMT                AS OTH_CNSMP_ALDY_USE_CRDT_LMT --其他消费已用授信额度
         ,A.CRDT_STAT                                  AS CRDT_STAT                   --授信状态
         ,A.FIRST_CRDT_DT                              AS FIRST_CRDT_DT               --首次授信日期
         ,A.DEPT_LINE                                  AS DEPT_LINE                   --部门条线
         ,A.DATA_SRC                                   AS DATA_SRC                    --数据来源
         ,A.CRDT_APP_DT                                AS CRDT_APP_DT                 --授信申请日期
         ,A.CRDT_START_DT                              AS CRDT_START_DT               --授信开始日期
         ,A.CRDT_EXP_DT                                AS CRDT_EXP_DT                 --授信结束日期
         ,A.CRDT_APVED_DT                              AS CRDT_APVED_DT               --授信审批日期  --ADD BY YJY 20250114
         --以下两个字段系统内转贴现客户转直贴客户的授信
         ,CASE WHEN A.CUST_ID = B.CUST_ID THEN B.CRDT_TOTAL_LMT_ZT
               ELSE A.CRDT_TOTAL_LMT_ZT
           END                                         AS CRDT_TOTAL_LMT_ZT           --授信总额度（系统内转贴现）ADD BY YJY 20250220
         ,CASE WHEN A.CUST_ID = B.CUST_ID THEN B.ALDY_USE_LMT_ZT
               ELSE A.ALDY_USE_LMT_ZT
           END                                         AS ALDY_USE_LMT_ZT             --已用额度（系统内转贴现） ADD BY YJY 20250220
    FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP07 A --授信额度主表临时表含授信维度
    LEFT JOIN TMP3 B --专门处理直贴客户有余额借用他人授信
      ON B.CUST_ID = A.CUST_ID
   WHERE 1 = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'M_CRDT_LMT_SUB是否重复';--26
  V_STARTTIME := SYSDATE;
  WITH TMP2 AS (
  SELECT DATA_DT,CRDT_CONT_ID,CUST_ID,CUST_ID_ZT_FLG,COUNT(1) AS CT
    FROM RRP_MDL.M_CRDT_LMT_SUB
   WHERE DATA_DT = V_P_DATE
     AND CUST_ID_ZT_FLG <> 'Y'
   GROUP BY DATA_DT,CRDT_CONT_ID,CUST_ID,CUST_ID_ZT_FLG --MOD BY YJY 202502220
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP2;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG   := 'M_CRDT_LMT_SUB数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME2,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'M_CRDT_LMT_INFO是否重复'; --27
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,CUST_ID,COUNT(1) AS CT
    FROM RRP_MDL.M_CRDT_LMT_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CUST_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG   := 'M_CRDT_LMT_INFO数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := V_TAB_NAME||'表分析';
  V_STARTTIME := SYSDATE;

  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := V_TAB_NAME2||'表分析';
  V_STARTTIME := SYSDATE;

  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME2, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME2,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分--
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CRDT_LMT_INFO;
/

