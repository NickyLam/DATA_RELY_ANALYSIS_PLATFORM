CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_012_FINANCE_GUARAN(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_DG_012_FINANCE_GUARAN
  *  功能描述：补录表-对公-融资担保机构代偿模型-G5305。
  *  创建日期：20221220
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            ICL.CMM_GUAR_CONT  --担保合同表
  *            ICL.CMM_LOAN_GUAR_CONT_RELA  --贷款合同与担保合同关系表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            IML.PTY_PARTY_CERT_INFO_H   --当事人证件信息历史
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款借据信息
  *            ICL.CMM_INTNAL_ORG_INFO  --内部机构信息表
  *            IOL.IFRS_VAL_RPT_TRADE   --估值报告表
  *  目标表：  ADD_DG_012_FINANCE_GUARAN  --融资担保机构代偿模型（G5305）
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221120  hulj     首次创建。
  *             2    20230530  liuyu    调整继承上天数据逻辑
  *             3    20230606  liuyu    根据业务反馈检查调整逻辑
  *             4    20230626  MW       根据严希婧口径，修改额度为客户当前生效的总额度
  *             5    20230711  MW       修改融资担保机构经营许可证编号，从配置表中取
  *             6    20230905  PJC      修改取担保合同号逻辑，剔除对公客户表的关联
  *             7    20231208  hulj     调整是否政府性融资担保公司保证取值，替换'-'
  *             8    20231220  hulj     根据严希婧口径，新增是否包含反担保措施，调整继承逻辑，剔除表外数据
  *             9    20240131  hulj     根据严希婧口径，统计余额改成取借据时点余额
                10   20240219  lwb      修改部分字段为非补录字段
  *             11   20240612  YJY      调整口径：1、担保机构的担保方式为保证
                                                  2、业务范围：对公贷款+贴现+转贴现，目前暂未有票据贴现、转贴现的业务
                                                  3、担保公司名称：含有‘担保’字样
                                                  4、是否普惠小微企业：按照S7101的贷款余额的授信取值口径，授信1000（含）万以下
                                                  5、本年度累计实际获得代偿金额（元）、报告日尚未履行代偿责任金额（元）为补录字段
                                                  6、新增是否符合S6301融资担保字段
  *             12  20240802   YJY      调整是否政府性融资担保公司保证、是否反担保措施标志：优先判断业务合同对应的担保合同，再判断业务合同项下额度合同的担保合同
  *             13  20240829   YJY      经营许可证编号’ 调整为支持补录和继承；'是否政府性融资担保公司保证’，优先从系统取值，为空的数据匹配政府性融资担保清单，匹配规则先用统一社会信用代码或者组织机构代码（统一社会信用代码取9-17位） ,匹配不上的定义为'否'；
  *             14  20241202   YJY      严希婧要求：是否包含反担保措施为空的数据，默认赋值为“是”
  ***********************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                                 -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                       -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_ADD_DG_012_FINANCE_GUARAN';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_DG_012_FINANCE_GUARAN';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                       -- 分区名称
  V_P_DATE      VARCHAR2(8);                                         -- 跑批数据日期
  V_STARTTIME   DATE;                                                -- 处理开始时间
  V_ENDTIME     DATE;                                                -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                                 -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                       -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                        -- 来源系统

BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  V_STEP      := 1;
  V_STEP_DESC := '删除当期临时表数据';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_DG_012_FINANCE_GUARAN_L';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_DG_012_FINANCE_GUARAN';

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

    INSERT INTO ADD_DG_012_FINANCE_GUARAN_L NOLOGGING
    (
     DATA_DATE        --01 数据日期
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
    ,SYS_SOURCE       --30 系统来源
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    ,SFFDBCS          --33 是否反担保措施标志
    ,S6301DBFS        --34 是否符合S6301融资担保   --ADD BY YJY IN 20240612
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
          ,SYS_SOURCE       --30 系统来源
          ,SFSC             --31 是否删除
          ,JYXKZBH          --32 经营许可证编号
          ,SFFDBCS          --33 是否反担保措施标志
          ,S6301DBFS        --34 是否符合S6301融资担保   --ADD BY YJY IN 20240612
    FROM (
    SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_012_FINANCE_GUARAN_ETL A
     WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_DG_012_FINANCE_GUARAN_ETL)
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

    INSERT INTO ADD_DG_012_FINANCE_GUARAN_L NOLOGGING
    (
     DATA_DATE        --01 数据日期
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
    ,SYS_SOURCE       --30 系统来源
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    ,SFFDBCS          --33 是否反担保措施标志
    ,S6301DBFS        --34 是否符合S6301融资担保    --ADD BY YJY IN 20240612
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
          ,SYS_SOURCE       --30 系统来源
          ,SFSC             --31 是否删除
          ,JYXKZBH          --32 经营许可证编号
          ,SFFDBCS          --33 是否反担保措施标志
          ,S6301DBFS        --34 是否符合S6301融资担保    --ADD BY YJY IN 20240612
      FROM RRP_MDL.ADD_DG_012_FINANCE_GUARAN T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_DG_012_FINANCE_GUARAN_L T2
                        WHERE T1.JYWYM = T2.JYWYM
                          AND T2.DATA_DATE = V_P_DATE);

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

  --DELETE FROM ADD_DG_012_FINANCE_GUARAN T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
   V_STEP      := 5;
   V_STEP_DESC := '处理系统取值-对公信贷、票据贴现、票据转贴现';
   V_STARTTIME := SYSDATE;

   INSERT INTO TMP_ADD_DG_012_FINANCE_GUARAN NOLOGGING
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
    ,SYS_SOURCE       --30 系统来源
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    ,SFFDBCS          --33 是否反担保措施标志
    ,S6301DBFS        --34 是否符合S6301融资担保    --ADD BY YJY IN 20240612
    )
  WITH TMP1_ADD_DG_012_FINANCE_GUARAN   AS
   ( SELECT  *
      FROM
       (
          SELECT  B.LOAN_CONT_ID                  AS  LOAN_CONT_ID     --贷款合同
                 ,A.GUAR_CONT_ID                  AS  GUAR_CONT_ID     --担保合同
                 ,A.GUARTOR_ID                    AS  GUARTOR_ID       --担保机构编号
                 ,A.GUARTOR_NAME                  AS  GUARTOR_NAME     --担保机构名称
                 ,A.GOVER_FIN_GUAR_CORP_GUAR_FLG  AS GOVER_FIN_GUAR_CORP_GUAR_FLG   --政府性融资担保公司保证标志
                 ,A.REV_GUAR_MEASURE_FLG          AS REV_GUAR_MEASURE_FLG   --反担保措施标志
                 ,A.GUAR_WAY_CD                   AS GUAR_WAY_CD       --担保方式
                 ,A.GUARTOR_CERT_TYPE_CD          AS GUARTOR_CERT_TYPE_CD   --担保人证件类型代码  ADD BY YJY 20240829
                 ,A.GUARTOR_CERT_NO               AS GUARTOR_CERT_NO    --担保人证件号码    ADD BY YJY 20240829
                 ,ROW_NUMBER() OVER(PARTITION BY B.LOAN_CONT_ID ORDER BY B.GUAR_CONT_ID DESC,B.GUAR_START_DT DESC ) AS RN   --排序
           FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A --担保合同表
          INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA B --贷款合同与担保合同关系表
             ON A.GUAR_CONT_ID = B.GUAR_CONT_ID
            AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
          WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
            AND A.STATUS_CD IN ('100', '101', '102', '109', '112') -- 取担保合同有效的
            AND A.GUARTOR_NAME LIKE '%担保%'
     )
    WHERE RN=1
      AND GUAR_WAY_CD = 'C'  --担保方式C-保证
  )
    SELECT /*+ PARALLEL*/
           V_P_DATE                              AS DATA_DATE        --01 数据日期
          ,T1.ORG_ID                             AS ACCT_ORG_NUM     --02 账务机构编号
          ,T6.ORG_NAME                           AS ZWJGMC           --03 账务机构名称
          ,'440000'                              AS JGSZSJXZQ        --04 机构所在省级行政区
          ,T1.CONT_ID                            AS ZHWYM            --05 账户唯一码
          ,T1.RCPT_ID                            AS JYWYM            --06 交易唯一码
          ,CASE WHEN T1.DATA_SRC = '票据转贴现'
                THEN NVL(T1.DISCNT_CUST_ID,'-') --转贴现业务直贴人
                 --由于客户号非空原则，如果直贴人客户号取不到取直贴人名称,M层已加工
                WHEN T1.LOAN_STD_PROD_ID IN ('203020300002','203030600002')
                THEN T1.LC_BENEFC
                ELSE T1.CUST_ID
           END                                   AS KHWYM            --07 客户唯一码
          ,T3.CUST_NM                            AS KHMC             --08 客户名称
          ,CASE WHEN T1.DATA_SRC = '票据转贴现'
                AND (T3.CUST_ID IS NULL OR T3.ENT_SCALE = 'Z') THEN 'M'
                ELSE DECODE(T3.ENT_SCALE,'L','01'
                                        ,'M','02'
                                        ,'S','03'
                                        ,'X','04') --01-大型、02-中型、03-小型、04-微型
           END                                    AS TJXWQYLB         --09 统计小微企业类别
          ,CASE WHEN T3.CBRC_CUST_CL='企业'
                 AND T1.DATA_SRC IN ('对公信贷')
                 AND T3.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）')
                 AND T3.ENT_SCALE IN ('S','X')
                 AND (T1.LOAN_DIR_BIO_FLG <> 'N' OR SUBSTR(T1.LOAN_BIZ_TYP,0,4) = '0399')
                 AND NVL(T4.CRDT_TOTAL_LMT,0) <= 10000000
                THEN 'Y'
                ELSE 'N'
            END                                  AS SFPHXWQY         --10 是否普惠小微企业
          ,NVL(T4.CRDT_TOTAL_LMT,T5.AMT)         AS SXED             --11 授信额度
          ,T1.LOAN_ACT_DSTR_DT                   AS FKRQ             --12 放款日期
          ,CASE WHEN T1.INTNAL_CARR_FLG = '1' 
                 AND SUBSTR(T1.ORG_ID,1,3) = '897'
                THEN 0  --剔除内部结转标志为是，账务机构为897的放款金额（默认取零）
                ELSE T1.LOAN_AMT
           END                                   AS FKJE             --13 放款金额
          ,CASE WHEN SUBSTR(T1.SUBJ_ID,1,6) IN ('810601','710701')
                THEN 0
                ELSE NVL(T1.LOAN_BAL,0) + NVL(T1.FAIR_VAL_CHG,0) - NVL(T1.INT_ADJ,0)
           END                                   AS TJYE             --14 统计余额（元）
          ,T1.LOAN_ORIG_EXP_DT                   AS DKDQRQ           --15 贷款到期日期
          ,CASE WHEN T1.DATA_SRC = '票据贴现'
                 AND TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD') < TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND (NVL(T1.LOAN_BAL,0)+NVL(T1.FAIR_VAL_CHG, 0)-NVL(T1.INT_ADJ,0)) <> 0
                THEN TO_DATE(V_P_DATE,'YYYYMMDD') - TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD')
                ELSE T1.OVD_DAYS
           END                                   AS BGRDKYQTS        --16 报告日贷款逾期天数
          ,CASE WHEN T1.DATA_SRC = '票据贴现'
                 AND TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD') < TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND (NVL(T1.LOAN_BAL,0)+NVL(T1.FAIR_VAL_CHG, 0)-NVL(T1.INT_ADJ,0)) <> 0
                THEN TO_DATE(V_P_DATE,'YYYYMMDD') - TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD')
                ELSE T1.OVD_DAYS
           END                                   AS TJYQTS           --17 统计逾期天数（天）
          ,CASE WHEN T1.DATA_SRC = '票据贴现'
                 AND TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD') < TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND (NVL(T1.LOAN_BAL,0)+NVL(T1.FAIR_VAL_CHG, 0)-NVL(T1.INT_ADJ,0)) <> 0
                THEN NVL(T1.LOAN_BAL,0) + NVL(T1.FAIR_VAL_CHG,0) - NVL(T1.INT_ADJ,0)
                ELSE NVL(T1.OVD_PRIN_BAL,0)
           END                                   AS TJYQBJJE         --18 统计逾期本金金额（元）
          ,DECODE(T1.LVL5_CL,'01','1'
                            ,'02','2'
                            ,'03','3'
                            ,'04','4'
                            ,'05','5')           AS WJFL             --19 五级分类
          ,NVL(T7.GUARTOR_ID,TT.GUARTOR_ID)      AS DBJGBH           --20 担保机构编号
          ,NVL(T7.GUARTOR_NAME,TT.GUARTOR_NAME)  AS DBJGMC           --21 担保机构名称
          ,'保证'                                AS DBFS             --22 担保方式
          ,'Y'                                   AS SFRZDBGSBZ       --23 是否融资担保公司保证
          ,CASE WHEN T8.TYSHXYDM IS NOT NULL
                THEN '1'      
                ELSE NULL
           END                                   AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记  -- MOD BY YJY 20240829
          ,CASE WHEN NVL(T7.GOVER_FIN_GUAR_CORP_GUAR_FLG,TT.GOVER_FIN_GUAR_CORP_GUAR_FLG) = '1'   --MOD BY YJY IN 20240802
                THEN 'Y'
               -- MOD BY YJY 20240829 用统一社会信用代码或者组织机构代码（统一社会信用代码取9-17位）进行匹配
                WHEN NVL(T7.GUARTOR_CERT_TYPE_CD,TT.GUARTOR_CERT_TYPE_CD) ='2313' --2313-营业执照（统一社会信用代码）
                 AND NVL(REPLACE(T7.GUARTOR_CERT_NO,'-',''),REPLACE(TT.GUARTOR_CERT_NO,'-','')) = T8.TYSHXYDM
                THEN 'Y'
                WHEN NVL(T7.GUARTOR_CERT_TYPE_CD,TT.GUARTOR_CERT_TYPE_CD) ='2020' --2020-组织机构代码证
                 AND NVL(REPLACE(T7.GUARTOR_CERT_NO,'-',''),REPLACE(TT.GUARTOR_CERT_NO,'-','')) = SUBSTR(T8.TYSHXYDM,9,9)
                THEN 'Y'
                ELSE 'N'
           END                                 AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
          ,CASE WHEN T9.CUST_ID IS NOT NULL
                 AND T9.FARM_AND_NEW_AGRI_MANG_MAIN_LOAN_FLG = '1'
                THEN 'Y'
                ELSE 'N'
           END                                   AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
          ,''                                    AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
          ,''                                    AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
          ,''                                    AS BZ               --29 备注
          ,'对公'                                AS SYS_SOURCE       --30 系统来源
          ,'N'                                   AS SFSC             --31 是否删除
          ,''                                    AS JYXKZBH          --32 经营许可证编号
          ,/*CASE WHEN NVL(T7.REV_GUAR_MEASURE_FLG,TT.REV_GUAR_MEASURE_FLG )= '1'   --MOD BY YJY IN 20240802
                THEN 'Y'
                ELSE 'N'
           END */    
           CASE WHEN NVL(T7.REV_GUAR_MEASURE_FLG,TT.REV_GUAR_MEASURE_FLG )= '0'   --MOD BY YJY IN 20241202  严希婧要求是否包含反担保措施，为空，默认赋值为“是”
                THEN 'N'
                ELSE 'Y'
           END                              AS SFFDBCS           --33 是否反担保措施标志
          ,CASE WHEN SUBSTR(T2.SUB_GUA_MODE,1,1) = '2'
                THEN 'Y'
                ELSE 'N'
           END                                   AS S6301DBFS         --34 是否符合S6301融资担保     --ADD BY YJY IN 20240612
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T1 --表内借据信息
     INNER JOIN RRP_MDL.M_LOAN_CONT_INFO T2 --贷款合同信息
        ON T2.CONT_ID = T1.CONT_ID
       AND T2.DATA_DT = V_P_DATE
       AND T2.DATA_SRC = '对公信贷'
      LEFT JOIN TMP1_ADD_DG_012_FINANCE_GUARAN  T7 ----担保机构临时表
        ON T7.LOAN_CONT_ID = T1.CONT_ID
      LEFT JOIN TMP1_ADD_DG_012_FINANCE_GUARAN  TT ----担保机构临时表  --取额度合同号
        ON TT.LOAN_CONT_ID = T1.LMT_CONT_ID
       AND TT.LOAN_CONT_ID <> T1.CONT_ID
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T3 --对公客户信息表
        ON T3.CUST_ID = (CASE WHEN T1.DATA_SRC = '票据转贴现' THEN NVL(T1.DISCNT_CUST_ID,'-')
                              WHEN T1.LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN T1.LC_BENEFC --二级福费廷取受益人
                              ELSE T1.CUST_ID  END)
       AND T3.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO T4 --授信额度主表
        ON T4.CUST_ID = (CASE WHEN T1.DATA_SRC = '票据转贴现' THEN NVL(T1.DISCNT_CUST_ID,'-')
                              ELSE T1.CUST_ID  END)
       AND T4.DATA_DT = V_P_DATE
      LEFT JOIN ( SELECT NVL(A.DISCNT_CUST_ID,'-') AS CUST_ID
                         ,SUM(A.LOAN_AMT) AS AMT --放款金额之和
                    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A
                    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO B  --授信额度表
                      ON B.CUST_ID = NVL(A.DISCNT_CUST_ID,'-')
                     AND B.DATA_DT = V_P_DATE
                   WHERE SUBSTR(A.LOAN_BIZ_TYP, 1, 4) = '0302' --买断式转贴现
                     AND A.DATA_DT = V_P_DATE
                     AND NVL(A.DISCNT_CUST_ID,'-') <> '-'
                     AND (CASE WHEN SUBSTR(A.SUBJ_ID,1,6) IN  ('810601','710701') 
                               THEN 0
                               ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
                          END) <> 0 --取余额不为0
                     AND (NVL(B.CRDT_TOTAL_LMT, 0) = 0 OR B.CUST_ID IS NULL) --取当期没有授信直贴人
                   GROUP BY NVL(A.DISCNT_CUST_ID,'-')
           ) T5
        ON T5.CUST_ID = NVL(T1.DISCNT_CUST_ID,'-')--转贴现特殊处理
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T6    --内部机构信息表
        ON T6.ORG_ID = T1.ORG_ID
       AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_ZFXRZDBJGMD_G5305DG T8  --G5305对公政府性融资担保机构名单   MOD BY YJY 20240829
        ON T8.TYSHXYDM =  NVL(T7.GUARTOR_CERT_NO,TT.GUARTOR_CERT_NO) --统一社会信用代码
        OR SUBSTR(T8.TYSHXYDM,9,9) = NVL(REPLACE(T7.GUARTOR_CERT_NO,'-',''),REPLACE(TT.GUARTOR_CERT_NO,'-','')) --组织机构代码
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_ATTACH_INFO T9  --对公客户补充信息
        ON T3.CUST_ID = T9.CUST_ID
       AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE T1.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现')
       AND NVL(T1.LOAN_BIZ_TYP,'0') NOT IN ('90','99') --剔除委托贷款、非标其他债券
       AND SUBSTR(T1.LOAN_STD_PROD_ID,0,1) <> '4' --MOD 20230522 剔除同业法人透支
       AND T1.AD_CSH_FLG = 0 --剔除过滤垫款
       AND T1.DATA_DT = V_P_DATE
       AND (T7.LOAN_CONT_ID IS NOT NULL OR TT.LOAN_CONT_ID IS NOT NULL)
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 6;
  V_STEP_DESC := '处理数据-插入目标表-未结清或本年发放';
  V_STARTTIME := SYSDATE;
--去掉继承逻辑，hulj20231220
   INSERT INTO ADD_DG_012_FINANCE_GUARAN NOLOGGING
    (
     DATA_DATE        --01 数据日期
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
    ,SYS_SOURCE       --30 系统来源
    ,SFSC             --31 是否删除
    ,JYXKZBH          --32 经营许可证编号
    ,SFFDBCS          --33 是否反担保措施标志
    ,S6301DBFS        --34 是否符合S6301融资担保    --ADD BY YJY IN 20240612
    )
       WITH TMP AS (SELECT /*+ PARALLEL*/
           V_P_DATE as DATA_DATE         --01 数据日期
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
          ,SYS_SOURCE       --30 系统来源
          ,SFSC             --31 是否删除
          ,JYXKZBH          --32 经营许可证编号
          ,SFFDBCS          --33 是否反担保措施标志
          ,S6301DBFS        --34 是否符合S6301融资担保    --ADD BY YJY IN 20240612
    FROM (
    SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_012_FINANCE_GUARAN_ETL A
     WHERE A.DATA_DATE = V_P_DATE
       ) T
    WHERE T.RN = 1)
    SELECT /*+ PARALLEL*/ DISTINCT
           V_P_DATE                                                            AS DATA_DATE        --01 数据日期
          ,T1.ACCT_ORG_NUM                                                    AS ACCT_ORG_NUM     --02 账务机构编号
          ,T1.ZWJGMC                                                          AS ZWJGMC           --03 账务机构名称
          ,T1.JGSZSJXZQ                                                       AS JGSZSJXZQ        --04 机构所在省级行政区
          ,T1.ZHWYM                                                           AS ZHWYM            --05 账户唯一码
          ,T1.JYWYM                                                           AS JYWYM            --06 交易唯一码
          ,T1.KHWYM                                                           AS KHWYM            --07 客户唯一码
          ,T1.KHMC                                                            AS KHMC             --08 客户名称
          ,/*COALESCE(T1.TJXWQYLB,T2.TJXWQYLB)*/T1.TJXWQYLB                   AS TJXWQYLB         --09 统计小微企业类别
          ,/*COALESCE(T1.SFPHXWQY,T2.SFPHXWQY)*/T1.SFPHXWQY                   AS SFPHXWQY         --10 是否普惠小微企业
          ,/*COALESCE(T1.SXED,T2.SXED)*/T1.SXED                               AS SXED             --11 授信额度
          ,/*COALESCE(T1.FKRQ,T2.FKRQ)*/T1.FKRQ                               AS FKRQ             --12 放款日期
          ,/*COALESCE(T1.FKJE,T2.FKJE)*/T1.FKJE                               AS FKJE             --13 放款金额
          ,/*COALESCE(T1.TJYE,T2.TJYE)*/T1.TJYE                               AS TJYE             --14 统计余额（元）
          ,/*COALESCE(T1.DKDQRQ,T2.DKDQRQ)*/T1.DKDQRQ                         AS DKDQRQ           --15 贷款到期日期
          ,/*COALESCE(T1.BGRDKYQTS,T2.BGRDKYQTS)*/T1.BGRDKYQTS                AS BGRDKYQTS        --16 报告日贷款逾期天数
          ,/*COALESCE(T1.TJYQTS,T2.TJYQTS)*/T1.TJYQTS                         AS TJYQTS           --17 统计逾期天数（天）
          ,CASE WHEN /*COALESCE(T1.TJYQTS,T2.TJYQTS)*/ T1.TJYQTS = 0
                THEN 0
                ELSE /*COALESCE(T1.TJYE,T2.TJYE)*/ T1.TJYE
            END                                                               AS TJYQBJJE         --18 统计逾期本金金额（元） 对公只要逾期，贷款余额都是逾期金额
          ,/*COALESCE(T1.WJFL,T2.WJFL)*/T1.WJFL                               AS WJFL             --19 五级分类
          ,/*COALESCE(T1.DBJGBH,T2.DBJGBH)*/T1.DBJGBH                         AS DBJGBH           --20 担保机构编号
          ,/*COALESCE(T1.DBJGMC,T2.DBJGMC)*/T1.DBJGMC                         AS DBJGMC           --21 担保机构名称
          ,/*COALESCE(T1.DBFS,T2.DBFS)*/T1.DBFS                               AS DBFS             --22 担保方式
          ,/*COALESCE(T2.SFRZDBGSBZ,T1.SFRZDBGSBZ)*/T1.SFRZDBGSBZ             AS SFRZDBGSBZ       --23 是否融资担保公司保证
          ,/*COALESCE(T2.ZFXRZDBJGBJ,T1.ZFXRZDBJGBJ)*/T1.ZFXRZDBJGBJ          AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
          ,/*COALESCE(T3.SFZFXRZDBGSBZ,T1.SFZFXRZDBGSBZ)*/T1.SFZFXRZDBGSBZ    AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
          ,/*COALESCE(T2.SFNHJXXNYJYZTDK,T1.SFNHJXXNYJYZTDK)*/T1.SFNHJXXNYJYZTDK
                                                                              AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
          ,COALESCE(T3.BNDLJSJHDDCJE,T2.BNDLJSJHDDCJE)                        AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
          ,COALESCE(T3.BGRSWLXDCZRJE,T2.BGRSWLXDCZRJE)                        AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
          ,/*COALESCE(T2.BZ,T1.BZ)*/T1.BZ                                     AS BZ               --29 备注
          ,T1.SYS_SOURCE                                                      AS SYS_SOURCE       --30 系统来源
          ,/*COALESCE(T2.SFSC,T1.SFSC)*/T1.SFSC                               AS SFSC             --31 是否删除
          ,COALESCE(T3.JYXKZBH,T2.JYXKZBH,T4.JYXKZBH)                         AS JYXKZBH          --32 经营许可证编号   --MOD BY YJY 20240829 调整为可补录和继承
          ,/*COALESCE(T3.SFFDBCS,T1.SFFDBCS)*/T1.SFFDBCS                      AS SFFDBCS          --33 是否反担保措施标志
          ,T1.S6301DBFS                                                       AS S6301DBFS        --34 是否符合S6301融资担保    --ADD BY YJY IN 20240612
      FROM TMP_ADD_DG_012_FINANCE_GUARAN       T1 --当天跑批数据
      LEFT JOIN ADD_DG_012_FINANCE_GUARAN_L    T2 --当天跑批后补录数据
             ON T1.JYWYM = T2.JYWYM
   -- mod by hulj 20231220 去掉继承逻辑
      LEFT JOIN TMP                    T3 --当天跑批后补录数据
             ON T1.JYWYM = T3.JYWYM
   -- mod by hulj 20231220 去掉继承逻辑
      LEFT JOIN RRP_MDL.CONFIG_FINANCE_GUARAN   T4 --经营许可证配置表
             ON COALESCE(T2.DBJGBH,/*T3.DBJGBH,*/T1.DBJGBH) = T4.DBJGBH
            AND COALESCE(T2.DBJGMC,/*T3.DBJGMC,*/T1.DBJGMC) = T4.DBJGMC
    --MODIFY BY MW 20230711  经营许可证从配置表中取
     WHERE  (T1.TJYE > 0 OR SUBSTR(T1.FKRQ, 1, 4) = SUBSTR(V_P_DATE, 1, 4))
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 7;
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
      FROM RRP_MDL.ADD_DG_012_FINANCE_GUARAN T
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
   V_STEP      := 8;
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

END ETL_ADD_DG_012_FINANCE_GUARAN;
/

