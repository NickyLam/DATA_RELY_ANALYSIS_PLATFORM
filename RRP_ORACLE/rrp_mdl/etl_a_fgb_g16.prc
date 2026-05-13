CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_G16
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
/**************************************************************************
  *  程序名称：ETL_A_FGB_G16
  *  功能描述：对公-股权质押模型（G16）
  *  创建日期：20221107
  *  开发人员：WYX
  *  来源表：
  *  目标表：A_FGB_G16           --对公-股权质押模型（G16）
  *  配置表：
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   WYX        首次创建
  *   2    20230418   liuyu      G16有零售和风管数据，都放在一个基表里面，新增数据来源字段标志
***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_G16';   --程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_FGB_G16';         --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

  -- 程序业务逻辑处理主体部分 --
   V_STEP      := V_STEP + 1;
   V_STEP_DESC := '股权质押模型（G16）';
   V_STARTTIME := SYSDATE;

    INSERT /*+APPEND*/ INTO A_FGB_G16 NOLOGGING
    (
           BGRQ  --1 报告日期
          ,JYWYM  --2 交易唯一码
          ,ZHWYM  --3 账户唯一码
          ,YPWYM  --4 押品唯一码
          ,JGMC  --5 机构名称
          ,JGBH  --6 机构编号
          ,KHWYM  --7 客户唯一码
          ,KHMC  --8 客户名称
          ,YPLB  --9 押品类别
          ,GQZYRZLB  --10 股权质押融资类别
          ,YWLX  --11 业务类型
          ,TFR  --12 投放日
          ,DQR  --13 到期日
          ,WJFL  --14 五级分类
          ,TJYE  --15 统计余额（元）
          ,QZ_YJWBLDYE  --16 其中：已计为不良的余额
          ,SFSSGPZY  --17 是否上市股票质押
          ,SFCNJY  --18 是否场内交易
          ,GQCZQYMC  --19 股权出质企业名称
          ,GS  --20 股数（股）
          ,JJFS  --21 计价方式
          ,MGJZ  --22 每股价值（元）
          ,YPZXGZ  --23 押品最新估值（元）
          ,SFCJYJX  --24 是否触及预警线
          ,YJXJG  --25 预警线价格（元）
          ,QZ_CJYJXDGPSL  --26 其中：触及预警线的股票数量
          ,QZ_CJYJXDYPYE  --27 其中：触及预警线的押品余额
          ,QZ_CJYJXDYPDYDRZYE  --28 其中：触及预警线的押品对应的融资余额
          ,SFCJPCX  --29 是否触及平仓线
          ,PCXJG  --30 平仓线价格（元）
          ,QZ_CJPCXDYPYE  --31 其中：触及平仓线的押品余额
          ,QZ_CJPCXDGPSL  --32 其中：触及平仓线的股票数量
          ,QZ_CJPCXDYPDYDRZYE  --33 其中：触及平仓线的押品对应的融资余额
          ,GQYPYE  --34 股权押品余额（元）
          ,GPSZNFFGBX  --35 股票市值能否覆盖本息
          ,DBFSZB  --36 上市股票担保程度
          ,BGQNLJPCDRZJE  --37 报告期内累计平仓的融资金额(元)
          ,HKSJ  --38 还款时间
          ,PCYPJE  --39 平仓押品金额（元）
          ,PCSJ  --40 平仓时间
          ,SFZBGQNPCGP  --41 是否在报告期内平仓股票
          ,MGPCPJJG  --42 每股平仓平均价格(元)
          ,SJLY      --43 数据来源
          )
     SELECT
           V_P_DATE             AS BGRQ  --1 报告日期
          ,T1.JYWYM             AS JYWYM  --2 交易唯一码
          ,T1.ZHWYM             AS ZHWYM  --3 账户唯一码
          ,T1.YPWYM             AS YPWYM  --4 押品唯一码
          ,T2.ORG_NM            AS JGMC  --5 机构名称
          ,T1.ACCT_ORG_NUM      AS JGBH  --6 机构编号
          ,T1.KHWYM             AS KHWYM  --7 客户唯一码
          ,T1.KHMC              AS KHMC  --8 客户名称
          ,M1.SRC_VALUE_NAME  AS YPLB  --9 押品类别
          ,DECODE(T1.GQZYRZLB,'01','法人客户贷款'
                             ,'02','个人经营性贷款'
                             ,'03','买入返售金融资产'
                             ,'04','私募证券投资基金（含FOF）'
                             ,'05','私募股权投资基金（含FOF）'
                             ,'06','私募创业投资基金（含FOF）'
                             ,'07','其他私募基金（含FOF）'
                             ,'08','非保本理财产品'
                             ,'09','信托产品'
                             ,'10','证券业资产管理产品（不含公募基金）'
                             ,'11','保险业资产管理产品'
                             ,'12','其他资产管理产品'
                             ,'13','其他债权融资类产品'
                             ,'14','以上未包括的投资项目'
                             ,'15','发行非保本理财产品'
                             ,'16','其他表外业务' )
                                             AS GQZYRZLB  --10 股权质押融资类别
          ,NVL(C1.PROD_NAME,T1.YWLX)         AS YWLX  --11 业务类型
          ,T1.TFR                            AS TFR  --12 投放日
          ,T1.DQR                            AS DQR  --13 到期日
          ,T1.WJFL                           AS WJFL  --14 五级分类
          ,T1.TJYE                           AS TJYE  --15 统计余额（元）
          ,T1.QZ_YJWBLDYE                    AS QZ_YJWBLDYE  --16 其中：已计为不良的余额
          ,DECODE(T1.SFSSGPZY,'Y','是','否') AS SFSSGPZY  --17 是否上市股票质押
          ,DECODE(T1.SFCNJY,'Y','是','否')   AS SFCNJY  --18 是否场内交易
          ,T1.GQCZQYMC                       AS GQCZQYMC  --19 股权出质企业名称
          ,T1.GS                             AS GS  --20 股数（股）
          ,CASE WHEN T1.JJFS='01' THEN '元/股'
		        WHEN T1.JJFS='02' THEN '股数'

                ELSE
                    CASE WHEN T1.SFSSGPZY = 'Y'
                         THEN '元/股'
                         WHEN T1.SFSSGPZY = 'N'
                         THEN '股数'
                         ELSE '不适用'
                     END
            END                              AS JJFS  --21 计价方式
          ,T1.MGJZ                           AS MGJZ  --22 每股价值（元）
          ,T1.YPZXGZ                         AS YPZXGZ  --23 押品最新估值（元）
          ,DECODE(T1.SFCJYJX,'Y','是','否')  AS SFCJYJX  --24 是否触及预警线
          ,T1.YJXJG                          AS YJXJG  --25 预警线价格（元）
          ,T1.QZ_CJYJXDGPSL                  AS QZ_CJYJXDGPSL  --26 其中：触及预警线的股票数量
          ,T1.QZ_CJYJXDYPYE                  AS QZ_CJYJXDYPYE  --27 其中：触及预警线的押品余额
          ,T1.QZ_CJYJXDYPDYDRZYE             AS QZ_CJYJXDYPDYDRZYE  --28 其中：触及预警线的押品对应的融资余额
          ,DECODE(T1.SFCJPCX,'Y','是','否')  AS SFCJPCX  --29 是否触及平仓线
          ,T1.PCXJG                          AS PCXJG  --30 平仓线价格（元）
          ,T1.QZ_CJPCXDYPYE                  AS QZ_CJPCXDYPYE  --31 其中：触及平仓线的押品余额
          ,T1.QZ_CJPCXDGPSL                  AS QZ_CJPCXDGPSL  --32 其中：触及平仓线的股票数量
          ,T1.QZ_CJPCXDYPDYDRZYE             AS QZ_CJPCXDYPDYDRZYE  --33 其中：触及平仓线的押品对应的融资余额
          ,NVL(T1.GQYPYE,T1.GS * T1.MGJZ)    AS GQYPYE  --34 股权押品余额（元）
          ,T1.GPSZNFFGBX                     AS GPSZNFFGBX  --35 股票市值能否覆盖本息
          ,CASE WHEN T1.DBFSZB IS NOT NULL
                   THEN T1.DBFSZB
                    ELSE
                     CASE WHEN NVL(NVL(T1.YPZXGZ,T3.BANK_IDNT_PRC_VAL),0)>0
                       THEN
                         NVL(T1.GQYPYE,T1.GS * T1.MGJZ)/NVL(T1.YPZXGZ,T3.BANK_IDNT_PRC_VAL) *100
                                           --MDF BY XUFEI 20220826 业务按照百分比数值录入，兜底需要统一
                        ELSE 0
                       END
               END                           AS DBFSZB  --36 上市股票担保程度
          ,T1.BGQNLJPCDRZJE                  AS BGQNLJPCDRZJE  --37 报告期内累计平仓的融资金额(元)
          ,T1.HKSJ                           AS HKSJ  --38 还款时间
          ,T1.PCYPJE                         AS PCYPJE  --39 平仓押品金额（元）
          ,T1.PCSJ                           AS PCSJ  --40 平仓时间
          ,DECODE(T1.SFZBGQNPCGP,'Y','是','否')
                                             AS SFZBGQNPCGP  --41 是否在报告期内平仓股票
          ,T1.MGPCPJJG                       AS MGPCPJJG  --42 每股平仓平均价格(元)
          ,T1.SYS_SOURCE                     AS SJLY      --43 数据来源
    FROM (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM,YPWYM ORDER BY JYWYM,YPWYM ) AS RN
            FROM RRP_MDL.S_STOCK_PLEDGE T
           WHERE T.DATA_DATE = V_P_DATE
         ) T1--补录表-对公-股权质押模型-G16
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T2 --机构表
      ON T2.ORG_ID = T1.ACCT_ORG_NUM
     AND T2.DATA_DT = T1.DATA_DATE
    LEFT JOIN RRP_MDL.M_GUA_COLL_INFO T3 --抵质押物详细信息
	    ON T3.COLL_ID = T1.YPWYM
	   AND T3.DATA_DT= V_P_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C1 --贷款产品信息表
      ON C1.PROD_ID = T1.YWLX
     AND C1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP M1
      ON M1.SRC_VALUE_CODE  = T1.YPLB
     AND M1.SRC_CLASS_CODE = 'T0008'  --押品类型
     AND M1.MOD_FLG = 'EAST'
   WHERE T1.DATA_DATE = V_P_DATE
     AND T1.RN = 1 ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,YPWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_G16 T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM,YPWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_A_FGB_G16;
/

