CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_S7103(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_S7103
  *  功能描述：S7103普惠型消费贷款明细表
  *  创建日期：20230109
  *  开发人员：于敬艺
  *  来源表：   S_LOAN
  *  目标表：   S_LOAN_S7103
  *  配置表：
  *  修改情况：
     序号  修改日期  修改人   修改原因
*     1    20230109   于敬艺   新增
*     2    20230315   于敬艺   修改口径，根据刘娉婷确认，不再提供底稿数据。注释掉之前提供的初始值
      3    20230608   liuyu    按照口径变更邮件调整逻辑：S7103的农户不再取A3326精准扶贫表，农户就按照实际的标识来取，
                               897机构数据不报送，后续有其他新业务发生符合填报要求的需报送。
      4    20240924   luweibo  新增20231231放款的联合网贷数据，同时加工联合网贷数据的20231231放款日期+1
      5    20250321   lwb      因2025新制度调整取数的范围
      6    20250324   HYF      新增原建档立卡贫困户标志
  **********************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_S7103'; -- 程序名称
  V_TABLE_NAME VARCHAR2(30) := 'S_LOAN_S7103';
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  --V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'S_LOAN_S7103'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
/*  DELETE FROM S_LOAN_S7103 T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TABLE_NAME||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, V_TABLE_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_STEP := 3;
  V_STEP_DESC := 'S7103普惠型消费贷款明细表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO S_LOAN_S7103 NOLOGGING
  (
        DATA_DT                    ,        --数据日期
        ORG_NO                     ,        --机构号
        CUST_NO                    ,        --客户号
        RCPT_ID                    ,        --借据号
        CONT_ID                    ,        --合同编号
        RCPT_STAT                  ,        --借据状态
        CURR_CD                    ,        --币种
        ORG_TYPE                   ,        --机构类型
        LOAN_BIZ_TYP               ,        --贷款业务类型
        LOAN_ACT_DSTR_DT           ,        --贷款实际发放日期
        LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
        LVL5_CL                    ,        --五级分类
        LOAN_AMT                   ,        --放款金额
        LOAN_BAL                   ,        --贷款余额
        LOAN_NET_VAL               ,        --贷款净值
        STD_PROD_ID                ,        --标准产品编号
        LOAN_USEAGE                ,        --贷款用途
        INCOME_ANNUAL              ,        --年化收益
        SGL_CRDT_AMT               ,        --单户授信金额
        CON_CRDT_TOT_AMT           ,        --消费授信总额
        CBRC_FLG                   ,        --CBRC标志
        FARM_FLG                   ,        --当前最新农户标志
        DSBR_FARM_FLG              ,        --放款时农户标志
        SFYWCSMX                   ,        --是否业务提供初始明细
        FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
        YJDLKPKH                            --原建档立卡贫困户标志
  )

  SELECT /*+ PARALLEL(4)*/
        A.DATA_DT                    ,        --数据日期
        A.ORG_ID                     ,        --机构号
        A.CUST_ID                    ,        --客户号
        A.RCPT_ID                    ,        --借据号
        A.CONT_ID                    ,        --合同编号
        A.RCPT_STAT                  ,        --借据状态
        A.CUR                        ,        --币种
        '' ORG_TYPE                  ,        --机构类型
        A.LOAN_BIZ_TYP               ,        --贷款业务类型
        CASE WHEN A.DATA_SRC='联合网贷' 
          AND A.LOAN_ACT_DSTR_DT=TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD')
          THEN TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
             ELSE    A.LOAN_ACT_DSTR_DT END AS LOAN_ACT_DSTR_DT         ,        --贷款实际发放日期
        A.LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
        A.LVL5_CL                    ,        --五级分类
        A.LOAN_AMT                   ,        --放款金额
        A.LOAN_BAL                   ,        --贷款余额
        A.LOAN_NET_VAL               ,        --贷款净值
        A.STD_PROD_ID                ,        --标准产品编号
        A.LOAN_USEAGE                ,        --贷款用途
        A.INCOME_ANNUAL              ,        --年化收益
        A.SGL_CRDT_AMT               ,        --单户授信金额
        A.CON_CRDT_TOT_AMT           ,        --消费授信总额
        A.CBRC_FLG                   ,        --CBRC标志
        A.FARM_FLG                   ,        --当前最新农户标志
        A.FKSSNBZ                    ,        --放款时农户标志
        'N'  AS SFYWCSMX             ,        --是否业务提供初始明细
        C.FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
        A.YJDLKPKH                            --原建档立卡贫困户标志 ADD BY HYF 20250324   
    FROM RRP_MDL.S_LOAN A --贷款业务整合表
    LEFT JOIN RRP_MDL.S_LOAN_AMT_S71 C --S71普惠小微发放时授信额度表
      ON C.RCPT_ID = A.RCPT_ID
     AND C.DATA_DT = V_P_DATE
   WHERE A.DATA_DT = V_P_DATE
     AND A.LOAN_DIR_BIO_FLG = 'Y'
     AND A.CBRC_FLG = 'Y' --CBRC标志  Y-银保监会
     AND A.DATA_SRC IN ('零售贷款', '联合网贷')
     AND A.LOAN_BIZ_TYP NOT LIKE '0102%' --个人只取消费性贷款
     AND A.LOAN_BIZ_TYP NOT IN ('010101', '010201', '010301')
         --010101个人住房按揭商业贷款  010201 商业用房贷款 010301 个人汽车贷款
     AND (A.LOAN_USEAGE NOT LIKE '%购车%' OR TRIM(A.LOAN_USEAGE) IS NULL) --贷款用途不为购车、用途为空的取入
     AND A.STD_PROD_ID NOT IN ('201030200004' --个人赎楼贷款（按揭）
                            ,'201010300003' --个人赎楼贷款
                            ,'201010300039' --个人赎楼贷款（消费）
                            ,'201020100049' --个人赎楼贷款（经营）
                            ,'201010100002' --兴车贷
                            )
     AND A.ORG_ID NOT LIKE '897%'
     AND ((SUBSTR(A.LOAN_ACT_DSTR_DT,1,4) = SUBSTR( V_P_DATE,1,4) /*AND C.FF_CON_CRDT_TOT_AMT <= 100000*/ )
       OR (A.LOAN_NET_VAL <> 0  /*AND A.CON_CRDT_TOT_AMT <= 100000*/ )
       OR (A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT =TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD')
          /*AND C.FF_CON_CRDT_TOT_AMT <= 100000*/)--MODIFY BY LWB 20240924
          );

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;



  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'S7103普惠型消费贷款明细表--查询数据是否重复';
  V_STARTTIME := SYSDATE;

    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.S_LOAN_S7103 T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
    -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GREEN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   V_STEP := V_STEP + 1;
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

  END ETL_S_LOAN_S7103;
/

