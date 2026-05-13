CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_INIT
(I_P_DATE  IN INTEGER,
 I_INIT_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2)
/*基表补录表初始化脚本 20230512投产初始化数据使用
1.整表初始化
  ADD_DG_011_ASSETS_CONVEY
  ADD_DG_014_NATION_CREDIT
  ADD_DG_015_NATION_FOREIGN
2.字段初始化
  ADD_DG_001_CUST
  ADD_DG_002_CREDIT
  ADD_DG_003_MONEY
  ADD_DG_006_HOUSE_LAND
  ADD_DG_012_FINANCE_GUARAN
3.无需初始化
  ADD_LS_003_MONEY --新增补录表
  ADD_LS_018_STOCK_PLEDGE --补录口径变更
  ADD_DG_018_STOCK_PLEDGE --补录口径变更
  ADD_LS_013_ASSETS_CONVEY --零售报表不初始化
  ADD_LS_FEE_WAIVER_TYPE  --零售报表不初始化
  ADD_LS_014_FINANCE_GUARAN --零售报表不初始化
*/
  AS
  -- 定义变量 --
  V_STEP        INTEGER;                                            -- 处理步骤
  V_STEP_DESC   VARCHAR2(200);                                      -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100);                                      -- 程序名称
  V_TABLE_NAME  VARCHAR2(100);                                      -- 报表名称
  V_P_DATE      VARCHAR2(8);                                        -- 跑批数据日期
  V_STARTTIME   DATE;                                               -- 处理开始时间
  V_ENDTIME     DATE;                                               -- 处理结束时间
  V_SQLCOUNT    INTEGER;                                            -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                      -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                       -- 来源系统
  V_INIT_DATE   VARCHAR2(8);                                        -- 同步原始日期

