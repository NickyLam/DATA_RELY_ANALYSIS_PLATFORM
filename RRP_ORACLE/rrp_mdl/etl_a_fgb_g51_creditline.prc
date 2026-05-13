CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_G51_CREDITLINE
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_G51_CREDITLINE
  *  功能描述：对公-国别-风险转移模型（G51）
  *  创建日期：20221227
  *  开发人员：孙满洋
  *  来源表：
  *  目标表：A_FGB_G51_CREDITLINE
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期    修改人         修改原因
  *   1    20221227   sunmanyang      首次创建
  ***************************************************************************/


 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_G51_CREDITLINE';
                                 -- 程序名称
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
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_FGB_G51_CREDITLINE'; --表名,写目标表表名
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

--分区表处理
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO A_FGB_G51_CREDITLINE (
     BGRQ                          --  数据日期
    ,ZWJGBH                        --  账务机构编号
    ,JYWYM                         --  交易唯一码
    ,KHWYM                         --  客户唯一码
    ,KHMC                          --  客户名称
    ,ZWJGMC                        --  账务机构名称
    ,JYDSJYDGB                     --  交易对手经营地国别
    ,GBFXJYDSLB                    --  国别风险交易对手类别
    ,ZQZWGX                        --  债权债务关系
    ,SFZQZQ                        --  是否主权债权
    ,JWZQZQLB                      --  境外主权债权类别
    ,GBFXYWPZLB                    --  国别风险业务品种类别
    ,SJDQRQ                        --  实际到期日期
    ,GBFXZQZWSYQXQJ                --  国别风险债权债务剩余期限区间
    ,WJFL                          --  五级分类
    ,YQTSQJ                        --  逾期天数区间
    ,TJYE                          --  统计余额（元）
    ,YSYJLX                        --  应收应计利息（元）
    ,ZMJZ                          --  账面价值（元）
    ,DBJTJZZB                      --  单笔计提减值准备（元）
    ,SFWYJTGBFXBBZC                --  是否为应计提国别风险拨备资产
    ,YJTGBFXBBBL                   --  应计提国别风险拨备比率
    ,YJTGBFXBBJE                   --  已计提国别风险拨备金额（元）
    ,FXZYGB                        --  风险转移国别
    ,FXZRFLB                       --  风险转入方类别
    ,FXZYSXJE                      --  风险转移上限金额（元）
    ,FXZYJE                        --  风险转移金额（元）
    ,JWZWRGB                       --  境外债务人国别
    ,BLXHGB                        --  表列序号国别
    ,GBFXDJ                        --  国别风险等级
    ,GBFXDJDM                      -- 国别风险等级代码 -- ADD BY LIUYU 20220831
    ,SYS_SOURCE                    --  来源系统
    ,GBFXXE                        -- 国别风险限额（元）

  )
  SELECT
         V_P_DATE                                  AS BGRQ      -- 数据日期
        ,A.ACCT_ORG_NUM                            AS ZWJGBH    -- 账务机构编号
        ,A.JYWYM                                   AS JYWYM     --  交易唯一码
        ,A.KHWYM                                   AS KHWYM     --  客户唯一码
        ,A.KHMC                                    AS KHMC      --  客户名称
        --,JBJGMC  --  经办机构名称
        ,A.ZWJGMC                                  AS ZWJGMC    --  账务机构名称
        ,CASE WHEN M1.SRC_VALUE_NAME LIKE '%香港%' THEN '中国香港'
              WHEN M1.SRC_VALUE_NAME LIKE '%澳门%' THEN '中国澳门'
              WHEN M1.SRC_VALUE_NAME LIKE '%台湾%' THEN '中国台湾'
              ELSE M1.SRC_VALUE_NAME
         END                                       AS JYDSJYDGB   --  交易对手经营地国别
        ,M2.SRC_VALUE_NAME                         AS GBFXJYDSLB  --  国别风险交易对手类别
        ,DECODE(A.ZQZWGX,'01','债权','02','债务')  AS ZQZWGX      --  债权债务关系
        ,DECODE(A.SFZQZQ,'Y','是','否')            AS SFZQZQ      --  是否主权债权
        ,CASE WHEN A.JWZQZQLB='01'  THEN '主权贷款'
              WHEN A.JWZQZQLB='02'  THEN '主权主体提供担保的贷款'
              WHEN A.JWZQZQLB='03'  THEN '主权债券'
              WHEN A.JWZQZQLB='04'  THEN '其他主权债权'
              ELSE '不适用'
         END                                       AS JWZQZQLB    --  境外主权债权类别
        ,CASE WHEN  A.GBFXYWPZLB='01' THEN '境外贷款（含银团贷款）'
              WHEN  A.GBFXYWPZLB='02' THEN '存放同业'
              WHEN  A.GBFXYWPZLB='03' THEN '拆放同业'
              WHEN  A.GBFXYWPZLB='04' THEN '买入返售'
              WHEN  A.GBFXYWPZLB='05' THEN '存放中央银行'
              WHEN  A.GBFXYWPZLB='06' THEN '境外有价证券和基金投资'
              WHEN  A.GBFXYWPZLB='07' THEN '境外金融衍生品'
              WHEN  A.GBFXYWPZLB='08' THEN '对非并表境外机构的投资'
              WHEN  A.GBFXYWPZLB='09' THEN '存款'
              WHEN  A.GBFXYWPZLB='10' THEN '同业融入'
              WHEN  A.GBFXYWPZLB='11' THEN '应付债券'
              WHEN  A.GBFXYWPZLB='12' THEN '衍生金融负债'
              WHEN  A.GBFXYWPZLB='13' THEN '其他'
              WHEN  A.GBFXYWPZLB='14' THEN '未提取承诺'
              WHEN  A.GBFXYWPZLB='15' THEN '非融资性保函'
              WHEN  A.GBFXYWPZLB='16' THEN '融资性保函'
              WHEN  A.GBFXYWPZLB='17' THEN '其他担保'
         END                                  	   AS GBFXYWPZLB  --  国别风险业务品种类别
        ,A.SJDQRQ                                  AS SJDQRQ      --  实际到期日期
        ,CASE WHEN A.SJDQRQ = '不适用' THEN '无固定期限'
              WHEN MONTHS_BETWEEN(TO_DATE(A.SJDQRQ, 'YYYY/MM/DD'),TO_DATE(V_P_DATE, 'YYYY/MM/DD'))<=12 THEN '1年以下（含）'
              WHEN MONTHS_BETWEEN(TO_DATE(A.SJDQRQ, 'YYYY/MM/DD'),TO_DATE(V_P_DATE, 'YYYY/MM/DD'))<=24 THEN '1-2年（含）'
              WHEN MONTHS_BETWEEN(TO_DATE(A.SJDQRQ, 'YYYY/MM/DD'),TO_DATE(V_P_DATE, 'YYYY/MM/DD')) >24 THEN '2年以上'
              ELSE '无固定期限'
         END                                       AS GBFXZQZWSYQXQJ  --  国别风险债权债务剩余期限区间
        ,M6.SRC_VALUE_NAME                               AS WJFL            --  五级分类
        ,CASE WHEN  A.GBFXYWPZLB='01' THEN '未逾期'
              WHEN  A.GBFXYWPZLB='02' THEN '逾期30天以内'
              WHEN  A.GBFXYWPZLB='03' THEN '逾期31天到60天'
              WHEN  A.GBFXYWPZLB='04' THEN '逾期61天到90天'
              WHEN  A.GBFXYWPZLB='05' THEN '逾期91天到180天'
              WHEN  A.GBFXYWPZLB='06' THEN '逾期181天到270天'
              WHEN  A.GBFXYWPZLB='07' THEN '逾期271天到360天'
              WHEN  A.GBFXYWPZLB='08' THEN '逾期361天以上'
         END                                       AS YQTSQJ          --  逾期天数区间
        ,A.TJYE                                    AS TJYE            --  统计余额（元）
        ,A.YSYJLX                                  AS YSYJLX          --  应收应计利息（元）
        ,NVL(A.TJYE,0) + NVL(A.YSYJLX,0)           AS ZMJZ            --  账面价值（元） =统计余额（元）+应收应计利息（元）
        ,A.DBJTJZZB                                AS DBJTJZZB        --  单笔计提减值准备（元）
        ,DECODE(A.SFWYJTGBFXBBZC,'Y','是','否')    AS SFWYJTGBFXBBZC  --  是否为应计提国别风险拨备资产
        ,''                                        AS YJTGBFXBBBL     --  应计提国别风险拨备比率
        ,A.YJTGBFXBBJE                             AS YJTGBFXBBJE     --  已计提国别风险拨备金额（元）
        ,M8.SRC_VALUE_NAME                         AS FXZYGB          --  风险转移国别
        ,CASE WHEN  A.FXZYGB='01' THEN '银行'
              WHEN  A.FXZYGB='02' THEN '公共部门'
              WHEN  A.FXZYGB='03' THEN '非银行金融机构'
              WHEN  A.FXZYGB='04' THEN '非金融机构'
              WHEN  A.FXZYGB='05' THEN '个人'
              WHEN  A.FXZYGB='06' THEN '其他'
         END                                       AS FXZRFLB         --  风险转入方类别
        ,A.FXZYSXJE                                AS FXZYSXJE        --  风险转移上限金额（元）
        ,A.FXZYJE                                  AS FXZYJE          --  风险转移金额（元）
        ,M10.SRC_VALUE_NAME                        AS JWZWRGB         --  境外债务人国别
        ,''                                        AS BLXHGB          --  表列序号国别
        ,CASE WHEN  A.GBFXDJ ='01' THEN '低'
              WHEN  A.GBFXDJ='02' THEN '较低'
              WHEN  A.GBFXDJ='03' THEN '中'
              WHEN  A.GBFXDJ='04' THEN '较高'
              WHEN  A.GBFXDJ='05' THEN '高'
          END                                      AS GBFXDJ          --  国别风险等级
        ,''                                         AS GBFXDJDM        -- 国别风险等级代码 -- ADD BY LIUYU 20220831
        ,A.SYS_SOURCE                              AS SYS_SOURCE      --  来源系统
        ,''                                        AS GBFXXE          -- 国别风险限额（元）
         /*取计财填报后数据【6.A】=G40_【3.A】为资本金额，风险限额= 资本金额*25%*/
    FROM (SELECT T.*,
                 ROW_NUMBER() OVER(PARTITION BY JYWYM ORDER BY JYWYM) AS RN
            FROM M_ADD_DG_014_NATION_CREDIT T
           WHERE T.DATA_DATE = V_P_DATE) A
    LEFT JOIN CODE_MAP M1 -- 国家代码
      ON A.JYDSJYDGB = M1.TAR_VALUE_CODE
     AND M1.TAR_CLASS_CODE = 'P0001'
     AND M1.SRC_CLASS_CODE = 'P0001'
     AND M1.MOD_FLG = 'EAST'
    LEFT JOIN CODE_MAP M2
      ON A.GBFXJYDSLB = M2.TAR_VALUE_CODE
     AND M2.TAR_CLASS_CODE = 'C0060' -- 国别风险交易对手类别
     AND M2.SRC_CLASS_CODE = 'C0060'
      --AND M1.MOD_FLG='EAST'
      /*LEFT JOIN CODE_MAP M3             -- 境外债权或债务
         ON A.ZQZWGX = M3.CODE
        AND M1.TAR_CLASS_CODE = 'P0001'
      AND M1.SRC_CLASS_CODE='P0001'
      AND M1.MOD_FLG='EAST'
       LEFT JOIN CODE_MAP M4             -- 境外主权债权类别
         ON A.JWZQZQLB = M4.CODE
        AND M4.CODE_TABLE_CODE = 'A0099'
       LEFT JOIN CODE_MAP M5             -- 国别风险业务品种类别
         ON A.GBFXYWPZLB = M5.CODE
        AND M5.CODE_TABLE_CODE = 'D0005'*/
    LEFT JOIN CODE_MAP M6 -- 五级分类
      ON '0' || A.WJFL = M6.TAR_VALUE_CODE
     AND M6.TAR_CLASS_CODE = 'D0005'
     AND M6.SRC_CLASS_CODE = 'D0005'
     AND M6.MOD_FLG = 'EAST'
      /*LEFT JOIN CODE_MAP M7             -- 逾期天数区间
       ON A.YQTSQJ = M7.CODE
      AND M7.CODE_TABLE_CODE = 'A0036'*/
    LEFT JOIN CODE_MAP M8 -- 国家代码
      ON A.FXZYGB = M8.TAR_VALUE_CODE
     AND M8.TAR_CLASS_CODE = 'P0001'
     AND M8.SRC_CLASS_CODE = 'P0001'
     AND M8.MOD_FLG = 'EAST'
    LEFT JOIN CODE_MAP M10 -- 国家代码
      ON A.JWZWRGB = M10.TAR_VALUE_CODE
     AND M10.TAR_CLASS_CODE = 'P0001'
     AND M10.SRC_CLASS_CODE = 'P0001'
     AND M10.MOD_FLG = 'EAST'
      /*LEFT JOIN CODE_MAP M11
        ON A.BLXHGB = M11.CODE
       AND M11.CODE_TABLE_CODE = 'A0019' -- 国家代码
      LEFT JOIN CODE_MAP M12
        ON A.GBFXDJ = M12.CODE
       AND M12.CODE_TABLE_CODE = 'A0098' -- 国别风险等级*/
   WHERE A.DATA_DATE = V_P_DATE
     AND A.RN = 1
  ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_G51_CREDITLINE T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM
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

  END ETL_A_FGB_G51_CREDITLINE;
/

