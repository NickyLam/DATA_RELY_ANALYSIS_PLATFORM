CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_LOAN_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_TRA_LOAN_DTL
  *  功能描述：监管集市所有影响个人信贷账户、对公信贷账户余额变动的交易信息，不包括查询交易，经审核暂时只规定本金的交易，
  *            不包含利息的交易，具体票据贴现情况根据项目情况实施反馈后再给公司反馈修改。
  *  创建日期：20220526
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO         --内部机构信息
  *            ICL.CMM_UNITE_WL_DUBIL_INFO     --联合网贷借据信息
  *            ICL.CMM_UNITE_WL_WRT_OFF_INFO   --联合网贷核销信息
  *            ICL.CMM_INDV_CUST_BASIC_INFO    --个人客户基本信息
  *            ICL.CMM_SUBJ_INFO               --科目信息
  *            ICL.CMM_TELLER_INFO             --柜员信息
  *            ICL.CMM_UNITE_WL_DISTR_DTL      --联合网贷放款明细
  *            ICL.CMM_RETL_LOAN_ACCT_INFO     --零售贷款账户信息
  *            ICL.CMM_RETL_LOAN_DUBIL_INFO    --零售贷款借据信息
  *            ICL.CMM_DEP_CUST_ACCT_INFO      --存款主账户信息
  *            IML.AGT_RETL_LOAN_ASSET_TRAN_H  --零售贷款账户资产转让历史
  *  目标表：  M_TRA_LOAN_DTL  --信贷账户交易流水
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221111  HULJ     调整逻辑,增加数据重复校验。
  *             2    20230424  XUXIAOBIN 修改贴现相关逻辑关联条件
  *             3    20230523  MW       调整联合网贷放款条件
  *             4    20230529  MW       调整联合网贷流水号逻辑
  *             5    20230530  LIP      调整对手方账号的取数口径
  *             6    20230711  LIP      增加对公贷款结息发放数据
  *             7    20230727  LIP      调整平安普惠的发放和收回的对方账号，受托支付的还款账号
  *             8    20230802  YANG     修改微粒贷还款流水交易时间逻辑
  *             9    20230802  LIP      修改微粒贷还款流水交易时间逻辑，及冲补抹标志
  *             10   20230828  LIP      票据提示付款的数据剔除客户发起的数据
  *             11   20240716  LIP      将TRA_TLR_NO取的是客户经理工号的置空
  *             12   20241009  LIP      排除有回退流水的流水号和排除冲正数据
  *             13   20241021  LIP      203030200001-国内信用证项下议付、203030600001-国内信用证项下福费廷产品的交易对手取数口径调整
  *             14   20241112  LIP      信贷账户交易流水--贴现到期/卖出_IMAS：同一天内转贴现多次的，增加创建日期的排序
  *             15   20250113  YJY      新增房抵贷（网商引流）产品的贷款收回、放款、核销逻辑
  *             16   20250218  YJY      调整联合网贷部分的放款、收回、核销逻辑，新增对微业贷产品的判断
  *             17   20250310  LIP      调整华兴易贷的对方账号及相关信息
  *             18   20250331  YJY      优化脚本，标准产品编号取STD_PROD_ID
  *             19   20250401  YJY      优化房抵贷贷款发放部分的逻辑
  *             20   20250414  YJY      调整微业贷产品的对公对私标志逻辑
  *             20   20250415  LIP      行内自营贷款贷后还款需求，调整成非合同登记的账号还款情况下的交易对手
  *             21   20250429  YJY      字节小微贷会存在一笔还款交易流水对应多笔借据的请款，调整联合网贷收回部分的交易流水逻辑
  *             22   20250521  YJY      修改联合网贷部分的借据号，取核心借据编号
  *             23   20250606  LIP      曹宁宁贷后需求，非挂账情况下的处理,用非合同登记的还款账号还款情况
  *             24   20250613  YJY      新增联合网贷产品字节放心借202010200009
  *             25   20250616  LIP      调整保理的放款流水的对方账号取数口径
  *             26   20250709  LIP      调整201010300041华兴好易贷（华强）的部分字段的取数口径
  *             27   20250717  YJY      新增联合网贷产品1）新增分期乐系列产品：分期乐乐金卡，产品编码202010200011；分期乐消费，产品编号202010200010
                                                       2）新增唯品消金产品：202010100007
  *             28   20250725  YJY      回退联合网贷部分的借据号
  *             29   20250728  LIP      字节小微存在账务处理时间和实际还款日期不一致的问题，且明细是增量数据，注释还款日期限制条件
  *             30   20250903  LIP      调整对方行号相关取数逻辑
  *             31   20250912  LIP      一表通：增加对公信贷放款的出账的审批人员 
  *             32   20251028  LIP      根据严希婧口径：对公贷款放款部分：贸易融资的账户余额是本金-利息调整
  *             33   20251104  YJY      调整联合网贷分期乐、好企贷-数据贷（微业贷3.0）产品放款部分的放款日期限制、以及核销部分的核销日期限制
  *             34   20251113  LIP      增加新票追索结清的流水数据
  *             35   20251120  YJY      新增203050100002-微众对公联合贷（微业贷4.0）产品
  *             36   20251209  LIP      出口代付的入账账号取国结登记的收款人账号
  *             37   20251215  HYF      修改摘要描述补充收益权转让用以区分
  *             38   20260106  YJY      经业务刘巳确认，产品202010100009富民联合贷消费、202020100002富民联合贷经营的交易渠道为抖音支付
  **********************************************************/