BEGIN
  -- 传入参数
  V_STEP        := 1;
  V_STEP_DESC   := '-- 程序跑批开始 --';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;
  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  V_SYSTEM      := '监管报送';
  V_PROC_NAME   := 'ETL_ADD_INIT';

  V_P_DATE      := TO_CHAR(I_P_DATE);       -- 获取跑批日期
  V_INIT_DATE   := TO_CHAR(I_INIT_DATE);    -- 同步原始日期

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --========================= 整表初始化 START ===================================

  V_TABLE_NAME  := 'ADD_DG_011_ASSETS_CONVEY'; -- 报表名称

  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '新建'||V_TABLE_NAME||'表'||V_P_DATE||'期分区';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);
  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进'||V_TABLE_NAME||'的'||V_P_DATE||'分区';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.ADD_DG_011_ASSETS_CONVEY
          (
           DATA_DATE      --01 数据日期
          ,ACCT_ORG_NUM   --02 账务机构编号
          ,JYWYM          --03 交易唯一码
          ,ZWJGMC         --04 账务机构名称
          ,KHWYM          --05 客户唯一码
          ,KHMC           --06 客户名称
          ,CPLX           --07 产品类型
          ,CPMC           --08 产品名称
          ,ZQZRRQ         --09 债权转让日期
          ,ZRFSLB         --10 转让方式类别
          ,ZRFS           --11 转让方式
          ,DYBJ           --12 对应本金
          ,DZHZRHSXJ      --18 调整后转让回收现金（元）
          ,ZRSHQTDJ       --19 转让收回其他对价（元）
          ,ZCJE           --20 自持金额（元）
          ,ZCZRJYPT       --21 资产转让交易平台
          ,ZCZRDJPT       --22 资产转让登记平台
          ,ZJJYDSLB       --23 直接交易对手类别
          ,JYDSMC         --24 交易对手名称
          ,ZQZRYZ         --25 债权转让原值（元）
          ,ZQZRXYJE       --26 债权转让协议金额（元）
          ,DJPTDJJE       --27 登记平台登记金额
          ,SYS_SOURCE     --28 来源系统
          ,SFSC           --29 是否删除
          )
    SELECT
           V_P_DATE      AS DATA_DATE
          ,ACCT_ORG_NUM   --02 账务机构编号
          ,JYWYM          --03 交易唯一码
          ,ZWJGMC         --04 账务机构名称
          ,KHWYM          --05 客户唯一码
          ,KHMC           --06 客户名称
          ,CPLX           --07 产品类型
          ,CPMC           --08 产品名称
          ,ZQZRRQ         --09 债权转让日期
          ,ZRFSLB         --10 转让方式类别
          ,ZRFS           --11 转让方式
          ,DYBJ           --12 对应本金
          ,DZHZRHSXJ      --18 调整后转让回收现金（元）
          ,ZRSHQTDJ       --19 转让收回其他对价（元）
          ,ZCJE           --20 自持金额（元）
          ,ZCZRJYPT       --21 资产转让交易平台
          ,ZCZRDJPT       --22 资产转让登记平台
          ,ZJJYDSLB       --23 直接交易对手类别
          ,JYDSMC         --24 交易对手名称
          ,ZQZRYZ         --25 债权转让原值（元）
          ,ZQZRXYJE       --26 债权转让协议金额（元）
          ,DJPTDJJE       --27 登记平台登记金额
          ,SYS_SOURCE     --28 来源系统
          ,SFSC           --29 是否删除
      FROM DATACORE.ADD_DG_011_ASSETS_CONVEY
     WHERE DATA_DATE = V_INIT_DATE; -- 取旧系统某一天数据插入新表数据

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_TABLE_NAME  := 'ADD_DG_014_NATION_CREDIT'; -- 报表名称

  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '新建'||V_TABLE_NAME||'表'||V_P_DATE||'期分区';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);
  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进'||V_TABLE_NAME||'的'||V_P_DATE||'分区';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.ADD_DG_014_NATION_CREDIT
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
     --,SFWCYGJYDYLXM         --28 是否为参与共建一带一路项目 新一代新增字段
    )
    SELECT
          V_P_DATE      AS DATA_DATE
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
     FROM DATACORE.ADD_DG_014_NATION_CREDIT
    WHERE DATA_DATE = V_INIT_DATE; -- 取旧系统某一天数据插入新表数据

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_TABLE_NAME  := 'ADD_DG_015_NATION_FOREIGN'; -- 报表名称

  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '新建'||V_TABLE_NAME||'表'||V_P_DATE||'期分区';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);
  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进'||V_TABLE_NAME||'的'||V_P_DATE||'分区';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.ADD_DG_015_NATION_FOREIGN
     (
      DATA_DATE             -- 01 数据日期
     ,ACCT_ORG_NUM          -- 02 账务机构编号
     ,JYWYM                 -- 03 交易唯一码
     ,ZHWYM                 -- 04 账户唯一码
     ,ZWJGMC                -- 05 账务机构名称
     ,YWLB                  -- 06 业务类别
     ,SFNBWD                -- 07 是否内保外贷
     ,DWDBLB                -- 08 对外担保类别
     ,YSQSRQ                -- 09 原始起始日期
     ,SFBNQY                -- 10 是否本年签约
     ,SJDQRQ                -- 11 实际到期日期
     ,DWDBQYE               -- 12 对外担保签约额（元）
     ,DWDBLYRQ              -- 13 对外担保履约日期
     ,SFBNLY                -- 14 是否本年履约
     ,DWDBLYE               -- 15 对外担保履约额（元）
     ,DWDBDQSXJE            -- 16 对外担保到期失效金额（元）
     ,DWDBQMYE              -- 17 对外担保期末余额（元）
     ,YCHDWDBDKJE           -- 18 已偿还对外担保垫款金额（元）
     ,DWDBQMDKYE            -- 19 对外担保期末垫款余额（元）
     ,SYS_SOURCE            -- 20 来源系统
  )
  SELECT
        V_P_DATE      AS DATA_DATE
       ,ACCT_ORG_NUM          -- 02 账务机构编号
       ,JYWYM                 -- 03 交易唯一码
       ,ZHWYM                 -- 04 账户唯一码
       ,ZWJGMC                -- 05 账务机构名称
       ,YWLB                  -- 06 业务类别
       ,SFNBWD                -- 07 是否内保外贷
       ,DWDBLB                -- 08 对外担保类别
       ,YSQSRQ                -- 09 原始起始日期
       ,SFBNQY                -- 10 是否本年签约
       ,SJDQRQ                -- 11 实际到期日期
       ,DWDBQYE               -- 12 对外担保签约额（元）
       ,DWDBLYRQ              -- 13 对外担保履约日期
       ,SFBNLY                -- 14 是否本年履约
       ,DWDBLYE               -- 15 对外担保履约额（元）
       ,DWDBDQSXJE            -- 16 对外担保到期失效金额（元）
       ,DWDBQMYE              -- 17 对外担保期末余额（元）
       ,YCHDWDBDKJE           -- 18 已偿还对外担保垫款金额（元）
       ,DWDBQMDKYE            -- 19 对外担保期末垫款余额（元）
       ,SYS_SOURCE            -- 20 来源系统
     FROM DATACORE.ADD_DG_015_NATION_FOREIGN
    WHERE DATA_DATE = V_INIT_DATE; -- 取旧系统某一天数据插入新表数据

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --========================= 整表初始化 END ===================================

  --========================= 字段初始化 START ===================================
  --备份表 跑批前备份
  /*字段初始化
  ADD_DG_001_CUST
  ADD_DG_002_CREDIT
  ADD_DG_003_MONEY
  ADD_DG_006_HOUSE_LAND
  ADD_DG_012_FINANCE_GUARAN*/
  V_TABLE_NAME  := 'ADD_DG_001_CUST'; -- 报表名称

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '清理TMP_'||V_TABLE_NAME||'临时表数据';
  V_STARTTIME  := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_'||V_TABLE_NAME;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --建立临时表
  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进TMP_'||V_TABLE_NAME||'表';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.TMP_ADD_DG_001_CUST
  ( DATA_DATE           --01 数据日期
   ,ACCT_ORG_NUM        --02 账务机构编号
   ,KHWYM               --04 客户唯一码
   ,KHMC                --05 客户名称
   ,ZJLX                --06 证件类型
   ,ZJHM                --07 证件号码
   ,SFGTQY              --09 是否关停企业
   ,BXCDJMFYLB          --11 本行承担/减免费用类別
   ,BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
   ,SYS_SOURCE          --13 来源系统
  )
  SELECT
        V_P_DATE                      AS DATA_DATE           --01 数据日期
       ,T1.ACCT_ORG_NUM               AS ACCT_ORG_NUM        --02 账务机构编号
       ,T1.KHWYM                      AS KHWYM               --04 客户唯一码
       ,T1.KHMC                       AS KHMC                --05 客户名称
       ,T1.ZJLX                       AS ZJLX                --06 证件类型
       ,T1.ZJHM                       AS ZJHM                --07 证件号码
       ,NVL(T2.SFGTQY,T1.SFGTQY)      AS SFGTQY              --09 是否关停企业
       ,NVL(T2.BXCDJMFYLB,T1.BXCDJMFYLB)
                                      AS BXCDJMFYLB          --11 本行承担/减免费用类別
       ,NVL(T2.BNLJCDHJMDXDXGFYJE,T1.BNLJCDHJMDXDXGFYJE)
                                      AS BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
       ,T1.SYS_SOURCE          --13 来源系统
    FROM RRP_MDL.ADD_DG_001_CUST T1
    LEFT JOIN DATACORE.ADD_DG_001_CUST T2
      ON T1.KHWYM = T2.KHWYM
     AND T2.DATA_DATE = V_INIT_DATE --取旧系统某一天数据插入新表数据
   WHERE T1.DATA_DATE = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --删除数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '清除'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --插入数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '将临时表数据插入'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  INSERT INTO RRP_MDL.ADD_DG_001_CUST
  ( DATA_DATE           --01 数据日期
   ,ACCT_ORG_NUM        --02 账务机构编号
   ,KHWYM               --04 客户唯一码
   ,KHMC                --05 客户名称
   ,ZJLX                --06 证件类型
   ,ZJHM                --07 证件号码
   ,SFGTQY              --09 是否关停企业
   ,BXCDJMFYLB          --11 本行承担/减免费用类別
   ,BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
   ,SYS_SOURCE          --13 来源系统
  )
  SELECT DATA_DATE           --01 数据日期
       ,ACCT_ORG_NUM        --02 账务机构编号
       ,KHWYM               --04 客户唯一码
       ,KHMC                --05 客户名称
       ,ZJLX                --06 证件类型
       ,ZJHM                --07 证件号码
       ,SFGTQY              --09 是否关停企业
       ,BXCDJMFYLB          --11 本行承担/减免费用类別
       ,BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
       ,SYS_SOURCE          --13 来源系统
    FROM TMP_ADD_DG_001_CUST;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);






  V_TABLE_NAME  := 'ADD_DG_002_CREDIT'; -- 报表名称

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '清理TMP_'||V_TABLE_NAME||'临时表数据';
  V_STARTTIME  := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_'||V_TABLE_NAME;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --建立临时表
  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进TMP_'||V_TABLE_NAME||'表';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.TMP_ADD_DG_002_CREDIT
  (  DATA_DATE      --01 数据日期
    ,ACCT_ORG_NUM   --02 账务机构编号
    ,KHWYM          --06 客户唯一码
    ,KHMC           --07 客户名称
    ,CNYE           --08 承诺余额（元）
    ,SYS_SOURCE     --09 来源系统
    ,ZSXED          --10 总授信额度
    ,YYED           --11 已用额度
  )
  SELECT
        V_P_DATE                      AS DATA_DATE           --01 数据日期
       ,T1.ACCT_ORG_NUM               AS ACCT_ORG_NUM        --02 账务机构编号
       ,T1.KHWYM                      AS KHWYM               --06 客户唯一码
       ,T1.KHMC                       AS KHMC                --07 客户名称
       ,NVL(T2.CNYE,T1.CNYE)          AS CNYE                --08 承诺余额（元）
       ,T1.SYS_SOURCE                 AS SYS_SOURCE          --09 来源系统
       ,T1.ZSXED                      AS ZSXED               --10 总授信额度
       ,T1.YYED                       AS YYED                --11 已用额度
    FROM RRP_MDL.ADD_DG_002_CREDIT T1
    LEFT JOIN
    (SELECT KHWYM,MAX(CNYE) CNYE
    FROM DATACORE.ADD_DG_002_CREDIT
    WHERE DATA_DATE = V_INIT_DATE
    GROUP  BY KHWYM ) T2
      ON T1.KHWYM = T2.KHWYM
      --取旧系统某一天数据插入新表数据
   WHERE T1.DATA_DATE = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --删除数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '清除'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --插入数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '将临时表数据插入'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  INSERT INTO RRP_MDL.ADD_DG_002_CREDIT
  (  DATA_DATE      --01 数据日期
    ,ACCT_ORG_NUM   --02 账务机构编号
    ,KHWYM          --06 客户唯一码
    ,KHMC           --07 客户名称
    ,CNYE           --08 承诺余额（元）
    ,SYS_SOURCE     --09 来源系统
    ,ZSXED          --10 总授信额度
    ,YYED           --11 已用额度
  )
  SELECT DATA_DATE      --01 数据日期
        ,ACCT_ORG_NUM   --02 账务机构编号
        ,KHWYM          --06 客户唯一码
        ,KHMC           --07 客户名称
        ,CNYE           --08 承诺余额（元）
        ,SYS_SOURCE     --09 来源系统
        ,ZSXED          --10 总授信额度
        ,YYED           --11 已用额度
    FROM TMP_ADD_DG_002_CREDIT;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);




  V_TABLE_NAME  := 'ADD_DG_003_MONEY'; -- 报表名称

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '清理TMP_'||V_TABLE_NAME||'临时表数据';
  V_STARTTIME  := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_'||V_TABLE_NAME;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --建立临时表
  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进TMP_'||V_TABLE_NAME||'表';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.TMP_ADD_DG_003_MONEY
    (  DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
    )
  SELECT
         V_P_DATE                     AS DATA_DATE,        --01 数据日期
         T1.ACCT_ORG_NUM              AS ACCT_ORG_NUM,    --02 账务机构编号,
         T1.JYWYM                     AS JYWYM,           --03 交易唯一码,
         T1.ZHWYM                     AS ZHWYM,           --04 账户唯一码,
         T1.KHWYM                     AS KHWYM,           --05 客户唯一码,
         T1.KHMC                      AS KHMC,            --06 客户名称,
         T1.PJBH                      AS PJBH,            --07 票据编号,
         T1.JBJGMC                    AS JBJGMC,          --08 经办机构名称,
         T1.JBJGJGSZXZQHDM            AS JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
         T1.ZWJGMC                    AS ZWJGMC,          --10 账务机构名称,
         T1.ZWJGJGSZXZQHDM            AS ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
         T1.TXGTJCYML                 AS TXGTJCYML,        --12 投向高技术产业门类,
         NVL(T2.SFTXGJSCY,T1.SFTXGJSCY)
                                      AS SFTXGJSCY,       --13 是否投向高技术产业,
         T1.TXGJSZZYDLMC              AS TXGJSZZYDLMC,     --14 投向高技术制造业大类,
         T1.GJSCYMC                   AS GJSCYMC,          --15 高技术产业名称,
         NVL(T2.SFTXZSCQMJXCY,T1.SFTXZSCQMJXCY)
                                      AS SFTXZSCQMJXCY,    --16 是否投向知识产权密集型产业,
         T1.ZSCQMJXCYMC               AS ZSCQMJXCYMC,      --17 知识产权密集型产业名称,
         NVL(T2.TXSZJJHXCYDL,T1.TXSZJJHXCYDL)
                                      AS TXSZJJHXCYDL,     --18 投向数字经济核心产业大类,
         T1.SZJJHXCYMC                AS SZJJHXCYMC,       --19 数字经济核心产业名称,
         NVL(T2.TXZLXXXCYML,T1.TXZLXXXCYML)
                                      AS TXZLXXXCYML,      --20 投向战略性新兴产业门类,
         NVL(T2.TXZLXXXCYML,T1.ZYXXXCYMC)
                                      AS ZYXXXCYMC,        --21 战略性新兴产业名称,
         NVL(T2.SFTXWHCYDL,T1.SFTXWHCYDL)
                                      AS SFTXWHCYDL,       --22 是否投向文化产业大类,
         NVL(T2.TXWHJXGCYXL,T1.WHCYMC)
                                      AS WHCYMC,           --23 文化产业名称,
         NVL(T2.SFGYQYJSGZSJDK,T1.SFGYQYJSGZSJDK)
                                      AS SFGYQYJSGZSJDK,   --24 是否工业企业技术改造升级贷款,
         NVL(T2.SFYSHZ,T1.SFYSHZ)     AS SFYSHZ,           --25 是否银税合作,
         NVL(T2.SFNYCYHLTQY,T1.SFNYCYHLTQY)
                                      AS SFNYCYHLTQY,      --26 是否农业产业化龙头企业
         NVL(T2.SFYQ,T1.SFYQ)         AS SFYQ,            --27 是否延期,
         T1.SYS_SOURCE                AS SYS_SOURCE,      --28 来源系统,
         NVL(T2.SFGXRBZ,T1.SFGXRBZ)   AS SFGXRBZ,         --29 是否关系人保证,
         T1.KHZBKHJLKHH               AS KHZBKHJLKHH,     --30 客户主办客户经理客户号,
         T1.KHZBGYH                   AS KHZBGYH,         --31 客户主办柜员号,
         T1.KHZBKHJLMC                AS KHZBKHJLMC,      --32 客户主办客户经理名称,
         T1.KHZBKHJLSSJG              AS KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
         T1.JJZBKHJLH                 AS JJZBKHJLH,       --34 借据主办客户经理号,
         T1.JJZBGYH                   AS JJZBGYH,         --35 借据主办柜员号,
         T1.JJZBKHJLMC                AS JJZBKHJLMC,      --36 借据主办客户经理名称,
         T1.JJZBKHJLSSJG              AS JJZBKHJLSSJG     --37 借据主办客户经理所属机构
    FROM RRP_MDL.ADD_DG_003_MONEY T1
    LEFT JOIN DATACORE.ADD_DG_003_MONEY T2
      ON T1.JYWYM = T2.JYWYM
     AND T2.DATA_DATE = V_INIT_DATE --取旧系统某一天数据插入新表数据
   WHERE T1.DATA_DATE = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --删除数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '清除'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --插入数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '将临时表数据插入'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  INSERT INTO RRP_MDL.ADD_DG_003_MONEY
    (  DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
    )
  SELECT DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
    FROM TMP_ADD_DG_003_MONEY;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);





  V_TABLE_NAME  := 'ADD_DG_006_HOUSE_LAND'; -- 报表名称

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '清理TMP_'||V_TABLE_NAME||'临时表数据';
  V_STARTTIME  := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_'||V_TABLE_NAME;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --建立临时表
  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进TMP_'||V_TABLE_NAME||'表';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.TMP_ADD_DG_006_HOUSE_LAND
  (  DATA_DATE     --01 数据日期
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
        V_P_DATE                      AS DATA_DATE           --01 数据日期
       ,T1.ACCT_ORG_NUM               AS ACCT_ORG_NUM        --02 账务机构编号
       ,T1.JYWYM                      AS JYWYM               --03 交易唯一码
       ,NVL(T2.ZFZLDKLB,T1.ZFZLDKLB)  AS ZFZLDKLB            --04 住房租赁贷款类别
       ,NVL(T2.BZXZLZFDKLB,T1.BZXZLZFDKLB)
                                      AS BZXZLZFDKLB         --05 保障性租赁住房贷款类别
       ,T1.ZHWYM                      AS ZHWYM               --06 账户唯一码
       ,T1.KHWYM                      AS KHWYM               --07 客户唯一码
       ,T1.KHMC                       AS KHMC                --08 客户名称
       ,T1.SYS_SOURCE                 AS SYS_SOURCE          --09 来源系统
    FROM RRP_MDL.ADD_DG_006_HOUSE_LAND T1
    LEFT JOIN DATACORE.ADD_DG_006_HOUSE_LAND T2
      ON T1.JYWYM = T2.JYWYM
     AND T2.DATA_DATE = V_INIT_DATE --取旧系统某一天数据插入新表数据
   WHERE T1.DATA_DATE = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --删除数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '清除'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --插入数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '将临时表数据插入'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  INSERT INTO RRP_MDL.ADD_DG_006_HOUSE_LAND
  (  DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZFZLDKLB      --04 住房租赁贷款类别
    ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
    ,ZHWYM         --06 账户唯一码
    ,KHWYM         --07 客户唯一码
    ,KHMC          --08 客户名称
    ,SYS_SOURCE    --09 来源系统
  )
  SELECT DATA_DATE     --01 数据日期
        ,ACCT_ORG_NUM  --02 账务机构编号
        ,JYWYM         --03 交易唯一码
        ,ZFZLDKLB      --04 住房租赁贷款类别
        ,BZXZLZFDKLB   --05 保障性租赁住房贷款类别
        ,ZHWYM         --06 账户唯一码
        ,KHWYM         --07 客户唯一码
        ,KHMC          --08 客户名称
        ,SYS_SOURCE    --09 来源系统
    FROM TMP_ADD_DG_006_HOUSE_LAND;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);





  V_TABLE_NAME  := 'ADD_DG_012_FINANCE_GUARAN'; -- 报表名称

  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '清理TMP_'||V_TABLE_NAME||'临时表数据';
  V_STARTTIME  := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_'||V_TABLE_NAME;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --建立临时表
  V_STEP       := V_STEP + 1;
  V_STEP_DESC  := '插入DATACORE'||V_INIT_DATE||'期数据进TMP_'||V_TABLE_NAME||'表';
  V_STARTTIME  := SYSDATE;

  INSERT INTO RRP_MDL.TMP_ADD_DG_012_FINANCE_GUARAN
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
    )
  SELECT
         V_P_DATE                      AS DATA_DATE        --01 数据日期
        ,NVL(T2.ACCT_ORG_NUM,T1.ACCT_ORG_NUM)
                                       AS ACCT_ORG_NUM     --02 账务机构编号
        ,NVL(T2.ZWJGMC,T1.ZWJGMC)      AS ZWJGMC           --03 账务机构名称
        ,NVL(T2.JGSZSJXZQ,T1.JGSZSJXZQ)
                                       AS JGSZSJXZQ        --04 机构所在省级行政区
        ,NVL(T2.ZHWYM,T1.ZHWYM)        AS ZHWYM            --05 账户唯一码
        ,NVL(T2.JYWYM,T1.JYWYM)        AS JYWYM            --06 交易唯一码
        ,NVL(T2.KHWYM,T1.KHWYM)        AS KHWYM            --07 客户唯一码
        ,NVL(T2.KHMC,T1.KHMC)          AS KHMC             --08 客户名称
        ,NVL(T2.TJXWQYLB,T1.TJXWQYLB)  AS TJXWQYLB         --09 统计小微企业类别
        ,NVL(T2.SFPHXWQY,T1.SFPHXWQY)  AS SFPHXWQY         --10 是否普惠小微企业
        ,NVL(T2.SXED,T1.SXED)          AS SXED             --11 授信额度
        ,NVL(T2.FKRQ,T1.FKRQ)          AS FKRQ             --12 放款日期
        ,NVL(T2.FKJE,T1.FKJE)          AS FKJE             --13 放款金额
        ,NVL(T1.TJYE,T2.TJYE)          AS TJYE             --14 统计余额（元）
        ,NVL(T2.DKDQRQ,T1.DKDQRQ)      AS DKDQRQ           --15 贷款到期日期
        ,NVL(T1.BGRDKYQTS,T2.BGRDKYQTS)
                                       AS BGRDKYQTS        --16 报告日贷款逾期天数
        ,NVL(T1.TJYQTS,T2.TJYQTS)      AS TJYQTS           --17 统计逾期天数（天）
        ,NVL(T1.TJYQBJJE,T2.TJYQBJJE)  AS TJYQBJJE         --18 统计逾期本金金额（元）
        ,NVL(T2.WJFL,T1.WJFL)          AS WJFL             --19 五级分类
        ,NVL(T2.DBJGBH,T1.DBJGBH)      AS DBJGBH           --20 担保机构编号
        ,NVL(T2.DBJGMC,T1.DBJGMC)      AS DBJGMC           --21 担保机构名称
        ,NVL(T2.DBFS,T1.DBFS)          AS DBFS             --22 担保方式
        ,NVL(T2.SFRZDBGSBZ,T1.SFRZDBGSBZ)
                                       AS SFRZDBGSBZ       --23 是否融资担保公司保证
        ,NVL(T2.ZFXRZDBJGBJ,T1.ZFXRZDBJGBJ)
                                       AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
        ,NVL(T2.SFZFXRZDBGSBZ,T1.SFZFXRZDBGSBZ)
                                       AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
        ,NVL(T2.SFNHJXXNYJYZTDK,T1.SFNHJXXNYJYZTDK)
                                       AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
        ,NVL(T2.BNDLJSJHDDCJE,T1.BNDLJSJHDDCJE)
                                       AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
        ,NVL(T2.BGRSWLXDCZRJE,T1.BGRSWLXDCZRJE)
                                       AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
        ,NVL(T2.BZ,T1.BZ)              AS BZ               --29 备注
        ,NVL(T2.SYS_SOURCE,T1.SYS_SOURCE)
                                       AS SYS_SOURCE       --30 系统来源
        ,NVL(T2.SFSC,T1.SFSC)          AS SFSC             --31 是否删除
        ,NVL(T2.JYXKZBH,T1.JYXKZBH)    AS JYXKZBH          --32 经营许可证编号
    FROM RRP_MDL.ADD_DG_012_FINANCE_GUARAN T1
    LEFT JOIN DATACORE.ADD_DG_012_FINANCE_GUARAN T2
      ON T1.JYWYM = T2.JYWYM
     AND T2.DATA_DATE = V_INIT_DATE --取旧系统某一天数据插入新表数据
   WHERE T1.DATA_DATE = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --删除数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '清除'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME, '1', O_ERRCODE);

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --插入数据
  V_STEP        := V_STEP + 1;
  V_STEP_DESC   := '将临时表数据插入'||V_TABLE_NAME||'表'||V_P_DATE||'期数据';
  V_STARTTIME   := SYSDATE;
  V_SQLCOUNT    := SQL%ROWCOUNT;

  INSERT INTO RRP_MDL.ADD_DG_012_FINANCE_GUARAN
  (  DATA_DATE        --01 数据日期
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
  )
  SELECT DATA_DATE        --01 数据日期
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
    FROM TMP_ADD_DG_012_FINANCE_GUARAN;

  V_SQLMSG      := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE     := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --========================= 字段初始化 END ===================================

  -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_ADD_INIT;
/

