CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_ASSET_LEDGET(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_ASSET_LEDGET
  *  功能描述：不良资产处置台账
  *  创建日期：20230227
  *  开发人员：周一威
  *  来源表：   RRP_MDL.M_ASSET_PRESERVATION_LEDGET A -- 资产保全台账信息表
                RRP_MDL.M_CRDT_BUS_CONT_RISK_ADJ_H B -- 信贷业务合同风险调整历史
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(40) := 'ETL_S_ASSET_LEDGET'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_ASSET_LEDGET'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

   /*增加表分区及重跑逻辑,在插入目标报表数据逻辑之前添加这段逻辑*/
   V_STEP := 1;
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
   V_STEP_DESC := '不良资产处置台账-非重组部分';
   V_STARTTIME := SYSDATE;
   INSERT INTO S_ASSET_LEDGET
    (
     DATA_SRC      -- 1.数据来源
    ,DATA_DT       -- 2.数据日期
    ,SERIALNO      -- 3.不良处置现金流唯一码
    ,DUEBILLID     -- 4.借据号
    ,ASSETTYPE     -- 5.资产类型
    ,HANDLETIME    -- 6.处置（含重组）时间
    ,HANDLETYPE    -- 7.不良处置化解方式
    ,HANDLEBALANCE -- 8.处置金额
    ,ACC_ID        -- 9.账户唯一码
    ,CUSTOMERID    -- 10.客户编号
    ,CUSTOMERNAME  -- 11.客户名称
    ,RECOVERBALANCE   -- 12.不良处置收回其他金额（元）
    ,CUSTOMERTYPE  -- 13.客户类型
    ,ORG_ID        -- 14.机构号
    )
    SELECT NULL                AS DATA_SRC     -- 1.数据来源
          ,V_P_DATE            AS DATA_DT      -- 2.报告日期
          ,A.SERIALNO          AS SERIALNO     -- 3.不良处置现金流唯一码
          ,A.DUEBILLID         AS DUEBILLID    -- 4.借据号
          ,A.ASSETTYPE         AS ASSETTYPE    -- 5.资产类型
          ,A.HANDLETIME        AS HANDLETIME   -- 6.处置（含重组）时间
          ,CASE WHEN A.HANDLETYPE IN ('现金收回', '直接催收', '司法清收', '第三方代偿') THEN '不良非转让收现'
                WHEN A.HANDLETYPE IN ('债务重组', '借新还旧', '展期') THEN '重组' --MOD BY LIUYU 直接接入重组
                WHEN A.HANDLETYPE IN ('全额核销','呆账核销') THEN '非转让核销'
                WHEN A.HANDLETYPE = '差额核销' THEN
                CASE WHEN A.CUSTOMERTYPE IN ('公司客户','对公') THEN
                     CASE WHEN A.TYPEASSETTRANSFER = '单户转让' THEN '对公单户转让损失核销'
                          WHEN A.TYPEASSETTRANSFER = '批量转让' THEN '对公批量转让损失核销'
                     END
                     WHEN A.CUSTOMERTYPE = '个人客户' THEN
                     CASE WHEN A.TYPEASSETTRANSFER = '单户转让' THEN '个贷单户转让损失核销'
                          WHEN A.TYPEASSETTRANSFER = '批量转让' THEN '个贷批量转让损失核销'
                     END
                END
                WHEN A.HANDLETYPE = '资产转让' THEN
                CASE WHEN A.CUSTOMERTYPE IN ('公司客户','对公') THEN
                     CASE WHEN A.TYPEASSETTRANSFER = '单户转让' THEN '对公单户转让收现'
                          WHEN A.TYPEASSETTRANSFER = '批量转让' THEN '对公批量转让收现'
                     END
                     WHEN A.CUSTOMERTYPE = '个人客户' THEN
                     CASE WHEN A.TYPEASSETTRANSFER = '单户转让' THEN '个贷单户转让收现'
                          WHEN A.TYPEASSETTRANSFER = '批量转让' THEN '个贷批量转让收现'
                     END
                END
                WHEN A.HANDLETYPE = '以物抵债' THEN '以物抵债不含债转股'
                WHEN A.HANDLETYPE = '债转股' THEN '以股抵债'
                WHEN A.HANDLETYPE = '资产证券化' THEN '其他处置'
                ELSE '其他处置'
           END                 AS HANDLETYPE    -- 7.不良处置化解方式
          ,A.HANDLEBALANCE     AS HANDLEBALANCE -- 8.处置金额
          ,NULL                AS ACC_ID        -- 9.账户唯一码
          ,A.CUSTOMERID        AS CUSTOMERID    -- 10.客户编号
          ,A.CUSTOMERNAME      AS CUSTOMERNAME  -- 11.客户名称
          ,NULL                AS RECOVERBALANCE-- 12.不良处置收回其他金额（元）
          ,CUSTOMERTYPE        AS CUSTOMERTYPE  -- 13.客户类型
          ,SUBSTR(BRANCHBUSINESSDIVISION,1,3)||'001'
                               AS ORG_ID -- 14.机构号
      FROM RRP_MDL.M_ASSET_PRESERVATION_LEDGET A -- 资产保全台账信息表
     WHERE A.DATA_DT = V_P_DATE
       AND A.ASSETTYPE IN ('不良贷款','不良资产（非信贷）','不良资产(非信贷)')
       ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --插入过程跑批完成记录表
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

  END ETL_S_ASSET_LEDGET;
/

