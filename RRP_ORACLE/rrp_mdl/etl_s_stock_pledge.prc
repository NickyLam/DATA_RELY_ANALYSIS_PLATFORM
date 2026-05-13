CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_STOCK_PLEDGE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_S_STOCK_PLEDGE
  *  功能描述：股权质押模型-G16。
  *  创建日期：
  *  开发人员：caichenghuan
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20230418  liuyu    明确数据来源
  *   2    20230427  liuyu    修改第三段押品部分逻辑，按照黎江浩及容炳华给的口径调整
  *   3    20231107  tzj      1.调整修改第三段是否场外交易的取数口径；
  *                           2.调整修改第三段股权质押融资类别取数口径，关联的上s_loan = ‘表内’，else ‘表外’
  *                           3.修改第三段资产借据分配历史\贷款整合表改成left join
  *                           NOT EXISTS 条件 加上 AND T.SYS_SOURCE IN ('对公补录','零售补录')，不然第二次取不到
  *                           4.调整修改第三段 新增关联个人客户信息表，取个人客户名称
  *   4    20231120   LWB     5.修改第三段机构号的取数逻辑，补全表外的数据的机构号
  *   5    20240710   lwb     修改警戒线逻辑
  *   6    20251105   HYF     调整押品类型按照新码值替换
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                               -- 处理步骤
  V_STEP_DESC   VARCHAR2(1000);                                    -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_S_STOCK_PLEDGE';            -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'S_STOCK_PLEDGE';                -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                     -- 分区名称
  V_P_DATE      VARCHAR2(8);                                       -- 跑批数据日期
  V_STARTTIME   DATE;                                              -- 处理开始时间
  V_ENDTIME     DATE;                                              -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                               -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                     -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                      -- 来源系统

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE    := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM    := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
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
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD对公的数据插入到目标表';
  V_STARTTIME := SYSDATE;

    INSERT INTO S_STOCK_PLEDGE
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
    ,'对公补录'            --43 来源系统
    ,A.SFSC                --44 是否删除
   FROM M_ADD_DG_018_STOCK_PLEDGE A    --对公股权质押模型（G16） 同业押品数据
   WHERE A.DATA_DATE = V_P_DATE
    ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 3;
  V_STEP_DESC := '继承ADD零售的数据插入到目标表';
  V_STARTTIME := SYSDATE;

    INSERT INTO S_STOCK_PLEDGE
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
    ,'零售补录'            --43 来源系统
    ,A.SFSC                --44 是否删除
   FROM M_ADD_LS_018_STOCK_PLEDGE A    --零售股权质押模型（G16） 空表
   WHERE NOT EXISTS (
   SELECT 1
   FROM S_STOCK_PLEDGE T
   WHERE A.YPWYM = T.YPWYM
   AND A.JYWYM = T.JYWYM
   AND T.DATA_DATE = V_P_DATE
   )
   AND A.DATA_DATE = V_P_DATE
    ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 4;
  V_STEP_DESC := '押品系统的跑批数据插入到目标表';
  V_STARTTIME := SYSDATE;

    INSERT INTO S_STOCK_PLEDGE NOLOGGING
    (
     DATA_DATE,           --01 数据日期,
     ACCT_ORG_NUM,        --02 账务机构编号,
     YPWYM,               --03 押品唯一码,
     JYWYM,               --04 交易唯一码,
     ZHWYM,               --05 账户唯一码,
     ZWJGMC,              --06 账务机构名称,
     KHWYM,               --07 客户唯一码,
     KHMC,                --08 客户名称,
     YPLB,                --09 押品类别,
     GQZYRZLB,            --10 股权质押融资类别,
     YWLX,                --11 业务类型,
     TFR,                 --12 投放日,
     DQR,                 --13 到期日,
     WJFL,                --14 五级分类,
     TJYE,                --15 统计余额（元）,
     QZ_YJWBLDYE,         --16 其中：已计为不良的余额,
     SFSSGPZY,            --17 是否上市股票质押,
     SFCNJY,              --18 是否场内交易,
     GQCZQYMC,            --19 股权出质企业名称,
     GS,                  --20 股数（股）,
     JJFS,                --21 计价方式,
     MGJZ,                --22 每股价值（元）,
     YPZXGZ,              --23 押品最新估值（元）,
     SFCJYJX,             --24 是否触及预警线,
     YJXJG,               --25 预警线价格（元）,
     QZ_CJYJXDGPSL,       --26 其中：触及预警线的股票数量,
     QZ_CJYJXDYPYE,       --27 其中：触及预警线的押品余额,
     QZ_CJYJXDYPDYDRZYE,  --28 其中：触及预警线的押品对应的融资余额,
     SFCJPCX,             --29 是否触及平仓线,
     PCXJG,               --30 平仓线价格（元）,
     QZ_CJPCXDYPYE,       --31 其中：触及平仓线的押品余额,
     QZ_CJPCXDGPSL,       --32 其中：触及平仓线的股票数量,
     QZ_CJPCXDYPDYDRZYE,  --33 其中：触及平仓线的押品对应的融资余额,
     GQYPYE,              --34 股权押品余额（元）,
     GPSZNFFGBX,          --35 股票市值能否覆盖本息,
     DBFSZB,              --36 担保方式占比,
     BGQNLJPCDRZJE,       --37 报告期内累计平仓的融资金额(元),
     HKSJ,                --38 还款时间,
     PCYPJE,              --39 平仓押品金额（元）,
     PCSJ,                --40 平仓时间,
     SFZBGQNPCGP,         --41 是否在报告期内平仓股票,
     MGPCPJJG,            --42 每股平仓平均价格(元),
     SYS_SOURCE,          --43 来源系统,
     SFSC                 --44 是否删除
    )
    SELECT /*+ PARALLEL(T1,4) */
           V_P_DATE                        AS DATA_DATE           --01 数据日期
          ,COALESCE(T10.ORG_ID,T100.ORG_ID,T101.ORG_NO,'896001')                     AS ACCT_ORG_NUM        --02 账务机构编号
          ,T1.SCCODE                       AS YPWYM               --03 押品唯一码
          ,T1.CREDNO                       AS JYWYM               --04 交易唯一码
          ,T10.CONT_ID                    AS ZHWYM               --05 账户唯一码
          ,T8.ORG_NAME                     AS ZWJGMC              --06 账务机构名称
          ,COALESCE(T10.CUST_ID,T100.CUST_ID,T101.CUST_ID)                     AS KHWYM               --07 客户唯一码
          ,NVL(T11.CUST_NM,T12.CUST_NM)    AS KHMC                --08 客户名称
          ,T1.GUARTYPE                     AS YPLB                --09 押品类别
          ,CASE WHEN T1.CREDNO = T10.RCPT_ID THEN
                                        CASE WHEN SUBSTR(T10.LOAN_BIZ_TYP,0,4) = '0102' THEN '02'   --个人经营性贷款
                                             WHEN T10.DATA_SRC = '对公信贷' THEN '01'    --法人客户贷款
                                             ELSE '99' END --其他
           ELSE '16' END  --表外
                                                 AS GQZYRZLB            --10 股权质押融资类别
          ,T10.STD_PROD_ID                     AS YWLX                --11 业务类型
          ,T10.LOAN_ACT_DSTR_DT                  AS TFR                 --12 投放日
          ,T10.LOAN_ORIG_EXP_DT                  AS DQR                 --13 到期日
          ,T1.LVL5_CL                            AS WJFL                --14 五级分类
          ,T1.DISTVALUE                          AS TJYE                --15 统计余额（元） 用G13拆分后余额  贷款分配价值
          ,''                                    AS QZ_YJWBLDYE         --16 其中：已计为不良的余额(无需使用)
