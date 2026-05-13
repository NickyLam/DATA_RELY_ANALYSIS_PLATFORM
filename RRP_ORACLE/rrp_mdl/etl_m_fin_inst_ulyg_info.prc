CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_FIN_INST_ULYG_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
 *  程序名称：ETL_M_FIN_INST_ULYG_INFO
 *  功能描述：标的物基础信息
 *  创建日期：20220930
 *  开发人员：MW
 *  来源表：
 *
 *  目标表：  M_FIN_INST_ULYG_INFO
 *  配置表：
 *  修改情况：序号  修改日期  修改人   修改原因
 *
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;            --处理步骤
  V_STEP_DESC VARCHAR2(100);           --处理步骤描述
  V_P_DATE    VARCHAR2(8);             --跑批数据日期
  V_STARTTIME DATE;                    --处理开始时间
  V_ENDTIME   DATE;                    --处理结束时间
  V_SQLCOUNT  INTEGER := 0;            --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);           --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);           --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_FIN_INST_ULYG_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_FIN_INST_ULYG_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_FIN_INST_ULYG_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_FIN_INST_ULYG_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
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
  V_STEP := 3;
  V_STEP_DESC := '插入标的物基础信息表--同业金融工具';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_ULYG_INFO
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,ORG_ID             --机构编号
    ,ULYG_ID            --标的物编号
    ,ULYG_PROD_CL       --标的产品分类
    ,CUR                --币种
    ,BOOK_AMT           --账面金额
    ,RATE               --利率
    ,VAL_DT             --起息日期
    ,EXP_DT             --到期日期
    ,ACPT_ORG_TYP       --承兑机构类型
    ,ORIG_BILL_HLDR_TYP --原始持票人类型
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    )
  SELECT V_P_DATE                                                     AS DATA_DT            --数据日期
        ,A.LP_ID                                                      AS LGL_REP_ID         --法人编号
        ,A.BELONG_ORG_ID                                              AS ORG_ID             --机构编号
        ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID  AS ULYG_ID            --标的物编号
        ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' THEN '0102'
              WHEN A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '0103'
              WHEN A.ASSET_TYPE_NAME LIKE '%同业理财%' THEN '0502'
              WHEN A.ASSET_TYPE_NAME LIKE '%净值型理财产品%' THEN '0502'
              WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR A.ASSET_TYPE_NAME LIKE '%类信贷资产%' THEN '0499'
              WHEN A.ASSET_TYPE_NAME LIKE '%券商资管计划%' OR A.ASSET_TYPE_NAME LIKE '%票据资管计划%'
                   OR A.ASSET_TYPE_NAME LIKE '%净值型资管计划%' OR A.ASSET_TYPE_NAME LIKE '%类信贷资产%'
              THEN '0604'
              WHEN A.ASSET_TYPE_NAME LIKE '%保险资管计划%' THEN '0605'
              WHEN A.ASSET_TYPE_NAME LIKE '%北金所债权融资计划%' OR A.ASSET_TYPE_NAME LIKE '%信贷类资产%'
                   OR A.ASSET_TYPE_NAME LIKE '%券商固定收益凭证%'
              THEN '0301'
              ELSE '9999'
          END                                                         AS ULYG_PROD_CL       --标的产品分类
        ,A.CURR_CD                                                    AS CUR                --币种
        ,A.FAC_VAL_AMT                                                AS BOOK_AMT           --账面金额
        ,A.FAC_VAL_INT_RAT                                            AS RATE               --利率
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                               AS VAL_DT             --起息日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                 AS EXP_DT             --到期日期
        ,NVL(B.ISSU_FINA_CODE,
             CASE WHEN A.DISCOV_ORG_CLS_NAME LIKE '%基金公司%' THEN 'E50000'  --基金公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%财务公司%' THEN 'C50000'  --财务公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%金融租赁公司%' THEN 'D30000'  --金融租赁公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%汽车金融公司%' THEN 'D40000'  --汽车金融公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%信托公司%' THEN 'D10000'  --信托公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%资产管理公司%' THEN 'D20000'  --资产管理公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%券商%' THEN 'E10000'  --券商
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%农村信用社%' THEN 'C31000'  --农村信用社
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%外资银行%' THEN 'C12200'  --外资商业银行
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%邮储银行%' THEN 'C12141'  --邮储
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%村镇银行%' THEN 'C12142'  --村镇银行
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%农村商业银行%' THEN 'C12132'  --农村商业银行
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%城市商业银行%' THEN 'C12131'  --城市商业银行
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%国有大型商业银行%' AND A.DISCOV_ORG_CLS_NAME NOT LIKE '%交通%' THEN 'C12111'  --国有独资商业银行
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%国有大型商业银行%' AND A.DISCOV_ORG_CLS_NAME LIKE '%交通%' THEN 'C12112'  --其他大型商业银行
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%股份制商业银行%' THEN 'C12120'  --全国性中小型商业银行
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%民营银行%' THEN 'C12140'  --其他商业银行(不含邮储)
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%保险公司%' THEN 'F10000'  --财产保险公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%北金所%' THEN 'I30000'  --其他金融辅助机构（不含SPV）
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%消费金融公司%' THEN 'I40000'  --消费金融公司
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%前海股权交易中心%' THEN 'G10000'  --交易所
                  WHEN A.DISCOV_ORG_CLS_NAME LIKE '%资管1635计划%' AND A.DISCOV_ORG_CLS_NAME LIKE '%资产管理计划%' THEN 'I20000'  --其他
                  ELSE ''
              END)                                                    AS ACPT_ORG_TYP       --承兑机构类型
        ,NULL                                                         AS ORIG_BILL_HLDR_TYP --原始持票人类型
        ,NULL                                                         AS DEPT_LINE          --部门条线
        ,'同业金融工具'                                               AS DATA_SRC           --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM A  --同业金融工具表
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.FIN_INSTM_ID,T.ASSET_TYPE_ID,T.MARKET_TYPE_ID ORDER BY T.UDER_COLL_WAY_CD) RN
                 FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST T) A1 --20201112 BY WL 生产跑批发现目前同业非标投资表有多条数据导致主键冲突，经与BA沟通和生产数据验证暂时 未发现 相同金融工具存在不同的资产类型（判断募集方式），因此改造程序只取一条数据
      ON A1.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND A1.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND A1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND A1.RN = 1
    LEFT JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY T.FIN_INSTM_ID,T.ASSET_TYPE_ID,T.MARKET_TYPE_ID ORDER BY T.BELONG_ORG_ID) RN
                 FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST T --同业证券持仓表
                WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))ACC
      ON ACC.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND ACC.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND ACC.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND ACC.RN = 1
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO C1 --同业交易对手信息
      ON C1.SRC_PARTY_ID = ACC.ISSUER_ID
     AND C1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ADD_AGRE_SUBJECT_INFO B
      ON B.SUBJ_NO = A.FIN_INSTM_ID || '.' || A.ASSET_TYPE_ID || '.' || A.MARKET_TYPE_ID
    --MDF BY HAP 20210325 其他标的物与债券信息表为互斥关系，用以下逻辑更合适
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.FIN_INSTM_ID || '.' || A.ASSET_TYPE_ID || '.' || A.MARKET_TYPE_ID
         NOT IN (SELECT B.FIN_INSTM_ID || '.' || B.ASSET_TYPE_ID || '.' || B.MARKET_TYPE_ID
                   FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A   --同业债券投资表
                   LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM B  --同业金融工具表
                     ON B.FIN_INSTM_ID||'.'||B.MARKET_TYPE_ID = A.FIN_INSTM_ID||'.'||A.MARKET_TYPE_ID
                    AND B.ASSET_TYPE_ID = A.ASSET_TYPE_ID
                    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  WHERE (B.ASSET_TYPE_NAME LIKE '%公司债%' OR B.ASSET_TYPE_NAME LIKE '%企业债%'
                         OR B.ASSET_TYPE_NAME LIKE '%资产支持%'
                         OR B.ASSET_TYPE_NAME LIKE '%其他债券%' OR B.ASSET_TYPE_NAME LIKE '%私募债%' )
                    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
     AND A.ASSET_TYPE_NAME NOT IN (SELECT DISTINCT B.ASSET_TYPE_NAME
                                     FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT B  --同业现金借贷
                                    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '插入标的物基础信息表--同业金融工具';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_ULYG_INFO
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,ORG_ID             --机构编号
    ,ULYG_ID            --标的物编号
    ,ULYG_PROD_CL       --标的产品分类
    ,CUR                --币种
    ,BOOK_AMT           --账面金额
    ,RATE               --利率
    ,VAL_DT             --起息日期
    ,EXP_DT             --到期日期
    ,ACPT_ORG_TYP       --承兑机构类型
    ,ORIG_BILL_HLDR_TYP --原始持票人类型
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    )
  SELECT V_P_DATE                        AS DATA_DT            --数据日期
        ,A.LP_ID                         AS LGL_REP_ID         --法人编号
        ,'800'                           AS ORG_ID             --机构编号
        ,A.BOND_ID                       AS ULYG_ID            --标的物编号
        ,'1001'                          AS ULYG_PROD_CL       --标的产品分类
        ,A.CURR_CD                       AS CUR                --币种
        ,A.FAC_VAL                       AS BOOK_AMT           --账面金额
        ,A.FAC_VAL_INT_RAT               AS RATE               --利率
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')  AS VAL_DT             --起息日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')    AS EXP_DT             --到期日期
        ,B.ISSU_FINA_CODE                AS ACPT_ORG_TYP       --承兑机构类型
        ,NULL                            AS ORIG_BILL_HLDR_TYP --原始持票人类型
        ,NULL                            AS DEPT_LINE          --部门条线
        ,'债券基本信息'                  AS DATA_SRC           --数据来源
    FROM RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO A  --债券基本信息表
    LEFT JOIN RRP_MDL.ADD_AGRE_SUBJECT_INFO B
      ON B.SUBJ_NO = A.BOND_ID
   WHERE A.BOND_TYPE_CD = 'W'
     AND A.DATA_SRC_SYS_IDF = 'CTMS'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_M_FIN_INST_ULYG_INFO;
/

