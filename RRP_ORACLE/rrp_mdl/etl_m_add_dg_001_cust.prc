CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ADD_DG_001_CUST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_ADD_DG_001_CUST
  *  功能描述：补录表-对公-客户基表。
  *  创建日期：20221213
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            IML.PTY_IBANK_CUST_CHAT_INFO  --同业客户特有信息
  *            IML.PTY_PARTY_CERT_INFO_H     --当事人证件信息历史
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            IML.REF_PUB_CD                --公共码值表
  *  目标表：  M_ADD_DG_001_CUST  --客户基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114  hulj     首次创建。
  *             2    20230531  liuyu    新增重复值校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                              -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                    -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_M_ADD_DG_001_CUST';        -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'M_ADD_DG_001_CUST';            -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                    -- 分区名称
  V_P_DATE      VARCHAR2(8);                                      -- 跑批数据日期
  V_STARTTIME   DATE;                                             -- 处理开始时间
  V_ENDTIME     DATE;                                             -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                              -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                    -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                     -- 来源系统

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

   --DELETE FROM M_ADD_DG_001_CUST T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
   ETL_PARTITION_ADD(I_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD的数据插入到临时表';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_M_ADD_DG_001_CUST';

  INSERT INTO TMP_M_ADD_DG_001_CUST
  (
    DATA_DATE           --01 数据日期
   ,ACCT_ORG_NUM        --02 账务机构编号
   ,KHWYM               --03 客户唯一码
   ,KHMC                --04 客户名称
   ,ZJLX                --05 证件类型
   ,ZJHM                --06 证件号码
   ,SFGTQY              --07 是否关停企业
   ,BXCDJMFYLB          --08 本行承担/减免费用类別
   ,BNLJCDHJMDXDXGFYJE  --09 本年累计承担或减免的信贷相关费用金额（元）
   ,SYS_SOURCE          --10 来源系统
  )
  SELECT /*+ PARALLEL(A,4) */
    DATA_DATE           --01 数据日期
   ,ACCT_ORG_NUM        --02 账务机构编号
   ,KHWYM               --03 客户唯一码
   ,KHMC                --04 客户名称
   ,ZJLX                --05 证件类型
   ,ZJHM                --06 证件号码
   ,SFGTQY              --07 是否关停企业
   ,BXCDJMFYLB          --08 本行承担/减免费用类別
   ,BNLJCDHJMDXDXGFYJE  --09 本年累计承担或减免的信贷相关费用金额（元）
   ,SYS_SOURCE          --10 来源系统
  FROM (
      SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_001_CUST_ETL A
      WHERE A.DATA_DATE = V_P_DATE
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
  V_STEP_DESC := 'ADD数据与跑批数据插入到目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_ADD_DG_001_CUST NOLOGGING
  (
    DATA_DATE           --01 数据日期
   ,ACCT_ORG_NUM        --02 账务机构编号
   ,TJKHLB              --03 统计客户类别
   ,KHWYM               --04 客户唯一码
   ,KHMC                --05 客户名称
   ,ZJLX                --06 证件类型
   ,ZJHM                --07 证件号码
   ,DGKHATJFL           --08 对公客户按统计分类
   ,SFGTQY              --09 是否关停企业
   ,SFKCQY              --10 是否科创企业
   ,BXCDJMFYLB          --11 本行承担/减免费用类別
   ,BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
   ,SYS_SOURCE          --13 来源系统
   ,ZDHJAQFXQYFL        --14 重大环境安全风险企业分类 add by hulj20221223
   ,FHLSDKYTFLDHYLB     --15 符合绿色贷款用途分类的行业类别  add by hulj20230129
   ,RMSFQY              --16 人行是否企业
  )
  SELECT /*+ PARALLEL(A,4),PARALLEL(T1,4) */
    A.DATA_DATE                          AS DATA_DATE         --01 数据日期
   ,A.ACCT_ORG_NUM                       AS ACCT_ORG_NUM   --02 账务机构编号
   ,CASE WHEN T1.CUST_TYPE_CD = '25' OR T2.PARTY_ID IS NOT NULL 
         THEN '12' 
         ELSE '11' 
     END                                 AS TJKHLB --03 统计客户类别  '12'同业客户  '11'对公客户
   ,A.KHWYM                              AS KHWYM              --04 客户唯一码
   ,A.KHMC                               AS KHMC                --05 客户名称
   ,A.ZJLX                               AS ZJLX                --06 证件类型
   ,A.ZJHM                               AS ZJHM                --07 证件号码
   ,CASE WHEN REPLACE(T3.CERT_NUM,'-','') LIKE '91%' AND T1.CUST_NAME NOT LIKE '%经济合作社%' --91：企业
         --THEN '1'   --企业
         --THEN '11'   --企业法人  补录删除1-企业码值
         THEN DECODE (T1.NATNAL_ECON_DEPT_TYPE_CD,'C02','12','11')   --11：企业法人，12：企业非法人  C02非公司企业
         WHEN REPLACE(T3.CERT_NUM,'-','') LIKE '91%' AND T1.CUST_NAME LIKE '%经济合作社%'
         THEN '3'   --农村集体经济组织
         WHEN REPLACE(T3.CERT_NUM,'-','') LIKE '93%' --93：农民专业合作社
         THEN '0'   --农民专业合作社
         WHEN REPLACE(T3.CERT_NUM,'-','') LIKE '52%' --52：民办非企业单位
         -- THEN '5'   --事业单位
         THEN '9'   --非企业法人 信用证代码52开头为民办非企业单位
         WHEN REPLACE(T3.CERT_NUM,'-','') LIKE '11%' --11：机关
         THEN '2'   --行政机关
         WHEN REPLACE(T3.CERT_NUM,'-','') LIKE '12%' --12：事业单位
         THEN '5'   --事业单位 ，信用证代码52开头为民办非企业单位
         WHEN REPLACE(T3.CERT_NUM,'-','') LIKE '51%' --51：社会团体
         THEN '4'   --社会团体
         WHEN SUBSTR(REPLACE(T3.CERT_NUM,'-',''),1,2) NOT IN ('91','93','51','52','11','12')
         THEN '6'   --其他对公客户
    ELSE 'NA' END                        AS DGKHATJFL    --08 对公客户按统计分类
   ,NVL(B.SFGTQY,A.SFGTQY)               AS SFGTQY            --09 是否关停企业
   ,CASE WHEN T1.SCI_TECH_CORP_CLS_CD ='03' 
         THEN 'Y' 
         ELSE 'N' 
     END                                 AS SFKCQY   --10 是否科创企业
   ,NVL(B.BXCDJMFYLB,A.BXCDJMFYLB)       AS BXCDJMFYLB    --11 本行承担/减免费用类別
   ,NVL(B.BNLJCDHJMDXDXGFYJE,A.BNLJCDHJMDXDXGFYJE) AS BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
   ,A.SYS_SOURCE                         AS SYS_SOURCE    --13 来源系统
   ,NULL                                 AS ZDHJAQFXQYFL          --14 重大环境安全风险企业分类        ADD取消，M_ADD不加工
   ,NULL                                 AS FHLSDKYTFLDHYLB       --15 符合绿色贷款用途分类的行业类别  ADD取消，M_ADD不加工
   ,CASE WHEN T1.NATNAL_ECON_DEPT_TYPE_CD = 'C99' THEN '否'
         WHEN T1.NATNAL_ECON_DEPT_TYPE_CD IS NULL THEN '不适用'
         ELSE '是' 
     END                                 AS RHSFQY            --16 人行是否企业
  FROM RRP_MDL.ADD_DG_001_CUST A
  LEFT JOIN TMP_M_ADD_DG_001_CUST B
    ON A.KHWYM = B.KHWYM
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T1 --对公客户基本信息表
    ON A.KHWYM = T1.CUST_ID
   AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO T2 --同业客户特有信息
    ON T1.CUST_ID = T2.PARTY_ID
   AND T2.FIN_INST_CATE_CD!='000000'
   AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN (SELECT
               TT.PARTY_ID
              ,TT.CERT_TYPE_CD
              ,TT.CERT_NUM
              ,ROW_NUMBER() OVER(PARTITION BY TT.PARTY_ID ORDER BY (CASE WHEN TT.CERT_TYPE_CD = '2313' AND LENGTH(TT.CERT_NUM)=18 THEN 1
                                                                         WHEN TT.CERT_TYPE_CD = '2072' AND LENGTH(TT.CERT_NUM)=18 THEN 2 --2072-地税登记证,根据3证合一，没有统一信用证先取税务登记证
                                                                         WHEN TT.CERT_TYPE_CD = '2071' AND LENGTH(TT.CERT_NUM)=18 THEN 3 --2071-国税登记证,根据3证合一，没有统一信用证先取税务登记证
                                                                         WHEN TT.CERT_TYPE_CD = '2020' THEN 4
                                                                         WHEN TT.CERT_TYPE_CD = '2090' THEN 5
                                                                         WHEN TT.CERT_TYPE_CD = '2999' THEN 6
                                                                    END
                                                                   ) ASC,TT.SORC_SYS_CD DESC, TT.START_DT DESC) RN   --金数优先级为2313>2020>2090>2999
             FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TT  --当事人证件信息历史
            INNER JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B  --对公客户基本信息表
               ON TT.PARTY_ID = B.CUST_ID
              AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            WHERE TT.CERT_NUM IS NOT NULL
              AND TT.CERT_NUM <> '******'
              AND TT.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              AND TT.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
            ) T3
         ON T1.CUST_ID = T3.PARTY_ID
        AND T3.RN = 1
  WHERE A.DATA_DATE = V_P_DATE
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 4;
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
    SELECT DATA_DATE,KHWYM,COUNT(1)
      FROM RRP_MDL.M_ADD_DG_001_CUST T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,KHWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 程序跑批结束记录 --
   V_STEP      := 5;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_ADD_DG_001_CUST;
/

