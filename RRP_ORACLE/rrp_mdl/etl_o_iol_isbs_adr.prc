CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_ADR(I_P_DATE IN INTEGER,
                                                 O_ERRCODE OUT VARCHAR2
                                                 )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ISBS_ADR
  *  功能描述：存放所有Party的地址信息
  *  创建日期：20251106
  *  开发人员：YJY
  *  来源表：
  *  目标表： O_IOL_ISBS_ADR
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251106  YJY     首次创建
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_ISBS_ADR'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ISBS_ADR'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_ADR';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-存放所有Party的地址信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ISBS_ADR
    ( INR              --内部唯一ID号
     ,EXTKEY           --地址关键字
     ,NAM              --地址名称
     ,BIC              --通知行SWIFT代码
     ,BICAUT           --SWIFT连接标志
     ,BID              --支行权限
     ,BLZ              --德国的空代码
     ,CLC              --国家的空代码
     ,DPT              --机构
     ,EML              --邮件信箱
     ,FAX1             --电传1
     ,FAX2             --电传2
     ,NAM1             --名称1
     ,NAM2             --名称2
     ,NAM3             --名称3
     ,STR1             --街道1
     ,STR2             --街道2
     ,LOCZIP           --邮政编码
     ,LOCTXT           --城市名称
     ,LOC2             --城市区域
     ,LOCCTY           --住址
     ,CORTYP           --通信方式
     ,POB              --邮箱号码
     ,POBZIP           --邮政编码
     ,POBTXT           --国家名称
     ,TEL1             --电话1
     ,TEL2             --电话2
     ,TID              --收单行机构代码
     ,TLX              --电报号码
     ,TLXAUT           --电报权限修改
     ,UIL              --默认语种
     ,VER              --版本号
     ,MANMOD           --手动更改标志
     ,RTGFLG           --RTGS标志
     ,TARFLG           --TARGET标志
     ,DTACID           --DTA messages的客户地址
     ,DTECID           --DTE messages的客户地址
     ,ETGEXTKEY        --用户组别关键字
     ,ADR1             --地址1
     ,ADR2             --地址2
     ,ADR3             --地址3
     ,ADR4             --地址4
     ,NAMELC           --人行名称
     ,ADRELC           --人行地址
     ,START_DT         --开始时间
     ,END_DT           --结束时间
     ,ID_MARK          --增删标志
     ,ETL_TIMESTAMP    --ETL处理时间戳
    )
  SELECT 
      INR              --内部唯一ID号
     ,EXTKEY           --地址关键字
     ,NAM              --地址名称
     ,BIC              --通知行SWIFT代码
     ,BICAUT           --SWIFT连接标志
     ,BID              --支行权限
     ,BLZ              --德国的空代码
     ,CLC              --国家的空代码
     ,DPT              --机构
     ,EML              --邮件信箱
     ,FAX1             --电传1
     ,FAX2             --电传2
     ,NAM1             --名称1
     ,NAM2             --名称2
     ,NAM3             --名称3
     ,STR1             --街道1
     ,STR2             --街道2
     ,LOCZIP           --邮政编码
     ,LOCTXT           --城市名称
     ,LOC2             --城市区域
     ,LOCCTY           --住址
     ,CORTYP           --通信方式
     ,POB              --邮箱号码
     ,POBZIP           --邮政编码
     ,POBTXT           --国家名称
     ,TEL1             --电话1
     ,TEL2             --电话2
     ,TID              --收单行机构代码
     ,TLX              --电报号码
     ,TLXAUT           --电报权限修改
     ,UIL              --默认语种
     ,VER              --版本号
     ,MANMOD           --手动更改标志
     ,RTGFLG           --RTGS标志
     ,TARFLG           --TARGET标志
     ,DTACID           --DTA messages的客户地址
     ,DTECID           --DTE messages的客户地址
     ,ETGEXTKEY        --用户组别关键字
     ,ADR1             --地址1
     ,ADR2             --地址2
     ,ADR3             --地址3
     ,ADR4             --地址4
     ,NAMELC           --人行名称
     ,ADRELC           --人行地址
     ,START_DT         --开始时间
     ,END_DT           --结束时间
     ,ID_MARK          --增删标志
     ,ETL_TIMESTAMP    --ETL处理时间戳
    FROM IOL.V_ISBS_ADR --视图-存放所有Party的地址信息
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';  

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ISBS_ADR;
/