/*          ,CASE WHEN T1.GUARTYPE IN
                               ('ZY0501003',
                                'ZY0501005',
                                'ZY0501007',
                                'ZY0501009',
                                'ZY0501011'
                                )*/
          ,CASE WHEN T1.GUARTYPE IN
                               ('60050010010',
                                '60050010020',
                                '60050010030',
                                '60050010040',
                                '60050010050',
                                '60050010060',
                                '60050010070',
                                '60050010080',
                                '60050010090',
                                '60050010100'
                                )                                
                THEN 'Y'
                ELSE 'N'
            END                                  AS SFSSGPZY            --17 是否上市股票质押
          ,NVL(T9.ISDEAL,'N')                    AS SFCNJY                --18 是否场内交易  同是否上市股票质押逻辑一致
        --,T1.PLEDGOR_NAME                       AS GQCZQYMC            --19 股权出质企业名称
          ,''                                    AS GQCZQYMC            --19 股权出质企业名称
          ,T7.INPWN_STOCK_QTTY                   AS GS                  --20 股数（股）
/*          ,CASE WHEN T1.GUARTYPE IN
                               ('ZY0501003',
                                'ZY0501005',
                                'ZY0501007',
                                'ZY0501009',
                                'ZY0501011')*/
          ,CASE WHEN T1.GUARTYPE IN
                               ('60050010010',
                                '60050010020',
                                '60050010030',
                                '60050010040',
                                '60050010050',
                                '60050010060',
                                '60050010070',
                                '60050010080',
                                '60050010090',
                                '60050010100'
                                )                                 
                THEN '01'--01：元/股
                ELSE '02'--02：股数
            END                                  AS JJFS                --21 计价方式
          ,T7.PER_SHARE_NET_ASSET                AS MGJZ                --22 每股价值（元）
          ,T1.CONFMAMT                           AS YPZXGZ              --23 押品最新估值（元）  用G13拆分后最新估值
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.WARNING_LINE THEN 'Y'
           ELSE 'N' END                          AS SFCJYJX             --24 是否触及预警线
          ,T7.WARNING_LINE                       AS YJXJG               --25 预警线价格（元）
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.WARNING_LINE THEN T7.INPWN_STOCK_QTTY
           ELSE NULL END                         AS QZ_CJYJXDGPSL       --26 其中：触及预警线的股票数量
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.WARNING_LINE THEN T2.SPLT_COL_LATEST_VAL
           ELSE NULL END                         AS QZ_CJYJXDYPYE       --27 其中：触及预警线的押品余额（无需使用）
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.WARNING_LINE THEN T1.DISTVALUE
           ELSE NULL END                         AS QZ_CJYJXDYPDYDRZYE  --28 其中：触及预警线的押品对应的融资余额  以G13的口径，取贷款分配价值
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.CLOSE_POS_LINE THEN 'Y'
           ELSE 'N' END                          AS SFCJPCX             --29 是否触及平仓线
          ,T7.CLOSE_POS_LINE                     AS PCXJG               --30 平仓线价格（元）
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.CLOSE_POS_LINE THEN T2.SPLT_COL_LATEST_VAL
           ELSE NULL END                         AS QZ_CJPCXDYPYE       --31 其中：触及平仓线的押品余额（无需使用）
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.CLOSE_POS_LINE THEN T7.INPWN_STOCK_QTTY
           ELSE NULL END                         AS QZ_CJPCXDGPSL       --32 其中：触及平仓线的股票数量
          ,CASE WHEN T7.PER_SHARE_NET_ASSET <= T7.CLOSE_POS_LINE THEN T1.DISTVALUE
           ELSE NULL END                         AS QZ_CJPCXDYPDYDRZYE  --33 其中：触及平仓线的押品对应的融资余额  以G13的口径，取贷款分配价值
         -- ,T1.HXB_CFM_VAL                      AS GQYPYE              --34 股权押品余额（元）  （无需使用）
          ,''                                    AS GQYPYE              --34 股权押品余额（元）  （无需使用）
          ,''                                    AS GPSZNFFGBX          --35 股票市值能否覆盖本息  （无需使用）
          ,CASE WHEN SUM(T1.CONFMAMT)OVER(PARTITION BY T2.DUBIL_ID)=0 THEN 0
