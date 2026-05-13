CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_014_NATION_CREDIT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_DG_014_NATION_CREDIT
  *  功能描述：补录表-对公-风险转移模型（G51）。
  *  创建日期：20221220
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            IML.PTY_IBANK_CUST_CHAT_INFO  --同业客户特有信息
  *            IML.PTY_PARTY_CERT_INFO_H     --当事人证件信息历史
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            IML.REF_PUB_CD                --公共码值表
  *  目标表：  ADD_DG_014_NATION_CREDIT  --国别-风险转移模型（G51）
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221120  hulj     首次创建。
  *             2    20230530  liuyu    调整继承上天数据逻辑
  *             3    20230727  MW       根据业务严希婧要求，不继承前一天数据
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                                -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                      -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_ADD_DG_014_NATION_CREDIT';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_DG_014_NATION_CREDIT';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                      -- 分区名称
  V_P_DATE      VARCHAR2(8);                                        -- 跑批数据日期
  V_STARTTIME   DATE;                                               -- 处理开始时间
  V_ENDTIME     DATE;                                               -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                                -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                      -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                       -- 来源系统

BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --DELETE FROM ADD_DG_014_NATION_CREDIT T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 /* -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '处理数据-当天补录数据';
  V_STARTTIME := SYSDATE;

   INSERT INTO ADD_DG_014_NATION_CREDIT
     (
      DATA_DATE             --01 数据日期
     ,ACCT_ORG_NUM          --02 账务机构编号
     ,JYWYM                 --03 交易唯一码
     ,KHWYM                 --04 客户唯一码
     ,KHMC                  --05 客户名称
     ,ZWJGMC                --06 账务机构名称
     ,JYDSJYDGB             --07 交易对手经营地国别
     ,GBFXJYDSLB            --08 国别风险交易对手类别
     ,ZQZWGX                --09 债权债务关系
     ,SFZQZQ                --10 是否主权债权
     ,JWZQZQLB              --11 境外主权债权类别
     ,GBFXYWPZLB            --12 国别风险业务品种类别
     ,SJDQRQ                --13 实际到期日期
     ,WJFL                  --14 五级分类
     ,YQTSQJ                --15 逾期天数区间
     ,TJYE                  --16 统计余额（元）
     ,YSYJLX                --17 应收应计利息（元）
     ,DBJTJZZB              --18 单笔计提减值准备（元）
     ,SFWYJTGBFXBBZC        --19 是否为应计提国别风险拨备资产
     ,YJTGBFXBBJE           --20 已计提国别风险拨备金额（元）
     ,FXZYGB                --21 风险转移国别
     ,FXZRFLB               --22 风险转入方类别
     ,FXZYSXJE              --23 风险转移上限金额（元）
     ,FXZYJE                --24 风险转移金额（元）
     ,JWZWRGB               --25 境外债务人国别
     ,SYS_SOURCE            --26 来源系统
     ,GBFXDJ                --27 国别风险等级
     ,SFWCYGJYDYLXM         --28 是否为参与共建一带一路项目
    )
    SELECT \*+ PARALLEL(A,4) *\
          V_P_DATE              --01 数据日期
         ,ACCT_ORG_NUM          --02 账务机构编号
         ,JYWYM                 --03 交易唯一码
         ,KHWYM                 --04 客户唯一码
         ,KHMC                  --05 客户名称
         ,ZWJGMC                --06 账务机构名称
         ,JYDSJYDGB             --07 交易对手经营地国别
         ,GBFXJYDSLB            --08 国别风险交易对手类别
         ,ZQZWGX                --09 债权债务关系
         ,SFZQZQ                --10 是否主权债权
         ,JWZQZQLB              --11 境外主权债权类别
         ,GBFXYWPZLB            --12 国别风险业务品种类别
         ,SJDQRQ                --13 实际到期日期
         ,WJFL                  --14 五级分类
         ,YQTSQJ                --15 逾期天数区间
         ,TJYE                  --16 统计余额（元）
         ,YSYJLX                --17 应收应计利息（元）
         ,DBJTJZZB              --18 单笔计提减值准备（元）
         ,SFWYJTGBFXBBZC        --19 是否为应计提国别风险拨备资产
         ,YJTGBFXBBJE           --20 已计提国别风险拨备金额（元）
         ,FXZYGB                --21 风险转移国别
         ,FXZRFLB               --22 风险转入方类别
         ,FXZYSXJE              --23 风险转移上限金额（元）
         ,FXZYJE                --24 风险转移金额（元）
         ,JWZWRGB               --25 境外债务人国别
         ,SYS_SOURCE            --26 来源系统
         ,GBFXDJ                --27 国别风险等级
         ,SFWCYGJYDYLXM         --28 是否为参与共建一带一路项目
    FROM (
          SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
            FROM ADD_DG_014_NATION_CREDIT_ETL A
           WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_DG_014_NATION_CREDIT_ETL)
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
  V_STEP_DESC := '处理数据-继承上一天数据';
  V_STARTTIME := SYSDATE;

   INSERT INTO ADD_DG_014_NATION_CREDIT
     (
      DATA_DATE             --01 数据日期
     ,ACCT_ORG_NUM          --02 账务机构编号
     ,JYWYM                 --03 交易唯一码
     ,KHWYM                 --04 客户唯一码
     ,KHMC                  --05 客户名称
     ,ZWJGMC                --06 账务机构名称
     ,JYDSJYDGB             --07 交易对手经营地国别
     ,GBFXJYDSLB            --08 国别风险交易对手类别
     ,ZQZWGX                --09 债权债务关系
     ,SFZQZQ                --10 是否主权债权
     ,JWZQZQLB              --11 境外主权债权类别
     ,GBFXYWPZLB            --12 国别风险业务品种类别
     ,SJDQRQ                --13 实际到期日期
     ,WJFL                  --14 五级分类
     ,YQTSQJ                --15 逾期天数区间
     ,TJYE                  --16 统计余额（元）
     ,YSYJLX                --17 应收应计利息（元）
     ,DBJTJZZB              --18 单笔计提减值准备（元）
     ,SFWYJTGBFXBBZC        --19 是否为应计提国别风险拨备资产
     ,YJTGBFXBBJE           --20 已计提国别风险拨备金额（元）
     ,FXZYGB                --21 风险转移国别
     ,FXZRFLB               --22 风险转入方类别
     ,FXZYSXJE              --23 风险转移上限金额（元）
     ,FXZYJE                --24 风险转移金额（元）
     ,JWZWRGB               --25 境外债务人国别
     ,SYS_SOURCE            --26 来源系统
     ,GBFXDJ                --27 国别风险等级
     ,SFWCYGJYDYLXM         --28 是否为参与共建一带一路项目
    )
    SELECT \*+ PARALLEL(A,4) *\
      V_P_DATE              --01 数据日期
     ,ACCT_ORG_NUM          --02 账务机构编号
     ,JYWYM                 --03 交易唯一码
     ,KHWYM                 --04 客户唯一码
     ,KHMC                  --05 客户名称
     ,ZWJGMC                --06 账务机构名称
     ,JYDSJYDGB             --07 交易对手经营地国别
     ,GBFXJYDSLB            --08 国别风险交易对手类别
     ,ZQZWGX                --09 债权债务关系
     ,SFZQZQ                --10 是否主权债权
     ,JWZQZQLB              --11 境外主权债权类别
     ,GBFXYWPZLB            --12 国别风险业务品种类别
     ,SJDQRQ                --13 实际到期日期
     ,WJFL                  --14 五级分类
     ,YQTSQJ                --15 逾期天数区间
     ,TJYE                  --16 统计余额（元）
     ,YSYJLX                --17 应收应计利息（元）
     ,DBJTJZZB              --18 单笔计提减值准备（元）
     ,SFWYJTGBFXBBZC        --19 是否为应计提国别风险拨备资产
     ,YJTGBFXBBJE           --20 已计提国别风险拨备金额（元）
     ,FXZYGB                --21 风险转移国别
     ,FXZRFLB               --22 风险转入方类别
     ,FXZYSXJE              --23 风险转移上限金额（元）
     ,FXZYJE                --24 风险转移金额（元）
     ,JWZWRGB               --25 境外债务人国别
     ,SYS_SOURCE            --26 来源系统
     ,GBFXDJ                --27 国别风险等级
     ,SFWCYGJYDYLXM         --28 是否为参与共建一带一路项目
      FROM RRP_MDL.ADD_DG_014_NATION_CREDIT T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_DG_014_NATION_CREDIT T2
                        WHERE T1.JYWYM = T2.JYWYM
                          AND T2.DATA_DATE = V_P_DATE)
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

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
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.ADD_DG_014_NATION_CREDIT T
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
   V_STEP      := 5;
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

END ETL_ADD_DG_014_NATION_CREDIT;
/

