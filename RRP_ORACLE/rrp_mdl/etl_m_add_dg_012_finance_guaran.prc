CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ADD_DG_012_FINANCE_GUARAN(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_ADD_DG_012_FINANCE_GUARAN
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
  *  目标表：  M_ADD_DG_012_FINANCE_GUARAN  --融资担保机构代偿模型（G5305）
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20221120  hulj     首次创建。
  *   2    20230508  LIUYU    修改逻辑从前端继承全部补录数据
  *   3    20230531  liuyu    新增重复数据校验
  *   4    20231220  hulj     新增是否反担保措施标志
  *   5    20240620  YJY      新增是否符合S6301融资担保字段
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                                 -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                       -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(300)  := 'ETL_M_ADD_DG_012_FINANCE_GUARAN'; -- 程序名称
  V_TABLE_NAME  VARCHAR2(300)  := 'M_ADD_DG_012_FINANCE_GUARAN';     -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                       -- 分区名称
  V_P_DATE      VARCHAR2(8);                                         -- 跑批数据日期
  V_STARTTIME   DATE;                                                -- 处理开始时间
  V_ENDTIME     DATE;                                                -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                                 -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                       -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                        -- 来源系统

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

   --DELETE FROM M_ADD_DG_012_FINANCE_GUARAN T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
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

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_M_ADD_DG_012_FINANCE_GUARAN';

   INSERT INTO TMP_M_ADD_DG_012_FINANCE_GUARAN
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
  	,S6301DBFS        --34 是否符合S6301融资担保     --ADD IN 20240620
    )
   SELECT /*+ PARALLEL(A,4) */
     A.DATA_DATE        --01 数据日期
    ,A.ACCT_ORG_NUM     --02 账务机构编号
    ,A.ZWJGMC           --03 账务机构名称
    ,A.JGSZSJXZQ        --04 机构所在省级行政区
    ,A.ZHWYM            --05 账户唯一码
    ,A.JYWYM            --06 交易唯一码
    ,A.KHWYM            --07 客户唯一码
    ,A.KHMC             --08 客户名称
    ,A.TJXWQYLB         --09 统计小微企业类别
    ,A.SFPHXWQY         --10 是否普惠小微企业
    ,A.SXED             --11 授信额度
    ,A.FKRQ             --12 放款日期
    ,A.FKJE             --13 放款金额
    ,A.TJYE             --14 统计余额（元）
    ,A.DKDQRQ           --15 贷款到期日期
    ,A.BGRDKYQTS        --16 报告日贷款逾期天数
    ,A.TJYQTS           --17 统计逾期天数（天）
    ,A.TJYQBJJE         --18 统计逾期本金金额（元）
    ,A.WJFL             --19 五级分类
    ,A.DBJGBH           --20 担保机构编号
    ,A.DBJGMC           --21 担保机构名称
    ,A.DBFS             --22 担保方式
    ,A.SFRZDBGSBZ       --23 是否融资担保公司保证
    ,A.ZFXRZDBJGBJ      --24 政府性融资担保机构标记
    ,A.SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
    ,A.SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
    ,A.BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
    ,A.BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
    ,A.BZ               --29 备注
    ,A.SYS_SOURCE       --30 系统来源
    ,A.SFSC             --31 是否删除
    ,A.JYXKZBH          --32 经营许可证编号
    ,A.SFFDBCS          --33 是否反担保措施标志
	  ,A.S6301DBFS        --34 是否符合S6301融资担保     --ADD IN 20240620
   FROM (
      SELECT B.*,ROW_NUMBER()OVER(PARTITION BY B.JYWYM ORDER BY B.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_012_FINANCE_GUARAN_ETL B
      WHERE B.DATA_DATE = V_P_DATE
       ) A
   WHERE A.RN = 1
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

   INSERT INTO M_ADD_DG_012_FINANCE_GUARAN
    (
     DATA_DATE,        --01 数据日期,
     ACCT_ORG_NUM,     --02 账务机构编号,
     ZWJGMC,           --03 账务机构名称,
     JGSZSJXZQ,        --04 机构所在省级行政区,
     ZHWYM,            --05 账户唯一码,
     JYWYM,            --06 交易唯一码,
     KHWYM,            --07 客户唯一码,
     KHMC,             --08 客户名称,
     TJXWQYLB,         --09 统计小微企业类别,
     SFPHXWQY,         --10 是否普惠小微企业,
     SXED,             --11 授信额度,
     FKRQ,             --12 放款日期,
     FKJE,             --13 放款金额,
     TJYE,             --14 统计余额（元）,
     DKDQRQ,           --15 贷款到期日期,
     BGRDKYQTS,        --16 报告日贷款逾期天数,
     TJYQTS,           --17 统计逾期天数（天）,
     TJYQBJJE,         --18 统计逾期本金金额（元）,
     WJFL,             --19 五级分类,
     DBJGBH,           --20 担保机构编号,
     DBJGMC,           --21 担保机构名称,
     DBFS,             --22 担保方式,
     SFRZDBGSBZ,       --23 是否融资担保公司保证,
     ZFXRZDBJGBJ,      --24 政府性融资担保机构标记,
     SFZFXRZDBGSBZ,    --25 是否政府性融资担保公司保证,
     SFNHJXXNYJYZTDK,  --26 是否农户及新型农业经营主体贷款,
     BNDLJSJHDDCJE,    --27 本年度累计实际获得代偿金额（元）,
     BGRSWLXDCZRJE,    --28 报告日尚未履行代偿责任金额（元）,
     BZ,               --29 备注,
     SYS_SOURCE,       --30 来源系统,
     SFSC,             --31 是否删除,
     JYXKZBH,          --32 经营许可证编号
     SFFDBCS,          --33 是否反担保措施标志
	   S6301DBFS         --34 是否符合S6301融资担保     --ADD IN 20240620
    )
   SELECT /*+ PARALLEL(A,4) */
     A.DATA_DATE,        --01 数据日期
     A.ACCT_ORG_NUM,     --02 账务机构编号
     A.ZWJGMC,           --03 账务机构名称
     A.JGSZSJXZQ,        --04 机构所在省级行政区
     A.ZHWYM,            --05 账户唯一码
     A.JYWYM,            --06 交易唯一码
     A.KHWYM,            --07 客户唯一码
     A.KHMC,             --08 客户名称
     A.TJXWQYLB,         --09 统计小微企业类别
     A.SFPHXWQY,         --10 是否普惠小微企业
     A.SXED,             --11 授信额度
     A.FKRQ,             --12 放款日期
     A.FKJE,             --13 放款金额
     A.TJYE,             --14 统计余额（元）
     A.DKDQRQ,           --15 贷款到期日期
     A.BGRDKYQTS,        --16 报告日贷款逾期天数
     A.TJYQTS,           --17 统计逾期天数（天）
     A.TJYQBJJE,         --18 统计逾期本金金额（元）
     A.WJFL,             --19 五级分类
     A.DBJGBH,           --20 担保机构编号
     A.DBJGMC,           --21 担保机构名称
     A.DBFS,             --22 担保方式
     A.SFRZDBGSBZ,       --23 是否融资担保公司保证
     A.ZFXRZDBJGBJ,      --24 政府性融资担保机构标记
     A.SFZFXRZDBGSBZ,    --25 是否政府性融资担保公司保证,
     A.SFNHJXXNYJYZTDK,  --26 是否农户及新型农业经营主体贷款
     NVL(B.BNDLJSJHDDCJE,A.BNDLJSJHDDCJE),    --27 本年度累计实际获得代偿金额（元）
     NVL(B.BGRSWLXDCZRJE,A.BGRSWLXDCZRJE),    --28 报告日尚未履行代偿责任金额（元）
     A.BZ,               --29 备注
     A.SYS_SOURCE,       --30 来源系统
     A.SFSC,             --31 是否删除
     A.JYXKZBH,          --32 经营许可证编号
     A.SFFDBCS,          --33 是否反担保措施标志
     A.S6301DBFS         --34 是否符合S6301融资担保     --ADD IN 20240620
   FROM ADD_DG_012_FINANCE_GUARAN  A    --跑批数据
   LEFT JOIN TMP_M_ADD_DG_012_FINANCE_GUARAN B    --当天补录数据
          ON A.JYWYM = B.JYWYM
   WHERE A.DATA_DATE = V_P_DATE
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.M_ADD_DG_012_FINANCE_GUARAN T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

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

END ETL_M_ADD_DG_012_FINANCE_GUARAN;
/

