CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_WRITE_OFF_LEDGER(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  ETL_S_WRITE_OFF_LEDGER
  *  功能描述：核销台账
  *  创建日期：20230227
  *  开发人员：周一威
  *  来源表：   RRP_MDL.M_ASSET_PRESERVATION_LEDGET A -- 资产保全台账信息表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(40) := 'ETL_S_WRITE_OFF_LEDGER'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ; --表名
  --V_PART_NAME VARCHAR2(100); --分区名

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_WRITE_OFF_LEDGER'; --表名,写目标表表名
  --V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  /*增加表分区及重跑逻辑,在插入目标报表数据逻辑之前添加这段逻辑*/
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
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '核销台账';
  V_STARTTIME := SYSDATE;

  INSERT INTO S_WRITE_OFF_LEDGER
    (DATA_SRC           -- 1.数据来源
    ,DATA_DT            -- 2.数据日期
    ,SERIALNO           -- 3.核销现金流唯一码
    ,DUEBILLID          -- 4.交易唯一码
    ,HANDLETIME         -- 5.核销日期
    ,IS_THIS_YEAR       -- 6.是否本年核销
    ,HANDLEBALANCE      -- 7.本年原始核销金额（元）
    ,CASHOFFDATE        -- 8.核销/抵债后收现日期（元）
    ,RECOVEROFFBALANCE  -- 9.核销/抵债后收回金额（元）
    ,ACC_ID             -- 10.账户唯一码
    ,CUSTOMERID         -- 11.客户编号
    ,CUSTOMERNAME       -- 12.客户名称
    ,HANDLETYPE         -- 13.处置方式
    ,ORG_ID             -- 14.机构编号
     )
    SELECT NULL                        AS DATA_SRC          -- 1.数据来源
          ,V_P_DATE                    AS DATA_DT           -- 2.数据日期
          ,A.SERIALNO                  AS SERIALNO          -- 3.流水号
          ,A.DUEBILLID                 AS DUEBILLID         -- 4.借据号
          ,A.HANDLETIME                AS HANDLETIME        -- 5.处置（含重组）时间
          ,CASE WHEN TO_CHAR(A.HANDLETIME, 'YYYY') = SUBSTR(V_P_DATE, 1, 4) THEN  '是'
                ELSE '否'
           END                         AS IS_THIS_YEAR      -- 6.是否本年核销
          ,A.HANDLEBALANCE             AS HANDLEBALANCE     -- 7.处置金额
          ,A.CASHOFFDATE               AS CASHOFFDATE       -- 8.核销/抵债后收现日期（元）
          ,A.RECOVEROFFBALANCE         AS RECOVEROFFBALANCE -- 9.核销/抵债后收回金额（元）
          ,NULL                        AS ACC_ID            -- 10.账户唯一码
          ,A.CUSTOMERID                AS CUSTOMERID        -- 11.客户编号
          ,A.CUSTOMERNAME              AS CUSTOMERNAME      -- 12.客户名称
          ,A.HANDLETYPE                AS HANDLETYPE        -- 13.处置方式
          ,SUBSTR(A.BRANCHBUSINESSDIVISION,1,3)||'001'
                                       AS ORG_ID             --14.机构编号
      FROM RRP_MDL.M_ASSET_PRESERVATION_LEDGET A -- 资产保全台账信息表
     WHERE A.DATA_DT = V_P_DATE
       AND A.HANDLETYPE IN ('全额核销', '差额核销','呆账核销') -- 处置（含重组）方式 8全额核销，9差额核销
       AND A.ASSETTYPE IN ('不良贷款','不良资产（非信贷）')
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GREEN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
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

  END ETL_S_WRITE_OFF_LEDGER;
/

