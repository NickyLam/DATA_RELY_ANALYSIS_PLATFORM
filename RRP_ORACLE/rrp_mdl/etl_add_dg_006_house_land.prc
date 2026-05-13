CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_006_HOUSE_LAND(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_DG_006_HOUSE_LAND
  *  功能描述：补录表-对公-房地产小基表。
  *  创建日期：20221213
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            IML.PTY_IBANK_CUST_CHAT_INFO  --同业客户特有信息
  *            IML.PTY_PARTY_CERT_INFO_H     --当事人证件信息历史
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            IML.REF_PUB_CD                --公共码值表
  *  目标表：  ADD_DG_006_HOUSE_LAND  --房地产小基表

     -- ADD BY LIUYU 20230530 房地产补录表确认口径：业务只能改数，不能新增数据
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20221116  hulj     首次创建。
  *   2    20230426  Liuyu    删除当天新增数据,补录表不接收新增客户条数补录
  *   3    20230530  liuyu    调整继承上天数据逻辑
  *   4    20251020  HYF      押品重构需求，调整押品类型取值过滤
  *   5    20260209  YJY      更新对公小微产品编号
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                             -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                   -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_ADD_DG_006_HOUSE_LAND';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_DG_006_HOUSE_LAND';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                   -- 分区名称
  V_P_DATE      VARCHAR2(8);                                     -- 跑批数据日期
  V_STARTTIME   DATE;                                            -- 处理开始时间
  V_ENDTIME     DATE;                                            -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                             -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                   -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                    -- 来源系统

BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  V_STEP      := 1;
  V_STEP_DESC := '删除当期临时表数据';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_DG_006_HOUSE_LAND_L';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_DG_006_HOUSE_LAND';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP1_ADD_DG_006_HOUSE_LAND';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '备份当期数据-从ETL表继承';
  V_STARTTIME := SYSDATE;

   INSERT INTO ADD_DG_006_HOUSE_LAND_L NOLOGGING
    (DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZFZLDKLB      --04 住房租赁贷款类别
    ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
    ,ZHWYM         --06 账户唯一码
    ,KHWYM         --07 客户唯一码
    ,KHMC          --08 客户名称
    ,SYS_SOURCE    --09 来源系统
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE      --01 数据日期
          ,ACCT_ORG_NUM  --02 账务机构编号
          ,JYWYM         --03 交易唯一码
          ,ZFZLDKLB      --04 住房租赁贷款类别
          ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
          ,ZHWYM         --06 账户唯一码
          ,KHWYM         --07 客户唯一码
          ,KHMC          --08 客户名称
          ,SYS_SOURCE    --09 来源系统
    FROM (
          SELECT A.*
                ,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
            FROM ADD_DG_006_HOUSE_LAND_ETL A
           WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_DG_006_HOUSE_LAND_ETL)
       ) T
    WHERE T.RN = 1
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP      := 3;
  V_STEP_DESC := '备份当期数据-从ADD表继承';
  V_STARTTIME := SYSDATE;

   INSERT INTO RRP_MDL.ADD_DG_006_HOUSE_LAND_L NOLOGGING
    (DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZFZLDKLB      --04 住房租赁贷款类别
    ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
    ,ZHWYM         --06 账户唯一码
    ,KHWYM         --07 客户唯一码
    ,KHMC          --08 客户名称
    ,SYS_SOURCE    --09 来源系统
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE      --01 数据日期
          ,ACCT_ORG_NUM  --02 账务机构编号
          ,JYWYM         --03 交易唯一码
          ,ZFZLDKLB      --04 住房租赁贷款类别
          ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
          ,ZHWYM         --06 账户唯一码
          ,KHWYM         --07 客户唯一码
          ,KHMC          --08 客户名称
          ,SYS_SOURCE    --09 来源系统
      FROM RRP_MDL.ADD_DG_006_HOUSE_LAND T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_DG_006_HOUSE_LAND_L T2
                        WHERE T1.JYWYM = T2.JYWYM
                          AND T2.DATA_DATE = V_P_DATE)
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 支持重跑 --
  V_STEP      := 4;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  V_STEP      := 5;
  V_STEP_DESC := '处理数据-处理临时表取押品最新估值';
  V_STARTTIME := SYSDATE;

  /***************处理临时表取押品最新估值**************/
   INSERT INTO TMP1_ADD_DG_006_HOUSE_LAND(DUBIL_ID, HXB_CFM_VAL)
    SELECT A.DUBIL_ID,SUM(B.HXB_CFM_VAL) AS HXB_CFM_VAL
      FROM RRP_MDL.O_IML_AST_DUBIL_ASSIGN_H A
     INNER JOIN RRP_MDL.O_ICL_CMM_COL_INFO B ON A.ASSET_ID=B.COL_ID AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')  -- 拉链表取数调整。
/*       AND (B.INSTO_STATUS_CD IN ('02','03') OR (B.COL_TYPE_ID IN ('ZY0102001','ZY0102002') AND B.HXB_CFM_VAL >0))
       AND B.COL_TYPE_ID IN ('DY0201001','DY0201002','DY0201003','DY0201005','DY0201999','DY0201004', --居住用房地产
                             'DY0202001','DY0202002','DY0202003','DY0202004','DY0202005','DY0202006','DY0202999',
                             'DY0203001','DY0203002','DY0203003','DY0203999','DY0299001','DY0299002','DY0299003',--经营性房地产
                             'DY0301001','DY0301002', --居住用房地产建设用地使用权
                             'DY0301003','DY0301004','DY0301005','DY0301006','DY0301007','DY0301008','DY0301999',
                             'DY0302001','DY0302002','DY0302003','DY0302004','DY0302999',--经营性房地产建设用地使用权
                             'DY0401001','DY0401002','DY0401003','DY0401004','DY0401999',--房产类在建工程
                             'DY0299999'--其他房地产类押品
                             )*/
       AND (B.INSTO_STATUS_CD IN ('02','03') OR (B.COL_TYPE_ID IN ('99010010010','99010010020') AND B.HXB_CFM_VAL >0))
       AND B.COL_TYPE_ID IN ('80010010010','80010010020','80010010030','80010010040','80010010060','80010010070', --居住用房地产
                             '80020010010','80020010020','80020010030','80020010040','80020010050','80020010060',
                             '80020010070','80020020010','80020020020','80020020030','80020020050','80020030010',--经营性房地产
                             '80030010010', --居住用房地产建设用地使用权
                             '80040010010','80040010020',--经营性房地产建设用地使用权
                             '80050010010','80050020010','80050020020','80050020030',--房产类在建工程
                             '80060010010'--其他房地产类押品
                             )                             
     GROUP BY A.DUBIL_ID
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 6;
  V_STEP_DESC := '处理数据-插入临时表';
  V_STARTTIME := SYSDATE;

   INSERT INTO TMP_ADD_DG_006_HOUSE_LAND
    (
     DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZFZLDKLB      --04 住房租赁贷款类别
    ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
    ,ZHWYM         --06 账户唯一码
    ,KHWYM         --07 客户唯一码
    ,KHMC          --08 客户名称
    ,SYS_SOURCE    --09 来源系统
    ,TJYE          --10 统计余额
    ,DRAWDOWN_DT   --11 放款日期
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                          AS DATA_DATE    --01 数据日期
          ,T2.ACCT_INSTIT_ID                 AS ACCT_ORG_NUM  --02 账务机构编号
          ,T1.DUBIL_ID                       AS JYWYM         --03 交易唯一码
          ,CASE WHEN T1.STD_PROD_ID = '201010300006'
                THEN '04' --04:住房租赁消费贷款
            END                              AS ZFZLDKLB      --04 住房租赁贷款类别          补录字段，可置空，继承上一天数据
          ,NULL                              AS BZXZLZFDKLB   --05 保障性租赁住房贷款类别    补录字段，可置空，继承上一天数据
          ,T2.CONT_ID                        AS ZHWYM         --06 账户唯一码
          ,T2.CUST_ID                        AS KHWYM         --07 客户唯一码
          ,T2.ACCT_NAME                      AS KHMC          --08 客户名称
          ,'对公'                            AS SYS_SOURCE    --09 来源系统
          ,CASE WHEN T2.WRT_OFF_FLG = '1' THEN 0  --核销贷款余额默认为0
                WHEN T2.WRT_OFF_FLG <> '1' THEN
                    CASE WHEN T2.SUBJ_ID LIKE '1313%'
                         THEN NVL(T2.OVDUE_PRIC_BAL, 0) + NVL(T2.IDLE_PRIC, 0) + NVL(T2.BAD_DEBT_PRIC, 0)
                         WHEN T2.SUBJ_ID IN ('30070102')
                         THEN NVL(T2.PRIC_BAL,0) - NVL(T2.WRT_OFF_PRIC, 0)                     -- 正常本金剔除核销本金
                         WHEN T1.STD_PROD_ID IN ('203020300001','203020300002','203030600001','203030600002') AND T2.SUBJ_ID = '13050201'
                         THEN ROUND((NVL(T2.PRIC_BAL, 0) - NVL(T2.WRT_OFF_PRIC, 0) + NVL(T4.N_PV_VARIATION, 0) - NVL(T2.IN_BS_INT, 0)),2)  --国内信用证福费廷剔除公允价值变动、利息调整
                         WHEN T1.STD_PROD_ID IN ('203020300001','203020300002','203030600001','203030600002') AND T2.SUBJ_ID = '13050201'
                         THEN ROUND((NVL(T2.PRIC_BAL, 0) - NVL(T2.WRT_OFF_PRIC, 0) + NVL(T4.N_PV_VARIATION, 0) - NVL(T2.IN_BS_INT, 0)),2)  --国际信用证福费廷剔除利息调整
                         WHEN T1.STD_PROD_ID IN ('203020300001','203020300002','203030600001','203030600002')                           --加上3个福费廷业务
                         THEN ROUND((NVL(T2.PRIC_BAL, 0) - NVL(T2.WRT_OFF_PRIC, 0) + NVL(T4.N_PV_VARIATION, 0) - NVL(T2.IN_BS_INT, 0)),2)  --加上3个福费廷业务
                         ELSE NVL(T2.PRIC_BAL, 0) - NVL(T2.WRT_OFF_PRIC, 0)     --减估值金额部分需要四舍五入保留小数点二位
                     END
            END                              AS TJYE          --10 统计余额
          ,T2.DISTR_DT                       AS DRAWDOWN_DT   --11 放款日期
      FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T1 --对公贷款借据信息表
     INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T2 --对公贷款账户信息表
             ON T1.DUBIL_ID = T2.DUBIL_NUM
            AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T3  --对公贷款合同信息表
             ON T1.CONT_ID = T3.CONT_ID
            AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE T4  --估值报告表 关联估值表取 国内信用证福费廷 公允价值变动
             ON T2.DUBIL_NUM = T4.V_TRADE_NO
            AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      --项目总投资
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO T5 --对公贷款业务合同补充信息
             ON T1.CONT_ID = T5.CONT_ID
            AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN TMP1_ADD_DG_006_HOUSE_LAND T7
             ON T1.DUBIL_ID = T7.DUBIL_ID
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND (T2.OPEN_ACCT_DT <> T2.CLOS_ACCT_DT
        OR (T2.OPEN_ACCT_DT = T2.CLOS_ACCT_DT AND NVL(T1.STD_PROD_ID,T3.STD_PROD_ID) IN ('203020300001','203020300002','203030600001','203030600002')))
       AND (T3.CRDT_TYPE_CD = '02' OR T3.CRDT_TYPE_CD IS NULL ) --00未知 01额度合同  02业务合同
       AND (T1.STD_PROD_ID IN ('203010200002','203010200001')
        OR T1.DIR_INDUS_CD LIKE 'K%'
        OR (T1.STD_PROD_ID IN ('203010200003',/*'203010200007'*/'203010200009') AND REPLACE(TRIM(T3.ESTATE_LOAN_TYPE_CD),'-',NULL) IS NOT NULL )) --mod by yjy 20250209 新增小微产品：203010200009-华兴固贷（小微），非小微仍保留203010200007-其他固定资产贷款
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 7;
  V_STEP_DESC := '处理数据-插入目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_006_HOUSE_LAND NOLOGGING
    (
     DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZFZLDKLB      --04 住房租赁贷款类别
    ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
    ,ZHWYM         --06 账户唯一码
    ,KHWYM         --07 客户唯一码
    ,KHMC          --08 客户名称
    ,SYS_SOURCE    --09 来源系统
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                                               AS DATA_DATE     --01 数据日期
          ,T1.ACCT_ORG_NUM                                        AS ACCT_ORG_NUM  --02 账务机构编号
          ,T1.JYWYM                                               AS JYWYM         --03 交易唯一码
          ,COALESCE(T2.ZFZLDKLB,T3.ZFZLDKLB,T1.ZFZLDKLB)          AS ZFZLDKLB      --04 住房租赁贷款类别
          ,COALESCE(T2.BZXZLZFDKLB,T3.BZXZLZFDKLB,T1.BZXZLZFDKLB) AS BZXZLZFDKLB   --05 保障性租赁住房贷款类别
          ,T1.ZHWYM                                               AS ZHWYM         --06 账户唯一码
          ,T1.KHWYM                                               AS KHWYM         --07 客户唯一码
          ,T1.KHMC                                                AS KHMC          --08 客户名称
          ,T1.SYS_SOURCE                                          AS SYS_SOURCE    --09 来源系统
      FROM TMP_ADD_DG_006_HOUSE_LAND T1       --当天跑批数据
      LEFT JOIN ADD_DG_006_HOUSE_LAND_L T2    --往期数据
        ON T1.JYWYM = T2.JYWYM
      LEFT JOIN
           (SELECT T.*
              FROM ADD_DG_006_HOUSE_LAND_ETL T
             WHERE T.DATA_DATE = (SELECT MAX(TT.DATA_DATE)
                                    FROM ADD_DG_006_HOUSE_LAND_ETL TT
                                   WHERE TT.DATA_DATE < V_P_DATE)
           ) T3  --上一天数据
        ON T1.JYWYM = T3.JYWYM
     WHERE T1.TJYE > 0
           OR TO_CHAR(T1.DRAWDOWN_DT,'YYYY') = SUBSTR(V_P_DATE,1,4)
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /* V_STEP      := 8;
   V_STEP_DESC := '处理数据-当期增加的数据插入目标表';
   V_STARTTIME := SYSDATE;

    INSERT INTO ADD_DG_006_HOUSE_LAND
   (
     DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZFZLDKLB      --04 住房租赁贷款类别
    ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
    ,ZHWYM         --06 账户唯一码
    ,KHWYM         --07 客户唯一码
    ,KHMC          --08 客户名称
    ,SYS_SOURCE    --09 来源系统
   )
   SELECT
     V_P_DATE      --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZFZLDKLB      --04 住房租赁贷款类别
    ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
    ,ZHWYM         --06 账户唯一码
    ,KHWYM         --07 客户唯一码
    ,KHMC          --08 客户名称
    ,SYS_SOURCE    --09 来源系统
   FROM ADD_DG_006_HOUSE_LAND_L A
   WHERE NOT EXISTS (SELECT 1 FROM ADD_DG_006_HOUSE_LAND T WHERE T.DATA_DATE = V_P_DATE AND A.JYWYM = T.JYWYM)
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
*/
   V_STEP      := 9;
   V_STEP_DESC := '增加表分析及跑批过程完成表';
   V_STARTTIME := SYSDATE;

     --表分析
     ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PART_NAME, O_ERRCODE);
     --插入过程跑批完成记录表
     INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
     VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.ADD_DG_006_HOUSE_LAND T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 程序跑批结束记录 --
   V_STEP      := 10;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_ADD_DG_006_HOUSE_LAND;
/

