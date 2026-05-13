CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_BCH(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：机构信息表
  **存储过程名称：    ETL_O_IOL_ISBS_BCH
  **存储过程创建日期：20251215
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251215    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_BCH'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_BCH';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-机构信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_BCH NOLOGGING 
  (        INR           --内部唯一ID
          ,ETYEXKEY      --实体关键字
          ,BRANCH        --机构编码
          ,BCHKEY        --经办机构编码
          ,BCHNAME       --机构名称
          ,LEV           --机构层次
          ,UPBRANCH      --上级机构编码
          ,BCHTYP        --机构类型
          ,BCHFLG        --机构参考号标志
          ,DECNUM        --金融机构编码
          ,TEL           --电话
          ,FAX           --传真
          ,ADR           --地址
          ,SWFCOD        --BIC码
          ,ADR2          --地址
          ,VER           --版本号
          ,NAMEN         --英文名称
          ,ADREN         --英文地址
          ,ADREN2        --英文地址
          ,YDJCOD        --外汇管理局印单局代码
          ,TID           --收单行系统机构代号
          ,UPBCHKEY      --替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
          ,ACCBCH        --核心机构号
          ,BCHREF        --该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
          ,BCHUSR        --核心虚拟柜员
          ,BCHLST        --包含的分支机构INR
          ,STA           --状态
          ,PTYINR        --与pty表inr对应
          ,STPFLG        --是否停用
          ,RMBRPT        --金融机构识别码
          ,START_DT      --开始时间
          ,END_DT        --结束时间
          ,ID_MARK       --增删标志
          ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT 
           INR           --内部唯一ID
          ,ETYEXKEY      --实体关键字
          ,BRANCH        --机构编码
          ,BCHKEY        --经办机构编码
          ,BCHNAME       --机构名称
          ,LEV           --机构层次
          ,UPBRANCH      --上级机构编码
          ,BCHTYP        --机构类型
          ,BCHFLG        --机构参考号标志
          ,DECNUM        --金融机构编码
          ,TEL           --电话
          ,FAX           --传真
          ,ADR           --地址
          ,SWFCOD        --BIC码
          ,ADR2          --地址
          ,VER           --版本号
          ,NAMEN         --英文名称
          ,ADREN         --英文地址
          ,ADREN2        --英文地址
          ,YDJCOD        --外汇管理局印单局代码
          ,TID           --收单行系统机构代号
          ,UPBCHKEY      --替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
          ,ACCBCH        --核心机构号
          ,BCHREF        --该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
          ,BCHUSR        --核心虚拟柜员
          ,BCHLST        --包含的分支机构INR
          ,STA           --状态
          ,PTYINR        --与pty表inr对应
          ,STPFLG        --是否停用
          ,RMBRPT        --金融机构识别码
          ,START_DT      --开始时间
          ,END_DT        --结束时间
          ,ID_MARK       --增删标志
          ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ISBS_BCH --视图-机构信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_BCH', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ISBS_BCH;
/

