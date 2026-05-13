CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_G5305
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
/**************************************************************************
  *  程序名称：ETL_A_FGB_G5305
  *  功能描述：对公-融资担保机构代偿模型（G5305）
  *  创建日期：20221107
  *  开发人员：WYX
  *  来源表：
  *  目标表：A_FGB_G5305           --对公-融资担保机构代偿模型（G5305）
  *  配置表：M_ZFXRZDBJGMD         --GD04_13政府性融资担保机构名单
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   WYX      首次创建
  *   2    20240620   YJY      新增是否反担保措施标志、是否符合S6301融资担保字段
***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_G5305';   --程序名称
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
  V_TAB_NAME := 'A_FGB_G5305'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

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

  ETL_PARTITION_ADD(I_P_DATE, 'A_FGB_G5305', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '对公-融资担保机构代偿模型（G5305）';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO A_FGB_G5305 NOLOGGING
    (
       BGRQ        --1 报告日期
      ,JGBH        --2 机构号
      ,JGMC        --3 机构名称
      ,JGSZSJXZQ   --4 机构所在省级行政区
      ,ZHWYM       --5 账户唯一码
      ,JYWYM       --6 交易唯一码
      ,KHWYM       --7 客户唯一码
      ,KHMC        --8 客户名称
      ,TJXWQYLB    --9 统计小微企业类别
      ,SFPHXWQY    --10 是否普惠小微企业
      ,SXED        --11 授信额度
      ,FKRQ        --12 放款日期
      ,FKJE        --13 放款金额
      ,TJYE        --14 统计余额（元）
      ,DKDQRQ      --15 贷款到期日期
      ,BGRDKYQTS   --16 报告日贷款逾期天数
      ,TJYQTS      --17 统计逾期天数（天）
      ,TJYQBJJE    --18 统计逾期本金金额（元）
      ,WJFL        --19 五级分类
      ,DBJGBH      --20 担保机构编号
      ,DBJGMC      --21 担保机构名称
      ,DBFS        --22 担保方式
      ,SFRZDBGSBZ  --23 是否融资担保公司保证
      ,ZFXRZDBJGBJ      --24 政府性融资担保机构标记
      ,SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
      ,SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
      ,BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
      ,BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
      ,SFSC             --29 是否删除
      ,BZ               --30 备注
      ,JYXKZBH          --31 经营许可证编号
      ,SFFDBCS          --32 是否反担保措施标志        --ADD IN 20240620
      ,S6301DBFS        --33 是否符合S6301融资担保     --ADD IN 20240620
    )
SELECT
       V_P_DATE                   AS BGRQ        --1 报告日期
      ,T1.ACCT_ORG_NUM            AS JGBH        --2 机构号
      ,T1.ZWJGMC                  AS JGMC        --3 机构名称
      ,CASE WHEN T1.JGSZSJXZQ = '440000' THEN  '广东省'
            ELSE T1.JGSZSJXZQ
       END                        AS JGSZSJXZQ   --4 机构所在省级行政区
      ,T1.ZHWYM                   AS ZHWYM       --5 账户唯一码
      ,T1.JYWYM                   AS JYWYM       --6 交易唯一码
      ,T1.KHWYM                   AS KHWYM       --7 客户唯一码
      ,T1.KHMC                    AS KHMC        --8 客户名称
      ,DECODE(T1.TJXWQYLB,'01','大型企业'
                         ,'02','中型企业'
                         ,'03','小型企业'
                         ,'04','微型企业'
                         ,'其他法人客户')              AS TJXWQYLB    --9 统计小微企业类别   --MOD IN 20240620
      ,DECODE(T1.SFPHXWQY,'Y','是','否')               AS SFPHXWQY    --10 是否普惠小微企业
      ,T1.SXED                                         AS SXED        --11 授信额度
      ,T1.FKRQ                                         AS FKRQ        --12 放款日期
      ,T1.FKJE                                         AS FKJE        --13 放款金额
      ,T1.TJYE                                         AS TJYE        --14 统计余额（元）
      ,T1.DKDQRQ                                       AS DKDQRQ      --15 贷款到期日期
      ,T1.BGRDKYQTS                                    AS BGRDKYQTS   --16 报告日贷款逾期天数
      ,T1.TJYQTS                                       AS TJYQTS      --17 统计逾期天数（天）
      ,T1.TJYQBJJE                                     AS TJYQBJJE    --18 统计逾期本金金额（元）
      ,T1.WJFL                                         AS WJFL        --19 五级分类
      ,T1.DBJGBH                                       AS DBJGBH      --20 担保机构编号
      ,T1.DBJGMC                                       AS DBJGMC      --21 担保机构名称
      ,T1.DBFS                                         AS DBFS        --22 担保方式        -- MOD IN 20240620
      ,DECODE(T1.SFRZDBGSBZ,'Y','是','否')             AS SFRZDBGSBZ  --23 是否融资担保公司保证
      ,T1.ZFXRZDBJGBJ                                  AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
       --严希婧确认直取补录数据
      ,DECODE(T1.SFZFXRZDBGSBZ,'Y','是','否')          AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
       --严希婧确认直取补录数据
      ,DECODE(T1.SFNHJXXNYJYZTDK,'Y','是','否')        AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
      ,NVL(T1.BNDLJSJHDDCJE,0)                         AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
      ,NVL(T1.BGRSWLXDCZRJE,0)                         AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
      ,DECODE(T1.SFSC,'Y','是','否')                   AS SFSC             --29 是否删除
      ,T1.BZ                                           AS BZ               --30 备注
      ,T1.JYXKZBH                                      AS JYXKZBH          --31 经营许可证编号
      ,DECODE(T1.SFFDBCS,'Y','是','否')                AS SFFDBCS          --32 是否反担保措施标志    --ADD IN 20240620
      ,DECODE(T1.S6301DBFS,'Y','是','否')              AS S6301DBFS        --33 是否符合S6301融资担保     --ADD IN 20240620
  FROM (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
          FROM M_ADD_DG_012_FINANCE_GUARAN T
         WHERE T.DATA_DATE = V_P_DATE ) T1 --补录表-对公-融资担保机构代偿模型-G5305
 WHERE T1.DATA_DATE = V_P_DATE
   AND T1.RN = 1
   AND NVL(T1.SFSC,'N') <> 'Y';
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
      FROM RRP_MDL.A_FGB_G5305 T
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

END ETL_A_FGB_G5305;
/