AS
  -- 定义变量 --
  --V_DATE      DATE;                 --数据日期(判断输入参数日期格式是否准确)
  V_STEP      INTEGER := 0;         --处理步骤
  V_STEP_DESC VARCHAR2(100);        --处理步骤描述
  V_P_DATE    VARCHAR2(8);          --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);        --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_TRA_LOAN_DTL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TRA_LOAN_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  V_P_DATE := I_P_DATE; --获取跑批日期
  --V_DATE := TO_DATE(I_P_DATE,'YYYYMMDD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_TRA_LOAN_DTL T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('alter session enable parallel dml');
  ETL_PARTITION_ADD(V_P_DATE,'M_TRA_LOAN_DTL','1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '||'M_TRA_LOAN_DTL'||' TRUNCATE PARTITION '||'PARTITION_'||V_P_DATE);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--人行支付行号与行名映射关系1';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP04';
  INSERT /*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP04
    (MEM_ORG_CD
    ,MEM_ORG_ID
    ,ORG_CN_FNAME
    ,ORG_CN_ABBR
    ,SYS_PRTCPTR_BIGAMT_BANK_NO
    ,DIST_CD     --行政区划代码
    ,SYS_PRTCPTR_BIGAMT_BANK_NAME
    ,RANK_RN
    )
  SELECT  TRIM(TTA.MEM_ORG_CD)       AS MEM_ORG_CD     --会员机构代码
         ,TRIM(TTA.MEM_ORG_ID)       AS MEM_ORG_ID     --会员机构编号
         ,TRIM(TTA.ORG_CN_FNAME)     AS ORG_CN_FNAME   --机构中文全称
         ,TRIM(TTA.ORG_CN_ABBR)      AS ORG_CN_ABBR    --机构中文简称
         ,TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) AS SYS_PRTCPTR_BIGAMT_BANK_NO  --系统参与者大额行号
         ,TRIM(TTA.DIST_CD)          AS DIST_CD        --行政区划代码
         ,CASE WHEN NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),'0') <> '0'
               THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME)
               ELSE TRIM(TTA.ORG_CN_FNAME)
          END                        AS SYS_PRTCPTR_BIGAMT_BANK_NAME  --系统参与者大额行名
         ,RANK                       AS RN
    FROM RRP_MDL.O_IML_PTY_CPES_MEM TTA --票交所会员 只有一天数据
   WHERE TTA.ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--人行支付行号与行名映射关系2';
  V_STARTTIME := SYSDATE;
  INSERT/*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP04
  (  MEM_ORG_CD
    ,MEM_ORG_ID
    ,ORG_CN_FNAME
    ,ORG_CN_ABBR
    ,SYS_PRTCPTR_BIGAMT_BANK_NO
    ,SYS_PRTCPTR_BIGAMT_BANK_NAME
    ,RANK_RN
    )
  SELECT  TRIM(T.PBC_PAY_BANK_NO) AS MEM_ORG_CD        --会员机构代码
         ,TRIM(T.PBC_PAY_BANK_NO) AS MEM_ORG_ID        --会员机构编号
         ,TRIM(T.CUST_NAME)       AS ORG_CN_FNAME      --机构中文全称
         ,TRIM(T.CUST_NAME)       AS ORG_CN_ABBR       --机构中文简称
         ,TRIM(T.PBC_PAY_BANK_NO) AS SYS_PRTCPTR_BIGAMT_BANK_NO     --系统参与者大额行号
         ,TRIM(T.CUST_NAME)       AS SYS_PRTCPTR_BIGAMT_BANK_NAME   --系统参与者大额行名
         ,ROW_NUMBER() OVER(PARTITION BY TRIM(T.CUST_NAME) ORDER BY TRIM(T.CUST_NAME) NULLS LAST) RN
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T --对公客户信息表
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TA
      ON TA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T.PBC_PAY_BANK_NO)
   WHERE TRIM(T.PBC_PAY_BANK_NO) IS NOT NULL
     AND TA.SYS_PRTCPTR_BIGAMT_BANK_NO IS NULL
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--将主账户和内部户账户汇总1';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP01';
  COMMIT;
  INSERT/*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP01
    (CUST_ACCT_ID             --账户编号
    ,CUST_ACCT_NAME           --账户户名
    ,ACCT_BELONG_ORG_ID       --账户所属机构
    ,ORG_ID1                  --账户所属机构映射报送机构
    ,FIN_INST_CODE            --银行机构代码
    ,FIN_LICS_NUM             --金融许可证号
    ,ORG_NAME                 --银行机构名称
    ,COUNTY_CD                --机构地区
    ,PBC_PAY_BANK_NO          --人行支付行号
    )
    WITH TMP1 AS (
      SELECT /*+MATERIALIZE*/
              CUST_ACCT_ID
             ,CUST_ACCT_NAME
             ,NVL(TRIM(ACCT_BELONG_ORG_ID),TRIM(OPEN_ACCT_ORG_ID)) AS BELONG_ORG_ID
        FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO
       WHERE TRIM(CUST_ACCT_ID) IS NOT NULL
         AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       UNION ALL
      SELECT  CUST_ACCT_CARD_NO AS CUST_ACCT_ID
             ,CUST_ACCT_NAME
             ,NVL(TRIM(ACCT_BELONG_ORG_ID),TRIM(OPEN_ACCT_ORG_ID)) AS BELONG_ORG_ID
        FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO
       WHERE TRIM(CUST_ACCT_CARD_NO) IS NOT NULL
         AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
     TMP2 AS (--MODIFY BY TANGAN AT 20230111  新核心跟旧核心主张户存储方式有变化，以前有卡有折的账户，会卡和折各一条，新核心是账号放折号，卡号放卡号，只有一条数据，数仓CMM_DEP_ACCT_INFO模型新增了字段【CUST_ACCT_CARD_NO-客户账户卡号】用来存放卡号。有卡有折的情况CUST_ACCT_ID-放的是折号，CUST_ACCT_CARD_NO-放的是卡号。
         SELECT /*+MATERIALIZE*/
                T.CUST_ACCT_ID
                ,MAX(T.CUST_ACCT_NAME) AS CUST_ACCT_NAME
                ,MAX(BELONG_ORG_ID) AS BELONG_ORG_ID
           FROM TMP1 T
         GROUP BY T.CUST_ACCT_ID)
  SELECT  A.CUST_ACCT_ID             --账户编号
         ,A.CUST_ACCT_NAME           --账户户名
         ,A.BELONG_ORG_ID  AS ACCT_BELONG_ORG_ID       --账户所属机构
         ,B.ORG_ID                   --账户所属机构映射报送机构
         ,B.FIN_INST_CODE            --银行机构代码
         ,B.FIN_LICS_NUM             --金融许可证号
         ,B.BKNAME                   --银行机构名称 --MOD BY LIP 20230810
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
         ,B.FIN_INST_CODE             --人行支付行号
    /*FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息*/
    FROM TMP2 A
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C--内部机构信息表
      ON C.ORG_ID = A.BELONG_ORG_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--将主账户和内部户账户汇总2';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL */INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP01
    (CUST_ACCT_ID             --账户编号
    ,CUST_ACCT_NAME           --账户户名
    ,ACCT_BELONG_ORG_ID       --账户所属机构
    ,ORG_ID1                  --账户所属机构映射报送机构
    ,FIN_INST_CODE            --银行机构代码
    ,FIN_LICS_NUM             --金融许可证号
    ,ORG_NAME                 --银行机构名称
    ,COUNTY_CD                --机构地区
    ,PBC_PAY_BANK_NO          --人行支付行号
    )
  SELECT  A.ACCT_ID      AS CUST_ACCT_ID              --账户编号 --MODIFY BY HULJ 20221021
         ,A.ACCT_NAME    AS CUST_ACCT_NAME            --账户户名
         ,TRIM(A.BELONG_ORG_ID) AS ACCT_BELONG_ORG_ID --账户所属机构
         ,B.ORG_ID1                                   --账户所属机构映射报送机构
         ,B.FIN_INST_CODE                             --银行机构代码
         ,B.FIN_LICS_NUM                              --金融许可证号
         ,B.BKNAME                                    --银行机构名称 --MOD BY LIP 20230810
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
         ,B.FIN_INST_CODE                            --人行支付行号
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = TRIM(A.BELONG_ORG_ID)
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY 20240311 增加从银行卡信息表中获取卡信息逻辑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--将主账户和内部户账户汇总3';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP01
    (CUST_ACCT_ID             --账户编号
    ,CUST_ACCT_NAME           --账户户名
    ,ACCT_BELONG_ORG_ID       --账户所属机构
    ,ORG_ID1                  --账户所属机构映射报送机构
    ,FIN_INST_CODE            --银行机构代码
    ,FIN_LICS_NUM             --金融许可证号
    ,ORG_NAME                 --银行机构名称
    ,COUNTY_CD                --机构地区
    ,PBC_PAY_BANK_NO          --人行支付行号
    )
  SELECT  A.CARD_NO    AS CUST_ACCT_ID              --账户编号
         ,A.CARD_NAME  AS CUST_ACCT_NAME            --账户户名
         ,TRIM(A.CARD_ISS_ORG_ID) AS ACCT_BELONG_ORG_ID  --账户所属机构
         ,B.ORG_ID1                                 --账户所属机构映射报送机构
         ,B.FIN_INST_CODE                           --银行机构代码
         ,B.FIN_LICS_NUM                            --金融许可证号
         ,B.BKNAME                                  --银行机构名称
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
         ,B.FIN_INST_CODE                             --人行支付行号
    FROM RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO A --银行卡基本信息
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = TRIM(A.CARD_ISS_ORG_ID)
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 D
      ON D.CUST_ACCT_ID = A.CARD_NO
   WHERE D.CUST_ACCT_ID IS NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY 20240229 加工一二级福费廷转让的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水-一二级福费廷转让对方账号临时表处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP05';
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP05
    (RCPT_ID              --借据号
    ,STD_PROD_ID          --标准产品编号
    ,TRA_DR_CR_FLG        --交易借贷标志
    ,OPP_ACC              --对方账号
    ,OPP_ACC_NM           --对方户名
    ,OPP_PBC_NO           --对方行号
    ,OPP_BANK_NM          --对方行名
    )
  SELECT  TB.DUBIL_ID                             AS RCPT_ID              --借据号
         ,TD.STD_PROD_ID                          AS STD_PROD_ID          --标准产品编号
         ,'C'                                     AS TRA_DR_CR_FLG        --交易借贷标志 --贷 收回
         ,TRIM(TA.CAP_SRC_ACCT_ID)                AS OPP_ACC              --对方账号
         ,TRIM(TA.CAP_SRC_ACCT_NAME)              AS OPP_ACC_NM           --对方户名
         ,TRIM(TA.CAP_SRC_BANK_NO)                AS OPP_PBC_NO           --对方行号
         ,TRIM(TC.BKNAME)                         AS OPP_BANK_NM          --对方行名
    FROM RRP_MDL.O_IOL_ICMS_ACCT_TRANSACTION T
   INNER JOIN RRP_MDL.O_IML_AGT_FFT_TRAN_TOT_TAB TA
      ON TA.FLOW_NUM = T.DOCUMENTNO
     AND TRIM(TA.CAP_SRC_ACCT_ID) IS NOT NULL
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_AGT_FFT_TRAN_DTL TB
      ON TB.FLOW_NUM = TA.FLOW_NUM
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO TC
      ON TC.BKCD = TA.CAP_SRC_BANK_NO
     AND TC.ID_MARK <> 'D'
     AND TC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TD
      ON TD.DUBIL_ID = TB.DUBIL_ID
     AND TD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.DOCUMENTTYPE = 'jbo.acct.ACCT_TRANS_FFT'
     AND T.TRANSCODE = '2003'
     AND T.TRANSSTATUS = 'Finished'
     AND TRIM(T.FALLBACKTRANSSERIALNO) IS NULL --MOD BY 20241009 排除有回退流水的
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY 20240229 加工二级福费廷买入的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水-二级福费廷买入对方账号临时表处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP05
    (RCPT_ID              --借据号
    ,STD_PROD_ID          --标准产品编号
    ,TRA_DR_CR_FLG        --交易借贷标志
    ,OPP_ACC              --对方账号
    ,OPP_ACC_NM           --对方户名
    ,OPP_PBC_NO           --对方行号
    ,OPP_BANK_NM          --对方行名
    )
  SELECT  TA.DUBIL_ID                             AS RCPT_ID              --借据号
         ,TA.STD_PROD_ID                          AS STD_PROD_ID          --标准产品编号
         ,'D'                                     AS TRA_DR_CR_FLG        --交易借贷标志 --借 买入
         ,TRIM(T.CNTPTY_RECVBL_ACCT_ID)           AS OPP_ACC              --对方账号
         ,TRIM(T.CNTPTY_RECVBL_ACCT_NAME)         AS OPP_ACC_NM           --对方户名
         ,TRIM(T.CNTPTY_RECVBL_BANK_NO)           AS OPP_PBC_NO           --对方行号
         ,TRIM(T.CNTPTY_RECVBL_BANK_NAME)         AS OPP_BANK_NM          --对方行名
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H T
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TA
      ON TA.OUT_ACCT_FLOW_NUM = T.OUT_ACCT_FLOW_NUM
     AND TA.STD_PROD_ID IN ('203020300002','203030600002','203030200001','203030600001', --二级福费廷 --MOD BY LIP 20241021 203030200001-国内信用证项下议付、203030600001-国内信用证项下福费廷产品的交易对手取数口径调整
         '203030500001','203030500014','203030500015') --MOD BY LIP 20250613 增加保理的入账账号取数口径
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(T.CNTPTY_RECVBL_ACCT_ID) IS NOT NULL
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY 20240204 加工一级福费廷买入的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水-一级福费廷买入对方账号临时表处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP05
    (RCPT_ID              --借据号
    ,STD_PROD_ID          --标准产品编号
    ,TRA_DR_CR_FLG        --交易借贷标志
    ,OPP_ACC              --对方账号
    ,OPP_ACC_NM           --对方户名
    ,OPP_PBC_NO           --对方行号
    ,OPP_BANK_NM          --对方行名
    )
  SELECT  TA.DUBIL_ID                             AS RCPT_ID              --借据号
         ,TA.STD_PROD_ID                          AS STD_PROD_ID          --标准产品编号
         ,'D'                                     AS TRA_DR_CR_FLG        --交易借贷标志 --借 买入
         ,TRIM(T.LEVEL1_FFT_ACTL_ENTER_ID)        AS OPP_ACC              --对方账号
         ,TRIM(TB.CUST_ACCT_NAME)                 AS OPP_ACC_NM           --对方户名
         ,TRIM(TB.PBC_PAY_BANK_NO)                AS OPP_PBC_NO           --对方行号
         ,TRIM(TB.ORG_NAME)                       AS OPP_BANK_NM          --对方行名
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H T
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TA
      ON TA.OUT_ACCT_FLOW_NUM = T.OUT_ACCT_FLOW_NUM
     AND (TA.STD_PROD_ID IN ('203020300001')--国际信用证项下福费廷 一级福费廷
          OR (TA.STD_PROD_ID IN ('203030600001') AND TRIM(T.CNTPTY_RECVBL_ACCT_ID) IS NULL)) --国内信用证项下福费廷
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 TB
      ON TB.CUST_ACCT_ID = TRIM(T.LEVEL1_FFT_ACTL_ENTER_ID)
   WHERE TRIM(T.LEVEL1_FFT_ACTL_ENTER_ID) IS NOT NULL
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251209 加工出口代付出账的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水-出口代付买入对方账号临时表处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP05
    (RCPT_ID              --借据号
    ,STD_PROD_ID          --标准产品编号
    ,TRA_DR_CR_FLG        --交易借贷标志
    ,OPP_ACC              --对方账号
    ,OPP_ACC_NM           --对方户名
    ,OPP_PBC_NO           --对方行号
    ,OPP_BANK_NM          --对方行名
    )
  SELECT  T.DUBIL_NUM                             AS RCPT_ID              --借据号
         ,T.STD_PROD_ID                           AS STD_PROD_ID          --标准产品编号
         ,'D'                                     AS TRA_DR_CR_FLG        --交易借贷标志 --借 买入
         ,TRIM(TA.FINACT)                         AS OPP_ACC              --对方账号
         ,TRIM(TB.CUST_ACCT_NAME)                 AS OPP_ACC_NM           --对方户名
         ,TRIM(TB.PBC_PAY_BANK_NO)                AS OPP_PBC_NO           --对方行号
         ,TRIM(TB.ORG_NAME)                       AS OPP_BANK_NM          --对方行名
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T
   INNER JOIN RRP_MDL.O_IOL_ISBS_TRD TA
      ON TA.FINCOD = T.DUBIL_NUM
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 TB
      ON TB.CUST_ACCT_ID = TRIM(TA.FINACT)
   WHERE TRIM(TA.FINACT) IS NOT NULL
     AND T.STD_PROD_ID IN ('203020700002')--出口代付
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20250415 曹宁宁贷后需求，客户用非合同登记的还款账号还款情况
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--信贷流水对应的还款账号加工';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP06';
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP06(
     TRAN_REF_NO               --信贷交易流水
    ,TRAN_FLOW_NUM             --对应核心交易流水
    ,ACCT_BILL_FLOW_NUM        --对应核心交易流水账单号
    ,TRAN_AMT                  --核心交易金额
    ,CNTPTY_ACCT_ID            --交易对手账号
    ,CNTPTY_ACCT_NAME          --交易对手户名
    ,CNTPTY_ACCT_OPEN_BANK_CD  --交易对手行号
    ,CNTPTY_OPEN_BANK_NAME     --交易对手行名
    ,OTH_REAL_BASE_ACCT_NO     --登记簿交易对手账号
    ,OTH_REAL_TRAN_NAME        --登记簿交易对手户名
    ,OTH_REAL_TRAN_BANK_CODE   --登记簿交易对手行号
    ,OTH_REAL_TRAN_BANK_NAME   --登记簿交易对手行名
    ,RANK_NUM)                 --序号
  SELECT  T.TRAN_REF_NO                                     AS TRAN_REF_NO               --信贷交易流水
         ,TC.TRAN_FLOW_NUM                                  AS TRAN_FLOW_NUM             --对应核心交易流水
         ,TC.ACCT_BILL_FLOW_NUM                             AS ACCT_BILL_FLOW_NUM        --对应核心交易流水账单号
         ,TC.TRAN_AMT                                       AS TRAN_AMT                  --核心交易金额
         ,CASE WHEN TRIM(TC.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(TC.REAL_CNTPTY_ACCT_ID)
              ELSE TRIM(TC.CNTPTY_ACCT_ID)
          END                                               AS CNTPTY_ACCT_ID            --交易对手账号
         ,CASE WHEN TRIM(TC.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(TC.REAL_CNTPTY_ACCT_NAME)
              ELSE TRIM(TC.CNTPTY_ACCT_NAME)
          END                                               AS CNTPTY_ACCT_NAME          --交易对手户名
         ,CASE WHEN TRIM(TC.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(TC.REAL_CNTPTY_FIN_INST_CD)
              WHEN LENGTH(TRIM(TC.CNTPTY_ACCT_OPEN_BANK_CD)) < 12 THEN TD.FIN_INST_CODE
              ELSE TRIM(TC.CNTPTY_ACCT_OPEN_BANK_CD)
          END                                               AS CNTPTY_ACCT_OPEN_BANK_CD  --交易对手行号
         ,CASE WHEN TRIM(TC.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(TC.REAL_CNTPTY_FIN_INST_NAME)
              ELSE TRIM(TC.CNTPTY_OPEN_BANK_NAME)
          END                                               AS CNTPTY_OPEN_BANK_NAME     --交易对手行名
         ,TRIM(NCBS.OTH_REAL_BASE_ACCT_NO)                  AS OTH_REAL_BASE_ACCT_NO     --登记簿交易对手账号
         ,TRIM(NCBS.OTH_REAL_TRAN_NAME)                     AS OTH_REAL_TRAN_NAME        --登记簿交易对手户名
         ,NVL(TE.FIN_INST_CODE,TRIM(NCBS.CONTRA_BANK_CODE)) AS OTH_REAL_TRAN_BANK_CODE   --登记簿交易对手行号
         --,NVL(TE.BKNAME,TF.BKNAME)                          AS OTH_REAL_TRAN_BANK_NAME   --登记簿交易对手行名
         ,COALESCE(TRIM(NCBS.CONTRA_BANK_NAME),TE.BKNAME,TF.BKNAME) AS OTH_REAL_TRAN_BANK_NAME   --登记簿交易对手行名 --MOD BY LIP 20260417
         ,ROW_NUMBER() OVER(PARTITION BY T.TRAN_REF_NO ORDER BY TC.TRAN_AMT DESC) AS RANK_NUM --序号
    FROM RRP_MDL.O_IML_EVT_REPAY_FLOW T --还款流水
   INNER JOIN RRP_MDL.O_IML_EVT_CUST_WRTOFF_TRAN TA --客户销账交易事件
      ON TA.TRAN_REF_NO = T.TRAN_REF_NO
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_EVT_CUST_ON_ACCT_TRAN TB --客户挂账交易事件
      ON TB.ON_ACCT_SEQ_NUM = TA.ON_ACCT_SEQ_NUM
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL TC --存款账户交易明细表
      ON TC.TRAN_FLOW_NUM = TB.TRAN_REF_NO
     AND TC.DEBIT_CRDT_DIR_CD = TB.DEBIT_CRDT_FLG
     AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT SEQ_NO,REFERENCE,CHANNEL_SEQ_NO,SUB_SEQ_NO,OTH_REAL_BASE_ACCT_NO,OTH_REAL_TRAN_NAME,CONTRA_BANK_CODE,TRAN_AMT,
                      OTH_REAL_ACCT_SEQ_NO,REGISTER_SEQ_NO,TRAN_TIMESTAMP,COMPANY,SOURCE_MODULE,START_DT,END_DT,ID_MARK,ETL_TIMESTAMP,
                      CONTRA_BANK_NAME, --真实对手行名 --ADD BY LIP 20260417
                      ROW_NUMBER() OVER(PARTITION BY SEQ_NO,REFERENCE,CHANNEL_SEQ_NO,SUB_SEQ_NO ORDER BY TRAN_AMT DESC) AS RN
                 FROM RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG) NCBS --核心交易对手登记簿
      ON NCBS.SEQ_NO = TC.ACCT_BILL_FLOW_NUM
     AND NCBS.REFERENCE = TC.TRAN_FLOW_NUM
     AND NCBS.CHANNEL_SEQ_NO = TC.OVA_FLOW_NUM
     AND NCBS.SUB_SEQ_NO = TC.TRAN_FLG_NUM
     AND NCBS.RN = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG TD --机构配置表
      ON TD.ORG_ID = TRIM(TC.CNTPTY_ACCT_OPEN_BANK_CD)
    LEFT JOIN RRP_MDL.ORG_CONFIG TE --机构配置表
      ON TE.ORG_ID = TRIM(NCBS.CONTRA_BANK_CODE)
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO TF --中台机构信息表
      ON TF.BKCD = TRIM(NCBS.CONTRA_BANK_CODE)
     AND TF.ID_MARK <> 'D'
     AND TF.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TF.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.REVS_FLG = '0' --排除冲正数据
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20250606 曹宁宁贷后需求，客户用非合同登记的还款账号还款情况，非挂账情况下的处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--信贷流水对应的还款账号加工';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP06(
     TRAN_REF_NO               --信贷交易流水
    ,TRAN_FLOW_NUM             --对应核心交易流水
    ,ACCT_BILL_FLOW_NUM        --对应核心交易流水账单号
    ,TRAN_AMT                  --核心交易金额
    ,CNTPTY_ACCT_ID            --交易对手账号
    ,CNTPTY_ACCT_NAME          --交易对手户名
    ,CNTPTY_ACCT_OPEN_BANK_CD  --交易对手行号
    ,CNTPTY_OPEN_BANK_NAME     --交易对手行名
    ,OTH_REAL_BASE_ACCT_NO     --登记簿交易对手账号
    ,OTH_REAL_TRAN_NAME        --登记簿交易对手户名
    ,OTH_REAL_TRAN_BANK_CODE   --登记簿交易对手行号
    ,OTH_REAL_TRAN_BANK_NAME   --登记簿交易对手行名
    ,RANK_NUM)                 --序号
  SELECT  TA.CORE_TRAN_REF_NO                               AS TRAN_REF_NO               --信贷交易流水
         ,TA.CORE_TRAN_REF_NO                               AS TRAN_FLOW_NUM             --对应核心交易流水
         ,NULL                                              AS ACCT_BILL_FLOW_NUM        --对应核心交易流水账单号
         ,TB.TRAN_AMT                                       AS TRAN_AMT                  --核心交易金额
         ,TRIM(TB.CNTPTY_ACCT_ID)                           AS CNTPTY_ACCT_ID            --交易对手账号
         ,TRIM(TB.CNTPTY_NAME)                              AS CNTPTY_ACCT_NAME          --交易对手户名
         ,TRIM(TB.CNTPTY_BANK_NO)                           AS CNTPTY_ACCT_OPEN_BANK_CD  --交易对手行号
         ,TRIM(TB.CNTPTY_BANK_NAME)                         AS CNTPTY_OPEN_BANK_NAME     --交易对手行名
         ,NULL                                              AS OTH_REAL_BASE_ACCT_NO     --登记簿交易对手账号
         ,NULL                                              AS OTH_REAL_TRAN_NAME        --登记簿交易对手户名
         ,NULL                                              AS OTH_REAL_TRAN_BANK_CODE   --登记簿交易对手行号
         ,NULL                                              AS OTH_REAL_TRAN_BANK_NAME   --登记簿交易对手行名
         ,ROW_NUMBER() OVER(PARTITION BY TA.CORE_TRAN_REF_NO ORDER BY TB.TRAN_AMT DESC) AS RANK_NUM --序号
    FROM RRP_MDL.O_IML_AGT_LON_POST_TRAN_APPL TA --贷后交易申请
   INNER JOIN RRP_MDL.O_IML_AGT_LON_POST_MODIF_CNTPTY_APPL TB --贷后变更交易对手申请
      ON TB.OBJ_ID = TA.TRAN_FLOW_NUM
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP06 TC
      ON TC.TRAN_REF_NO = TA.CORE_TRAN_REF_NO
     AND TC.RANK_NUM = 1
   WHERE TC.TRAN_REF_NO IS NULL
     AND TA.TRAN_STATUS_CD = 'Finished'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY YJY 20250113 新增房抵贷（网商引流）的贷款收回、放款、核销逻辑  BEGIN --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贷款收回-零售房抵贷（网商引流）';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP02';
  INSERT/*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,REPAY_TYPE            --还款类型代码
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    )
  WITH CMM_RETL_LOAN_REPAY_DTL AS (
  SELECT  A.ACCT_ID             --账户编号
         ,A.CUST_ID             --客户编号
         ,A.CONT_ID             --合同编号
         ,A.DUBIL_ID            --借据号
         ,A.CURR_CD             --币种
         ,A.ADV_REPAY_FLG       --提前还款标志
         ,A.STRK_BAL_FLG        --冲正标志
         ,A.REPAY_DT            --还款日期
         ,A.REPAY_FLOW_ID       --还款流水编号
         ,CASE LVL WHEN 1 THEN 'PRI'  --本金
                   WHEN 2 THEN 'INT'  --利息
                   WHEN 3 THEN 'ODI'  --罚息
                   WHEN 4 THEN 'FEE'  --费用
                   WHEN 5 THEN 'COMP' --复利
           END AS AMT_TYPE      --还款金额类型
         ,CASE LVL WHEN 1 THEN CURRT_REPAY_PRIC       --本金
                   WHEN 2 THEN CURRT_REPAY_INT        --利息
                   WHEN 3 THEN CURRT_REPAY_PNLT       --罚息
                   WHEN 4 THEN CURRT_REPAY_FEE        --费用
                   WHEN 5 THEN CURRT_REPAY_COMP_INT   --复利
           END AS TRAN_AMT      --还款金额
         ,ROW_NUMBER() OVER(PARTITION BY REPAY_FLOW_ID ORDER BY DUBIL_ID) AS RN
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 5)
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                                               AS DATA_DT               --数据日期
         ,T2.LP_ID                                               AS LGL_REP_ID            --法人编号
         ,T2.ACCT_INSTIT_ID                                      AS TRA_ORG_ID            --交易机构编号
         ,T1.REPAY_FLOW_ID|| T1.RN                               AS TRA_SEQ_NO            --交易流水号
         ,T1.ACCT_ID                                             AS ACC_ID                --账户编号
         ,T1.CUST_ID                                             AS CUST_ID               --客户编号
         ,T1.CONT_ID                                             AS CONT_ID               --合同编号
         ,'1'                                                    AS CORP_IND_FLG          --对公对私标志  1-对私
         ,T2.ACCT_INSTIT_ID                                      AS ORG_ID                --机构编号
         ,T2.SUBJ_ID                                             AS SUBJ_ID               --科目编号
         ,T1.DUBIL_ID                                            AS RCPT_ID               --借据编号
         ,T4.CUST_NAME                                           AS CUST_NM               --客户名称
         ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN '12' --贷款还本
               WHEN T1.AMT_TYPE IN ('INT','COMP') THEN '13' --贷款还息
               WHEN T1.AMT_TYPE = 'ODI' THEN '18' --贷款还罚息
               WHEN T1.AMT_TYPE = 'FEE' THEN '19' --费用
           END                                                   AS TRA_TYP               --交易类型 D0121
         ,'C'                                                    AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
         ,T1.TRAN_AMT                                            AS TRA_AMT               --交易金额
         ,T2.CURRT_BAL                                           AS ACC_BAL               --账户余额
         ,COALESCE(TRIM(T2.LOAN_REPAY_NUM),TRIM(T2.LOAN_DISTR_ACCT_NUM)) AS OPP_ACC       --对方账号
         ,T4.CUST_NAME                                           AS OPP_ACC_NM            --对方户名
         ,NULL                                                   AS OPP_PBC_NO            --对方行号
         ,'支付宝'                                               AS OPP_BANK_NM           --对方行名 默认支付宝
         ,'403001'                                               AS TRA_CHAN              --交易渠道 默认支付宝
         ,T1.CURR_CD                                             AS CUR                   --币种
         ,'贷款回收'||CASE WHEN TRUNC(T1.REPAY_DT) <= TRUNC(T2.ASSET_TRAN_DT) THEN '收益权转让' --MOD BY HYF 20251215
                           WHEN T1.AMT_TYPE = 'PRI' THEN '本金'
                           WHEN T1.AMT_TYPE IN ('INT','COMP') THEN '利息'
                           WHEN T1.AMT_TYPE = 'ODI' THEN '罚息'
                           WHEN T1.AMT_TYPE = 'FEE' THEN '费用'
                       END                                       AS ABSTR                 --摘要
         ,CASE WHEN T1.STRK_BAL_FLG = '1' THEN '2' --2-冲账
               ELSE '1' --1-正常
           END                                                   AS FLUSH_PATCH_FLG       --冲补抹标志 D0128 1-正常 2-冲账 3-补账
         ,NULL                                                   AS TRA_TLR_NO            --交易柜员号
         ,NULL                                                   AS GRANT_TLR_NO          --授权柜员号
         ,'2'                                                    AS CASH_TRF_FLG          --现转标志 2-转账
         ,NULL                                                   AS AGT_NM                --代办人姓名
         ,NULL                                                   AS AGT_CRDL_TYP          --代办人证件类型
         ,NULL                                                   AS AGT_CRDL_NO           --代办人证件号码
         ,NULL                                                   AS BATCH_TRF_FLG         --批量转让标志
         ,NULL                                                   AS NORM_RETRV_AMT        --正常回收金额
         ,NULL                                                   AS ADV_REPY_AMT          --提前还款金额
         ,CASE WHEN T5.DUBIL_ID IS NOT NULL THEN 'B10' --核销后收回
               WHEN T1.ADV_REPAY_FLG = '1' THEN 'B02' --提前还款
               ELSE 'B01'
           END                                                   AS DSTR_RETRV_TYP        --发放收回类型
         ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN 'Y'
               ELSE 'N'
           END                                                   AS PRIN_TRA_FLG          --本金交易标志
         ,TO_DATE(TO_CHAR(T1.REPAY_DT,'YYYYMMDD')||' '||SUBSTR(T1.REPAY_FLOW_ID,9,6),'YYYYMMDD HH24:MI:SS') AS TRA_TM --交易时间
         ,TO_CHAR(T1.REPAY_DT,'YYYYMMDD')                        AS TRA_DT                --交易日期
         ,NULL                                                   AS LOAN_CHG_TYP          --贷款变动类型
         ,'800924'                                               AS DEPT_LINE             --部门条线 /*零售信贷部(普惠金融部)*/
         ,'零售贷款收回'                                         AS DATA_SRC              --数据来源
         ,'1'                                                    AS REPAY_PERDS           --还款期数
         ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
               WHEN T1.AMT_TYPE IN ('INT','COMP') THEN '2'
               WHEN T1.AMT_TYPE = 'ODI' THEN '3'
               WHEN T1.AMT_TYPE = 'FEE' THEN '4'
               ELSE '9'
           END                                                   AS DTL_SEQ_NUM           --交易序号
         ,T1.AMT_TYPE                                            AS AMT_TYPE              --金额类型
         ,NULL                                                   AS REPAY_TYPE            --还款类型代码
         ,T2.PROD_ID                                             AS STD_PROD_ID           --标准产品编号
         ,NULL                                                   AS DISCNT_INT_RAT        --贴现利率
         ,NULL                                                   AS CTR_NT_ID             --成交单编号
         ,T1.REPAY_FLOW_ID                                       AS CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    FROM CMM_RETL_LOAN_REPAY_DTL T1 --零售贷款还款明细
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.DUBIL_NUM = T1.DUBIL_ID
     AND T2.STD_PROD_ID = '201020100057' --房抵贷 华兴快贷经营
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO T4 --个人客户基础信息
      ON T4.CUST_ID = T1.CUST_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO T5 --贷款核销信息表
      ON T5.DUBIL_ID = T1.DUBIL_ID
     AND T5.FIR_WRT_OFF_DT <= T1.REPAY_DT
     AND T5.STD_PROD_ID = '201020100057' --房抵贷 华兴快贷经营
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贷款放款-零售房抵贷（网商引流）';
  V_STARTTIME := SYSDATE;
  INSERT/*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02 NOLOGGING
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,CRN_PRD_ACCRD_INT     --当期应计利息
    ,CRN_PRD_REPY_PNY_INT  --当期还款罚息
    ,CRN_PRD_REPY_CP_INT   --当期还款复息
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,AMT_TYPE              --金额类型
    ,CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    )
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
         ,B.LP_ID                                                AS LGL_REP_ID            --法人编号
         ,COALESCE(TRIM(A.OUT_ACCT_ORG_ID),B.ACCT_INSTIT_ID)     AS TRA_ORG_ID            --交易机构编号
         ,A.OUT_ACCT_FLOW_NUM                                    AS TRA_SEQ_NO            --交易流水号
         ,B.ACCT_ID                                              AS ACC_ID                --账户编号
         ,B.CUST_ID                                              AS CUST_ID               --客户编号
         ,B.CONT_ID                                              AS CONT_ID               --合同编号
         ,'1'                                                    AS CORP_IND_FLG          --对公对私标志
         ,B.ACCT_INSTIT_ID                                       AS ORG_ID                --机构编号
         ,B.SUBJ_ID                                              AS SUBJ_ID               --科目编号
         ,B.DUBIL_NUM                                            AS RCPT_ID               --借据编号
         ,C.CUST_NAME                                            AS CUST_NM               --客户名称
         ,'11'                                                   AS TRA_TYP               --交易类型 D0121
         ,'D'                                                    AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
         ,A.THS_TM_DISTR_AMT                                     AS TRA_AMT               --交易金额
         ,B.DISTR_AMT                                            AS ACC_BAL               --账户余额
         ,TRIM(A.ENTER_ID)                                       AS OPP_ACC               --对方账号
         ,TRIM(A.ENTER_NAME)                                     AS OPP_ACC_NM            --对方户名
         ,TRIM(A.ENTER_OPEN_ACCT_ORG_ID)                         AS OPP_PBC_NO            --对方行号
         ,'支付宝'                                               AS OPP_BANK_NM           --对方行名 默认支付宝
         ,'403001'                                               AS TRA_CHAN              --交易渠道 Z0014 --默认支付宝
         ,A.CURR_CD                                              AS CUR                   --币种
         ,'贷款发放'                                             AS ABSTR                 --摘要
         ,'1'                                                    AS FLUSH_PATCH_FLG       --冲补抹标志
         ,NULL                                                   AS TRA_TLR_NO            --交易柜员号
         ,NULL                                                   AS GRANT_TLR_NO          --授权柜员号
         ,'2'                                                    AS CASH_TRF_FLG          --现转标志
         ,NULL                                                   AS AGT_NM                --代办人姓名
         ,NULL                                                   AS AGT_CRDL_TYP          --代办人证件类型
         ,NULL                                                   AS AGT_CRDL_NO           --代办人证件号码
         ,NULL                                                   AS BATCH_TRF_FLG         --批量转让标志
         ,NULL                                                   AS NORM_RETRV_AMT        --正常回收金额
         ,NULL                                                   AS ADV_REPY_AMT          --提前还款金额
         ,'A01'                                                  AS DSTR_RETRV_TYP        --发放收回类型
         ,NULL                                                   AS PRIN_TRA_FLG          --本金交易标志
         ,A.DISTR_DT                                             AS TRA_TM                --交易时间
         ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                         AS TRA_DT                --交易日期
         ,NULL                                                   AS LOAN_CHG_TYP          --贷款变动类型
         ,'800924'                                               AS DEPT_LINE             --部门条线/*零售信贷部(普惠金融部)*/
         ,'零售贷款放款'                                         AS DATA_SRC              --数据来源
         ,NULL                                                   AS CRN_PRD_ACCRD_INT     --当期应计利息
         ,NULL                                                   AS CRN_PRD_REPY_PNY_INT  --当期还款罚息
         ,NULL                                                   AS CRN_PRD_REPY_CP_INT   --当期还款复息
         ,'1'                                                    AS REPAY_PERDS           --还款期数
         ,'001'                                                  AS DTL_SEQ_NUM           --交易序号
         ,B.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
         ,NULL                                                   AS DISCNT_INT_RAT        --贴现利率
         ,NULL                                                   AS CTR_NT_ID             --成交单编号
         ,'PRI'                                                  AS AMT_TYPE              --金额类型
         ,TRIM(A.CORE_TRAN_FLOW_NUM)                             AS CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --贷款出账申请历史
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO B --零售贷款账户信息
      ON B.DUBIL_NUM = A.DUBIL_ID
     AND B.STD_PROD_ID = '201020100057' --房抵贷 华兴快贷经营
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.PROD_ID = '201020100057'
     AND TRUNC(A.DISTR_DT) = TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --MOD BY YJY 20250401
     AND A.ID_MARK <> 'D'
     AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贷款核销-零售房抵贷（网商引流）';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    )
  WITH CMM_LOAN_WRT_OFF_INFO AS (
  SELECT A.DUBIL_ID        --借据号
        ,A.FIR_WRT_OFF_DT  --首次核销日期
        ,A.LP_ID           --法人编号
        ,A.FINAL_WRT_OFF_RETRA_DT  --最后核销收回日期
        ,A.CURR_CD         --币种代码
        ,A.CUST_ID         --客户编号
        ,A.CONT_ID         --合同编号
        ,A.APPL_TELLER_ID  --申请柜员编号
        ,A.STD_PROD_ID
        ,A.TRAN_TIMESTAMP
        ,CASE LVL WHEN 1 THEN 'PRI' --本金
                  WHEN 2 THEN 'INT' --利息
                  WHEN 3 THEN 'FEE' --费用
          END AS AMT_TYPE    --核销金额类型
        ,CASE LVL WHEN 1 THEN A.ACTL_WRTOFF_LOAN_PRIC --实核贷款本金
                  WHEN 2 THEN A.ACTL_WRTOFF_IN_BS_INT + A.ACTL_WRTOFF_OFF_BS_INT --实核表内利息+实核表外利息
                  WHEN 3 THEN A.WRT_OFF_RETRA_ADVC_FEE --核销收回垫付费用
          END AS TRAN_AMT   --核销金额
    FROM RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 3)
   WHERE A.STD_PROD_ID = '201020100057'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T2.ACCT_INSTIT_ID                                       AS TRA_ORG_ID            --交易机构编号
        ,V_P_DATE||T1.DUBIL_ID                                   AS TRA_SEQ_NO            --交易流水号
        ,T2.ACCT_ID                                              AS ACC_ID                --账户编号
        ,T1.CUST_ID                                              AS CUST_ID               --客户编号
        ,T1.CONT_ID                                              AS CONT_ID               --合同编号
        ,'1'                                                     AS CORP_IND_FLG          --对公对私标志
        ,T2.ACCT_INSTIT_ID                                       AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T1.DUBIL_ID                                             AS RCPT_ID               --借据编号
        ,T2.ACCT_NAME                                            AS CUST_NM               --客户名称
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12' --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13' --贷款还息
              ELSE '99'
          END                                                    AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                                             AS TRA_AMT               --交易金额
        ,0                                                       AS ACC_BAL               --账户余额
        ,NULL                                                    AS OPP_ACC               --对方账号
        ,NULL                                                    AS OPP_ACC_NM            --对方户名
        ,NULL                                                    AS OPP_PBC_NO            --对方行号
        ,NULL                                                    AS OPP_BANK_NM           --对方行名
        ,'999996'                                                AS TRA_CHAN              --交易渠道 其他-核销
        ,DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD)            AS CUR                   --币种
        ,'核销'                                                  AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        ,T1.APPL_TELLER_ID                                       AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B03'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,T1.TRAN_TIMESTAMP                                       AS TRA_TM                --交易时间
        ,TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')                   AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800924'                                                AS DEPT_LINE             --部门条线/*零售信贷部(普惠金融部)*/
        ,'零售贷款核销'                                          AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'CNCL'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '01'
                                  WHEN 'INT' THEN '02'
                                  WHEN 'FEE' THEN '03'
                  END                                            AS DTL_SEQ_NUM           --交易序号
        ,T1.AMT_TYPE                                             AS AMT_TYPE              --金额类型
        ,T1.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
        ,NULL                                                    AS CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    FROM CMM_LOAN_WRT_OFF_INFO T1 --贷款核销信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.DUBIL_NUM = T1.DUBIL_ID
     AND T2.STD_PROD_ID = '201020100057' --房抵贷 华兴快贷经营
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0
     AND T1.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
     AND T1.FIR_WRT_OFF_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY YJY 20250113 新增房抵贷（网商引流）的贷款收回、放款、核销逻辑  END --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贷款收回';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,REPAY_TYPE            --还款类型代码
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,CALLBK_RS             --回款原因
    ,CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    )
  WITH TMP_OPPACC_CHN AS (--MOD BY LIP 20250618
  SELECT /*+MATERIALIZE*/TRAN_REF_NO,EVT_CATE_ID,AMT_TYPE_CD,AMT_CALC_TYPE_CD,TRAN_AMT,DEBIT_CRDT_FLG,
         CNTPTY_ACCT_CURR_CD,CNTPTY_CUST_ACCT_NUM,CNTPTY_ACCT_NAME,CNTPTY_OPEN_ACCT_ORG_ID,CNTPTY_BANK_NAME,CHN_ID,
         ROW_NUMBER() OVER(PARTITION BY TRAN_REF_NO ORDER BY TRAN_AMT DESC) RN
    FROM RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW A --贷款金融交易流水
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
         ,T1.LP_ID                                               AS LGL_REP_ID            --法人编号
         ,T1.TRAN_ORG_ID                                         AS TRA_ORG_ID            --交易机构编号
         ,T2.ADVISE_ODD_NO||T14.PAY_FLOW_NUM                     AS TRA_SEQ_NO            --交易流水号
         ,T2.ACCT_ID                                             AS ACC_ID                --账户编号
         ,T1.CUST_ID                                             AS CUST_ID               --客户编号
         ,CASE WHEN T3.DUBIL_NUM IS NOT NULL THEN T3.CONT_ID --对私
               WHEN T5.DUBIL_NUM IS NOT NULL THEN T5.CONT_ID --对公
           END                                                   AS CONT_ID               --合同编号
         ,CASE WHEN T3.DUBIL_NUM IS NOT NULL THEN '1' --对私
               WHEN T5.DUBIL_NUM IS NOT NULL THEN '2' --对公
           END                                                   AS CORP_IND_FLG          --对公对私标志
         ,NVL(T3.ACCT_INSTIT_ID,T5.ACCT_INSTIT_ID)               AS ORG_ID                --机构编号
         ,NVL(T3.SUBJ_ID,T5.SUBJ_ID)                             AS SUBJ_ID               --科目编号
         ,NVL(T3.DUBIL_NUM,T5.DUBIL_NUM)                         AS RCPT_ID               --借据编号
         ,NVL(T3.ACCT_NAME,T5.ACCT_NAME)                         AS CUST_NM               --客户名称
         /*,CASE WHEN T2.AMT_TYPE_CD IN ('PRI') THEN '12' --贷款还本
               WHEN T2.AMT_TYPE_CD IN ('INT') THEN '13' --贷款还息
               ELSE '99'
           END                                                   AS TRA_TYP               --交易类型 D0121*/
         ,CASE WHEN T2.AMT_TYPE_CD IN ('PRI','PRD') THEN '12' --贷款还本 --本金 逾期本金 --ADD BY LIP 20260227 增加逾期本金
               WHEN T2.AMT_TYPE_CD IN ('INT','ODI','ODP') THEN '13' --贷款还息 --利息 复利 罚息 --ADD BY LIP 20260227 增加复利罚息
               ELSE '99'
           END                                                   AS TRA_TYP               --交易类型 D0121
         ,'C'                                                    AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
         ,T2.CALLBK_PRIC                                         AS TRA_AMT               --交易金额
         ,NVL(T3.PRIC_BAL,T5.PRIC_BAL)                           AS ACC_BAL               --账户余额
         /*MODIFY BY TANGAN AT 20230111 调整助贷产品对手方信息逻辑 BEGIN*/
         /*,NVL(T4.ENTER_ACCT_ID,T5.LOAN_DISTR_ACCT_NUM)           AS OPP_ACC               --对方账号
         ,NVL(T7.CUST_ACCT_NAME,T8.CUST_ACCT_NAME)               AS OPP_ACC_NM            --对方户名
         ,NVL(T7.PBC_PAY_BANK_NO,T8.PBC_PAY_BANK_NO)             AS OPP_PBC_NO            --对方行号
         ,NVL(T7.ORG_NAME,T8.ORG_NAME)                           AS OPP_BANK_NM           --对方行名*/
         ,CASE WHEN T16.TRAN_REF_NO IS NOT NULL THEN T16.CNTPTY_ACCT_ID --MOD BY LIP 20250415
               WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL --平安普惠
               THEN TB.FINAL_ENTY_C_NUM
               WHEN T3.STD_PROD_ID IN ('202020200005','202020200006') AND TRIM(T4.ENTER_ACCT_ID) IS NOT NULL --网商小贷 取合同栏位的账号
               THEN T4.ENTER_ACCT_ID
               WHEN T3.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                    AND TRIM(TBB.REPAY_BANK_CARD_NUM) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
               THEN TBB.REPAY_BANK_CARD_NUM
               WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_ACC --ADD BY 20240229
               --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
               WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN T14.RECVBL_ACCT_ID
               ELSE COALESCE(TRIM(T3.LOAN_REPAY_NUM),TRIM(T5.LOAN_REPAY_NUM),TRIM(T5.LOAN_DISTR_ACCT_NUM),TRIM(T3.LOAN_DISTR_ACCT_NUM))
           END                                                   AS OPP_ACC               --对方账号
         ,CASE WHEN T16.TRAN_REF_NO IS NOT NULL THEN T16.CNTPTY_ACCT_NAME --MOD BY LIP 20250415
               WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL --平安普惠
               THEN TB.FINAL_ENTY_C_NAME
               WHEN T3.STD_PROD_ID IN ('202020200005','202020200006') AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL --网商小贷 取合同栏位的账号
               THEN TB.FINAL_ENTY_C_NAME
               WHEN T3.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                    AND TRIM(TBB.REPAY_BANK_CARD_NUM) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
               THEN TRIM(TBB.REPAY_BANK_CARD_NAME)
               WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_ACC_NM --ADD BY 20240229
               --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
               WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN TRIM(T14.RECVER_NAME)
               ELSE NVL(T7.CUST_ACCT_NAME,T11.CUST_ACCT_NAME)
           END                                                   AS OPP_ACC_NM            --对方户名
         ,CASE WHEN T16.TRAN_REF_NO IS NOT NULL THEN T16.CNTPTY_ACCT_OPEN_BANK_CD --MOD BY LIP 20250415
               WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NUM) IS NOT NULL --平安普惠
               THEN TB.FINAL_ENTY_C_OPEN_BANK_NUM
               WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTER_CLEAR_BK_NO) IS NOT NULL --平安普惠
               THEN TB.FINAL_ENTER_CLEAR_BK_NO
               WHEN T3.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                    AND TRIM(TBB.REPAY_BANK_CARD_NUM) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
               THEN TRIM(TBB.REPAY_BANK_NO)
               WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_PBC_NO --ADD BY 20240229
               --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
               WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN TRIM(T14.RECVER_OPEN_BANK_NAME)
               ELSE NVL(T7.PBC_PAY_BANK_NO,T11.PBC_PAY_BANK_NO)
           END                                                   AS OPP_PBC_NO            --对方行号
         ,CASE WHEN T16.TRAN_REF_NO IS NOT NULL THEN T16.CNTPTY_OPEN_BANK_NAME --MOD BY LIP 20250415
               WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL --平安普惠
               THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
               WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME) IS NOT NULL --平安普惠
               THEN TRIM(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME)
               WHEN T3.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                    AND TRIM(TBB.REPAY_BANK_CARD_NUM) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
               THEN TRIM(TBB.REPAY_BANK_NAME)
               WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_BANK_NM --ADD BY 20240229
               --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
               WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN TRIM(T14.TRAN_IN_BANK_NAME)
               ELSE NVL(T7.ORG_NAME,T11.ORG_NAME)
           END                                                   AS OPP_BANK_NM           --对方行名
         /*MODIFY BY TANGAN AT 20230111 调整助贷产品对手方信息逻辑 END*/
         ,T9.CHN_ID                                              AS TRA_CHAN              --交易渠道
         ,DECODE(T1.CURR_CD,'-',NVL(T3.CURR_CD,T5.CURR_CD),T1.CURR_CD) AS CUR             --币种
         --,'贷款回收-'||T10.CD_DESCB                              AS ABSTR                 --摘要
         ,'贷款回收-'||CASE WHEN TRUNC(T2.TRAN_TM) <= TRUNC(T3.ASSET_TRAN_DT) THEN '收益权转让' --MOD BY HYF 20251215
                            WHEN TRUNC(T2.TRAN_TM) <= TRUNC(T5.ASSET_TRAN_DT) THEN '收益权转让'
                       ELSE T10.CD_DESCB                       END AS ABSTR                 --摘要 --MOD BY HYF 20251215
         --,'1'                                                    AS FLUSH_PATCH_FLG       --冲补抹标志 D0128 1-正常 2-冲账 3-补账
         --MOD BY LIP 20230802 调整冲补抹标志逻辑
         ,CASE WHEN T1.REVS_FLG = '1' THEN '2'
               ELSE '1'
           END                                                     AS FLUSH_PATCH_FLG     --冲补抹标志 D0128 1-正常 2-冲账 3-补账
         ,T1.TRAN_TELLER_ID                                        AS TRA_TLR_NO          --交易柜员号
         ,TRIM(T1.BA_AUTH_TELLER_ID)                              AS GRANT_TLR_NO         --授权柜员号
         ,'2'                                                     AS CASH_TRF_FLG         --现转标志 2-转账
         ,NULL                                                    AS AGT_NM               --代办人姓名
         ,NULL                                                    AS AGT_CRDL_TYP         --代办人证件类型
         ,NULL                                                    AS AGT_CRDL_NO          --代办人证件号码
         ,NULL                                                    AS BATCH_TRF_FLG        --批量转让标志
         ,CASE WHEN T1.LOAN_REPAY_TYPE_CD IN ('NS','PO')
               THEN T1.CALLBK_PRIC
           END                                                    AS NORM_RETRV_AMT       --正常回收金额
         ,CASE WHEN T1.LOAN_REPAY_TYPE_CD = 'ER'
               THEN T1.CALLBK_PRIC
           END                                                    AS ADV_REPY_AMT         --提前还款金额
         ,CASE WHEN D.DUBIL_ID IS NOT NULL THEN 'B10' --核销后收回ADD20230203XUXIAOBIN
               WHEN T1.LOAN_REPAY_TYPE_CD IN ('NS','PO') THEN 'B01'
               WHEN T1.LOAN_REPAY_TYPE_CD = 'ER' THEN 'B02'
           END                                                   AS DSTR_RETRV_TYP        --发放收回类型
         ,CASE WHEN T2.AMT_TYPE_CD IN ('PRI') THEN 'Y'
               ELSE 'N'
           END                                                   AS PRIN_TRA_FLG          --本金交易标志
         ,T1.TRAN_TM                                             AS TRA_TM                --交易时间
         ,TO_CHAR(T1.LOAN_REPAY_DT,'YYYYMMDD')                   AS TRA_DT                --交易日期
         ,NULL                                                   AS LOAN_CHG_TYP          --贷款变动类型
         ,CASE WHEN T3.DUBIL_NUM IS NOT NULL THEN '800924' /*零售信贷部(普惠金融部)*/
               ELSE '800919' /*风险管理部*/
           END                                                   AS DEPT_LINE             --部门条线
         ,CASE WHEN T3.DUBIL_NUM IS NOT NULL THEN '零售贷款收回'
               ELSE '对公贷款收回'
           END                                                    AS DATA_SRC             --数据来源
         ,T2.CURR_PD                                              AS REPAY_PERDS          --还款期数
         ,T1.EVT_ID                                               AS DTL_SEQ_NUM          --交易序号
         ,T2.AMT_TYPE_CD                                          AS AMT_TYPE             --金额类型
         ,T1.LOAN_REPAY_TYPE_CD                                   AS REPAY_TYPE           --还款类型代码
         ,NVL(T3.STD_PROD_ID,T5.STD_PROD_ID)                      AS STD_PROD_ID          --标准产品编号
         ,NULL                                                    AS DISCNT_INT_RAT       --贴现利率
         ,NULL                                                    AS CTR_NT_ID            --成交单编号
         ,T1.CALLBK_RS                                            AS CALLBK_RS            --回款原因
         ,TRIM(T1.TRAN_REF_NO)                                    AS CORE_TRAN_FLOW_NUM   --核心交易流水号 --ADD BY LIP 20251112
    FROM RRP_MDL.O_IML_EVT_REPAY_FLOW T1 --还款流水
   INNER JOIN RRP_MDL.O_IML_EVT_REPAY_DTL T2 --还款明细
      ON T2.EVT_ID = T1.EVT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T3 --零售贷款账户信息
      ON T3.ACCT_ID = T2.ACCT_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款合同信息
      ON T4.CONT_ID = T3.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H TB --贷款合同个人贷款附属信息历史 --MODIFY BY TANGAN AT 20230111 取助贷的入账和出账账号
      ON TB.CONT_ID = T3.CONT_ID
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO TBB --零售贷款业务合同补充信息 --ADD BY LIP 20250311
      ON TBB.CONT_ID = T3.CONT_ID
     AND TBB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TC --ADD BY LIP 20230530 互联网贷款取合同登记的还款账号
      ON TC.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(TB.FINAL_ENTER_CLEAR_BK_NO)
     AND TC.RANK_RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T5 --对公贷款账户信息
      ON T5.ACCT_ID = T2.ACCT_ID
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 T7 --主账户和内部户账户汇总临时表
      ON T7.CUST_ACCT_ID = COALESCE(TRIM(T3.LOAN_REPAY_NUM),TRIM(T5.LOAN_REPAY_NUM),TRIM(T5.LOAN_DISTR_ACCT_NUM),TRIM(T3.LOAN_DISTR_ACCT_NUM))
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 T11 --主账户和内部户账户汇总临时表 助贷
      ON T11.CUST_ACCT_ID = TB.FINAL_ENTY_C_NUM
    LEFT JOIN TMP_OPPACC_CHN T9 --MOD BY LIP 20250618
      ON T9.TRAN_REF_NO = T1.TRAN_REF_NO
     AND T9.RN = 1
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T10 --公共代码表 取还款备注
      ON T10.CD_VAL = T2.AMT_TYPE_CD
     AND T10.CD_ID = 'CD2558'
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO D --贷款核销信息表
      ON D.DUBIL_ID = NVL(T3.DUBIL_NUM,T5.DUBIL_NUM)
     AND D.FIR_WRT_OFF_DT <= T1.LOAN_REPAY_DT
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --MOD BY LIP 20230725 取零售贷款部分受托支付表中自主支付方式的账号
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T12
      ON T12.DUBIL_ID = T3.DUBIL_NUM
     AND T12.MODE_PAY_CD <> '1' --不等于受托支付
     AND T12.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_ENTR_PAY_INFO_H T14 --例如平安普惠的数据现在在受托支付信息表中
      ON T14.OUT_ACCT_FLOW_NUM = T12.OUT_ACCT_FLOW_NUM
     AND T14.ID_MARK <> 'D'
     AND T14.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T14.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP05 T15 --贷款账户交易流水 --对方账号信息
      ON T15.RCPT_ID = NVL(T3.DUBIL_NUM,T5.DUBIL_NUM)
     AND NVL(T15.TRA_DR_CR_FLG,'C') = 'C'
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP06 T16 --ADD BY LIP 20250415
      ON T16.TRAN_REF_NO = T1.TRAN_REF_NO
     AND T16.RANK_NUM = 1
   WHERE T1.REVS_FLG = '0' --MOD BY 20241009 排除冲正数据
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230711增加对公贷款的结息数据
  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款结息数据';
  V_STARTTIME := SYSDATE;
  INSERT\*+ APPEND PARALLEL*\ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02(
    DATA_DT,               --数据日期
    LGL_REP_ID,            --法人编号
    TRA_ORG_ID,            --交易机构编号
    TRA_SEQ_NO,            --交易流水号
    ACC_ID,                --账户编号
    CUST_ID,               --客户编号
    CONT_ID,               --合同编号
    CORP_IND_FLG,          --对公对私标志
    ORG_ID,                --机构编号
    SUBJ_ID,               --科目编号
    RCPT_ID,               --借据编号
    CUST_NM,               --客户名称
    TRA_TYP,               --交易类型 D0121
    TRA_DR_CR_FLG,         --交易借贷标志 Z0017 D-借，C-贷
    TRA_AMT,               --交易金额
    ACC_BAL,               --账户余额
    OPP_ACC,               --对方账号
    OPP_ACC_NM,            --对方户名
    OPP_PBC_NO,            --对方行号
    OPP_BANK_NM,           --对方行名
    TRA_CHAN,              --交易渠道 Z0014
    CUR,                   --币种
    ABSTR,                 --摘要
    FLUSH_PATCH_FLG,       --冲补抹标志
    TRA_TLR_NO,            --交易柜员号
    GRANT_TLR_NO,          --授权柜员号
    CASH_TRF_FLG,          --现转标志
    AGT_NM,                --代办人姓名
    AGT_CRDL_TYP,          --代办人证件类型
    AGT_CRDL_NO,           --代办人证件号码
    BATCH_TRF_FLG,         --批量转让标志
    NORM_RETRV_AMT,        --正常回收金额
    ADV_REPY_AMT,          --提前还款金额
    DSTR_RETRV_TYP,        --发放收回类型
    PRIN_TRA_FLG,          --本金交易标志
    TRA_TM,                --交易时间
    TRA_DT,                --交易日期
    LOAN_CHG_TYP,          --贷款变动类型
    DEPT_LINE,             --部门条线
    DATA_SRC,              --数据来源
    REPAY_PERDS,           --还款期数
    DTL_SEQ_NUM,           --交易序号
    AMT_TYPE,              --金额类型
    REPAY_TYPE,            --还款类型代码
    STD_PROD_ID,           --标准产品编号
    DISCNT_INT_RAT,        --贴现利率
    CTR_NT_ID,             --成交单编号
    CALLBK_RS              --回款原因
    )
  SELECT V_P_DATE                                                AS DATA_DT,              --数据日期
         T1.LP_ID                                                AS LGL_REP_ID,           --法人编号
         T1.TRAN_ORG_ID                                          AS TRA_ORG_ID,           --交易机构编号
         T1.TRAN_FLOW_NUM                                        AS TRA_SEQ_NO,           --交易流水号
         T2.ACCT_ID                                              AS ACC_ID,               --账户编号
         T1.CUST_ID                                              AS CUST_ID,              --客户编号
         T2.CONT_ID                                              AS CONT_ID,              --合同编号
         '2'                                                     AS CORP_IND_FLG,         --对公对私标志
         T2.ACCT_INSTIT_ID                                       AS ORG_ID,               --机构编号
         T2.SUBJ_ID                                              AS SUBJ_ID,              --科目编号
         T2.DUBIL_NUM                                            AS RCPT_ID,              --借据编号
         T2.ACCT_NAME                                            AS CUST_NM,              --客户名称
         '04'                                                    AS TRA_TYP,              --交易类型 D0121 结息
         'D'                                                     AS TRA_DR_CR_FLG,        --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                                             AS TRA_AMT,              --交易金额
         T2.CURRT_BAL                                            AS ACC_BAL,              --账户余额
         T2.DUBIL_NUM                                            AS OPP_ACC,              --对方账号
         T2.ACCT_NAME                                            AS OPP_ACC_NM,           --对方户名
         T3.FIN_INST_CODE                                        AS OPP_PBC_NO,           --对方行号
         T3.ORG_NAME                                             AS OPP_BANK_NM,          --对方行名
         T1.CHN_ID                                               AS TRA_CHAN,             --交易渠道
         DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD)            AS CUR,                  --币种
         TRIM(T1.TRAN_MEMO_DESCB)                                AS ABSTR,                --摘要
         CASE WHEN TRIM(T1.REVS_FLOW_NUM) IS NOT NULL THEN '2'
              ELSE '1'
          END                                                    AS FLUSH_PATCH_FLG,      --冲补抹标志 D0128 1-正常 2-冲账 3-补账
         ''                                                      AS TRA_TLR_NO,           --交易柜员号
         ''                                                      AS GRANT_TLR_NO,         --授权柜员号
         '2'                                                     AS CASH_TRF_FLG,         --现转标志 2-转账
         NULL                                                    AS AGT_NM,               --代办人姓名
         NULL                                                    AS AGT_CRDL_TYP,         --代办人证件类型
         NULL                                                    AS AGT_CRDL_NO,          --代办人证件号码
         NULL                                                    AS BATCH_TRF_FLG,        --批量转让标志
         NULL                                                    AS NORM_RETRV_AMT,       --正常回收金额
         NULL                                                    AS ADV_REPY_AMT,         --提前还款金额
         'A01'                                                   AS DSTR_RETRV_TYP,       --发放收回类型
         'N'                                                     AS PRIN_TRA_FLG,         --本金交易标志
         T1.TRAN_TM                                              AS TRA_TM,               --交易时间
         TO_CHAR(T1.TRAN_DT,'YYYYMMDD')                          AS TRA_DT,               --交易日期
         NULL                                                    AS LOAN_CHG_TYP,         --贷款变动类型
         '800919'                                                AS DEPT_LINE,            --部门条线 \*风险管理部*\
         '对公贷款发放'                                          AS DATA_SRC,               --数据来源
         NULL                                                    AS REPAY_PERDS,          --还款期数
         T1.EVT_ID                                               AS DTL_SEQ_NUM,          --交易序号
         'INT'                                                   AS AMT_TYPE,             --金额类型
         --T1.AMT_TYPE_CD                                          AS AMT_TYPE,           --金额类型
         NULL                                                    AS REPAY_TYPE,           --还款类型代码
         T2.STD_PROD_ID                                          AS STD_PROD_ID,          --标准产品编号
         NULL                                                    AS DISCNT_INT_RAT,       --贴现利率
         NULL                                                    AS CTR_NT_ID,            --成交单编号
         NULL                                                    AS CALLBK_RS             --回款原因
    FROM RRP_MDL.O_IML_EVT_LOAN_TRAN_FLOW T1 --还款流水
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T2 --对公贷款账户信息
      ON T2.ACCT_ID = T1.ACCT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG T3 --机构配置表
      ON T3.ORG_ID = T2.ACCT_INSTIT_ID
   WHERE T1.TRAN_CODE = 'DUE' --结息数据
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贷款发放';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    )
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T1.TRAN_ORG_ID                                          AS TRA_ORG_ID            --交易机构编号
        ,T1.TRAN_FLOW_NUM||T14.PAY_FLOW_NUM                      AS TRA_SEQ_NO            --交易流水号
        ,T1.ACCT_ID                                              AS ACC_ID                --账户编号
        ,T1.CUST_ID                                              AS CUST_ID               --客户编号
        ,NVL(T2.CONT_ID,T3.CONT_ID)                              AS CONT_ID               --合同编号
        ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '1' --个人
              WHEN T3.DUBIL_NUM IS NOT NULL THEN '2' --对公
          END                                                    AS CORP_IND_FLG          --对公对私标志
        ,NVL(T2.ACCT_INSTIT_ID,T3.ACCT_INSTIT_ID)                AS ORG_ID                --机构编号
        ,NVL(T2.SUBJ_ID,T3.SUBJ_ID)                              AS SUBJ_ID               --科目编号
        ,NVL(T2.DUBIL_NUM,T3.DUBIL_NUM)                          AS RCPT_ID               --借据编号
        ,T1.CUST_NAME                                            AS CUST_NM               --客户名称
        ,'11'                                                    AS TRA_TYP               --交易类型 D0121 --11-贷款放款
        --MOD BY LIP 20231031 因保理同时存在利息调整的数据，该部分不能默认为D
        ,T1.DEBIT_CRDT_FLG                                       AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借,C-贷
        ,NVL(T14.PAY_AMT,T1.TRAN_AMT)                            AS TRA_AMT               --交易金额
        --MOD BY LIP 20231031 根据严希婧口径，保理的账户余额是本金-利息调整
        /*,CASE WHEN T3.SUBJ_ID = '13050301' THEN NVL(T3.DUBIL_AMT,0) - NVL(T3.TD_INT_INCOME_ADJ,0)
             --MOD BY 20240312 福费廷贷款发放的交易金额取核心登记的交易金额
             WHEN T3.STD_PROD_ID IN ('203020300001','203020300002','203030600001','203030600002') THEN T3.DISTR_AMT
             ELSE T1.ACTL_BAL
          END                                                    AS ACC_BAL               --账户余额*/
        --MOD BY LIP 20251028 根据严希婧口径，贸易融资的账户余额是本金-利息调整
        ,CASE WHEN T3.SUBJ_ID = '13050301' THEN NVL(T3.DUBIL_AMT,0) - NVL(T3.TD_INT_INCOME_ADJ,0)
              WHEN SUBSTR(T3.STD_PROD_ID,0,5) IN ('20302','20303') --20302国际贸易融资、20303国内贸易融资
              THEN NVL(T3.DUBIL_AMT,0) - NVL(T3.TD_INT_INCOME_ADJ,0)
              ELSE T1.ACTL_BAL
          END                                                    AS ACC_BAL               --账户余额
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200005','202020200006') AND TRIM(T4.ENTER_ACCT_ID) IS NOT NULL --网商小贷 取合同栏位的账号
              THEN T4.ENTER_ACCT_ID
              WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NUM
              WHEN T2.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                   AND TRIM(TBB.RECVBL_BANK_CARD_CARD_NO) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
              THEN TRIM(TBB.RECVBL_BANK_CARD_CARD_NO)
              WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_ACC --ADD BY 20240229
              WHEN T3.STD_PROD_ID IN ('203020700002') THEN T3.LOAN_REPAY_NUM --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
              WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN T14.RECVBL_ACCT_ID
              ELSE DECODE(T1.CNTPTY_ACCT_ID,'0',NVL(TRIM(T2.LOAN_DISTR_ACCT_NUM),TRIM(T3.LOAN_DISTR_ACCT_NUM)),T1.CNTPTY_ACCT_ID)
          END                                                    AS OPP_ACC               --对方账号
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NAME
              WHEN T2.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                   AND TRIM(TBB.RECVBL_BANK_CARD_CARD_NO) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
              THEN TRIM(TBB.RECVBL_BANK_CARD_NAME)
              WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_ACC_NM --ADD BY 20240229
              WHEN T3.STD_PROD_ID IN ('203020700002') THEN T8.CUST_ACCT_NAME --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
              WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN TRIM(T14.RECVER_NAME)
              ELSE NVL(NVL(T1.CNTPTY_ACCT_NAME,T7.CUST_ACCT_NAME),T11.CUST_ACCT_NAME)
          END                                                    AS OPP_ACC_NM            --对方户名
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NUM) IS NOT NULL --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NUM
              WHEN T2.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                   AND TRIM(TBB.RECVBL_BANK_CARD_CARD_NO) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
                   AND LENGTH(TRIM(TBB.RECVBL_BANK_NO)) = 12   --MOD BY LIP 20250903
              THEN TRIM(TBB.RECVBL_BANK_NO)
              WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_PBC_NO --ADD BY 20240229
              WHEN T3.STD_PROD_ID IN ('203020700002') THEN T8.PBC_PAY_BANK_NO --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
              WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN TRIM(T14.RECVER_OPEN_BANK_NAME)
              ELSE NVL(NVL(T7.PBC_PAY_BANK_NO,T1.CNTPTY_BANK_NO),T11.PBC_PAY_BANK_NO)
          END                                                    AS OPP_PBC_NO            --对方行号
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
              WHEN T2.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
                   AND TRIM(TBB.RECVBL_BANK_CARD_CARD_NO) IS NOT NULL --华兴易贷 MOD BY LIP 20250311
              THEN TRIM(TBB.RECVBL_BANK_NAME)
              WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME) IS NOT NULL --平安普惠 助贷产品
              THEN TC.SYS_PRTCPTR_BIGAMT_BANK_NAME
              WHEN T15.RCPT_ID IS NOT NULL THEN T15.OPP_BANK_NM --ADD BY 20240229
              WHEN T3.STD_PROD_ID IN ('203020700002') THEN T8.ORG_NAME --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              --ADD BY LIP 20230725 增加受托支付表中零售的自主支付部分数据的取数逻辑
              WHEN T14.OUT_ACCT_FLOW_NUM IS NOT NULL THEN TRIM(T14.TRAN_IN_BANK_NAME)
              ELSE NVL(NVL(T1.CNTPTY_BANK_NAME,T7.ORG_NAME),T11.ORG_NAME)
          END                                                    AS OPP_BANK_NM           --对方行名
        /*MODIFY BY TANGAN AT 20230111 调整助贷产品对手方信息逻辑 END*/
        ,T1.CHN_ID                                               AS TRA_CHAN              --交易渠道 Z0014
        ,DECODE(T1.CURR_CD,'-',NVL(T2.CURR_CD,T3.CURR_CD),T1.CURR_CD) AS CUR              --币种
        ,T1.TRAN_MEMO_DESCB                                      AS ABSTR                 --摘要
        --MOD BY LIP 20230802 调整冲补抹标志逻辑
        ,CASE WHEN REVS_FLG = '1' THEN '2'
              ELSE '1' --MODIFY XUXIAOBIN 20230809
          END                                                    AS FLUSH_PATCH_FLG       --冲补抹标志
        ,TRIM(T1.TRAN_TELLER_ID)                                 AS TRA_TLR_NO            --交易柜员号
        ,TRIM(T1.AUTH_TELLER_ID)                                 AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,CASE WHEN NVL(T2.STD_PROD_ID,T3.STD_PROD_ID) IN ('203010500001') --法人透支
              THEN 'A03' --透支
              ELSE 'A01' --贷款发放
          END                                                    AS DSTR_RETRV_TYP        --发放收回类型
        ,'Y'                                                     AS PRIN_TRA_FLG          --本金交易标志
        ,T1.TRAN_TM                                              AS TRA_TM                --交易时间
        ,TO_CHAR(T1.TRAN_DT,'YYYYMMDD')                          AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '800924' /*零售信贷部(普惠金融部)*/
              ELSE '800919' /*风险管理部*/
          END                                                    AS DEPT_LINE             --部门条线
        ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '零售贷款放款'
              ELSE '对公贷款放款'
          END                                                    AS DATA_SRC              --数据来源
        ,NULL                                                    AS REPAY_PERDS           --还款期数
        ,T1.MAIN_TRAN_SEQ_NUM                                    AS DTL_SEQ_NUM           --交易序号
        ,CASE WHEN T1.DEBIT_CRDT_FLG = 'C' THEN 'INT'
              ELSE 'PRI'
         END                                                     AS AMT_TYPE              --金额类型
        ,NVL(T2.STD_PROD_ID,T3.STD_PROD_ID)                      AS STD_PROD_ID           --标准产品编号
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
        ,TRIM(T1.TRAN_REF_NO)                                    AS CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    FROM RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW T1 --贷款金融交易流水
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.ACCT_ID = T1.ACCT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T3 --对公贷款账户信息
      ON T3.ACCT_ID = T1.ACCT_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款合同信息 --MODIFY BY TANGAN AT 20230111
      ON T4.CONT_ID = T2.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H TB --贷款合同个人贷款附属信息历史 --MODIFY BY TANGAN AT 20230111 取助贷的入账和出账账号
      --ON TB.CONT_ID = T3.CONT_ID
      ON TB.CONT_ID = T2.CONT_ID --MOD BY LIP 20250903
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO TBB --零售贷款业务合同补充信息 --ADD BY LIP 20250311
      --ON TBB.CONT_ID = T3.CONT_ID
      ON TBB.CONT_ID = T2.CONT_ID --MOD BY LIP 20250903
     AND TBB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 T7 --主账户和内部户账户汇总临时表 零售
      ON T7.CUST_ACCT_ID = NVL(TRIM(T2.LOAN_DISTR_ACCT_NUM),TRIM(T3.LOAN_DISTR_ACCT_NUM))
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 T11 --主账户和内部户账户汇总临时表 助贷
      ON T11.CUST_ACCT_ID = TB.FINAL_ENTY_C_NUM
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 T8 --主账户和内部户账户汇总临时表 出口代付
      ON T8.CUST_ACCT_ID = T3.LOAN_REPAY_NUM
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TC --ADD BY LIP 20230530 互联网贷款取合同登记的还款账号
      ON TC.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(TB.FINAL_ENTER_CLEAR_BK_NO)
     AND TC.RANK_RN = 1
    --MOD BY LIP 20230725取零售贷款部分受托支付表中的账号
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T12
      ON T12.DUBIL_ID = T2.DUBIL_NUM
     AND T12.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H T13
      ON T13.DUBIL_ID = T12.DUBIL_ID
     AND T13.ID_MARK <> 'D'
     AND T13.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T13.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_ENTR_PAY_INFO_H T14 --例如平安普惠的数据现在在受托支付信息表中
      ON T14.OUT_ACCT_FLOW_NUM = T13.OUT_ACCT_FLOW_NUM
     AND T14.ID_MARK <> 'D'
     AND T14.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T14.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP05 T15 --贷款账户交易流水--对方账号信息
      ON T15.RCPT_ID = NVL(T2.DUBIL_NUM,T3.DUBIL_NUM)
     AND NVL(T15.TRA_DR_CR_FLG,'D') = 'D'
   WHERE T1.EVT_CATE_ID = 'DRW'
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公/零售贷款核销';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    )
   WITH TMP_CMM_LOAN_WRT_OFF_INFO AS (
   SELECT A.DUBIL_ID,A.FIR_WRT_OFF_DT,A.LP_ID,A.FINAL_WRT_OFF_RETRA_DT,A.CURR_CD
         ,A.CUST_ID,A.CONT_ID,A.APPL_TELLER_ID,A.STD_PROD_ID,A.TRAN_TIMESTAMP
         ,CASE LVL WHEN 1 THEN 'PRI' --本金
                   WHEN 2 THEN 'INT' --利息
                   WHEN 3 THEN 'FEE' --费用
           END AS AMT_TYPE
         ,CASE LVL WHEN 1 THEN A.ACTL_WRTOFF_LOAN_PRIC
                   WHEN 2 THEN A.ACTL_WRTOFF_IN_BS_INT + A.ACTL_WRTOFF_OFF_BS_INT
                   WHEN 3 THEN A.WRT_OFF_RETRA_ADVC_FEE
           END AS TRAN_AMT
     FROM RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 3)
    WHERE A.FIR_WRT_OFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD')--MOD BY HULJ 20230109
      AND A.STD_PROD_ID <> '201020100057' --MOD BY YJY 20240115 房抵贷产品是T+2数据，特殊处理
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                                               AS DATA_DT               --数据日期
         ,T1.LP_ID                                               AS LGL_REP_ID            --法人编号
         ,NVL(T2.ACCT_INSTIT_ID,T3.ACCT_INSTIT_ID)               AS TRA_ORG_ID            --交易机构编号
         ,V_P_DATE||T1.DUBIL_ID                                  AS TRA_SEQ_NO            --交易流水号
         ,NVL(T2.ACCT_ID,T3.ACCT_ID)                             AS ACC_ID                --账户编号
         ,T1.CUST_ID                                             AS CUST_ID               --客户编号
         ,T1.CONT_ID                                             AS CONT_ID               --合同编号
         ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '1' --对私
               WHEN T3.DUBIL_NUM IS NOT NULL THEN '2' --对公
           END                                                   AS CORP_IND_FLG          --对公对私标志
         ,NVL(T2.ACCT_INSTIT_ID,T3.ACCT_INSTIT_ID)               AS ORG_ID                --机构编号
         ,NVL(T2.SUBJ_ID,T3.SUBJ_ID)                             AS SUBJ_ID               --科目编号
         ,T1.DUBIL_ID                                            AS RCPT_ID               --借据编号
         ,NVL(T2.ACCT_NAME,T3.ACCT_NAME)                         AS CUST_NM               --客户名称
         ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12' --贷款还本
               WHEN T1.AMT_TYPE IN ('INT') THEN '13' --贷款还息
               ELSE '99'
          END                                                    AS TRA_TYP               --交易类型 D0121
         ,'C'                                                    AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
         ,T1.TRAN_AMT                                            AS TRA_AMT               --交易金额
         ,0                                                      AS ACC_BAL               --账户余额
         ,NULL                                                   AS OPP_ACC               --对方账号
         ,NULL                                                   AS OPP_ACC_NM            --对方户名
         ,NULL                                                   AS OPP_PBC_NO            --对方行号
         ,NULL                                                   AS OPP_BANK_NM           --对方行名
         ,'999996'                                               AS TRA_CHAN              --交易渠道 其他-核销
         ,DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD)           AS CUR                   --币种
         ,'核销'                                                 AS ABSTR                 --摘要
         ,'1'                                                    AS FLUSH_PATCH_FLG       --冲补抹标志
         ,T1.APPL_TELLER_ID                                      AS TRA_TLR_NO            --交易柜员号
         ,NULL                                                   AS GRANT_TLR_NO          --授权柜员号
         ,'2'                                                    AS CASH_TRF_FLG          --现转标志
         ,NULL                                                   AS AGT_NM                --代办人姓名
         ,NULL                                                   AS AGT_CRDL_TYP          --代办人证件类型
         ,NULL                                                   AS AGT_CRDL_NO           --代办人证件号码
         ,NULL                                                   AS BATCH_TRF_FLG         --批量转让标志
         ,NULL                                                   AS NORM_RETRV_AMT        --正常回收金额
         ,NULL                                                   AS ADV_REPY_AMT          --提前还款金额
         ,'B03'                                                  AS DSTR_RETRV_TYP        --发放收回类型
         ,NULL                                                   AS  PRIN_TRA_FLG         --本金交易标志
         ,T1.TRAN_TIMESTAMP                                      AS TRA_TM                --交易时间
         ,TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')                  AS TRA_DT                --交易日期
         ,NULL                                                   AS LOAN_CHG_TYP          --贷款变动类型
         ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '800924' /*零售信贷部(普惠金融部)*/
               WHEN T3.DUBIL_NUM IS NOT NULL THEN '800919' /*风险管理部*/
               ELSE '贷款核销'
           END                                                   AS DEPT_LINE             --部门条线
         ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '零售贷款核销'
               WHEN T3.DUBIL_NUM IS NOT NULL THEN '对公贷款核销'
               ELSE '贷款核销'
           END                                                   AS DATA_SRC              --数据来源
         ,'1'                                                    AS REPAY_PERDS           --还款期数
         ,'CNCL'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '01'
                                   WHEN 'INT' THEN '02'
                                   WHEN 'FEE' THEN '03'
           END                                                   AS DTL_SEQ_NUM           --交易序号
         ,T1.AMT_TYPE                                            AS AMT_TYPE              --金额类型
         ,T1.STD_PROD_ID                                         AS STD_PROD_ID           --标准产品编号
         ,NULL                                                   AS DISCNT_INT_RAT        --贴现利率
         ,NULL                                                   AS CTR_NT_ID             --成交单编号
    FROM TMP_CMM_LOAN_WRT_OFF_INFO T1 --贷款核销信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.DUBIL_NUM = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T3 --对公贷款账户信息
      ON T3.DUBIL_NUM = T1.DUBIL_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--零售贷款转让';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    )
   WITH CMM_RETL_LOAN_ACCT_INFO AS
   (SELECT A.DUBIL_NUM,A.CURR_CD,A.LP_ID,A.ACCT_INSTIT_ID,A.ACCT_ID,A.CUST_ID,A.CONT_ID,A.SUBJ_ID,A.CURRT_BAL,
           A.STD_PROD_ID,A.ASSET_TRAN_DT,A.ACCT_NAME,
           CASE LVL WHEN 1 THEN 'PRI' --本金
                    WHEN 2 THEN 'INT' --利息
           END AS AMT_TYPE,
          CASE LVL WHEN 1 THEN PRIC_BAL
                   WHEN 2 THEN IN_BS_INT + OFF_BS_INT
           END AS TRAN_AMT
     FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 2)
    WHERE A.ASSET_TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T1.ACCT_INSTIT_ID                                       AS TRA_ORG_ID            --交易机构编号
        ,T1.DUBIL_NUM                                            AS TRA_SEQ_NO            --交易流水号
        ,T1.ACCT_ID                                              AS ACC_ID                --账户编号
        ,T1.CUST_ID                                              AS CUST_ID               --客户编号
        ,T1.CONT_ID                                              AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,T1.ACCT_INSTIT_ID                                       AS ORG_ID                --机构编号
        ,T1.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T1.DUBIL_NUM                                            AS RCPT_ID               --借据编号
        ,T1.ACCT_NAME                                            AS CUST_NM               --客户名称
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12'   --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13'   --贷款还息
              ELSE '99'
          END                                                    AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                                             AS TRA_AMT               --交易金额
        ,T1.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,T2.CNTPTY_ACCT_NUM                                      AS OPP_ACC               --对方账号
        ,T2.CNTPTY_NAME                                          AS OPP_ACC_NM            --对方户名
        ,T2.CNTPTY_OPEN_BANK_NAME                                AS OPP_PBC_NO            --对方行号
        ,T3.CUST_NAME                                            AS OPP_BANK_NM           --对方行名
        ,'999013'                                                AS TRA_CHAN              --交易渠道 Z0014
        ,T1.CURR_CD                                              AS CUR                   --币种
        ,'零售贷款-转让'                                         AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        ,T2.RGST_TELLER_ID                                       AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B06'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN 'Y'
              ELSE 'N'
          END                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,TO_DATE(TRIM(SUBSTR(T6.TRAN_TIMESTAMP,1,19)),'YYYY-MM-DD HH24:MI:SS') AS TRA_TM  --交易时间
        ,TO_CHAR(T1.ASSET_TRAN_DT,'YYYYMMDD')                    AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800924'                                                AS DEPT_LINE             --部门条线/*零售信贷部(普惠金融部)*/
        ,'零售贷款转让'                                          AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'ZR'||CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
                    WHEN T1.AMT_TYPE = 'INT' THEN '2'
                END                                              AS DTL_SEQ_NUM           --交易序号
        ,T1.AMT_TYPE                                             AS AMT_TYPE              --金额类型
        ,T1.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
    FROM CMM_RETL_LOAN_ACCT_INFO T1 --零售贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO T5 --资产证券化基础资产信息
      ON T5.DUBIL_ID = T1.DUBIL_NUM
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO T2 --资产证券化转让合同信息
      ON T2.CONT_ID = T5.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T3 --对公客户信息表
      ON TRIM(T3.PBC_PAY_BANK_NO) = TRIM(T2.CNTPTY_OPEN_BANK_NAME)
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T4 --零售贷款借据信息
      ON T4.DUBIL_ID = T1.DUBIL_NUM
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_NCBS_CL_TRANSFER_DETAIL T6 --资产转让合同明细表
      ON T6.INTERNAL_KEY = T1.ACCT_ID
     AND T6.ID_MARK <> 'D'
     AND T6.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T6.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款转让';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    )
   WITH CMM_CORP_LOAN_ACCT_INFO AS
   (SELECT A.DUBIL_NUM,A.CURR_CD,A.LP_ID,A.ACCT_INSTIT_ID,A.ACCT_ID,A.CUST_ID,A.CONT_ID,A.SUBJ_ID,A.CURRT_BAL,
           A.STD_PROD_ID,A.ASSET_TRAN_DT,A.ACCT_NAME,
           CASE LVL WHEN 1 THEN 'PRI' --本金
                    WHEN 2 THEN 'INT' --利息
           END AS AMT_TYPE,
          CASE LVL WHEN 1 THEN A.PRIC_BAL
                   WHEN 2 THEN A.IN_BS_INT + OFF_BS_INT
           END AS TRAN_AMT
     FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 2)
    WHERE A.ASSET_TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T1.ACCT_INSTIT_ID                                       AS TRA_ORG_ID            --交易机构编号
        ,T1.DUBIL_NUM                                            AS TRA_SEQ_NO            --交易流水号
        ,T1.ACCT_ID                                              AS ACC_ID                --账户编号
        ,T1.CUST_ID                                              AS CUST_ID               --客户编号
        ,T1.CONT_ID                                              AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,T1.ACCT_INSTIT_ID                                       AS ORG_ID                --机构编号
        ,T1.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T1.DUBIL_NUM                                            AS RCPT_ID               --借据编号
        ,T1.ACCT_NAME                                            AS CUST_NM               --客户名称
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12' --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13' --贷款还息
              ELSE '99'
          END                                                    AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                                             AS TRA_AMT               --交易金额
        ,T1.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,T2.CNTPTY_ACCT_NUM                                      AS OPP_ACC               --对方账号
        ,T2.CNTPTY_NAME                                          AS OPP_ACC_NM            --对方户名
        ,T2.CNTPTY_OPEN_BANK_NAME                                AS OPP_PBC_NO            --对方行号
        ,T3.CUST_NAME                                            AS OPP_BANK_NM           --对方行名
        ,'999013'                                                AS TRA_CHAN              --交易渠道 Z0014
        ,T1.CURR_CD                                              AS CUR                   --币种
        ,'对公贷款-转让'                                         AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        ,T2.RGST_TELLER_ID                                       AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B06'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN 'Y'
              ELSE 'N'
          END                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,TO_DATE(TRIM(SUBSTR(T6.TRAN_TIMESTAMP,1,19)),'YYYY-MM-DD HH24:MI:SS') AS TRA_TM  --交易时间
        ,TO_CHAR(T1.ASSET_TRAN_DT,'YYYYMMDD')                    AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800919'                                                AS DEPT_LINE             --部门条线/*风险管理部*/
        ,'对公贷款转让'                                          AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'ZR'||CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
                    WHEN T1.AMT_TYPE = 'INT' THEN '2'
                END                                              AS DTL_SEQ_NUM           --交易序号
        ,T1.AMT_TYPE                                             AS AMT_TYPE              --金额类型
        ,T1.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
    FROM CMM_CORP_LOAN_ACCT_INFO T1 --对公贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO T5 --资产证券化基础资产信息
      ON T5.DUBIL_ID = T1.DUBIL_NUM
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO T2 --资产证券化转让合同信息
      ON T2.CONT_ID = T5.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T3 --对公客户信息表
      ON TRIM(T3.PBC_PAY_BANK_NO) = TRIM(T2.CNTPTY_OPEN_BANK_NAME)
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_NCBS_CL_TRANSFER_DETAIL T6 --资产转让合同明细表
      ON T6.INTERNAL_KEY = T1.ACCT_ID
     AND T6.ID_MARK <> 'D'
     AND T6.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T6.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T4 --对公贷款借据信息
      ON T4.DUBIL_ID = T1.DUBIL_NUM
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷--放款';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02 NOLOGGING
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,CRN_PRD_ACCRD_INT     --当期应计利息
    ,CRN_PRD_REPY_PNY_INT  --当期还款罚息
    ,CRN_PRD_REPY_CP_INT   --当期还款复息
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,AMT_TYPE              --金额类型
    )
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,A.LP_ID                                                 AS LGL_REP_ID            --法人编号
        ,A.OPEN_ACCT_ORG_ID                                      AS TRA_ORG_ID            --交易机构编号
        ,A.DUBIL_ID                                              AS TRA_SEQ_NO            --交易流水号
        ,A.DUBIL_ID                                              AS ACC_ID                --账户编号
        ,A.CUST_ID                                               AS CUST_ID               --客户编号
        ,A.DUBIL_ID                                              AS CONT_ID               --合同编号
        /*,'1'                                                     AS CORP_IND_FLG          --对公对私标志 1-对私 2-对公*/
        --MOD BY YJY 20250414
        ,CASE WHEN A.STD_PROD_ID IN ('203050100001','203050100002') THEN '2' --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE '1'
          END                                                    AS CORP_IND_FLG          --对公对私标志 1-对私 2-对公
        ,A.ACCT_INSTIT_ID                                        AS ORG_ID                --机构编号
        ,A.SUBJ_ID                                               AS SUBJ_ID               --科目编号
        /*,A.DUBIL_ID                                              AS RCPT_ID               --借据编号 */
        --,A.CORE_DUBIL_ID                                         AS RCPT_ID               --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号
        ,A.DUBIL_ID                                              AS RCPT_ID               --借据编号 MOD BY YJY 20250725
        ,CASE WHEN A.STD_PROD_ID IN ('203050100001','203050100002') THEN B.CUST_NAME --ADD BY YJY 20250218 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE C.CUST_NAME
         END                                                     AS CUST_NM               --客户名称
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
                   AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '0101' --ADD BY LIP 20230925 网商贷债权直转的交易类型改为转入
              ELSE '11'
          END                                                    AS TRA_TYP               --交易类型 D0121
        ,'D'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,A.DISTR_AMT                                             AS TRA_AMT               --交易金额
        ,A.DISTR_AMT                                             AS ACC_BAL               --账户余额
        --MOD BY LIP 20230530 修改联合网贷的对手方信息
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
                   AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '30010000000009867009' --ADD BY LIP 20230925 网商贷债权直转的交易对手等张家伟提供后补充信息
              WHEN TRIM(D.RECVBL_ACCT_ID) IS NOT NULL THEN TRIM(D.RECVBL_ACCT_ID)
              WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN TRIM(A.ENTER_ACCT_ACCT_NUM)
              ELSE A.REPAY_NUM
          END                                                    AS OPP_ACC               --对方账号
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
                   AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '浙江网商银行股份有限公司'  --ADD BY LIP 20230925 网商贷债权直转的交易对手等张家伟提供后补充信息
              WHEN TRIM(D.RECVBL_ACCT_ID) IS NOT NULL THEN TRIM(D.RECVBL_ACCT_NAME)
              WHEN A.STD_PROD_ID IN ('203050100001','203050100002') THEN B.CUST_NAME  --ADD BY YJY 20250218 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE C.CUST_NAME
          END                                                    AS OPP_ACC_NM            --对方户名
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
                   AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '323331000001'  --ADD BY LIP 20230925 网商贷债权直转的交易对手等张家伟提供后补充信息
              ELSE NULL
          END                                                    AS OPP_PBC_NO            --对方行号
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
                   AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '浙江网商银行股份有限公司'  --ADD BY LIP 20230925 网商贷债权直转的交易对手等张家伟提供后补充信息
              WHEN A.STD_PROD_ID IN ('202010100004') THEN '京东'
              WHEN A.STD_PROD_ID IN ('202010100006','202010100008','202020100003') AND TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '微信'
              WHEN A.STD_PROD_ID  IN ('202020200001','203050100001','202010200009' --MOD BY YJY 20250613 新增字节放心借 --202010200009
                                     ,'202010200010','202010200011','202010100007'
                                     ,'201020100063','203050100002','202010100009','202020100002')--add by yjy 20250717 新增分期乐系列产品、唯品消金 add by yjy 20251104 新增好企贷-数据贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
                                     ----MOD BY YJY 20260106 新增202010100009富民联合贷消费、202020100002富民联合贷经营
              THEN NVL(TRIM(A.ENTER_ACCT_BANK_NAME),TRIM(A.REPAY_OPEN_ACCT_ORG_NAME)) --ADD BY YJY 20250218
              WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                                    AS OPP_BANK_NM           --对方行名
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006','202010100008','202020100003') THEN 'WECHAT'--'403011' --微信
              WHEN A.STD_PROD_ID IN ('202010100004') THEN '403002' --京东
              WHEN A.STD_PROD_ID IN ('202020200001','202010200009','202010100009','202020100002') THEN '404028' --抖音支付 --MOD BY YJY 20250613 新增字节放心借 --202010200009  --MOD BY YJY 20260106 新增202010100009富民联合贷消费、202020100002富民联合贷经营
              WHEN A.STD_PROD_ID = '203050100001' THEN '404001' --微众银行 --ADD BY YJY 20250218
              WHEN A.STD_PROD_ID = '202010100007' THEN '403012' --唯品联合贷 第三方支付公司宝付网络科技有限公司 --ADD BY LIP 20250730
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010') THEN '403011' --分期乐都是403011 三方支付-通联 --ADD BY YJY 20250801
               --ELSE '403001' --支付宝
              --MOD BY YJY 20251104 新增微业贷3.0产品的渠道映射，以及优化支付宝相关产品
              WHEN A.STD_PROD_ID IN( '201020100063','203050100002') THEN '901001' --微业贷3.0（好企贷-数据贷） 默认内部渠道
              WHEN A.STD_PROD_ID IN ('02001004165051','02001004120222','202010100001','202010100002'--借呗
                                     ,'02001004135021','202010100003'--花呗
                                     ,'202020100001','202020200004','02001006135011','02001006160048') --网商贷
              THEN '403001' --支付宝
              ELSE NULL            
          END                                                    AS TRA_CHAN              --交易渠道 Z0014
        ,A.CURR_CD                                               AS CUR                   --币种
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
                   AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '贷款转入' --ADD BY LIP 20230925 网商贷债权直转按转入
              ELSE '贷款发放'
          END                                                    AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'A01'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        --MOD BY LIP 20230628 微粒贷的发放日期时间为000000时，取申请时间
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006','202010100008','202020100003') AND TRUNC(A.DISTR_DT) = A.DISTR_DT
              THEN E.APPL_TM
              ELSE A.DISTR_DT
          END                                                    AS TRA_TM                --交易时间
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                          AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800924'                                                AS DEPT_LINE             --部门条线/*零售信贷部(普惠金融部)*/
        ,CASE WHEN A.STD_PROD_ID IN ( '203050100001','203050100002') THEN '对公联合网贷放款'
              ELSE '联合网贷放款'
          END                                                    AS DATA_SRC              --数据来源 --ADD BY YJY 20250218 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
        ,NULL                                                    AS CRN_PRD_ACCRD_INT     --当期应计利息
        ,NULL                                                    AS CRN_PRD_REPY_PNY_INT  --当期还款罚息
        ,NULL                                                    AS CRN_PRD_REPY_CP_INT   --当期还款复息
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'001'                                                   AS DTL_SEQ_NUM           --交易序号
        ,A.STD_PROD_ID                                           AS STD_PROD_ID           --标准产品编号
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
        ,'PRI'                                                   AS AMT_TYPE              --金额类型
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B --对公客户基本信息
      ON B.CUST_ID = A.CUST_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY YJY 20250218
    LEFT JOIN RRP_MDL.O_IML_AGT_MYLOAN_DUBIL D
      ON D.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.O_IML_AGT_WLD_DUBIL_INFO E --微粒贷借据
      ON E.DUBIL_ID = A.DUBIL_ID
   WHERE /*A.DISTR_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
         AND A.DISTR_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1 */
          --MOD BY YJY 20251104 分期乐、好企贷-数据贷（微业贷3.0）产品按照t-1获取数据，一般联合网贷产品获取t-2数据
         ((A.STD_PROD_ID NOT IN ('202010200011','202010200010','201020100063')
           AND A.DISTR_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
           AND A.DISTR_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1)--一般联合网贷
      OR (A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
           AND A.DISTR_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS') 
           AND A.DISTR_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS'))) --分期乐、好企贷-数据贷（微业贷3.0）产品
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷--收回';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
     ,AMT_TYPE             --金额类型
     ,REPAY_TYPE           --还款类型代码
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    )
   WITH CMM_UNITE_WL_REPAY_DTL AS
   (SELECT A.DUBIL_ID,A.REPAY_DT,A.REPAY_FLOW_ID,
           A.REPAY_TYPE_CD,A.CURR_NOMAL_PRIC_BAL,A.CURR_CD,A.PROD_ID,LVL,
           CASE LVL WHEN 1 THEN 'PRI' --本金
                    WHEN 2 THEN 'INT' --利息
                    WHEN 3 THEN 'ODI' --罚息
                    WHEN 4 THEN 'FEE' --费用
            END AS AMT_TYPE,
           CASE LVL WHEN 1 THEN A.CURRT_REPAY_PRIC
                    WHEN 2 THEN A.CURR_REPAY_INT
                    WHEN 3 THEN A.CURRT_REPAY_PNLT
                    WHEN 4 THEN A.CURRT_REPAY_FEE
            END AS TRAN_AMT,
           ROW_NUMBER() OVER(PARTITION BY A.REPAY_FLOW_ID ORDER BY A.DUBIL_ID) AS RN --MOD BY YJY 20250429
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 4)
     WHERE /*A.REPAY_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
       AND A.REPAY_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1 --MOD BY LIP 20250728 字节小微存在账务处理时间和实际还款日期不一致的问题，且明细是增量数据，注释还款日期限制条件
       AND*/ A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     /*ORDER BY A.DUBIL_ID,A.REPAY_DT,A.REPAY_FLOW_ID*/)
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T2.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T2.OPEN_ACCT_ORG_ID                                     AS TRA_ORG_ID            --交易机构编号
        --,T1.REPAY_FLOW_ID || T1.RN                               AS TRA_SEQ_NO            --交易流水号
        ,T1.REPAY_FLOW_ID || '_'||T1.RN                          AS TRA_SEQ_NO            --交易流水号 --MOD BY LIP 20250504
        ,T1.DUBIL_ID                                             AS ACC_ID                --账户编号
        ,T2.CUST_ID                                              AS CUST_ID               --客户编号
        ,T1.DUBIL_ID                                             AS CONT_ID               --合同编号
        --MOD BY YJY 20250414
        ,CASE WHEN T2.STD_PROD_ID IN ( '203050100001','203050100002') THEN '2' --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE '1'
          END                                                    AS CORP_IND_FLG          --对公对私标志 1-对私 2-对公
        ,T2.ACCT_INSTIT_ID                                       AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        /*,T1.DUBIL_ID                                             AS RCPT_ID               --借据编号 */
        --,T2.CORE_DUBIL_ID                                        AS RCPT_ID               --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号
        ,T1.DUBIL_ID                                             AS RCPT_ID               --借据编号 MOD BY YJY 20250725
        ,CASE WHEN T2.STD_PROD_ID IN ('203050100001','203050100002') THEN T6.CUST_NAME --ADD BY YJY 20250218 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE T3.CUST_NAME
          END                                                    AS CUST_NM               --客户名称
        ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN '12' --贷款还本
              WHEN T1.AMT_TYPE = 'INT' THEN '13' --贷款还息
              WHEN T1.AMT_TYPE = 'ODI' THEN '18' --贷款还罚息
              WHEN T1.AMT_TYPE = 'FEE' THEN '19' --费用
          END                                                    AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                                             AS TRA_AMT               --交易金额
        /*MODIFY LHQ 20230112 零售和联合网贷口径的账户余额目前上游是没有实时借据的账户余额，
        所以取不到实时的账户余额 ,经咨询张家伟后，沿用生产口径*/
        ,T2.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,CASE WHEN TRIM(T2.REPAY_NUM) IS NOT NULL THEN TRIM(T2.REPAY_NUM)
              ELSE TRIM(T2.ENTER_ACCT_ACCT_NUM)
          END                                                    AS OPP_ACC               --对方账号
        ,CASE WHEN T2.STD_PROD_ID IN ('202020100001','202020200004')
                   AND TRIM(T5.REPAY_ACCT_ID) IS NOT NULL
              THEN TRIM(T5.REPAY_ACCT_NAME) --网商贷的取借据表的还款账户名称
              WHEN T2.STD_PROD_ID IN ('202010100006','202010100008','202020100003')
                   AND TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NUM) IS NOT NULL
              THEN TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NAME) --微信取账户表的约定还款信息
              WHEN T2.STD_PROD_ID IN ('203050100001','203050100002')--MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              THEN T6.CUST_NAME --ADD BY YJY 20250218
              ELSE T3.CUST_NAME
          END                                                    AS OPP_ACC_NM            --对方户名
        ,CASE WHEN T2.STD_PROD_ID IN ('202010100006','202010100008','202020100003')
                   AND TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NUM) IS NOT NULL
              THEN TRIM(T8.APOT_REPAY_OPEN_BANK_NUM) --微信取账户表的约定还款信息
              WHEN T2.STD_PROD_ID IN ('202020200001','203050100001','202010200009' --MOD BY YJY 20250613 新增字节放心借 - 202010200009
                                     ,'202010200010','202010200011','202010100007'
                                     ,'201020100063','203050100002','202010100009','202020100002')--add by yjy 20250717 新增分期乐系列产品、唯品消金 -- add by yjy 20251104 新增好企贷-数据贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              THEN T2.REPAY_OPEN_ACCT_BANK_ID --ADD BY YJY 20250218
          END                                                    AS OPP_PBC_NO            --对方行号
        ,CASE WHEN T2.STD_PROD_ID IN ('202010100004') THEN '京东'
              WHEN T2.STD_PROD_ID IN ('202010100006','202010100008','202020100003')
                   AND TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NUM) IS NOT NULL
              THEN NVL(TRIM(T8.APOT_REPAY_BANK_NAME),'微信') --微信取账户表的约定还款信息
              WHEN T2.STD_PROD_ID IN ('202020200001','203050100001','202010200009' --MOD BY YJY 20250613 新增字节放心借 --202010200009
                                     ,'202010200010','202010200011','202010100007'
                                     ,'201020100063','203050100002','202010100009','202020100002')--add by yjy 20250717 新增分期乐系列产品、唯品消金 -- add by yjy 20251104 新增好企贷-数据贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              THEN NVL(TRIM(T2.REPAY_OPEN_ACCT_ORG_NAME),TRIM(T2.ENTER_ACCT_BANK_NAME)) --ADD BY YJY 20250218
              WHEN TRIM(T2.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                                    AS OPP_BANK_NM           --对方行名
        ,CASE WHEN T2.STD_PROD_ID IN ('202010100006','202010100008','202020100003') THEN 'WECHAT'--'403011' --微信
              WHEN T2.STD_PROD_ID IN ('202010100004') THEN '403002' --京东
              WHEN T2.STD_PROD_ID IN ('202020200001','202010200009','202010100009','202020100002') THEN '404028' --抖音支付 --ADD BY YJY 20250218 --MOD BY YJY 20250613 新增字节放心借 - 202010200009  --MOD BY YJY 20260106 新增202010100009富民联合贷消费、202020100002富民联合贷经营
              WHEN T2.STD_PROD_ID = '203050100001' THEN '404001' --微众银行 --ADD BY YJY 20250218
              WHEN T2.STD_PROD_ID = '202010100007' THEN '403012' --唯品联合贷 第三方支付公司宝付网络科技有限公司 --ADD BY LIP 20250730
              WHEN T2.STD_PROD_ID IN ('202010200011','202010200010') THEN '403011' --分期乐都是403011 三方支付-通联 --ADD BY YJY 20250801
              --MOD BY YJY 20251104 新增微业贷3.0产品的渠道映射，以及优化支付宝相关产品
              WHEN T2.STD_PROD_ID IN ('201020100063','203050100002') THEN '901001' --微业贷3.0（好企贷-数据贷） 默认内部渠道
              WHEN T2.STD_PROD_ID IN ('02001004165051','02001004120222','202010100001','202010100002'--借呗
                                     ,'02001004135021','202010100003'--花呗
                                     ,'202020100001','202020200004','02001006135011','02001006160048') --网商贷
              THEN '403001' --支付宝
              ELSE NULL
         END                                                     AS TRA_CHAN              --交易渠道 Z0014
        ,DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD)            AS CUR                   --币种
        ,'贷款回收'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '本金'
                                      WHEN 'INT' THEN '利息'
                                      WHEN 'ODI' THEN '罚息'
                                      WHEN 'FEE' THEN '费用'
                      END                                        AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,CASE WHEN T1.REPAY_TYPE_CD = '06' --CD2820
              THEN T1.TRAN_AMT
          END                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,CASE WHEN T1.REPAY_TYPE_CD = '07'
              THEN T1.TRAN_AMT
          END                                                    AS ADV_REPY_AMT          --提前还款金额
        ,CASE WHEN D.DUBIL_ID IS NOT NULL THEN 'B10' --核销后收回ADD20230203XUXIAOBIN
              WHEN T1.REPAY_TYPE_CD = '07' THEN 'B02' --提前还款
              ELSE 'B01'
          END                                                    AS DSTR_RETRV_TYP        --发放收回类型
        ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN 'Y'
              ELSE 'N'
          END                                                    AS PRIN_TRA_FLG          --本金交易标志
        --MOD BY LIP 20230628 根据张家伟口径，如果第三方没有供具体的交易时间点的话，取我行的入账时间或者生成流水时间
        ,CASE WHEN TO_CHAR(T1.REPAY_DT,'HH24:MI:SS') = '00:00:00'
                   AND REGEXP_REPLACE(SUBSTR(T1.REPAY_FLOW_ID,9,6),'[0-9]') IS NULL --ADD BY LIP 20230802 当流水号全是数字时进行比对
                   AND SUBSTR(T1.REPAY_FLOW_ID,9,2) >= 0 AND SUBSTR(T1.REPAY_FLOW_ID,9,2) <= 23
                   AND SUBSTR(T1.REPAY_FLOW_ID,11,2) >= 0 AND SUBSTR(T1.REPAY_FLOW_ID,11,2) < 60
                   AND SUBSTR(T1.REPAY_FLOW_ID,13,2) >= 0 AND SUBSTR(T1.REPAY_FLOW_ID,13,2) < 60
              THEN TO_DATE(TO_CHAR(T1.REPAY_DT,'YYYYMMDD')||' '||SUBSTR(T1.REPAY_FLOW_ID,9,6),'YYYYMMDD HH24:MI:SS')
              ELSE T1.REPAY_DT
          END                                                    AS TRA_TM                --交易时间
        ,TO_CHAR(T1.REPAY_DT,'YYYYMMDD')                         AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800924'                                                AS DEPT_LINE             --部门条线/*零售信贷部(普惠金融部)*/
        ,CASE WHEN T2.STD_PROD_ID IN ('203050100001','203050100002') THEN '对公联合网贷收回'
              ELSE '联合网贷收回'
          END                                                    AS DATA_SRC              --数据来源 --MOD BY YJY 20250218 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
              WHEN T1.AMT_TYPE = 'INT' THEN '2'
              WHEN T1.AMT_TYPE = 'ODI' THEN '3'
              WHEN T1.AMT_TYPE = 'FEE' THEN '4'
              ELSE '9'
          END                                                    AS DTL_SEQ_NUM           --交易序号
        ,T1.AMT_TYPE                                             AS AMT_TYPE              --金额类型
        ,T1.REPAY_TYPE_CD                                        AS REPAY_TYPE            --还款类型代码
        ,T2.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
    FROM CMM_UNITE_WL_REPAY_DTL T1 --联合网贷还款明细
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T2 --联合网贷借据信息
      ON T2.DUBIL_ID = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO D --联合网贷核销信息
      ON D.DUBIL_ID = T1.DUBIL_ID
     AND D.FIR_WRT_OFF_DT <= T1.REPAY_DT
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO T3 --个人客户基础信息
      ON T3.CUST_ID = T2.CUST_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T6 --对公客户基础信息
      ON T6.CUST_ID = T2.CUST_ID
     AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY YJY 20250218
    --ADD BY LIP 20230530 增加联合网贷还款账号取数口径
    LEFT JOIN RRP_MDL.O_IML_AGT_MYLOAN_DUBIL T5 --网商贷借据
      ON T5.DUBIL_ID = T2.DUBIL_ID
    LEFT JOIN RRP_MDL.O_IML_AGT_WLD_DUBIL_INFO T7 --微粒贷借据
      ON T7.DUBIL_ID = T2.DUBIL_ID
    LEFT JOIN RRP_MDL.O_IML_AGT_WLD_ACCT T8 --微粒贷账户
      ON T8.ACCT_ID = T7.ACCT_ID
     AND T8.ACCT_TYPE_CD = T7.ACCT_TYPE_CD
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T4 --标准产品信息表
      ON T4.PROD_ID = T2.STD_PROD_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷核销';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,STD_PROD_ID           --标准产品编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    )
   WITH CMM_UNITE_WL_WRT_OFF_INFO AS (
   SELECT A.DUBIL_ID,A.FIR_WRT_OFF_DT,A.LP_ID,A.FINAL_WRT_OFF_RETRA_DT,A.CURR_CD,
          A.CUST_ID,A.CONT_ID,A.APPL_TELLER_ID,A.STD_PROD_ID,
          CASE LVL WHEN 1 THEN 'PRI' --本金
                   WHEN 2 THEN 'INT' --利息
                   WHEN 3 THEN 'FEE' --费用
           END AS AMT_TYPE,
          CASE LVL WHEN 1 THEN A.ACTL_WRTOFF_LOAN_PRIC
                   WHEN 2 THEN A.ACTL_WRTOFF_IN_BS_INT + A.ACTL_WRTOFF_OFF_BS_INT
                   WHEN 3 THEN A.WRT_OFF_RETRA_ADVC_FEE
           END AS TRAN_AMT
     FROM RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 3)
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T2.OPEN_ACCT_ORG_ID                                     AS TRA_ORG_ID            --交易机构编号
        ,V_P_DATE||T1.DUBIL_ID                                   AS TRA_SEQ_NO            --交易流水号
        ,T1.DUBIL_ID                                             AS ACC_ID                --账户编号
        ,T1.CUST_ID                                              AS CUST_ID               --客户编号
        ,T1.CONT_ID                                              AS CONT_ID               --合同编号
        /*,'1'                                                     AS CORP_IND_FLG          --对公对私标志 1-对私 2-对公*/
        --MOD BY YJY 20250414
        ,CASE WHEN T2.STD_PROD_ID IN ( '203050100001','203050100002') THEN '2' --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE '1'
          END                                                    AS CORP_IND_FLG          --对公对私标志 1-对私 2-对公
        ,T2.ACCT_INSTIT_ID                                       AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        /*,T1.DUBIL_ID                                             AS RCPT_ID               --借据编号 */
        --,T2.CORE_DUBIL_ID                                        AS RCPT_ID               --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号
        ,T1.DUBIL_ID                                             AS RCPT_ID               --借据编号 MOD BY YJY 20250725
        ,NULL                                                    AS CUST_NM               --客户名称
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12' --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13' --贷款还息
              ELSE '99'
          END                                                    AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                                             AS TRA_AMT               --交易金额
        ,0                                                       AS ACC_BAL               --账户余额
        ,NULL                                                    AS OPP_ACC               --对方账号
        ,NULL                                                    AS OPP_ACC_NM            --对方户名
        ,NULL                                                    AS OPP_PBC_NO            --对方行号
        ,NULL                                                    AS OPP_BANK_NM           --对方行名
        ,'999996'                                                AS TRA_CHAN              --交易渠道 其他-核销
        ,DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD)            AS CUR                   --币种
        ,'核销'                                                  AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        ,T1.APPL_TELLER_ID                                       AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B03'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,T1.FIR_WRT_OFF_DT                                       AS TRA_TM                --交易时间
        ,TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')                   AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800924'                                                AS DEPT_LINE             --部门条线/*零售信贷部(普惠金融部)*/
        ,CASE WHEN T2.STD_PROD_ID IN ('203050100001','203050100002') THEN '对公联合网贷核销'
              ELSE '联合网贷核销'
          END                                                    AS DATA_SRC              --数据来源 --MOD BY YJY 20250218 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'CNCL'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '01'
                                  WHEN 'INT' THEN '02'
                                  WHEN 'FEE' THEN '03'
                  END                                            AS DTL_SEQ_NUM           --交易序号
        ,T1.AMT_TYPE                                             AS AMT_TYPE              --金额类型
        ,T1.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
    FROM CMM_UNITE_WL_WRT_OFF_INFO T1 --联合网贷核销信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T2 --联合网贷借据信息
      ON T2.DUBIL_ID = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0
        /*AND T1.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
          AND T1.FIR_WRT_OFF_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1; */
     --MOD BY YJY 20251104 分期乐、好企贷-数据贷（微业贷3.0）产品按照T-1获取数据，一般联合网贷产品按照T-2获取数据
     AND ( ( T1.STD_PROD_ID NOT IN ('202010200011','202010200010','201020100063')
             AND T1.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
             AND T1.FIR_WRT_OFF_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1 ) --一般联合网贷
        OR ( T1.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
             AND T1.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE||'235959','YYYYMMDD HH24:MI:SS')
             AND T1.FIR_WRT_OFF_DT >= TO_DATE(V_P_DATE||'000000','YYYYMMDD HH24:MI:SS') ) ); --分期乐、好企贷-数据贷（微业贷3.0）

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款贴现-买入';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,REL_ID                --票据ID
    ,SYS_IN_FLG            --系统内标识
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
  SELECT DISTINCT
         V_P_DATE                                                AS DATA_DT               --数据日期
        ,A.LP_ID                                                 AS LGL_REP_ID            --法人编号
        ,A.ENTER_ACCT_ORG_ID                                     AS TRA_ORG_ID            --交易机构编号
        ,B.DUBIL_ID                                              AS TRA_SEQ_NO            --交易流水号 --0906修改
        ,B.DUBIL_ID                                              AS ACC_ID                --账户编号
        ,A.CUST_ID                                               AS CUST_ID               --客户编号
        ,B.CONT_ID                                               AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,A.ENTER_ACCT_ORG_ID                                     AS ORG_ID                --机构编号
        ,A.SUBJ_ID                                               AS SUBJ_ID               --科目编号
        ,B.DUBIL_ID                                              AS RCPT_ID               --借据编号
        ,NULL                                                    AS CUST_NM               --客户名称
        ,'11'                                                    AS TRA_TYP               --交易类型 D0121
        ,'D'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,A.ACTL_AMT - A.BUYER_PAY_INT_AMT                        AS TRA_AMT               --交易金额
        ,B.DUBIL_AMT                                             AS ACC_BAL               --账户余额 --发放时的余额是票面金额
        --MOD BY LIP 20230529 修改贴现买入的对手方信息
        ,COALESCE(TRIM(A.DSCNT_PROPS_ACCT_NUM),TRIM(A.DISCNT_APPLIT_ACCT_NUM),TRIM(B.STL_ACCT_NUM)) AS OPP_ACC --对方账号
        ,COALESCE(TRIM(A.DSCNT_PROPS_NAME),E.CUST_NAME,TRIM(B.RECVBL_ACCT_NAME)) AS OPP_ACC_NM --对方户名
        ,COALESCE(TRIM(A.DSCNT_PROPS_OPEN_BANK_NO),TRIM(A.DISCNT_APPLIT_BANK_NO)) AS OPP_PBC_NO --对方行号
        ,NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(B.RECVBL_BANK_NAME)) AS OPP_BANK_NM --对方行名
        ,'409020'                                                AS TRA_CHAN              --交易渠道 99-9020 其他-票据系统
        ,A.CURR_CD                                               AS CUR                   --币种
        ,'票据贴现-买入'                                         AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --,TRIM(A.CUST_MGR_ID)                                     AS TRA_TLR_NO            --交易柜员号
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'A04'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        --ADD BY LIP 20230721 买入数据取借据对应的交易时间
        ,C.TRAN_TM                                               AS TRA_TM                --交易时间
        ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')                          AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800926'                                                AS DEPT_LINE             --部门条线/*公司银行总部*/
        ,'对公贷款贴现-买入'                                     AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'1'                                                     AS DTL_SEQ_NUM           --交易序号
        ,A.STD_PROD_ID                                           AS STD_PROD_ID           --标准产品编号
        ,A.BILL_NUM                                              AS BILL_NUM              --票据号码
        ,A.BILL_ID                                               AS REL_ID                --票据编号
        ,A.SYS_IN_FLG                                            AS SYS_IN_FLG            --系统内标识
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(A.BILL_SUB_INTRV_ID),'-')                      AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)--20230424 XUXIAOBIN MODIFY
     AND B.STD_PROD_ID IN ('204010200001','204010200002') --贴现
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND B.DISTR_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --20230110XUXIAOBIN 注释 0930测试环境特殊处理，拿一整个月
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY LIP 20230721 增加交易时间
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H C
      ON C.OUT_ACCT_FLOW_NUM = B.OUT_ACCT_FLOW_NUM
     AND C.ID_MARK <> 'D'
     AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.DISCNT_APPLIT_BANK_NO)
     AND TTA.RANK_RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态 06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款贴现-结清';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,REL_ID                --票据ID
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
    WITH DISCOUNT_INFO AS (
    SELECT TA.BILL_NUM
          ,NVL(TRIM(TA.BILL_SUB_INTRV_ID),'-') BILL_SUB_INTRV_ID
          ,TA.ACCT_INSTIT_ID,STL_DT,CNTPTY_NAME,CNTPTY_BANK_NO
          ,ROW_NUMBER () OVER (PARTITION BY TA.BILL_NUM,TA.BILL_SUB_INTRV_ID ORDER BY STL_DT ASC) RN
      FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO TA
     WHERE TA.ENTRY_STATUS_CD = '03' --记账成功
       AND TA.TRAN_DIR_CD = '02' --卖出
       AND TA.BUS_TYPE_CD = 'BT01'
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT DISTINCT V_P_DATE                                       AS DATA_DT               --数据日期
        ,A.LP_ID                                                 AS LGL_REP_ID            --法人编号
        ,A.ENTER_ACCT_ORG_ID                                     AS TRA_ORG_ID            --交易机构编号
        ,B.DUBIL_ID                                              AS TRA_SEQ_NO            --交易流水号 --0906修改
        ,B.DUBIL_ID                                              AS ACC_ID                --账户编号
        ,A.CUST_ID                                               AS CUST_ID               --客户编号
        ,B.CONT_ID                                               AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,A.ENTER_ACCT_ORG_ID                                     AS ORG_ID                --机构编号
        ,A.SUBJ_ID                                               AS SUBJ_ID               --科目编号
        ,B.DUBIL_ID                                              AS RCPT_ID               --借据编号
        ,NULL                                                    AS CUST_NM               --客户名称
        ,'99-02'                                                 AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,B.DUBIL_AMT                                             AS TRA_AMT               --交易金额
        ,A.CURRT_BAL                                             AS ACC_BAL               --账户余额
        ,CASE WHEN C.BILL_NUM IS NULL THEN TRIM(A.DRAWER_ACCT_NUM)
              WHEN C.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN TRIM(C.CNTPTY_BANK_NO)
          END                                                    AS OPP_ACC               --对方账号
        ,CASE WHEN C.BILL_NUM IS NULL THEN TRIM(A.DRAWER_NAME)
              WHEN C.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN TRIM(C.CNTPTY_NAME)
          END                                                    AS OPP_ACC_NM            --对方户名
        ,CASE WHEN C.BILL_NUM IS NULL THEN TRIM(A.DRAWER_OPEN_BANK_NO)
              WHEN C.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN TRIM(C.CNTPTY_BANK_NO)
          END                                                    AS OPP_PBC_NO            --对方行号
        ,CASE WHEN C.BILL_NUM IS NULL THEN TRIM(A.DRAWER_OPEN_BANK_NAME)
              WHEN C.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN T6.SYS_PRTCPTR_BIGAMT_BANK_NAME
          END                                                    AS OPP_BANK_NM           --对方行名
        ,'409020'                                                AS TRA_CHAN              --交易渠道 99-9020 其他-票据系统
        ,A.CURR_CD                                               AS CUR                   --币种
        ,'票据贴现-结清'                                         AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --,TRIM(A.CUST_MGR_ID)                                     AS TRA_TLR_NO            --交易柜员号
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'A04'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,A.INT_ACCR_EXP_DT                                       AS TRA_TM                --交易时间
        ,TO_CHAR(A.INT_ACCR_EXP_DT,'YYYYMMDD')                   AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800926'                                                AS DEPT_LINE             --部门条线/*公司银行总部*/
        ,'对公贷款贴现-结清'                                     AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'2'                                                     AS DTL_SEQ_NUM           --交易序号
        ,A.STD_PROD_ID                                           AS STD_PROD_ID           --标准产品编号
        ,A.BILL_NUM                                              AS BILL_NUM              --票据号码
        ,A.BILL_ID                                               AS REL_ID                --票据ID
        ,NULL                                                    AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(A.BILL_SUB_INTRV_ID),'-')                      AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)--20230424 XUXIAOBIN MODIFY
     AND B.STD_PROD_ID IN ('204010200001','204010200002') --贴现
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.DISCNT_APPLIT_BANK_NO)
     AND TTA.RANK_RN = 1
    LEFT JOIN DISCOUNT_INFO C
      ON C.BILL_NUM = A.BILL_NUM
     AND C.BILL_SUB_INTRV_ID = NVL(TRIM(A.BILL_SUB_INTRV_ID),'-')
     AND C.RN = 1
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T6 --票交所会员
      ON T6.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(C.CNTPTY_BANK_NO)
     AND T6.RANK_RN = 1
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03'
     AND A.BILL_STATUS_CD IN ('42')
     AND A.INT_ACCR_EXP_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--买断式转贴现-买入卖出';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,REL_ID                --关联编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
  SELECT DISTINCT V_P_DATE                                       AS DATA_DT               --数据日期
        ,A.LP_ID                                                 AS LGL_REP_ID            --法人编号
        ,A.ACCT_INSTIT_ID                                        AS TRA_ORG_ID            --交易机构编号
        ,A.BUS_ID                                                AS TRA_SEQ_NO            --交易流水号 --20231009修改
        ,B.DUBIL_ID                                              AS ACC_ID                --账户编号
        ,A.CNTPTY_ID                                             AS CUST_ID               --客户编号 --转贴、二级市场福费廷业务的借款人按照交易对手（同业）填报
        ,B.CONT_ID                                               AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,A.ACCT_INSTIT_ID                                        AS ORG_ID                --机构编号
        ,A.SUBJ_ID                                               AS SUBJ_ID               --科目编号
        ,B.DUBIL_ID                                              AS RCPT_ID               --借据编号
        ,NULL                                                    AS CUST_NM               --客户名称
        ,'99-01'                                                 AS TRA_TYP               --交易类型 D0121
        ,CASE WHEN A.TRAN_DIR_CD = '01' THEN 'D'
              ELSE 'C'
          END                                                    AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,A.STL_AMT                                               AS TRA_AMT               --交易金额
        ,CASE WHEN A.TRAN_DIR_CD IN ('01') THEN A.FAC_VAL_AMT
              ELSE A.CURRT_BAL
          END                                                    AS ACC_BAL               --账户余额 --发放时取票面金额
        ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD)         AS OPP_ACC               --对方账号 --参考答疑口径二期740、704调整
        ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) AS OPP_ACC_NM     --对方户名
        ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD)         AS OPP_PBC_NO            --对方行号
        ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) AS OPP_BANK_NM    --对方行名
        ,'409995'                                                AS TRA_CHAN              --交易渠道 99-9020 其他-票据系统
        ,A.CURR_CD                                               AS CUR                   --币种
        ,CASE WHEN A.TRAN_DIR_CD IN ('01') THEN '票据买断式转贴现-买入'
              WHEN A.TRAN_DIR_CD = '02' THEN '票据买断式转贴现-卖出'
          END                                                    AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --,TRIM(A.CUST_MGR_ID)                                     AS TRA_TLR_NO            --交易柜员号
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,CASE WHEN A.TRAN_DIR_CD IN ('01') THEN 'A04'
              ELSE 'B99'
          END                                                    AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        --MOD BY LIP 20230721 修改交易时间的口径
        ,CASE WHEN C.OUT_ACCT_FLOW_NUM IS NOT NULL THEN C.TRAN_TM
              WHEN TEN.DTL_ID IS NOT NULL THEN TEN.CREATE_TM
              ELSE A.BUS_DT
          END                                                    AS TRA_TM                --交易时间
        ,TO_CHAR(A.BUS_DT,'YYYYMMDD')                            AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800935'                                                AS DEPT_LINE             --部门条线/*票据业务事业部*/
        ,CASE WHEN A.TRAN_DIR_CD IN ('01') THEN '买断式转贴现-买入'
              WHEN A.TRAN_DIR_CD = '02' THEN '买断式转贴现-卖出'
          END                                                    AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,CASE WHEN A.TRAN_DIR_CD IN ('01') THEN '1'
              WHEN A.TRAN_DIR_CD = '02' THEN '2'
          END                                                    AS DTL_SEQ_NUM           --交易序号
        ,A.STD_PROD_ID                                           AS STD_PROD_ID           --标准产品编号
        ,A.BILL_NUM                                              AS BILL_NUM              --票据号码
        ,A.BATCH_ID||A.BILL_NUM                                  AS REL_ID                --关联编号
        ,A.DISCNT_INT_RAT                                        AS DISCNT_INT_RAT        --贴现利率
        --,A.CTR_NT_ID                                             AS CTR_NT_ID             --成交单编号
        --MOD BY 20240418 卖出票据的成交单编号需取买入时的成交单编号
        ,CASE WHEN A.TRAN_DIR_CD = '01' THEN A.CTR_NT_ID
              WHEN A.TRAN_DIR_CD = '02' THEN D.CTR_NT_ID
          END                                                    AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(A.BILL_SUB_INTRV_ID),'-')                      AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.CNTPTY_BANK_NO)
     AND TTA.RANK_RN = 1
    LEFT JOIN (SELECT ORG_CN_ABBR,SYS_PRTCPTR_BIGAMT_BANK_NO,SYS_PRTCPTR_BIGAMT_BANK_NAME,MEM_ORG_CD,
                      ROW_NUMBER() OVER(PARTITION BY ORG_CN_ABBR ORDER BY SYS_PRTCPTR_BIGAMT_BANK_NO) RN
                 FROM RRP_MDL.M_TRA_LOAN_DTL_TEMP04) TTB --票交所会员 只有一天数据
      ON TTB.ORG_CN_ABBR = TRIM(A.CNTPTY_NAME)
     AND TTB.RN = 1
    --ADD BY LIP 20230721 增加交易时间
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H C
      ON C.OUT_ACCT_FLOW_NUM = B.OUT_ACCT_FLOW_NUM
     AND C.ID_MARK <> 'D'
     AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_ENTRY TEN --ADD BY LIP 20230727 增加卖出数据的交易时间
      ON TEN.DTL_ID = A.BUS_ID
     AND TEN.RN_RANK = 1
     AND TEN.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO D --卖出票据的成交单编号需取买入时的成交单编号 --ADD BY 20240418
      ON D.BILL_ID = A.BILL_ID
     AND D.TRAN_DIR_CD = '01'
     AND A.TRAN_DIR_CD = '02' --转贴现卖出的票据
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_DIR_CD IN ('01','02') --买入
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
     AND A.SYS_IN_FLG = '1'
     AND A.BUS_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款买断式贴现-结清';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,REL_ID                --关联编号
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
  SELECT /*+USE_HASH(T1 T3 T4)*/
         V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T1.ORG_ID                                               AS TRA_ORG_ID            --交易机构编号
        ,T2.BUS_ID                                               AS TRA_SEQ_NO            --交易流水号
        ,T3.DUBIL_ID                                             AS ACC_ID                --账户编号
        ,T2.CNTPTY_ID                                            AS CUST_ID               --客户编号
        ,T3.CONT_ID                                              AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,T2.ACCT_INSTIT_ID                                       AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T3.DUBIL_ID                                             AS RCPT_ID               --借据编号
        ,T2.CNTPTY_NAME                                          AS CUST_NM               --客户名称
        ,'99-02'                                                 AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T1.FAC_VAL_AMT                                          AS TRA_AMT               --交易金额
        ,T2.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,TRIM(T1.SUGST_PAYER_ORG_CD)                             AS OPP_ACC               --对方账号
        ,TRIM(T1.SUGST_PAYER_NAME)                               AS OPP_ACC_NM            --对方户名
        ,TRIM(T1.SUGST_PAYER_OPEN_BANK_NUM)                      AS OPP_PBC_NO            --对方行号
        ,TRIM(T5.SYS_PRTCPTR_BIGAMT_BANK_NAME)                   AS OPP_BANK_NM           --对方行名
        ,'409020'                                                AS TRA_CHAN              --交易渠道 Z0014
        ,T2.CURR_CD                                              AS CUR                   --币种
        ,'票据转贴现提示付款结清'                                AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        ,TRIM(T1.MODIF_TELLER_ID)                                AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B10'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,T1.APPL_DT                                              AS TRA_TM                --交易时间
        ,TO_CHAR(T1.APPL_DT,'YYYYMMDD')                          AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800935'                                                AS DEPT_LINE             --部门条线 /*票据业务事业部*/
        ,'票据转贴现提示付款'                                    AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'TF'||'01'                                              AS DTL_SEQ_NUM           --交易序号
        ,T2.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,T2.BILL_NUM                                             AS BILL_NUM              --票据号码
        ,T2.BILL_ID                                              AS REL_ID                --关联编号
        ,T2.DISCNT_INT_RAT                                       AS DISCNT_INT_RAT        --贴现利率
        ,T2.CTR_NT_ID                                            AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(T2.BILL_SUB_INTRV_ID),'-')                     AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_IML_EVT_SUGST_PAY_APPL_EVT T1 --提示付款申请事件
   INNER JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO T2 --票据转贴现信息
      ON T2.BILL_ID = T1.BILL_ID
     AND T2.ENTRY_STATUS_CD = '03' --记账成功 新票据
     AND T2.TRAN_DIR_CD = '01'
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T4
      ON T4.BILL_ID = T2.BILL_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3
      ON T3.BILL_ID = T2.BILL_ID
     AND T3.STD_PROD_ID IN ('204010100001','204010100002') --新一代
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T5
      ON T5.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T1.SUGST_PAYER_OPEN_BANK_NUM)
     AND T5.RANK_RN = 1
   WHERE T1.APPL_TRAN_TYPE_CD = '01'
     AND T1.ENTRY_STATUS_CD = '03'
     AND T1.APPL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--票据追索结清';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,SYS_IN_FLG            --系统内标志
    ,REL_ID                --票据ID
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T1.BELONG_ORG_ID                                        AS TRA_ORG_ID            --交易机构编号
        ,T2.BUS_ID                                               AS TRA_SEQ_NO            --交易流水号
        ,T3.DUBIL_ID                                             AS ACC_ID                --账户编号
        ,T1.CUST_ID                                              AS CUST_ID               --客户编号
        ,T3.CONT_ID                                              AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,T1.BELONG_ORG_ID                                        AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T3.DUBIL_ID                                             AS RCPT_ID               --借据编号
        ,T1.CUST_ID                                              AS CUST_NM               --客户名称
        ,'99-02'                                                 AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T3.DUBIL_AMT                                            AS TRA_AMT               --交易金额
        ,T2.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,TRIM(T7.AGREE_PAYOFF_PS_ACCT_ID)                        AS OPP_ACC               --对方账号
        ,TRIM(T7.AGREE_PAYOFF_PS_NAME)                           AS OPP_ACC_NM            --对方户名
        ,TRIM(T7.AGREE_PAYOFF_PS_OPEN_BANK_NO)                   AS OPP_PBC_NO            --对方行号
        ,TRIM(T6.SYS_PRTCPTR_BIGAMT_BANK_NAME)                   AS OPP_BANK_NM           --对方行名
        ,'409020'                                                AS TRA_CHAN              --交易渠道 Z0014
        ,T1.CURR_CD                                              AS CUR                   --币种
        ,'票据追索结清'                                          AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --,T2.CUST_MGR_ID                                          AS TRA_TLR_NO            --交易柜员号
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B10'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,T7.AGREE_PAYOFF_DT                                      AS TRA_TM                --交易时间
        ,TO_CHAR(T7.AGREE_PAYOFF_DT,'YYYYMMDD')                  AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800926'                                                AS DEPT_LINE             --部门条线 /*公司银行总部*/
        ,'票据追索结清'                                          AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'ZS'||'01'                                              AS DTL_SEQ_NUM           --交易序号
        ,T2.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,T1.BILL_NUM                                             AS BILL_NUM              --票据号码
        --UPDATE BY LYH 20231228，系统内外标识没有用到，改为取票据贴现信息表系统内外标识字段
        ,T2.SYS_IN_FLG                                           AS SYS_IN_FLG            --系统内标志
        ,T2.BILL_ID                                              AS REL_ID                --关联编号
        ,T2.DISCNT_INT_RAT                                       AS DISCNT_INT_RAT        --贴现利率
        ,NULL                                                    AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(T2.BILL_SUB_INTRV_ID),'-')                     AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T1 --票据中心信息
   INNER JOIN RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T2 --票据贴现信息
      ON T2.BILL_ID = T1.BILL_ID
     AND T2.DISCNT_STATUS_CD NOT IN ('00','01','02') --UPD BY CG 经过咨询旭华，旧票据的001，012等未成功记账的码值都转为新票据的00失效了，只有记账成功等的转为新票据的06记账成功，新票据的都存在
     AND T2.ENTRY_STATUS_CD = '03'
     AND NVL(TRIM(T2.BILL_SUB_INTRV_ID),'-') = NVL(TRIM(T1.BILL_SUB_INTRV_ID),'-')
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*T1.ETL_DT*/
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3 --对公贷款借据信息
      ON T3.BILL_NUM = T1.BILL_NUM
     AND T3.BILL_UNIQ_MARK_ID = NVL(T2.BILL_ENTRY_ID,T2.BILL_ID) --20230424 数仓陈伟锋反馈关联条件需调整
     AND TRIM(T3.BILL_UNIQ_MARK_ID) IS NOT NULL --20230424 需加非空
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM ORDER BY T.AGREE_PAYOFF_DT DESC) RN
                 FROM RRP_MDL.O_IML_AGT_RECS_AGREE_PAYOFF_APPL_H T
                WHERE T.RECV_OPINION_TYPE_CD = 'SU00'--签收意见类型代码：SU00：同意签收 SU01拒绝签收 其它:未知
                  AND NVL(T.PAYOFF_APPL_INITOR_CD,'-') NOT IN ('W') --Y 银行端 我行发起的,W 网银端 客户发起的 --ADD BY LIP 20230828
                  AND T.ID_MARK <> 'D'
                  AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) T7
      ON T7.BILL_NUM = T1.BILL_NUM
     AND T7.AGREE_PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T7.RN = 1
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T6 --票交所会员 只有一天数据
      ON T6.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T7.AGREE_PAYOFF_PS_OPEN_BANK_NO)/*TRIM(T2.DISCNT_APPLIT_BANK_NO)*/
     AND T6.RANK_RN = 1
   WHERE T1.RECS_FLG = '1' --追索标志
     AND T1.BILL_STATUS_CD IN ('56','42') --56追索已结清 42托收已收回
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--转贴追索数据_IMAS';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,SYS_IN_FLG            --系统内标志
    ,REL_ID                --票据ID
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
    WITH TMP1 AS (
    SELECT TA.*,
           ROW_NUMBER() OVER(PARTITION BY TA.BILL_NUM,TA.BILL_SUB_INTRV_ID ORDER BY TA.CTR_NT_ID DESC) RN
      FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO TA --票据转贴现信息
     INNER JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO TB --票据中心信息
        ON TB.BILL_ID = TA.BILL_ID
       AND TB.BILL_STATUS_CD = 'S14'--已结清
       AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE TA.BUS_TYPE_CD = 'BT01' --转贴现
       AND TA.TRAN_DIR_CD <> '02' --还没卖出的
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T3.ORG_ID                                               AS TRA_ORG_ID            --交易机构编号
        ,T2.BUS_ID                                               AS TRA_SEQ_NO            --交易流水号
        ,T3.DUBIL_ID                                             AS ACC_ID                --账户编号
        ,T2.CNTPTY_ID                                            AS CUST_ID               --客户编号
        ,T3.CONT_ID                                              AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,T3.ORG_ID                                               AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T3.DUBIL_ID                                             AS RCPT_ID               --借据编号
        ,T3.CUST_ID                                              AS CUST_NM               --客户名称
        ,'99-02'                                                 AS TRA_TYP               --交易类型 D0121
        /*,CASE WHEN T2.TRAN_DIR_CD = '01' THEN 'D' --买入
              WHEN T2.TRAN_DIR_CD = '02' THEN 'C' --卖出
              ELSE 'D'
           END                                                   AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷*/
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T1.BILL_AMT                                             AS TRA_AMT               --交易金额
        ,T2.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,TRIM(T1.AGREE_PAYOFF_PS_ACCT_ID)                        AS OPP_ACC               --对方账号
        ,TRIM(T1.AGREE_PAYOFF_PS_NAME)                           AS OPP_ACC_NM            --对方户名
        ,TRIM(T1.AGREE_PAYOFF_PS_OPEN_BANK_NO)                   AS OPP_PBC_NO            --对方行号
        ,TRIM(T5.SYS_PRTCPTR_BIGAMT_BANK_NAME)                   AS OPP_BANK_NM           --对方行名
        ,'400920'                                                AS TRA_CHAN              --交易渠道 Z0014
        ,T1.BILL_CURR_CD                                         AS CUR                   --币种
        ,'票据追索结清'                                          AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --,T2.CUST_MGR_ID                                          AS TRA_TLR_NO            --交易柜员号
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B10'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,T1.RECV_DT                                              AS TRA_TM                --交易时间
        ,TO_CHAR(T1.RECV_DT,'YYYYMMDD')                          AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800926'                                                AS DEPT_LINE             --部门条线/*公司银行总部*/
        ,'转贴追索数据-IMAS'                                     AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'ZTZS'||'01'                                            AS DTL_SEQ_NUM           --交易序号
        ,T2.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,T1.BILL_NUM                                             AS BILL_NUM              --票据号码
        ,NULL                                                    AS SYS_IN_FLG            --系统内标志
        ,T1.BILL_ID                                              AS REL_ID                --票据ID
        ,T2.DISCNT_INT_RAT                                       AS DISCNT_INT_RAT        --贴现利率
        ,T2.CTR_NT_ID                                            AS CTR_NT_ID             --成交单编号
        ,NULL                                                    AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_IML_AGT_RECS_AGREE_PAYOFF_APPL_H T1 --追索同意清偿申请历史
   INNER JOIN TMP1 T2 --票据转贴现信息
      ON T2.BILL_NUM = T1.BILL_NUM
     AND T2.RN = 1
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3 --对公贷款借据信息
      ON T3.BILL_ID = T2.BILL_ID
     AND T3.STD_PROD_ID IN ('204010100001','204010100002')
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T4 --票据贴现信息
      ON T4.BILL_ID = T2.BILL_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T5
      ON T5.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T1.AGREE_PAYOFF_PS_OPEN_BANK_NO)
     AND T5.RANK_RN = 1
   WHERE T1.RECS_AGREE_PAYOFF_STATUS_CD = '02'
     AND T1.RECV_OPINION_TYPE_CD = 'SU00'
     AND NVL(T1.PAYOFF_APPL_INITOR_CD,'-') NOT IN ('W') --Y 银行端 我行发起的,W 网银端 客户发起的 --ADD BY LIP 20230828
     AND T1.RECV_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251113 增加新票追索结清数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--新票转贴追索数据-IMAS';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,SYS_IN_FLG            --系统内标志
    ,REL_ID                --票据ID
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
    WITH TMP1 AS (
  SELECT TA.*,ROW_NUMBER() OVER(PARTITION BY TA.BILL_NUM,TA.BILL_SUB_INTRV_ID ORDER BY TA.CTR_NT_ID DESC) RN
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO TA --票据转贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO TB --票据中心信息
      ON TB.BILL_ID = TA.BILL_ID
     AND TB.BILL_STATUS_CD = 'S14' --已结清
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TA.BUS_TYPE_CD = 'BT01' --转贴现
     AND TA.TRAN_DIR_CD <> '02' --还没卖出的
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T2.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T3.ORG_ID                                               AS TRA_ORG_ID            --交易机构编号
        ,T2.BUS_ID                                               AS TRA_SEQ_NO            --交易流水号
        ,T3.DUBIL_ID                                             AS ACC_ID                --账户编号
        ,T2.CNTPTY_ID                                            AS CUST_ID               --客户编号
        ,T3.CONT_ID                                              AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,T3.ORG_ID                                               AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T3.DUBIL_ID                                             AS RCPT_ID               --借据编号
        ,T3.CUST_ID                                              AS CUST_NM               --客户名称
        ,'99-02'                                                 AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷 --卖出
        ,T1.DRAFT_AMOUNT                                         AS TRA_AMT               --交易金额
        ,T2.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,TRIM(T1.BERECOVERED_ACCOUNT)                            AS OPP_ACC               --对方账号
        ,TRIM(T1.BERECOVERED_NAME)                               AS OPP_ACC_NM            --对方户名
        ,NVL(TRIM(T4.SYS_PRTCPTR_BIGAMT_BANK_NO),TRIM(T1.BERECOVERED_BRH_NO)) AS OPP_PBC_NO            --对方行号
        ,NVL(TRIM(T4.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(T4.ORG_CN_FNAME)) AS OPP_BANK_NM           --对方行名
        ,'400920'                                                AS TRA_CHAN              --交易渠道 Z0014
        ,T2.CURR_CD                                              AS CUR                   --币种
        ,'票据追索结清'                                          AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'B10'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,TO_DATE(TRIM(T1.BERECOVERED_AGREE_DATE),'YYYYMMDD')     AS TRA_TM                --交易时间
        ,TRIM(T1.BERECOVERED_AGREE_DATE)                         AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800926'                                                AS DEPT_LINE             --部门条线/*公司银行总部*/
        ,'新票转贴追索数据-IMAS'                                 AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'ZTZS'||'01'                                            AS DTL_SEQ_NUM           --交易序号
        ,T2.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,T2.BILL_NUM                                             AS BILL_NUM              --票据号码
        ,T2.SYS_IN_FLG                                           AS SYS_IN_FLG            --系统内标志
        ,T2.BILL_ID                                              AS REL_ID                --票据ID
        ,T2.DISCNT_INT_RAT                                       AS DISCNT_INT_RAT        --贴现利率
        ,T2.CTR_NT_ID                                            AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(T2.BILL_SUB_INTRV_ID),'-')                     AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY T1 --贴现前手动追索同意清偿表
   INNER JOIN TMP1 T2 --票据转贴现信息
      ON T2.BILL_NUM = T1.DRAFT_NUMBER
     AND NVL(TRIM(T2.BILL_SUB_INTRV_ID),'-') = NVL(TRIM(T1.CD_RANGE),'-')
     AND T2.RN = 1
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3 --对公贷款借据信息
      ON T3.BILL_ID = T2.BILL_ID
     AND T3.STD_PROD_ID IN ('204010100001','204010100002')
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM T4 
      ON T4.MEM_ORG_CD = TRIM(T1.BERECOVERED_BRH_NO)
     AND T4.ID_MARK <> 'D'
   WHERE T1.RECOVERY_SIGN_MK = 'SU00' --追索人应答标识 SU00 同意
     AND T1.RECOVERY_BUSS_TYPE = 'ZT01' --追索人业务主体类别 ZT01-银行、金融机构
     AND T1.BUSS_FLAG = '02' --交易方向 02 签收
     AND T1.DEAL_STATUS = '12' --处理状态 12 已发送同意签收报文，收到票交所确认成功
     AND T1.SETTLE_STATUS = 'MS04' --结算成功
     AND T1.ACCOUNT_STATUS = '02' --记账状态 02 记账成功
     AND T1.BERECOVERED_AGREE_DATE = V_P_DATE
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贴现到期/卖出_IMAS';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,SYS_IN_FLG            --系统内标志
    ,REL_ID                --票据ID
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
  WITH DISCOUNT_INFO AS (
  SELECT TA.BILL_NUM
        ,TA.BILL_SUB_INTRV_ID
        ,TA.ACCT_INSTIT_ID
        ,STL_DT,CNTPTY_NAME,CNTPTY_BANK_NO,TEN.CREATE_TM,DISCNT_INT_RAT
        ,ROW_NUMBER () OVER (PARTITION BY TA.BILL_NUM,TA.BILL_SUB_INTRV_ID ORDER BY STL_DT ASC,CREATE_TM) RN --MOD BY LIP 20241112 同一天内转贴现多次的，增加创建日期的排序
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO TA
    LEFT JOIN RRP_MDL.O_IML_EVT_ENTRY TEN --ADD BY LIP 20230727 增加卖出数据的交易时间
      ON TEN.DTL_ID = TA.BUS_ID
     AND TEN.RN_RANK = 1
     AND TEN.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TA.ENTRY_STATUS_CD = '03' --记账成功
     AND TA.TRAN_DIR_CD = '02' --卖出
     AND TA.BUS_TYPE_CD = 'BT01'
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,T1.LP_ID                                                AS LGL_REP_ID            --法人编号
        ,T1.ORG_ID                                               AS TRA_ORG_ID            --交易机构编号
        ,T2.BUS_ID                                               AS TRA_SEQ_NO            --交易流水号
        ,T1.DUBIL_ID                                             AS ACC_ID                --账户编号
        ,T1.CUST_ID                                              AS CUST_ID               --客户编号
        ,T1.CONT_ID                                              AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,NVL(T5.ACCT_INSTIT_ID,T2.ENTER_ACCT_ORG_ID)             AS ORG_ID                --机构编号
        ,T2.SUBJ_ID                                              AS SUBJ_ID               --科目编号
        ,T1.DUBIL_ID                                             AS RCPT_ID               --借据编号
        ,T1.CUST_ID                                              AS CUST_NM               --客户名称
        ,'99-01'                                                 AS TRA_TYP               --交易类型 D0121
        ,'C'                                                     AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,T2.FAC_VAL_AMT                                          AS TRA_AMT               --交易金额
        ,T2.CURRT_BAL                                            AS ACC_BAL               --账户余额
        ,CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL THEN TRIM(T2.DRAWER_ACCT_NUM)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN TRIM(T5.CNTPTY_BANK_NO)
          END                                                    AS OPP_ACC               --对方账号
        ,CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL THEN TRIM(T2.DRAWER_NAME)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN TRIM(T5.CNTPTY_NAME)
          END                                                    AS OPP_ACC_NM            --对方户名
        ,CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL THEN TRIM(T2.DRAWER_OPEN_BANK_NO)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN TRIM(T5.CNTPTY_BANK_NO)
          END                                                    AS OPP_PBC_NO            --对方行号
        ,CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL THEN TRIM(T2.DRAWER_OPEN_BANK_NAME)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN T6.SYS_PRTCPTR_BIGAMT_BANK_NAME
          END                                                    AS OPP_BANK_NM           --对方行名
        ,'409020'                                                AS TRA_CHAN              --交易渠道 Z0014
        ,T2.CURR_CD                                              AS CUR                   --币种
        ,'票据贴现-到期/卖出'                                    AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --,TRIM(T2.CUST_MGR_ID)                                    AS TRA_TLR_NO            --交易柜员号
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,'A04'                                                   AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        ,CASE WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN T5.CREATE_TM
              ELSE TO_DATE(V_P_DATE,'YYYYMMDD')
          END                                                    AS TRA_TM                --交易时间
        ,V_P_DATE                                                AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800926'                                                AS DEPT_LINE             --部门条线/*公司银行总部*/
        ,'贴现到期/结清-IMAS'                                    AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,'TXDQJQ'||'02'                                          AS DTL_SEQ_NUM           --交易序号
        ,T2.STD_PROD_ID                                          AS STD_PROD_ID           --标准产品编号
        ,T2.BILL_NUM                                             AS BILL_NUM              --票据号码
        ,NULL                                                    AS SYS_IN_FLG            --系统内标志
        ,T2.BILL_ID                                              AS REL_ID                --票据ID
        ,CASE WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN T5.DISCNT_INT_RAT
              ELSE T2.DISCNT_INT_RAT
          END                                                    AS DISCNT_INT_RAT        --贴现利率
        ,T1.DUBIL_ID                                             AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(T2.BILL_SUB_INTRV_ID),'-')                     AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T1 --对公贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T2 --票据贴现信息
      ON NVL(TRIM(T2.BILL_ENTRY_ID),T2.BILL_ID) = T1.BILL_UNIQ_MARK_ID --20230424 数仓反馈需调整条件
     AND TRIM(T1.BILL_UNIQ_MARK_ID) IS NOT NULL --20230505 同表内借据表逻辑一致
     AND T2.ENTRY_STATUS_CD = '03'
     AND T2.DISCNT_STATUS_CD = '06'
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_ENTRY T3 --记账分录事件
      ON T3.BILL_NUM = T1.BILL_NUM
     AND T3.DTL_STATUS_FLG = '1'
     AND T3.DEBIT_CRDT_DIR_CD = 'C'
     AND T3.SUBJ_ID IN ('13010101','13010201','811605')
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_EVT_BILL_ENTRY T4 --记账事件
      ON T4.BILL_ID = T3.BILL_ID
     AND T4.BUS_ID = T3.DTL_ID
   LEFT JOIN DISCOUNT_INFO T5 --票据转贴信息
     ON T5.BILL_NUM = T2.BILL_NUM
    AND T5.BILL_SUB_INTRV_ID = T2.BILL_SUB_INTRV_ID
    AND T5.RN = 1
   LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T6
     ON T6.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T5.CNTPTY_BANK_NO)
    AND T6.RANK_RN = 1
  WHERE T1.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
    AND ((T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL) --当天到期且没有做转贴现卖出的
          OR T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) --当天做转贴现卖出的
    AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230629 IMAS增加系统内转帖现买入
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--系统内转贴现买入IMAS';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REPAY_PERDS           --还款期数
    ,DTL_SEQ_NUM           --交易序号
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,SYS_IN_FLG            --系统内标志
    ,REL_ID                --票据ID
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    )
  SELECT V_P_DATE                                                AS DATA_DT               --数据日期
        ,A.LP_ID                                                 AS LGL_REP_ID            --法人编号
        ,A.ACCT_INSTIT_ID                                        AS TRA_ORG_ID            --交易机构编号
        ,A.BUS_ID                                                AS TRA_SEQ_NO            --交易流水号 --20231009修改
        ,B.DUBIL_ID                                              AS ACC_ID                --账户编号
        ,A.CNTPTY_ID                                             AS CUST_ID               --客户编号 --转贴、二级市场福费廷业务的借款人按照交易对手（同业）填报
        ,B.CONT_ID                                               AS CONT_ID               --合同编号
        ,'2'                                                     AS CORP_IND_FLG          --对公对私标志
        ,A.ACCT_INSTIT_ID                                        AS ORG_ID                --机构编号
        ,A.SUBJ_ID                                               AS SUBJ_ID               --科目编号
        ,B.DUBIL_ID                                              AS RCPT_ID               --借据编号
        ,NULL                                                    AS CUST_NM               --客户名称
        ,'99-01'                                                 AS TRA_TYP               --交易类型 D0121
        ,CASE WHEN A.TRAN_DIR_CD = '01' THEN 'D' ELSE 'C' END    AS TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
        ,A.STL_AMT                                               AS TRA_AMT               --交易金额
        ,A.FAC_VAL_AMT                                           AS ACC_BAL               --账户余额 --MOD BY LIP 20230821 买入时取票面金额
        ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD)         AS OPP_ACC               --对方账号 --参考答疑口径二期740、704调整
        ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) AS OPP_ACC_NM     --对方户名
        ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD)         AS OPP_PBC_NO            --对方行号
        ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) AS OPP_BANK_NM    --对方行名
        ,'409995'                                                AS TRA_CHAN              --交易渠道 99-9020 其他-票据系统
        ,A.CURR_CD                                               AS CUR                   --币种
        ,'票据买断式转贴现-买入'                                 AS ABSTR                 --摘要
        ,'1'                                                     AS FLUSH_PATCH_FLG       --冲补抹标志
        --,TRIM(A.CUST_MGR_ID)                                     AS TRA_TLR_NO            --交易柜员号
        --MOD BY LIP 20240716 非柜面交易的，交易柜员号可为空
        ,NULL                                                    AS TRA_TLR_NO            --交易柜员号
        ,NULL                                                    AS GRANT_TLR_NO          --授权柜员号
        ,'2'                                                     AS CASH_TRF_FLG          --现转标志
        ,NULL                                                    AS AGT_NM                --代办人姓名
        ,NULL                                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,NULL                                                    AS AGT_CRDL_NO           --代办人证件号码
        ,NULL                                                    AS BATCH_TRF_FLG         --批量转让标志
        ,NULL                                                    AS NORM_RETRV_AMT        --正常回收金额
        ,NULL                                                    AS ADV_REPY_AMT          --提前还款金额
        ,CASE WHEN A.TRAN_DIR_CD IN ('01') THEN 'A04'
              ELSE 'B99'
          END                                                    AS DSTR_RETRV_TYP        --发放收回类型
        ,NULL                                                    AS PRIN_TRA_FLG          --本金交易标志
        --MOD BY LIP 20230721 调整票据交易时间口径
        ,CASE WHEN C.OUT_ACCT_FLOW_NUM IS NOT NULL THEN C.TRAN_TM
              ELSE A.BUS_DT
          END                                                    AS TRA_TM                --交易时间
        ,TO_CHAR(A.BUS_DT,'YYYYMMDD')                            AS TRA_DT                --交易日期
        ,NULL                                                    AS LOAN_CHG_TYP          --贷款变动类型
        ,'800935'                                                AS DEPT_LINE             --部门条线/*票据业务事业部*/
        ,'系统内转贴现买入IMAS'                                  AS DATA_SRC              --数据来源
        ,'1'                                                     AS REPAY_PERDS           --还款期数
        ,CASE WHEN A.TRAN_DIR_CD IN ('01') THEN '1'
              WHEN A.TRAN_DIR_CD = '02' THEN '2'
          END                                                    AS DTL_SEQ_NUM           --交易序号
        ,A.STD_PROD_ID                                           AS STD_PROD_ID           --标准产品编号
        ,A.BILL_NUM                                              AS BILL_NUM              --票据号码
        ,NVL(TRIM(A.SYS_IN_FLG),'0')                             AS SYSYS_IN_FLG          --系统内标志
        ,A.BATCH_ID||A.BILL_NUM                                  AS REL_ID                --关联编号
        ,A.DISCNT_INT_RAT                                        AS DISCNT_INT_RAT        --贴现利率
        ,A.CTR_NT_ID                                             AS CTR_NT_ID             --成交单编号
        ,NVL(TRIM(A.BILL_SUB_INTRV_ID),'-')                      AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.CNTPTY_BANK_NO)
     AND TTA.RANK_RN = 1
    LEFT JOIN (SELECT ORG_CN_ABBR,SYS_PRTCPTR_BIGAMT_BANK_NO,SYS_PRTCPTR_BIGAMT_BANK_NAME,MEM_ORG_CD,
                      ROW_NUMBER() OVER(PARTITION BY ORG_CN_ABBR ORDER BY SYS_PRTCPTR_BIGAMT_BANK_NO) RN
                 FROM RRP_MDL.M_TRA_LOAN_DTL_TEMP04) TTB --票交所会员 只有一天数据
      ON TTB.ORG_CN_ABBR = TRIM(A.CNTPTY_NAME)
     AND TTB.RN = 1
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H C
      ON C.OUT_ACCT_FLOW_NUM = B.OUT_ACCT_FLOW_NUM
     AND C.ID_MARK <> 'D'
     AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_DIR_CD IN ('01') --买入
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
     AND NVL(TRIM(A.SYS_IN_FLG),'0') = '0'
     AND A.BUS_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20250912
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--放款流水登记和审核员工信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP07';
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP07(
    RCPT_ID,              --借据号
    OUT_ACCT_FLOW_NUM,    --出账流水号
    OPER_USER_ID,         --经办员工ID
    LAST_CHECK_USER_ID    --授权员工ID
    )
    WITH TMP1 AS (
  SELECT TC.DUBIL_ID,
         T.OBJECTNO,T.OBJECTTYPE,T.PHASETYPE,T.USERID,T.USERNAME,T.SERIALNO,T.RELATIVESERIALNO,
         ROW_NUMBER() OVER(PARTITION BY TC.DUBIL_ID,T.PHASETYPE ORDER BY T.ENDTIME DESC) RN
    FROM RRP_MDL.O_IOL_ICMS_FLOW_TASK T
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TC
      ON TC.OUT_ACCT_FLOW_NUM = T.OBJECTNO
     AND TC.DISTR_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.OBJECTTYPE IN ('PutOutApply','DGGeneratedBillApply','CreditPutoutApply','SmallPutoutOnlineApply',
                          'CentralBillingApply','GeneratedBillApply')
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.DUBIL_ID AS RCPT_ID,              --借据号
         T.OBJECTNO AS OUT_ACCT_FLOW_NUM,    --出账流水号
         T.USERID   AS OPER_USER_ID,         --发起人员ID
         TB.USERID  AS LAST_CHECK_USER_ID    --最后节点审批人
    FROM TMP1 T
    LEFT JOIN TMP1 TA ON TA.OBJECTNO = T.OBJECTNO AND TA.PHASETYPE = '1040' AND TA.RN = 1 --审批通过 基本都是system,改成取上一层的员工ID
    LEFT JOIN TMP1 TB ON TB.SERIALNO = TA.RELATIVESERIALNO
   WHERE T.PHASETYPE = '1010' AND T.RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--数据汇总';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_LOAN_DTL
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRA_ORG_ID            --交易机构编号
    ,TRA_SEQ_NO            --交易流水号
    ,ACC_ID                --账户编号
    ,CUST_ID               --客户编号
    ,CONT_ID               --合同编号
    ,CORP_IND_FLG          --对公对私标志
    ,ORG_ID                --机构编号
    ,SUBJ_ID               --科目编号
    ,RCPT_ID               --借据编号
    ,CUST_NM               --客户名称
    ,TRA_TYP               --交易类型 D0121
    ,TRA_DR_CR_FLG         --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT               --交易金额
    ,ACC_BAL               --账户余额
    ,OPP_ACC               --对方账号
    ,OPP_ACC_NM            --对方户名
    ,OPP_PBC_NO            --对方行号
    ,OPP_BANK_NM           --对方行名
    ,TRA_CHAN              --交易渠道 Z0014
    ,CUR                   --币种
    ,ABSTR                 --摘要
    ,FLUSH_PATCH_FLG       --冲补抹标志
    ,TRA_TLR_NO            --交易柜员号
    ,GRANT_TLR_NO          --授权柜员号
    ,CASH_TRF_FLG          --现转标志
    ,AGT_NM                --代办人姓名
    ,AGT_CRDL_TYP          --代办人证件类型
    ,AGT_CRDL_NO           --代办人证件号码
    ,BATCH_TRF_FLG         --批量转让标志
    ,NORM_RETRV_AMT        --正常回收金额
    ,ADV_REPY_AMT          --提前还款金额
    ,DSTR_RETRV_TYP        --发放收回类型
    ,PRIN_TRA_FLG          --本金交易标志
    ,TRA_TM                --交易时间
    ,TRA_DT                --交易日期
    ,LOAN_CHG_TYP          --贷款变动类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,CRN_PRD_ACCRD_INT     --当期应计利息
    ,CRN_PRD_REPY_PNY_INT  --当期还款罚息
    ,CRN_PRD_REPY_CP_INT   --当期还款复息
    ,REPAY_PERDS           --期数号
    ,DTL_SEQ_NUM           --交易序号
    ,AMT_TYPE              --金额类型
    ,REPAY_TYPE            --还款类型代码
    ,STD_PROD_ID           --标准产品编号
    ,BILL_NUM              --票据号码
    ,REL_ID                --关联编号
    ,SYS_IN_FLG            --系统内标志
    ,DISCNT_INT_RAT        --贴现利率
    ,CTR_NT_ID             --成交单编号
    ,CALLBK_RS             --回款原因
    ,BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
    ,OPER_USER_ID          --经办员工ID --ADD BY LIP 20250912
    ,LAST_CHECK_USER_ID    --授权员工ID --ADD BY LIP 20250912
    ,CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    )
  SELECT T.DATA_DT                                               AS DATA_DT               --数据日期
        ,T.LGL_REP_ID                                            AS LGL_REP_ID            --法人编号
        ,TRA_ORG_ID                                              AS TRA_ORG_ID            --交易机构编号
        ,T.TRA_SEQ_NO                                            AS TRA_SEQ_NO            --交易流水号
        ,T.ACC_ID                                                AS ACC_ID                --账户编号
        ,T.CUST_ID                                               AS CUST_ID               --客户编号
        ,T.CONT_ID                                               AS CONT_ID               --合同编号
        ,T.CORP_IND_FLG                                          AS CORP_IND_FLG          --对公对私标志
        ,T.ORG_ID                                                AS ORG_ID                --机构编号
        ,T.SUBJ_ID                                               AS SUBJ_ID               --科目编号
        ,T.RCPT_ID                                               AS RCPT_ID               --借据编号
        ,T.CUST_NM                                               AS CUST_NM               --客户名称
        ,T.TRA_TYP                                               AS TRA_TYP               --交易类型
        ,T.TRA_DR_CR_FLG                                         AS TRA_DR_CR_FLG         --交易借贷标志
        ,T.TRA_AMT                                               AS TRA_AMT               --交易金额
        ,T.ACC_BAL                                               AS ACC_BAL               --账户余额
        ,TRIM(REPLACE(REPLACE(T.OPP_ACC,CHR(10),''),CHR(13),'')) AS OPP_ACC               --对方账号
        ,TRIM(REPLACE(REPLACE(COALESCE(TRIM(T.OPP_ACC_NM),TRIM(TB.CUST_ACCT_NAME)),CHR(10),''),CHR(13),'')) AS OPP_ACC_NM --对方户名
        ,CASE WHEN COALESCE(TRIM(T.OPP_PBC_NO),TRIM(TB.ORG_ID1)) IS NOT NULL
              THEN COALESCE(TRIM(TB.PBC_PAY_BANK_NO),TRIM(TC.FIN_INST_CODE),TRIM(T.OPP_PBC_NO),TRIM(TD.FIN_INST_CODE))
              WHEN B.SYS_PRTCPTR_BIGAMT_BANK_NO IS NOT NULL THEN B.SYS_PRTCPTR_BIGAMT_BANK_NO --MOD BY LIP 20250415
              WHEN TRIM(T.OPP_BANK_NM) = '工商银行' THEN '102100099996'
              WHEN TRIM(T.OPP_BANK_NM) = '中信银行' THEN '302100011000'
              WHEN TRIM(T.OPP_BANK_NM) = '兴业银行' THEN '309391000011'
              WHEN TRIM(T.OPP_BANK_NM) = '平安银行' THEN '307584007998'
              WHEN TRIM(T.OPP_BANK_NM) = '民生银行' THEN '305100000013'
              WHEN TRIM(T.OPP_BANK_NM) LIKE '%建设银行' THEN '105100000017'
              WHEN TRIM(T.OPP_BANK_NM) = '招商银行' THEN '308584000013'  --20250903
              WHEN TRIM(T.OPP_BANK_NM) = '中国银行' THEN '104100000004'  --20250903
              WHEN TRIM(T.OPP_BANK_NM) = '光大银行' THEN '303100000006'  --20250903
              WHEN TRIM(T.OPP_BANK_NM) = '农业银行' THEN '103100000026'  --20250903
          END                                                    AS OPP_PBC_NO            --对方行号
        ,CASE WHEN COALESCE(TRIM(T.OPP_BANK_NM),TRIM(T.OPP_PBC_NO),TRIM(TB.ORG_ID1)) IS NOT NULL
              THEN COALESCE(CASE WHEN TRIM(T.OPP_BANK_NM) = '0' THEN NULL ELSE TRIM(T.OPP_BANK_NM) END,
                            CASE WHEN TRIM(A.SYS_PRTCPTR_BIGAMT_BANK_NAME) = '0' THEN NULL
                                 ELSE TRIM(A.SYS_PRTCPTR_BIGAMT_BANK_NAME) END,
                            TRIM(TB.ORG_NAME),
                            TRIM(TC.ORG_NAME),TRIM(TD.ORG_NAME))
          END                                                    AS OPP_BANK_NM           --对方行名
        ,NVL(T.TRA_CHAN,'99')                                    AS TRA_CHAN              --交易渠道
        ,T.CUR                                                   AS CUR                   --币种
        ,TRIM(REPLACE(REPLACE(T.ABSTR,CHR(10),''),CHR(13),''))   AS ABSTR                 --摘要
        ,TRIM(T.FLUSH_PATCH_FLG)                                 AS FLUSH_PATCH_FLG       --冲补抹标志
        ,TRIM(T.TRA_TLR_NO)                                      AS TRA_TLR_NO            --交易柜员号
        ,TRIM(T.GRANT_TLR_NO)                                    AS GRANT_TLR_NO          --授权柜员号
        ,T.CASH_TRF_FLG                                          AS CASH_TRF_FLG          --现转标志
        ,TRIM(T.AGT_NM)                                          AS AGT_NM                --代办人姓名
        ,TRIM(T.AGT_CRDL_TYP)                                    AS AGT_CRDL_TYP          --代办人证件类型
        ,TRIM(T.AGT_CRDL_NO)                                     AS AGT_CRDL_NO           --代办人证件号码
        ,T.BATCH_TRF_FLG                                         AS BATCH_TRF_FLG         --批量转让标志
        ,T.NORM_RETRV_AMT                                        AS NORM_RETRV_AMT        --正常回收金额
        ,T.ADV_REPY_AMT                                          AS ADV_REPY_AMT          --提前还款金额
        ,T.DSTR_RETRV_TYP                                        AS DSTR_RETRV_TYP        --发放收回类型
        ,T.PRIN_TRA_FLG                                          AS PRIN_TRA_FLG          --本金交易标志
        ,T.TRA_TM                                                AS TRA_TM                --交易时间
        ,T.TRA_DT                                                AS TRA_DT                --交易日期
        ,T.LOAN_CHG_TYP                                          AS LOAN_CHG_TYP          --贷款变动类型
        ,T.DEPT_LINE                                             AS DEPT_LINE             --部门条线
        ,UPPER(T.DATA_SRC)                                       AS DATA_SRC              --数据来源
        ,T.CRN_PRD_ACCRD_INT                                     AS CRN_PRD_ACCRD_INT     --当期应计利息
        ,T.CRN_PRD_REPY_PNY_INT                                  AS CRN_PRD_REPY_PNY_INT  --当期还款罚息
        ,T.CRN_PRD_REPY_CP_INT                                   AS CRN_PRD_REPY_CP_INT   --当期还款复息
        ,T.REPAY_PERDS                                           AS REPAY_PERDS           --还款期数号
        ,T.DTL_SEQ_NUM                                           AS DTL_SEQ_NUM           --交易序号
        ,T.AMT_TYPE                                              AS AMT_TYPE              --金额类型
        ,T.REPAY_TYPE                                            AS REPAY_TYPE            --还款类型代码
        ,T.STD_PROD_ID                                           AS STD_PROD_ID           --标准产品编号
        ,T.BILL_NUM                                              AS BILL_NUM              --票据号码
        ,T.REL_ID                                                AS REL_ID                --关联编号
        ,T.SYS_IN_FLG                                            AS SYS_IN_FLG            --系统内标志
        ,T.DISCNT_INT_RAT                                        AS DISCNT_INT_RAT        --贴现利率
        ,T.CTR_NT_ID                                             AS CTR_NT_ID             --成交单编号
        ,T.CALLBK_RS                                             AS CALLBK_RS             --回款原因
        ,T.BILL_SUB_INTRV_ID                                     AS BILL_SUB_INTRV_ID     --票据子区间编号 --ADD BY LIP 20231027
        ,CASE WHEN T.DATA_SRC IN ('对公贷款放款') AND T.TRA_TYP = '11'
              THEN TF.OPER_USER_ID --对公信贷放款的取出账的审批人员
              ELSE NULL
          END                                                    AS OPER_USER_ID          --经办员工ID --ADD BY LIP 20250912
        ,CASE WHEN T.DATA_SRC IN ('对公贷款放款') AND T.TRA_TYP = '11'
              THEN TF.LAST_CHECK_USER_ID --对公信贷放款的取出账的审批人员
              ELSE NULL
          END                                                    AS LAST_CHECK_USER_ID    --授权员工ID --ADD BY LIP 20250912
        ,T.CORE_TRAN_FLOW_NUM                                    AS CORE_TRAN_FLOW_NUM    --核心交易流水号 --ADD BY LIP 20251112
    FROM RRP_MDL.M_TRA_LOAN_DTL_TEMP02 T
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 TB
      ON TB.CUST_ACCT_ID = T.OPP_ACC
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 A
      ON A.SYS_PRTCPTR_BIGAMT_BANK_NO = T.OPP_PBC_NO
     AND A.RANK_RN = 1
    LEFT JOIN (SELECT ORG_CN_ABBR,SYS_PRTCPTR_BIGAMT_BANK_NO,
                      ROW_NUMBER() OVER(PARTITION BY ORG_CN_ABBR ORDER BY SYS_PRTCPTR_BIGAMT_BANK_NO) RN
                 FROM RRP_MDL.M_TRA_LOAN_DTL_TEMP04) B --MOD BY LIP 20250415
      ON B.ORG_CN_ABBR = TRIM(T.OPP_BANK_NM)
     AND B.RN = 1
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP07 TF --ADD BY LIP 20250912 放款流水取出账时对应的员工ID和审核员工
      ON TF.RCPT_ID = T.RCPT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG TC
      ON TC.ORG_ID = TRIM(T.OPP_PBC_NO)
    LEFT JOIN RRP_MDL.ORG_CONFIG TD
      ON TD.ORG_ID = '800'
    LEFT JOIN RRP_MDL.ORG_CONFIG TE
      ON TE.ORG_ID = T.TRA_ORG_ID
   WHERE NVL(T.TRA_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,TRA_SEQ_NO,DTL_SEQ_NUM,REPAY_PERDS,COUNT(1)
    FROM RRP_MDL.M_TRA_LOAN_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_SEQ_NO,DTL_SEQ_NUM,REPAY_PERDS
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG   := '数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE); --表分析

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_TRA_LOAN_DTL;
/