/*                WHEN T1.GUARTYPE IN
                               ('ZY0501003',
                                'ZY0501005',
                                'ZY0501007',
                                'ZY0501009',
                                'ZY0501011')*/
                  WHEN T1.GUARTYPE IN
                               ('60050010010',
                                '60050010020',
                                '60050010030',
                                '60050010040',
                                '60050010050',
                                '60050010060',
                                '60050010070',
                                '60050010080',
                                '60050010090',
                                '60050010100'
                                )                              
                THEN T1.CONFMAMT/SUM(T1.CONFMAMT)OVER(PARTITION BY T2.DUBIL_ID)
           ELSE NULL END                         AS DBFSZB              --36 担保方式占比   参照G13中的股权股票分配我行确认价值/该笔借据下的所有押品分配我行确认价值
          ,CASE WHEN T9.CLOSINGSTOCK = '1' THEN T9.FINANCINGAMOUNT
           ELSE NULL END                         AS BGQNLJPCDRZJE       --37 报告期内累计平仓的融资金额(元)
          ,T9.REPAYMENTTIME                      AS HKSJ                --38 还款时间
          ,T9.CLOSINGAMOUNT                      AS PCYPJE              --39 平仓押品金额（元）
          ,T9.CLOSINGTIME                        AS PCSJ                --40 平仓时间
          ,CASE WHEN T9.CLOSINGSTOCK = '1' THEN 'Y'
           ELSE 'N' END                          AS SFZBGQNPCGP         --41 是否在报告期内平仓股票
          ,T9.CLOSINGPRICE                       AS MGPCPJJG            --42 每股平仓平均价格(元)
          ,T1.DATA_SRC                            AS SYS_SOURCE          --43 来源系统
          ,'N'                                   AS SFSC                --44 是否删除
      FROM RRP_MDL.S_G13_BASE T1    --G13贷款押品分配结果表
     LEFT JOIN RRP_MDL.O_IML_AST_DUBIL_ASSIGN_H T2    --资产借据分配历史
        ON T2.ASSET_ID = T1.SCCODE
       AND T2.DUBIL_ID = T1.CREDNO
       AND T2.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND T2.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IML_AST_COL_LIST_STOCK_INPWN_INFO T7 -- 押品上市公司股权质押信息
        ON T7.ASSET_ID = T1.SCCODE
       AND T7.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T7.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_MIMS_SI_STOCKSTOCK T9  --上市公司股权表
      ON  T9.SCCODE = T2.ASSET_ID
      AND T9.CREDNO = T2.DUBIL_ID
      LEFT JOIN RRP_MDL.S_LOAN T10 --贷款整合表
      ON T1.CREDNO = T10.RCPT_ID
      AND T10.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.S_OUT_DUBILL T100
        ON T100.RCPT_ID=T1.CREDNO
       AND T100.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.S_CPTL_INVEST T101
        ON T101.CREDNO=T1.CREDNO
       AND T101.DATA_DT = V_P_DATE
