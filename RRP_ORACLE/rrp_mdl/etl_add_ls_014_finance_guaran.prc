CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_LS_014_FINANCE_GUARAN(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_LS_014_FINANCE_GUARAN
  *  功能描述：补录表-零售-融资担保机构代偿模型（G5305）
  *  创建日期：20221221
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INDV_CUST_BASIC_INFO  --个人客户基本信息表
  *            ICL.CMM_GUAR_CONT             --担保合同表
  *            ICL.CMM_LOAN_GUAR_CONT_RELA   --贷款合同与担保合同关系表
  *            ICL.CMM_RETL_LOAN_DUBIL_INFO  --零售贷款借据信息
  *            ICL.CMM_RETL_LOAN_ACCT_INFO   --零售贷款账户信息
  *            ICL.CMM_RETL_LOAN_CONT_INFO   --零售贷款合同信息表
  *            ICL.CMM_INTNAL_ORG_INFO       --内部机构信息表
  *
  *  目标表：  ADD_LS_014_FINANCE_GUARAN  --融资担保机构代偿模型（G5305）
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221121  hulj     首次创建。
  *             2    20230530  liuyu    调整继承上天数据逻辑
                3    20230606  liuyu    根据业务反馈检查调整逻辑
                     平安普惠、平安普惠（引流）只计算2022年7月1日之后发放的贷款
                     20230711  mw       修改经营许可证号取数逻辑，基础数据从配置表中取
                4    20240105  hulj     新增网商贷担保口径
                5    20240109  hulj     新增零售部分额度合同下面的担保口径
                6    20240410  YJY      加工网商贷部分代偿金额逻辑
                7    20240419  YJY      调整网商贷代偿金额继承逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                                 -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                       -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_ADD_LS_014_FINANCE_GUARAN';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_LS_014_FINANCE_GUARAN';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                       -- 分区名称
  V_P_DATE      VARCHAR2(8);                                         -- 跑批数据日期
  V_LAST_YEAR_END    VARCHAR2(8);                                    --上年年末
  V_STARTTIME   DATE;                                                -- 处理开始时间
  V_ENDTIME     DATE;                                                -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                                 -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                       -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                        -- 来源系统

BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_LAST_YEAR_END := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD')-1,'YYYYMMDD'); --上年年末

  V_STEP      := 1;
  V_STEP_DESC := '删除当期临时表数据';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_LS_014_FINANCE_GUARAN_L';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_LS_014_FINANCE_GUARAN';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP1_ADD_LS_014_FINANCE_GUARAN';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '备份当期数据-从ETL表继承';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_LS_014_FINANCE_GUARAN_L NOLOGGING
    (DATA_DATE        --01 数据日期
    ,ACCT_ORG_NUM     --02 账务机构编号
    ,ZWJGMC           --03 账务机构名称
    ,JGSZSJXZQ        --04 机构所在省级行政区
    ,ZHWYM            --05 账户唯一码
    ,JYWYM            --06 交易唯一码
    ,KHWYM            --07 客户唯一码
    ,KHMC             --08 客户名称
    ,TJXWQYLB         --09 统计小微企业类别
    ,SFPHXWQY         --10 是否普惠小微企业
    ,SXED             --11 授信额度
    ,FKRQ             --12 放款日期
    ,FKJE             --13 放款金额
    ,TJYE             --14 统计余额（元）
    ,DKDQRQ           --15 贷款到期日期
    ,BGRDKYQTS        --16 报告日贷款逾期天数
    ,TJYQTS           --17 统计逾期天数（天）
    ,TJYQBJJE         --18 统计逾期本金金额（元）
    ,WJFL             --19 五级分类
    ,DBJGBH           --20 担保机构编号
    ,DBJGMC           --21 担保机构名称
    ,DBFS             --22 担保方式
    ,SFRZDBGSBZ       --23 是否融资担保公司保证
    ,ZFXRZDBJGBJ      --24 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
    ,BZ               --29 备注
    ,SYS_SOURCE       --30 来源系统
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE         --01 数据日期
          ,ACCT_ORG_NUM     --02 账务机构编号
          ,ZWJGMC           --03 账务机构名称
          ,JGSZSJXZQ        --04 机构所在省级行政区
          ,ZHWYM            --05 账户唯一码
          ,JYWYM            --06 交易唯一码
          ,KHWYM            --07 客户唯一码
          ,KHMC             --08 客户名称
          ,TJXWQYLB         --09 统计小微企业类别
          ,SFPHXWQY         --10 是否普惠小微企业
          ,SXED             --11 授信额度
          ,FKRQ             --12 放款日期
          ,FKJE             --13 放款金额
          ,TJYE             --14 统计余额（元）
          ,DKDQRQ           --15 贷款到期日期
          ,BGRDKYQTS        --16 报告日贷款逾期天数
          ,TJYQTS           --17 统计逾期天数（天）
          ,TJYQBJJE         --18 统计逾期本金金额（元）
          ,WJFL             --19 五级分类
          ,DBJGBH           --20 担保机构编号
          ,DBJGMC           --21 担保机构名称
          ,DBFS             --22 担保方式
          ,SFRZDBGSBZ       --23 是否融资担保公司保证
          ,ZFXRZDBJGBJ      --24 政府性融资担保机构标记
          ,SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
          ,SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
          ,BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
          ,BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
          ,BZ               --29 备注
          ,SYS_SOURCE       --30 来源系统
          ,SFSC             --31 是否删除
          ,JYXKZBH          --32 经营许可证编号
      FROM (
        SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
          FROM ADD_LS_014_FINANCE_GUARAN_ETL A
         WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_LS_014_FINANCE_GUARAN_ETL)
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

  INSERT INTO ADD_LS_014_FINANCE_GUARAN_L NOLOGGING
    (DATA_DATE        --01 数据日期
    ,ACCT_ORG_NUM     --02 账务机构编号
    ,ZWJGMC           --03 账务机构名称
    ,JGSZSJXZQ        --04 机构所在省级行政区
    ,ZHWYM            --05 账户唯一码
    ,JYWYM            --06 交易唯一码
    ,KHWYM            --07 客户唯一码
    ,KHMC             --08 客户名称
    ,TJXWQYLB         --09 统计小微企业类别
    ,SFPHXWQY         --10 是否普惠小微企业
    ,SXED             --11 授信额度
    ,FKRQ             --12 放款日期
    ,FKJE             --13 放款金额
    ,TJYE             --14 统计余额（元）
    ,DKDQRQ           --15 贷款到期日期
    ,BGRDKYQTS        --16 报告日贷款逾期天数
    ,TJYQTS           --17 统计逾期天数（天）
    ,TJYQBJJE         --18 统计逾期本金金额（元）
    ,WJFL             --19 五级分类
    ,DBJGBH           --20 担保机构编号
    ,DBJGMC           --21 担保机构名称
    ,DBFS             --22 担保方式
    ,SFRZDBGSBZ       --23 是否融资担保公司保证
    ,ZFXRZDBJGBJ      --24 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
    ,BZ               --29 备注
    ,SYS_SOURCE       --30 来源系统
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE         --01 数据日期
          ,ACCT_ORG_NUM     --02 账务机构编号
          ,ZWJGMC           --03 账务机构名称
          ,JGSZSJXZQ        --04 机构所在省级行政区
          ,ZHWYM            --05 账户唯一码
          ,JYWYM            --06 交易唯一码
          ,KHWYM            --07 客户唯一码
          ,KHMC             --08 客户名称
          ,TJXWQYLB         --09 统计小微企业类别
          ,SFPHXWQY         --10 是否普惠小微企业
          ,SXED             --11 授信额度
          ,FKRQ             --12 放款日期
          ,FKJE             --13 放款金额
          ,TJYE             --14 统计余额（元）
          ,DKDQRQ           --15 贷款到期日期
          ,BGRDKYQTS        --16 报告日贷款逾期天数
          ,TJYQTS           --17 统计逾期天数（天）
          ,TJYQBJJE         --18 统计逾期本金金额（元）
          ,WJFL             --19 五级分类
          ,DBJGBH           --20 担保机构编号
          ,DBJGMC           --21 担保机构名称
          ,DBFS             --22 担保方式
          ,SFRZDBGSBZ       --23 是否融资担保公司保证
          ,ZFXRZDBJGBJ      --24 政府性融资担保机构标记
          ,SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
          ,SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
          ,BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
          ,BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
          ,BZ               --29 备注
          ,SYS_SOURCE       --30 来源系统
          ,SFSC             --31 是否删除
          ,JYXKZBH          --32 经营许可证编号
      FROM RRP_MDL.ADD_LS_014_FINANCE_GUARAN T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_LS_014_FINANCE_GUARAN_L T2
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
  V_STEP      := 3;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --DELETE FROM ADD_LS_014_FINANCE_GUARAN T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 4;
  V_STEP_DESC := '处理数据-TMP1_ADD_LS_014_FINANCE_GUARAN';
  V_STARTTIME := SYSDATE;

   INSERT INTO TMP1_ADD_LS_014_FINANCE_GUARAN NOLOGGING
     (LOAN_CONT_ID,
      GUARTOR_ID,
      GUARTOR_NAME,
      GOVER_FIN_GUAR_CORP_GUAR_FLG,
      DATA_SRC,
      RN)
     SELECT B.LOAN_CONT_ID,
            A.GUARTOR_ID,
            A.GUARTOR_NAME,
            A.GOVER_FIN_GUAR_CORP_GUAR_FLG,
            '零售担保' AS DATA_SRC,
            ROW_NUMBER() OVER(PARTITION BY B.LOAN_CONT_ID ORDER BY B.GUAR_CONT_ID DESC) RN
       FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A --担保合同表
      INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA B --贷款合同与担保合同关系表
         ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
        AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
        AND A.STATUS_CD IN ('100', '101', '102', '109', '112') -- 取担保合同有效的
        --AND A.GUARTOR_NAME  LIKE '%担保%'--新增零售额度合同下面的担保逻辑，零售担保不需要卡这个条件
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '处理数据-TMP1_ADD_LS_014_FINANCE_GUARAN';
  V_STARTTIME := SYSDATE;

   INSERT INTO TMP1_ADD_LS_014_FINANCE_GUARAN NOLOGGING
     (LOAN_CONT_ID,
      GUARTOR_ID,
      GUARTOR_NAME,
      GOVER_FIN_GUAR_CORP_GUAR_FLG,
      DATA_SRC,
      RN)
     SELECT B.LOAN_CONT_ID,
            A.GUARTOR_CUST_ID,
            A.GUARTOR_NAME,
            A.GOVER_FIN_GUAR_CORP_GUAR_FLG,
            '网商贷担保' AS DATA_SRC,
            ROW_NUMBER() OVER(PARTITION BY B.LOAN_CONT_ID ORDER BY B.GUAR_CONT_ID DESC) RN
       FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO A --联合网贷担保合同信息
      INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA B --联合网贷贷款与担保合同关系
         ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
        AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
        AND A.STATUS_CD NOT IN ('4') -- 取担保合同有效的
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 5;
  V_STEP_DESC := '处理数据-插入临时表-零售';
  V_STARTTIME := SYSDATE;

   INSERT INTO TMP_ADD_LS_014_FINANCE_GUARAN NOLOGGING
    (DATA_DATE        --01 数据日期
    ,ACCT_ORG_NUM     --02 账务机构编号
    ,ZWJGMC           --03 账务机构名称
    ,JGSZSJXZQ        --04 机构所在省级行政区
    ,ZHWYM            --05 账户唯一码
    ,JYWYM            --06 交易唯一码
    ,KHWYM            --07 客户唯一码
    ,KHMC             --08 客户名称
    ,TJXWQYLB         --09 统计小微企业类别
    ,SFPHXWQY         --10 是否普惠小微企业
    ,SXED             --11 授信额度
    ,FKRQ             --12 放款日期
    ,FKJE             --13 放款金额
    ,TJYE             --14 统计余额（元）
    ,DKDQRQ           --15 贷款到期日期
    ,BGRDKYQTS        --16 报告日贷款逾期天数
    ,TJYQTS           --17 统计逾期天数（天）
    ,TJYQBJJE         --18 统计逾期本金金额（元）
    ,WJFL             --19 五级分类
    ,DBJGBH           --20 担保机构编号
    ,DBJGMC           --21 担保机构名称
    ,DBFS             --22 担保方式
    ,SFRZDBGSBZ       --23 是否融资担保公司保证
    ,ZFXRZDBJGBJ      --24 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
    ,BZ               --29 备注
    ,SYS_SOURCE       --30 来源系统
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                              AS DATA_DATE        --01 数据日期
          ,T2.ACCT_INSTIT_ID                     AS ACCT_ORG_NUM     --02 账务机构编号
          ,T4.ORG_NAME                           AS ZWJGMC           --03 账务机构名称
          ,'440000'                              AS JGSZSJXZQ        --04 机构所在省级行政区
          ,T1.CONT_ID                            AS ZHWYM            --05 账户唯一码
          ,T1.DUBIL_ID                           AS JYWYM            --06 交易唯一码
          ,T1.CUST_ID                            AS KHWYM            --07 客户唯一码
          ,T5.CUST_NAME                          AS KHMC             --08 客户名称
          ,CASE WHEN NVL(TTA.TAR_VALUE_CODE,T2.STD_PROD_ID) LIKE '0102%' THEN
                 CASE WHEN T5.INDV_BUS_FLG  = '1' THEN '06' --06-个体工商户
                      WHEN T5.SM_BUS_OWNER_FLG = '1' THEN '07' --07-小微企业主
                      ELSE '08' --其他个人经营客户
                  END
           END                                   AS TJXWQYLB         --09 统计小微企业类别
          ,CASE WHEN NVL(TTA.TAR_VALUE_CODE,T2.STD_PROD_ID) LIKE '0102%'
                     AND (T5.INDV_BUS_FLG  = '1' OR T5.SM_BUS_OWNER_FLG = '1' )
                     AND NVL(T6.CRDT_LMT,T3.CONT_AMT) <= 10000000 -- 加工逻辑复杂，暂时用业务合同取数
                THEN 'Y'
                ELSE 'N'
           END                                   AS SFPHXWQY         --10 是否普惠小微企业
          ,NVL(T6.CRDT_LMT,T3.CONT_AMT)          AS SXED             --11 授信额度
          ,TO_CHAR(T2.DISTR_DT,'YYYYMMDD')       AS FKRQ             --12 放款日期
          ,T2.DISTR_AMT                          AS FKJE             --13 放款金额
          ,CASE WHEN T2.WRT_OFF_FLG = '1'
                THEN 0
                ELSE T2.PRIC_BAL
            END                                  AS TJYE             --14 统计余额（元）
          ,TO_CHAR(T1.DUBIL_EXP_DT,'YYYYMMDD')   AS DKDQRQ           --15 贷款到期日期
          ,CASE WHEN T2.PRIC_OVDUE_DAYS >= T2.INT_OVDUE_DAYS
                THEN T2.PRIC_OVDUE_DAYS
                ELSE T2.INT_OVDUE_DAYS
            END                                  AS BGRDKYQTS        --16 报告日贷款逾期天数
          ,CASE WHEN T2.PRIC_OVDUE_DAYS >= T2.INT_OVDUE_DAYS
                THEN T2.PRIC_OVDUE_DAYS
                ELSE T2.INT_OVDUE_DAYS
            END                                  AS TJYQTS           --17 统计逾期天数（天）
          ,CASE WHEN T2.WRT_OFF_FLG = '1'
               THEN 0
               ELSE NVL(T2.OVDUE_PRIC_BAL, 0)
            END                                  AS TJYQBJJE         --18 统计逾期本金金额（元）
          ,DECODE(TTC.TAR_VALUE_CODE,'01','1'
                                    ,'02','2'
                                    ,'03','3'
                                    ,'04','4'
                                    ,'05','5')   AS WJFL             --19 五级分类
          ,CASE WHEN T1.STD_PROD_ID = '202020200007'
                THEN ''
                ELSE T7.GUARTOR_ID
            END                                  AS DBJGBH           --20 担保机构编号
          ,CASE WHEN T1.STD_PROD_ID = '202020200007'
                THEN '广东中盈盛达融资担保投资股份有限公司'
                ELSE T7.GUARTOR_NAME
            END                                  AS DBJGMC           --21 担保机构名称
          ,DECODE(TC.TAR_VALUE_CODE,'1','1' --抵押
                                   ,'2','0' --质押
                                   ,'3','2' --保证
                                   ,'4','3' --信用
                                             )   AS DBFS             --22 担保方式
           -- 暂时取主担保方式，后续有口径变更再调整
          ,'Y'                                   AS SFRZDBGSBZ       --23 是否融资担保公司保证
          ,T8.FLG                                AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
          ,CASE WHEN T7.GOVER_FIN_GUAR_CORP_GUAR_FLG IS NOT NULL THEN 'Y'
                ELSE 'N'
           END                                   AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
          ,DECODE(T5.FARM_FLG,'1','Y','N')       AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
          ,''                                    AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
          ,''                                    AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
          ,''                                    AS BZ               --29 备注
          ,'零售'                                AS SYS_SOURCE       --30 来源系统
          ,'N'                                   AS SFSC             --31 是否删除
          ,''                                    AS JYXKZBH          --32 经营许可证编号
      FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T1 --零售贷款借据信息
     INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
        ON T2.DUBIL_NUM = T1.DUBIL_ID
       AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T3  --零售贷款合同信息表
        ON T3.CONT_ID = T1.CONT_ID
       AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T4 --内部机构信息表
        ON T4.ORG_ID = T2.ACCT_INSTIT_ID
       AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     INNER JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO T5 --个人客户基本信息表
        ON T5.CUST_ID = T1.CUST_ID
       AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO T6 --零售贷款授信额度信息
        ON T6.LMT_CONT_ID = T3.LMT_CONT_ID
       AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN TMP1_ADD_LS_014_FINANCE_GUARAN T7 --新增额度合同下面的担保 20240109
        ON (T7.LOAN_CONT_ID = NVL(T1.CONT_ID,T3.LMT_CONT_ID))
       AND T7.RN = 1
      LEFT JOIN (SELECT DISTINCT GUARTOR_ID_K,FLG FROM M_ZFXRZDBJGMD) T8
        ON T7.GUARTOR_ID = T8.GUARTOR_ID_K
      LEFT JOIN RRP_MDL.CODE_MAP TC --主担保方式
        ON TC.SRC_VALUE_CODE = T3.MAJOR_GUAR_WAY_CD
       AND TC.SRC_CLASS_CODE = 'CD2656'
       AND TC.TAR_CLASS_CODE = 'D0002'
       AND TC.MOD_FLG = 'MDM'
      LEFT JOIN RRP_MDL.CODE_MAP TTC --五级分类
        ON TTC.SRC_VALUE_CODE = T1.LOAN_LEVEL5_CLS_CD
       AND TTC.SRC_CLASS_CODE = 'CD1032'
       AND TTC.TAR_CLASS_CODE = 'D0005'
       AND TTC.MOD_FLG = 'MDM'
      LEFT JOIN RRP_MDL.CODE_MAP TTA --贷款类型
        ON TTA.SRC_VALUE_CODE = T2.STD_PROD_ID
       AND TTA.SRC_CLASS_CODE = 'STD0002'
       AND TTA.TAR_CLASS_CODE = 'T0001'
       AND TTA.MOD_FLG = 'MDM'
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND ((T7.LOAN_CONT_ID IS NOT NULL
                AND T1.STD_PROD_ID NOT IN ('202010200005', '202020200002'))
            OR (T7.LOAN_CONT_ID IS NOT NULL
                AND T1.STD_PROD_ID IN ('202010200005', '202020200002') --平安普惠只要2022年7月之后放款
                AND T2.DISTR_DT >= DATE '2022-07-01')
            OR T1.STD_PROD_ID = '202020200007') --新兴金融
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '处理数据-插入临时表-网商贷';
  V_STARTTIME := SYSDATE;

   INSERT INTO TMP_ADD_LS_014_FINANCE_GUARAN NOLOGGING
    (DATA_DATE        --01 数据日期
    ,ACCT_ORG_NUM     --02 账务机构编号
    ,ZWJGMC           --03 账务机构名称
    ,JGSZSJXZQ        --04 机构所在省级行政区
    ,ZHWYM            --05 账户唯一码
    ,JYWYM            --06 交易唯一码
    ,KHWYM            --07 客户唯一码
    ,KHMC             --08 客户名称
    ,TJXWQYLB         --09 统计小微企业类别
    ,SFPHXWQY         --10 是否普惠小微企业
    ,SXED             --11 授信额度
    ,FKRQ             --12 放款日期
    ,FKJE             --13 放款金额
    ,TJYE             --14 统计余额（元）
    ,DKDQRQ           --15 贷款到期日期
    ,BGRDKYQTS        --16 报告日贷款逾期天数
    ,TJYQTS           --17 统计逾期天数（天）
    ,TJYQBJJE         --18 统计逾期本金金额（元）
    ,WJFL             --19 五级分类
    ,DBJGBH           --20 担保机构编号
    ,DBJGMC           --21 担保机构名称
    ,DBFS             --22 担保方式
    ,SFRZDBGSBZ       --23 是否融资担保公司保证
    ,ZFXRZDBJGBJ      --24 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
    ,BZ               --29 备注
    ,SYS_SOURCE       --30 来源系统
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                              AS DATA_DATE        --01 数据日期
          ,T1.ACCT_INSTIT_ID                     AS ACCT_ORG_NUM     --02 账务机构编号
          ,T4.ORG_NAME                           AS ZWJGMC           --03 账务机构名称
          ,'440000'                              AS JGSZSJXZQ        --04 机构所在省级行政区
          ,T1.CONT_ID                            AS ZHWYM            --05 账户唯一码
          ,T1.DUBIL_ID                           AS JYWYM            --06 交易唯一码
          ,T1.CUST_ID                            AS KHWYM            --07 客户唯一码
          ,T5.CUST_NAME                          AS KHMC             --08 客户名称
          ,CASE WHEN NVL(TTA.TAR_VALUE_CODE,T1.STD_PROD_ID) LIKE '0102%' THEN
                 CASE WHEN T5.INDV_BUS_FLG  = '1' THEN '06' --06-个体工商户
                      WHEN T5.SM_BUS_OWNER_FLG = '1' THEN '07' --07-小微企业主
                      ELSE '08' --其他个人经营客户
                  END
           END                                   AS TJXWQYLB         --09 统计小微企业类别
          ,CASE WHEN NVL(TTA.TAR_VALUE_CODE,T1.STD_PROD_ID) LIKE '0102%'
                     AND (T5.INDV_BUS_FLG  = '1' OR T5.SM_BUS_OWNER_FLG = '1' )
                     AND T3.CONT_AMT <= 10000000 -- 加工逻辑复杂，暂时用业务合同取数
                THEN 'Y'
                ELSE 'N'
           END                                   AS SFPHXWQY         --10 是否普惠小微企业
          ,T3.CONT_AMT                           AS SXED             --11 授信额度
          ,TO_CHAR(T1.DISTR_DT,'YYYYMMDD')       AS FKRQ             --12 放款日期
          ,T1.DISTR_AMT                          AS FKJE             --13 放款金额
          ,CASE WHEN T1.WRT_OFF_FLG = '1'
                THEN 0
                ELSE T1.NOMAL_PRIC
            END                                  AS TJYE             --14 统计余额（元）
          ,TO_CHAR(T1.EXP_DT,'YYYYMMDD')         AS DKDQRQ           --15 贷款到期日期
          ,CASE WHEN T1.PRIC_OVDUE_DAYS >= T1.INT_OVDUE_DAYS
                THEN T1.PRIC_OVDUE_DAYS
                ELSE T1.INT_OVDUE_DAYS
            END                                  AS BGRDKYQTS        --16 报告日贷款逾期天数
          ,CASE WHEN T1.PRIC_OVDUE_DAYS >= T1.INT_OVDUE_DAYS
                THEN T1.PRIC_OVDUE_DAYS
                ELSE T1.INT_OVDUE_DAYS
            END                                  AS TJYQTS           --17 统计逾期天数（天）
          ,CASE WHEN T1.WRT_OFF_FLG = '1'
               THEN 0
               ELSE NVL(T1.OVDUE_PRIC, 0)
            END                                  AS TJYQBJJE         --18 统计逾期本金金额（元）
          ,DECODE(TTC.TAR_VALUE_CODE,'01','1'
                                    ,'02','2'
                                    ,'03','3'
                                    ,'04','4'
                                    ,'05','5')   AS WJFL             --19 五级分类
          ,CASE WHEN T1.STD_PROD_ID = '202020200007'
                THEN ''
                ELSE T7.GUARTOR_ID
            END                                  AS DBJGBH           --20 担保机构编号
          ,CASE WHEN T1.STD_PROD_ID = '202020200007'
                THEN '广东中盈盛达融资担保投资股份有限公司'
                ELSE T7.GUARTOR_NAME
            END                                  AS DBJGMC           --21 担保机构名称
          ,DECODE(TC.TAR_VALUE_CODE,'1','1' --抵押
                                   ,'2','0' --质押
                                   ,'3','2' --保证
                                   ,'4','3' --信用
                                             )   AS DBFS             --22 担保方式
          ,'Y'                                   AS SFRZDBGSBZ       --23 是否融资担保公司保证
          ,T8.FLG                                AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
          ,CASE WHEN T7.GOVER_FIN_GUAR_CORP_GUAR_FLG IS NOT NULL THEN 'Y'
                ELSE 'N'
           END                                   AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
          ,DECODE(T5.FARM_FLG,'1','Y','N')       AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
          ,CASE WHEN T9.DUBIL_ID IS NOT NULL THEN T9.CURRT_REPAY_PRIC
                ELSE 0
           END                                   AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）   --MOD BY YJY IN 20240410
          ,''                                    AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
          ,''                                    AS BZ               --29 备注
          ,'网商贷'                              AS SYS_SOURCE       --30 来源系统
          ,'N'                                   AS SFSC             --31 是否删除
          ,''                                    AS JYXKZBH          --32 经营许可证编号
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T1 --联合网贷借据信息
      LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO T3  --联合网贷贷款合同信息
        ON T3.CONT_ID = T1.CONT_ID
       AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO T2  --联合网贷核销信息
       ON T1.DUBIL_ID = T2.DUBIL_ID
      AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T4 --内部机构信息表
        ON T4.ORG_ID = T1.ACCT_INSTIT_ID
       AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     INNER JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO T5 --个人客户基本信息表
        ON T5.CUST_ID = T1.CUST_ID
       AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN TMP1_ADD_LS_014_FINANCE_GUARAN T7
        ON T7.LOAN_CONT_ID = T1.CONT_ID
       AND T7.RN = 1
      LEFT JOIN (SELECT DISTINCT GUARTOR_ID_K,FLG FROM M_ZFXRZDBJGMD) T8
        ON T7.GUARTOR_ID = T8.GUARTOR_ID_K
      LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL  T9 --联合网贷还款明细  --ADD BY YJY IN 20240410 加工代偿金额
             ON T1.DUBIL_ID = T9.DUBIL_ID
            AND T9.REPAY_TYPE_CD ='05'      --还款方式 05-代偿
            AND T9.REPAY_DT < TO_DATE(V_P_DATE,'YYYYMMDD')
            AND T9.REPAY_DT >= TO_DATE(V_LAST_YEAR_END,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP TC --主担保方式
        ON TC.SRC_VALUE_CODE = T3.GUAR_WAY_CD
       AND TC.SRC_CLASS_CODE = 'CD2656'
       AND TC.TAR_CLASS_CODE = 'D0002'
       AND TC.MOD_FLG = 'MDM'
      LEFT JOIN RRP_MDL.CODE_MAP TTC --五级分类
        ON TTC.SRC_VALUE_CODE = T1.LOAN_LEVEL5_CLS_CD
       AND TTC.SRC_CLASS_CODE = 'CD1032'
       AND TTC.TAR_CLASS_CODE = 'D0005'
       AND TTC.MOD_FLG = 'MDM'
      LEFT JOIN RRP_MDL.CODE_MAP TTA --贷款类型
        ON TTA.SRC_VALUE_CODE = T1.STD_PROD_ID
       AND TTA.SRC_CLASS_CODE = 'STD0002'
       AND TTA.TAR_CLASS_CODE = 'T0001'
       AND TTA.MOD_FLG = 'MDM'
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND  T3.CONT_ID IS NOT NULL
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 6;
  V_STEP_DESC := '处理数据-插入目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_LS_014_FINANCE_GUARAN NOLOGGING
    (
     DATA_DATE        --01 数据日期
    ,ACCT_ORG_NUM     --02 账务机构编号
    ,ZWJGMC           --04 账务机构名称
    ,JGSZSJXZQ        --05 机构所在省级行政区
    ,ZHWYM            --06 账户唯一码
    ,JYWYM            --07 交易唯一码
    ,KHWYM            --08 客户唯一码
    ,KHMC             --09 客户名称
    ,TJXWQYLB         --10 统计小微企业类别
    ,SFPHXWQY         --11 是否普惠小微企业
    ,SXED             --12 授信额度
    ,FKRQ             --13 放款日期
    ,FKJE             --14 放款金额
    ,TJYE             --15 统计余额（元）
    ,DKDQRQ           --16 贷款到期日期
    ,BGRDKYQTS        --17 报告日贷款逾期天数
    ,TJYQTS           --18 统计逾期天数（天）
    ,TJYQBJJE         --19 统计逾期本金金额（元）
    ,WJFL             --20 五级分类
    ,DBJGBH           --21 担保机构编号
    ,DBJGMC           --22 担保机构名称
    ,DBFS             --23 担保方式
    ,SFRZDBGSBZ       --24 是否融资担保公司保证
    ,ZFXRZDBJGBJ      --25 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ    --26 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK  --27 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE    --28 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE    --29 报告日尚未履行代偿责任金额（元）
    ,BZ               --30 备注
    ,SYS_SOURCE       --31 来源系统
    ,SFSC             --32 是否删除
    ,JYXKZBH          --33 经营许可证编号
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                                       AS DATA_DATE        --01 数据日期
          ,T1.ACCT_ORG_NUM                                AS ACCT_ORG_NUM     --02 账务机构编号
          ,T1.ZWJGMC                                      AS ZWJGMC           --04 账务机构名称
          ,T1.JGSZSJXZQ                                   AS JGSZSJXZQ        --05 机构所在省级行政区
          ,T1.ZHWYM                                       AS ZHWYM            --06 账户唯一码
          ,T1.JYWYM                                       AS JYWYM            --07 交易唯一码
          ,T1.KHWYM                                       AS KHWYM            --08 客户唯一码
          ,T1.KHMC                                        AS KHMC             --09 客户名称
          ,COALESCE(T2.TJXWQYLB,T3.TJXWQYLB,T1.TJXWQYLB)  AS TJXWQYLB         --10 统计小微企业类别
          ,COALESCE(T2.SFPHXWQY,T3.SFPHXWQY,T1.SFPHXWQY)  AS SFPHXWQY         --11 是否普惠小微企业
          ,COALESCE(T2.SXED,T1.SXED)                      AS SXED             --12 授信额度
          ,COALESCE(T2.FKRQ,T3.FKRQ,T1.FKRQ)              AS FKRQ             --13 放款日期
          ,COALESCE(T2.FKJE,T3.FKJE,T1.FKJE)              AS FKJE             --14 放款金额
          ,COALESCE(T2.TJYE,T1.TJYE)                      AS TJYE             --15 统计余额（元）
          ,COALESCE(T2.DKDQRQ,T3.DKDQRQ,T1.DKDQRQ)        AS DKDQRQ           --16 贷款到期日期
          ,COALESCE(T2.BGRDKYQTS,T1.BGRDKYQTS)            AS BGRDKYQTS        --17 报告日贷款逾期天数
          ,COALESCE(T2.TJYQTS,T1.TJYQTS)                  AS TJYQTS           --18 统计逾期天数（天）
          ,CASE WHEN NVL(T2.TJYQTS,T1.TJYQTS) = 0
                THEN 0
                WHEN NVL(T2.TJYQTS,T1.TJYQTS) <= 90
                  --AND SUBSTR(T1.ACCT_TYP ,1,4) IN ('0101','0102','0103','0104','0199')
                  --AND T1.REPAY_WAY_CD IN('110','111','210','212','220','222','230')
                THEN NVL(T2.TJYQBJJE,T1.TJYQBJJE)
                ELSE NVL(T2.TJYE,T1.TJYE)
            END                                                               AS TJYQBJJE         --19 统计逾期本金金额（元）
          ,COALESCE(T2.WJFL,T3.WJFL,T1.WJFL)                                  AS WJFL             --20 五级分类
          ,COALESCE(T2.DBJGBH,T3.DBJGBH,T1.DBJGBH)                            AS DBJGBH           --21 担保机构编号
          ,COALESCE(T2.DBJGMC,T3.DBJGMC,T1.DBJGMC)                            AS DBJGMC           --22 担保机构名称
          ,COALESCE(T2.DBFS,T3.DBFS,T1.DBFS)                                  AS DBFS             --23 担保方式
          ,COALESCE(T2.SFRZDBGSBZ,T3.SFRZDBGSBZ,T1.SFRZDBGSBZ)                AS SFRZDBGSBZ       --24 是否融资担保公司保证
          ,COALESCE(T2.ZFXRZDBJGBJ,T3.ZFXRZDBJGBJ,T1.ZFXRZDBJGBJ)             AS ZFXRZDBJGBJ      --25 政府性融资担保机构标记
          ,COALESCE(T2.SFZFXRZDBGSBZ,T3.SFZFXRZDBGSBZ,T1.SFZFXRZDBGSBZ)       AS SFZFXRZDBGSBZ    --26 是否政府性融资担保公司保证
          ,COALESCE(T2.SFNHJXXNYJYZTDK,T3.SFNHJXXNYJYZTDK,T1.SFNHJXXNYJYZTDK) AS SFNHJXXNYJYZTDK  --27 是否农户及新型农业经营主体贷款
          ,/*COALESCE(T2.BNDLJSJHDDCJE,T3.BNDLJSJHDDCJE,T1.BNDLJSJHDDCJE)*/
           COALESCE(T1.BNDLJSJHDDCJE,T2.BNDLJSJHDDCJE,T3.BNDLJSJHDDCJE)       AS BNDLJSJHDDCJE    --28 本年度累计实际获得代偿金额（元）--MODIFY BY YJY 20240419 优先从系统出数
          ,COALESCE(T2.BGRSWLXDCZRJE,T3.BGRSWLXDCZRJE,T1.BGRSWLXDCZRJE)       AS BGRSWLXDCZRJE    --29 报告日尚未履行代偿责任金额（元）
          ,COALESCE(T2.BZ,T3.BZ,T1.BZ)                                        AS BZ               --30 备注
          ,T1.SYS_SOURCE                                                      AS SYS_SOURCE       --31 来源系统
          ,COALESCE(T2.SFSC,T1.SFSC)                                          AS SFSC             --32 是否删除
          ,COALESCE(T2.JYXKZBH,T3.JYXKZBH,T1.JYXKZBH,T4.JYXKZBH)              AS JYXKZBH          --33 经营许可证编号
      FROM TMP_ADD_LS_014_FINANCE_GUARAN T1
      LEFT JOIN ADD_LS_014_FINANCE_GUARAN_L T2
        ON T1.JYWYM = T2.JYWYM
      LEFT JOIN (SELECT T.*
                   FROM ADD_LS_014_FINANCE_GUARAN_ETL T
                  WHERE T.DATA_DATE = (SELECT MAX(TT.DATA_DATE) FROM ADD_LS_014_FINANCE_GUARAN_ETL TT WHERE TT.DATA_DATE < V_P_DATE)
                ) T3
        ON T1.JYWYM = T3.JYWYM
      LEFT JOIN RRP_MDL.CONFIG_FINANCE_GUARAN  T4
        ON COALESCE(T2.DBJGBH,T3.DBJGBH,T1.DBJGBH) = T4.DBJGBH
       AND COALESCE(T2.DBJGMC,T3.DBJGMC,T1.DBJGMC) = T4.DBJGMC
     WHERE NVL(T3.SFSC,'N') <> 'Y'
       AND (COALESCE(T2.TJYE,T1.TJYE) > 0 OR SUBSTR(COALESCE(T2.FKRQ,T3.FKRQ,T1.FKRQ),1,4) = SUBSTR(V_P_DATE,1,4))
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 8;
  V_STEP_DESC := '处理数据-继承上一天数据';
  V_STARTTIME := SYSDATE;

   INSERT INTO ADD_LS_014_FINANCE_GUARAN NOLOGGING
    (
     DATA_DATE        --01 数据日期
    ,ACCT_ORG_NUM     --02 账务机构编号
    ,ZWJGMC           --04 账务机构名称
    ,JGSZSJXZQ        --05 机构所在省级行政区
    ,ZHWYM            --06 账户唯一码
    ,JYWYM            --07 交易唯一码
    ,KHWYM            --08 客户唯一码
    ,KHMC             --09 客户名称
    ,TJXWQYLB         --10 统计小微企业类别
    ,SFPHXWQY         --11 是否普惠小微企业
    ,SXED             --12 授信额度
    ,FKRQ             --13 放款日期
    ,FKJE             --14 放款金额
    ,TJYE             --15 统计余额（元）
    ,DKDQRQ           --16 贷款到期日期
    ,BGRDKYQTS        --17 报告日贷款逾期天数
    ,TJYQTS           --18 统计逾期天数（天）
    ,TJYQBJJE         --19 统计逾期本金金额（元）
    ,WJFL             --20 五级分类
    ,DBJGBH           --21 担保机构编号
    ,DBJGMC           --22 担保机构名称
    ,DBFS             --23 担保方式
    ,SFRZDBGSBZ       --24 是否融资担保公司保证
    ,ZFXRZDBJGBJ      --25 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ    --26 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK  --27 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE    --28 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE    --29 报告日尚未履行代偿责任金额（元）
    ,BZ               --30 备注
    ,SYS_SOURCE       --31 来源系统
    ,SFSC             --32 是否删除
    ,JYXKZBH          --33 经营许可证编号
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE         --01 数据日期
          ,A.ACCT_ORG_NUM     --02 账务机构编号
          ,A.ZWJGMC           --04 账务机构名称
          ,A.JGSZSJXZQ        --05 机构所在省级行政区
          ,A.ZHWYM            --06 账户唯一码
          ,A.JYWYM            --07 交易唯一码
          ,A.KHWYM            --08 客户唯一码
          ,A.KHMC             --09 客户名称
          ,A.TJXWQYLB         --10 统计小微企业类别
          ,A.SFPHXWQY         --11 是否普惠小微企业
          ,A.SXED             --12 授信额度
          ,A.FKRQ             --13 放款日期
          ,A.FKJE             --14 放款金额
          ,A.TJYE             --15 统计余额（元）
          ,A.DKDQRQ           --16 贷款到期日期
          ,A.BGRDKYQTS        --17 报告日贷款逾期天数
          ,A.TJYQTS           --18 统计逾期天数（天）
          ,A.TJYQBJJE         --19 统计逾期本金金额（元）
          ,A.WJFL             --20 五级分类
          ,A.DBJGBH           --21 担保机构编号
          ,A.DBJGMC           --22 担保机构名称
          ,A.DBFS             --23 担保方式
          ,A.SFRZDBGSBZ       --24 是否融资担保公司保证
          ,A.ZFXRZDBJGBJ      --25 政府性融资担保机构标记
          ,A.SFZFXRZDBGSBZ    --26 是否政府性融资担保公司保证
          ,A.SFNHJXXNYJYZTDK  --27 是否农户及新型农业经营主体贷款
          ,A.BNDLJSJHDDCJE    --28 本年度累计实际获得代偿金额（元）
          ,A.BGRSWLXDCZRJE    --29 报告日尚未履行代偿责任金额（元）
          ,A.BZ               --30 备注
          ,A.SYS_SOURCE       --31 来源系统
          ,A.SFSC             --32 是否删除
          ,NVL(A.JYXKZBH,B.JYXKZBH)
                              --33 经营许可证编号
      FROM RRP_MDL.ADD_LS_014_FINANCE_GUARAN_ETL A
      LEFT JOIN RRP_MDL.CONFIG_FINANCE_GUARAN B
        ON A.DBJGBH = B.DBJGBH
       AND A.DBJGMC = B.DBJGMC
    WHERE DATA_DATE = (SELECT MAX(TT.DATA_DATE) FROM ADD_LS_014_FINANCE_GUARAN_ETL TT WHERE TT.DATA_DATE < V_P_DATE)
      AND NOT EXISTS(SELECT 1 FROM ADD_LS_014_FINANCE_GUARAN T
                     WHERE T.DATA_DATE = V_P_DATE
                     AND A.JYWYM = T.JYWYM
                     )
      AND NVL(A.SFSC,'N') <> 'Y'
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 9;
   V_STEP_DESC := '处理数据-当期增加的数据插入目标表';
   V_STARTTIME := SYSDATE;

   INSERT INTO ADD_LS_014_FINANCE_GUARAN NOLOGGING
    (
     DATA_DATE        --01 数据日期
    ,ACCT_ORG_NUM     --02 账务机构编号
    ,ZWJGMC           --04 账务机构名称
    ,JGSZSJXZQ        --05 机构所在省级行政区
    ,ZHWYM            --06 账户唯一码
    ,JYWYM            --07 交易唯一码
    ,KHWYM            --08 客户唯一码
    ,KHMC             --09 客户名称
    ,TJXWQYLB         --10 统计小微企业类别
    ,SFPHXWQY         --11 是否普惠小微企业
    ,SXED             --12 授信额度
    ,FKRQ             --13 放款日期
    ,FKJE             --14 放款金额
    ,TJYE             --15 统计余额（元）
    ,DKDQRQ           --16 贷款到期日期
    ,BGRDKYQTS        --17 报告日贷款逾期天数
    ,TJYQTS           --18 统计逾期天数（天）
    ,TJYQBJJE         --19 统计逾期本金金额（元）
    ,WJFL             --20 五级分类
    ,DBJGBH           --21 担保机构编号
    ,DBJGMC           --22 担保机构名称
    ,DBFS             --23 担保方式
    ,SFRZDBGSBZ       --24 是否融资担保公司保证
    ,ZFXRZDBJGBJ      --25 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ    --26 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK  --27 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE    --28 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE    --29 报告日尚未履行代偿责任金额（元）
    ,BZ               --30 备注
    ,SYS_SOURCE       --31 来源系统
    ,SFSC             --32 是否删除
    ,JYXKZBH          --33 经营许可证编号
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE         --01 数据日期
          ,A.ACCT_ORG_NUM     --02 账务机构编号
          ,A.ZWJGMC           --04 账务机构名称
          ,A.JGSZSJXZQ        --05 机构所在省级行政区
          ,A.ZHWYM            --06 账户唯一码
          ,A.JYWYM            --07 交易唯一码
          ,A.KHWYM            --08 客户唯一码
          ,A.KHMC             --09 客户名称
          ,A.TJXWQYLB         --10 统计小微企业类别
          ,A.SFPHXWQY         --11 是否普惠小微企业
          ,A.SXED             --12 授信额度
          ,A.FKRQ             --13 放款日期
          ,A.FKJE             --14 放款金额
          ,A.TJYE             --15 统计余额（元）
          ,A.DKDQRQ           --16 贷款到期日期
          ,A.BGRDKYQTS        --17 报告日贷款逾期天数
          ,A.TJYQTS           --18 统计逾期天数（天）
          ,A.TJYQBJJE         --19 统计逾期本金金额（元）
          ,A.WJFL             --20 五级分类
          ,A.DBJGBH           --21 担保机构编号
          ,A.DBJGMC           --22 担保机构名称
          ,A.DBFS             --23 担保方式
          ,A.SFRZDBGSBZ       --24 是否融资担保公司保证
          ,A.ZFXRZDBJGBJ      --25 政府性融资担保机构标记
          ,A.SFZFXRZDBGSBZ    --26 是否政府性融资担保公司保证
          ,A.SFNHJXXNYJYZTDK  --27 是否农户及新型农业经营主体贷款
          ,A.BNDLJSJHDDCJE    --28 本年度累计实际获得代偿金额（元）
          ,A.BGRSWLXDCZRJE    --29 报告日尚未履行代偿责任金额（元）
          ,A.BZ               --30 备注
          ,A.SYS_SOURCE       --31 来源系统
          ,A.SFSC             --32 是否删除
          ,NVL(A.JYXKZBH,B.JYXKZBH)
                              --33 经营许可证编号
      FROM ADD_LS_014_FINANCE_GUARAN_L A
      LEFT JOIN RRP_MDL.CONFIG_FINANCE_GUARAN B
        ON A.DBJGBH = B.DBJGBH
       AND A.DBJGMC = B.DBJGMC
    WHERE NOT EXISTS (SELECT 1 FROM ADD_LS_014_FINANCE_GUARAN T WHERE T.DATA_DATE = V_P_DATE AND A.JYWYM = T.JYWYM)
      AND NVL(A.SFSC,'N') <> 'Y'
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 10;
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

  WITH TMP1 AS (
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.ADD_LS_014_FINANCE_GUARAN T
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
   V_STEP      := 11;
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

END ETL_ADD_LS_014_FINANCE_GUARAN;
/

