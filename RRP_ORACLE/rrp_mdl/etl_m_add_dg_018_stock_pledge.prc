CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ADD_DG_018_STOCK_PLEDGE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_ADD_DG_018_STOCK_PLEDGE
  *  功能描述：补录表-对公-股权质押模型-G16。
  *  创建日期：20221220
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            ICL.CMM_COL_INFO              --押品信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款借据信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            ICL.CMM_CORP_LOAN_ACCT_INFO   --对公贷款账户信息
  *            IOL.IFRS_VAL_RPT_TRADE        --估值报告表
  *            IML.AST_DUBIL_ASSIGN_H        --资产借据分配历史
  *  目标表：  M_ADD_DG_018_STOCK_PLEDGE  --股权质押模型（G16）
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221120  hulj     首次创建。
  *             2    20230529  MW       增加add继承逻辑
                3    20230531  liuyu    新增重复数据校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                               -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                     -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_M_ADD_DG_018_STOCK_PLEDGE'; -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'M_ADD_DG_018_STOCK_PLEDGE';     -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                     -- 分区名称
  V_P_DATE      VARCHAR2(8);                                       -- 跑批数据日期
  V_STARTTIME   DATE;                                              -- 处理开始时间
  V_ENDTIME     DATE;                                              -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                               -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                     -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                      -- 来源系统

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

   --DELETE FROM M_ADD_DG_018_STOCK_PLEDGE T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
   ETL_PARTITION_ADD(I_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD_ETL对公的数据插入到目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_ADD_DG_018_STOCK_PLEDGE
    (
     DATA_DATE           --01 数据日期
    ,ACCT_ORG_NUM        --02 账务机构编号
    ,YPWYM               --03 押品唯一码
    ,JYWYM               --04 交易唯一码
    ,ZHWYM               --05 账户唯一码
    ,ZWJGMC              --06 账务机构名称
    ,KHWYM               --07 客户唯一码
    ,KHMC                --08 客户名称
    ,YPLB                --09 押品类别
    ,GQZYRZLB            --10 股权质押融资类别
    ,YWLX                --11 业务类型
    ,TFR                 --12 投放日
    ,DQR                 --13 到期日
    ,WJFL                --14 五级分类
    ,TJYE                --15 统计余额（元）
    ,QZ_YJWBLDYE         --16 其中：已计为不良的余额
    ,SFSSGPZY            --17 是否上市股票质押
    ,SFCNJY              --18 是否场内交易
    ,GQCZQYMC            --19 股权出质企业名称
    ,GS                  --20 股数（股）
    ,JJFS                --21 计价方式
    ,MGJZ                --22 每股价值（元）
    ,YPZXGZ              --23 押品最新估值（元）
    ,SFCJYJX             --24 是否触及预警线
    ,YJXJG               --25 预警线价格（元）
    ,QZ_CJYJXDGPSL       --26 其中：触及预警线的股票数量
    ,QZ_CJYJXDYPYE       --27 其中：触及预警线的押品余额
    ,QZ_CJYJXDYPDYDRZYE  --28 其中：触及预警线的押品对应的融资余额
    ,SFCJPCX             --29 是否触及平仓线
    ,PCXJG               --30 平仓线价格（元）
    ,QZ_CJPCXDYPYE       --31 其中：触及平仓线的押品余额
    ,QZ_CJPCXDGPSL       --32 其中：触及平仓线的股票数量
    ,QZ_CJPCXDYPDYDRZYE  --33 其中：触及平仓线的押品对应的融资余额
    ,GQYPYE              --34 股权押品余额（元）
    ,GPSZNFFGBX          --35 股票市值能否覆盖本息
    ,DBFSZB              --36 担保方式占比
    ,BGQNLJPCDRZJE       --37 报告期内累计平仓的融资金额(元)
    ,HKSJ                --38 还款时间
    ,PCYPJE              --39 平仓押品金额（元）
    ,PCSJ                --40 平仓时间
    ,SFZBGQNPCGP         --41 是否在报告期内平仓股票
    ,MGPCPJJG            --42 每股平仓平均价格(元)
    ,SYS_SOURCE          --43 来源系统
    ,SFSC                --44 是否删除
    )
  SELECT /*+ PARALLEL(A,4) */
     A.DATA_DATE           --01 数据日期
    ,A.ACCT_ORG_NUM        --02 账务机构编号
    ,A.YPWYM               --03 押品唯一码
    ,A.JYWYM               --04 交易唯一码
    ,A.ZHWYM               --05 账户唯一码
    ,A.ZWJGMC              --06 账务机构名称
    ,A.KHWYM               --07 客户唯一码
    ,A.KHMC                --08 客户名称
    ,A.YPLB                --09 押品类别
    ,A.GQZYRZLB            --10 股权质押融资类别
    ,A.YWLX                --11 业务类型
    ,A.TFR                 --12 投放日
    ,A.DQR                 --13 到期日
    ,A.WJFL                --14 五级分类
    ,A.TJYE                --15 统计余额（元）
    ,A.QZ_YJWBLDYE         --16 其中：已计为不良的余额
    ,A.SFSSGPZY            --17 是否上市股票质押
    ,A.SFCNJY              --18 是否场内交易
    ,A.GQCZQYMC            --19 股权出质企业名称
    ,A.GS                  --20 股数（股）
    ,A.JJFS                --21 计价方式
    ,A.MGJZ                --22 每股价值（元）
    ,A.YPZXGZ              --23 押品最新估值（元）
    ,A.SFCJYJX             --24 是否触及预警线
    ,A.YJXJG               --25 预警线价格（元）
    ,A.QZ_CJYJXDGPSL       --26 其中：触及预警线的股票数量
    ,A.QZ_CJYJXDYPYE       --27 其中：触及预警线的押品余额
    ,A.QZ_CJYJXDYPDYDRZYE  --28 其中：触及预警线的押品对应的融资余额
    ,A.SFCJPCX             --29 是否触及平仓线
    ,A.PCXJG               --30 平仓线价格（元）
    ,A.QZ_CJPCXDYPYE       --31 其中：触及平仓线的押品余额
    ,A.QZ_CJPCXDGPSL       --32 其中：触及平仓线的股票数量
    ,A.QZ_CJPCXDYPDYDRZYE  --33 其中：触及平仓线的押品对应的融资余额
    ,A.GQYPYE              --34 股权押品余额（元）
    ,A.GPSZNFFGBX          --35 股票市值能否覆盖本息
    ,A.DBFSZB              --36 担保方式占比
    ,A.BGQNLJPCDRZJE       --37 报告期内累计平仓的融资金额(元)
    ,A.HKSJ                --38 还款时间
    ,A.PCYPJE              --39 平仓押品金额（元）
    ,A.PCSJ                --40 平仓时间
    ,A.SFZBGQNPCGP         --41 是否在报告期内平仓股票
    ,A.MGPCPJJG            --42 每股平仓平均价格(元)
    ,A.SYS_SOURCE          --43 来源系统
    ,A.SFSC                --44 是否删除
   FROM (
      SELECT B.*,ROW_NUMBER()OVER(PARTITION BY B.JYWYM ORDER BY B.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_018_STOCK_PLEDGE_ETL B
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
  V_STEP_DESC := '继承ADD_的数据插入到目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_ADD_DG_018_STOCK_PLEDGE
    (
     DATA_DATE           --01 数据日期
    ,ACCT_ORG_NUM        --02 账务机构编号
    ,YPWYM               --03 押品唯一码
    ,JYWYM               --04 交易唯一码
    ,ZHWYM               --05 账户唯一码
    ,ZWJGMC              --06 账务机构名称
    ,KHWYM               --07 客户唯一码
    ,KHMC                --08 客户名称
    ,YPLB                --09 押品类别
    ,GQZYRZLB            --10 股权质押融资类别
    ,YWLX                --11 业务类型
    ,TFR                 --12 投放日
    ,DQR                 --13 到期日
    ,WJFL                --14 五级分类
    ,TJYE                --15 统计余额（元）
    ,QZ_YJWBLDYE         --16 其中：已计为不良的余额
    ,SFSSGPZY            --17 是否上市股票质押
    ,SFCNJY              --18 是否场内交易
    ,GQCZQYMC            --19 股权出质企业名称
    ,GS                  --20 股数（股）
    ,JJFS                --21 计价方式
    ,MGJZ                --22 每股价值（元）
    ,YPZXGZ              --23 押品最新估值（元）
    ,SFCJYJX             --24 是否触及预警线
    ,YJXJG               --25 预警线价格（元）
    ,QZ_CJYJXDGPSL       --26 其中：触及预警线的股票数量
    ,QZ_CJYJXDYPYE       --27 其中：触及预警线的押品余额
    ,QZ_CJYJXDYPDYDRZYE  --28 其中：触及预警线的押品对应的融资余额
    ,SFCJPCX             --29 是否触及平仓线
    ,PCXJG               --30 平仓线价格（元）
    ,QZ_CJPCXDYPYE       --31 其中：触及平仓线的押品余额
    ,QZ_CJPCXDGPSL       --32 其中：触及平仓线的股票数量
    ,QZ_CJPCXDYPDYDRZYE  --33 其中：触及平仓线的押品对应的融资余额
    ,GQYPYE              --34 股权押品余额（元）
    ,GPSZNFFGBX          --35 股票市值能否覆盖本息
    ,DBFSZB              --36 担保方式占比
    ,BGQNLJPCDRZJE       --37 报告期内累计平仓的融资金额(元)
    ,HKSJ                --38 还款时间
    ,PCYPJE              --39 平仓押品金额（元）
    ,PCSJ                --40 平仓时间
    ,SFZBGQNPCGP         --41 是否在报告期内平仓股票
    ,MGPCPJJG            --42 每股平仓平均价格(元)
    ,SYS_SOURCE          --43 来源系统
    ,SFSC                --44 是否删除
    )
  SELECT /*+ PARALLEL(A,4) */
     A.DATA_DATE           --01 数据日期
    ,A.ACCT_ORG_NUM        --02 账务机构编号
    ,A.YPWYM               --03 押品唯一码
    ,A.JYWYM               --04 交易唯一码
    ,A.ZHWYM               --05 账户唯一码
    ,A.ZWJGMC              --06 账务机构名称
    ,A.KHWYM               --07 客户唯一码
    ,A.KHMC                --08 客户名称
    ,A.YPLB                --09 押品类别
    ,A.GQZYRZLB            --10 股权质押融资类别
    ,A.YWLX                --11 业务类型
    ,A.TFR                 --12 投放日
    ,A.DQR                 --13 到期日
    ,A.WJFL                --14 五级分类
    ,A.TJYE                --15 统计余额（元）
    ,A.QZ_YJWBLDYE         --16 其中：已计为不良的余额
    ,A.SFSSGPZY            --17 是否上市股票质押
    ,A.SFCNJY              --18 是否场内交易
    ,A.GQCZQYMC            --19 股权出质企业名称
    ,A.GS                  --20 股数（股）
    ,A.JJFS                --21 计价方式
    ,A.MGJZ                --22 每股价值（元）
    ,A.YPZXGZ              --23 押品最新估值（元）
    ,A.SFCJYJX             --24 是否触及预警线
    ,A.YJXJG               --25 预警线价格（元）
    ,A.QZ_CJYJXDGPSL       --26 其中：触及预警线的股票数量
    ,A.QZ_CJYJXDYPYE       --27 其中：触及预警线的押品余额
    ,A.QZ_CJYJXDYPDYDRZYE  --28 其中：触及预警线的押品对应的融资余额
    ,A.SFCJPCX             --29 是否触及平仓线
    ,A.PCXJG               --30 平仓线价格（元）
    ,A.QZ_CJPCXDYPYE       --31 其中：触及平仓线的押品余额
    ,A.QZ_CJPCXDGPSL       --32 其中：触及平仓线的股票数量
    ,A.QZ_CJPCXDYPDYDRZYE  --33 其中：触及平仓线的押品对应的融资余额
    ,A.GQYPYE              --34 股权押品余额（元）
    ,A.GPSZNFFGBX          --35 股票市值能否覆盖本息
    ,A.DBFSZB              --36 担保方式占比
    ,A.BGQNLJPCDRZJE       --37 报告期内累计平仓的融资金额(元)
    ,A.HKSJ                --38 还款时间
    ,A.PCYPJE              --39 平仓押品金额（元）
    ,A.PCSJ                --40 平仓时间
    ,A.SFZBGQNPCGP         --41 是否在报告期内平仓股票
    ,A.MGPCPJJG            --42 每股平仓平均价格(元)
    ,A.SYS_SOURCE          --43 来源系统
    ,A.SFSC                --44 是否删除
   FROM (
      SELECT B.*,ROW_NUMBER()OVER(PARTITION BY B.JYWYM ORDER BY B.SYS_SOURCE DESC) RN
      FROM ADD_DG_018_STOCK_PLEDGE B
      WHERE B.DATA_DATE = V_P_DATE
       ) A
   WHERE A.RN = 1
     AND NOT EXISTS (SELECT 1 FROM RRP_MDL.M_ADD_DG_018_STOCK_PLEDGE T
                              WHERE T.JYWYM = A.JYWYM
                                AND T.DATA_DATE = V_P_DATE )
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
    SELECT DATA_DATE,JYWYM,YPWYM,COUNT(1)
      FROM RRP_MDL.M_ADD_DG_018_STOCK_PLEDGE T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,JYWYM,YPWYM
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

END ETL_M_ADD_DG_018_STOCK_PLEDGE;
/