/*      INNER JOIN RRP_MDL.A_FGB_ACCT_LOAN T11  --对公账务基表
        ON T11.JYWYM = T1.CREDNO
       AND T11.BGRQ = V_P_DATE*/
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T8 --内部机构信息表
        ON T8.ORG_ID = T10.ORG_ID
       AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T11
        ON T11.CUST_ID = T10.CUST_ID
       AND T11.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_IND_INFO T12
        ON T12.CUST_ID = T10.CUST_ID
       AND T12.DATA_DT = V_P_DATE
/*     WHERE T1.GUARTYPE IN
                    ('ZY0501001',
                     'ZY0501002',
                     'ZY0501003',
                     'ZY0501004',
                     'ZY0501005',
                     'ZY0501006',
                     'ZY0501007',
                     'ZY0501008',
                     'ZY0501009',
                     'ZY0501010',
                     'ZY0501011',
                     'ZY0501012',
                     'ZY0503001',
                     'ZY0599001')--只取股权质押相关的押品信息*/
     WHERE T1.GUARTYPE IN
                    ('60050010010',
                     '60050010020',
                     '60050010030',
                     '60050010040',
                     '60050010050',
                     '60050010060',
                     '60050010070',
                     '60050010080',
                     '60050010090',
                     '60050010100',
                     '60050020010')--只取股权质押相关的押品信息                     
       AND NOT EXISTS(
    SELECT 1
   FROM RRP_MDL.S_STOCK_PLEDGE T
   INNER JOIN RRP_MDL.O_IML_AST_DUBIL_ASSIGN_H T2    --资产借据分配历史
        ON T2.ASSET_ID = T1.SCCODE
       AND T2.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND T2.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
   WHERE T1.SCCODE = T.YPWYM
   AND T2.DUBIL_ID = T.JYWYM
   AND T.DATA_DATE = V_P_DATE
   AND T.SYS_SOURCE IN ('对公补录','零售补录')
       )
   AND T1.DATA_DT = V_P_DATE
    ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 5;
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
  V_STEP      := 6;
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

END ETL_S_STOCK_PLEDGE;
/

