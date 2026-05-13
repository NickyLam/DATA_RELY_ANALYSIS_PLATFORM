CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_FIVELEVEL_CLASS
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_FIVELEVEL_CLASS
  *  功能描述：
  *  创建日期：20230905
  *  开发人员：潘金成
  *  来源表：
  *  目标表：A_PHB_FIVELEVEL_CLASS --五级分类变动台帐
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人          修改原因
  *   1    20230905   panjincheng      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_FIVELEVEL_CLASS';
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
  V_TAB_NAME := 'A_PHB_FIVELEVEL_CLASS'; --表名,写目标表表名
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

  ETL_PARTITION_ADD(I_P_DATE, 'A_PHB_FIVELEVEL_CLASS', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入五级分类变动信息';
  V_STARTTIME := SYSDATE;

  INSERT INTO A_PHB_FIVELEVEL_CLASS
   (
     BGRQ,                     -- 1. 报告日期
     DATA_SRC                  -- 2. 数据来源
    ,JYWYM                     -- 3. 交易唯一码
    ,BZ                        -- 4. 币种
    ,HL                        -- 5. 汇率
    ,FKJEZB                    -- 6. 放款金额_折币（元）
    ,FHJEYBZ                   -- 7. 放款金额（原币种元）
    ,NCWJFL                    -- 8. 年初五级分类
    ,NCTJYEZB                  -- 9. 年初统计余额_折币（元）
    ,NCTJYEYBZ                 -- 10.年初统计余额（原币种元）
    ,WJFL                      -- 11.五级分类
    ,TJYEZB                    -- 12.统计余额_折币（元）
    ,TJYEYBZ                   -- 13.统计余额（原币种元）
    ,BGQJSJEZB                 -- 14.报告期减少金额（元）
    ,BGQJSJEYBZ                -- 15.报告期减少金额（原币种元）
    ,DNFKJSJEZB                -- 16.当年放款减少金额（元）
    ,DNFKJSJEYBZ               -- 17.当年放款减少金额（原币种元）
    ,CZBS                      -- 18.重组标识
    ,TJYWPZ                    -- 19.统计业务品种
    ,JGBH                      -- 20.机构编号
    ,BD_ORG_ID                 -- 21.变动账务机构
    ,BD_FLG                    -- 22.账务机构变动标志
   )
    SELECT V_P_DATE                  AS BGRQ -- 1.报告日期
          ,A.DATA_SRC                AS DATA_SRC -- 2.数据来源
          ,A.RCPT_ID                 AS JYWYM -- 3.交易唯一码
          ,A.CUR                     AS BZ -- 4.币种
          ,A.EXRT                    AS HL -- 5. 汇率
          ,A.LOAN_AMT_CNY            AS FKJEZB -- 6. 放款金额_折币（元）
          ,A.LOAN_AMT                AS FHJEYBZ -- 7. 放款金额（原币种元）
          ,A.BEGIN_YEAR_LVL5_CL      AS NCWJFL -- 8. 年初五级分类
          ,A.BEGIN_YEAR_LOAN_BAL_CNY AS NCTJYEZB -- 9. 年初统计余额_折币（元）
          ,A.BEGIN_YEAR_LOAN_BAL     AS NCTJYEYBZ -- 10.年初统计余额（原币种元）
          ,A.LVL5_CL                 AS WJFL -- 11.五级分类
          ,A.LOAN_BAL_CNY            AS TJYEZB -- 12.统计余额_折币（元）
          ,A.LOAN_BAL                AS TJYEYBZ -- 13.统计余额（原币种元）
          ,A.REDUCE_LOAN_BAL_CNY     AS BGQJSJEZB -- 14.报告期减少金额（元）
          ,A.REDUCE_LOAN_BAL         AS BGQJSJEYBZ -- 15.报告期减少金额（原币种元）
          ,A.REDUCE_LOAN_AMT_CNY     AS DNFKJSJEZB -- 16.当年放款减少金额（元）
          ,A.REDUCE_LOAN_AMT         AS DNFKJSJEYBZ -- 17.当年放款减少金额（原币种元）
          ,A.REC_ID                  AS CZBS -- 18.重组标识
          ,C1.PROD_NAME              AS TJYWPZ -- 19.统计业务品种
          ,A.ORG_ID                  AS JGBH   -- 20.机构编号
          ,A.BD_ORG_ID                 -- 21.变动账务机构
          ,A.BD_FLG                    -- 22.账务机构变动标志
      FROM RRP_MDL.S_FIVELEVEL_CLASS_CHANGE A --五级分类变动台账
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C1 --贷款产品信息表
        ON C1.PROD_ID = A.STD_PROD_ID
       AND C1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE A.DATA_DT = V_P_DATE
       AND A.DATA_SRC IN ( '零售贷款','联合网贷');
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
      FROM RRP_MDL.A_PHB_FIVELEVEL_CLASS T
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

  END ETL_A_PHB_FIVELEVEL_CLASS;
/

